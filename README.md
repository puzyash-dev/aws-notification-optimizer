# AWS Notification Optimizer

> A/B POC of a serverless notification pipeline: consolidating redundant
> email broadcasts via **SQS + Lambda + SES**.

The scenario is based on a real broker setup: the broker sends a client **3 emails
and 2 push notifications** for a single action - requesting a brokerage account
statement. This project shows how the "as-is" (legacy) flow becomes the "should-be"
(optimized) flow while keeping the mandatory notifications (Bank of Russia
Regulation No. 503-P).

## Architecture

<!-- images/architecture.png -->

## Key Technical Features

- Terraform IaC: SQS + Lambda (Python) + SES + IAM + CloudWatch
- `legacy` / `optimized` modes via a single Terraform variable
- Flow: `SQS -> Lambda (Python 3.13) -> SES`
- Reusable Terraform module `sqs_lambda` via `for_each` (legacy/optimized stacks)
- A/B validation: **3 emails vs 1 email** per event
- CloudWatch logs, SES identity verification, sent counter

## Validation

Demo: one `statement_request` event sent to each queue. Raw evidence from
CloudWatch logs:

| Mode | Emails per event | Log |
|---|---|---|
| `legacy` (as-is) | **3** - accepted + executed + statement | [logs/legacy.csv](docs/logs/legacy.csv) |
| `optimized` (proposal) | **1** - mandatory statement only | [logs/optimized.csv](docs/logs/optimized.csv) |

## Key Observations

- SES emails without a verified domain / DKIM land in **Spam** (Gmail) - critical
  for the deliverability of the broker's mandatory notifications.
- Production path: SES domain identity + DKIM/SPF/DMARC + custom MAIL FROM.
- The statement email is mandatory per Bank of Russia Regulation No. 503-P
  (ch. 12); see `docs/compliance.md`.

## Security & Observability

- IAM least privilege, no hardcoded secrets
- CloudWatch logs + monthly cost budget alert

## Repository Structure

    infra/   # Terraform IaC
    lambda/  # Python handlers (legacy / optimized / common)
    docs/    # compliance.md, deliverability.md, logs/
    images/  # diagrams and screenshots

## Stack

AWS | Terraform | Python | SES | SQS | Lambda