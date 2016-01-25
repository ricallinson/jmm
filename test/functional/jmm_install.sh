#!/bin/bash
source ../jmm.sh
jmm install $JMMPATH/src/github/com/ricallinson/jmminstall
data=$(jmminstall)
if [ "$data" = "Hello world." ]; then
	exit 0
fi
echo "Jar 'jmminstall' did not execute."
exit 1
