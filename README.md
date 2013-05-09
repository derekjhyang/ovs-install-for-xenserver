ovs-install-for-xenserver
=========================
WARNING
     you MUST run this project in the Xenserver5.6.100sp2 DDK with Hotfix XS56ESP2002
     (http://support.citrix.com/article/CTX130729)
     
# Step
1. ./install.sh
2. generate a rpm tarbll 
3. then scp to Xenserver 5.6.100sp2 with Hotfix XS56ESP2002 to install rpm
4. extract the tarball
5. rpm -U *.rpm to upgrade the openvswitch
6. ovs-vsctl -V to show its version.
