from django.test import TestCase

# Create your tests here.

"""
__ __ __ __ __ __ __ __ __ ___

        FALLBACK TEST
__ __ __ __ __ __ __ __ __ __
    
"""
import anthropic
from pathlib import Path
from django.core.cache import cache
import os
from dotenv import load_dotenv

BASE_DIR = Path(__file__).resolve().parent.parent.parent
load_dotenv(BASE_DIR / '.env')

api_key = os.environ.get('ANTHROPIC_API_KEY')
aws_bearer_token = os.environ.get('AWS_BEARER_TOKEN_BEDROCK')
providers = [    
    # ("bedrock", anthropic.AnthropicBedrock(aws_region='eu-north-1'),
    # "eu.anthropic.claude-sonnet-4-6"),
    ("bedrock", anthropic.AnthropicBedrock(aws_region='eu-north-1'),
    "eu.anthropic.claude-sonnet-4-5"),
    ("api", anthropic.Anthropic(api_key=api_key),
    "claude-sonnet-4-6"),
    ]

last_provider_error = None

def _name_format(name):
    return f'Provider: {name}'

def _set_last_provider_error(name, e):
    cache.set(f'last_provider_error', f'{_name_format(name)}, error: {e}')

def _set_timeout(name):
    cache.set(_name_format(name), True, timeout=60) #set to timeout to 600 in production 

def _timeout_check(name):
    return bool(cache.get(_name_format(name)))

def _clear_timeout(name):
    cache.delete(_name_format(name))
    
def _is_retryable(e):
    retryable_errors = (anthropic.APIConnectionError, 
                        anthropic.RateLimitError,
                        anthropic.InternalServerError,
                        anthropic.BadRequestError)
    if isinstance(e, retryable_errors):
        return True
    return False

def call_with_fallback(user_message):
    ordered_providers = sorted(providers, key=lambda p: _timeout_check(p[0]))
    print(f"ordered providers: {ordered_providers}")
    for name, client, model in ordered_providers: 
        try: 
            study_plan = client.messages.create(
                model=model,
                max_tokens=8096,
                # system=SYSTEM_PROMPT,
                messages=[{"role": "user", "content": user_message}],
            )
            print('provider_name:', name)
            
            _clear_timeout(name)
            return study_plan
        except Exception as e: 
            if _is_retryable(e):
                _set_timeout(name)
                _set_last_provider_error(name, e)
                print(f'Provider: {name}, \n retryable error: {e}')
                continue
            raise e 
        
print(call_with_fallback('Hi Claude!'))