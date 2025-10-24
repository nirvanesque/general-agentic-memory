from abc import ABC, abstractmethod
from gam.schemas import InMemoryPageStore, Hit
from typing import Any, List, Dict

class AbsRetriever(ABC):
    def __init__(
        self,
        config: Dict[str, Any],
    ):
        self.config = config

    def load(self):
        pass

    def search(self, query_list: List[str], top_k: int = 10) -> List[List[Hit]]:
        pass

    def build(self, page_store: InMemoryPageStore):
        pass
    
    def update(self, page_store: InMemoryPageStore):
        pass