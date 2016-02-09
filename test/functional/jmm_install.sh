#!/bin/bash

#
# Copyright 2016, Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.
#

source ../jmm.sh
jmm install $JMMPATH/src/github/com/jminusminus/jmminstall
data=$(jmminstall)
if [[ "$data" != "Hello world." ]]; then
	echo "Jar 'jmminstall' did not execute without slash."
	exit 1
fi

jmm install $JMMPATH/src/github/com/jminusminus/jmminstall/
data=$(jmminstall)
if [[ "$data" != "Hello world." ]]; then
	echo "Jar 'jmminstall' did not execute with slash."
	exit 1
fi
exit 0
