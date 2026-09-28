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
- ...

## ✅ Validation

<!-- скриншоты terraform apply, CloudWatch, письма -->

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