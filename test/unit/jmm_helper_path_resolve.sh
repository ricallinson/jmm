#!/bin/bash
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
