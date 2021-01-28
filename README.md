# EC2 instance with EBS volume attachment

Configuration in this directory creates EC2 instances, EBS volume and attach it together.

Unspecified arguments for security group id and subnet are inherited from the default VPC.

This example outputs instance id and EBS volume id.

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which can cost money. Run `terraform destroy` when you don't need these resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.6 |
| aws | >= 2.65 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.65 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| instances\_number | Number of instances | `number` | `1` | yes |
| elb\_numbers | Number of elastic load balancer | `number` | `1` | yes |
| instances\_security_groups | SG of the compute| `number` | `1` | yes |


## Outputs

| Name | Description |
|------|-------------|
| ebs\_tc_volume.ebs.id\_id | The volume ID |
| ebs\_tc_volume.ebs.id\_attachment\_instance\_id | The instance ID |
| instances\_public_subnet\_ips | Public IPs assigned to the EC2 instance |
| instances\_private_subnet\_ips | Private IPs assigned to the EC2 instance |
| instances\_aws_launch_template.Instance.latest_version | Latest version of instances |
| instances\_data.aws_ami.AMI.id | Amazon Image ID |



<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
