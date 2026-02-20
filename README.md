# aws-terraform-cicd-pipeline

A small, production-style Terraform project that demonstrates **CI/CD for infrastructure** using **GitHub Actions** and **AWS OIDC (no long-lived AWS keys)**.

- **CI (Pull Requests):** runs `terraform fmt/validate/plan` and comments the plan in the PR
- **CD (main branch):** runs `terraform apply` automatically after merge
- **Remote state:** stored in S3 with state locking via DynamoDB

## Architecture

- GitHub Actions workflows:
  - `terraform-ci.yml` → PR plan + comment
  - `terraform-cd.yml` → apply on merge to `main`
- AWS IAM:
  - OIDC provider for GitHub Actions
  - IAM role assumed by GitHub Actions (least privilege)
- Terraform remote state:
  - S3 backend bucket
  - DynamoDB table for state locking

## Repo structure

```text
.
├── infra/                     # Terraform code (backend + resources)
├── .github/workflows/          # GitHub Actions CI/CD
└── screenshots/                # Evidence of setup and successful runs
```

The `infra/` folder contains the Terraform configuration that defines the AWS resources. The `.github/workflows/` folder contains the CI/CD automation that runs on pull requests and merges.

## Screenshots

1. Backend initialised: `screenshots/01-terraform-backend-initialized.png`
2. Local apply success: `screenshots/03-terraform-apply-local-success.png`
3. AWS OIDC provider: `screenshots/07-iam-oidc-provider.png`
4. IAM role trust policy: `screenshots/08-iam-role-trust-policy.png`
5. CI success overview: `screenshots/10-terraform-ci-success-overview.png`
6. CD apply success: `screenshots/16-terraform-cd-apply-success.png`

## How it works (simple)

* When you open a PR that changes `infra/**`, GitHub Actions assumes an AWS role via OIDC and runs a Terraform plan.
* When the PR is merged into `main`, GitHub Actions runs Terraform apply to make AWS match the code.

## What I learned

Setting up OIDC between GitHub and AWS was more involved than expected — the trust policy needs to explicitly allow the repo and branch, which means you can't just copy-paste examples. Getting state locking working in CI required adding specific DynamoDB permissions to the IAM role. The biggest shift was realising that `terraform plan` in CI behaves differently than running it locally — you need to handle outputs carefully so they don't leak sensitive data into PR comments.

## Notes

* This repository is intentionally small to focus on the CI/CD pattern.
* Initially, the IAM role lacked S3 bucket configuration permissions — adding `s3:PutBucketVersioning` and `s3:PutBucketPublicAccessBlock` fixed the plan failures.
* Future improvement: add a manual approval gate before `terraform apply` runs in production.
