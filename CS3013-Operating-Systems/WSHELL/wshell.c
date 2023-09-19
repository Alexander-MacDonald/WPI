/*
 * Author(s): aemacdonald, jweintraub
 * Date: 1/27/2022
 * current: 89/89
 * 
 */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <signal.h>
#define TRUE 1
#define FALSE 0
#define WRITER 1
#define READER 0
#define MAX_BUF 256

/*Job is the structure that stores all relative information about a process.
  This includes the job id (jid), the process id (pid), and the name
  of the command for "jobs" functionality */
struct job{

	int jid; 	//job id
	pid_t pid; 	//process id
	char* name; //name of process

}job;

/* History Variables */
char historyQ[10][MAX_BUF] = {""}; 	//semi-circular queue that the commands are kept for 'history' functionality
int cmdAmt = -1; 					//amount of commands, used as index so first command is "0"
int front = 0;						//rotating pointer for semi-circular queue, starts at 0->9, loops back to 0
int modCt; 							//% calc of the count to ensure 10 commands are always kept for history

/* Path Variable */
char path[MAX_BUF]; 	//working path

/* Jobs Variables */
int jid = 0; 				//working job id - keeps track of what the jobid "should" be while entering commands
pid_t *pidList; 			//working pid list - keeps track of all active process ids that are in the background. -1 for a PID is indicative of a finished process
struct job jobs[MAX_BUF]; 	//working job list - keeps track of all active jobs that are in the background

/* Functions Begin */
//this func kills specific or all forked process(es)
void killProcess(int n)
{
    if(n == -1) //no job ID can be -1 therefore -1 is used as the "all process #" to avoid forks printing done statements after an exit is called
    {    
        for(int i = 0; i < jid; i++) //for all the jobs
        {
            if(pidList[i] != -1) //as long as the process is active
            {    
                kill(pidList[i], SIGQUIT); //kill the process
            }
        }
    }
    else //if not -1, then a specific job ID was provided
    {
    	int flag = 0; //flag indicating whether the job has been found or not
    	for(int j = 0; j < jid; j++) //for all the jobs up to the current job id
    	{
    		if(n == jobs[j].jid) //if the job id matches the search
    		{
    			for(int k = 0; k < jid; k++)
    			{
    				if(jobs[j].pid == pidList[k]) //if the process id in the jobs list is a currently active process
    				{
    					flag = 1;//flag that an active process is ready to be terminated
    					kill(pidList[k], SIGQUIT); //kill process
    					pidList[k] = -1; //mark process as completed
    				}
    			}
    		}
    	}
    	
    	if(flag == 0) //if process is not found, then it doesnt exist
    	{
    		printf("wshell: no such background job: %d\n", n);
    	}
    }
}

