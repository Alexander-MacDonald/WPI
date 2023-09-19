/*
 * Author(s): aemacdonald, jweintraub
 * Date: 2/3/2022
 * current: 75/75
 * 
 */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <assert.h>
#include <string.h>
#include <limits.h>

//job node for doubly-linked list
struct job
{
  int id; //id of job
  int arrival; //when the process arrives
  int length; //how long the process is
  int startTime; //when the process starts
  int timeLeft; //time left for process
  int timeSpent; //how long the process has spent in the current iteration
  struct job *next; //next process in LL
  struct job *prev; //previous process in LL
};

/*** Globals ***/
int seed = 100; //seed
int maxJid = 0; //highest job ID for all processes

// This is the start of our linked list of jobs, i.e., the job list
struct job *head = NULL; //head of list | used as pivot for round robin, so separate rrhead exists
struct job *RRhead = NULL; //head of list for round robin
struct job *tail = NULL; //end of list

/*** Globals End ***/

/*Function to append a new job to the list*/
struct job *append(int id, int arrival, int length, struct job *prev) //adding jobs to list
{
  // create a new struct and initialize it with the input data
  struct job *tmp = (struct job *)malloc(sizeof(struct job)); //allocate memory

  // tmp->id = numofjobs++;
  tmp->id = id; //set ID
  if(id > maxJid) //if ID is higher than current highest, set new highest
  {
  	maxJid = id;
  }
  //set construction values
  tmp->length = length; 
  tmp->arrival = arrival;
  tmp->startTime = arrival;
  tmp->timeLeft = 0;
  tmp->timeSpent = 0;

  // the new job is the last job
  tmp->next = NULL;
  tmp->prev = prev;

  tail = tmp;
  // Case: job is first to be added, linked list is empty
  if (head == NULL)
  {
    head = tmp;
    return tmp;
  }

  // Add job to end of list
  prev->next = tmp;
  return tmp;
}

/*Function to swap the order of jobs in the linked list*/
/*This function is useful when sorting the job list*/
void swap(struct job *job1, struct job *job2)
{
  assert(job1 != NULL && job2 != NULL); //assert both jobs are not null

  struct job *tmp = job2->next; 
  if (tmp)
  {
    job2->next->prev = job1;
  }
  //new job prev/next logic
  job2->next = job1;
  job1->next = tmp;
  tmp = job1->prev;
  job1->prev = job2;
  job2->prev = tmp;
  
  if (tmp)
  {
  	tmp->next = job2;
  }
  if (job1->next == NULL)
  {
    tail = job1; //set tail
  }
  if (job2->prev == NULL)
  {
    head = job2; //set head (kinda wonky for RR i think)
  }
  return;
}

void updateStartTime() //updates starttime for new iterations of processes
{
  struct job *curJob = head;
  curJob->startTime = curJob->arrival; //start time is arrival
  while (curJob != NULL)
  {
    if (curJob->prev != NULL)
    {
      curJob->startTime = curJob->prev->startTime + curJob->prev->length; //start time is prev's start time plus prev's length
      if (curJob->startTime < curJob->arrival)
      {
      	curJob->startTime = curJob->arrival; //if starttime is less than initial arrival, update it
      }
    }
    curJob = curJob->next; //next process
  }
}

/*Function to read in the workload file and create job list*/
void read_workload_file(char *filename)
{
  int id = 0;
  FILE *fp;
  size_t len = 0;
  ssize_t read;
  char *line = NULL,
       *arrival = NULL,
       *length = NULL;

  struct job *prev = NULL; //head

  if ((fp = fopen(filename, "r")) == NULL)
  {
    exit(EXIT_FAILURE);
  }

  while ((read = getline(&line, &len, fp)) > 1)
  {
  	//remove new line
    arrival = strtok(line, ",\n");
    length = strtok(NULL, ",\n");

    // Make sure neither arrival nor length are null.
    assert(arrival != NULL && length != NULL);
    prev = append(id++, atoi(arrival), atoi(length), prev);
  }

  fclose(fp);

  // Make sure we read in at least one job
  assert(id > 0);

  return;
}

void debugJob(struct job *job)
{
  printf("t=%i: [Job %i] arrived at [%i], ran for: [%i]. timeLeft: [%i] timeSpent: [%i]\n", job->startTime, job->id, job->arrival, job->length, job->timeLeft, job->timeSpent);
}

struct job *append2(int id, int arrival, int length, struct job *prev)
{
  // create a new struct and initialize it with the input data
  struct job *tmp = (struct job *)malloc(sizeof(struct job));

  // tmp->id = numofjobs++;
  tmp->id = id;
  tmp->length = length;
  tmp->arrival = arrival;
  tmp->startTime = 0;
  tmp->timeSpent = 0;
  tmp->timeLeft = 0;

  // the new job is the last job
  tmp->next = NULL;
  tmp->prev = prev;

  // Add job to end of list
  if (prev != NULL)
    prev->next = tmp;
  return tmp;
}

