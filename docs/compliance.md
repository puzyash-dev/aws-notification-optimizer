# Compliance Analysis of Notifications (Broker Case)

## Emails sent per single action (statement request)

| # | Email | Mandatory? | Basis |
|---|---|---|---|
| 1 | "Statement request accepted" | no - product activity |
| 2 | "Statement order executed" | no - product activity |
| 3 | Statement (report + attachment) | **yes** | Bank of Russia Regulation No. 503-P (ch. 12) |
| push x2 | in-app notifications | no - product activity |

## Regulations

- **Bank of Russia Regulation No. 503-P** - "On Depository Activity". A statement
  of the securities account is provided upon client request (ch. 12): this is
  email #3, and it **cannot be removed**.
- **Regulation No. 606-P** - a professional participant must store documents for
  >= 5 years, so emails/statements must be archived.
- **Regulation No. 577-P** - broker reporting to clients (ch. 9) - the context
  for sending reporting documents.

## Conclusion for optimization

Emails 1-2 and the push notifications are optional and duplicate each other.
Consolidating them into **one final email** (the statement) does not violate
client rights and reduces information noise: **3 emails + 2 pushes -> 1 email +
record in the personal account**.