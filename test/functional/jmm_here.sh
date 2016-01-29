#!/bin/bash

#
# Copyright 2016, Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.
#

source ../jmm.sh
data=$(jmm here "/jmm")
if [ "${data:1:4}" != "This" ]; then
	echo "Workspace found in wrong location."
	exit 1
fi

mkdir -p ./tmp
data=$(jmm here ./tmp)
if [ ! -d ./tmp/src ]; then
	rm -rf ./tmp
	echo $data
	echo "New workspace ./tmp was not created."
	exit 1
fi
rm -rf ./tmp
exit 0
