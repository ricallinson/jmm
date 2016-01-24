#!/bin/bash
source ../jmm.sh
jmm build $JMMPATH/src/github/com/ricallinson/jmmbuild
data=$(jmmbuild)
if [ "$data" = "Hello world." ]; then
	exit 0
fi
echo "Jar 'jmmbuild' did not execute."
exit 1
