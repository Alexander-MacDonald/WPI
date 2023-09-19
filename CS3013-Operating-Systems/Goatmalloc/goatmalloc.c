/*
 * Author(s): aemacdonald, jweintraub
 * Date: 2/14/2022
 * current: 117/117
 * 
 */
/* Standard Libraries*/
#include <stdlib.h>
#include <stdio.h>
/* Mmap */
#include <sys/mman.h>
/* Page Size */
#include <unistd.h>
/* Open */
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
/* Header File */
#include "goatmalloc.h"

#include <string.h>

void *START; //start of arena
size_t TRUESIZE; //actual size of arena
int initialized = 0; //if its initialized or not
int statusno = 0;
struct __node_t *head;

extern int init(size_t size)
{
	initialized = 0; //not initialized
	int cmp = (int) size; //get numerical value of size
	
	if(cmp <= 0) //if non positive size input
	{
		return ERR_BAD_ARGUMENTS; //errors in goatmalloc.h
	}
	else
	{
		int fd = open("/dev/zero",O_RDWR); //given code
		
		//attempting to recreate output.txt that resources.php describes...
		printf("Initializing arena:\n...requested size %td bytes\n", size);
		size_t realSize;
		if(cmp % 4096 != 0)
		{
			realSize = 4096 * ((cmp/4096) + 1); //logic for byte size in increments of 4096 bytes i think....
		}
		else
		{
			realSize = cmp;
		}
		TRUESIZE = realSize;
		
		int pageSize = getpagesize();
		//start of init string formatting
		printf("...pagesize is %d bytes\n", pageSize);
		
		printf("...adjusting size with page boundaries\n...adjusted size is %td bytes\n", realSize);
		
		printf("...mapping arena with mmap()\n");
		void *_arena_start = mmap(NULL, realSize, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0); //given code
		START = _arena_start;
		if(fd == 0)//mmap failed to load
		{
			return ERR_SYSCALL_FAILED;
		}
		else
		{
			initialized = 1; //it worked & is initialized
		}
		
		printf("...arena starts at %p\n", START);
		
		printf("...arena ends at %p\n", (START + realSize));
		head = (struct __node_t *)_arena_start;
		head->is_free = 1;
		head->size = realSize - sizeof(node_t);
		head->fwd = NULL;
		head->bwd = NULL;
		printf("...initializing header for initial free chunk\n");
		
		printf("..header size is %lu bytes\n", sizeof(node_t));
		
		return TRUESIZE;
	}
}

extern int destroy()
{
	if(initialized == 0)//if unintialized throw error
	{
		return ERR_UNINITIALIZED;
	}
	printf("...unmapping arena with munmap()\n");
	munmap(START, TRUESIZE); //unitialize map
	return 0;
}

/* Creates chunks inside of arena
First component of chunk is a header of type node.t containing metadata
Second component is area reserved for use by the application
node_t in goatmalloc.h
if chunk at address a, metadata for chunk is adddress ((void*)a) - sizeof(node t)
*/
extern void* walloc(size_t size)
{
	void* res = NULL;
	struct __node_t *temp = head;
	if(temp==NULL)
	{
		statusno = ERR_UNINITIALIZED;
		return NULL;
	}
	//start of walloc print format
	printf("Allocating memory:\n");
	printf("...looking for free chunk of >= %td bytes\n", size);

	while(temp!=NULL)
	{
		if(temp->is_free == 1 && temp->size >=size) //if chunk is found and is free
		{
			break;
		}
		temp = temp->fwd;

	}
	if(temp != NULL)// if chunk found
	{
		printf("...found free chunk of >= %td bytes with header at %p\n", temp->size, temp);
		printf("...free chunk->fwd currently points to (%p)\n", (temp->fwd));
		printf("...free chunk->bwd currently points to (%p)\n", (temp->bwd));
		printf("...checking if splitting is required\n");
		if(temp->size == size || (temp->size > size && temp->size < size + sizeof(node_t))) //logic for not needing splitting
		{
			printf("...splitting not required");
			printf("...updating chunk header at %p\n", temp);
			temp->is_free = 0;
			printf("...being careful with my pointer arthimetic and void pointer casting\n");
			printf("...allocation starts at %p\n",temp+sizeof(node_t)); 
		}
		else if(temp->size > size) //logic for needing splitting
		{
			printf("...splitting required");
			printf("...updating chunk header at %p\n", temp);
			struct __node_t *nextNode = (struct __node_t *)((void *)temp + size + sizeof(node_t));
			temp->is_free = 0; //add new node to linked list logic
			temp->fwd = nextNode;
			nextNode->is_free = 1;
			nextNode->bwd = temp;
			nextNode->size = temp->size - size - sizeof(node_t);
			temp->size = size;
			printf("...being careful with my pointer arthimetic and void pointer casting\n");
			printf("...allocation starts at %p\n",nextNode+sizeof(node_t));   
		}
	res = (void*) temp;
	res = res+sizeof(node_t);
    return res;
	}
	else
	{
		statusno = ERR_OUT_OF_MEMORY;
		return NULL;
	}
}

/* frees existing chunk
pointer points to start of application-usable component in the chunk */
extern void wfree(void *ptr)
{	
	int fullSize = getpagesize() - sizeof(node_t); //max size of chunk not including header
	struct __node_t *chunkHead = ptr - sizeof(node_t); //header of chunk location
	
	//wfree string formatting
	printf("Freeing allocating memory:\n");
	printf("...supplied pointer %p\n", ptr); //param mem location
	printf("...being careful with my pointer arithmetic and void pointer casting");
	printf("...accessing chunk header at %p\n", chunkHead); //go back size of header to get start mem
	printf("...chunk of size %ld\n", chunkHead->size);
	printf("...checking if coalescing is needed");
	if(chunkHead->size== fullSize) //if you're not freeing an entire chunk and have to combine others....
	{
		chunkHead->is_free=1;
		printf("...coalescing not needed.");
	}
	else //full chunk
	{
		printf("...coalescing needed.");
		// freed is moved to back. now can set as free
		chunkHead->is_free=1;
		if(chunkHead->fwd && chunkHead->fwd->is_free == 1) //if chunk infront of it is free
		{
			chunkHead->size += chunkHead->fwd->size + sizeof(node_t); //coalesce
			chunkHead->fwd = chunkHead->fwd->fwd;
			if(chunkHead->fwd)
			{
				chunkHead->fwd->bwd=chunkHead;
			}
		// it's freeing the same thing. need to move the memory addresses down
		}
		if(chunkHead->bwd && chunkHead->bwd->is_free == 1) //if chunk behind it is free
		{
			chunkHead = chunkHead->bwd;//coalesce
			chunkHead->size+=chunkHead->fwd->size + sizeof(node_t);
			chunkHead->fwd= chunkHead->fwd->fwd;
			if(chunkHead->fwd)
			{
				chunkHead->fwd->bwd=chunkHead;
			}
			printf("%lu\n",chunkHead->size);
		}
	
	}
	
}

