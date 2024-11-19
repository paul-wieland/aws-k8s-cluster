output "vpc_id" {
  value = aws_vpc.k8s-vpc.id
}

output "cluster_name" {
  value = aws_vpc.k8s-vpc.tags["Name"]
}
