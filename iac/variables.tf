variable "aws_region" {
  description = "(Required) AWS region in which the resources should be created"
  type        = string
}
variable "tags" {
  description = "(Optional) Default tags"
  type        = map(string)
}
