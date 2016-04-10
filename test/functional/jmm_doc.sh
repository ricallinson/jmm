#!/bin/bash

#
# Copyright 2016, Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.
#

source ../jmm.sh
error=$((0))
data=$(jmm doc github.com.jminusminus.jmmdoc.DocTest)
if [ "$data" != "goo" ]; then
	echo $data
	error=$((1))
fi
rm -rf "$JMMPATH/src/github/com/jminusminus/doc"
rm -rf "$JMMPATH/src/github/com/jminusminus/simplebdd"
rm -rf "$JMMPATH/src/github/com/ricallinson"
exit error
