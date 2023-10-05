package main

import future.keywords.if
import data.baseline.aws.s3
import data.baseline.aws.common

default allow := false

allow if {
  s3.baseline_valid
}

result["allowed"] := allow
result["violations"] := s3.violations | common.violations
