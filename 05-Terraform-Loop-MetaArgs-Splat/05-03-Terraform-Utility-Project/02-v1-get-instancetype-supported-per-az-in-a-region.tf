data "aws_ec2_instance_type_offerings" "my_ins_type1" {
  filter {
    name   = "instance-type"
    values = ["t3.micro"]
  }
  filter {
    name   = "location"
    # 가능한 AZ에 대해 하드코딩으로 테스트합니다.
    # values = ["ap-northeast-2a"]
    # values = ["ap-northeast-2b"]
    # values = ["ap-northeast-2c"]
    # values = ["ap-northeast-2d"]
    values = ["ap-northeast-2e"]
  }
  location_type = "availability-zone"
}


# Output
output "output_v1_1" {
  value = data.aws_ec2_instance_type_offerings.my_ins_type1.instance_types
}