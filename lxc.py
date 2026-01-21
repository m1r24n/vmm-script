#!/usr/bin/env python3
# this is to create lxc instances

import sys, pathlib, yaml, subprocess, json, os
from jinja2 import Template
import paramiko, pprint



def create_lxc(d1):
    # print("host ",d1['lxc_server']['host'])
    # print("list of lxc ",list(d1['lxc'].keys()))
    net0="""{% for p in ports %}
auto {{p}}
{% if ports[p].ipv4 -%}
iface {{p}} inet static
    address {{ ports[p].ipv4 }}
{% else -%}
iface {{p}} inet dhcp
{% endif -%}
    {% if ports[p].gw4 -%}
    gateway {{ ports[p].gw4 }}
    {% endif %}
    mtu 1500
{% if ports[p].ipv6 -%}
iface {{ p}} inet6 static
    address {{ ports[p].ipv6 }}
    {% if ports[p].gw6 -%}
    gateway {{ ports[p].gw6 }}
    {% endif -%}
{% endif -%}
{% endfor -%}
    """
    frr0="""
ipv6 forwarding
!
interface eth1
ipv6 nd prefix {{nd_prefix}}
no ipv6 nd suppress-ra
exit
router bgp {{asn}}
no bgp ebgp-requires-policy
neighbor {{peerv4}} remote-as {{peerasn}}
neighbor {{peerv6}} remote-as {{peerasn}}
!
address-family ipv4 unicast
network {{advv4}}
exit-address-family
!
address-family ipv6 unicast
network {{advv6}}
neighbor {{peerv6}} activate
exit-address-family
exit
!
    """
    dns0="""
dhcp-range={{range}},255.255.255.0,2h
dhcp-option=option:router,{{router}}
dhcp-option=option:dns-server,{{dns}}
domain=local.lan
local=/local.lan/
    """
    pd0 = """
devices:
  {% for p in ports -%}
  {{ p }}:
    name: {{ p}}
    nictype: bridged
    parent: {{ ports[p].bridge }}
    {% if ports[p].vlan -%}
    vlan: "{{ ports[p].vlan }}"
    {% endif -%}
    type: nic
  {% endfor -%}
"""
    pd1 = Template(pd0)
    net1 = Template(net0)
    frr1 = Template(frr0)
    dns1 = Template(dns0)
    print("Creating LXC")
    ssh=paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(hostname=d1['lxc_server']['host'],username=d1['lxc_server']['user'],password=d1['lxc_server']['password'])
    cmd1 = 'sudo ovs-vsctl show | grep Bridge| sed -e "s/Bridge//"| tr -d " "'
    _,s2,_=ssh.exec_command(cmd1)
    # s2l = s2.split("\n")
    ovs_l = [ i.rstrip() for i in s2.readlines()]
    cmd1 = 'ip link show type bridge | grep mtu | tr -d " " | cut -f 2 -d ":"'
    _,s2,_=ssh.exec_command(cmd1)
    br_l = [ i.rstrip() for i in s2.readlines()]
    print(f"opevnswitch {ovs_l}")
    print(f"linux_bridge {br_l}")
    lxc_ovs_br  = []
    lxc_lnx_br = []
    for i in d1['lxc'].keys():
        for j in d1['lxc'][i]['ports']:
            if 'type' in  d1['lxc'][i]['ports'][j].keys() and d1['lxc'][i]['ports'][j]['type'] == 'ovs':
                if d1['lxc'][i]['ports'][j]['bridge'] not in ovs_l:
                    lxc_ovs_br.append(d1['lxc'][i]['ports'][j]['bridge'])
                #print(f" lxc {i} port {j} bridge {d1['lxc'][i]['ports'][j]['bridge']}")
            elif 'type'  not in  d1['lxc'][i]['ports'][j].keys():
                if d1['lxc'][i]['ports'][j]['bridge'] not in br_l and d1['lxc'][i]['ports'][j]['bridge'] not in lxc_lnx_br:
                    lxc_lnx_br.append(d1['lxc'][i]['ports'][j]['bridge'] )

            # j = d1['lxc'][i]['ports'][k]
            # if 'type' in j.keys() and j['type'] == 'ovs':
            #     if j['bridge'] not in ovs_l:
            #         if j['bridge'] not in lxc_ovs_br:
            #             lxc_ovs_br.append(j['bridge'])
            # elif 'type' in j.keys() and j['type'] != 'ovs':
            #     if j['bridge'] not in br_l:
            #         if j['bridge'] not in lxc_lnx_br:
            #             lxc_lnx_br.append(j['bridge'])
            # elif j['bridge'] not in br_l:
            #     if j['bridge'] not in lxc_lnx_br:
            #         lxc_lnx_br.append(j['bridge'])
    # for i in d1['lxc'].keys():
    #exit(1)
    print(f"lxc_ovs_br {lxc_ovs_br}")
    print(f"lxc_lnx_br{lxc_lnx_br}")
    existing_lxc = list_lxc(d1)
    print(existing_lxc)
    #exit(1)
    list_of_lxc = d1['lxc'].keys()
    lxc_src = []
    for i in list_of_lxc:
        if d1['lxc'][i]['type'] not in lxc_src:
            lxc_src.append(d1['lxc'][i]['type'] )
    if not existing_lxc:
        print(f"source LXC {lxc_src} are not available")
        exit(1)
    stat_src = 1
    for i in lxc_src:
        if i not in existing_lxc:
            print(f"source LXC {i} is not available")
            stat_src = 0
    if not stat_src:
        exit(1)
    print("source LXC are ok")
    print("bridge used by lxc")
    print(f"ovs bridge {ovs_l}")
    print(f"linux bridge {lxc_lnx_br}")
    if lxc_ovs_br:
        for i in lxc_ovs_br:
            print(f"OpenvSwitch {i} is not defined")
        exit(1)
    if lxc_lnx_br:
        print("creating linux bridge")
        cmd1=""
        for i in lxc_lnx_br:
            cmd1+=f"sudo ip link add dev {i} type bridge;"
            cmd1+=f"sudo ip link set dev {i} up;"
        #print(cmd1)
        _,s2,_=ssh.exec_command(cmd1)
        result= [ i.rstrip() for i in s2.readlines()]
    else:
        print("bridge exists")
    cmd1 =[]
    
    lxc_temp = []
    for i in list_of_lxc:
        if i in existing_lxc:
            lxc_temp.append(i)

    if lxc_temp:
        for i in lxc_temp:
            print(f"LXC {i} already exists")
    cmd1.append("#!/bin/bash")
    cmd1.append("echo creating LXC")
    for i in list_of_lxc:
        cmd1.append(f"lxc copy {d1['lxc'][i]['type']} {i}")
        dt = {'ports': d1['lxc'][i]['ports']}
        pd2 = pd1.render(dt)
        print(pd2)
        pd3 = yaml.load(pd2,Loader=yaml.FullLoader)
        # pd4 = json.dumps(pd3).replace('"','\\"')
        pd4 = json.dumps(pd3)
        cmd = f"lxc query --request PATCH /1.0/instances/{i} --data '{pd4}'"
        cmd1.append(cmd)
        net2 = net1.render(dt)
        cmd=f"cat << EOF | tee /tmp/net.{i}"
        cmd1.append(cmd)
        cmd1.append(net2)
        cmd1.append("EOF")
        cmd1.append(f"lxc file push /tmp/net.{i} {i}/etc/network/interfaces")
        if 'bgp' in d1['lxc'][i].keys():
            bgp = d1['lxc'][i]['bgp']
            frr2 = frr1.render(bgp)
            cmd=f"cat << EOF | tee /tmp/frr.{i}"
            cmd1.append(cmd)
            cmd1.append(frr2)
            cmd1.append("EOF")
            cmd1.append(f"lxc file push /tmp/frr.{i} {i}/etc/frr/frr.conf")
        if 'dnsmasq' in d1['lxc'][i].keys():
            dns = d1['lxc'][i]['dnsmasq']
            dns2 = dns1.render(dns)
            cmd=f"cat << EOF | tee /tmp/dns.{i}"
            cmd1.append(cmd)
            cmd1.append(dns2)
            cmd1.append("EOF")
            cmd1.append(f"lxc file push /tmp/dns.{i} {i}/etc/dnsmasq.conf")

        #print(f"LXC {i}")
        #print(net2)

    # writing command to file
    cmd2 = "\n".join(cmd1)
    with open('/tmp/run1.sh',"w") as f1:
        f1.write(cmd2)
    os.chmod("/tmp/run1.sh",0o744)
    sftp=ssh.open_sftp()
    sftp.put("/tmp/run1.sh","/tmp/run1.sh")
    print("executing script")
    cmd1 = "bash /tmp/run1.sh"
    _,s2,_=ssh.exec_command(cmd1)
    result = [ i.rstrip() for i in s2.readlines()]
    print(result)
    ssh.close()

