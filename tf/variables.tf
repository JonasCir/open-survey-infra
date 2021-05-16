# default tags with static values
variable "default_tags" {
  default = {
    created_by = "terraform"
    tf_plan    = "sdp"
    tf_module  = "unknown"
    Name       = "unknown"
    # Owner      = "<SOME_NAME>" // IMPORTANT: also used as filter in the AWS Cost Explorer
  }
}
