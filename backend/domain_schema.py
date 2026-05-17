from pydantic import BaseModel
from typing import List, Optional, Dict

class ProviderCard(BaseModel):
    provider_id: str
    name: str
    rating: float
    total_reviews: int
    skill_level: str
    distance_km: float
    travel_fee_pkr: float
    eta_minutes: Optional[int] = None
    smart_badges: List[str] = []
    available_slots: List[str] = []
    is_ai_recommended: bool = False
    ai_reasoning_urdu: str = ""

class ServiceState(BaseModel):
    session_id: str
    original_input: str
    corrected_input: str
    service_category: Optional[str] = None      
    location_query: Optional[str] = None       
    urgency_flag: str = "Scheduled"            
    discovered_options: List[ProviderCard] = [] # The live array the UI must build
    selected_provider_id: Optional[str] = None  
    selected_time_slot: Optional[str] = None    
    booking_status: str = "Pending"
