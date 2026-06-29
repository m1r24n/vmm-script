#!/usr/bin/env python3
import sys
import os
import lib1
import time
# yaml.warnings({'YAMLLoadWarning': False})


time_start = time.time()
config1=lib1.check_argv(sys.argv)
if config1:
	# print("configuration ",config1)
	d1=lib1.read_config(config1)
	#print(d1)
	#d1={}
	#print(f"config {config1['cmd']} {config1['vm']}")
	#print(d1['template'])
	if d1:
		if config1['cmd'] == 'upload':
			lib1.upload(d1)
		elif config1['cmd'] == 'start':
			lib1.start(d1)
		elif config1['cmd'] == 'lsbr':
			lsbr=lib1.list_bridge(d1)
			print(lsbr)
		elif config1['cmd'] == 'stop':
			print('stop topology on vmm')
			lib1.stop(d1)
		elif config1['cmd'] == 'list':
			lib1.list_vm(d1)
		elif config1['cmd'] == 'set_gw':
			if 'gw_type' in d1['pod'].keys():
				if d1['pod']['gw_type'] == 1:
					set_gw = lib1.set_gw_v1
				elif d1['pod']['gw_type'] == 2:
					set_gw = lib1.set_gw_v2
			else:
				set_gw = lib1.set_gw_v2
			set_gw(d1)
		elif config1['cmd'] == 'set_host':
			lib1.set_host(d1,config1['vm'])
		elif config1['cmd'] == 'ssh_config':
			lib1.write_ssh_config(d1)
		elif config1['cmd'] == 'get_vjunos_mac':
			lib1.get_vjunos_mac(d1)
		elif config1['cmd'] == 'print_data':
			lib1.print_data(d1)
		elif config1['cmd'] == 'get_wg_config':
			lib1.get_wg_config(d1)
		elif config1['cmd'] == 'get_serial':
			lib1.get_serial(d1)
		elif config1['cmd']=='lxc-create':
			lib1.create_lxc(d1)
			lib1.start_lxc(d1)
		elif config1['cmd'] in ['lxc-del','lxc-delete']:
			lib1.delete_lxc(d1)
		elif config1['cmd']=='lxc-start':
			lib1.start_lxc(d1)
		elif config1['cmd']=='lxc-stop':
			lib1.stop_lxc(d1)
		elif config1['cmd']=='lxc-list':
			print(f"list of LXC: {lib1.list_lxc(d1)}")
			lib1.list_bridge(d1)
		else:
			print("wrong argument")
	else:
		print("data is not available")
	time_end=time.time()
	print("script run for %d seconds" %(time_end-time_start))
else:
	pass
