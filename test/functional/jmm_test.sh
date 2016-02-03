#!/bin/bash

#
# Copyright 2016, Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.
#

source ../jmm.sh
$(jmm test $JMMPATH/src/github/com/jminusminus/jmmtest/TestClass_test.java)
if [[ $? -gt 0 ]]; then
	echo $?
	echo "Test failed !pass."
	exit 1
fi
$(jmm test $JMMPATH/src/github/com/jminusminus/jmmtest/sub/SubTestClass_test.java)
if [[ $? -eq 0 ]]; then
	echo $?
	echo "Test failed !fail."
	exit 1
fi
$(jmm test $JMMPATH/src/github/com/jminusminus/jmmtest)
if [[ $? -gt 1 ]]; then
	echo $?
	echo "Test failed !pass and !fail."
	exit 1
fi
exit 0
