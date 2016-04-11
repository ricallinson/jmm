#!/bin/bash

#
# Copyright 2016, Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.
#

source ../jmm.sh

mkdir ./jmmtest
cd ./jmmtest
jmm here .
jmm get github.com/jminusminus/jmmexample
data=$(jmm doc github.com.jminusminus.jmmexample.Helloworld)
cd ..
rm -rf ./jmmtest

if [[ "$data" != *"# Helloworld"* ]] || [[ "$data" != *"## github.com.jminusminus.jmmexample.Helloworld"* ]]; then
	echo "$data"
	exit 1
fi
exit 0
