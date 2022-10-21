# Palo Alto Networks ASG Module Example for AWS Cloud

A Terraform module example for deploying a autoscaling group with VM-Series in AWS Cloud.

This example can be used to familarize oneself with both VM-series and Terraform - it creates a autoscaling group with instances of virtualized firewalls in a Security VPC with a multiple interfaces which was created by Lambda function.

**NOTE:**
Firewall will take a serveral minutes to bootup during the initial setup.
It is necessary and important to set mgmt-interface-swap since default interface is created through launch template.
In this scenario we create management interface via lambda and passing mgmt-interface-swap enable to use that interface in bootstrap.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.0, < 2.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.25 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_security_subnet_sets"></a> [security\_subnet\_sets](#module\_security\_subnet\_sets) | ../../modules/subnet_set | n/a |
| <a name="module_security_vpc"></a> [security\_vpc](#module\_security\_vpc) | ../../modules/vpc | n/a |
| <a name="module_vm_series_asg"></a> [vm\_series\_asg](#module\_vm\_series\_asg) | ../../modules/asg | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_asg_desired_cap"></a> [asg\_desired\_cap](#input\_asg\_desired\_cap) | n/a | `number` | `1` | no |
| <a name="input_asg_max_size"></a> [asg\_max\_size](#input\_asg\_max\_size) | n/a | `number` | `10` | no |
| <a name="input_asg_min_size"></a> [asg\_min\_size](#input\_asg\_min\_size) | n/a | `number` | `1` | no |
| <a name="input_bootstrap_options"></a> [bootstrap\_options](#input\_bootstrap\_options) | n/a | `any` | n/a | yes |
| <a name="input_global_tags"></a> [global\_tags](#input\_global\_tags) | A map of tags to assign to the resources.<br>If configured with a provider `default_tags` configuration block present, tags with matching keys will overwrite those defined at the provider-level." | `map(any)` | `{}` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix use for creating unique names. | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region. | `string` | `"us-east-1"` | no |
| <a name="input_ssh_key_name"></a> [ssh\_key\_name](#input\_ssh\_key\_name) | n/a | `any` | n/a | yes |
| <a name="input_vmseries_ami_id"></a> [vmseries\_ami\_id](#input\_vmseries\_ami\_id) | n/a | `any` | n/a | yes |
| <a name="input_vmseries_interfaces"></a> [vmseries\_interfaces](#input\_vmseries\_interfaces) | n/a | `any` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | AWS VPC Cidr block. | `string` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | VPC Name. | `string` | `"security-vpc"` | no |
| <a name="input_vpc_security_groups"></a> [vpc\_security\_groups](#input\_vpc\_security\_groups) | Security VPC security groups settings.<br>Structure looks like this:<pre>{<br>  security_group_name = {<br>    {<br>      name = "security_group_name"<br>      rules = {<br>        all_outbound = {<br>          description = "Permit All traffic outbound"<br>          type        = "egress", from_port = "0", to_port = "0", protocol = "-1"<br>          cidr_blocks = ["0.0.0.0/0"]<br>        }<br>        https = {<br>          description = "Permit HTTPS"<br>          type        = "ingress", from_port = "443", to_port = "443", protocol = "tcp"<br>          cidr_blocks = ["0.0.0.0/0"]<br>        }<br>        ssh = {<br>          description = "Permit SSH"<br>          type        = "ingress", from_port = "22", to_port = "22", protocol = "tcp"<br>          cidr_blocks = ["0.0.0.0/0"]<br>        }<br>      }<br>    }<br>  }<br>}</pre> | `map(any)` | n/a | yes |
| <a name="input_vpc_subnets"></a> [vpc\_subnets](#input\_vpc\_subnets) | Security VPC subnets CIDR | `map(any)` | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->