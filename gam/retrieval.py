# retrieval.py
# -*- coding: utf-8 -*-
"""
Retrievers for ResearchAgent:
- RankBM25Retriever: 关键词检索（BM25）
- OpenAIVectorRetriever: 向量检索（OpenAI Embeddings -> 余弦相似）
- page_id_lookup: 按 page_id 精确命中

用法（示例）：
    from agents import ResearchAgent, InMemoryPageStore
    from retrieval import create_retrievers_with_rankbm25, page_id_lookup

    page_store = InMemoryPageStore()
    # ... 用 MemoryAgent.memorize 写入一些 Page 后
    retrievers = create_retrievers_with_rankbm25(
        page_store,
        use_vector=True,
        openai_api_key="sk-***",
        base_url="https://api.openai.com",
        embedding_model="text-embedding-3-small",
    )
    agent = ResearchAgent(page_store=page_store, retrievers=retrievers, ...)
"""

from __future__ import annotations

from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional, Tuple
import math
import heapq
import re

# 依赖 agents.py 中的数据模型/协议
from agents import Page, Hit, Retriever, PageStore  # type: ignore

# =============================
# Tokenization（英文字/数字按词，中文按单字；简单好用）
# =============================
_TOKEN_RE = re.compile(r"[A-Za-z0-9]+|[\u4e00-\u9fff]", re.UNICODE)
def _tok(text: str) -> List[str]:
    if not text:
        return []
    return [m.group(0).lower() for m in _TOKEN_RE.finditer(text)]

# =============================
# 关键词检索：Rank-BM25
# =============================
# pip install rank-bm25
try:
    from rank_bm25 import BM25Okapi  # type: ignore
except Exception as _e:
    BM25Okapi = None  # type: ignore

@dataclass
class RankBM25Retriever(Retriever):
    """基于 rank-bm25 的关键词检索（BM25Okapi）。"""
    name: str = "keyword"
    _pages: List[Page] = field(default_factory=list, init=False)
    _bm25: Optional[Any] = field(default=None, init=False)
    _corpus_tokens: List[List[str]] = field(default_factory=list, init=False)

    def build(self, pages: List[Page]) -> None:
        if BM25Okapi is None:
            raise RuntimeError(
                "rank-bm25 is not installed. Please `pip install rank-bm25` to use RankBM25Retriever."
            )
        self._pages = pages[:]
        self._corpus_tokens = [_tok(f"{getattr(p,'header','')}\n{getattr(p,'content','')}") for p in self._pages]
        self._bm25 = BM25Okapi(self._corpus_tokens)

    def search(self, query: str, top_k: int = 10) -> List[Hit]:
        if not self._pages or not self._bm25:
            return []
        q = _tok(query)
        if not q:
            return []
        scores = self._bm25.get_scores(q)  # List[float], 与 _pages 对齐
        top = heapq.nlargest(min(top_k, len(scores)), enumerate(scores), key=lambda x: x[1])
        hits: List[Hit] = []
        for rank, (idx, score) in enumerate(top, 1):
            p = self._pages[idx]
            snippet = (getattr(p, "content", "") or getattr(p, "header", ""))[:200]
            hits.append(Hit(
                page_id=getattr(p, "page_id", None),
                snippet=snippet,
                source="keyword",
                meta={"rank": rank, "score": float(score), "index": idx}
            ))
        return hits

# =============================
# 向量检索：OpenAI Embeddings + 余弦相似
# =============================
def _l2_norm(v: List[float]) -> float:
    return math.sqrt(sum(x * x for x in v)) or 1e-9

def _normalize(v: List[float]) -> List[float]:
    n = _l2_norm(v)
    return [x / n for x in v]

