output "route_table_id" {
  value = var.is_public ? aws_route_table.public_route_table[0].id : aws_route_table.private_route_table[0].id
}