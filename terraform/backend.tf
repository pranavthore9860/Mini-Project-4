terraform {
  backend "s3" {
    bucket       = "mini-project-4-tfstate-pranav-2125ucsm1040-20261018"
    key          = "mini-project-4/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
