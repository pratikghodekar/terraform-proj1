# terraform-proj1
Terraform creates AWS VPC, public &amp; private subnets and deploys ec2 instance in private subnet. It also creates application load balancer which is used to serve apache traffic from ec2 instance.

Prerequisites:
- AWS account
- terraform version >= 0.14.10
- Install AWS CLI & configure credentials.
- Credentials should have full access to EC2,VPC,S3 services.

Install Steps:
1. Update **terraform.tfvars** with values.
2. Execute **terraform plan** to validate what changes will take place
3. Execute **terraform apply --auto-approve** to setup resources in AWS

Delete Steps:
1. Execute **terraform destroy --auto-approve**
