#!/bin/bash

#
# Copyright 2016, Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.
#

source ../jmm.sh

data=$(jmm test $JMMPATH/src/github/com/jminusminus/jmmscripts)
if [[ "$data" != "Pre Test"* && "$data" != *"Post Test" ]]; then
	echo "script jmm test failed"
	echo "$data"
	exit 1
fi

data=$(jmm test cover $JMMPATH/src/github/com/jminusminus/jmmscripts)
if [[ "$data" != "Pre Test"* && "$data" != *"Post Test" ]]; then
	echo "script jmm test cover failed"
	echo "$data"
	exit 1
fi

data=$(jmm install $JMMPATH/src/github/com/jminusminus/jmmscripts)
if [[ "$data" != "Pre Install"* && "$data" != *"Post Install" ]]; then
	echo "script jmm install failed"
	echo "$data"
	exit 1
fi

data=$(jmm run-script $JMMPATH/src/github/com/jminusminus/jmmscripts foo)
if [[ "$data" != "Foo" ]]; then
	echo "script jmm run-script [abspath] [foo] failed"
	echo "$data"
	exit 1
fi

cd $JMMPATH/src/github/com/jminusminus
data=$(jmm run-script jmmscripts foo)
if [[ "$data" != "Foo" ]]; then
	echo "script jmm run-script [relpath] [foo] failed"
	echo "$data"
	exit 1
fi

cd $JMMPATH/src/github/com/jminusminus/jmmscripts
data=$(jmm run-script foo)
if [[ "$data" != "Foo" ]]; then
	echo "script jmm run-script [foo] failed"
	echo "$data"
	exit 1
fi

exit 0
