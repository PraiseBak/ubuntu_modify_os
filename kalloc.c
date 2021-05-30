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
  uint pgrefcount[MAXPHYPAGE]; //20193062 lock 사용할려면 kmem 구조체 안에 변수가 있어야함
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
  uint idx = 0;   //20193062 몇번째 페이지인지 인덱스 가져오기 위한 변수
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
  {  
    idx = V2P(p) / PGSIZE;  //인덱스 값 갱신
    kmem.pgrefcount[idx] = 1;   //20193062 0으로하기보다는 1로해서 일단 무조건 빼고 값을 확인해서 하는 식으로함
    kfree(p);
  }
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
  
  if(kmem.use_lock)
    acquire(&kmem.lock);
  uint idx = V2P(v) / PGSIZE;   //20193062 몇번째 페이지인지 인덱스 가져오기 위한 변수
  kmem.pgrefcount[idx]--;  //20193062 우선 값 빼줌
  if(kmem.pgrefcount[idx] == 0)    //20193062 빼준 값이 0이면 freelist에 추가
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
  uint idx = 0   //20193062 몇번째 페이지인지 인덱스 가져오기 위한 변수

  if(kmem.use_lock)
    acquire(&kmem.lock);
  
  r = kmem.freelist;
  
  if(r)
      idx = V2P((char *)r) / PGSIZE;  //사용가능한 페이지가 존재하면 인덱스 가져옴
      numfreepages--;
      kmem.freelist = r->next;
      kmem.pgrefcount[idx] = 1; //20193062 후에 리턴될 페이지에 해당하는 refcounter를 1로 초기화

  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}

int freemem(){
	return numfreepages;
}


uint get_refcounter(uint pa)
{
    if(pa < V2P(end) || pa >= PHYSTOP) // 20193062 메모리 참조범위 점검
    { // 20193062 
      panic("get_refcounter");  // 20193062  에러 출력
    } // 20193062  
    uint idx = pa / PGSIZE;    // 20193062  몇번째 페이지인지 가져옴  앞서서 가상주소로 인덱스 변환했는데 이게 더 편한듯
    uint result = 0;    //20193062 결과값 변수
    acquire(&kmem.lock);    // 20193062 잠금걸어서 참조 불가하도록 제한검
    
    result = kmem.pgrefcount[idx];    // 20193062 해당하는 ref counter 가져옴

    release(&kmem.lock);  // 20193062 잠금 해제
    return result;      // 20193062  ref counter 반환
}

void dec_refcounter(uint pa)    
{
    if(pa < V2P(end) || pa >= PHYSTOP)  // 20193062 메모리 참조범위 점검
    { // 20193062
      panic("dec_refcounter");  // 20193062  에러 출력
    }  // 20193062 
    uint idx = pa / PGSIZE;    // 20193062  몇번째 페이지인지 가져옴  앞서서 가상주소로 인덱스 변환했는데 이게 더 편한듯
    acquire(&kmem.lock);
    if(kmem.pgrefcount[idx] == 0)  // 20193062 refcounter가 -1이 되는 경우는 없기 때문에 예외처리
    {
      panic("dec_refcounter");  // 20193062  에러 출력
    }
    else
    {
      kmem.pgrefcount[idx]--;   // 20193062 refcounter 값 빼줌
    }
    release(&kmem.lock);  // 20193062  락 해제



}

void inc_refcounter(uint pa)
{
    if(pa < V2P(end) || pa >= PHYSTOP)  // 20193062 메모리 참조범위 점검
    { // 20193062
      panic("inc_refcounter");  // 20193062  에러 출력
    }  // 20193062 
    uint idx = pa / PGSIZE;    // 20193062  몇번째 페이지인지 가져옴 앞서서 가상주소로 인덱스 변환했는데 이게 더 편한듯
    acquire(&kmem.lock);
    kmem.pgrefcount[idx]++;   // 20193062 refcounter 값 더함
    release(&kmem.lock);  // 20193062  락 해제
}
