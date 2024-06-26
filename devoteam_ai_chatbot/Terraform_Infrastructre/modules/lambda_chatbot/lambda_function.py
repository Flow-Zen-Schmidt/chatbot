import json
import boto3
from datetime import datetime

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('ChatbotHistory')

def lambda_handler(event, context):
    message = json.loads(event['body'])['message']
    user_id = event['requestContext']['identity']['cognitoIdentityId']
    
    # Process the message here and generate a response
    response = f"You said: {message}"
    
    # Store the conversation in DynamoDB
    table.put_item(
        Item={
            'UserId': user_id,
            'Timestamp': str(datetime.now()),
            'Message': message,
            'Response': response
        }
    )
    
    return {
        'statusCode': 200,
        'body': json.dumps({'message': response}),
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        }
    }