// appends to queue all the jobs that start at a given time
struct job *updateQueue(struct job *queue, struct job *tail, int t)
{
  while (tail != NULL) //update job
  {
    if (tail->arrival == t)
    {
      struct job *temp = append2(tail->id, tail->arrival, tail->length, NULL);
      temp->timeLeft = temp->length;
      if (queue != NULL)
      {
        temp->next = queue;
        queue->prev = temp;
      }
      queue = temp;
    }
    tail = tail->prev;
  }
  return queue;
}

// finds the time of the next closest job to be run
// will return -1 if none is found
int findNextTime(struct job *head, int t)
{
  int bestTime = -1;
  while (head != NULL)
  {
    if (head->arrival > t)
    {
      if (bestTime == -1 || head->arrival < bestTime)
      {
        bestTime = head->arrival;
      }
    }
    head = head->next;
  }
  return bestTime;
}
void policy_rr(struct job *head, int timeSlice)
{
  int priorTime = 0;
  int time = 0;

  // a list of jobs that need to be run
  // head of linked list
  struct job *queue = NULL;
  struct job *queueTail = NULL;

  // a running track of jobs given run sequentally
  // tail of linked list
  struct job *lastUsed = NULL;

  // adds all the new jobs that can run between right after the last job started and the current time
  // done via a for loop to keep FIFO order
  queue = updateQueue(queue, tail, 0); // adds all the jobs that can run at current time in
  queueTail = queue;
  while (queueTail->next != NULL)
  {
    queueTail = queueTail->next;
  }
  do
  {
    //  if this if statement doesn't pass, just proceed to next in queue

    // we have a new job that is being run, append to lastUsed
    // so now new last used should be equal to the current queue
    lastUsed = append2(queue->id, queue->arrival, queue->length, lastUsed);
    if (lastUsed->prev == NULL)
    {
    	RRhead = lastUsed;
    }
    // updating queue and last used vars based off of what happened
    if (queue->timeLeft <= timeSlice)
    {
      // we spent less than the time slice, so update accordingly
      lastUsed->timeSpent = queue->timeLeft;
      queue->timeLeft = 0;
      lastUsed->timeLeft = 0;
    }
    else
    {
      // update time spent to be equal to time slice and lower time left
      lastUsed->timeSpent = timeSlice;
      queue->timeLeft = queue->timeLeft - timeSlice;
      lastUsed->timeLeft = queue->timeLeft;
      queueTail = append2(queue->id, queue->arrival, queue->length, queueTail);
      queueTail->timeLeft = queue->timeLeft;
    }
    // update time variables based off current situation
    priorTime = time + 1;
    time = time + lastUsed->timeSpent;
    // bringing job back to end of list for RR behavior
    // adds all the new jobs that can run between right after the last job started and the current time
    // done via a for loop to keep FIFO order
    queue = queue->next;
    for (int t = time; t >= priorTime; t--)
    {
      queue = updateQueue(queue, tail, t); // adds all the jobs that can run at current time in
      queueTail = queue;
      while (queue != NULL && queueTail->next != NULL)
      {
        queueTail = queueTail->next;
      }
    }
    if (lastUsed->prev)
      lastUsed->startTime = priorTime - 1; // lastUsed->prev->startTime + lastUsed->prev->timeSpent;
    printf("t=%i: [Job %i] arrived at [%i], ran for: [%i]\n", lastUsed->startTime, lastUsed->id, lastUsed->arrival, lastUsed->timeSpent);

    if (queue == NULL)
    {
      int nextTime = findNextTime(head, priorTime - 1); // finds the closest time that can be used
      if (nextTime != -1)
      {
        time = nextTime;
        priorTime = nextTime;
        queue = updateQueue(NULL, tail, nextTime);
        queueTail = queue;
        while (queueTail->next != NULL)
          queueTail = queueTail->next;
      }
    }
  } while (queue != NULL);
}
// each iteration:
// find the best possible head (one to go first)
// update it's startTime variable
// set this one to the head of the ll
// call policy_FIFO with head.next
void policy_generic(struct job *head, int (*swapCheck)(struct job *, struct job *), int verbose)
{
  updateStartTime();
  struct job *curJob = NULL;

  while (curJob == NULL || curJob->next != NULL)
  {
    struct job *temp = tail;
    while (temp->prev)
    {
      if (curJob != NULL && temp->prev->id == curJob->id)
      {
        break;
      }
      struct job *temp2 = temp->prev;
      if (swapCheck(temp, temp2) == 0)
      {
        temp = temp2;
      };
      if (temp->prev != NULL)
        temp = temp->prev;
    }
    /*if(curJob!= NULL){
    temp->startTime = curJob->startTime + curJob->length;
    if(temp->startTime < temp->arrival)temp->startTime = temp->arrival;
    }*/
    curJob = temp;
    if (verbose == 0)
      printf("t=%i: [Job %i] arrived at [%i], ran for: [%i]\n", curJob->startTime, curJob->id, curJob->arrival, curJob->length);
  }
  return;
}

// job 2 first
int policy_FIFO(struct job *job1, struct job *job2)
{
  if (job2->arrival > job1->arrival)
  {
    swap(job2, job1);
    updateStartTime();
    return 0;
  }
  return 1;
}

