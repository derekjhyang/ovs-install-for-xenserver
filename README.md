ovs-install-for-xenserver
=========================
WARNING
     you MUST run this project in the Xenserver5.6.100sp2 DDK with Hotfix XS56ESP2002
     (http://support.citrix.com/article/CTX130729)
     
# Installation-1
1. BOOT the Xenserver DDK
2. git clone the project
3. ./run_rpmbuild.sh
4. generate a rpm tarbll 
5. then scp to ""Xenserver 5.6.100sp2 with Hotfix XS56ESP2002"" to install rpm tarball
6. extract the rpm tarball
7. rpm -U *.rpm to upgrade the openvswitch
8. ovs-vsctl -V to show its version.


# Installation-2
1. ./install_rpm.sh 


