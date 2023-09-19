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

int production(int argc, char *argv[])
{
	//new random environment
	srand(time(NULL));
	
	//initialize variables necessary for function
	int first = 0; //whether comp or player is first
	int winner = 0; //who is the winner
	int playerHits = 0; //# of unique hits, 17 is victory
	int computerHits = 0; //# of unique hits, 17 is victory
	int turns = 0; //# of turns
	char manual = ' '; //whether manual input is done or not
	
	//initialize various gameboards for player and computer
	char **playerBoard = initializeGameBoard(ROWS, COLS, 'w');
	char **pegBoard = initializeGameBoard(ROWS, COLS, '-');
	char **computerBoard = initializeGameBoard(ROWS, COLS, 'w');
	char **computerPegBoard = initializeGameBoard(ROWS, COLS, '-');
	
	//put random ships for computer
	printf("Generating Computer Board... Can take a while...\n");
	computerBoard = initializeRandomPlacing(computerBoard, ROWS, COLS);
		
	//ask for manual placing
	printf("MANUAL PLACING? Y/N\n");
	scanf(" %c", &manual);
	//ensure validity
	while(manual != 'Y' && manual != 'y' && manual != 'n' && manual != 'N')
	{
		printf("Y/N not given, please input again.\n");
		scanf(" %c", &manual);	
	}
	//if yes, do manual
	if(manual == 'Y' || manual == 'y')
	{
		playerBoard = initializeManualPlacing(playerBoard, ROWS, COLS);
	}
	//if no, do random placing
	else
	{
		printf("Generating... Can take a while\n");
		sleep(1); //idk funny thing that is needed for the above print statement to work :D
		if(1)
		{
			playerBoard = initializeRandomPlacing(playerBoard, ROWS, COLS);
		}
	}
		
	//UNCOMMENT IF YOU WANT TO CHEAT :D
	printf("PLAYER BOARD:\n");
	printGameBoard(playerBoard, ROWS, COLS);
	printf("PEG BOARD:\n");
	printGameBoard(pegBoard, ROWS, COLS);
	printf("COMPUTER BOARD:\n");
	printGameBoard(computerBoard, ROWS, COLS);
	printf("COMPUTER PEG BOARD:\n");
	printGameBoard(computerPegBoard, ROWS, COLS);
	
	//game start	
	printf("GAME START\n");
	//who's first
	first = rand() % 2;
	
	
	if(first) //1 is player
	{
		printf("Player FIRST\n");
	}
	else //0 is computer
	{
		printf("Computer FIRST\n");
		turns++; //ensure comp is first by skipping player
	}
		
	while(!(winner))
	{
		turns++; //new turn
		if(turns % 2 == 1) //odd turns are the players 
		{	
			//necessary variables for function
			int x = 0; //x index to guess
			int y = 0; //y index to guess
			int hitStatus1 = 0; //whether index was a hit or not
			
			//ask for x index
			printf("Your turn! Please input the X value of the coordinate you wish to guess. (0-9)\n");
			scanf(" %d", &x);
			//ensure validity
			while(x < 0 || x > 9)
			{
				printf("Out of Bounds X input. Please use 0-9\n");
				scanf(" %d", &x);
			}
			//ask for y index
			printf("Please input the Y value of the coordinate you wish to guess\n");
			scanf(" %d", &y);
			//ensure validity
			while(y < 0 || y > 9)
			{
				printf("Out of Bounds Y input. Please use 0-9\n");
				scanf(" %d", &y);
			}
			
			//check hit status!
			hitStatus1 = checkHit(computerBoard, pegBoard, x, y);
			
			//if hit
			if(hitStatus1 == 1)
			{
				printf("Player hit @ [%d, %d]\n", x, y);
				pegBoard = addHit(pegBoard, x, y);
				playerHits++;
			}
			//if repeat
			else if(hitStatus1 == 2)
			{
				printf("Already guessed @ [%d, %d]\n", x, y);
			}
			//if miss
			else
			{
				printf("Player Missed @ [%d, %d]\n", x, y);
				pegBoard = addMiss(pegBoard, x, y);
			}
		}
		//computers turn! on even turns
		else
		{
			int guessX = rand() % 10; //random index guess
			int guessY = rand() % 10; //random index guess
			//check hit status
			int hitStatus2 = checkHit(playerBoard, computerPegBoard, guessX, guessY);
			
			//very minor smart computer, random, but no repeated guesses
			while(hitStatus2 == 2)
			{
				srand(time(NULL));
				guessX = rand() % 10;
				guessY = rand() % 10;
				hitStatus2 = checkHit(playerBoard, computerPegBoard, guessX, guessY);
			}
			
			//if computer hits
			if(hitStatus2 == 1)
			{
				printf("Computer hit @ [%d, %d]\n", guessX, guessY);
				computerPegBoard = addHit(computerPegBoard, guessX, guessY);
				computerHits++;
			}
			//if computer misses
			else
			{
				printf("Computer Missed @ [%d, %d]\n", guessX, guessY);
				computerPegBoard = addMiss(computerPegBoard, guessX, guessY);
			}
		}
		
		//check for winner!
		if(playerHits == 17)
		{
			winner = 1;
		}
		else if(computerHits == 17)
		{
			winner = 2;
		}
	}
		
	if(winner == 1) //player wins
	{
		printf("Congratulations, You Won in %d Turns and by %d Hits!\n", turns, (playerHits-computerHits));
		printf("Player Peg Board:\n");
		printGameBoard(pegBoard, ROWS, COLS);
		printf("Computer Peg Board:\n");
		printGameBoard(computerPegBoard, ROWS, COLS);
			
	}
	else if(winner == 2) //computer wins
	{
		printf("Sorry, You Lost in %d Turns and by %d Hits!\n", turns/2, (computerHits-playerHits));
		printf("Player Peg Board:\n");
		printGameBoard(pegBoard, ROWS, COLS);
		printf("Computer Peg Board:\n");
		printGameBoard(computerPegBoard, ROWS, COLS);
	}
	//successful compilation!
	return 1;
}
