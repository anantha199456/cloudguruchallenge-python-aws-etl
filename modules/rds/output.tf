output "rds_hostname" {
  value = aws_db_instance.covid19_db.address
}
output "rds_port" {
  value = aws_db_instance.covid19_db.port
}
output "rds_db_name" {
  value = aws_db_instance.covid19_db.name
}
output "rds_db_username" {
  value = aws_db_instance.covid19_db.username
}
output "rds_db_password" {
  value = aws_db_instance.covid19_db.password
}