# Deliverability: Why Emails Landed in Spam

## Observation in the demo

SES in sandbox, sender = verified email address, no domain identity.
Gmail put all emails into **Spam**.

## Why

| Setting | Value in the demo | Required in production |
|---|---|---|
| Identity | email (address) | **domain identity** (custom domain) |
| DKIM | no (SigningEnabled=false) | **DKIM records** in DNS |
| SPF | none | SPF + MX |
| MAIL FROM | default amazonses.com | **custom MAIL FROM** (own subdomain) |

## Conclusion

The broker's mandatory email (statement) must reliably reach the inbox. Without
sender authentication, even correct emails land in spam - a strong argument to
take to the broker: fewer emails + proper authentication = higher deliverability
of the important one.

## How to fix (production path)

1. Get a domain and create an `aws_sesv2_email_identity` for it.
2. Add DKIM (3 CNAME records) and MAIL FROM (MX + SPF) to DNS.
3. Move from sandbox to production (AWS Support request).