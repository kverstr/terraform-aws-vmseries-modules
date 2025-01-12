variable "region" {
  description = "AWS region to use for the created resources."
  default     = "us-east-1"
  type        = string
}

variable "switchme" {
  description = "The true/false switch for testing the modifiability. Initial runs should use `true`, then at some point one or more consecutive runs should use `false` instead."
  type        = bool
}

variable "create_iam_role_policy" {
  description = "If true, a new IAM role with policy will be created. When false, name of existing IAM role to use has to be provided in `iam_role_name` variable."
  default     = true
  type        = string
}

variable "iam_role_name" {
  description = "Name of a IAM role to reuse or create (depending on `create_iam_role_policy` value)."
  default     = ""
  type        = string
}

variable "dhcp_send_hostname" {
  description = "The DHCP server determines a value of yes or no. If yes, the firewall sends its hostname to the DHCP server."
  default     = "yes"
  type        = string
}

variable "dhcp_send_client_id" {
  description = "The DHCP server determines a value of yes or no. If yes, the firewall sends its client ID to the DHCP server."
  default     = "yes"
  type        = string
}

variable "dhcp_accept_server_hostname" {
  description = "The DHCP server determines a value of yes or no. If yes, the firewall accepts its hostname from the DHCP server."
  default     = "yes"
  type        = string
}

variable "dhcp_accept_server_domain" {
  description = "The DHCP server determines a value of yes or no. If yes, the firewall accepts its DNS server from the DHCP server."
  default     = "yes"
  type        = string
}

resource "aws_iam_role" "simulate_existing_role_for_test" {
  count = length(var.iam_role_name) > 0 ? 1 : 0

  name = var.iam_role_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
      "Service": "ec2.amazonaws.com"
    },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

module "bootstrap" {
  source                      = "../../modules/bootstrap"
  prefix                      = "a"
  global_tags                 = var.switchme ? {} : { switchme = var.switchme }
  create_iam_role_policy      = var.create_iam_role_policy
  iam_role_name               = try(var.iam_role_name, "")
  dhcp_send_hostname          = var.dhcp_send_hostname
  dhcp_send_client_id         = var.dhcp_send_client_id
  dhcp_accept_server_hostname = var.dhcp_accept_server_hostname
  dhcp_accept_server_domain   = var.dhcp_accept_server_domain
  depends_on = [
    aws_iam_role.simulate_existing_role_for_test
  ]
}

output "bucket_name_correct" {
  value = (substr(module.bootstrap.bucket_name, 0, 1) == "a")
}

output "instance_profile_name_correct" {
  value = (substr(module.bootstrap.instance_profile_name, 0, 1) == "a")
}

output "bucket_domain_name" {
  value = module.bootstrap.bucket_domain_name
}

output "iam_role_name" {
  value = module.bootstrap.iam_role_name
}

output "iam_role_arn" {
  value = module.bootstrap.iam_role_arn
}