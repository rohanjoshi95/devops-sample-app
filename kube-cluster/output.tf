output "Master_public_ip" {
  value = aws_instance.my-test-instance.public_ip
}
output "Worker_public_ip" {
  value = aws_instance.my-test-instance2.public_ip
}
