#!/usr/bin/env python3
import sys
# import os
import lib4
import time
# yaml.warnings({'YAMLLoadWarning': False})
time_start = time.time()
config1=lib4.check_argv(sys.argv)
if config1:
	# print("configuration ",config1)
	d1=lib4.read_config(config1)
	#print(d1)
	#d1={}
	#print(f"config {config1['cmd']} {config1['vm']}")
	#print(d1['template'])
	if d1:
		if config1['cmd'] == 'start':
			lib4.start(d1)
		elif config1['cmd'] in ['list_topo','ls_topo']:
		 	lib4.list_topo(d1)
		elif config1['cmd'] == 'stop':
			print('stop topology on vmm')
			lib4.stop(d1)
		elif config1['cmd'] == 'set_gw':
			lib4.set_gw_v3(d1)
		elif config1['cmd'] == 'set_host':
			lib4.set_host(d1,config1['vm'])
		elif config1['cmd'] == 'ssh_config':
			lib4.write_ssh_config(d1)
		elif config1['cmd'] == 'rewrite_lab':
			lib4.rewrite_lab_yaml(d1)
		elif config1['cmd'] in ['set_srx','set_vsrx']:
			lib4.set_srx(d1)
		else:
			print("wrong argument")
	else:
		print("data is not available")
	time_end=time.time()
	print("script run for %d seconds" %(time_end-time_start))
else:
	pass
			 
		# if config1['cmd'] == 'upload':
		# 	lib4.upload(d1)
		# elif config1['cmd'] == 'create':
		# 	lib4.upload(d1,upload_status=0)
		# elif config1['cmd'] == 'start':
		# 	lib4.upload(d1)
		# 	lib4.start(d1)
		# elif config1['cmd'] == 'lsbr':
		# 	lsbr=lib4.list_bridge(d1)
		# 	print(lsbr)
		# elif config1['cmd'] == 'stop':
		# 	print('stop topology on vmm')
		# 	lib4.stop(d1)
		# elif config1['cmd'] == 'list':
		# 	lib4.list_vm(d1)
		# elif config1['cmd'] == 'auth':
		# 	lib4.vmm_cloud_auth(d1)
		# elif config1['cmd'] in ['list_topo','ls_topo']:
		# 	lib4.list_topo(d1)
		# elif config1['cmd'] == 'set_gw':
		# 	if 'gw_type' in d1['pod'].keys():
		# 		if d1['pod']['gw_type'] == 1:
		# 			set_gw = lib4.set_gw_v1
		# 		elif d1['pod']['gw_type'] == 2:
		# 			set_gw = lib4.set_gw_v2
		# 		elif d1['pod']['gw_type'] == 3:
		# 			set_gw = lib4.set_gw_v3
		# 	else:
		# 		set_gw = lib4.set_gw_v3
		# 	set_gw(d1)
		# elif config1['cmd'] == 'set_host':
		# 	lib4.set_host(d1,config1['vm'])
		# elif config1['cmd'] in ['set_srx','set_vsrx']:
		# 	if d1['pod']['type'] == 'vmm':
		# 		if len(sys.argv) != 3: 
		# 			print("vmm key is not included")
		# 			print("usage: ")
		# 			print("vmm.py set_srx <vmm_key>")
		# 		else:
		# 			vmm_key = sys.argv[2]
		# 			lib4.set_srx(d1,vmm_key)
		# 	elif d1['pod']['type'] == 'cloud':
		# 		lib4.set_srx(d1)
		# elif config1['cmd'] == 'ssh_config':
		# 	lib4.write_ssh_config(d1)
		# elif config1['cmd'] == 'rewrite_lab':
		# 	lib4.rewrite_lab_yaml(d1)
		# elif config1['cmd'] == 'get_vjunos_mac':
		# 	lib4.get_vjunos_mac(d1)
		# elif config1['cmd'] == 'print_data':
		# 	lib4.print_data(d1)
		# elif config1['cmd'] == 'get_wg_config':
		# 	lib4.get_wg_config(d1)
		# elif config1['cmd'] == 'get_serial':
		# 	lib4.get_serial(d1)
		# elif config1['cmd']=='lxc-create':
		# 	lib4.create_lxc(d1)
		# 	lib4.start_lxc(d1)
		# elif config1['cmd'] in ['lxc-del','lxc-delete']:
		# 	lib4.delete_lxc(d1)
		# elif config1['cmd']=='lxc-start':
		# 	lib4.start_lxc(d1)
		# elif config1['cmd']=='lxc-stop':
		# 	lib4.stop_lxc(d1)
		# elif config1['cmd']=='lxc-list':
		# 	print(f"list of LXC: {lib4.list_lxc(d1)}")
		# 	lib4.list_bridge(d1)
		# else:
		# 	print("wrong argument")
	# else:
	# 	print("data is not available")
	# time_end=time.time()
	# print("script run for %d seconds" %(time_end-time_start))
# else:
# 	pass
