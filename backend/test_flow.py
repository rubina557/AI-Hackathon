import json
from main import app, book_service, BookServiceRequest
import os

def run_test():
    # Make sure we're in the right directory or adjust paths
    os.chdir(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    
    req = BookServiceRequest(
        phrase="mujhe kl raat ko latifabad mai ac repair wala chahiye"
    )
    res = book_service(req)
    
    print("=== SELECTED PROVIDER ===")
    if res.selected_provider:
        print(json.dumps(res.selected_provider.model_dump(), indent=2))
    else:
        print("None")
        
    print("\n=== INTENT LOG ===")
    print(res.intent_log)
    
    print("\n=== DISCOVERY LOG ===")
    print(res.discovery_log)
    
    print("\n=== RANKING LOG ===")
    print(res.ranking_log)

if __name__ == "__main__":
    run_test()
