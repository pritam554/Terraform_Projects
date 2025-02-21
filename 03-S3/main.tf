resource "aws_s3_bucket" "pbanik78567857969" {

	bucket = "${var.bucket_name}"
	acl = "private"

	versioning {
		enabled = true
	}
}