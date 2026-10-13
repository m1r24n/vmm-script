# install python package

    pip3 install --index-url https://vmm-cloud.englab.juniper.net/pypi/simple vmm-cloud


# login into vmm
    vmm-api auth 


# config the topology

    vmm-api config -c <config_file> -g vmm-default

# bind the topology
    vmm-api bind -tid <topology_id> 


# start the topology 

    vmm-api start -tid <topology_id>

# all in one command 

     vmm-api launch -c <config_file> -g vmm-default --wait

# list topo

    vmm-api topo_name --display-all
    