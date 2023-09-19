/*
	AUTHOR: Alexander MacDonald
	DATE: 2/16/2022
 */
#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <unistd.h>
#include "battleship.h"
#include "tests.h"
#include "production.h"

#define ROWS 10
#define COLS 10

int main (int argc, char* argv[])
{
	if(tests())
	{	
		printf("All Test Cases Pass\n");
		welcomeScreen();
		production(argc, argv);
	}
	else
	{
		printf("Test Cases Failed\n");
	}
}
