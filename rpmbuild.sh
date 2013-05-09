#!/usr/bin/env bash
# [WARNING]
#    be aware the hypervisor kernel version, so here  we adopt openvswitch-1.4.3 
#

set -x 
TOP_DIR=$(pwd)

# clean iT
for f in $(find . -maxdepth 1 -name "openvswitch-*")
do
     rm -rf $f
done

# download openvswitch tarball
OPENVSWITCH_TARBALL=openvswitch-1.4.3.tar.gz
wget http://openvswitch.org/releases/${OPENVSWITCH_TARBALL}

# extract it
tar zxvf ${OPENVSWITCH_TARBALL}

cd ${OPENVSWITCH_TARBALL%".tar.gz"}

# generate config file 
sh boot.sh

# fix the config file
sed -i '16a ovs_cv_xsversion=5.6.100'  configure
./configure --with-linux=/lib/modules/$(uname -r)/build
./configure --prefix=/usr --localstatedir=/var


# compile 
make 

# make distribution tarball 
make dist 


# copy 
mv ${OPENVSWITCH_TARBALL} /usr/src/redhat/SOURCES


# <openvswitch version> is the version number that appears in the
#    name of the Open vSwitch tarball, e.g. 0.90.0.
VERSION=$(echo ${OPENVSWITCH_TARBALL} | egrep -o '([0-9]+\.){2}[0-9]+')


# <Xen Kernel name> is the name of the Xen Kernel,
#    e.g. kernel-xen or kernel-NAME-xen. By convention, the name
#    starts with "kernel-" and ends with "-xen".
#    This can be obtained by executing 
#        'rpm -q --queryformat "%{Name}" kernel.*xen'
#    with the "kernel-" stripped out using  sed 's/kernel-//'
#    e.g. kernel-NAME-xen => NAME-xen
KERNEL_NAME=$(rpm -q --qf "%{name}" kernel-xen | sed 's/kernel-//')

# <Xen Kernel version> is the output of:
#    rpm -q --queryformat "%{Version}-%{Release}" kernel.*xen-devel
#    e.g. 2.6.32.12-0.7.1.xs5.6.100.323.170596 
KERNEL_VERSION=$(rpm -q --qf "%{version}-%{release}" kernel-xen-devel)

# <Xen Kernel flavor (suffix) > is either "xen" or "kdump".
#    The "xen" flavor is the main running kernel flavor and the "kdump" flavor is
#    the crashdump kernel flavor. Commonly, one would specify "xen" here.
KERNEL_FLAVOR=xen


cd /tmp
tar zxvf /usr/src/redhat/SOURCES/openvswitch-${VERSION}.tar.gz
rpmbuild \
     -D "openvswitch_version ${VERSION}" \
     -D "kernel_name ${KERNEL_NAME}" \
     -D "kernel_version ${KERNEL_VERSION}" \
     -D "kernel_flavor ${KERNEL_FLAVOR}" \
     -bb openvswitch-${VERSION}/xenserver/openvswitch-xen.spec


cd /usr/src/redhat/RPMS/i386/
TAR_DIR=xenserver-5.6sp2
TAR=ovs-xenserver-5.6sp2.tar.gz
if [ -d ${TAR_DIR} ]; then
    rm -rf ${TAR_DIR}
fi
mkdir ${TAR_DIR}
mv *.rpm ${TAR_DIR}
tar zcvf ${TAR} ${TAR_DIR}
mv ${TAR} ${TOP_DIR}

