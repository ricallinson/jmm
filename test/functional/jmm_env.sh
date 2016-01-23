#!/bin/bash
source ../jmm.sh
data=$(jmm env)
if [ "${data:0:8}" = "JMMPATH=" ]; then
	exit 0
fi
echo "No JMMPATH found."
exit 1
