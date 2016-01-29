#!/bin/bash

#
# Copyright 2016, Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.
#

source ../jmm.sh
jmm install $JMMPATH/src/github/com/javaminusminus/jmmjava
data=$(jmmjava)
if [ "$data" == "101" ]; then
	exit 0
fi
echo "Jar 'jmmjava' did not execute."
exit 1
