output "instance" {
  value = {
    id                 = google_sql_database_instance.main.id
    connection_name    = google_sql_database_instance.main.connection_name
    public_ip_address  = google_sql_database_instance.main.public_ip_address
    private_ip_address = google_sql_database_instance.main.private_ip_address
  }
}
