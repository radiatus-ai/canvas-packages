output "instance" {
  value = {
    id                 = google_sql_database_instance.default.id
    connection_name    = google_sql_database_instance.default.connection_name
    public_ip_address  = google_sql_database_instance.default.public_ip_address
    private_ip_address = google_sql_database_instance.default.private_ip_address
  }
}
