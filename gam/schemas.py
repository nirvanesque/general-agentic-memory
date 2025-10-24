# schemas.py
# -*- coding: utf-8 -*-
"""
统一的数据模型定义
使用 Pydantic 实现一个定义，多种用途：
- Python 数据类
- JSON Schema 自动生成
- 数据验证
"""

from __future__ import annotations

from pydantic import BaseModel, Field
from typing import Any, Dict, List, Optional, Protocol

# =============================
# Core data models (Pydantic)
# =============================

class MemoryState(BaseModel):
    """Long-term memory: only abstracts list."""
    abstracts: List[str] = Field(default_factory=list, description="List of memory abstracts")

class Page(BaseModel):
    """Page data structure"""
    header: str = Field(..., description="Page header")
    content: str = Field(..., description="Page content")
    meta: Dict[str, Any] = Field(default_factory=dict, description="Metadata")

class MemoryUpdate(BaseModel):
    """Memory update result"""
    new_state: MemoryState = Field(..., description="Updated memory state")
    new_page: Page = Field(..., description="New page added")
    debug: Dict[str, Any] = Field(default_factory=dict, description="Debug information")

class SearchPlan(BaseModel):
    """Search planning structure"""
    info_needs: List[str] = Field(default_factory=list, description="List of information needs")
    tools: List[str] = Field(default_factory=list, description="Tools to use for searching")
    keyword_collection: List[str] = Field(default_factory=list, description="Keywords to search for")
    vector_queries: List[str] = Field(default_factory=list, description="Semantic search queries")
    page_indices: List[int] = Field(default_factory=list, description="Specific page indices to retrieve")

class ToolResult(BaseModel):
    """Tool execution result"""
    tool: str = Field(..., description="Tool name")
    inputs: Dict[str, Any] = Field(..., description="Input parameters")
    outputs: Any = Field(..., description="Output results")
    error: Optional[str] = Field(None, description="Error message if any")

class Hit(BaseModel):
    """Search result hit"""
    page_index: Optional[int] = Field(None, description="Page index in store")
    snippet: str = Field(..., description="Text snippet from the source")
    source: str = Field(..., description="Source type (keyword/vector/page_index/tool)")
    meta: Dict[str, Any] = Field(default_factory=dict, description="Additional metadata")

class SourceInfo(BaseModel):
    """Source information"""
    page_index: Optional[int] = Field(None, description="Page index in store")
    snippet: str = Field(..., description="Text snippet from the source")
    source: str = Field(..., description="Source type")

class Result(BaseModel):
    """Search and integration result"""
    content: str = Field("", description="Integrated content about the question")
    sources: List[SourceInfo] = Field(default_factory=list, description="List of sources used")

class ReflectionDecision(BaseModel):
    """Reflection decision"""
    enough: bool = Field(..., description="Whether information is sufficient")
    new_request: Optional[str] = Field(None, description="New request if information is insufficient")

class ResearchOutput(BaseModel):
    """Research output"""
    integrated_memory: str = Field(..., description="Integrated memory content")
    raw_memory: Dict[str, Any] = Field(..., description="Raw memory data")

class GenerateRequests(BaseModel):
    """Generate new requests"""
    new_requests: List[str] = Field(..., description="List of new search requests")

# =============================
# Protocols (Interface definitions)
# =============================

class MemoryStore(Protocol):
    def load(self) -> MemoryState: ...
    def save(self, state: MemoryState) -> None: ...
    def add(self, abstract: str) -> None: ...

class PageStore(Protocol):
    def add(self, page: Page) -> None: ...
    def get(self, index: int) -> Optional[Page]: ...
    def list_all(self) -> List[Page]: ...

class Retriever(Protocol):
    """Unified interface for keyword / vector / page-id retrievers."""
    name: str
    def build(self, pages: List[Page]) -> None: ...
    def search(self, query: str, top_k: int = 10) -> List[Hit]: ...

class Tool(Protocol):
    name: str
    def run(self, **kwargs) -> ToolResult: ...

class ToolRegistry(Protocol):
    def run_many(self, tool_inputs: Dict[str, Dict[str, Any]]) -> List[ToolResult]: ...

# =============================
# In-memory default stores (for quick start)
# =============================

class InMemoryMemoryStore:
    def __init__(self, init_state: Optional[MemoryState] = None) -> None:
        self._state = init_state or MemoryState()

    def load(self) -> MemoryState:
        return self._state

    def save(self, state: MemoryState) -> None:
        self._state = state

    def add(self, abstract: str) -> None:
        """Add a new abstract to memory if it doesn't already exist."""
        if abstract and abstract not in self._state.abstracts:
            self._state.abstracts.append(abstract)

class InMemoryPageStore:
    """
    Simple append-only list store for Page.
    Uses index-based access.
    """
    def __init__(self) -> None:
        self._pages: List[Page] = []

    def add(self, page: Page) -> None:
        self._pages.append(page)

    def get(self, index: int) -> Optional[Page]:
        if 0 <= index < len(self._pages):
            return self._pages[index]
        return None

    def list_all(self) -> List[Page]:
        return list(self._pages)

# =============================
# Auto-generated JSON Schema
# =============================

# JSON Schema for LLM calls
PLANNING_SCHEMA = SearchPlan.model_json_schema()
INTEGRATE_SCHEMA = Result.model_json_schema()
INFO_CHECK_SCHEMA = ReflectionDecision.model_json_schema()
GENERATE_REQUESTS_SCHEMA = GenerateRequests.model_json_schema()