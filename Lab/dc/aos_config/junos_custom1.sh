#!/bin/sh
cli -c "configure; set system commit synchronize; set chassis evpn-vxlan-default-switch-support; set chassis fpc 0 pic 0 number-of-ports 12; commit and-quit"

