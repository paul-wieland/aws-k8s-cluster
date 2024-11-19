output "instances" {
  value = [
    for instance in aws_instance.node : {
      host_name  = instance.tags["Name"]
      public_ip  = instance.public_ip
      private_ip = instance.private_ip
    }
  ]
}