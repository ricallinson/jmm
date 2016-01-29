#!/bin/bash

#
# Copyright 2016, Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.
#

source ../jmm.sh
data=$(jmm version)
if [ "$data" = "$JMMVERSION" ]; then
	exit 0
fi
echo "No version returned."
exit 1
