output "group_names" {
  description = "List of IAM group names managed by Terraform"
  value       = module.iam_groups.group_names
}
