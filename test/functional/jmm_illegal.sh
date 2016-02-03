#!/bin/bash

#
# Copyright 2016, Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.
#

source ../jmm.sh
data=$(jmm install $JMMPATH/src/github/com/jminusminus/jmmillegal)
if [ "$data" = "Illegal package: java.util.Date;" ]; then
	exit 0
fi
echo "Illegal package not found."
exit 1
