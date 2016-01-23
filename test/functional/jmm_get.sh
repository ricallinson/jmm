#!/bin/bash
source ../jmm.sh
packageDir=$JMMPATH/src/github/com/ricallinson/jmmimporttest
if [ -d $packageDir ]; then
	rm -rf $packageDir
fi
jmm get github.com/ricallinson/jmmimporttest
if [ -d $packageDir ]; then
	exit 0
fi
echo "Package was not downloaded."
exit 1
