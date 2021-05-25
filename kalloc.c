// Physical memory allocator, intended to allocate
// memory for user processes, kernel stacks, page table pages,
// and pipe buffers. Allocates 4096-byte pages.

#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "spinlock.h"


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
  uint pgrefcount[PHYSTOP >> PGSHIFT]; //20193062 페이지는 총 917,504개
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
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE
    kmem.pgrefcounter[(uint)p/(uint)PGSIZE] = 0; //20193062 범위안의 refcounter를 0으로 초기화해줌 p/PGSIZE는 인덱스
    kfree(p);
}

//PAGEBREAK: 21
// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
  if(kmem.pgrefcounter[(uint)p/(uint)PGSIZE] != 0)	//20193062 0인경우는 맨 처음 초기화된 경우
  {	//20193062
    kmem.pgrefcounter[(uint)p/(uint)PGSIZE]--; 	//20193062 counter 감소
  }	//20193062
  if(kmem.pgrefcounter[(uint)p/(uint)PGSIZE] == 0) //20193062 0이 됐다면 프리리스트에 추가
  {
    r = (struct run*)v; //20193062 프리리스트 참조 변수
    r->next = kmem.freelist;	//20193062 프리리스트추가
    kmem.freelist = r;	//20193062 프리리스트 추가
    numfreepages++; //20193062 프리리스트가 추가됐으므로 개수도 증가
  }  //20193062
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
  numfreepages--;
  r = kmem.freelist;
  if(r)
    kmem.freelist = r->next;
    kmem.pgrefcounter[PHYSTOP<<PGSHIFT - numfreepages] = 1;	//20193062 총 페이지크기에서 할당가능한 페이지 개수 = 이번에 할당되는 페이지 인덱스. 배열 인덱스 이므로 -된 뒤 값 할당이 옳다..:
  if(kmem.use_lock)
    release(&kmem.lock);
    return (char*)r;
}

int freemem(){
	return numfreepages;
}



uint get_refcounter(uint pa)	//20193062 pa가 속한 물리 페이지의 reference counter 반환
{
	char * P2V(pa);
	
	
}

void dec_refcounter(uint pa)	//20193062 pa가 속한 물리 페이지의 reference counter 감소
{


}

void inc_refcounter(uint pa)	//20193062 pa가 속한 물리 페이지의 reference counter 증가
{	

}
