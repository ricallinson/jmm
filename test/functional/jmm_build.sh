#!/bin/bash
source ../jmm.sh
jar=$(jmm build $JMMPATH/src/github/com/ricallinson/jmmbuild)
if [ -e "$jar" ]; then
	data=$(java -jar $jar)
	if [ "$data" = "Hello world." ]; then
		exit 0
	fi
	echo "Jar did not execute."
	exit 1
fi
echo "File '$jar' not created."
exit 1
