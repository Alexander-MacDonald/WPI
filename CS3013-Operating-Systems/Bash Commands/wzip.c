/*
 * Author(s): aemacdonald, jweintraub
 * Date: 1/17/2022
 *
 */
#include <stdio.h>
#include <stdlib.h>

int main (int argc, char *argv[])
{

    char c; //char detected
    int count = 0; //count of char starts at 0
    char holder = '\0'; //char starts at 0

    if(!(argc >= 2)) //check if file name given
    {
        printf("wzip: file1 [file2 ...]\n");
        exit(1);
    }
    else
    {
        for(int i = 1; i < argc; i++) //for each file
        {       
            FILE *file = fopen(argv[i], "r"); //open file for reading

            if(file == NULL) //if file cannot be opened
            {
                printf("wzip: cannot open file\n");
                exit(1);
            }
            else
            {
                while((c = fgetc(file)) != EOF) //while not end of file
                {
                    if(c == holder || holder == '\0') //check if it's start of file, or previous letter matches
                    {
                        count += 1; //occurance of char increment
                        holder = c; //new previous char
                    }
                    else
                    {
                    
                        fwrite(&count, sizeof(int), 1, stdout); //write the occurances to stdout
                        fwrite(&holder, sizeof(char), 1, stdout); //write the char to stdout

                        count = 1; //reset count
                        holder = c; //reset new previous char
                    }
                }
            }
            
        }
        fwrite(&count, sizeof(int), 1, stdout); //fwrite count
        fwrite(&holder, sizeof(char), 1, stdout); //fwrite letter
    }
          
    return 0;
}
