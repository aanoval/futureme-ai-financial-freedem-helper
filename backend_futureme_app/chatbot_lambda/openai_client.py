# utils.py
def parse_request(event: Dict[str, Any]) -> Dict[str, Any]:
    """
    Parse the incoming API Gateway event to extract JSON body.
    Handles both base64-encoded and direct JSON bodies.
    """
    try:
        if event.get('isBase64Encoded', False):
            body = base64.b64decode(event['body']).decode('utf-8')
        else:
            body = event['body']
        return json.loads(body)
    except Exception as e:
        log_error(f"Failed to parse request body: {str(e)}")
        raise ValueError("Invalid request body")

def log_info(message: str) -> None:
    """Log informational messages."""
    print(f"INFO: {message}")

def log_error(message: str) -> None:
    """Log error messages."""
    print(f"ERROR: {message}")