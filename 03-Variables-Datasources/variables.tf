# AWS Region 정의
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type = string
  default = "ap-northeast-2"  
}

# AWS EC2 인스턴스 타입 정의
variable "instance_type" {
  description = "EC2 Instance Type"
  type = string
  default = "t3.micro"  
}

# AWS EC2 Instance Key Pair 설정
variable "instance_keypair" {
  description = "AWS EC2 Key pair that need to be associated with EC2 Instance"
  type = string
  default = "terraform-key"
}