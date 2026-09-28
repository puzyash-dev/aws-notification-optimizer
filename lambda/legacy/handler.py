"""Legacy notification flow (VTB today): 3 emails per single action."""

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

        _send("Заявка на выписку по счёту депо принята",
              f"Заявка №{request_id} принята к исполнению.")
        _send("Исполнено поручение на выписку",
              f"Номер распоряжения: {request_id}.")
        _send("Выписка по счёту депо готова",
              f"Выписка по запросу №{request_id} доступна: {msg.get('statement_url')}.")

    return {"statusCode": 200}