def delete_lxc(d1):
    ssh=paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(hostname=d1['lxc_server']['host'],username=d1['lxc_server']['user'],password=d1['lxc_server']['password'])
    # cmd1 = 'ip link show type bridge | grep mtu | tr -d " " | cut -f 2 -d ":"'
    # _,s2,_=ssh.exec_command(cmd1)
    # # s2l = s2.split("\n")
    # br_l = [ i.rstrip() for i in s2.readlines()]
    # lxc_lnx_br =[]
    # cmd1 = ""
    # for i in d1['lxc'].keys():
    #     cmd1 += f"lxc stop {i};"
    #     cmd1 += f"lxc rm {i};"
    #     for j in d1['lxc'][i]['ports']:
    #         if 'type' in j.keys() and j['type'] != 'ovs':
    #             if j['bridge'] in br_l:
    #                 if j['bridge'] not in lxc_lnx_br:
    #                     lxc_lnx_br.append(j['bridge'])
    #         elif j['bridge'] in br_l:
    #             if j['bridge'] not in lxc_lnx_br:
    #                 lxc_lnx_br.append(j['bridge'])
    #lxc_ovs_br  = []
    lxc_lnx_br = []
    cmd1 = ""
    for i in d1['lxc'].keys():
        for j in d1['lxc'][i]['ports']:
            if 'type' not in  d1['lxc'][i]['ports'][j].keys():
                if d1['lxc'][i]['ports'][j]['bridge'] not in lxc_lnx_br:
                    lxc_lnx_br.append(d1['lxc'][i]['ports'][j]['bridge'])
        cmd1 += f"lxc stop {i};lxc rm {i};"
        for j in lxc_lnx_br:
            cmd1 += f"sudo ip link del dev {j};"
    print("Deleting LXC")
    _,s2,_=ssh.exec_command(cmd1)
    print(cmd1)
    result = [ i.rstrip() for i in s2.readlines()]
    print(result)
    # cmd1=""
    # if lxc_lnx_br:
    #     print("Deleting linux bridge")
    #     for i in lxc_lnx_br:
    #         cmd1+= f"sudo ip link del dev {i};"
    #     _,s2,_=ssh.exec_command(cmd1)
    #     print(cmd1)
    #     result = [ i.rstrip() for i in s2.readlines()]
    #     print(result)
    ssh.close()

