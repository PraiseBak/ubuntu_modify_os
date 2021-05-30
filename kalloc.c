// Physical memory allocator, intended to allocate
// memory for user processes, kernel stacks, page table pages,
// and pipe buffers. Allocates 4096-byte pages.

#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "spinlock.h"
#define MAXPHYPAGE PHYSTOP >> PGSHIFT //20193062 DEFINE 값 설정
uint pgrefcount[MAXPHYPAGE]; //20193062 물리 페이지 개수만큼의 refcount 배열선언
void freerange(void *vstart, void *vend);
extern char end[]; // first address after kernel loaded from ELF file
int numfreepages=0;

 
struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  int use_lock;
  struct run *freelist;
} kmem;

// Initialization happens in two phases.
// 1. main() calls kinit1() while still using entrypgdir to place just
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  //cprintf("%d\n",idx);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
  {  
    pgrefcount[(p - end)/PGSIZE] = 1; 
    kfree(p);
  }
}

//PAGEBREAK: 21
// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
// reference counter 감소해야 및 ref count가 0이되면 freelist에 추가해야함 20193062
void
kfree(char *v)
{

  struct run *r;
  //uint cur_page_idx =(((uint) v  - (uint)end )/ PGSIZE);	//20139062

  
  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");

  // Fill with junk to catch dangling refs.
  
  if(kmem.use_lock)
    acquire(&kmem.lock);
  pgrefcount[(v-end)/PGSIZE]--;  //20193062
  if(pgrefcount[(v-end)/PGSIZE] == 0 )    //20193062
  {    //20193062

    memset(v, 1, PGSIZE);
    numfreepages++; 
    r = (struct run*)v;
    r->next = kmem.freelist;
    kmem.freelist = r;   
  } //20193062 

  if(kmem.use_lock)
    release(&kmem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
  
  r = kmem.freelist;
  
  if(r)
      numfreepages--;
      kmem.freelist = r->next;
      pgrefcount[((char*)r - end) >> PGSHIFT] = 1; //20193062 후에 리턴될 페이지에 해당하는 refcounter를 1로 초기화

  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}

int freemem(){
	return numfreepages;
}