// this func either calls a built in function or calls the external command
int funcCall(char *cmdPart, char *fileName, char *GT)
{

	FILE* fOut = stdout; //this allows for files to be sent through beyond just stdout
	int result = 0; //if return -1, error encountered

	if(fileName != NULL) //if a file is submitted
	{
		if(strcmp(GT,">") == 0)//if > and not >>
		{
			fOut = fopen(fileName, "w+"); //open to write
		}
		else 
		{
			fOut = fopen(fileName, "a"); //open to append
		}
	
	}
	
    char *dupCmdPart = strdup(cmdPart); //duplicates given command
    char *cmdFuncChk;
    char *cmdFunc = strtok_r(dupCmdPart, " ", &cmdFuncChk); //isolates function
    
    if (strcmp(cmdFunc, "exit") == 0) //was exit called?
    {
        killProcess(-1); //kill all background processes
        fclose(fOut); //close the output
        exit(0); //exit the program
    }
    else if (strcmp(cmdFunc, "echo") == 0)//was echo called?
    {
        char *args = strdup(cmdPart); //duplicate command
        args += 5;
        fprintf(fOut, "%s\n", args); //print string after "echo "
        result = 0;
    }
    else if (strcmp(cmdFunc, "cd") == 0) //was cd called
    {
        char *args = strdup(cmdPart); //duplicate command
        args += 3; //skip "cd "
        if (strstr(args, " ") == 0)
        {

            if (strcmp(args, "") == 0) //if "cd" called, go home
            {
                args = getenv("HOME");
            }
            if (chdir(args) != 0) //if directory doesnt exist, print error
            {
                printf( "wshell: no such directory: %s\n", args);
                result = -1;
            }
            else //go to env
            {
                result = 0;
            }
        }
        else//more than one directory
        {
            printf("wshell: cd: too many arguments\n");
            result = -1;
        }

    }
    else if (strcmp(cmdFunc, "pwd") == 0)//if "pwd" is called
    {
        fprintf(fOut, "%s\n", path); //print out working directory
        result = 0;
    }

    else if (strcmp(cmdFunc, "history") == 0) //if "history" is called
    {
    	/*	couldnt get history to work when adding to array
    	 *in general command processing;; added it to array
    	 */
        modCt = cmdAmt % 10; //get index which command is input to
        strcpy(historyQ[modCt], "history"); //put history command in array

        if (front == 10) //if at end of array index, reset front to 0 index
        {
            front = 0;
        }
        else if (front < 10 && cmdAmt > 9) //if front < 10 && cmd > 9 specifying full array
        {
            front += 1;
        }

        if (cmdAmt < 10) //if array is not full of commands
        {
            for (int k = 0; k <= cmdAmt; k++) //just print out the entire array
            {
                fprintf(fOut, "%s\n", historyQ[k]);
            }
        }
        else //if array is full, start at pseudo front, print til end, then print actual 0 to pseudo front
        {
            for (int i = front; i < 10; i++)
            {
                fprintf(fOut, "%s\n", historyQ[i]);
            }
            for (int j = 0; j < front; j++)
            {
                fprintf(fOut, "%s\n", historyQ[j]);
            }// epic fake circular queue things : ^ D
        }
        result = 0;
    }
	else if (strcmp(cmdFunc, "jobs") == 0)// if jobs is called
	{
		for(int i = 0; i < jid; i++) //go through the job ids up to most recent job
		{
			if(pidList[i] > 0) // if pid at index exists
			{
				for(int j = 0; j < jid; j++) //go through list of jobs
				{
					if(pidList[i] == jobs[j].pid) //if you can find the job pid on the pid list
					{
						fprintf(fOut, "%d: %s \n", jobs[j].jid, jobs[j].name); //print it out as an active job
					}
				}
			}
		}
	
	}
	else if (strcmp(cmdFunc, "kill") == 0) //if kill is called
	{
		char *args = strdup(cmdPart); //duplicate command
		args += 5; //see what job id to use
		int x = atoi(args); //turn to int
		killProcess(x); //call kill process for specific job id
	}
    else //create an array of the command and arguments followed by null to be execvp'd ex: {"ls", "-a", NULL}
    {
        char *args[MAX_BUF]; // argument array
        char *arg = strdup(cmdFunc);  //argument
        int i = 0; //start i at index 0
        while (arg != NULL) //input cmd and args into array
        {
            args[i] = arg; //make arg the arg at i
            arg = strtok_r(NULL, " ", &cmdFuncChk); //substring
            i++; //increment i
        }

        args[i] = NULL; //add null at end
        int pipefd[2];
		pipe(pipefd);
		
        if (fork() != 0)//create child process
        {
			int status;
			waitpid(-1, &status, 0);
			result = WEXITSTATUS(status); //return status of parent
			char buffer[1024];
			close(pipefd[1]);  // close the write end of the pipe in the parent
    		ssize_t n = read(pipefd[0], buffer, sizeof(buffer));
   			buffer[n] = '\0';
   			fprintf(fOut,"%s", buffer);
        }
        else
        {
	    	close(pipefd[0]);    // close reading end in the child

   			dup2(pipefd[1], 1);  // send stdout to the pipe
   			dup2(pipefd[1], 2);  // send stderr to the pipe

    		close(pipefd[1]);    // this descriptor is no longer needed

            execvp(args[0], args); //exec the external command
            printf("wshell: could not execute command: %s\n", args[0]); //if command doesnt run
            exit(-1);
        }
    }
    if(fileName != NULL)
    {
   		fclose(fOut);//close out fOut
    }
    return result;
    
}


// this function checks for operators
int opCheck(char *cmd)
{
    char *cmdPartChk;
    char *cmdPart;  
    
    if (strstr(cmd, " && ")) //if && exists
    {
        cmdPart = strtok_r(cmd, "&", &cmdPartChk); //substring it
        int len = strlen(cmdPart);
        cmdPart[len - 1] = '\0';
        int check = funcCall(cmdPart, NULL, NULL); 
        if (check == 0) //if first function is successful run second
        {
            cmdPart = strtok_r(NULL, "&", &cmdPartChk); //substring it again
            cmdPart++;
            return funcCall(cmdPart, NULL, NULL); //finally run isolated commands
        }
        else
            return -1;
    }
    else if (strstr(cmd, " || ")) //if || exists
    {
        cmdPart = strtok_r(cmd, "|", &cmdPartChk); //substring it
        int len = strlen(cmdPart);
        cmdPart[len - 1] = '\0';
        int check = funcCall(cmdPart, NULL, NULL);
        if (check != 0) //if first function is unsuccessful, run second
        {
            cmdPart = strtok_r(NULL, "|", &cmdPartChk); //substring it again
            cmdPart++;
            return funcCall(cmdPart, NULL, NULL);
        }
        else
            return -1;
    }
    else if (strstr(cmd, " >> ")) //if >> exists
    {
        cmdPart = strtok_r(cmd, ">", &cmdPartChk); //substring it
        int len = strlen(cmdPart);
        cmdPart[len - 1] = '\0';
        char *file = strtok_r(NULL, ">", &cmdPartChk); //substring it again
        file++;
        int check = funcCall(cmdPart, file, ">>"); //call function with cmd to append to file
        return check;
        
    }
    else if (strstr(cmd, " > "))
    {
        cmdPart = strtok_r(cmd, ">", &cmdPartChk); //substring it
        int len = strlen(cmdPart);
        cmdPart[len - 1] = '\0';
        char *file = strtok_r(NULL, ">", &cmdPartChk); //substring it again
        file++;
        int check = funcCall(cmdPart, file, ">"); //call function with cmd to write to file
        return check;
    }
    else if (strstr(cmd, " | ")) //if | exists
    {
        cmdPart = strtok_r(cmd, "|", &cmdPartChk); //substring it
        char* cmdPart2 = strtok_r(NULL, "|", &cmdPartChk);
        
        int fd[2];
        pipe(fd); //pipe
        pid_t pid = fork(); //create child
        
        if(pid == 0) //if child
        {
            dup2(fd[WRITER], STDOUT_FILENO); // piping stdout to current pipeline
        	close(fd[READER]); // close allows reallocation, cleaning up file descriptors
        	close(fd[WRITER]);
        	funcCall(cmdPart, NULL, NULL); // uses first part of pipe
            exit(-1); //breaking if this is reached
        }
        else
        {
        	pid = fork(); //create another child

        	if(pid==0)
        	{
       		dup2(fd[READER], STDIN_FILENO); // piping stdin to current pipeline
       		// stdin comes from prior pipe's stdout
       		// now stdout is used outside of the pipe, exposed to the user
        		close(fd[WRITER]); // same logic as before
        		close(fd[READER]);
        		funcCall(cmdPart2, NULL, NULL); // uses second part of pipe
        		exit(-1);
        	}
        	else
        	{
        		int status;
        		close(fd[READER]); // same logic as before
        		close(fd[WRITER]);
        		return waitpid(pid, &status, 0);
        	}
        }
    }
    else
    {
        return funcCall(cmd, NULL, NULL); //call function with stdout :)
    }
}

