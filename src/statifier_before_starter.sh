#!/bin/bash

# Copyright (C) 2004 Valery Reznic
# This file is part of the Elf Statifier project
# 
# This project is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License.
# See LICENSE file in the doc directory.

# Calculate addresses for _dl variables

function Main
{
	set -e
		source $COMMON_SRC || return
	set +e
	local Value
	local DL_LIST="$BaseAddr"
	Value=`GetSymbol _dl_argc        1 $VirtAddr $BaseAddr` || return
	DL_LIST="$DL_LIST $Value"
	Value=`GetSymbol _dl_argv        1 $VirtAddr $BaseAddr` || return
	DL_LIST="$DL_LIST $Value"
	Value=`GetSymbol _environ        1 $VirtAddr $BaseAddr` || return
	DL_LIST="$DL_LIST $Value"
	Value=`GetSymbol _dl_auxv        1 $VirtAddr $BaseAddr` || return
	DL_LIST="$DL_LIST $Value"
	Value=`GetSymbol _dl_platform    0 $VirtAddr $BaseAddr` || return
	DL_LIST="$DL_LIST $Value"
	Value=`GetSymbol _dl_platformlen 0 $VirtAddr $BaseAddr` || return
	DL_LIST="$DL_LIST $Value"

	echo "DL_LIST='$DL_LIST'" || return
	return 0
}
#################### Main Part ###################################
[ $# -ne 1 -o "x$1" = "x" ] && {
	echo "Usage: $0 <work_dir>" 1>&2
	exit 1
}

WORK_DIR=$1

# Where Look For Other Programs
D=`dirname $0`                || exit
source $D/statifier_lib.src   || exit

Main > $STARTER_SRC           || exit
exit 0