import json
import os
import boto3
from botocore.exceptions import ClientError

# Initialize AWS clients
lex_client = boto3.client('lex-runtime')
dynamodb = boto3.resource('dynamodb')
bedrock_runtime = boto3.client('bedrock-runtime', region_name='us-west-2')  # Adjust region as needed

# Get environment variables
LEX_BOT_NAME = os.environ['LEX_BOT_NAME']
LEX_BOT_ALIAS = os.environ['LEX_BOT_ALIAS']
DYNAMODB_TABLE = os.environ['DYNAMODB_TABLE']

def lambda_handler(event, context):
    # Extract user ID and input text from the event
    user_id = event['requestContext']['identity'].get('cognitoIdentityId', 'anonymous')
    input_text = json.loads(event['body'])['message']

    try:
        # Step 1: Interact with Lex
        lex_response = lex_client.post_text(
            botName=LEX_BOT_NAME,
            botAlias=LEX_BOT_ALIAS,
            userId=user_id,
            inputText=input_text
        )

        # Step 2: If needed, enhance Lex response with Bedrock
        enhanced_response = lex_response['message']
        if lex_response['dialogState'] in ['Fulfilled', 'Failed']:
            bedrock_params = {
                "modelId": "anthropic.claude-v2",  # or another suitable model
                "contentType": "application/json",
                "accept": "application/json",
                "body": json.dumps({
                    "prompt": f"Human: {input_text}\n\nAssistant: {lex_response['message']}\n\nHuman: Can you enhance this response?\n\nAssistant:",
                    "max_tokens_to_sample": 300,
                    "temperature": 0.7,
                    "top_p": 0.9,
                })
            }
            bedrock_response = bedrock_runtime.invoke_model(**bedrock_params)
            bedrock_result = json.loads(bedrock_response['body'].read())
            enhanced_response = bedrock_result['completion']

        # Step 3: Store conversation in DynamoDB
        table = dynamodb.Table(DYNAMODB_TABLE)
        table.put_item(
            Item={
                'userId': user_id,
                'timestamp': int(context.get_remaining_time_in_millis()),
                'input': input_text,
                'response': enhanced_response
            }
        )

        # Step 4: Return response to client
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({'message': enhanced_response})
        }

    except ClientError as e:
        print(f"Error: {e}")
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({'message': 'Internal server error'})
        }
