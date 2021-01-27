#!/bin/sh
set -e

TESTS_DIR=$(dirname "$0")
eval `dbus-launch --sh-syntax`

trap 'kill -TERM $DBUS_SESSION_BUS_PID' EXIT

PYTHON=${1:-python}

"$PYTHON" $TESTS_DIR/context.py
"$PYTHON" $TESTS_DIR/identifier.py
"$PYTHON" $TESTS_DIR/error.py
if [ "$2" != "dontpublish" ]
then
	echo "====================================================================="
	echo "TEST START"
	all=0
	xfail=0
	xpass=0
	for test_file in `ls $TESTS_DIR/publish*.py`
	do
	    all=`expr $all + 1`
	    "$PYTHON" $test_file
	    if [ $? -eq 0 ]; then
	       echo "PASS: $test_file"
	       xpass=`expr $xpass + 1`
	    else
	       echo "FAIL: $test_file"
	       xfail=`expr $xfail + 1`
	    fi
	done
	echo "TEST END"
	echo "====================================================================="
	echo "TEST RESULT SUMMARY for python-pydbus"
	echo "# TOTAL: $all"
	echo "# PASS:  $xpass"
	echo "# FAIL:  $xfail"
	echo "====================================================================="
fi
