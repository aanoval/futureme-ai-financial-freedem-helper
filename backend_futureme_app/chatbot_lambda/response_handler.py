# openai_client.py
import requests
from typing import List, Dict, Any

class OpenAIClient:
    """Client for interacting with OpenAI API."""
    def __init__(self, api_key: str):
        self.api_key = api_key
        self.base_url = "https://api.openai.com/v1"

    def chat_completion(self, messages: List[Dict[str, str]], model: str = "gpt-3.5-turbo", max_tokens: int = 500) -> Dict[str, Any]:
        """
        Call OpenAI Chat Completion API.
        """
        try:
            response = requests.post(
                f"{self.base_url}/chat/completions",
                headers={
                    "Authorization": f"Bearer {self.api_key}",
                    "Content-Type": "application/json"
                },
                json={
                    "model": model,
                    "messages": messages,
                    "max_tokens": max_tokens,
                    "temperature": 0.7
                }
            )
            response.raise_for_status()
            return response.json()
        except requests.RequestException as e:
            log_error(f"OpenAI API call failed: {str(e)}")
            raise Exception(f"OpenAI API error: {str(e)}")