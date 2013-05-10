#!/bin/sh

./rpmbuild.sh 2>&1 | tee installation-log

# install python fabric for bulk installation
if [[ ! $(pip freeze | grep -i 'fabric') =~ '(f|F)abric' ]];then
    pip install fabric
    echo "[INFO] fabric is installed."
fi

