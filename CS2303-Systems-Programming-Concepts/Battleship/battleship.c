/*
	AUTHOR: Alexander MacDonald
	DATE: 2/16/2022
 */
#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <unistd.h>
#include "battleship.h"

//in starter code
void welcomeScreen()
{
	printf ("XXXXX   XXXX  XXXXXX XXXXXX XX     XXXXXX  XXXXX XX  XX XX XXXX\n");
	printf ("XX  XX XX  XX   XX     XX   XX     XX     XX     XX  XX XX XX  XX\n");
	printf ("XXXXX  XX  XX   XX     XX   XX     XXXX    XXXX  XXXXXX XX XXXX\n"); 
	printf ("XX  XX XXXXXX   XX     XX   XX     XX         XX XX  XX XX XX\n");
	printf ("XXXXX  XX  XX   XX     XX   XXXXXX XXXXXX XXXXX  XX  XX XX XX\n");
	printf ("\n\n");

	printf ("RULES OF THE GAME:\n");
	printf ("1. This is a two player game.\n");
	printf ("2. Player 1 is you and Player 2 is the computer.\n");
	printf ("3. Player 1 will be prompted if user wants to manually input coordinates\n");
	printf ("   for the game board or have the computer randomly generate a game board\n");
	printf ("4. There are five types of ships to be placed by longest length to the\n"); 
	printf ("   shortest; [c] Carrier has 5 cells, [b] Battleship has 4 cells, [r] Cruiser\n");
	printf ("   has 3 cells, [s] Submarine has 3 cells, [d] Destroyer has 2 cells\n");
	printf ("5. The computer randomly selects which player goes first\n");
	printf ("6. The game begins as each player tries to guess the location of the ships\n");
	printf ("   of the opposing player's game board; [*] hit and [m] miss\n");
	printf ("7. First player to guess the location of all ships wins\n\n");
}

//initializes a row x col 2d array filled entirely with the char c
char **initializeGameBoard(int rows, int cols, char c)
{
	//intialize the board in memory
	char **board;
	board = malloc(sizeof(char*) * rows);
	for(int i = 0; i < rows; i++)
	{
		board[i] = malloc(sizeof(char*) * cols);
	}
	
	//fill the board with the character specified
	for(int i = 0; i < rows; i++)
	{
		for(int j = 0; j < cols; j++)
		{
			board[i][j] = c;
		}
	}
	
	//return the 2d char array
	return board;	
}

//logic for if the user wishes to place their ships manually
char **initializeManualPlacing(char **board, int rows, int cols)
{
	//intialize the board
	char **tmpBoard = board;
	//these are the 5 ship sizes in battleship, they will be placed in order of the array (5, 4, 3, 3, 2)
	int shipSizes[] = {5, 4, 3, 3, 2};
	
	//for each ship
	for(int i = 0; i < 5; i++)
	{
		//initialize the variables necessary for the function
		int flag = 1; //flag for valid placements
		int direction = 0; //direction, 1 for veritcal, 0 for horizontal
		int x = 0; //x index of head of ship
		int y = 0; //y index of head of ship
		
		//ask for direction
		printf("Please input the orientation of the ship. 1 for vertical, 0 for horizontal\n");
		scanf(" %d", &direction);
		//ensure valid direction
		while(direction != 0 && direction != 1)
		{
			printf("Wrong value input! Please input a 1 for vertical, or a 0 for horizontal.\n");
			scanf(" %d", &direction);
		}
		
		//if vertical
		if(direction)
		{
			//assume valid
			flag = 0;
			//ask for x index
			printf("Please input the X index for the %d length Ship. (0-9)\n", shipSizes[i]);
			scanf(" %d", &x);
			//ensure x validity
			while(x < 0 || x > 9)
			{
				printf("Wrong value input! Please input the X index for the %d length Ship. (0-9)\n", shipSizes[i]);
				scanf(" %d", &x);
			}
			//ask for y index
			printf("Please input the Y index for the %d length Ship. (0-%d)\n", shipSizes[i], (10 - shipSizes[i]));
			scanf(" %d", &y);
			//ensure y validity, avoid out of bounds by limiting head placement, although all board is reachable based on combination of indeces
			while(y < 0 || y > (10 - shipSizes[i]))
			{
				printf("Wrong value input! Please input the Y index for the %d length Ship. (0-%d)\n", shipSizes[i], (10 - shipSizes[i]));
				scanf(" %d", &y);
			}
			//for the size of the ship
			for(int k = 0; k < shipSizes[i]; k++)
			{
				//ensure that another ship does not already exist there
				if(tmpBoard[x][y + k] == 's')
				{
					flag = 1;
				}
			}
			//if there was overlap
			if(flag == 1)
			{
				//try a new index :)
				printf("Invalid Position due to Overlap, please input another coordinate pair\n");
				i--;
			}
			//if it's a valid, non-overlapping position
			else
			{
				//add the ship to the board
				for(int l = 0; l < shipSizes[i]; l++)
				{
					tmpBoard[x][y + l] = 's';
				}
			}
			
		}
		//if horizontal
		else
		{
			//assume valid
			flag = 0;
			//ask for x index
			printf("Please input the X index for the %d length Ship. (0-%d)\n", shipSizes[i], (10 - shipSizes[i]));
			scanf(" %d", &x);
			//ensure x validity
			while(x < 0 || x > (10 - shipSizes[i]))
			{
				printf("Wrong value input! Please input the X index for the %d length Ship. (0-%d)\n", shipSizes[i], (10 - shipSizes[i]));
				scanf(" %d", &x);
			}
			//ask for y index
			printf("Please input the Y index for the %d length Ship. (0-9)\n", shipSizes[i]);
			scanf(" %d", &y);
			//ensure y validity
			while(y < 0 || y > 9)
			{
				printf("Wrong value input! Please input the Y index for the %d length Ship. (0-9)\n", shipSizes[i]);
				scanf(" %d", &y);
			}
			//check if valid
			for(int j = 0; j < shipSizes[i]; j++)
			{
				//if overlaps, not valid
				if(tmpBoard[x + j][y] == 's')
				{
					flag = 1;
				}
			}
			//if not valid, try again
			if(flag == 1)
			{
				printf("Invalid Position due to Overlap, please input another coordinate pair\n");
				i--;
			}
			//if valid, add to board!
			else
			{
				for(int m = 0; m < shipSizes[i]; m++)
				{
					tmpBoard[x + m][y] = 's';
				}
			}
		}
		
	}
	//return edited board
	return tmpBoard;
}

