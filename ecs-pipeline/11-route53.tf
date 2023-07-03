locals {
  /* 기존에 route53_zone 이 생성되어 있는 경우 */
  create_route53_zone = false
  route53_zone_id = "Z07944031UQG8BIM8ILPY"

  /* 신규로 route53_zone 을 생성 시 */
  //create_route53_zone = true
  //route53_zone_id = element(aws_route53_zone.main.*.zone_id, 0) 

  domain_name = "hyeon.cloud"

}

################################################################################
# Route 53 생성
################################################################################
resource "aws_route53_zone" "main" {
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
}

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