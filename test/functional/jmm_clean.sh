#!/bin/bash
source ../jmm.sh
jmm build $JMMPATH/src/github/com/ricallinson/jmmbuild
jmm clean
if [ -e "$JMMPATH/bin/jmmbuild" ]; then
	echo "Jar 'jmmbuild.jar' did not get removed."
	exit 1
fi
exit 0
