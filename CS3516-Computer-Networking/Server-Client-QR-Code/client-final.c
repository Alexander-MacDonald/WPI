// Assignment: 	CS3516 Assignment 1
// Author: 		Alexander MacDonald
// Date: 		11/8/2022

// CLIENT

#include <stdio.h>          // for printf() and fprintf()
#include <sys/socket.h> 	// for socket(), bind(), and connect()
#include <arpa/inet.h>   	// for sockaddr_in and inet_ntoa()
#include <stdlib.h>       	// for atoi() and exit()
#include <string.h>       	// for memset()
#include <unistd.h>      	// for close()
#include <time.h>			// for time

#define RCVBUFSIZE 32

void DieWithError(char *errorMessage)
{
	perror(errorMessage);
	exit(1);
}

int main(int argc, char *argv[])
{
	int sock;							// Socket descriptor 
	struct sockaddr_in serverAddress;	// Echo server address 
	unsigned short serverPort;			// Echo server port 
	char *serverIP;						// Server IP address (dotted quad) 
	char *filePath;						// String to send to echo server 
	char strBuffer[RCVBUFSIZE];			// Buffer for echo string 
	unsigned int filePathLength;		// Length of string to echo 
	int bytesRcvd, totalBytesRcvd;		// Bytes read in single recv() and total bytes read

	if (argc != 4)
	{
		fprintf(stderr, "Usage: %s <Server IP> <File Path> <Port>\n",
        argv[0]);
		exit(1);
	}
	  
	serverIP = argv[1];            	// First arg: server IP address (dotted quad) 
	filePath = argv[2];         	// Second arg: string to echo
	serverPort = atoi(argv[3]);    	// Use given port
	
	// Create socket for outgoing connection
	if((sock = socket (AF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
	{
		DieWithError("socket() failed");
	}
	
	// Construct the server address structure
	memset(&serverAddress, 0, sizeof(serverAddress));		// Zero out structure   
	serverAddress.sin_family = AF_INET;                 // Internet address family 
	serverAddress.sin_addr.s_addr = inet_addr(serverIP);  // Server IP address 
	serverAddress.sin_port = htons(serverPort);   	// Server port  
	
	if(connect(sock, (struct sockaddr *) &serverAddress, sizeof(serverAddress)) < 0)
	{
		DieWithError("connect() failed");
	}
	
	filePathLength = strlen(filePath);          /* Determine input length */
	
	FILE *fileExist = fopen(filePath, "r");
	
	if(!fileExist) 
	{
		DieWithError("File does not exist");
	}
	/* Send the string to the server */
	if(send(sock, filePath, filePathLength, 0) != filePathLength)
	{
		DieWithError("send() sent a different number of bytes than expected");
	}
	
	/* Receive the same string back from the server */
	totalBytesRcvd = 0;	      /* Count of total bytes received     */
	printf("Received: ");                /* Setup to print the echoed string */ 
	
	while (totalBytesRcvd < filePathLength)
	{
		/* Receive up to the buffer size (minus 1 to leave space for 
				                     a null terminator) bytes from the sender */
		if ((bytesRcvd = recv(sock, strBuffer, RCVBUFSIZE - 1, 0)) <= 0)
		{
			DieWithError("recv() failed or connection closed prematurely");
		}
		
		totalBytesRcvd += bytesRcvd;   /* Keep tally of total bytes */ 
		strBuffer[bytesRcvd] = '\0';  /* Terminate the string! */  
		printf("%s", strBuffer);      /* Print the echo buffer */
	}
	
	printf("\n");    /* Print a final linefeed */
	close(sock);
	exit(0);
}

