variable "username" {
    default = "username"
    description = "MCP user name"
}

variable "password" {
    default = "password"
    description = "MCP Password"
}

variable "region" {
    default = "AU"
    description = "MCP Region to use (Default is AU)"
}



variable "network_domain_name" {
    default = "my-network-domain-name"
    description = "MCP network domain name"
}



variable "network_domain_description" {
    default = "Test domain - stood up with Terraform"
}

variable "datacenter" {
    default = "AU11"
    description = "Datacenter to deploy resources to"
}

variable "vlan_name" {
    default = "temp-vlan-terraform"
}

variable "vlan_base_address" {
    default = "192.168.17.0"
}

variable "vlan_ipv4_prefix" {
    default = "24"
}

variable "server_count" {
    default = "3"
}

variable "server_name_prefix" {
    default = "terraform-dev"
}

variable "memory" {
    default = "4"
    description = "Memory size (GB)"
}

variable "cpu" {
    default = "2"
    description = "CPU Count"
}

variable "image" {
    default = "CentOS 7 64-bit 2 CPU"
    description = "Default Image name"
}

variable "dns_primary" {
    default = "8.8.8.8"
}

variable "dns_secondary" {
    default = "8.8.4.4"
}

variable "incoming_firewall_rule_name" {
    default = "my_server.HTTP.inbound"
}

variable "incoming_firewall_rule_port" {
    default = "80"
}

