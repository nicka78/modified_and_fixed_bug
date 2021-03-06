#!/bin/sh
# scifab device driver autotest shell-script
# this program is run in /root. Please login /root with 'su' command

set -e
#set -x

LOCAL_TTY="/dev/ttyUSB1"
BOARD_HOSTNAME="lager"
BOARD_USERNAME="root"
BOARD_TTY="/dev/ttySC6"
SCI_ID="6"
# Run suspend-resume.py to connect Host PC with the Board
$(dirname $0)/../common/suspend-resume.py $LOCAL_TTY $BOARD_HOSTNAME $BOARD_USERNAME \
	$BOARD_TTY $SCI_ID

