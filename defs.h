// kalloc.c
char *kalloc(int n);
void kfree(char *cp, int len);
void kinit(void);

// console.c
void cprintf(char *fmt, ...);
void panic(char *s);
void cons_putc(int);

// proc.c
struct proc;
void setupsegs(struct proc *);
struct proc * newproc(void);
void swtch(void);
void sleep(void *);
void wakeup(void *);

// trap.c
void tvinit(void);
void idtinit(void);

// string.c
void * memcpy(void *dst, void *src, unsigned n);
void * memset(void *dst, int c, unsigned n);
int memcmp(const void *v1, const void *v2, unsigned n);
void *memmove(void *dst, const void *src, unsigned n);

// syscall.c
void syscall(void);

// picirq.c
void irq_setmask_8259A(uint16_t mask);
void pic_init(void);

// mp.c
void mp_init(void);
int cpu(void);
int mp_isbcpu(void);

// spinlock.c
extern uint32_t kernel_lock;
void acquire_spinlock(uint32_t* lock);
void release_spinlock(uint32_t* lock);
void release_grant_spinlock(uint32_t* lock, int cpu);

// main.c
void load_icode(struct proc *p, uint8_t *binary, unsigned size);