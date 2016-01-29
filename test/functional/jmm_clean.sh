#!/bin/bash

#
# Copyright 2016, Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.
#

source ../jmm.sh
jmm install $JMMPATH/src/github/com/javaminusminus/jmminstall
jmm clean
if [ -e "$JMMPATH/bin/jmminstall" ]; then
	echo "Jar 'jmminstall.jar' did not get removed."
	exit 1
fi
exit 0
