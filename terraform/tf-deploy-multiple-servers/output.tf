output "ip" {
  value = "${join(",",ddcloud_server.my-server.*.primary_adapter_ipv4)}"
}