# AWS Region 정의
variable "aws_region" {
  description = "test-hmkim-terraform-default-region-seoul"
  type = string
  # 디폴트 리전을 서울로 설정합니다.
  default = "ap-northeast-2"  
}

# AWS EC2 인스턴스 타입 정의 (리스트)
variable "instance_type_list" {
  description = "EC2 Instance Type"
  # 타입을 리스트로 지정합니다
  type = list(string)
  # 인스턴스 타입을 정의합니다
  default = ["t3.micro", "t3.small"]
}

# AWS EC2 인스턴스 타입 정의 ()
variable "instance_type_map" {
  description = "EC2 Instance Type"
  # 타입을 맵으로 지정합니다
  type = map(string)
  # 인스턴스 타입을 정의합니다
  default = {
    "dev" = "t3.micro"
    "qa"  = "t3.small"
    "prod"= "t3.large"
  }
}

# AWS EC2 Instance Key Pair 설정
variable "instance_keypair" {
  description = "AWS EC2 Key pair that need to be associated with EC2 Instance"
  type = string
  # 키페어를 변경하였습니다.
  default = "test-hmkim-keypair"
}