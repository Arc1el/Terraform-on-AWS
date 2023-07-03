resource "aws_s3_bucket" "bucket_1" {
  bucket         = "${local.bucket_name}"                                 # 생성할 버킷의 이름을 설정합니다. (생략 시 랜덤 이름)
  #acl            = "private"                                                   # 기본값, 사전에 준비된 acl을 선택할 수 있습니다.(https://docs.aws.amazon.com/AmazonS3/latest/userguide/acl-overview.html#canned-acl)
  # versioning {
  #   enabled = true
  # }

  tags = {
    Env = local.env_name
  }
}

# ################################################################################
# OAI
# ################################################################################
resource "aws_cloudfront_origin_access_identity" "oai_1" {
  #comment = "Accept"
}

# ################################################################################
# # Bucket Policy
# ################################################################################

resource "aws_s3_bucket_policy" "s3_policy_1" {
  bucket = aws_s3_bucket.bucket_1.id

  policy = jsonencode({
  
    Version = "2012-10-17"
    Statement = [    
      {
        Sid       = "OAI"
        Effect    = "Allow"
        Principal = {"AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.oai_1.id}"}
        Action    = "s3:GetObject"
        Resource = [
          aws_s3_bucket.bucket_1.arn,
          "${aws_s3_bucket.bucket_1.arn}/*",
        ]
      },
    ]
  })
}


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