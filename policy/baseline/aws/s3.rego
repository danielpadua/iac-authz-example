package baseline.aws.s3

import future.keywords.if
import input as tfplan

baseline_valid if {
	s3_bucket_public_access__changes := [r | r := tfplan.resource_changes[_]; r.type == "aws_s3_bucket_public_access_block"]
	s3_bucket_server_side_encryption_configuration__changes := [r | r := tfplan.resource_changes[_]; r.type == "aws_s3_bucket_server_side_encryption_configuration"]
	s3_bucket_versioning__changes := [r | r := tfplan.resource_changes[_]; r.type == "aws_s3_bucket_versioning"]

	s3__public_access_disabled(s3_bucket_public_access__changes)
	s3__bucket_cryptography_enabled(s3_bucket_server_side_encryption_configuration__changes)
	s3__bucket_versioning_enabled(s3_bucket_versioning__changes)
}

violations["S3 - Bucket should block all public access"] {
	s3_bucket_public_access__changes := [r | r := tfplan.resource_changes[_]; r.type == "aws_s3_bucket_public_access_block"]
	not s3__public_access_disabled(s3_bucket_public_access__changes)
}

violations["S3 - Bucket should be encrypted"] {
	s3_bucket_server_side_encryption_configuration__changes := [r | r := tfplan.resource_changes[_]; r.type == "aws_s3_bucket_server_side_encryption_configuration"]
	not s3__bucket_cryptography_enabled(s3_bucket_server_side_encryption_configuration__changes)
}

violations["S3 - Bucket should be versioned"] {
	s3_bucket_versioning__changes := [r | r := tfplan.resource_changes[_]; r.type == "aws_s3_bucket_versioning"]
	not s3__bucket_versioning_enabled(s3_bucket_versioning__changes)
}

########################################################
# Baseline: S3 - Bucket should block all public access #
########################################################
s3__public_access_disabled(s3_bucket_public_access__changes) if {
	s3_bucket_public_access__changes[_].change.after.block_public_acls == true
	s3_bucket_public_access__changes[_].change.after.block_public_policy == true
	s3_bucket_public_access__changes[_].change.after.ignore_public_acls == true
	s3_bucket_public_access__changes[_].change.after.restrict_public_buckets == true
}

#############################################
# Baseline: S3 - Bucket should be encrypted #
#############################################
s3__bucket_cryptography_enabled(s3_bucket_server_side_encryption_configuration__changes) if {
	s3_bucket_server_side_encryption_configuration__changes[_].change.after.rule[_].apply_server_side_encryption_by_default[_].sse_algorithm == "AES256"
}

s3__bucket_cryptography_enabled(s3_bucket_server_side_encryption_configuration__changes) if {
	s3_bucket_server_side_encryption_configuration__changes[_].change.after.rule[_].apply_server_side_encryption_by_default[_].sse_algorithm == "aws:kms"
	s3_bucket_server_side_encryption_configuration__changes[_].change.after.rule[_].apply_server_side_encryption_by_default[_].kms_master_key_id != ""
}

s3__bucket_cryptography_enabled(s3_bucket_server_side_encryption_configuration__changes) if {
	s3_bucket_server_side_encryption_configuration__changes[_].change.after.rule[_].apply_server_side_encryption_by_default[_].sse_algorithm == "aws:kms:dsse"
	s3_bucket_server_side_encryption_configuration__changes[_].change.after.rule[_].apply_server_side_encryption_by_default[_].kms_master_key_id != ""
}

#############################################
# Baseline: S3 - Bucket should be versioned #
#############################################
s3__bucket_versioning_enabled(s3_bucket_versioning__changes) if {
	lower(s3_bucket_versioning__changes[_].change.after.versioning_configuration[_].status) == "enabled"
}
