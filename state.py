from typing import TypedDict, List, Dict, Optional, Any, Annotated
from langgraph.graph import add_messages
from langchain_core.messages import BaseMessage

class AgentState(TypedDict):
    """Shared mutable state for the multi-agent-system."""

    # coversation history
    messages: Annotated[List[BaseMessage], add_messages]
    
    # context and file system awareness
    current_folder: Optional[str]
    known_files: List[str]
    
    # agent artifacts
    requirements: Dict[str, Any]
    user_stories: List[Dict]
    test_cases: List[Dict]
    
    # results
    analysis_results: Dict[str, Any]

    # final output
    final_output: Optional[str]
    total_tokens: int
    total_cost: float
    
