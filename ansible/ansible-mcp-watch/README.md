# MCP Watch Ansible installer
This will deploy the MCP watch components (including a local InfluxDB instance) to a server running Ubuntu.

To deploy:
* Enter your MCP username and password into the roles\Install-MCP-Watch\defaults\main.yml file
* Enter your server details into the inventory file
* run `ansible-playbook -i inventory site.yml`
* Once this has been installed, you will need to run the ingestion process to get some data into InfluxDB. Run the ingestion.yml playbook (`ansible-playbook -i inventory ingestion.yml`) to bring in data for the past hour. 
**Note:** this ingestion may take some time to run. If you want to run this for a different time period, specify this as variable like so: `ansible-playbook -i inventory -e ingestion_period=1w ingestion.yml`

* To get access to the data, install Grafana and point the datasource to the deployed server : http://server:8086/mcp
* the default username and password for the mcp database is 'root' - you probably want to change this in the config.py file..

For more information on how to use MCP Watch, and detailed documentation please see : <https://github.com/bernard357/mcp-watch/blob/master/README.md>