#!/bin/bash

# Copyright (C) 2004 Valery Reznic
# This file is part of the Elf Statifier project
# 
# This project is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License.
# See LICENSE file in the doc directory.

# Create starter

function CreateStarter
{
	[ $# -ne 1 -o "x$1" = "x" ] && {
		echo "$0: Usage: CreateStarter <Starter>" 1>&2
		return 1
	}

	set -e
		source $COMMON_SRC  || return
		source $STARTER_SRC || return
	set +e
	local Starter="$1"

	local REGS=$D/regs
	local REGS_BIN=$WORK_OUT_DIR/regs
	local DL_VAR=$D/dl-var
	local DL_VAR_BIN=$WORK_OUT_DIR/dl-var
	local STA=$D/set_thread_area
	local STA_BIN=$WORK_OUT_DIR/set_thread_area
	local TLS_LIST=

	[ "$HAS_TLS" = "yes" ] && {
		# Create binary file with set_thread_area parameters
		$D/set_thread_area.sh $WORK_GDB_OUT_DIR/set_thread_area $STA_BIN || return
		TLS_LIST="$STA $STA_BIN"
	}

	# Create binary file with dl-var variables
	rm -f $DL_VAR_BIN || return
	$D/strtoul $DL_LIST > $DL_VAR_BIN || return
	# Create binary file with registers' values
	$D/regs.sh $REGISTERS_FILE $REGS_BIN || return
	cat $DL_VAR $DL_VAR_BIN $TLS_LIST $REGS $REGS_BIN > $Starter || return
	return 0 
}

function Main
{
	CreateStarter $WORK_OUT_DIR/starter || return
	return 0
}

#################### Main Part ###################################
[ $# -ne 1 -o "x$1" = "x" ] && {
	echo "Usage: $0 <work_dir>" 1>&2
	exit 1
}

WORK_DIR=$1

# Where Look For Other Programs
D=`dirname $0`              || exit
source $D/statifier_lib.src || exit

Main                        || exit
exit 0