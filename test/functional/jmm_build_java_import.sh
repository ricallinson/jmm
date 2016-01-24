#!/bin/bash
source ../jmm.sh
jar=$(jmm build $JMMPATH/src/github/com/ricallinson/jmmjava)
if [ -e "$jar" ]; then
	data=$(jmmjava)
	if [ "${data:13:4}" = "Here" ]; then
		exit 0
	fi
	echo "Jar '$jar' did not execute."
	exit 1
fi
echo "File '$jar' not created."
exit 1