// this function checks to see if we're running in the background
int andCheck(char *cmd)
{
    int len = strlen(cmd);
    int curJid; //current job id, job id is only related to " &"
    
    if (cmd[len - 2] == ' ' && cmd[len - 1] == '&') //if " &" is there at end
    {
    	jid += 1; //new job
    	curJid = jid; //this is the current job id
        cmd[len - 2] = '\0'; // removing space &
        char* tempCmd = strdup(cmd); //duplicate : D
        
        int curPid = fork(); //child
        sleep(0.1); //sleep to wait for code to run (stuff just took a while to load, sets forced wait)
        
        if (curPid == 0)
        {
            int res = opCheck(cmd); //ru
            printf("[%i] Done: %s \n", curJid, cmd); //done statement
            pidList[curJid-1] = -1; //child is complete
            exit(res);
            // return opCheck(cmd);
        }
        else
        {
            pidList[curJid-1] = curPid; // new pid as child
        	jobs[curJid-1].name = tempCmd;//add new job name
        	jobs[curJid-1].pid = curPid; //job process id
        	jobs[curJid-1].jid = curJid; //job job id
        	printf("[%i]\n",curJid); //print out job
            // TODO need to get result of &?
            return 0;
        }
        
        
    }
    else
        return opCheck(cmd);
}
// does logic based off of if history is called
void historyCheck(char *cmd)
{
    modCt = cmdAmt % 10; //command count total mod 10 for index in storage
    strcpy(historyQ[modCt], cmd); //add command to history "queue"

    if (front == 10) //if at end of array
    {
        front = 0; //set front to 0 index
    }
    else if (front < 10 && cmdAmt > 9) //otherwise if array is full, increment front index by 1
    {
        front += 1;
    }
}

// prints the current location and gets a command from the user
void getCommand() //general shell running
{
    char *subPath;
    char cmd[MAX_BUF];
    cmdAmt += 1; //increment # of commands
    getcwd(path, MAX_BUF);
    subPath = strrchr(path, '/');

    if (subPath != NULL && strcmp(subPath, "/") != 0)
    {
        subPath++; // step over the slash
    }

    printf("%s$ ", subPath); //print path
    fgets(cmd, 256, stdin); //get cmd from stdin
    if (feof(stdin))//if end of file, exit
    {
    	fclose(stdout);
        exit(0);
	}
	if(strcmp(cmd, "\n") == 0) //if you just hit enter and input nothing, it just asks for another command (weird edge case)
    {
    	getCommand();
    }
	
    cmd[strcspn(cmd, "\n")] = 0; // removing trailing \n

    if (!isatty(fileno(stdin))) //checks for stdin or not
    {
        printf("%s\n", cmd);
        fflush(stdout);
    }
    
    if (strcmp(cmd, "history") != 0) //if not history command (history command history is handled in history command), add command to historyQ
    {
    	
        historyCheck(cmd);
    }

    andCheck(cmd);//check for backgrounds
}
// this func starts up the command
int main(int argc, char *argv[])
{
	pidList = mmap(NULL, MAX_BUF*sizeof(pid_t), PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, 0, 0); 
	//initialize map so child and parent processes can communicate
	//dont know if necessary, but works so...
	
    while (TRUE)
    {
        getCommand(); //run shell
    }
    return 0;
}




