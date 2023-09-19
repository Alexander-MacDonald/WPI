/*
 * Author(s): aemacdonald, jweintraub
 * Date: 1/17/2022
 *
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[])
{
    char *line = NULL; //line checked in file
    char line2[60]; //line checked in stdin
    size_t len = 0; //memory size of word
    ssize_t nread; //-1 check
    char *ret; //return string
    char *word; //word to search

    if(!(argc >= 2)) //error for no filename
    {
        printf("wgrep: searchterm [file ...]\n");
        exit(1);
    }
    else
    {
        word = argv[1]; // word to search for
        for(int i = 2; i < argc; i++) //search each file
        {
            FILE *file = fopen(argv[i], "r"); //open the file
    
        	if(file == NULL) //error for not being able to open file
            {
                printf("wgrep: cannot open file\n");
                exit(1);
            }
    
            else
            {
            	while ((nread = getline(&line, &len, file)) != -1) //going line by line
            	{
            		ret = strstr(line, word); //see if occurence of word exists on line
               		if (ret)//if word was found
                	{
                    	printf("%s", line); //print out the line it was found on
                	}
            	}
            fclose(file); //close the file     
    		}
        }   
        if(argc==2) //if there was no specified file
        {
        	while(!feof(stdin)) //if standard input is not end of file
        	{
            	fgets(line2, 256, stdin); //get line
            	if(!feof(stdin)) //if not end of file
            	{
                	ret = strstr(line2, word); //see if word is found in line
                	if (ret) //if it was
                	{
                    	printf("%s", line2); //print it
                    }
                }
            }
        }
    }
    return 0; //successful compilation
}
