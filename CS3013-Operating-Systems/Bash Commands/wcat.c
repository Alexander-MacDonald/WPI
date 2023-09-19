/*
 * Author(s): aemacdonald, jweintraub
 * Date: 1/17/2022
 *
 */
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
	char a; //char holder
	
	if(!(argc >= 2)) //check if file is given
		exit(0);
	else
	{
		for(int i = 1; i < argc; i++) //for each file
		{
			FILE *file = fopen(argv[i], "r"); //open the file for reading
			if(file == NULL)
			{
				printf("wcat: cannot open file\n");
				exit(1);
			}
	
			else
			{
				a = fgetc(file); //get the first char
				while(a != EOF) //while its not the end of the file
				{
					printf("%c", a); //print out the char
					a = fgetc(file); //get the next char
				}	
			}
		fclose(file);//close the file
		}
	}
	return 0; //sucessful compilation
}
