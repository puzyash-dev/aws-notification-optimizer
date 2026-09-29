"""Optimized notification flow (proposal): 1 consolidated, mandatory email.

Chatty confirmations are dropped; the audit trail stays in the personal account.
"""

import os
import json

import boto3

ses = boto3.client("ses")

SENDER = os.environ["SENDER_EMAIL"]
RECIPIENT = os.environ["RECIPIENT_EMAIL"]


def lambda_handler(event, context):
    for record in event["Records"]:
        msg = json.loads(record["body"])
        request_id = msg["request_id"]

        ses.send_email(
            Source=SENDER,
            Destination={"ToAddresses": [RECIPIENT]},
            Message={
                "Subject": {"Data": "Broker statement is ready"},
                "Body": {
                    "Text": {
                        "Data": (
                            f"Request #{request_id} has been executed.\n"
                            f"Statement: {msg.get('statement_url')}\n\n"
                            "This is the only notification - intermediate "
                            "'accepted / executed' alerts are disabled."
                        )
                    }
                },
            },
        )
        print(f"optimized sent for {request_id}")

    return {"statusCode": 200}