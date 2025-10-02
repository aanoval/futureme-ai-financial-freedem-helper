import json
import os
from typing import Dict, Any
from .utils import parse_request, log_info, log_error
from .openai_client import OpenAIClient
from .response_handler import build_success_response, build_error_response

def lambda_handler(event: Dict[str, Any], context: Any) -> Dict[str, Any]:
    """
    AWS Lambda handler for the /chatbot endpoint.
    Processes incoming chat requests and calls OpenAI Chat Completion API.
    """
    try:
        # Parse the incoming request
        data = parse_request(event)
        profile = data.get('profile', {})
        message = data.get('message')
        
        if not message:
            raise ValueError("Message field is required")

        # Initialize OpenAI client
        openai_client = OpenAIClient(api_key=os.environ["OPENAI_API_KEY"])

        # Prepare chat completion messages
        system_prompt = (
            "You are a helpful financial assistant. Use the user's profile to provide personalized responses. "
            f"User profile: {json.dumps(profile)}. Respond in a friendly and concise manner."
        )
        messages = [
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": message}
        ]

        # Call OpenAI Chat Completion API
        response = openai_client.chat_completion(messages=messages, model="gpt-3.5-turbo", max_tokens=500)
        
        # Extract the response
        ai_response = response['choices'][0]['message']['content'].strip()
        
        log_info(f"Successfully processed chat request: {message}")
        return build_success_response({"response": ai_response})

    except Exception as e:
        log_error(f"Error processing chat request: {str(e)}")
        return build_error_response(str(e))