#!/bin/bash
cd "$(dirname "$0")"
export JMMPATH=$(dirname $(pwd))/examples

echo
echo "Running Tests"
echo
echo "JMMPATH is set to $JMMPATH"
source ../jmm.sh
echo

failures=0
successes=0

for test in ./functional/*.sh; do
	jmm clean
	$test
	if [ $? -eq 0 ]; then
		successes=successes+1
	    echo "    Pass $test"
	else
		failures=failures+1
	    echo "    Fail $test"
	fi
	jmm clean
done

echo

if [[ failures != 0 ]]; then
	exit 1
fi
exit 0
