provider "aws" {
	region = var.aws-region
}

resource "aws_s3_bucket" "terraform_state" {
	bucket = var.bucket-name

	# enable versioning - revision history of state files
	versioning {
		enabled = true
	}

	# self-explanatory
	server_side_encryption_configuration {
		rule {
			apply_server_side_encryption_by_default {
				sse_algorithm = "AES256"
			}
		}
	}
}

resource "aws_dynamodb_table" "terraform_locks" {
	name = var.dynamodb-table-name
	billing_mode = "PAY_PER_REQUEST"
	hash_key = "LockID"

	attribute {
		name = "LockID"
		type = "S"
	}
}

# after running init and apply
# terraform {
# 	backend "s3" {
# 		# bucket
# 		bucket = "new-s3-bucket-for-tf-backend"
# 		key = "global/s3/terraform.tfstate"
# 		region = "us-east-1"

# 		# table with locks
# 		dynamodb_table = "new-dynamodb-for-tf-state-locks"
# 		encrypt = true
# 	}
# }

# output "s3_bucket_arn" {
# 	value = aws_s3_bucket.terraform_state.arn
# 	description = "ARN of the TF state S3 bucket"
# }

# output "dynamodb_table_name" {
# 	value = aws_dynamodb_table.terraform_locks.name
# 	description = "Table name for DynamoDB locks table"
# }
