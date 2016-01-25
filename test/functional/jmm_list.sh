#!/bin/bash
source ../jmm.sh
data=$(jmm list $JMMPATH/src/github/com/ricallinson/jmminstall)
if [[ "$data" != *"github.com.ricallinson.jmminstall"* ]] && [[ "$data" != *"github.com.ricallinson.jmminstall.sub"* ]]; then
	echo "Test did not execute."
	exit 1
fi
data=$(jmm list $JMMPATH/src/github/com/ricallinson/jmminstall/BuildClass.java)
if [[ "$data" != "github.com.ricallinson.jmminstall"* ]]; then
	echo "Test did not execute."
	exit 1
fi
exit 0
