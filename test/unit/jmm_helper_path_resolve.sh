#!/bin/bash

#
# Copyright 2016, Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.
#

source ../jmm.sh

path="./tmp"
data=$(jmm_helper_path_resolve $path)
if [[ "$data" != "$(pwd)${path:1}" ]]; then
	echo "Wrong path: $data"
	exit 1
fi

path="~/tmp"
data=$(jmm_helper_path_resolve $path)
if [[ "$data" != "$HOME${path:1}" ]]; then
	echo "Wrong path: $data"
	exit 1
fi

path="/tmp"
data=$(jmm_helper_path_resolve $path)
if [[ "$data" != "$path" ]]; then
	echo "Wrong path: $data"
	exit 1
fi

path="tmp"
data=$(jmm_helper_path_resolve $path)
if [[ "$data" != "$(pwd)/$path" ]]; then
	echo "Wrong path: $data"
	exit 1
fi

exit 0
