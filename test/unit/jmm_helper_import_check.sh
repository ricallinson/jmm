#!/bin/bash

#
# Copyright 2016, Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.
#

source ../jmm.sh

jmm_start_import_check

import="foo.bar.baz;"
data="$(jmm_helper_import_check "$import")"
if [[ "$data" == "skip" ]]; then
	echo "Failed add import: $data"
	exit 1
fi

import="baz.bar.foo;"
data="$(jmm_helper_import_check "$import")"
if [[ "$data" == "skip" ]]; then
	echo "Failed add import: $data"
	exit 1
fi

import="foo.bar.baz;"
data="$(jmm_helper_import_check "$import")"
if [[ "$data" == "import" ]]; then
	echo "Failed skip import: $data"
	exit 1
fi

jmm_end_import_check

jmm_start_import_check

import="foo.bar.baz;"
data="$(jmm_helper_import_check "$import")"
if [[ "$data" == "skip" ]]; then
	echo "Failed add fresh import: $data"
	exit 1
fi

jmm_end_import_check