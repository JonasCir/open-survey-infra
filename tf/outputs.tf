output "data_aws_sdp_ec2_ip" {
  value = [
    aws_instance.sdp.public_dns,
    aws_instance.sdp.public_ip
  ]
}
