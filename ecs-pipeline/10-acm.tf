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
}
