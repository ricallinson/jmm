#!/bin/bash

#
# Copyright 2016, Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.
#

source ../jmm.sh
jmm test cover $JMMPATH/src/github/com/jminusminus/jmmtest/TestClass_test.java
if [[ ! -f "$JMMPATH/coverage/index.html" ]]; then
	echo $?
	echo "Coverage file not found."
	exit 1
fi
exit 0
