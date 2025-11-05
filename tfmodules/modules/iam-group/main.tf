variable "group_names" {
  type        = list(string)
  description = "List of IAM group names"
}

variable "existing" {
  type        = bool
  default     = false
  description = "Set true if the IAM groups already exist"
}

variable "policy_arns" {
  type        = list(string)
  default     = []
  description = "List of AWS managed policy ARNs to attach"
}

resource "aws_iam_group" "this" {
  for_each = toset(var.existing ? [] : var.group_names)
  name     = each.value
}

resource "aws_iam_group_policy_attachment" "this" {
  count      = var.existing ? 0 : length(var.policy_arns)
  group      = aws_iam_group.this[0].name
  policy_arn = var.policy_arns[count.index]
}

output "group_names" {
  value = var.group_names
}
