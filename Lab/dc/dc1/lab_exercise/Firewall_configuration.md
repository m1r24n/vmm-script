# basis configuration fw1/fw2

set system host-name fw2
set system root-authentication encrypted-password "$1$X.Q52Yjv$qOBjPbq6AzlCCOGW/8ki7."
set system login user admin class super-user
set system login user admin authentication encrypted-password "$6$wXEML3m7$iFDcokpuGRfSumXK1d/UwhAM1H6Ge72hVSIFz/SwOeNh1ssw4seHJO6WaDLyran0Xog6NBv5LdJ0Jd1jE7oPS0"
set system services ssh root-login allow
set system services ssh sftp-server
set system services netconf ssh
set system management-instance
set interfaces fxp0 unit 0 family inet dhcp
