"""Legacy notification flow (as-is): 3 emails per single action."""

import os
import json

import boto3

ses = boto3.client("ses")

SENDER = os.environ["SENDER_EMAIL"]
RECIPIENT = os.environ["RECIPIENT_EMAIL"]


def _send(subject: str, body: str) -> None:
    ses.send_email(
        Source=SENDER,
        Destination={"ToAddresses": [RECIPIENT]},
        Message={
            "Subject": {"Data": subject},
            "Body": {"Text": {"Data": body}},
        },
    )
    print(f"sent: {subject}")


def lambda_handler(event, context):
    for record in event["Records"]:
        msg = json.loads(record["body"])
        request_id = msg["request_id"]

        _send("Statement request accepted",
              f"Request #{request_id} accepted for processing.")
        _send("Statement order executed",
              f"Order number: {request_id}.")
        _send("Broker statement is ready",
              f"Statement for request #{request_id} is available: {msg.get('statement_url')}.")

    return {"statusCode": 200}