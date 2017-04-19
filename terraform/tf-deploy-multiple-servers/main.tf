/*
 * This configuration will create multiple servers running CentOS 7
 */

provider "ddcloud" {
  # User name and password can also be specified via MCP_USER and MCP_PASSWORD environment variables.
  "username"           = "${var.username}"
  "password"           = "${var.password}" # Watch out for escaping if your password contains characters such as "$".
  "region"             = "${var.region}" # The DD compute region code (e.g. "AU", "NA", "EU")
}

resource "ddcloud_networkdomain" "my-domain" {
  name                 = "${var.network_domain_name}"
  description          = "${var.network_domain_description}"
  datacenter           = "${var.datacenter}" # The ID of the data centre in which to create your network domain.
}

resource "ddcloud_vlan" "my-vlan" {
  name                 = "${var.vlan_name}"
  description          = "This is my Terraform test VLAN."

  networkdomain        = "${ddcloud_networkdomain.my-domain.id}"

  # VLAN's default network: 192.168.17.1 -> 192.168.17.254 (netmask = 255.255.255.0)
  ipv4_base_address    = "${var.vlan_base_address}"
  ipv4_prefix_size     = "${var.vlan_ipv4_prefix}"

  depends_on           = [ "ddcloud_networkdomain.my-domain"]
}

resource "ddcloud_server" "my-server" {
  name                 = "${var.server_name_prefix}-${count.index}"
  count                = "${var.server_count}"
  auto_start                = "true"
  description          = "This is my Terraform test server."
  admin_password       = "password"

  memory_gb            = "${var.memory}"
  cpu_count            = "${var.cpu}"

  networkdomain        = "${ddcloud_networkdomain.my-domain.id}"

  primary_network_adapter = {
    vlan               = "${ddcloud_vlan.my-vlan.id}"
  }

  dns_primary          = "${var.dns_primary}"
  dns_secondary        = "${var.dns_secondary}"

  image                = "${var.image}"

  # The image disk (part of the original server image). If size_gb is larger than the image disk's original size, it will be expanded (specifying a smaller size is not supported).
  # You don't have to specify this but, if you don't, then Terraform will keep treating the ddcloud_server resource as modified.
  disk {
    scsi_unit_id       = 0
    size_gb            = 10
  }

  # An additional disk.
  disk {
    scsi_unit_id       = 1
    size_gb            = 20
  }

  depends_on           = [ "ddcloud_vlan.my-vlan" ]
}

resource "ddcloud_nat" "my-server-nat" {
  count = "${var.server_count}"
  networkdomain       = "${ddcloud_networkdomain.my-domain.id}"
  #private_ipv4        = ${element(${ddcloud_server.my-server.primary_adapter_ipv4}"
  private_ipv4        = "${element(ddcloud_server.my-server.*.primary_adapter_ipv4, count.index)}"

  # public_ipv4 is computed at deploy time.

  depends_on          = [ "ddcloud_vlan.my-vlan" ]
  }

resource "ddcloud_firewall_rule" "my-vm-http-in" {
  count               = "${var.server_count}"
  name                = "${var.incoming_firewall_rule_name}.${count.index}"
  placement           = "first"
  action              = "accept" # Valid values are "accept" or "drop."
  enabled             = true

  ip_version          = "ipv4"
  protocol            = "tcp"

  # source_address is computed at deploy time (not specified = "any").
  # source_port is computed at deploy time (not specified = "any).
  # You can also specify source_network (e.g. 10.2.198.0/24) or source_address_list instead of source_address.
  # For a ddcloud_vlan, you can obtain these values using the ipv4_baseaddress and ipv4_prefixsize properties.

  # You can also specify destination_network or destination_address_list instead of source_address.
  destination_address = "${element(ddcloud_nat.my-server-nat.*.public_ipv4, count.index)}"
  destination_port_list    = "${ddcloud_port_list.mgmt.id}"
  networkdomain       = "${ddcloud_networkdomain.my-domain.id}"
}


resource "ddcloud_port_list" "mgmt" {
  name        = "mgmt"
  description = "Management (HTTP, HTTPS and SSH)"
  networkdomain       = "${ddcloud_networkdomain.my-domain.id}"

  port {
      begin = 80
  }

  port {
      begin = 443
  }
  port {
    begin = 22
  }
}

