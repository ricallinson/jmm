#!/bin/bash

#
# Copyright 2016, Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.
#

source ../jmm.sh

data=$(jmm test $JMMPATH/src/github/com/jminusminus/jmmscripts)
if [[ "$data" != "Pre Test"* && "$data" != *"Post Test" ]]; then
	echo "script jmm test"
	echo "$data"
	exit 1
fi

data=$(jmm test cover $JMMPATH/src/github/com/jminusminus/jmmscripts)
if [[ "$data" != "Pre Test"* && "$data" != *"Post Test" ]]; then
	echo "script jmm test cover"
	echo "$data"
	exit 1
fi

exit 0
