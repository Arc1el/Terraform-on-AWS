resource "aws_s3_bucket" "bucket_1" {
  bucket         = "${local.bucket_name}"
  #acl            = "private"
  # versioning {
  #   enabled = true
  # }
  tags = {
    Env = local.env_name
  }
}
resource "aws_cloudfront_origin_access_identity" "oai_1" {
  #comment = "Accept"
}
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