// Assignment: 	CS3516 Assignment 1
// Author: 		Alexander MacDonald
// Date: 		11/8/2022


// Notes:
// netstat -tulpn
// kill -9 <pid>
// SERVER

#include <stdio.h>          // for printf() and fprintf()
#include <sys/socket.h> 	// for socket(), bind(), and connect()
#include <arpa/inet.h>   	// for sockaddr_in and inet_ntoa()
#include <stdlib.h>       	// for atoi() and exit()
#include <string.h>       	// for memset()
#include <unistd.h>      	// for close()
#include <time.h>			// for time
#include <signal.h>

#define MAX_DATA 1024

int port = 2012;
//unused rate
int rate = 3;
int max_users = 3;
int time_out = 80;

void writeLog(char *log)
{
	//get time
	time_t rawtime;
	struct tm * time_s;
	time(&rawtime);
	time_s = localtime(&rawtime);
	
	//open file
	FILE *logFile = fopen("serverLog.txt", "a");
	
	//write to file date and log
	fprintf(logFile, "%02d-%02d-%d %02d:%02d:%02d %s", time_s->tm_mday, time_s->tm_mon + 1, time_s->tm_year+1900, time_s->tm_hour, time_s->tm_min, time_s->tm_sec, log);
	fclose(logFile);
}

//error handler
void DieWithError(char *errorMessage) 
{
	writeLog(errorMessage);
	perror(errorMessage);
}

//client handler
void HandleTCPClient(int clientSocket) 
{
	int data_len = 1;
	int result_len = 0;
	int newlines = 0;
	
	char c;
    char data[MAX_DATA];
    char result[MAX_DATA];
    char command[100] = "java -cp javase.jar:core.jar com.google.zxing.client.j2se.CommandLineRunner ";
	
	while(data_len)
	{
		data_len = recv(clientSocket, data, MAX_DATA, 0);
		if(data_len)
		{	
			FILE *qr = fopen(data, "r+");
			FILE *res;
			
			if(!qr)
			{
				char *msg = ("File not found from client: %i", clientSocket);
				DieWithError(msg);
			}
			
			strcat(command, data);
			strcat(command, " > QRResult.txt");
			
			system(command);
			
			res = fopen("QRResult.txt", "r+");
			
			if(res)
			{
				c = fgetc(res);
				while(c != EOF)
				{
					if(c == '\n')
					{
						newlines++;
					}
					
					if(newlines == 2)
					{
						result[result_len] = c;
						result_len++;
					}
					c = fgetc(res);
				}
				fclose(res);
			}
	
			strcat(result, "\n");
			
			memmove(result, result+1, strlen(result));
			
			sleep(10);
			
			send(clientSocket, result, result_len, 0);
			printf("Send Message: %s\n", result);
		}
	}
	close(clientSocket);
}

int main(int argc, char *argv[])
{
	int opt;
	
	while((opt = getopt(argc, argv, "p:r:m:t:f:")) != -1)
	{
		switch(opt)
		{
			//port number
			case 'p':
				port = atoi(optarg);
				break;
			case 'r':
			//rate limit
				rate = atoi(optarg);
				break;
			case 'm':
			//max_users for server
				max_users = atoi(optarg);
				break;
			case 't':
			//timeout for forks
				time_out = atoi(optarg);
				break;
		}
	}
	
	printf("Server Starting with Following Values:\n");
	printf("Port: %i\n", port);
	printf("Rate: %i\n", rate);
	printf("Max_users: %i\n", max_users);
	printf("Time_out: %i\n", time_out);
	//printf("File name: %s\n", fileName);
	
	// Create file for logging purposes
	FILE *createFile = fopen("serverLog.txt", "a");
	fclose(createFile);
	
	int serverSocket;                  	/* Socket descriptor for server */
    int clientSocket;                   /* Socket descriptor for client */
    struct sockaddr_in serverAddress; 	/* Local address */
    struct sockaddr_in clientAddress;	/* Client address */
    unsigned short serverPort = port;   /* Server port */
    unsigned int clientLength;          /* Length of client address data structure */ 
	
	// Create socket for incoming connections 
	if((serverSocket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0) 
	{
     	DieWithError("socket() failed\n");
     	exit(1);
    }
    
    // Construct local address structure
    memset(&serverAddress, 0, sizeof(serverAddress));		/* Zero out structure */
    serverAddress.sin_family = AF_INET;						/* Internet address family */
    serverAddress.sin_addr.s_addr = htonl(INADDR_ANY); 		/* Any incoming interface */
    serverAddress.sin_port = htons(serverPort);     		/* Local port */
    
    // Bind to the local address
    if(bind(serverSocket,(struct sockaddr *) &serverAddress, sizeof(serverAddress)) < 0)
    {
		DieWithError("bind() failed\n");
		exit(1);
	}
	
    /* Mark the socket so it will listen for incoming connections */
    if(listen(serverSocket, max_users) < 0)
    {
    	DieWithError("listen() failed\n");
    	exit(1);
    }
   
    writeLog("Server Starting\n");
    
    while(1)
    {
    	//keep track of # of forks made for max_users
    	int numForks = 0;
    	
        // Set the size of the in-out parameter
        clientLength = sizeof(clientAddress);
        
        if((clientSocket = accept(serverSocket, (struct sockaddr *) &clientAddress, &clientLength)) < 0)
        {
        	DieWithError("accept() failed\n");
		}
		
        //client conncted log!
        char *connectionStr = inet_ntoa(clientAddress.sin_addr);
        strcat(connectionStr, " Connected\n");
        writeLog(connectionStr);
        
        
        //using intermediate child to use timeout processes to kill after set time
        
        pid_t combo;
        if(numForks < max_users)
        {
        	numForks++;
        	combo = fork();
        }
        else
       	{
       		DieWithError("ERROR max clients connect to server\n");
       	}
        if(combo == 0) 
        {
        	pid_t qrWork = fork();
        	
        	if(qrWork == 0)
        	{
        		HandleTCPClient(clientSocket);
        		exit(0);
        	}
        	
        	pid_t timeout = fork();
        	if(timeout == 0)
        	{
        		//sleep for time_out amount
        		sleep(time_out);
        		exit(0);
        	}
        	
        	pid_t hmm = waitpid(NULL); //wait for any child to end
        	
        	//if qr finishes
        	if(hmm == qrWork)
        	{
        		//kill timeout
        		kill(timeout, SIGKILL);
        	}
        	//if timeout finishes
        	else
        	{
        		//kill qr
        		kill(qrWork, SIGKILL);
        	}
        	waitpid(NULL);
        	exit(0);
       	}

        //wait for it to finish
        waitpid(combo);
        numForks--;
        
        //disconnect client
        char *disconnectStr = inet_ntoa(clientAddress.sin_addr);
        strcat(disconnectStr, " Disconnected\n");
        writeLog(disconnectStr);
     }
	
}