@dataclass
class OpenAIVectorRetriever(Retriever):
    """基于 OpenAI Embeddings 的向量检索（余弦相似）。"""
    name: str = "vector"
    api_key: str = ""
    base_url: str = "https://api.openai.com"
    embedding_model: str = "text-embedding-3-small"
    timeout: float = 60.0

    _pages: List[Page] = field(default_factory=list, init=False)
    _doc_vecs: List[List[float]] = field(default_factory=list, init=False)

    def build(self, pages: List[Page]) -> None:
        self._pages = pages[:]
        self._doc_vecs.clear()
        if not self.api_key or not self._pages:
            return
        from openai import OpenAI  # 延迟导入，避免硬依赖影响不用向量的用户
        client = OpenAI(api_key=self.api_key, base_url=self.base_url.rstrip("/"))
        client = client.with_options(timeout=self.timeout) if hasattr(client, "with_options") else client
        texts = [f"{getattr(p,'header','')}\n{getattr(p,'content','')}".strip() or " " for p in self._pages]
        embs = client.embeddings.create(model=self.embedding_model, input=texts)
        self._doc_vecs = [_normalize(d.embedding) for d in embs.data]

    def search(self, query: str, top_k: int = 10) -> List[Hit]:
        if not self._doc_vecs or not self._pages or not self.api_key:
            return []
        from openai import OpenAI
        client = OpenAI(api_key=self.api_key, base_url=self.base_url.rstrip("/"))
        client = client.with_options(timeout=self.timeout) if hasattr(client, "with_options") else client
        qvec = client.embeddings.create(model=self.embedding_model, input=[query]).data[0].embedding
        qvec = _normalize(qvec)

        scored: List[Tuple[float, int]] = []
        for i, dvec in enumerate(self._doc_vecs):
            sim = sum(q * d for q, d in zip(qvec, dvec))  # 单位向量点积 ≈ 余弦
            scored.append((sim, i))

        top = heapq.nlargest(min(top_k, len(scored)), scored, key=lambda x: x[0])
        hits: List[Hit] = []
        for rank, (sim, idx) in enumerate(top, 1):
            p = self._pages[idx]
            snippet = (getattr(p, "content", "") or getattr(p, "header", ""))[:200]
            hits.append(Hit(
                page_id=getattr(p, "page_id", None),
                snippet=snippet,
                source="vector",
                meta={"rank": rank, "score": float(sim), "index": idx}
            ))
        return hits

# =============================
# page_id 精确命中（给 _search_by_page_id 用）
# =============================
def page_id_lookup(page_store: PageStore, page_id_list: List[str]) -> List[Hit]:
    """按给定 page_id 列表返回命中（顺序保持与输入一致）。"""
    hits: List[Hit] = []
    for pid in page_id_list:
        p = page_store.get(pid)
        if not p:
            continue
        snippet = (getattr(p, "content", "") or getattr(p, "header", ""))[:200]
        hits.append(Hit(
            page_id=getattr(p, "page_id", None),
            snippet=snippet,
            source="page_id",
            meta={}
        ))
    return hits

# =============================
# 小工厂：一键构建检索器字典给 ResearchAgent
# =============================
def create_retrievers_with_rankbm25(
    page_store: PageStore,
    use_vector: bool = False,
    openai_api_key: Optional[str] = None,
    base_url: str = "https://api.openai.com",
    embedding_model: str = "text-embedding-3-small",
) -> Dict[str, Retriever]:
    """
    返回 {"keyword": RankBM25Retriever, ("vector": OpenAIVectorRetriever?)}，
    并已对当前 pages 调用过一次 .build(...)。
    """
    pages = page_store.list_all()

    kw = RankBM25Retriever(); kw.build(pages)
    retrievers: Dict[str, Retriever] = {"keyword": kw}

    if use_vector:
        if not openai_api_key:
            raise ValueError("use_vector=True 需要提供 openai_api_key")
        vec = OpenAIVectorRetriever(
            api_key=openai_api_key, base_url=base_url, embedding_model=embedding_model
        )
        vec.build(pages)
        retrievers["vector"] = vec

    return retrievers
