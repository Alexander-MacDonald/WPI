/*


 */ 
#ifndef BATTLESHIP_H
#define BATTLESHIP_H
 
void welcomeScreen();
char **initializeGameBoard(int rows, int cols, char c);
void printGameBoard(char **board, int rows, int cols);
char **initializeManualPlacing(char **board, int rows, int cols);
char **initializeRandomPlacing(char **board, int rows, int cols);
int checkHit(char **board1, char **board2, int x, int y);
char **addHit(char **board, int x, int y);
char **addMiss(char **board, int x, int y);

#endif
