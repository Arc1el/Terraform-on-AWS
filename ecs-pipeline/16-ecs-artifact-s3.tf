resource "aws_s3_bucket" "bucket-artifact" {
  bucket = local.codepipeline_artifact_bucket
}