// job 2 first
int policy_SJFP1(struct job *job1, struct job *job2)
{
  if (job2->arrival > job1->arrival)
  {
    // have another if to compare start time and arrival
    swap(job2, job1);
    updateStartTime();
    return 0;
  }
  return 1;
}

// job 2 first
int policy_SJFP2(struct job *job1, struct job *job2)
{
  if (job2->arrival + job2->length > job1->arrival + job1->length && job1->arrival <= job2->startTime)
  {
    // have another if to compare start time and arrival
    swap(job2, job1);
    updateStartTime();
    return 0;
  }
  return 1;
}

//analyzes workload over different schedulers
void analyze(struct job *head)
{
	int jid, arr, tmp1, tmp2, len= 0;
	/*	jid - job id
		arr - arrival time
		tmp1 - temporary start time
		tmp2 - temporary time spent
		len - length of job
	*/	
	int rt, st, tt, wt = 0;
	/*	rt - response time
		st - start time
		tt - turnaround time
		wt - wait time
	*/
	int lastStart = 0;
	/*
		lastStart - absolute last start of the process
	*/
	int lastLength = 0;
	/*
		lastLength - absolute last length of process runtime
	*/
	double totRT, totTT, totWT = 0;
	/*
		totRT - Total reponse time of all processes
		totTT - Total turnaround time of all processes 
		totWT - Total wait time of all processes
		(dont ask me why i hate floats)
	*/
	
	for(int i = 0; i <= maxJid; i++)
	{
		int count = 0; // this is the first occurance of the process with jid 'i'
		lastStart = 0; // last start is no start
		wt = 0; //weight time for jid is 0
		struct job *curJ = head; //start at head!
		while(curJ != NULL) //check them all
		{
			jid = curJ->id; //get jid
			if(jid == i) //if process is jid
			{
				tmp1 = curJ->startTime; //get start time
				tmp2 = curJ->timeSpent; //get instantaneous time spent
				arr = curJ->arrival; //get arrival time
				len = curJ->length; //get length
				if(tmp2 == 0)
				{
					tmp2 = len; //if timespent = 0 then the process runs to length
				}
				if(tmp1 >= lastStart) //if instantaneous start is greater than last record start
				{
					lastStart = tmp1; //update absolute end
					lastLength = tmp2;
					wt = tmp1 + tmp2 - arr - len; //calc wait time (absolute end - arrival - length)
				}
				
				if(count == 0) //if its the first occurance of the jid
				{
					st = tmp1; //this is the absolute start time
					rt = st - arr; //calc response time
				}
				count += 1; //every jid match after this is not the absolute start :)
			}
			curJ = curJ->next; //next JOB!!!
		}
		tt = (lastStart + lastLength) - arr; //calc turnaround time
		totTT += tt; //sum total of turnaround
		totRT += rt; //sum total of response
		totWT += wt; //sum total of wait
		
		printf("Job %i -- Response time: %i  Turnaround: %i  Wait: %i\n", i, rt, tt, wt);
	}
	double retRT = totRT / (maxJid + 1); //AVERAGES!!!
	double retTT = totTT / (maxJid + 1);
	double retWT = totWT / (maxJid + 1);
	
	printf("Average -- Response: %.2f  Turnaround %.2f  Wait %.2f\n", retRT, retTT, retWT);

}

int main(int argc, char **argv) //starter code
{

  if (argc < 4)
  {
    fprintf(stderr, "missing variables\n");
    fprintf(stderr, "usage: %s analysis-flag policy workload-file slice-duration\n", argv[0]);
    exit(EXIT_FAILURE);
  }

  int analysis = atoi(argv[1]);
  char *policy = argv[2],
       *workload = argv[3];
  int slice_duration = atoi(argv[4]);

  // Note: we use a global variable to point to
  // the start of a linked-list of jobs, i.e., the job list
  read_workload_file(workload);

  if (strcmp(policy, "FIFO") == 0)
  {
    printf("Execution trace with FIFO:\n");
    policy_generic(head, policy_FIFO, 0);
    printf("End of execution with FIFO.\n");
    if (analysis)
    {
      printf("Begin analyzing FIFO:\n");
      analyze(head);
      printf("End analyzing FIFO.\n");
    }

    exit(EXIT_SUCCESS);
  }

  if (strcmp(policy, "SJF") == 0)
  {
    printf("Execution trace with SJF:\n");
    policy_generic(head, policy_SJFP1, 1);
    policy_generic(head, policy_SJFP2, 0);
    printf("End of execution with SJF.\n");
    if (analysis)
    {
      printf("Begin analyzing SJF:\n");
      analyze(head);
      printf("End analyzing SJF.\n");
    }

    exit(EXIT_SUCCESS);
  }

  if (strcmp(policy, "RR") == 0)
  {
    printf("Execution trace with RR:\n");
    policy_rr(head, slice_duration);
    printf("End of execution with RR.\n");
    if (analysis)
    {
      printf("Begin analyzing RR:\n");
      analyze(RRhead);
      printf("End analyzing RR.\n");
    }

    exit(EXIT_SUCCESS);
  }

  exit(EXIT_SUCCESS);
}