//logic for user random placement, same logic as the computer generated board
char **initializeRandomPlacing(char **board, int rows, int cols)
{
	//5, 4, 3, 3, 2 ship sizes
	// 0 is vert
	// 1 is hori
	
	//same intialization as manual placement
	char **tmpBoard = board;
	int xHeadOfShip;
	int yHeadOfShip;
	int direction;
	int shipSizes[] = {5, 4, 3, 3, 2};
	
	
	for(int i = 0; i < 5; i++) //iterating through the 5 ships
	{
		int flag = 1;
		while(flag) //while its not in a valid position
		{
			srand(time(NULL)); //new random environment
			direction = rand() % 2; //random direction
			xHeadOfShip = rand() % (10 - shipSizes[i]) + 1; //0-max index
			yHeadOfShip = rand() % (10 - shipSizes[i]) + 1; //0-max index
			if(direction) //vertical
			{
				//assume valid
				flag = 0;
				for(int j = 0; j < shipSizes[i]; j++)
				{
					//if found overlap, try again
					if(tmpBoard[xHeadOfShip][yHeadOfShip + j] != 'w')
					{
						flag = 1;
					}
				}
					
			}
			else //horizontal
			{
				//assume valid
				flag = 0;
				for(int k = 0; k < shipSizes[i]; k++)
				{
					//if found overlap, try again
					if(tmpBoard[xHeadOfShip + k][yHeadOfShip] != 'w')
					{
						flag = 1;
					}
				}
				
			}
		}
		//if valid
		if(direction)//vertical
		{
			//place on board
			for(int a = 0; a < shipSizes[i]; a++)
			{
				tmpBoard[xHeadOfShip][yHeadOfShip + a] = 's';
			}
		}
		else //horizontal
		{
			//place on board;
			for(int b = 0; b < shipSizes[i]; b++)
			{
				tmpBoard[xHeadOfShip + b][yHeadOfShip] = 's';
			}
		}
	}
	//return edited board
	return tmpBoard;
}

//board1 is gameboard, board2 is peg board
int checkHit(char **board1, char **board2, int x, int y)
{
	//if opposite board has ship and you havent hit it before, 
	if(board1[x][y] == 's' && board2[x][y] == '-')
	{
		return 1;
	}
	//if you've guessed this before
	else if((board1[x][y] == 's' && board2[x][y] == '*') || board2[x][y] == 'm')
	{
		return 2;
	}
	//if you missed lol!
	else
	{
		return 0;
	}
}

//add hit marker to x,y index on board
char **addHit(char **board, int x, int y)
{
	char **ret = board;
	
	ret[x][y] = '*';
	
	return ret;
}
//add miss marker to x,y index on board
char **addMiss(char **board, int x, int y)
{
	char **ret = board;
	
	ret[x][y] = 'm';
	
	return ret;
}

//simply print function with indexes
void printGameBoard(char **board, int rows, int cols)
{
	printf("  0 1 2 3 4 5 6 7 8 9\n");
	for(int i = 0; i < rows; i++)
	{
		printf("%d ", i);
		for(int j = 0; j < cols; j++)
		{
			printf("%c ", board[i][j]);
		}
		printf("\n");
	}
}


