package main

import data.baseline.aws.common
import data.baseline.aws.s3
import future.keywords.if

default allow := false

allow if {
	s3.baseline_valid
	# sqs.baseline_valid
	# ec2.baseline_valid etc...
}

result["allowed"] := allow

result["violations"] := s3.violations # | sqs.violations | ec2.violations etc...
