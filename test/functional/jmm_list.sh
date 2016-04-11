#!/bin/bash

#
# Copyright 2016, Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.
#

source ../jmm.sh
data=$(jmm list $JMMPATH/src/github/com/jminusminus/jmmrecursiveimport)
if [[ "$data" == *".jmmrecursiveimport.sub.SecondClass"* ]] && [[ "$data" == *".jmmrecursiveimport.FirstClass"* ]]; then
	echo ""
else
	echo "Test did not execute."
	exit 1
fi
data=$(jmm list $JMMPATH/src/github/com/jminusminus/jmminstall/BuildClass.java)
if [[ "$data" == "github.com.jminusminus.jmminstall"* ]]; then
	echo ""
else
	echo "Test did not execute."
	exit 1
fi
exit 0
