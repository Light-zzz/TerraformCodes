# TerraformCodes
In This repo have terraform code .tf files to created VPC EC2 and deployed Index.html using nginx.

If There is two .ftvars Files Link **Dev_terraform.tfvars** and **Prod_terraform.tfvars** then use the below commad to store and secure your .tfstate files.
For Develpoer :
terraform init -backend-config="bucket=Linknestcode"
terraform init -backend-config="key=Developer/Dev_terraform.tfstate"
terraform init -backend-config="region=ap-south-1"

For Producation:
terraform init -backend-config="bucket=Linknestcode"
terraform init -backend-config="key=Producation/Prod_terraform.tfstate"
terraform init -backend-config="region=ap-south-1"

terraform plan and tell the terraform to which .tfvars file willl use command like
terraform plan -var-file="Dev_terraform.tfvars"
or
terraform plan -var-file="Prod_terraform.tfvars"

same at the time of apply
terraform apply -var-file="Dev_terraform.tfvars" --auto-approve
or
terraform apply -var-file="Prod_terraform.tfvars" --auto-approve
