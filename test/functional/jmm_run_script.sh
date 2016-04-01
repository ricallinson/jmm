#!/bin/bash

#
# Copyright 2016, Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.
#

source ../jmm.sh

data=$(jmm run-script test1)
if [ "$data" != "Test 1: " ]; then
	echo "Test1 did not execute correctly"
	echo "$data"
	exit 1
fi

data=$(jmm run-script test1 a b c)
if [ "$data" != "Test 1: a b c" ]; then
	echo "Test1 with args did not execute correctly"
	echo "$data"
	exit 1
fi

data=$(jmm run-script test2.sh)
if [ "$data" != "Test 2: " ]; then
	echo "Test1 did not execute correctly"
	echo "$data"
	exit 1
fi

data=$(jmm run-script test2.sh a b c)
if [ "$data" != "Test 2: a b c" ]; then
	echo "Test2 with args did not execute correctly"
	echo "$data"
	exit 1
fi

exit 0