def list_lxc(d1):
    retval=[]
    ssh=paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(hostname=d1['lxc_server']['host'],username=d1['lxc_server']['user'],password=d1['lxc_server']['password'])
    cmd1 = 'lxc ls --format=json'
    _,s2,_=ssh.exec_command(cmd1)
    # s2l = s2.split("\n")
    result = [ i.rstrip() for i in s2.readlines()]
    d0=json.loads(result[0])
    # print(type(d0))
    # print(len(d0))
    ssh.close()
    for i in d0:
        retval.append(i['name'])
    return retval


def start_lxc(d1):
    ssh=paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(hostname=d1['lxc_server']['host'],username=d1['lxc_server']['user'],password=d1['lxc_server']['password'])
    cmd1=[]
    for i in d1['lxc'].keys():
        cmd = f"lxc start {i}"
        cmd1.append(cmd)
    cmd2 = ';'.join(cmd1)
    _,s2,_=ssh.exec_command(cmd2)
    result = [ i.rstrip() for i in s2.readlines()]
    print(result)
    ssh.close()

def stop_lxc(d1):
    ssh=paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(hostname=d1['lxc_server']['host'],username=d1['lxc_server']['user'],password=d1['lxc_server']['password'])
    cmd1=[]
    for i in d1['lxc'].keys():
        cmd = f"lxc stop {i}"
        cmd1.append(cmd)
    cmd2 = ';'.join(cmd1)
    _,s2,_=ssh.exec_command(cmd2)
    result = [ i.rstrip() for i in s2.readlines()]
    print(result)
    ssh.close()
    
def check_arg(argv):
    list_of_cmd=["create","start","delete","stop","del","lbr","list"]
    if len(argv) < 3:
        print("lxc.py <config_file> [command] )")
        exit(1)
    file1 = argv[1]
    cmd1 = argv[2]
    filepath = pathlib.Path(file1)
    if not filepath.exists() or not filepath.is_file():
        print(f"file {file1} is not a file or doesn't exist")
        exit(1)
    print(f"reading {file1}")
    with open(file1) as f1:
        d0 = f1.read()
    d1 = yaml.load(d0,Loader=yaml.FullLoader)
    if cmd1 not in list_of_cmd:
        print(f"command {cmd1} is not yet implemented")
        exit(1)
    d1['cmd']=cmd1
    return d1

# main function
d1 = check_arg(sys.argv)
#pprint.pprint(d1)
if d1['cmd']=='create':
    create_lxc(d1)
if d1['cmd'] in ['del','delete']:
    delete_lxc(d1)
if d1['cmd']=='start':
    start_lxc(d1)
if d1['cmd']=='stop':
    stop_lxc(d1)
if d1['cmd']=='list':
    list_lxc(d1)
# if d1['cmd']=='lbr':
#     list_bridge(d1)
