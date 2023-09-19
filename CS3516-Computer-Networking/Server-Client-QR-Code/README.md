//Assignment: Project 1
//Author: Alexander MacDonald
//Date: 11/8/2022
//
///////////////////////////////////////////////////////////////////////
//
//Compilation Instruction:
//
//	unzip the submitted files in client and server directories
//  attach any other qr codes tested for both directories
//
//	run command 'make all' in both directories
//		alternatively, run make server & make client individually
//
//  run command 'make clean' to remove all .o files and .txt files
//
///////////////////////////////////////////////////////////////////////
//
//Run Instruction:
//
//
//	Server:
//		./server.o
//		
//	Server Options:
//		
//		-p #####
//			port # specified in command
//		
//		-r ###
//			rate # specified in command
//		
//		-m ###
//			max users # specified in command
//
//		-t ###
//			timeout # specified in command
//
//	Run Examples:
//
//		./server.o
//			Port: 2012
//			Rate: 3
//			Max Users: 3
//			Timeout: 80
//
//		./server.o -p 22222 -r 10 -m 100 -t 10
//			Port: 22222
//			Rate: 10
//			Max Users: 100
//			Timeout: 10
//
//	** Arguments can be done in ANY order and are OPTIONAL
//
///////////////////////////////////////////////////////////////////////
//
//	Client: 
//		./client.o <IP> <QR.PNG> <PORT>
//
//	Client Arguments
//
//		IP - IP of host server
//
//		QR.PNG - File name of QR in directory
//
//		PORT - Port that server is listening
//
//	** Arguments must be done IN order and are REQUIRED
