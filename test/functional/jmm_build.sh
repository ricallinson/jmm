#!/bin/bash
source ../jmm.sh
jar=$(jmm build $JMMPATH/src/github/com/ricallinson/jmmbuild)
if [ -e "$jar" ]; then
	data=$(jmmbuild)
	if [ "$data" = "Hello world." ]; then
		exit 0
	fi
	echo "Jar '$jar' did not execute."
	exit 1
fi
echo "File '$jar' not created."
exit 1
