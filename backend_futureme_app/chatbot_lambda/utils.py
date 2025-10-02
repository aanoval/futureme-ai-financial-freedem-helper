# response_handler.py
def build_success_response(data: Dict[str, Any]) -> Dict[str, Any]:
    """Build a successful API response."""
    return {
        "statusCode": 200,
        "body": json.dumps(data),
        "headers": {"Content-Type": "application/json"}
    }

def build_error_response(error_message: str) -> Dict[str, Any]:
    """Build an error API response."""
    return {
        "statusCode": 500,
        "body": json.dumps({"error": error_message}),
        "headers": {"Content-Type": "application/json"}
    }