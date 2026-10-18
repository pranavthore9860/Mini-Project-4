# Mini Project 4: AWS Infrastructure Automation

**Student:** Pranav Hanuman Thore  
**PRN:** 2125UCSM1040  
**Class:** SY-A AIML  
**GitHub:** [pranavthore9860](https://github.com/pranavthore9860)

This project provisions a small AWS web-hosting environment with Terraform, deploys Nginx with Ansible, and runs the process from GitHub Actions. It creates a VPC, public subnet, internet gateway, route table, security group, EC2 instance, and encrypted/versioned private S3 bucket.

> **Deployment status:** This folder is prepared as source code only. No AWS resources have been deployed or tested. Deployment requires your AWS account, an IAM role trusted by GitHub OIDC, an SSH key pair, backend setup, and a manual GitHub Actions run. AWS charges may apply while resources exist.

## Repository layout

```text
Mini-Project-4/
├── .github/workflows/deploy.yml
├── ansible/playbook.yml
├── terraform/backend.tf
├── terraform/main.tf
├── terraform/outputs.tf
├── terraform/variables.tf
├── terraform/versions.tf
├── report/Assignment-Report.docx
├── .gitignore
└── README.md
```

## Before deployment

1. Create a private GitHub repository named `Mini-Project-4` under `pranavthore9860`.
2. Choose one AWS region and use it consistently. Examples below use `us-east-1`.
3. Create an S3 bucket for Terraform state in that region. Use a globally unique name, block public access, enable versioning and default encryption, and restrict access to your deployment role. The backend bucket must exist before Terraform runs.
4. Edit `terraform/backend.tf`: replace `REPLACE_WITH_TERRAFORM_STATE_BUCKET` with that bucket name.
5. Generate an SSH key pair locally. Add only the **public key** to the repository variable `EC2_SSH_PUBLIC_KEY`; store the private key as the GitHub Actions secret `EC2_SSH_PRIVATE_KEY`. Never commit either key.
6. Add the repository variable `AWS_REGION` (for example `us-east-1`), `AWS_ROLE_ARN` (the IAM role ARN to assume via OIDC), and `SSH_ALLOWED_CIDR` (your current public IPv4 address in `/32` format, e.g. `203.0.113.7/32`).
7. In AWS IAM, configure the GitHub OIDC provider `https://token.actions.githubusercontent.com` with audience `sts.amazonaws.com`. Create a role whose trust policy restricts `sub` to `repo:pranavthore9860/Mini-Project-4:ref:refs/heads/main`. Grant only the permissions needed to manage this stack and its state bucket. Avoid administrator access and long-lived access keys. Follow AWS service authorization guidance and tighten resource ARNs to your project where practical.
8. Set Terraform backend access on that role for the state object and `.tflock` object. The workflow uses S3 native state locking (`use_lockfile = true`).
9. Review the Terraform plan and IAM policy before deploying.

`SSH_ALLOWED_CIDR` is necessary because Ansible connects to the instance over SSH. Keep it restricted to your IP. If your IP changes, update the variable. HTTP is open to the internet so the Nginx page can be viewed publicly.

## Create and push the repository

From this folder, run:

```bash
git init -b main
git add .
git commit -m "Build Mini Project 4 infrastructure automation"
git remote add origin https://github.com/pranavthore9860/Mini-Project-4.git
git push -u origin main
```

Create the empty GitHub repository first. Do not select options that add a README or license, since those files are already included. If Git prompts for a password, use GitHub's supported browser sign-in or a personal access token; never put credentials in the remote URL.

## Run the deployment

In GitHub, open **Actions → Deploy Mini Project 4 → Run workflow**. The workflow is manual and applies Terraform before configuring Nginx with Ansible. It runs only on `main` on the configured self-hosted runner and has concurrency protection for the shared state.

After a successful run, Terraform outputs the web URL and S3 bucket name. Visit the web URL and confirm the sample page. Capture screenshots of the actual completed Actions run and browser output for your submission; do not use the example logs from the supplied assignment as proof of this deployment.

## Remove AWS resources

Use the workflow's `destroy` option after saving any needed evidence. Destroying the stack deletes its EC2/network resources and backup bucket contents. The separate Terraform state bucket is intentionally retained and must be removed manually only after confirming it contains no needed state. Review the destroy plan carefully before confirming.

## Security notes

- AWS authentication uses GitHub OIDC and a short-lived role session; no AWS access key is stored in the repository.
- The SSH private key exists only as a GitHub Actions secret during the job. The public key alone is registered with EC2. The self-hosted runner must be secured and kept patched.
- S3 public access is blocked, default encryption and versioning are enabled, and the demo bucket lifecycle cleans old versions after 90 days.
- SSH ingress is limited to the configured CIDR. Nginx HTTP is public by design.
- Terraform state contains infrastructure metadata and must remain private.
- Pin and review third-party GitHub Actions before production use. This educational workflow uses version tags for readability.

## Components

| Component | Purpose |
|---|---|
| Terraform | Reproducible AWS network, compute, security, and storage provisioning |
| GitHub Actions | Manual, auditable deployment and destroy workflow |
| AWS OIDC | Temporary credentials for the workflow |
| Ansible | Install and enable Nginx over SSH |
| Amazon Linux 2023 | EC2 operating system |
| S3 | Private, encrypted, versioned backup bucket |

## Limitations

This is an educational single-instance deployment, not a highly available or production web architecture. The public EC2 address can change after replacement. It does not configure a domain, TLS certificate, load balancer, application database, or centralized monitoring. The deployment has not been run in an AWS account; account-specific IAM permissions and quotas may need adjustment.
