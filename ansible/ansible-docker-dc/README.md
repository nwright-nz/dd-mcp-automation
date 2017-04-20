Deployment of Docker Datacenter
-------------------------------

This playbook setup a cluster of hosts running:
* Docker Engine CS
* Universal Control Plane
* Docker Trusted Registry

Inventory
---------

The inventory.ini file defines the host the server needs to be deployed on

The following example of inventory.ini file defines:
- 3 UCP controller (the main manager is identified with ucp_manager=1, the replicas are identified with ucp_replica=1)
- 3 UCP workers
- 3 DTR manager (the main manager is identified with dtr_manager=1, the replicas are identified with dtr_replica=1)

```
[ucp_managers]
192.168.0.230 ucp_manager=1
192.168.0.231 ucp_replica=1
192.168.0.232 ucp_replica=1

[ucp_workers]
192.168.0.233 dtr_manager=1
192.168.0.234 dtr_replica=1
192.168.0.235 dtr_replica=1

[ucp:children]
ucp_managers
ucp_workers

[dtr:children]
ucp_workers

[dtr:vars]
replica_id=13b873dfa912
```

Notes:
- the nodes are structured in groups. Only the IP addresses within the ucp_managers and ucp_workers needs to be set.
- the replica_id within the dtr:vars group is a random value that is used to setup DTR, you can leave it or pick another one.




Split the installation
----------------------

In order to monitor the installation process, the commands can be splitted in 3 using tags:

```
ansible-playbook -i inventory.ini -t engine [OPTS] main.yml
ansible-playbook -i inventory.ini -t ucp [OPTS] main.yml
ansible-playbook -i inventory.ini -t dtr [OPTS] main.yml
```

Using the application
---------------------

Once installed, the application can be access on the following URLs

Application | URL | Comments
------------| --- | --------
UCP         | https://ucp[0] | admin / ucppassword
DTR         | https://dtr[0] |

Disclaimer
----------

This playbook is dedicated to have Docker Datacenter up and runnin, in HA mode, g within a matter of minutes.
This playbook should not be used as it is for production setup though.


License
-------

The MIT License (MIT)

Copyright (c) [2016]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
