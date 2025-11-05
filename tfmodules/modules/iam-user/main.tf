variable "user_names" {
  description = "List of IAM users"
  type        = list(string)
}

variable "group_names" {
  description = "List of IAM groups users should belong to"
  type        = list(string)
}

variable "existing" {
  type        = bool
  default     = false
  description = "Set true if the IAM users already exist"
}

resource "aws_iam_user" "this" {
  for_each = toset(var.existing ? [] : var.user_names)
  name     = each.key
  force_destroy = true
}

resource "aws_iam_user_group_membership" "this" {
  for_each = { for u in var.user_names : u => u }

  user = var.existing ? each.value : aws_iam_user.this[each.key].name
  groups = var.group_names
}

output "user_names" {
  value = var.user_names
}
