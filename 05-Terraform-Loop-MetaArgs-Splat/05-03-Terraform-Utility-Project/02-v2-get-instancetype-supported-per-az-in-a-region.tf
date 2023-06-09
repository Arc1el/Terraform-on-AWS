data "aws_ec2_instance_type_offerings" "my_ins_type2" {
  for_each = toset([ "ap-northeast-2a", "ap-northeast-2b",
                     "ap-northeast-2c", "ap-northeast-2d", ])
  filter {
    name   = "instance-type"
    values = ["t3.micro"]
  }
  filter {
    name   = "location"
    values = [each.key]
  }
  location_type = "availability-zone"
}

output "output_v2_1" {
 #value = data.aws_ec2_instance_type_offerings.my_ins_type1.instance_types
 value = toset([
      for t in data.aws_ec2_instance_type_offerings.my_ins_type2 : t.instance_types
    ])  
}

output "output_v2_2" {
 value = { for az, details in data.aws_ec2_instance_type_offerings.my_ins_type2 :
  az => details.instance_types }   
}