#!/bin/bash
source ../jmm.sh
jar=$(jmm build $JMMPATH/src/github/com/ricallinson/jmmbuild)
if [ -e "$jar" ]; then
	jmm clean
	if [ -e "$jar" ]; then
		echo "Jar '$jar' did not get removed."
		exit 1
	fi
	exit 0
fi
echo "File '$jar' not created."
exit 1
