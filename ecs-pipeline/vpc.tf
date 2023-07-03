locals {
  region = "ap-northeast-2"
  role_arn = "arn:aws:iam::759320821027:role/ducku-haha"
  name   = "peteasy" # project name
  key_name = "peteasy-key"
  env_name = "prod"

  # user_data = <<-EOT
  # #!/bin/bash
  # echo "Hello Terraform!"
  # EOT

  tags = {
    Owner       = "user"
    Environment = "prod"
  }
}
/* 
resource "random_pet" "this" {
  length = 2
}
 */


################################################################################
# VPC 생성
################################################################################
## [시퀀스]-[프로젝트명]-[리소스종류]-[구분명]-[AZ]-[번호]
module "vpc" {
  source = "./modules/vpc"
  vpc    = [{ 
    name = "01.vpc-${local.name}-prod" 
    cidr = "10.0.0.0/16" 

  }]


  subnet = [
    {name="01.sub-${local.name}-prod-pub-a-01", cidr = "10.0.1.0/24",default_gateway = "igw" },
    {name="02.sub-${local.name}-prod-pub-c-01", cidr = "10.0.2.0/24",default_gateway = "igw" },
    {name="03.sub-${local.name}-prod-pri-a-01", cidr = "10.0.11.0/24",default_gateway = "nat" },
    {name="04.sub-${local.name}-prod-pri-c-01", cidr = "10.0.22.0/24", default_gateway = "nat" },
    {name="05.sub-${local.name}-prod-db-a-01", cidr = "10.0.31.0/24", default_gateway = "non" },
    {name="06.sub-${local.name}-prod-db-c-01", cidr = "10.0.32.0/24", default_gateway = "non" },
  ]
  igw = true 
  nat = ["01.sub-${local.name}-prod-pub-a-01", "02.sub-${local.name}-prod-pub-c-01"]

  tags = { 
    Env  = local.env_name
  }
}









################################################################################
# Route 53 생성
################################################################################
/* resource "aws_route53_zone" "main" {
  count = local.create_route53_zone ? 1 : 0

  name = local.domain_name
  comment = "route53-${local.name}"
  tags = {
    Name = "route53-${local.name}"
  }
}

resource "aws_route53_record" "cloudfront_1" {
    zone_id = local.route53_zone_id
    name = local.cdn_domain_name
    type = "A"
    alias {
        name = aws_cloudfront_distribution.s3_distribution_1.domain_name
        zone_id = aws_cloudfront_distribution.s3_distribution_1.hosted_zone_id
        evaluate_target_health = false
    }
} */
# resource "aws_route53_record" "devs3-a" {
#     zone_id = local.route53_zone_id
#     name = "devs3.${var.domain_name}"
#     type = "A"
#     alias {
#         name = aws_cloudfront_distribution.devs3_s3_distribution.domain_name
#         zone_id = aws_cloudfront_distribution.devs3_s3_distribution.hosted_zone_id
#         evaluate_target_health = false
#     }
# }
/* data "aws_lb" "alb" {
    name = "014f04b3-jenkins-ingress-8202"
}
resource "aws_route53_record" "www-a" {
    zone_id = local.route53_zone_id
    name = "www.${var.domain_name}"
    type = "A"
    alias {
        name = data.aws_lb.alb.dns_name
        zone_id = data.aws_lb.alb.zone_id
        evaluate_target_health = false
    }
} */


################################################################################
# ACM 생성
/* ################################################################################
resource "aws_acm_certificate" "ssl_certificate" {
    #provider = aws.acm_provider
    domain_name = local.domain_name
    subject_alternative_names = ["*.${local.domain_name}"]
    validation_method = "DNS"
    tags = {
      Name = "acm-${local.name}"
      Env  = local.env_name
    }
    lifecycle {
      create_before_destroy = true
    }
}
resource "aws_route53_record" "main" {
    for_each = {
        for dvo in aws_acm_certificate.ssl_certificate.domain_validation_options : dvo.domain_name => {
            name = dvo.resource_record_name
            record = dvo.resource_record_value
            type = dvo.resource_record_type
        }
    }
    allow_overwrite = true
    zone_id = local.route53_zone_id
    name = each.value.name
    records = [each.value.record]
    type = each.value.type
    ttl = 60
}
resource "aws_acm_certificate_validation" "cert_validation" {
    #provider = aws.acm_provider
    certificate_arn = aws_acm_certificate.ssl_certificate.arn
    validation_record_fqdns = [for record in aws_route53_record.main : record.fqdn]
} */


