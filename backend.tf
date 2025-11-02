terraform {
  backend "s3" {
    bucket         = "linknextawscode"  # Replace with your S3 bucket name
    key            = "Developer/terraform.tfstate"  # Path inside the bucket
    region         = "ap-south-1"                  # AWS region
  }
}
