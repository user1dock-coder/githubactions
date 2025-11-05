module "iam_groups" {
  source       = "../../../../tfmodules/modules/iam-group"
  group_names  = var.group_names
  existing    = true
}
