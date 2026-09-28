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
                "Subject": {"Data": "Выписка по счёту депо готова"},
                "Body": {
                    "Text": {
                        "Data": (
                            f"Запрос №{request_id} исполнен.\n"
                            f"Выписка: {msg.get('statement_url')}\n\n"
                            "Это единственное уведомление — промежуточные "
                            "«принято / исполнено» отключены."
                        )
                    }
                },
            },
        )
        print(f"optimized sent for {request_id}")

    return {"statusCode": 200}