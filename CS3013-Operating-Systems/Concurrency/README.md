/*
 *    Authors: aemacdonald, jweintraub
 *    Date: 3/1/2022
 */
 
--PART 2 WRITEUP---------------------
 
Consulted with Ben K. for advice on how to preserve concurrency with our base algorithm. 

The design of the solution.
 
 This solution is designed to split the input
 vector by the designated number of threads.
 Then summate the individual sets. Finally,
 taking a snapshot of the last value in the
 thread. Furthermore, all snapshots of threads
 less than the current thread is added to each
 value in the vector.
 
Working Example:
 case of {1 2 3 4 5 6} With 3 threads
 Thread 1:
  {1 2} 
  {1 3} 
  snapshot made
  prints 1 3

 Thread 2:
  {3 4}
  {3 7}
  snapshot made
  waits for thread 1 snapshot
  {6 10}
  waits to be able to print
  prints 6 10

 Thread 3:
  {5 6}
  {5 11}
  snapshot made
  waits for thread 1 snapshot
  {8 14}
  waits for thread 2 snapshot (already likely done by this point as was just waiting for snapshot)
  {15 21}
  waits to be able to print
  prints 15 21

Threaded Computation
 
 Each sum computation in the subset vector is computed by a separate
 thread which is locked until this original computation is done. 
 The max value of this thread's original computation is placed in shared memory between the various threads
 while it's being calculated. Each thread adds the prior thread's maximum to the sum(s) in parallel.
 Printing is considered to be a critical section and needs to be in a total order, therefore, it's locked by a ticket lock.
 One thread could be doing it's computations while another is printing potentially. 

Ensuring Concurrent Correctness

 Threads are entirely isolated in their computation allowing for a partial order as
 they are dependent on previous threads snapshots but will simply wait until they can
 be acquired.
 A semaphore is used to prevent other threads from using the current's maximum until it's calculated.
 A semaphore is used instead of a lock so the lock can occur before any thread is called, as the information is unfinalized.
 An array of maximum thread values is used as the threads update their values after appending to the array. This ensures correctness when adding prior values while also allowing for parallelization. 
 Deadlocks are avoided in this implementation by ensuring that all threads acquired and freed the same locks in the same order. Furthermore, the semaphores are instantly freed.
 
Maximized Concurrent Opportunity

 Every thread is used to the fullest by making it so it always performs calculations 
 while the other threads are running until it's completed where it then returns.
 The workload is evenly divided among the threads through vectors of the same size. 
 The only times the threads are really waiting are in two cases:
 when they wait for the first semaphore to be unlocked or when waiting to print.
 In the first given case, having to wait is like a pseudo barrier, as it's very likely 
 the other threads will be done when the first is done with it's snapshot. 
 If thread 1 finishes before some other threads the code allows for parallelization, which is why a barrier wasn't implemented.
 In the second given case, threads have the opportunity to do calculations while another prints, allowing for greater concurrency.