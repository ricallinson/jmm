#!/bin/bash

#
# Copyright 2016, Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.
#

source ../jmm.sh
data=$(jmm run $JMMPATH/src/github/com/javaminusminus/jmmrun/RunClass.java $JMMPATH/src/github/com/javaminusminus/jmmrun/OtherClass.java)
if [ "$data" = "Hello world." ]; then
	exit 0
fi
echo "Jar did not output 'Hello world': $data"
exit 1
