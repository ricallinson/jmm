#!/bin/bash

#
# Copyright 2016, Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.
#

source ../jmm.sh
packageDir=$JMMPATH/src/github/com/jminusminus/jmmexample
if [ -d $packageDir ]; then
	rm -rf $packageDir
fi
jmm get github.com/jminusminus/jmmexample
if [ ! -d $packageDir ]; then
	echo "Package was not downloaded."
	exit 1
fi
rm -rf $packageDir
exit 0
