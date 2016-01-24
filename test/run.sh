#!/bin/bash

# Set the JMMPATH and current the directory.
cd "$(dirname "$0")"
export JMMPATH=$(dirname $(pwd))/examples
source ../jmm.sh

echo
echo "Running Tests"
echo
echo "JMMPATH is set to $JMMPATH"
echo

failures=0
passes=0

for test in ./unit/*.sh ./functional/*.sh; do
	# Clean up anything that may have been left by old tests.
	jmm clean
	# Run the test.
	$test
	if [ $? -eq 0 ]; then
		passes=$(($passes+1))
	    echo "    Pass $test"
	else
		failures=$(($failures+1))
	    echo "    Fail $test"
	fi
done

echo
echo "There were $passes passes and $failures failures."
echo

if [[ $failures != 0 ]]; then
	exit 1
fi
exit 0
