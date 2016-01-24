#!/bin/bash
source ../jmm.sh
jmm build $JMMPATH/src/github/com/ricallinson/jmmjava
data=$(jmmjava)
if [ "${data:13:4}" = "Here" ]; then
	exit 0
fi
echo "Jar 'jmmjava' did not execute."
exit 1
