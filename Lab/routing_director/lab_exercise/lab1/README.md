# Lab Exercise 1


## Create Network Implementation Plan (NIP) and onboarding device on Routing Director, using GUI

1. Access web dashboard of Routing director, http://172.16.12.1

2. if Organization is not yet created, create one, for example create an organization called **vmm** or **lab**

3. Navigate to **Inventory** > **Sites**, and click **+** to create a site. Create 10 sites for all the vJunosRouter nodes.

4. Navigate to **Inventory** > **Network Implementation Plan**, and click **+** to create a new NIP

5. Click **next** to add device, and click **+**. Set the device name, site, serial number, vendor, and model.

6. To get the serial number of the devices, use this shell script [get_sernum.sh](./get_sernum.sh) or use ansible-playbook [get_sernum.yaml](ansible/get_sernum.yaml) 

7. Navigate to **Inventory** > **Network Inventory**, and click **add device**, copy the cli command

8. Open ssh session into node **pe1**, and paste the cli command into the configuration mode.

9. Repeat step 7 for all the vJunosRouter nodes (PE2, PE3, PE4, PE5, P1, P2, P3, P4, and P5)
11. Routing Director will start the onboarding process.
12. Navigate to **Inventory** > **Network Inventory**, and wait until all devices status become **Ready for Service**
13. Navigate to **Inventory** > **Onboarding Dashboar**, select all devices and click **Put into Service**
14. Now you can start playing around with Routing Director


## Create Network Implementation Plan (NIP) and onboarding devices on Routing Director, using API

### create token to access routing director using API
1. edit file [rd.sh](API/rd.sh), set the parameter (RD's IP address, login admin, and password)
2. source file [rd.sh](API/rd.sh)

       cd API
       source rd.sh

3. run script [create_token.py](API/create_token.py)

       ./create_token.sh

4. source file [token.sh](API/token.sh)

       source ./token.sh

### create organization using API

1. Create environment variable ORG_NAME with the organization name that you want to create

       export ORG_NAME=vmmlab

2. Run script [create_org.py](API/create_org.py), to create organzation on Routing director

       ./create_org.py

3. Source file [org.sh](API/org.sh) to import ORG-ID

       source org.sh

### create sites and get sites ID into yaml file
1. Edit file [sites.yaml](API/sites.yaml), to define the sites which will be created on routing director (name, address, coordinate (latlng), and country_code)

       cd API
       vi sites.yaml
2. run script [create_sites.py](API/create_sites.py) to create sites in routing director.

       cd API
       ./create_sites.py

3. login into routing director dashboard to verify that sites has been create
4. run script [get_sites_id.py](API/get_sites_id.py) to create yaml file with the list of sites and its ID. It will create a yaml file [sites_id.yaml](data/sites_id.yaml)

       ./get_sites_id.py

### retrieve serial number of all junos nodes
1. Run ansible script [get_sernum][ansible/get_sernum.yaml]

        cd ansible
        ansible-playbook get_sernum.yaml

2. it will create a file [nodes_sernum.yaml](data/nodes_sernum.yaml)

        cd ../data
        cat nodes_sernum.yaml

### Create NIP (Network implementation plan)
1. edit file [nodes.yaml](create_NIP/nodes.yaml), to define interfaces of the nodes (connection to other nodes or access)

       nodes:
          pe1:
            interfaces:
            - name: ge-0/0/0
              link: Link_PE1_P1
            - name: ge-0/0/1
              link: Link_PE1_P2
            - name: ge-0/0/2
              access: yes
            - name: ge-0/0/3
              access: yes
            - name: ge-0/0/4
              access: yes
          p11:
            interfaces:
            - name: ge-0/0/0
              link: Link_PE1_P1
            - name: ge-0/0/1
              link: Link_PE2_P2
        
       
       for the exampleabove, it defines two nodes, PE1, and P1

       PE1 has five interfaces, ge-0/0/0 and ge-0/0/1 are connected to another nodes, and ge-0/0/2, ge-0/0/3, ge-0/0/4 are defined as access interface

       P1 has five interfaces, ge-0/0/0 and ge-0/0/1 are connected to another nodes

2. create NIP (Network implementation plan) json file using script [create_nip.py](create_NIP/create_nip.py)

       cd create_NIP
       ./create_nip.py NIP1.json  # NIP1.json is the filename of the NIP file

3. The NIP file is stored on directory [data](data/)

       cd data
       ls -la

4. Upload NIP json file into routing director using WebUI Dashboard

### onboard devices into Routing director
1. use script [get_outbound_ssh_cmd.py](API/get_outbound_ssh_cmd.py) to retrieve onboarding script from Routing director

       cd API
       ./get_outbound_ssh_cmd.py

2. This script will create a file [onboarding.set](ansible/onboarding.set) in directory ansible
3. Run ansible script [onboarding.yaml](ansible/onboarding.yaml) to upload onboarding script into network devices

       cd ansible
       ansible-playbook onboarding.yaml

4. on Routing director Dashboard, on **Network Inventory** > **Inventory**,  monitor the onboarding status
5. Once all devices has been onboarded (ready for service), go to **Onboarding Dashboard** > **Put devices into service**, and put all devics into service  
