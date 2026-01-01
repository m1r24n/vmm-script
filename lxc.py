#!/usr/bin/env python3
# this is to create lxc instances

import sys, pathlib, yaml, subprocess, json, os
from jinja2 import Template
import paramiko



def create_lxc(d1):
    # print("host ",d1['lxc_server']['host'])
    # print("list of lxc ",list(d1['lxc'].keys()))
    net0="""{% for p in ports %}
auto {{p.port}}
{% if p.ipv4 -%}
iface {{p.port}} inet static
    address {{ p.ipv4 }}
{% else -%}
iface {{p.port}} inet dhcp
{% endif -%}
    {% if p.gw4 -%}
    gateway {{ p.gw4 }}
    {% endif -%}
    mtu 1500
{% if p.ipv6 -%}
iface {{ p.port}} inet6 static
    address {{ p.ipv6 }}
    {% if p.gw6 -%}
    gateway {{ p.gw6 }}
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
  {{ p.port }}:
    name: {{ p.port }}
    nictype: bridged
    parent: {{ p.bridge }}
    {% if p.vlan -%}
    vlan: "{{ p.vlan }}"
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
            if 'br_type' in j.keys() and j['br_type'] == 'ovs':
                if j['bridge'] not in ovs_l:
                    if j['bridge'] not in lxc_ovs_br:
                        lxc_ovs_br.append(j['bridge'])
            elif 'br_type' in j.keys() and j['br_type'] != 'ovs':
                if j['bridge'] not in br_l:
                    if j['bridge'] not in lxc_lnx_br:
                        lxc_lnx_br.append(j['bridge'])
            elif j['bridge'] not in br_l:
                if j['bridge'] not in lxc_lnx_br:
                    lxc_lnx_br.append(j['bridge'])
    existing_lxc = list_lxc(d1)
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
    print(f"ovs bridge {lxc_ovs_br}")
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
        exit(1)
 
    cmd1.append("#!/bin/bash")
    cmd1.append("echo creating LXC")
    for i in list_of_lxc:
        cmd1.append(f"lxc copy {d1['lxc'][i]['type']} {i}")
        dt = {'ports': d1['lxc'][i]['ports']}
        pd2 = pd1.render(dt)
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
    cmd1 = 'ip link show type bridge | grep mtu | tr -d " " | cut -f 2 -d ":"'
    _,s2,_=ssh.exec_command(cmd1)
    # s2l = s2.split("\n")
    br_l = [ i.rstrip() for i in s2.readlines()]
    lxc_lnx_br =[]
    cmd1 = ""
    for i in d1['lxc'].keys():
        cmd1 += f"lxc stop {i};"
        cmd1 += f"lxc rm {i};"
        for j in d1['lxc'][i]['ports']:
            if 'br_type' in j.keys() and j['br_type'] != 'ovs':
                if j['bridge'] in br_l:
                    if j['bridge'] not in lxc_lnx_br:
                        lxc_lnx_br.append(j['bridge'])
            elif j['bridge'] in br_l:
                if j['bridge'] not in lxc_lnx_br:
                    lxc_lnx_br.append(j['bridge'])
    print("Deleting LXC")
    _,s2,_=ssh.exec_command(cmd1)
    print(cmd1)
    result = [ i.rstrip() for i in s2.readlines()]
    print(result)
    cmd1=""
    if lxc_lnx_br:
        print("Deleting linux bridge")
        for i in lxc_lnx_br:
            cmd1+= f"sudo ip link del dev {i};"
        _,s2,_=ssh.exec_command(cmd1)
        print(cmd1)
        result = [ i.rstrip() for i in s2.readlines()]
        print(result)
    ssh.close()


def list_bridge_old(d1):
    # cmd = ["ip","link", "show","type","bridge","|","grep","UP"]
    cmd = ["ip","link", "show","type","bridge"]
    result = subprocess.run(cmd, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    output1 = result.stdout
    o3 = []
    o2 = output1.split("\n")
    for i in o2:
        if "UP" in i:
            o3.append(i.replace(" ","").split(":")[1])
    cmd=["sudo", "ovs-vsctl","show"]
    result = subprocess.run(cmd, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    output1 = result.stdout
    o2 = output1.split("\n")
    for i in o2:
        if "Bridge" in i:
            o3.append(i.replace("Bridge","").replace(" ",""))
    # print(output1)
    #print(o3)
    o4=[]
    for i in d1['lxc'].keys():
        for j in d1['lxc'][i]['ports'].keys():
            br = d1['lxc'][i]['ports'][j]['bridge']
            if br not in o3 and br not in o4:
                o4.append(d1['lxc'][i]['ports'][j]['bridge'])
    if o4:
        print(f"creating bridge {o4}")
    for i in o4:
        cmd=["sudo", "ip", "link", "add", "dev", i,"type", "bridge"]
        result = subprocess.run(cmd, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        output1 = result.stdout
        cmd=["sudo", "ip", "link", "set", "dev",i,"up"]
        result = subprocess.run(cmd, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        output1 = result.stdout
        cmd=["sudo","sysctl","-w", f"net.ipv6.conf.{i}.disable_ipv6=1"]
        result = subprocess.run(cmd, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        output1 = result.stdout

def create_lxc_old(d1):
    cmd = ['lxc', 'ls','--format=json']
    result = subprocess.run(cmd, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    output1 = result.stdout
    d0 = json.loads(output1)
    list_of_images = [i['name'] for i in d0]
    t0="""
{% for i in intf %}
auto {{i}}
{% if intf[i].ipv4 -%}
iface {{i}} inet static
    address {{ intf[i].ipv4 }}
{% else -%}
iface {{i}} inet dhcp
{% endif -%}
    {% if intf[i].gw4 -%}
    gateway {{ intf[i].gw4 }}
    {% endif -%}
    mtu 1500
{% if intf[i].ipv6 -%}
iface {{i}} inet6 static
    address {{ intf[i].ipv6 }}
    {% if intf[i].gw6 -%}
    gateway {{ intf[i].gw6 }}
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
    t1 = Template(t0)
    frr1 = Template(frr0)
    dns1 = Template(dns0)
    # for i in d0:
    #     print(i['name'])
    # print(f"image {list_of_images}")
    list_of_lxc = d1['lxc'].keys()
    # checking image
    for i in list_of_lxc:
        cmd = ["lxc","copy",d1['lxc'][i]['type'],i]
        if d1['lxc'][i]['type'] not in list_of_images:
            print(f"image {d1['lxc'][i]['type']} for container {i} is not available")
        else:
            # src = {d1['lxc'][i]['type']} 
            #print(cmd)
            print(f"creating {i}")
            result = subprocess.run(cmd, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
            output1 = result.stdout
            ports = d1['lxc'][i]['ports'].keys()
            #print(f"lxc {i} ports {ports}")
            data1 = ["devices:"]
            net_cfg1=["intf:"]
            for p in ports:
                net_cfg1.append(f"  {p}:")
                if 'ipv4' in d1['lxc'][i]['ports'][p].keys():
                    net_cfg1.append(f"     ipv4: {d1['lxc'][i]['ports'][p]['ipv4']}")
                if 'gw4' in d1['lxc'][i]['ports'][p].keys():
                    net_cfg1.append(f"     gw4: {d1['lxc'][i]['ports'][p]['gw4']}")
                if 'gw6' in d1['lxc'][i]['ports'][p].keys():
                    net_cfg1.append(f"     gw6: {d1['lxc'][i]['ports'][p]['gw6']}")
                if 'ipv6' in d1['lxc'][i]['ports'][p].keys():
                    net_cfg1.append(f"     ipv6: {d1['lxc'][i]['ports'][p]['ipv6']}")
                             
                data1.append(f"  {p}:")
                data1.append(f"    name: {p}") 
                data1.append(f"    nictype: bridged")
                if 'bridge' not in d1['lxc'][i]['ports'][p].keys():
                    print(f"bridge for lxc {i} port {p} is not defined")
                    exit(1)
                data1.append(f"    parent: {d1['lxc'][i]['ports'][p]['bridge']}")
                if 'vlan' in d1['lxc'][i]['ports'][p].keys():
                    data1.append(f"    vlan: '{d1['lxc'][i]['ports'][p]['vlan']}'")
                data1.append(f"    type: nic")
            net_cfg2 = "\n".join(net_cfg1)
            net_cfg3 = yaml.load(net_cfg2,Loader=yaml.FullLoader)
            data2 = "\n".join(data1)
            data3 = yaml.load(data2,Loader=yaml.FullLoader)
            data4 = json.dumps(data3)
            data5 = f"{data4}"
            # print(data5)
            print("change container configuration")
            cmd = ["lxc","query", "--request", "PATCH", f"/1.0/instances/{i}","--data",data5]
            result = subprocess.run(cmd, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
            output1 = result.stdout
            net_cfg4 = t1.render(net_cfg3)
            with open("interfaces.tmp","w") as f1:
                f1.write(net_cfg4)
            cmd = ["lxc", "file" , "push", "interfaces.tmp",  f"{i}/etc/network/interfaces"]
            result = subprocess.run(cmd, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
            output1 = result.stdout
            os.remove("interfaces.tmp")
            if d1['lxc'][i]['type'] == "router":
                frr_data = d1['lxc'][i]['bgp']
                frr_cfg = frr1.render(frr_data)
                with open("frr.conf","w") as f1:
                    f1.write(frr_cfg)
                cmd = ["lxc", "file" , "push", "frr.conf",  f"{i}/etc/frr/frr.conf"]
                result = subprocess.run(cmd, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
                output1 = result.stdout
                os.remove("frr.conf")
                dns_data = d1['lxc'][i]['dnsmasq']
                dns_cfg = dns1.render(dns_data)
                with open("dnsmasq.conf","w") as f1:
                    f1.write(dns_cfg)
                cmd = ["lxc", "file" , "push", "dnsmasq.conf",  f"{i}/etc/dnsmasq.conf"]
                result = subprocess.run(cmd, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
                output1 = result.stdout
                os.remove("dnsmasq.conf")

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
