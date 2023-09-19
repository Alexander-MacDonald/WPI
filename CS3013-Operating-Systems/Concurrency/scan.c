/*
 *	Authors: aemacdonald, jweintraub
 *	Date: 3/1/2022
 */

#include <assert.h>
#include <stdio.h>
#include <math.h>
#include <pthread.h>
#include <semaphore.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>

#define MAX_LINE_SIZE 256

int chunkSize = 0; // how many values does each thread look at?
int curPrint = 0;	 // initializing print ticket lock
pthread_t *threadList;
sem_t *locks; // one lock/semaphore for every thread that determines when local summing was finished
int *input;		// a list of every single value to be summed
int *maxSum;	// a list of the last summed values in batches

void read_input_vector(const char *filename, int n, int *array)
{
	FILE *fp;
	char *line = malloc(MAX_LINE_SIZE + 1);
	size_t len = MAX_LINE_SIZE;
	ssize_t read;

	fp = strcmp(filename, "-") ? fopen(filename, "r") : stdin;

	assert(fp != NULL && line != NULL);

	int index = 0;

	while ((read = getline(&line, &len, fp)) != -1)
	{
		array[index] = atoi(line);
		index++;
	}

	free(line);
	fclose(fp);
}

void *sum(void *var)
{
	int index = *((int *)var);
	for (int i = index * chunkSize + 1; i < (index + 1) * chunkSize; i++)
	{
		input[i] += input[i - 1];
	}
	// getting the maximum value of the batch and storing it for later use so it doesn't get altered
	maxSum[index] = input[(index + 1) * chunkSize - 1];
	sem_post(&locks[index]); // maxSum was added to, allow other threads to access

	for (int i = 0; i < index; i++) // going through all the prior threads
	{
		sem_wait(&locks[i]); // checking to see if you finished summing for a prior thread
		sem_post(&locks[i]); // immediately releasing lock so other threads can access
		for (int j = index * chunkSize; j < (index + 1) * chunkSize; j++)
		{
			input[j] += maxSum[i]; // updating sum using previous batches
		}
	}
	while (curPrint != index)
		; // ticket lock for being allowed to print

	for (int i = index * chunkSize; i < (index + 1) * chunkSize; i++)
	{ // concurrently printing each input
		printf("%d\n", input[i]);
	}

	curPrint += 1; // updating ticket lock
	return NULL;
}

int main(int argc, char *argv[])
{
	if (argc < 3)
	{
		exit(EXIT_FAILURE);
	}

	char *filename = argv[1]; // given args
	int n = atoi(argv[2]);
	int threads = atoi(argv[3]);

	chunkSize = n / threads;

	input = malloc(sizeof(int) * n);
	threadList = malloc(sizeof(pthread_t) * threads);
	locks = malloc(sizeof(sem_t) * threads);
	maxSum = malloc(sizeof(int) * threads);

	read_input_vector(filename, n, input);

	for (int j = 0; j < threads; j += 1)
	{
		int *arg = malloc(sizeof(*arg));
		*arg = j;									 // argument is just an int specifying which thread you're looking at
		sem_init(&locks[j], 0, 0); // initializing to 0 so no threads allow to access data of other threads initially
		pthread_create(&threadList[j], NULL, sum, arg);
	}
	for (int j = 0; j < threads; j += 1)
	{ // joining the threads to make print visible
		pthread_join(threadList[j], NULL);
	}

	// unmallocing
	free(input);
	free(threadList);
	free(locks);
	free(maxSum);
}