################################################################################
# ACM 생성 for CloudFront
################################################################################
/* resource "aws_acm_certificate" "ssl_certificate_virginia" {
    provider = aws.virginia
    domain_name = local.domain_name
    subject_alternative_names = ["*.${local.domain_name}"]
    validation_method = "DNS"
    tags = {
      Name = "acm-${local.name}"
      Env  = local.env_name
    }
    lifecycle {
      create_before_destroy = true
    }
}
resource "aws_route53_record" "main_virginia" {
    for_each = {
        for dvo in aws_acm_certificate.ssl_certificate.domain_validation_options : dvo.domain_name => {
            name = dvo.resource_record_name
            record = dvo.resource_record_value
            type = dvo.resource_record_type
        }
    }
    allow_overwrite = true
    zone_id = local.route53_zone_id
    name = each.value.name
    records = [each.value.record]
    type = each.value.type
    ttl = 60
}
resource "aws_acm_certificate_validation" "cert_validation_virginia" {
    provider = aws.virginia
    certificate_arn = aws_acm_certificate.ssl_certificate_virginia.arn
    validation_record_fqdns = [for record in aws_route53_record.main : record.fqdn]
} */



# ################################################################################
# # CloudFront
# ################################################################################

/* resource "aws_cloudfront_distribution" "s3_distribution_1" {
  origin {
    domain_name               = aws_s3_bucket.bucket_1.bucket_regional_domain_name                                               # Origin Domain Name
    origin_id                 = local.bucket_name                                                                                  # CloudFront Name             
    s3_origin_config {
      origin_access_identity  = "origin-access-identity/cloudfront/${aws_cloudfront_origin_access_identity.oai_1.id}"            # OAI 설정     
    }
  }
  
  aliases = ["${local.cdn_domain_name}"]                     # 대체 도메인 설정
  http_version                = "http2"                            # HTTP 버전 기본값(http1.1, http2)
  enabled                     = true                               # Enduser가 해당 Distributiond을 사용할 수 있는지 여부
  is_ipv6_enabled             = true                               # IPv6 지원 설정
  
  # logging_config {
  #   include_cookies           = false                              # CloudFront Access Log에 쿠키 정보 포함 여부 설정
  #   bucket                    = aws_s3_bucket.                     # Log를 저장할 Bucket 설정
  #   prefix                    = "CF-${local.bucket_name}-Log/"       # 로그 파일의 접두사 설정
  # }


  default_cache_behavior {                                           # 기본 캐시 동작 설정
    compress                   = true                                # 특정 파일에 대한 자동 압축 설정            
    allowed_methods            = ["GET", "HEAD"]
    cached_methods             = ["GET", "HEAD"]
    target_origin_id           = local.bucket_name

    forwarded_values {
      query_string             = false
      headers                  = []

      cookies {
        forward                = "none"
      }
    }
  
  
  viewer_protocol_policy = "allow-all"
    min_ttl                    = 0
    default_ttl                = 3600
    max_ttl                    = 86400
  }
  
  restrictions {
    geo_restriction {
      restriction_type         = "none"
      locations                = []
    }
  }

  viewer_certificate {
    #cloudfront_default_certificate = true
    acm_certificate_arn = aws_acm_certificate.ssl_certificate_virginia.arn
    ssl_support_method  = "sni-only"
  }

} */



# resource "aws_s3_bucket_policy" "s3_policy_1" {       # 퍼블릭 버킷
#   bucket = aws_s3_bucket.bucket_1.id

#   policy = jsonencode({
  
#     Version = "2012-10-17"
#     Statement = [    
#       {
#         Sid       = "IPAllow"
#         Effect    = "Allow"
#         Principal = "*"
#         Action    = "s3:*"
#         Resource = [
#           aws_s3_bucket.bucket_1.arn,
#           "${aws_s3_bucket.bucket_1.arn}/*",
#         ]
#       },
#     ]
#   })
# }