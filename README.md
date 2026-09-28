# ✉️ AWS Notification Optimizer

> 📌 **Project Overview**

POC serverless-конвейера уведомлений: консолидация избыточных email-рассылок через **SQS + Lambda + SES**. 
Сценарий взят из реальной ситуации: брокер (ВТБ) шлёт клиенту 3 письма и 2 push-уведомления на одно действие — 
заказ выписки по счёту депо. Проект показывает, как "как есть" (legacy) превращается в "как надо" (optimized) 
с сохранением обязательных уведомлений (Положение ЦБ РФ № 503-П).

## 🏗️ Architecture Diagram

<!-- images/architecture.png -->

## 🛠️ Key Technical Features

- Terraform IaC: SQS + Lambda (Python) + SES + IAM + CloudWatch
- Режимы `legacy` / `optimized` через Terraform-переменную `MODE`
- Поток: `SQS -> Lambda (Python 3.13) -> SES`
- Terraform-модуль `sqs_lambda`, переиспользуемый через `for_each` (стек legacy/optimized)
- A/B-демонстрация: 3 письма vs 1 письмо на одно событие
- CloudWatch-логи, SES-верификация, счётчик отправленных

## ✅ Validation

Демо-прогон: в каждую очередь отправлено одно событие `statement_request`.

| Режим | Писем на событие | Скриншот |
|---|---|---|
| `legacy` (как ВТБ) | **3** — «принята» + «исполнено» + «выписка» | ![legacy](images/legacy-3-emails.png) |
| `optimized` (предложение) | **1** — только обязательная выписка | ![optimized](images/optimized-1-email.png) |

## 💡 Key Observations

- Письма SES без своего домена/DKIM попадают в **Spam** (Gmail) — а это критично для доставляемости обязательных уведомлений брокера.
- Production-путь: SES domain identity + DKIM/SPF/DMARC + custom MAIL FROM.
- Обязательность письма-выписки — Положение ЦБ РФ № 503-П (гл. 12), см. `docs/compliance.md`.

## 🔒 Security & Observability

- IAM least privileges, никаких hardcoded-секретов
- CloudWatch metrics + budgets

## 📂 Repository Structure

├── infra/          # Terraform
├── lambda/         # Python (legacy/optimized/common)
├── docs/           # compliance.md, letter.md
└── images/         # схемы и скриншоты

## 🛠️ Stack

AWS | Terraform | Python | SES | SQS | Lambda