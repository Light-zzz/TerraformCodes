output "vpc_id" {
  value = aws_vpc.VPC_Terraform.id
}
output "Sub_Pub" {
  value = aws_subnet.Sub_Pub.id
}
output "Sub_Pri" {
    value = aws_subnet.Sub_Pri.id 
}
# output "public_ec2_instance" {
#   value = aws_instance.public_ec2_instance.id
# }
output "web_server1" {
  value = aws_instance.web_server1.public_ip
}
