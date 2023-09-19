/*/*
 * Author(s): aemacdonald, jweintraub
 * Date: 1/17/2022
 *
 */
#include <stdio.h>
#include <stdlib.h>

int main (int argc, char *argv[])
{


    char holder = '\0'; //character selected, initially null
    int count=0; //count of char repetitions

    if(!(argc >= 2)) //check if file name given
    {
        printf("wunzip: file1 [file2 ...]\n");
        exit(1);
    }
    else
    {
    
        for(int i = 1; i < argc; i++) //for each file
        {    
        
            FILE *file = fopen(argv[i], "r"); // open file to read

    
            if(file == NULL)
            {
                printf("wzip: cannot open file\n");
                exit(1);
            }
            else
            {
                while(fread(&count, sizeof(int), 1, file)==1 && fread(&holder, sizeof(char), 1, file)==1) //collect int and char from file
                {
                	while(count>0)
                	{
               			printf("%c", holder); //print character (int) # of times
                		count--;
               	 	}
            	}    
            }
            
        }

   	}       
    return 0;
}
