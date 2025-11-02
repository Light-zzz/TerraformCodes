variable "Sub_Pub" {
  description = "Enter the Public Subnet 1"
}
variable "Sub_Pri" {
  description = "Enter the Private Subnet 2"
}
variable "public_ec2_instance" {
  description = "Enter the name for VM"
  type = string
}
variable "VPC_Terraform" {
  description = "Enter the VPC name"
}