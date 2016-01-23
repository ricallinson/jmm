#!/bin/bash
cd "$(dirname "$0")"
export JMMPATH=$(dirname $(pwd))/examples
echo
echo "Running Tests"
echo
echo "JMMPATH is set to $JMMPATH"
source ../jmm.sh
echo
for test in ./functional/*.sh; do
	jmm clean
	$test
	if [ $? -eq 0 ]; then
	  echo "    Pass $test"
	else
	  echo "    Fail $test"
	fi
	jmm clean
done
echo
