#!/bin/bash
source ../jmm.sh
data=$(jmm test $JMMPATH/src/github/com/ricallinson/jmmtest/TestClass_test.java)
if [ "$data" != "pass" ]; then
	echo "Test did not execute."
	exit 1
fi
data=$(jmm test $JMMPATH/src/github/com/ricallinson/jmmtest/sub/SubTestClass_test.java)
if [ "$data" != "fail" ]; then
	echo "Test did not execute."
	exit 1
fi
data=$(jmm test $JMMPATH/src/github/com/ricallinson/jmmtest)
if [[ "$data" != *"pass"* ]] && [[ "$data" != *"fail"* ]]; then
	echo "Test did not execute."
	exit 1
fi
exit 0
