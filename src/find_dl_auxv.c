/*
 * Copyright (C) 2004 Valery Reznic
 * This file is part of the Elf Statifier project
 * 
 * This project is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License.
 * See LICENSE file in the doc directory.
 */

static char **my_pattern;
static int init_my_pattern(int argc, char *argv[], char *envp[])
{
	for (my_pattern = envp; *my_pattern; my_pattern++);
	my_pattern++;
	return 0;
}
#include "./find_dl_main.inc.c"