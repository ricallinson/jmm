#!/bin/bash
source ../jmm.sh
data=$(jmm list $JMMPATH/src/github/com/ricallinson/jmmbuild)
if [[ "$data" != *"github.com.ricallinson.jmmbuild"* ]] && [[ "$data" != *"github.com.ricallinson.jmmbuild.sub"* ]]; then
	echo "Test did not execute."
	exit 1
fi
data=$(jmm list $JMMPATH/src/github/com/ricallinson/jmmbuild/BuildClass.java)
if [[ "$data" != "github.com.ricallinson.jmmbuild"* ]]; then
	echo "Test did not execute."
	exit 1
fi
exit 0
