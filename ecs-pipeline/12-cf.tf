locals {

  ##################
  # CloudFront
  ##################
  bucket_name = "bhoh-peteasy-s3" 
  cdn_domain_name = "cdn.hyeon.cloud" 
}
################################################################################
# ACM 생성 for CloudFront
################################################################################
resource "aws_acm_certificate" "ssl_certificate_virginia" {
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
}



# ################################################################################
# # CloudFront
# ################################################################################

resource "aws_cloudfront_distribution" "s3_distribution_1" {
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

}
