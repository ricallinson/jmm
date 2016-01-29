#!/bin/bash

#
# Copyright 2016, Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.
#

source ../jmm.sh
data=$(jmm env)
if [ "${data:0:8}" = "JMMPATH=" ]; then
	exit 0
fi
echo "No JMMPATH found."
exit 1
