#!/bin/bash
source ../jmm.sh
data=$(jmm version)
if [ "$data" = "$JMMVERSION" ]; then
	exit 0
fi
echo "No version returned."
exit 1
