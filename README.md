# dd-mcp-automation
Automation for Dimension Data's Managed Cloud Platform

A series of automation activities tested on Dimension Data's Managed Cloud Platform 2.0 designed to help people get up and running as fast as possible.

# **Ansible**

## ansible-secure-instance
This will secure a linux instance deployed using the provided images on MCP. 
At present this will do the following:
* Creates a new user (and adds them to sudoers with passwordless sudo)
* Adds a SSH key for the newly created user account
* Disables empty password login
* Disables remote root login
* Disables password login

This will help secure the default linux instances. Tested on Centos 7

## ansible-docker-dc
This will deploy Docker Datacenter to DD MCP 2.0. Please see the README for more details
