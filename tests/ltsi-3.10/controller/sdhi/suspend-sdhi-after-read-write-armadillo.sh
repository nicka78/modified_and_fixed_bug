#!/bin/sh
# scifab device driver autotest shell-script
# this program is run in /root. Please login /root with 'su' command

set -e
#set -x

LOCAL_TTY="/dev/ttyUSB0"
BOARD_HOSTNAME="armadillo800"
BOARD_USERNAME="root"
BOARD_TTY="/dev/ttySC1"
SCI_ID="1"
SIZE="10"
FILE="/tmp/sdhi-script"
SDHI="\write-read-sd0-ram.sh"

# Search for sdhi file
for count in 1 2
do
	if ! ssh $BOARD_USERNAME@$BOARD_HOSTNAME "/usr/bin/find . -name $SDHI -print" \
	> $FILE; then
		echo "Not found file $SDHI"
		exit 1
	fi
	for path in `cat $FILE`
	do
		echo "$path $SIZE" > $FILE	
	done

	if ! ssh $BOARD_USERNAME@$BOARD_HOSTNAME < $FILE; then
		echo "can not run script $SDHI"
		exit 1
	elif [ $count -eq 2 ]; then
		echo "SUSPEND SDHI TEST PASSED"
	fi

	# Run suspend-resume.py to connect Host PC with the Board
	if [ $count -eq 1 ]; then
		if $(dirname $0)/../common/suspend-resume.py $LOCAL_TTY $BOARD_HOSTNAME \
		$BOARD_USERNAME $BOARD_TTY $SCI_ID; then
			echo "PASSED"
			sleep 1
		else
			echo "FAILED"
			exit 1
		fi
	fi

	if [ -f $FILE ]; then
		rm $FILE
	fi
done
