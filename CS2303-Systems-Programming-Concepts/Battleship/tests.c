/*
	AUTHOR: Alexander MacDonald
	DATE: 2/16/2022
 */
#include <stdlib.h>
#include <stdio.h>
#include "battleship.h"
#include "tests.h"

//this is the tester file for testing the helper functions in this environment for a successful battleship game

int testInit()
{
	char answer[3][3] =
	{
		{'a', 'a', 'a'},
		{'a', 'a', 'a'},
		{'a', 'a', 'a'}
	};
	
	char **test = initializeGameBoard(3, 3, 'a');
	
	for(int i = 0; i < 3; i++)
	{
		for(int j = 0; j < 3; j++)
		{
			if(answer[i][j] != test[i][j])
			{
				return 0;
			}
		}
	}
	
	return 1;
}

int testHit()
{
	char **board;
	char **noGuess;
	char **prevGuess;
	
	board = malloc(sizeof(char*) * 3);
	for(int i = 0; i < 3; i++)
	{
		board[i] = malloc(sizeof(char*) * 3);
	}
	noGuess = malloc(sizeof(char*) * 3);
	for(int j = 0; j < 3; j++)
	{
		noGuess[j] = malloc(sizeof(char*) * 3);
	}
	prevGuess = malloc(sizeof(char*) * 3);
	for(int k = 0; k < 3; k++)
	{
		prevGuess[k] = malloc(sizeof(char*) * 3);
	}
	
	for(int a = 0; a < 3; a++)
	{
		for(int b = 0; b < 3; b++)
		{
			if(a == 0)
			{
				board[a][b] = 's';
			}
			else
			{
				board[a][b] = 'w';
			}
		}
	}
	
	for(int c = 0; c < 3; c++)
	{
		for(int d = 0; d < 3; d++)
		{
			if(c == 0 && d == 1)
			{
				noGuess[c][d] = '-';
				prevGuess[c][d] = '*';
			}
			else
			{
				noGuess[c][d] = '-';
				prevGuess[c][d] = '-';
			}
		}
	}
	
	int t1 = checkHit(board, noGuess, 0, 1);
	int t2 = checkHit(board, prevGuess, 0, 1);
	int t3 = checkHit(board, noGuess, 1, 1);
	
	if(t1 != 1 || t2 != 2 || t3 != 0)
	{
		return 0;
	}
	else
	{
		return 1;
	}	
}

int testAddHit()
{
	char **answer;
	char **prevBoard;
	
	answer = malloc(sizeof(char*) * 3);
	prevBoard = malloc(sizeof(char*) * 3);
	for(int i = 0; i < 3; i++)
	{
		answer[i] = malloc(sizeof(char*) * 3);
		prevBoard[i] = malloc(sizeof(char*) * 3);
	}
	
	for(int j = 0; j < 3; j++)
	{
		for(int k = 0; k < 3; k++)
		{
			if(j == 0 && k == 1)
			{
				answer[j][k] = '*';
				prevBoard[j][k] = '-';
			}
			else
			{
				answer[j][k] = '-';
				prevBoard[j][k] = '-';
			}
		}
	}
	
	prevBoard = addHit(prevBoard, 0, 1);
	
	for(int a = 0; a < 3; a++)
	{
		for(int b = 0; b < 3; b++)
		{
			if(prevBoard[a][b] != answer[a][b])
			{
				return 0;
			}
		}
	}
	return 1;
}

int testAddMiss()
{
	char **answer;
	char **prevBoard;
	
	answer = malloc(sizeof(char*) * 3);
	prevBoard = malloc(sizeof(char*) * 3);
	for(int i = 0; i < 3; i++)
	{
		answer[i] = malloc(sizeof(char*) * 3);
		prevBoard[i] = malloc(sizeof(char*) * 3);
	}
	
	for(int j = 0; j < 3; j++)
	{
		for(int k = 0; k < 3; k++)
		{
			if(j == 0 && k == 1)
			{
				answer[j][k] = 'm';
				prevBoard[j][k] = '-';
			}
			else
			{
				answer[j][k] = '-';
				prevBoard[j][k] = '-';
			}
		}
	}
	
	prevBoard = addMiss(prevBoard, 0, 1);
	
	for(int a = 0; a < 3; a++)
	{
		for(int b = 0; b < 3; b++)
		{
			if(prevBoard[a][b] != answer[a][b])
			{
				return 0;
			}
		}
	}
	return 1;
}

int tests()
{	
	int test1 = testInit();
	int test2 = testHit();
	int test3 = testAddHit();
	int test4 = testAddMiss();
	
	
	if(test1 == 1 && test2 == 1 && test3 == 1 && test4 == 1)
	{
		return 1;
	}
	else
	{
		return 0;
	}
}
