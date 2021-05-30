
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 b5 10 80       	mov    $0x8010b5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 60 2f 10 80       	mov    $0x80102f60,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 14 b6 10 80       	mov    $0x8010b614,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	68 c0 6f 10 80       	push   $0x80106fc0
80100051:	68 e0 b5 10 80       	push   $0x8010b5e0
80100056:	e8 65 42 00 00       	call   801042c0 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 2c fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd2c
80100062:	fc 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 30 fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd30
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba dc fc 10 80       	mov    $0x8010fcdc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 c7 6f 10 80       	push   $0x80106fc7
80100097:	50                   	push   %eax
80100098:	e8 13 41 00 00       	call   801041b0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 fd 10 80       	mov    0x8010fd30,%eax

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b0:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d dc fc 10 80       	cmp    $0x8010fcdc,%eax
801000bb:	75 c3                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000df:	68 e0 b5 10 80       	push   $0x8010b5e0
801000e4:	e8 f7 41 00 00       	call   801042e0 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 30 fd 10 80    	mov    0x8010fd30,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Not cached; recycle some unused buffer and clean buffer
  // "clean" because B_DIRTY and not locked means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 2c fd 10 80    	mov    0x8010fd2c,%ebx
80100126:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 e0 b5 10 80       	push   $0x8010b5e0
80100162:	e8 59 43 00 00       	call   801044c0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 7e 40 00 00       	call   801041f0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if(!(b->flags & B_VALID)) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 0d 1f 00 00       	call   80102090 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 ce 6f 10 80       	push   $0x80106fce
80100198:	e8 d3 01 00 00       	call   80100370 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 dd 40 00 00       	call   80104290 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 c7 1e 00 00       	jmp    80102090 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 df 6f 10 80       	push   $0x80106fdf
801001d1:	e8 9a 01 00 00       	call   80100370 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 9c 40 00 00       	call   80104290 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 4c 40 00 00       	call   80104250 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
8010020b:	e8 d0 40 00 00       	call   801042e0 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100241:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 e0 b5 10 80 	movl   $0x8010b5e0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
8010025c:	e9 5f 42 00 00       	jmp    801044c0 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 e6 6f 10 80       	push   $0x80106fe6
80100269:	e8 02 01 00 00       	call   80100370 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 7b 14 00 00       	call   80101700 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 4f 40 00 00       	call   801042e0 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e 9a 00 00 00    	jle    8010033b <consoleread+0xcb>
    while(input.r == input.w){
801002a1:	a1 c0 ff 10 80       	mov    0x8010ffc0,%eax
801002a6:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
801002ac:	74 24                	je     801002d2 <consoleread+0x62>
801002ae:	eb 58                	jmp    80100308 <consoleread+0x98>
      if(proc->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b0:	83 ec 08             	sub    $0x8,%esp
801002b3:	68 20 a5 10 80       	push   $0x8010a520
801002b8:	68 c0 ff 10 80       	push   $0x8010ffc0
801002bd:	e8 9e 3b 00 00       	call   80103e60 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c2:	a1 c0 ff 10 80       	mov    0x8010ffc0,%eax
801002c7:	83 c4 10             	add    $0x10,%esp
801002ca:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
801002d0:	75 36                	jne    80100308 <consoleread+0x98>
      if(proc->killed){
801002d2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801002d8:	8b 40 24             	mov    0x24(%eax),%eax
801002db:	85 c0                	test   %eax,%eax
801002dd:	74 d1                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002df:	83 ec 0c             	sub    $0xc,%esp
801002e2:	68 20 a5 10 80       	push   $0x8010a520
801002e7:	e8 d4 41 00 00       	call   801044c0 <release>
        ilock(ip);
801002ec:	89 3c 24             	mov    %edi,(%esp)
801002ef:	e8 2c 13 00 00       	call   80101620 <ilock>
        return -1;
801002f4:	83 c4 10             	add    $0x10,%esp
801002f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002ff:	5b                   	pop    %ebx
80100300:	5e                   	pop    %esi
80100301:	5f                   	pop    %edi
80100302:	5d                   	pop    %ebp
80100303:	c3                   	ret    
80100304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100308:	8d 50 01             	lea    0x1(%eax),%edx
8010030b:	89 15 c0 ff 10 80    	mov    %edx,0x8010ffc0
80100311:	89 c2                	mov    %eax,%edx
80100313:	83 e2 7f             	and    $0x7f,%edx
80100316:	0f be 92 40 ff 10 80 	movsbl -0x7fef00c0(%edx),%edx
    if(c == C('D')){  // EOF
8010031d:	83 fa 04             	cmp    $0x4,%edx
80100320:	74 39                	je     8010035b <consoleread+0xeb>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
80100322:	83 c6 01             	add    $0x1,%esi
    --n;
80100325:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
80100328:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
8010032b:	88 56 ff             	mov    %dl,-0x1(%esi)
    --n;
    if(c == '\n')
8010032e:	74 35                	je     80100365 <consoleread+0xf5>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100330:	85 db                	test   %ebx,%ebx
80100332:	0f 85 69 ff ff ff    	jne    801002a1 <consoleread+0x31>
80100338:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
8010033b:	83 ec 0c             	sub    $0xc,%esp
8010033e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100341:	68 20 a5 10 80       	push   $0x8010a520
80100346:	e8 75 41 00 00       	call   801044c0 <release>
  ilock(ip);
8010034b:	89 3c 24             	mov    %edi,(%esp)
8010034e:	e8 cd 12 00 00       	call   80101620 <ilock>

  return target - n;
80100353:	83 c4 10             	add    $0x10,%esp
80100356:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100359:	eb a1                	jmp    801002fc <consoleread+0x8c>
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
8010035b:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010035e:	76 05                	jbe    80100365 <consoleread+0xf5>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100360:	a3 c0 ff 10 80       	mov    %eax,0x8010ffc0
80100365:	8b 45 10             	mov    0x10(%ebp),%eax
80100368:	29 d8                	sub    %ebx,%eax
8010036a:	eb cf                	jmp    8010033b <consoleread+0xcb>
8010036c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100370 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100370:	55                   	push   %ebp
80100371:	89 e5                	mov    %esp,%ebp
80100373:	56                   	push   %esi
80100374:	53                   	push   %ebx
80100375:	83 ec 38             	sub    $0x38,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100378:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
80100379:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
{
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
8010037f:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100386:	00 00 00 
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
80100389:	8d 5d d0             	lea    -0x30(%ebp),%ebx
8010038c:	8d 75 f8             	lea    -0x8(%ebp),%esi
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
8010038f:	0f b6 00             	movzbl (%eax),%eax
80100392:	50                   	push   %eax
80100393:	68 ed 6f 10 80       	push   $0x80106fed
80100398:	e8 c3 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039d:	58                   	pop    %eax
8010039e:	ff 75 08             	pushl  0x8(%ebp)
801003a1:	e8 ba 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a6:	c7 04 24 97 78 10 80 	movl   $0x80107897,(%esp)
801003ad:	e8 ae 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b2:	5a                   	pop    %edx
801003b3:	8d 45 08             	lea    0x8(%ebp),%eax
801003b6:	59                   	pop    %ecx
801003b7:	53                   	push   %ebx
801003b8:	50                   	push   %eax
801003b9:	e8 f2 3f 00 00       	call   801043b0 <getcallerpcs>
801003be:	83 c4 10             	add    $0x10,%esp
801003c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c8:	83 ec 08             	sub    $0x8,%esp
801003cb:	ff 33                	pushl  (%ebx)
801003cd:	83 c3 04             	add    $0x4,%ebx
801003d0:	68 09 70 10 80       	push   $0x80107009
801003d5:	e8 86 02 00 00       	call   80100660 <cprintf>
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003da:	83 c4 10             	add    $0x10,%esp
801003dd:	39 f3                	cmp    %esi,%ebx
801003df:	75 e7                	jne    801003c8 <panic+0x58>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003e1:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003e8:	00 00 00 
801003eb:	eb fe                	jmp    801003eb <panic+0x7b>
801003ed:	8d 76 00             	lea    0x0(%esi),%esi

801003f0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003f0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003f6:	85 d2                	test   %edx,%edx
801003f8:	74 06                	je     80100400 <consputc+0x10>
801003fa:	fa                   	cli    
801003fb:	eb fe                	jmp    801003fb <consputc+0xb>
801003fd:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 0c             	sub    $0xc,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 b8 00 00 00    	je     801004ce <consputc+0xde>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 51 57 00 00       	call   80105b70 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	c1 e0 08             	shl    $0x8,%eax
8010043f:	89 c1                	mov    %eax,%ecx
80100441:	b8 0f 00 00 00       	mov    $0xf,%eax
80100446:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100447:	89 f2                	mov    %esi,%edx
80100449:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
8010044a:	0f b6 c0             	movzbl %al,%eax
8010044d:	09 c8                	or     %ecx,%eax

  if(c == '\n')
8010044f:	83 fb 0a             	cmp    $0xa,%ebx
80100452:	0f 84 0b 01 00 00    	je     80100563 <consputc+0x173>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100458:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045e:	0f 84 e6 00 00 00    	je     8010054a <consputc+0x15a>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100464:	0f b6 d3             	movzbl %bl,%edx
80100467:	8d 78 01             	lea    0x1(%eax),%edi
8010046a:	80 ce 07             	or     $0x7,%dh
8010046d:	66 89 94 00 00 80 0b 	mov    %dx,-0x7ff48000(%eax,%eax,1)
80100474:	80 

  if(pos < 0 || pos > 25*80)
80100475:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
8010047b:	0f 8f bc 00 00 00    	jg     8010053d <consputc+0x14d>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
80100481:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100487:	7f 6f                	jg     801004f8 <consputc+0x108>
80100489:	89 f8                	mov    %edi,%eax
8010048b:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
80100492:	89 fb                	mov    %edi,%ebx
80100494:	c1 e8 08             	shr    $0x8,%eax
80100497:	89 c6                	mov    %eax,%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100499:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010049e:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a3:	89 fa                	mov    %edi,%edx
801004a5:	ee                   	out    %al,(%dx)
801004a6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004ab:	89 f0                	mov    %esi,%eax
801004ad:	ee                   	out    %al,(%dx)
801004ae:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b3:	89 fa                	mov    %edi,%edx
801004b5:	ee                   	out    %al,(%dx)
801004b6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004bb:	89 d8                	mov    %ebx,%eax
801004bd:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004be:	b8 20 07 00 00       	mov    $0x720,%eax
801004c3:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c9:	5b                   	pop    %ebx
801004ca:	5e                   	pop    %esi
801004cb:	5f                   	pop    %edi
801004cc:	5d                   	pop    %ebp
801004cd:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004ce:	83 ec 0c             	sub    $0xc,%esp
801004d1:	6a 08                	push   $0x8
801004d3:	e8 98 56 00 00       	call   80105b70 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 8c 56 00 00       	call   80105b70 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 80 56 00 00       	call   80105b70 <uartputc>
801004f0:	83 c4 10             	add    $0x10,%esp
801004f3:	e9 2a ff ff ff       	jmp    80100422 <consputc+0x32>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f8:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
801004fb:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004fe:	68 60 0e 00 00       	push   $0xe60
80100503:	68 a0 80 0b 80       	push   $0x800b80a0
80100508:	68 00 80 0b 80       	push   $0x800b8000
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010050d:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100514:	e8 a7 40 00 00       	call   801045c0 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 e2 3f 00 00       	call   80104510 <memset>
8010052e:	89 f1                	mov    %esi,%ecx
80100530:	83 c4 10             	add    $0x10,%esp
80100533:	be 07 00 00 00       	mov    $0x7,%esi
80100538:	e9 5c ff ff ff       	jmp    80100499 <consputc+0xa9>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010053d:	83 ec 0c             	sub    $0xc,%esp
80100540:	68 0d 70 10 80       	push   $0x8010700d
80100545:	e8 26 fe ff ff       	call   80100370 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
8010054a:	85 c0                	test   %eax,%eax
8010054c:	8d 78 ff             	lea    -0x1(%eax),%edi
8010054f:	0f 85 20 ff ff ff    	jne    80100475 <consputc+0x85>
80100555:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
8010055a:	31 db                	xor    %ebx,%ebx
8010055c:	31 f6                	xor    %esi,%esi
8010055e:	e9 36 ff ff ff       	jmp    80100499 <consputc+0xa9>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
80100563:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100568:	f7 ea                	imul   %edx
8010056a:	89 d0                	mov    %edx,%eax
8010056c:	c1 e8 05             	shr    $0x5,%eax
8010056f:	8d 04 80             	lea    (%eax,%eax,4),%eax
80100572:	c1 e0 04             	shl    $0x4,%eax
80100575:	8d 78 50             	lea    0x50(%eax),%edi
80100578:	e9 f8 fe ff ff       	jmp    80100475 <consputc+0x85>
8010057d:	8d 76 00             	lea    0x0(%esi),%esi

80100580 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d6                	mov    %edx,%esi
80100588:	83 ec 2c             	sub    $0x2c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100590:	74 0c                	je     8010059e <printint+0x1e>
80100592:	89 c7                	mov    %eax,%edi
80100594:	c1 ef 1f             	shr    $0x1f,%edi
80100597:	85 c0                	test   %eax,%eax
80100599:	89 7d d4             	mov    %edi,-0x2c(%ebp)
8010059c:	78 51                	js     801005ef <printint+0x6f>
    x = -xx;
  else
    x = xx;

  i = 0;
8010059e:	31 ff                	xor    %edi,%edi
801005a0:	8d 5d d7             	lea    -0x29(%ebp),%ebx
801005a3:	eb 05                	jmp    801005aa <printint+0x2a>
801005a5:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
801005a8:	89 cf                	mov    %ecx,%edi
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 4f 01             	lea    0x1(%edi),%ecx
801005af:	f7 f6                	div    %esi
801005b1:	0f b6 92 38 70 10 80 	movzbl -0x7fef8fc8(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005ba:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>

  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
801005cb:	8d 4f 02             	lea    0x2(%edi),%ecx
801005ce:	8d 74 0d d7          	lea    -0x29(%ebp,%ecx,1),%esi
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  while(--i >= 0)
    consputc(buf[i]);
801005d8:	0f be 06             	movsbl (%esi),%eax
801005db:	83 ee 01             	sub    $0x1,%esi
801005de:	e8 0d fe ff ff       	call   801003f0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005e3:	39 de                	cmp    %ebx,%esi
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
    consputc(buf[i]);
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
801005ef:	f7 d8                	neg    %eax
801005f1:	eb ab                	jmp    8010059e <printint+0x1e>
801005f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100600 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100609:	ff 75 08             	pushl  0x8(%ebp)
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
8010060c:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060f:	e8 ec 10 00 00       	call   80101700 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 c0 3c 00 00       	call   801042e0 <acquire>
80100620:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100623:	83 c4 10             	add    $0x10,%esp
80100626:	85 f6                	test   %esi,%esi
80100628:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062b:	7e 12                	jle    8010063f <consolewrite+0x3f>
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 b5 fd ff ff       	call   801003f0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010063b:	39 df                	cmp    %ebx,%edi
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 a5 10 80       	push   $0x8010a520
80100647:	e8 74 3e 00 00       	call   801044c0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 cb 0f 00 00       	call   80101620 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100669:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100670:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100673:	0f 85 47 01 00 00    	jne    801007c0 <cprintf+0x160>
    acquire(&cons.lock);

  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c1                	mov    %eax,%ecx
80100680:	0f 84 4f 01 00 00    	je     801007d5 <cprintf+0x175>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
80100689:	31 db                	xor    %ebx,%ebx
8010068b:	8d 75 0c             	lea    0xc(%ebp),%esi
8010068e:	89 cf                	mov    %ecx,%edi
80100690:	85 c0                	test   %eax,%eax
80100692:	75 55                	jne    801006e9 <cprintf+0x89>
80100694:	eb 68                	jmp    801006fe <cprintf+0x9e>
80100696:	8d 76 00             	lea    0x0(%esi),%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
801006a0:	83 c3 01             	add    $0x1,%ebx
801006a3:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
801006a7:	85 d2                	test   %edx,%edx
801006a9:	74 53                	je     801006fe <cprintf+0x9e>
      break;
    switch(c){
801006ab:	83 fa 70             	cmp    $0x70,%edx
801006ae:	74 7a                	je     8010072a <cprintf+0xca>
801006b0:	7f 6e                	jg     80100720 <cprintf+0xc0>
801006b2:	83 fa 25             	cmp    $0x25,%edx
801006b5:	0f 84 ad 00 00 00    	je     80100768 <cprintf+0x108>
801006bb:	83 fa 64             	cmp    $0x64,%edx
801006be:	0f 85 84 00 00 00    	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
801006c4:	8d 46 04             	lea    0x4(%esi),%eax
801006c7:	b9 01 00 00 00       	mov    $0x1,%ecx
801006cc:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d4:	8b 06                	mov    (%esi),%eax
801006d6:	e8 a5 fe ff ff       	call   80100580 <printint>
801006db:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006de:	83 c3 01             	add    $0x1,%ebx
801006e1:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e5:	85 c0                	test   %eax,%eax
801006e7:	74 15                	je     801006fe <cprintf+0x9e>
    if(c != '%'){
801006e9:	83 f8 25             	cmp    $0x25,%eax
801006ec:	74 b2                	je     801006a0 <cprintf+0x40>
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
801006ee:	e8 fd fc ff ff       	call   801003f0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006f3:	83 c3 01             	add    $0x1,%ebx
801006f6:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006fa:	85 c0                	test   %eax,%eax
801006fc:	75 eb                	jne    801006e9 <cprintf+0x89>
      consputc(c);
      break;
    }
  }

  if(locking)
801006fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100701:	85 c0                	test   %eax,%eax
80100703:	74 10                	je     80100715 <cprintf+0xb5>
    release(&cons.lock);
80100705:	83 ec 0c             	sub    $0xc,%esp
80100708:	68 20 a5 10 80       	push   $0x8010a520
8010070d:	e8 ae 3d 00 00       	call   801044c0 <release>
80100712:	83 c4 10             	add    $0x10,%esp
}
80100715:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100718:	5b                   	pop    %ebx
80100719:	5e                   	pop    %esi
8010071a:	5f                   	pop    %edi
8010071b:	5d                   	pop    %ebp
8010071c:	c3                   	ret    
8010071d:	8d 76 00             	lea    0x0(%esi),%esi
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100720:	83 fa 73             	cmp    $0x73,%edx
80100723:	74 5b                	je     80100780 <cprintf+0x120>
80100725:	83 fa 78             	cmp    $0x78,%edx
80100728:	75 1e                	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010072a:	8d 46 04             	lea    0x4(%esi),%eax
8010072d:	31 c9                	xor    %ecx,%ecx
8010072f:	ba 10 00 00 00       	mov    $0x10,%edx
80100734:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100737:	8b 06                	mov    (%esi),%eax
80100739:	e8 42 fe ff ff       	call   80100580 <printint>
8010073e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100741:	eb 9b                	jmp    801006de <cprintf+0x7e>
80100743:	90                   	nop
80100744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100750:	e8 9b fc ff ff       	call   801003f0 <consputc>
      consputc(c);
80100755:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100758:	89 d0                	mov    %edx,%eax
8010075a:	e8 91 fc ff ff       	call   801003f0 <consputc>
      break;
8010075f:	e9 7a ff ff ff       	jmp    801006de <cprintf+0x7e>
80100764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100768:	b8 25 00 00 00       	mov    $0x25,%eax
8010076d:	e8 7e fc ff ff       	call   801003f0 <consputc>
80100772:	e9 7c ff ff ff       	jmp    801006f3 <cprintf+0x93>
80100777:	89 f6                	mov    %esi,%esi
80100779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100780:	8d 46 04             	lea    0x4(%esi),%eax
80100783:	8b 36                	mov    (%esi),%esi
80100785:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100788:	b8 20 70 10 80       	mov    $0x80107020,%eax
8010078d:	85 f6                	test   %esi,%esi
8010078f:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
80100792:	0f be 06             	movsbl (%esi),%eax
80100795:	84 c0                	test   %al,%al
80100797:	74 16                	je     801007af <cprintf+0x14f>
80100799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007a0:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
801007a3:	e8 48 fc ff ff       	call   801003f0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801007a8:	0f be 06             	movsbl (%esi),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
801007af:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801007b2:	e9 27 ff ff ff       	jmp    801006de <cprintf+0x7e>
801007b7:	89 f6                	mov    %esi,%esi
801007b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
801007c0:	83 ec 0c             	sub    $0xc,%esp
801007c3:	68 20 a5 10 80       	push   $0x8010a520
801007c8:	e8 13 3b 00 00       	call   801042e0 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 27 70 10 80       	push   $0x80107027
801007dd:	e8 8e fb ff ff       	call   80100370 <panic>
801007e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801007f0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f0:	55                   	push   %ebp
801007f1:	89 e5                	mov    %esp,%ebp
801007f3:	57                   	push   %edi
801007f4:	56                   	push   %esi
801007f5:	53                   	push   %ebx
  int c, doprocdump = 0;
801007f6:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f8:	83 ec 18             	sub    $0x18,%esp
801007fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007fe:	68 20 a5 10 80       	push   $0x8010a520
80100803:	e8 d8 3a 00 00       	call   801042e0 <acquire>
  while((c = getc()) >= 0){
80100808:	83 c4 10             	add    $0x10,%esp
8010080b:	90                   	nop
8010080c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100810:	ff d3                	call   *%ebx
80100812:	85 c0                	test   %eax,%eax
80100814:	89 c7                	mov    %eax,%edi
80100816:	78 48                	js     80100860 <consoleintr+0x70>
    switch(c){
80100818:	83 ff 10             	cmp    $0x10,%edi
8010081b:	0f 84 3f 01 00 00    	je     80100960 <consoleintr+0x170>
80100821:	7e 5d                	jle    80100880 <consoleintr+0x90>
80100823:	83 ff 15             	cmp    $0x15,%edi
80100826:	0f 84 dc 00 00 00    	je     80100908 <consoleintr+0x118>
8010082c:	83 ff 7f             	cmp    $0x7f,%edi
8010082f:	75 54                	jne    80100885 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100831:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100836:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
8010083c:	74 d2                	je     80100810 <consoleintr+0x20>
        input.e--;
8010083e:	83 e8 01             	sub    $0x1,%eax
80100841:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
        consputc(BACKSPACE);
80100846:	b8 00 01 00 00       	mov    $0x100,%eax
8010084b:	e8 a0 fb ff ff       	call   801003f0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100850:	ff d3                	call   *%ebx
80100852:	85 c0                	test   %eax,%eax
80100854:	89 c7                	mov    %eax,%edi
80100856:	79 c0                	jns    80100818 <consoleintr+0x28>
80100858:	90                   	nop
80100859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100860:	83 ec 0c             	sub    $0xc,%esp
80100863:	68 20 a5 10 80       	push   $0x8010a520
80100868:	e8 53 3c 00 00       	call   801044c0 <release>
  if(doprocdump) {
8010086d:	83 c4 10             	add    $0x10,%esp
80100870:	85 f6                	test   %esi,%esi
80100872:	0f 85 f8 00 00 00    	jne    80100970 <consoleintr+0x180>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100878:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010087b:	5b                   	pop    %ebx
8010087c:	5e                   	pop    %esi
8010087d:	5f                   	pop    %edi
8010087e:	5d                   	pop    %ebp
8010087f:	c3                   	ret    
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100880:	83 ff 08             	cmp    $0x8,%edi
80100883:	74 ac                	je     80100831 <consoleintr+0x41>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100885:	85 ff                	test   %edi,%edi
80100887:	74 87                	je     80100810 <consoleintr+0x20>
80100889:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
8010088e:	89 c2                	mov    %eax,%edx
80100890:	2b 15 c0 ff 10 80    	sub    0x8010ffc0,%edx
80100896:	83 fa 7f             	cmp    $0x7f,%edx
80100899:	0f 87 71 ff ff ff    	ja     80100810 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010089f:	8d 50 01             	lea    0x1(%eax),%edx
801008a2:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008a5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008a8:	89 15 c8 ff 10 80    	mov    %edx,0x8010ffc8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008ae:	0f 84 c8 00 00 00    	je     8010097c <consoleintr+0x18c>
        input.buf[input.e++ % INPUT_BUF] = c;
801008b4:	89 f9                	mov    %edi,%ecx
801008b6:	88 88 40 ff 10 80    	mov    %cl,-0x7fef00c0(%eax)
        consputc(c);
801008bc:	89 f8                	mov    %edi,%eax
801008be:	e8 2d fb ff ff       	call   801003f0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c3:	83 ff 0a             	cmp    $0xa,%edi
801008c6:	0f 84 c1 00 00 00    	je     8010098d <consoleintr+0x19d>
801008cc:	83 ff 04             	cmp    $0x4,%edi
801008cf:	0f 84 b8 00 00 00    	je     8010098d <consoleintr+0x19d>
801008d5:	a1 c0 ff 10 80       	mov    0x8010ffc0,%eax
801008da:	83 e8 80             	sub    $0xffffff80,%eax
801008dd:	39 05 c8 ff 10 80    	cmp    %eax,0x8010ffc8
801008e3:	0f 85 27 ff ff ff    	jne    80100810 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008e9:	83 ec 0c             	sub    $0xc,%esp
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008ec:	a3 c4 ff 10 80       	mov    %eax,0x8010ffc4
          wakeup(&input.r);
801008f1:	68 c0 ff 10 80       	push   $0x8010ffc0
801008f6:	e8 05 37 00 00       	call   80104000 <wakeup>
801008fb:	83 c4 10             	add    $0x10,%esp
801008fe:	e9 0d ff ff ff       	jmp    80100810 <consoleintr+0x20>
80100903:	90                   	nop
80100904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100908:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
8010090d:	39 05 c4 ff 10 80    	cmp    %eax,0x8010ffc4
80100913:	75 2b                	jne    80100940 <consoleintr+0x150>
80100915:	e9 f6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100920:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
        consputc(BACKSPACE);
80100925:	b8 00 01 00 00       	mov    $0x100,%eax
8010092a:	e8 c1 fa ff ff       	call   801003f0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010092f:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100934:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
8010093a:	0f 84 d0 fe ff ff    	je     80100810 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100940:	83 e8 01             	sub    $0x1,%eax
80100943:	89 c2                	mov    %eax,%edx
80100945:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100948:	80 ba 40 ff 10 80 0a 	cmpb   $0xa,-0x7fef00c0(%edx)
8010094f:	75 cf                	jne    80100920 <consoleintr+0x130>
80100951:	e9 ba fe ff ff       	jmp    80100810 <consoleintr+0x20>
80100956:	8d 76 00             	lea    0x0(%esi),%esi
80100959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100960:	be 01 00 00 00       	mov    $0x1,%esi
80100965:	e9 a6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010096a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100970:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100973:	5b                   	pop    %ebx
80100974:	5e                   	pop    %esi
80100975:	5f                   	pop    %edi
80100976:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100977:	e9 74 37 00 00       	jmp    801040f0 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010097c:	c6 80 40 ff 10 80 0a 	movb   $0xa,-0x7fef00c0(%eax)
        consputc(c);
80100983:	b8 0a 00 00 00       	mov    $0xa,%eax
80100988:	e8 63 fa ff ff       	call   801003f0 <consputc>
8010098d:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100992:	e9 52 ff ff ff       	jmp    801008e9 <consoleintr+0xf9>
80100997:	89 f6                	mov    %esi,%esi
80100999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801009a0 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009a6:	68 30 70 10 80       	push   $0x80107030
801009ab:	68 20 a5 10 80       	push   $0x8010a520
801009b0:	e8 0b 39 00 00       	call   801042c0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  picenable(IRQ_KBD);
801009b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
801009bc:	c7 05 8c 09 11 80 00 	movl   $0x80100600,0x8011098c
801009c3:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009c6:	c7 05 88 09 11 80 70 	movl   $0x80100270,0x80110988
801009cd:	02 10 80 
  cons.locking = 1;
801009d0:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801009d7:	00 00 00 

  picenable(IRQ_KBD);
801009da:	e8 31 29 00 00       	call   80103310 <picenable>
  ioapicenable(IRQ_KBD, 0);
801009df:	58                   	pop    %eax
801009e0:	5a                   	pop    %edx
801009e1:	6a 00                	push   $0x0
801009e3:	6a 01                	push   $0x1
801009e5:	e8 66 18 00 00       	call   80102250 <ioapicenable>
}
801009ea:	83 c4 10             	add    $0x10,%esp
801009ed:	c9                   	leave  
801009ee:	c3                   	ret    
801009ef:	90                   	nop

801009f0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009f0:	55                   	push   %ebp
801009f1:	89 e5                	mov    %esp,%ebp
801009f3:	57                   	push   %edi
801009f4:	56                   	push   %esi
801009f5:	53                   	push   %ebx
801009f6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
801009fc:	e8 5f 22 00 00       	call   80102c60 <begin_op>

  if((ip = namei(path)) == 0){
80100a01:	83 ec 0c             	sub    $0xc,%esp
80100a04:	ff 75 08             	pushl  0x8(%ebp)
80100a07:	e8 44 14 00 00       	call   80101e50 <namei>
80100a0c:	83 c4 10             	add    $0x10,%esp
80100a0f:	85 c0                	test   %eax,%eax
80100a11:	0f 84 9f 01 00 00    	je     80100bb6 <exec+0x1c6>
    end_op();
    return -1;
  }
  ilock(ip);
80100a17:	83 ec 0c             	sub    $0xc,%esp
80100a1a:	89 c3                	mov    %eax,%ebx
80100a1c:	50                   	push   %eax
80100a1d:	e8 fe 0b 00 00       	call   80101620 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a22:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a28:	6a 34                	push   $0x34
80100a2a:	6a 00                	push   $0x0
80100a2c:	50                   	push   %eax
80100a2d:	53                   	push   %ebx
80100a2e:	e8 ad 0e 00 00       	call   801018e0 <readi>
80100a33:	83 c4 20             	add    $0x20,%esp
80100a36:	83 f8 34             	cmp    $0x34,%eax
80100a39:	74 25                	je     80100a60 <exec+0x70>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a3b:	83 ec 0c             	sub    $0xc,%esp
80100a3e:	53                   	push   %ebx
80100a3f:	e8 4c 0e 00 00       	call   80101890 <iunlockput>
    end_op();
80100a44:	e8 87 22 00 00       	call   80102cd0 <end_op>
80100a49:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a54:	5b                   	pop    %ebx
80100a55:	5e                   	pop    %esi
80100a56:	5f                   	pop    %edi
80100a57:	5d                   	pop    %ebp
80100a58:	c3                   	ret    
80100a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a60:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a67:	45 4c 46 
80100a6a:	75 cf                	jne    80100a3b <exec+0x4b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a6c:	e8 df 5e 00 00       	call   80106950 <setupkvm>
80100a71:	85 c0                	test   %eax,%eax
80100a73:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100a79:	74 c0                	je     80100a3b <exec+0x4b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a7b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a82:	00 
80100a83:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100a89:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100a90:	00 00 00 
80100a93:	0f 84 c5 00 00 00    	je     80100b5e <exec+0x16e>
80100a99:	31 ff                	xor    %edi,%edi
80100a9b:	eb 18                	jmp    80100ab5 <exec+0xc5>
80100a9d:	8d 76 00             	lea    0x0(%esi),%esi
80100aa0:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100aa7:	83 c7 01             	add    $0x1,%edi
80100aaa:	83 c6 20             	add    $0x20,%esi
80100aad:	39 f8                	cmp    %edi,%eax
80100aaf:	0f 8e a9 00 00 00    	jle    80100b5e <exec+0x16e>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100ab5:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100abb:	6a 20                	push   $0x20
80100abd:	56                   	push   %esi
80100abe:	50                   	push   %eax
80100abf:	53                   	push   %ebx
80100ac0:	e8 1b 0e 00 00       	call   801018e0 <readi>
80100ac5:	83 c4 10             	add    $0x10,%esp
80100ac8:	83 f8 20             	cmp    $0x20,%eax
80100acb:	75 7b                	jne    80100b48 <exec+0x158>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100acd:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100ad4:	75 ca                	jne    80100aa0 <exec+0xb0>
      continue;
    if(ph.memsz < ph.filesz)
80100ad6:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100adc:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ae2:	72 64                	jb     80100b48 <exec+0x158>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ae4:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100aea:	72 5c                	jb     80100b48 <exec+0x158>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aec:	83 ec 04             	sub    $0x4,%esp
80100aef:	50                   	push   %eax
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100afc:	e8 0f 61 00 00       	call   80106c10 <allocuvm>
80100b01:	83 c4 10             	add    $0x10,%esp
80100b04:	85 c0                	test   %eax,%eax
80100b06:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b0c:	74 3a                	je     80100b48 <exec+0x158>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100b0e:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b14:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b19:	75 2d                	jne    80100b48 <exec+0x158>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b1b:	83 ec 0c             	sub    $0xc,%esp
80100b1e:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b24:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b2a:	53                   	push   %ebx
80100b2b:	50                   	push   %eax
80100b2c:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b32:	e8 19 60 00 00       	call   80106b50 <loaduvm>
80100b37:	83 c4 20             	add    $0x20,%esp
80100b3a:	85 c0                	test   %eax,%eax
80100b3c:	0f 89 5e ff ff ff    	jns    80100aa0 <exec+0xb0>
80100b42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b48:	83 ec 0c             	sub    $0xc,%esp
80100b4b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b51:	e8 ea 61 00 00       	call   80106d40 <freevm>
80100b56:	83 c4 10             	add    $0x10,%esp
80100b59:	e9 dd fe ff ff       	jmp    80100a3b <exec+0x4b>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b5e:	83 ec 0c             	sub    $0xc,%esp
80100b61:	53                   	push   %ebx
80100b62:	e8 29 0d 00 00       	call   80101890 <iunlockput>
  end_op();
80100b67:	e8 64 21 00 00       	call   80102cd0 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b6c:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b72:	83 c4 0c             	add    $0xc,%esp
  end_op();
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b75:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b7a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b7f:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b85:	52                   	push   %edx
80100b86:	50                   	push   %eax
80100b87:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b8d:	e8 7e 60 00 00       	call   80106c10 <allocuvm>
80100b92:	83 c4 10             	add    $0x10,%esp
80100b95:	85 c0                	test   %eax,%eax
80100b97:	89 c6                	mov    %eax,%esi
80100b99:	75 2a                	jne    80100bc5 <exec+0x1d5>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b9b:	83 ec 0c             	sub    $0xc,%esp
80100b9e:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ba4:	e8 97 61 00 00       	call   80106d40 <freevm>
80100ba9:	83 c4 10             	add    $0x10,%esp
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100bac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bb1:	e9 9b fe ff ff       	jmp    80100a51 <exec+0x61>
  pde_t *pgdir, *oldpgdir;

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100bb6:	e8 15 21 00 00       	call   80102cd0 <end_op>
    return -1;
80100bbb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bc0:	e9 8c fe ff ff       	jmp    80100a51 <exec+0x61>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bc5:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bcb:	83 ec 08             	sub    $0x8,%esp
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bce:	31 ff                	xor    %edi,%edi
80100bd0:	89 f3                	mov    %esi,%ebx
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bd2:	50                   	push   %eax
80100bd3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100bd9:	e8 e2 61 00 00       	call   80106dc0 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bde:	8b 45 0c             	mov    0xc(%ebp),%eax
80100be1:	83 c4 10             	add    $0x10,%esp
80100be4:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100bea:	8b 00                	mov    (%eax),%eax
80100bec:	85 c0                	test   %eax,%eax
80100bee:	74 6d                	je     80100c5d <exec+0x26d>
80100bf0:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100bf6:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100bfc:	eb 07                	jmp    80100c05 <exec+0x215>
80100bfe:	66 90                	xchg   %ax,%ax
    if(argc >= MAXARG)
80100c00:	83 ff 20             	cmp    $0x20,%edi
80100c03:	74 96                	je     80100b9b <exec+0x1ab>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c05:	83 ec 0c             	sub    $0xc,%esp
80100c08:	50                   	push   %eax
80100c09:	e8 42 3b 00 00       	call   80104750 <strlen>
80100c0e:	f7 d0                	not    %eax
80100c10:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c12:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c15:	5a                   	pop    %edx

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c16:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c19:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c1c:	e8 2f 3b 00 00       	call   80104750 <strlen>
80100c21:	83 c0 01             	add    $0x1,%eax
80100c24:	50                   	push   %eax
80100c25:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c28:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c2b:	53                   	push   %ebx
80100c2c:	56                   	push   %esi
80100c2d:	e8 ee 62 00 00       	call   80106f20 <copyout>
80100c32:	83 c4 20             	add    $0x20,%esp
80100c35:	85 c0                	test   %eax,%eax
80100c37:	0f 88 5e ff ff ff    	js     80100b9b <exec+0x1ab>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c3d:	8b 45 0c             	mov    0xc(%ebp),%eax
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c40:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c47:	83 c7 01             	add    $0x1,%edi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c4a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c50:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c53:	85 c0                	test   %eax,%eax
80100c55:	75 a9                	jne    80100c00 <exec+0x210>
80100c57:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c5d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c64:	89 d9                	mov    %ebx,%ecx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100c66:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c6d:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100c71:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c78:	ff ff ff 
  ustack[1] = argc;
80100c7b:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c81:	29 c1                	sub    %eax,%ecx

  sp -= (3+argc+1) * 4;
80100c83:	83 c0 0c             	add    $0xc,%eax
80100c86:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c88:	50                   	push   %eax
80100c89:	52                   	push   %edx
80100c8a:	53                   	push   %ebx
80100c8b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c91:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c97:	e8 84 62 00 00       	call   80106f20 <copyout>
80100c9c:	83 c4 10             	add    $0x10,%esp
80100c9f:	85 c0                	test   %eax,%eax
80100ca1:	0f 88 f4 fe ff ff    	js     80100b9b <exec+0x1ab>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ca7:	8b 45 08             	mov    0x8(%ebp),%eax
80100caa:	0f b6 10             	movzbl (%eax),%edx
80100cad:	84 d2                	test   %dl,%dl
80100caf:	74 19                	je     80100cca <exec+0x2da>
80100cb1:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cb4:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
80100cb7:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cba:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100cbd:	0f 44 c8             	cmove  %eax,%ecx
80100cc0:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cc3:	84 d2                	test   %dl,%dl
80100cc5:	75 f0                	jne    80100cb7 <exec+0x2c7>
80100cc7:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100cca:	50                   	push   %eax
80100ccb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100cd1:	6a 10                	push   $0x10
80100cd3:	ff 75 08             	pushl  0x8(%ebp)
80100cd6:	83 c0 6c             	add    $0x6c,%eax
80100cd9:	50                   	push   %eax
80100cda:	e8 31 3a 00 00       	call   80104710 <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100cdf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  proc->pgdir = pgdir;
80100ce5:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100ceb:	8b 78 04             	mov    0x4(%eax),%edi
  proc->pgdir = pgdir;
  proc->sz = sz;
80100cee:	89 30                	mov    %esi,(%eax)
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));

  // Commit to the user image.
  oldpgdir = proc->pgdir;
  proc->pgdir = pgdir;
80100cf0:	89 48 04             	mov    %ecx,0x4(%eax)
  proc->sz = sz;
  proc->tf->eip = elf.entry;  // main
80100cf3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100cf9:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
80100cff:	8b 50 18             	mov    0x18(%eax),%edx
80100d02:	89 4a 38             	mov    %ecx,0x38(%edx)
  proc->tf->esp = sp;
80100d05:	8b 50 18             	mov    0x18(%eax),%edx
80100d08:	89 5a 44             	mov    %ebx,0x44(%edx)
  switchuvm(proc);
80100d0b:	89 04 24             	mov    %eax,(%esp)
80100d0e:	e8 ed 5c 00 00       	call   80106a00 <switchuvm>
  freevm(oldpgdir);
80100d13:	89 3c 24             	mov    %edi,(%esp)
80100d16:	e8 25 60 00 00       	call   80106d40 <freevm>
  return 0;
80100d1b:	83 c4 10             	add    $0x10,%esp
80100d1e:	31 c0                	xor    %eax,%eax
80100d20:	e9 2c fd ff ff       	jmp    80100a51 <exec+0x61>
80100d25:	66 90                	xchg   %ax,%ax
80100d27:	66 90                	xchg   %ax,%ax
80100d29:	66 90                	xchg   %ax,%ax
80100d2b:	66 90                	xchg   %ax,%ax
80100d2d:	66 90                	xchg   %ax,%ax
80100d2f:	90                   	nop

80100d30 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d30:	55                   	push   %ebp
80100d31:	89 e5                	mov    %esp,%ebp
80100d33:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d36:	68 49 70 10 80       	push   $0x80107049
80100d3b:	68 e0 ff 10 80       	push   $0x8010ffe0
80100d40:	e8 7b 35 00 00       	call   801042c0 <initlock>
}
80100d45:	83 c4 10             	add    $0x10,%esp
80100d48:	c9                   	leave  
80100d49:	c3                   	ret    
80100d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d50 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d50:	55                   	push   %ebp
80100d51:	89 e5                	mov    %esp,%ebp
80100d53:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d54:	bb 14 00 11 80       	mov    $0x80110014,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d59:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d5c:	68 e0 ff 10 80       	push   $0x8010ffe0
80100d61:	e8 7a 35 00 00       	call   801042e0 <acquire>
80100d66:	83 c4 10             	add    $0x10,%esp
80100d69:	eb 10                	jmp    80100d7b <filealloc+0x2b>
80100d6b:	90                   	nop
80100d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d70:	83 c3 18             	add    $0x18,%ebx
80100d73:	81 fb 74 09 11 80    	cmp    $0x80110974,%ebx
80100d79:	74 25                	je     80100da0 <filealloc+0x50>
    if(f->ref == 0){
80100d7b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d7e:	85 c0                	test   %eax,%eax
80100d80:	75 ee                	jne    80100d70 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100d82:	83 ec 0c             	sub    $0xc,%esp
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100d85:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100d8c:	68 e0 ff 10 80       	push   $0x8010ffe0
80100d91:	e8 2a 37 00 00       	call   801044c0 <release>
      return f;
80100d96:	89 d8                	mov    %ebx,%eax
80100d98:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100d9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100d9e:	c9                   	leave  
80100d9f:	c3                   	ret    
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100da0:	83 ec 0c             	sub    $0xc,%esp
80100da3:	68 e0 ff 10 80       	push   $0x8010ffe0
80100da8:	e8 13 37 00 00       	call   801044c0 <release>
  return 0;
80100dad:	83 c4 10             	add    $0x10,%esp
80100db0:	31 c0                	xor    %eax,%eax
}
80100db2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100db5:	c9                   	leave  
80100db6:	c3                   	ret    
80100db7:	89 f6                	mov    %esi,%esi
80100db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100dc0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100dc0:	55                   	push   %ebp
80100dc1:	89 e5                	mov    %esp,%ebp
80100dc3:	53                   	push   %ebx
80100dc4:	83 ec 10             	sub    $0x10,%esp
80100dc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dca:	68 e0 ff 10 80       	push   $0x8010ffe0
80100dcf:	e8 0c 35 00 00       	call   801042e0 <acquire>
  if(f->ref < 1)
80100dd4:	8b 43 04             	mov    0x4(%ebx),%eax
80100dd7:	83 c4 10             	add    $0x10,%esp
80100dda:	85 c0                	test   %eax,%eax
80100ddc:	7e 1a                	jle    80100df8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100dde:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100de1:	83 ec 0c             	sub    $0xc,%esp
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
80100de4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100de7:	68 e0 ff 10 80       	push   $0x8010ffe0
80100dec:	e8 cf 36 00 00       	call   801044c0 <release>
  return f;
}
80100df1:	89 d8                	mov    %ebx,%eax
80100df3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100df6:	c9                   	leave  
80100df7:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100df8:	83 ec 0c             	sub    $0xc,%esp
80100dfb:	68 50 70 10 80       	push   $0x80107050
80100e00:	e8 6b f5 ff ff       	call   80100370 <panic>
80100e05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e10 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	57                   	push   %edi
80100e14:	56                   	push   %esi
80100e15:	53                   	push   %ebx
80100e16:	83 ec 28             	sub    $0x28,%esp
80100e19:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e1c:	68 e0 ff 10 80       	push   $0x8010ffe0
80100e21:	e8 ba 34 00 00       	call   801042e0 <acquire>
  if(f->ref < 1)
80100e26:	8b 47 04             	mov    0x4(%edi),%eax
80100e29:	83 c4 10             	add    $0x10,%esp
80100e2c:	85 c0                	test   %eax,%eax
80100e2e:	0f 8e 9b 00 00 00    	jle    80100ecf <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e34:	83 e8 01             	sub    $0x1,%eax
80100e37:	85 c0                	test   %eax,%eax
80100e39:	89 47 04             	mov    %eax,0x4(%edi)
80100e3c:	74 1a                	je     80100e58 <fileclose+0x48>
    release(&ftable.lock);
80100e3e:	c7 45 08 e0 ff 10 80 	movl   $0x8010ffe0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e45:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e48:	5b                   	pop    %ebx
80100e49:	5e                   	pop    %esi
80100e4a:	5f                   	pop    %edi
80100e4b:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e4c:	e9 6f 36 00 00       	jmp    801044c0 <release>
80100e51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
80100e58:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e5c:	8b 1f                	mov    (%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e5e:	83 ec 0c             	sub    $0xc,%esp
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e61:	8b 77 0c             	mov    0xc(%edi),%esi
  f->ref = 0;
  f->type = FD_NONE;
80100e64:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e6a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e6d:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e70:	68 e0 ff 10 80       	push   $0x8010ffe0
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e75:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e78:	e8 43 36 00 00       	call   801044c0 <release>

  if(ff.type == FD_PIPE)
80100e7d:	83 c4 10             	add    $0x10,%esp
80100e80:	83 fb 01             	cmp    $0x1,%ebx
80100e83:	74 13                	je     80100e98 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100e85:	83 fb 02             	cmp    $0x2,%ebx
80100e88:	74 26                	je     80100eb0 <fileclose+0xa0>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e8d:	5b                   	pop    %ebx
80100e8e:	5e                   	pop    %esi
80100e8f:	5f                   	pop    %edi
80100e90:	5d                   	pop    %ebp
80100e91:	c3                   	ret    
80100e92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100e98:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100e9c:	83 ec 08             	sub    $0x8,%esp
80100e9f:	53                   	push   %ebx
80100ea0:	56                   	push   %esi
80100ea1:	e8 3a 26 00 00       	call   801034e0 <pipeclose>
80100ea6:	83 c4 10             	add    $0x10,%esp
80100ea9:	eb df                	jmp    80100e8a <fileclose+0x7a>
80100eab:	90                   	nop
80100eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100eb0:	e8 ab 1d 00 00       	call   80102c60 <begin_op>
    iput(ff.ip);
80100eb5:	83 ec 0c             	sub    $0xc,%esp
80100eb8:	ff 75 e0             	pushl  -0x20(%ebp)
80100ebb:	e8 90 08 00 00       	call   80101750 <iput>
    end_op();
80100ec0:	83 c4 10             	add    $0x10,%esp
  }
}
80100ec3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ec6:	5b                   	pop    %ebx
80100ec7:	5e                   	pop    %esi
80100ec8:	5f                   	pop    %edi
80100ec9:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100eca:	e9 01 1e 00 00       	jmp    80102cd0 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100ecf:	83 ec 0c             	sub    $0xc,%esp
80100ed2:	68 58 70 10 80       	push   $0x80107058
80100ed7:	e8 94 f4 ff ff       	call   80100370 <panic>
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ee0 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ee0:	55                   	push   %ebp
80100ee1:	89 e5                	mov    %esp,%ebp
80100ee3:	53                   	push   %ebx
80100ee4:	83 ec 04             	sub    $0x4,%esp
80100ee7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100eea:	83 3b 02             	cmpl   $0x2,(%ebx)
80100eed:	75 31                	jne    80100f20 <filestat+0x40>
    ilock(f->ip);
80100eef:	83 ec 0c             	sub    $0xc,%esp
80100ef2:	ff 73 10             	pushl  0x10(%ebx)
80100ef5:	e8 26 07 00 00       	call   80101620 <ilock>
    stati(f->ip, st);
80100efa:	58                   	pop    %eax
80100efb:	5a                   	pop    %edx
80100efc:	ff 75 0c             	pushl  0xc(%ebp)
80100eff:	ff 73 10             	pushl  0x10(%ebx)
80100f02:	e8 a9 09 00 00       	call   801018b0 <stati>
    iunlock(f->ip);
80100f07:	59                   	pop    %ecx
80100f08:	ff 73 10             	pushl  0x10(%ebx)
80100f0b:	e8 f0 07 00 00       	call   80101700 <iunlock>
    return 0;
80100f10:	83 c4 10             	add    $0x10,%esp
80100f13:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f18:	c9                   	leave  
80100f19:	c3                   	ret    
80100f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f28:	c9                   	leave  
80100f29:	c3                   	ret    
80100f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f30 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f30:	55                   	push   %ebp
80100f31:	89 e5                	mov    %esp,%ebp
80100f33:	57                   	push   %edi
80100f34:	56                   	push   %esi
80100f35:	53                   	push   %ebx
80100f36:	83 ec 0c             	sub    $0xc,%esp
80100f39:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f3c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f3f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f42:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f46:	74 60                	je     80100fa8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f48:	8b 03                	mov    (%ebx),%eax
80100f4a:	83 f8 01             	cmp    $0x1,%eax
80100f4d:	74 41                	je     80100f90 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f4f:	83 f8 02             	cmp    $0x2,%eax
80100f52:	75 5b                	jne    80100faf <fileread+0x7f>
    ilock(f->ip);
80100f54:	83 ec 0c             	sub    $0xc,%esp
80100f57:	ff 73 10             	pushl  0x10(%ebx)
80100f5a:	e8 c1 06 00 00       	call   80101620 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f5f:	57                   	push   %edi
80100f60:	ff 73 14             	pushl  0x14(%ebx)
80100f63:	56                   	push   %esi
80100f64:	ff 73 10             	pushl  0x10(%ebx)
80100f67:	e8 74 09 00 00       	call   801018e0 <readi>
80100f6c:	83 c4 20             	add    $0x20,%esp
80100f6f:	85 c0                	test   %eax,%eax
80100f71:	89 c6                	mov    %eax,%esi
80100f73:	7e 03                	jle    80100f78 <fileread+0x48>
      f->off += r;
80100f75:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f78:	83 ec 0c             	sub    $0xc,%esp
80100f7b:	ff 73 10             	pushl  0x10(%ebx)
80100f7e:	e8 7d 07 00 00       	call   80101700 <iunlock>
    return r;
80100f83:	83 c4 10             	add    $0x10,%esp
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f86:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100f88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8b:	5b                   	pop    %ebx
80100f8c:	5e                   	pop    %esi
80100f8d:	5f                   	pop    %edi
80100f8e:	5d                   	pop    %ebp
80100f8f:	c3                   	ret    
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100f90:	8b 43 0c             	mov    0xc(%ebx),%eax
80100f93:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100f96:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f99:	5b                   	pop    %ebx
80100f9a:	5e                   	pop    %esi
80100f9b:	5f                   	pop    %edi
80100f9c:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100f9d:	e9 0e 27 00 00       	jmp    801036b0 <piperead>
80100fa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100fa8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fad:	eb d9                	jmp    80100f88 <fileread+0x58>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100faf:	83 ec 0c             	sub    $0xc,%esp
80100fb2:	68 62 70 10 80       	push   $0x80107062
80100fb7:	e8 b4 f3 ff ff       	call   80100370 <panic>
80100fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100fc0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fc0:	55                   	push   %ebp
80100fc1:	89 e5                	mov    %esp,%ebp
80100fc3:	57                   	push   %edi
80100fc4:	56                   	push   %esi
80100fc5:	53                   	push   %ebx
80100fc6:	83 ec 1c             	sub    $0x1c,%esp
80100fc9:	8b 75 08             	mov    0x8(%ebp),%esi
80100fcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fcf:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fd3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100fd6:	8b 45 10             	mov    0x10(%ebp),%eax
80100fd9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100fdc:	0f 84 aa 00 00 00    	je     8010108c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80100fe2:	8b 06                	mov    (%esi),%eax
80100fe4:	83 f8 01             	cmp    $0x1,%eax
80100fe7:	0f 84 c2 00 00 00    	je     801010af <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100fed:	83 f8 02             	cmp    $0x2,%eax
80100ff0:	0f 85 d8 00 00 00    	jne    801010ce <filewrite+0x10e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80100ff6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ff9:	31 ff                	xor    %edi,%edi
80100ffb:	85 c0                	test   %eax,%eax
80100ffd:	7f 34                	jg     80101033 <filewrite+0x73>
80100fff:	e9 9c 00 00 00       	jmp    801010a0 <filewrite+0xe0>
80101004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101008:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010100b:	83 ec 0c             	sub    $0xc,%esp
8010100e:	ff 76 10             	pushl  0x10(%esi)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101011:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101014:	e8 e7 06 00 00       	call   80101700 <iunlock>
      end_op();
80101019:	e8 b2 1c 00 00       	call   80102cd0 <end_op>
8010101e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101021:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101024:	39 d8                	cmp    %ebx,%eax
80101026:	0f 85 95 00 00 00    	jne    801010c1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
8010102c:	01 c7                	add    %eax,%edi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010102e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101031:	7e 6d                	jle    801010a0 <filewrite+0xe0>
      int n1 = n - i;
80101033:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101036:	b8 00 1a 00 00       	mov    $0x1a00,%eax
8010103b:	29 fb                	sub    %edi,%ebx
8010103d:	81 fb 00 1a 00 00    	cmp    $0x1a00,%ebx
80101043:	0f 4f d8             	cmovg  %eax,%ebx
      if(n1 > max)
        n1 = max;

      begin_op();
80101046:	e8 15 1c 00 00       	call   80102c60 <begin_op>
      ilock(f->ip);
8010104b:	83 ec 0c             	sub    $0xc,%esp
8010104e:	ff 76 10             	pushl  0x10(%esi)
80101051:	e8 ca 05 00 00       	call   80101620 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101056:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101059:	53                   	push   %ebx
8010105a:	ff 76 14             	pushl  0x14(%esi)
8010105d:	01 f8                	add    %edi,%eax
8010105f:	50                   	push   %eax
80101060:	ff 76 10             	pushl  0x10(%esi)
80101063:	e8 78 09 00 00       	call   801019e0 <writei>
80101068:	83 c4 20             	add    $0x20,%esp
8010106b:	85 c0                	test   %eax,%eax
8010106d:	7f 99                	jg     80101008 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
8010106f:	83 ec 0c             	sub    $0xc,%esp
80101072:	ff 76 10             	pushl  0x10(%esi)
80101075:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101078:	e8 83 06 00 00       	call   80101700 <iunlock>
      end_op();
8010107d:	e8 4e 1c 00 00       	call   80102cd0 <end_op>

      if(r < 0)
80101082:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101085:	83 c4 10             	add    $0x10,%esp
80101088:	85 c0                	test   %eax,%eax
8010108a:	74 98                	je     80101024 <filewrite+0x64>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010108c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
8010108f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101094:	5b                   	pop    %ebx
80101095:	5e                   	pop    %esi
80101096:	5f                   	pop    %edi
80101097:	5d                   	pop    %ebp
80101098:	c3                   	ret    
80101099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010a0:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801010a3:	75 e7                	jne    8010108c <filewrite+0xcc>
  }
  panic("filewrite");
}
801010a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010a8:	89 f8                	mov    %edi,%eax
801010aa:	5b                   	pop    %ebx
801010ab:	5e                   	pop    %esi
801010ac:	5f                   	pop    %edi
801010ad:	5d                   	pop    %ebp
801010ae:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010af:	8b 46 0c             	mov    0xc(%esi),%eax
801010b2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010b8:	5b                   	pop    %ebx
801010b9:	5e                   	pop    %esi
801010ba:	5f                   	pop    %edi
801010bb:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010bc:	e9 bf 24 00 00       	jmp    80103580 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801010c1:	83 ec 0c             	sub    $0xc,%esp
801010c4:	68 6b 70 10 80       	push   $0x8010706b
801010c9:	e8 a2 f2 ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010ce:	83 ec 0c             	sub    $0xc,%esp
801010d1:	68 71 70 10 80       	push   $0x80107071
801010d6:	e8 95 f2 ff ff       	call   80100370 <panic>
801010db:	66 90                	xchg   %ax,%ax
801010dd:	66 90                	xchg   %ax,%ax
801010df:	90                   	nop

801010e0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801010e0:	55                   	push   %ebp
801010e1:	89 e5                	mov    %esp,%ebp
801010e3:	57                   	push   %edi
801010e4:	56                   	push   %esi
801010e5:	53                   	push   %ebx
801010e6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801010e9:	8b 0d e0 09 11 80    	mov    0x801109e0,%ecx
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801010ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801010f2:	85 c9                	test   %ecx,%ecx
801010f4:	0f 84 85 00 00 00    	je     8010117f <balloc+0x9f>
801010fa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101101:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101104:	83 ec 08             	sub    $0x8,%esp
80101107:	89 f0                	mov    %esi,%eax
80101109:	c1 f8 0c             	sar    $0xc,%eax
8010110c:	03 05 f8 09 11 80    	add    0x801109f8,%eax
80101112:	50                   	push   %eax
80101113:	ff 75 d8             	pushl  -0x28(%ebp)
80101116:	e8 b5 ef ff ff       	call   801000d0 <bread>
8010111b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010111e:	a1 e0 09 11 80       	mov    0x801109e0,%eax
80101123:	83 c4 10             	add    $0x10,%esp
80101126:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101129:	31 c0                	xor    %eax,%eax
8010112b:	eb 2d                	jmp    8010115a <balloc+0x7a>
8010112d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101130:	89 c1                	mov    %eax,%ecx
80101132:	ba 01 00 00 00       	mov    $0x1,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101137:	8b 5d e4             	mov    -0x1c(%ebp),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010113a:	83 e1 07             	and    $0x7,%ecx
8010113d:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010113f:	89 c1                	mov    %eax,%ecx
80101141:	c1 f9 03             	sar    $0x3,%ecx
80101144:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
80101149:	85 d7                	test   %edx,%edi
8010114b:	74 43                	je     80101190 <balloc+0xb0>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010114d:	83 c0 01             	add    $0x1,%eax
80101150:	83 c6 01             	add    $0x1,%esi
80101153:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101158:	74 05                	je     8010115f <balloc+0x7f>
8010115a:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010115d:	72 d1                	jb     80101130 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010115f:	83 ec 0c             	sub    $0xc,%esp
80101162:	ff 75 e4             	pushl  -0x1c(%ebp)
80101165:	e8 76 f0 ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010116a:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101171:	83 c4 10             	add    $0x10,%esp
80101174:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101177:	39 05 e0 09 11 80    	cmp    %eax,0x801109e0
8010117d:	77 82                	ja     80101101 <balloc+0x21>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010117f:	83 ec 0c             	sub    $0xc,%esp
80101182:	68 7b 70 10 80       	push   $0x8010707b
80101187:	e8 e4 f1 ff ff       	call   80100370 <panic>
8010118c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101190:	09 fa                	or     %edi,%edx
80101192:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101195:	83 ec 0c             	sub    $0xc,%esp
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101198:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010119c:	57                   	push   %edi
8010119d:	e8 9e 1c 00 00       	call   80102e40 <log_write>
        brelse(bp);
801011a2:	89 3c 24             	mov    %edi,(%esp)
801011a5:	e8 36 f0 ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801011aa:	58                   	pop    %eax
801011ab:	5a                   	pop    %edx
801011ac:	56                   	push   %esi
801011ad:	ff 75 d8             	pushl  -0x28(%ebp)
801011b0:	e8 1b ef ff ff       	call   801000d0 <bread>
801011b5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011b7:	8d 40 5c             	lea    0x5c(%eax),%eax
801011ba:	83 c4 0c             	add    $0xc,%esp
801011bd:	68 00 02 00 00       	push   $0x200
801011c2:	6a 00                	push   $0x0
801011c4:	50                   	push   %eax
801011c5:	e8 46 33 00 00       	call   80104510 <memset>
  log_write(bp);
801011ca:	89 1c 24             	mov    %ebx,(%esp)
801011cd:	e8 6e 1c 00 00       	call   80102e40 <log_write>
  brelse(bp);
801011d2:	89 1c 24             	mov    %ebx,(%esp)
801011d5:	e8 06 f0 ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
801011da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011dd:	89 f0                	mov    %esi,%eax
801011df:	5b                   	pop    %ebx
801011e0:	5e                   	pop    %esi
801011e1:	5f                   	pop    %edi
801011e2:	5d                   	pop    %ebp
801011e3:	c3                   	ret    
801011e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801011ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801011f0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801011f0:	55                   	push   %ebp
801011f1:	89 e5                	mov    %esp,%ebp
801011f3:	57                   	push   %edi
801011f4:	56                   	push   %esi
801011f5:	53                   	push   %ebx
801011f6:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801011f8:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011fa:	bb 34 0a 11 80       	mov    $0x80110a34,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801011ff:	83 ec 28             	sub    $0x28,%esp
80101202:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101205:	68 00 0a 11 80       	push   $0x80110a00
8010120a:	e8 d1 30 00 00       	call   801042e0 <acquire>
8010120f:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101212:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101215:	eb 1b                	jmp    80101232 <iget+0x42>
80101217:	89 f6                	mov    %esi,%esi
80101219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101220:	85 f6                	test   %esi,%esi
80101222:	74 44                	je     80101268 <iget+0x78>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101224:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010122a:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
80101230:	74 4e                	je     80101280 <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101232:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101235:	85 c9                	test   %ecx,%ecx
80101237:	7e e7                	jle    80101220 <iget+0x30>
80101239:	39 3b                	cmp    %edi,(%ebx)
8010123b:	75 e3                	jne    80101220 <iget+0x30>
8010123d:	39 53 04             	cmp    %edx,0x4(%ebx)
80101240:	75 de                	jne    80101220 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
80101242:	83 ec 0c             	sub    $0xc,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101245:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
80101248:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010124a:	68 00 0a 11 80       	push   $0x80110a00

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
8010124f:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101252:	e8 69 32 00 00       	call   801044c0 <release>
      return ip;
80101257:	83 c4 10             	add    $0x10,%esp
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);

  return ip;
}
8010125a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010125d:	89 f0                	mov    %esi,%eax
8010125f:	5b                   	pop    %ebx
80101260:	5e                   	pop    %esi
80101261:	5f                   	pop    %edi
80101262:	5d                   	pop    %ebp
80101263:	c3                   	ret    
80101264:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101268:	85 c9                	test   %ecx,%ecx
8010126a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010126d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101273:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
80101279:	75 b7                	jne    80101232 <iget+0x42>
8010127b:	90                   	nop
8010127c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101280:	85 f6                	test   %esi,%esi
80101282:	74 2d                	je     801012b1 <iget+0xc1>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);
80101284:	83 ec 0c             	sub    $0xc,%esp
  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101287:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101289:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010128c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->flags = 0;
80101293:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010129a:	68 00 0a 11 80       	push   $0x80110a00
8010129f:	e8 1c 32 00 00       	call   801044c0 <release>

  return ip;
801012a4:	83 c4 10             	add    $0x10,%esp
}
801012a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012aa:	89 f0                	mov    %esi,%eax
801012ac:	5b                   	pop    %ebx
801012ad:	5e                   	pop    %esi
801012ae:	5f                   	pop    %edi
801012af:	5d                   	pop    %ebp
801012b0:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
801012b1:	83 ec 0c             	sub    $0xc,%esp
801012b4:	68 91 70 10 80       	push   $0x80107091
801012b9:	e8 b2 f0 ff ff       	call   80100370 <panic>
801012be:	66 90                	xchg   %ax,%ax

801012c0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012c0:	55                   	push   %ebp
801012c1:	89 e5                	mov    %esp,%ebp
801012c3:	57                   	push   %edi
801012c4:	56                   	push   %esi
801012c5:	53                   	push   %ebx
801012c6:	89 c6                	mov    %eax,%esi
801012c8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012cb:	83 fa 0b             	cmp    $0xb,%edx
801012ce:	77 18                	ja     801012e8 <bmap+0x28>
801012d0:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    if((addr = ip->addrs[bn]) == 0)
801012d3:	8b 43 5c             	mov    0x5c(%ebx),%eax
801012d6:	85 c0                	test   %eax,%eax
801012d8:	74 76                	je     80101350 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801012da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012dd:	5b                   	pop    %ebx
801012de:	5e                   	pop    %esi
801012df:	5f                   	pop    %edi
801012e0:	5d                   	pop    %ebp
801012e1:	c3                   	ret    
801012e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801012e8:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801012eb:	83 fb 7f             	cmp    $0x7f,%ebx
801012ee:	0f 87 83 00 00 00    	ja     80101377 <bmap+0xb7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801012f4:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801012fa:	85 c0                	test   %eax,%eax
801012fc:	74 6a                	je     80101368 <bmap+0xa8>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801012fe:	83 ec 08             	sub    $0x8,%esp
80101301:	50                   	push   %eax
80101302:	ff 36                	pushl  (%esi)
80101304:	e8 c7 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101309:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010130d:	83 c4 10             	add    $0x10,%esp

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101310:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101312:	8b 1a                	mov    (%edx),%ebx
80101314:	85 db                	test   %ebx,%ebx
80101316:	75 1d                	jne    80101335 <bmap+0x75>
      a[bn] = addr = balloc(ip->dev);
80101318:	8b 06                	mov    (%esi),%eax
8010131a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010131d:	e8 be fd ff ff       	call   801010e0 <balloc>
80101322:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101325:	83 ec 0c             	sub    $0xc,%esp
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
80101328:	89 c3                	mov    %eax,%ebx
8010132a:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010132c:	57                   	push   %edi
8010132d:	e8 0e 1b 00 00       	call   80102e40 <log_write>
80101332:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101335:	83 ec 0c             	sub    $0xc,%esp
80101338:	57                   	push   %edi
80101339:	e8 a2 ee ff ff       	call   801001e0 <brelse>
8010133e:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101341:	8d 65 f4             	lea    -0xc(%ebp),%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101344:	89 d8                	mov    %ebx,%eax
    return addr;
  }

  panic("bmap: out of range");
}
80101346:	5b                   	pop    %ebx
80101347:	5e                   	pop    %esi
80101348:	5f                   	pop    %edi
80101349:	5d                   	pop    %ebp
8010134a:	c3                   	ret    
8010134b:	90                   	nop
8010134c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101350:	8b 06                	mov    (%esi),%eax
80101352:	e8 89 fd ff ff       	call   801010e0 <balloc>
80101357:	89 43 5c             	mov    %eax,0x5c(%ebx)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010135a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010135d:	5b                   	pop    %ebx
8010135e:	5e                   	pop    %esi
8010135f:	5f                   	pop    %edi
80101360:	5d                   	pop    %ebp
80101361:	c3                   	ret    
80101362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101368:	8b 06                	mov    (%esi),%eax
8010136a:	e8 71 fd ff ff       	call   801010e0 <balloc>
8010136f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101375:	eb 87                	jmp    801012fe <bmap+0x3e>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101377:	83 ec 0c             	sub    $0xc,%esp
8010137a:	68 a1 70 10 80       	push   $0x801070a1
8010137f:	e8 ec ef ff ff       	call   80100370 <panic>
80101384:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010138a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101390 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101390:	55                   	push   %ebp
80101391:	89 e5                	mov    %esp,%ebp
80101393:	56                   	push   %esi
80101394:	53                   	push   %ebx
80101395:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
80101398:	83 ec 08             	sub    $0x8,%esp
8010139b:	6a 01                	push   $0x1
8010139d:	ff 75 08             	pushl  0x8(%ebp)
801013a0:	e8 2b ed ff ff       	call   801000d0 <bread>
801013a5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013a7:	8d 40 5c             	lea    0x5c(%eax),%eax
801013aa:	83 c4 0c             	add    $0xc,%esp
801013ad:	6a 1c                	push   $0x1c
801013af:	50                   	push   %eax
801013b0:	56                   	push   %esi
801013b1:	e8 0a 32 00 00       	call   801045c0 <memmove>
  brelse(bp);
801013b6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801013b9:	83 c4 10             	add    $0x10,%esp
}
801013bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013bf:	5b                   	pop    %ebx
801013c0:	5e                   	pop    %esi
801013c1:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
801013c2:	e9 19 ee ff ff       	jmp    801001e0 <brelse>
801013c7:	89 f6                	mov    %esi,%esi
801013c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013d0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801013d0:	55                   	push   %ebp
801013d1:	89 e5                	mov    %esp,%ebp
801013d3:	56                   	push   %esi
801013d4:	53                   	push   %ebx
801013d5:	89 d3                	mov    %edx,%ebx
801013d7:	89 c6                	mov    %eax,%esi
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801013d9:	83 ec 08             	sub    $0x8,%esp
801013dc:	68 e0 09 11 80       	push   $0x801109e0
801013e1:	50                   	push   %eax
801013e2:	e8 a9 ff ff ff       	call   80101390 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801013e7:	58                   	pop    %eax
801013e8:	5a                   	pop    %edx
801013e9:	89 da                	mov    %ebx,%edx
801013eb:	c1 ea 0c             	shr    $0xc,%edx
801013ee:	03 15 f8 09 11 80    	add    0x801109f8,%edx
801013f4:	52                   	push   %edx
801013f5:	56                   	push   %esi
801013f6:	e8 d5 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801013fb:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801013fd:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101403:	ba 01 00 00 00       	mov    $0x1,%edx
80101408:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010140b:	c1 fb 03             	sar    $0x3,%ebx
8010140e:	83 c4 10             	add    $0x10,%esp
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101411:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101413:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101418:	85 d1                	test   %edx,%ecx
8010141a:	74 27                	je     80101443 <bfree+0x73>
8010141c:	89 c6                	mov    %eax,%esi
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010141e:	f7 d2                	not    %edx
80101420:	89 c8                	mov    %ecx,%eax
  log_write(bp);
80101422:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101425:	21 d0                	and    %edx,%eax
80101427:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010142b:	56                   	push   %esi
8010142c:	e8 0f 1a 00 00       	call   80102e40 <log_write>
  brelse(bp);
80101431:	89 34 24             	mov    %esi,(%esp)
80101434:	e8 a7 ed ff ff       	call   801001e0 <brelse>
}
80101439:	83 c4 10             	add    $0x10,%esp
8010143c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010143f:	5b                   	pop    %ebx
80101440:	5e                   	pop    %esi
80101441:	5d                   	pop    %ebp
80101442:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101443:	83 ec 0c             	sub    $0xc,%esp
80101446:	68 b4 70 10 80       	push   $0x801070b4
8010144b:	e8 20 ef ff ff       	call   80100370 <panic>

80101450 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	53                   	push   %ebx
80101454:	bb 40 0a 11 80       	mov    $0x80110a40,%ebx
80101459:	83 ec 0c             	sub    $0xc,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010145c:	68 c7 70 10 80       	push   $0x801070c7
80101461:	68 00 0a 11 80       	push   $0x80110a00
80101466:	e8 55 2e 00 00       	call   801042c0 <initlock>
8010146b:	83 c4 10             	add    $0x10,%esp
8010146e:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101470:	83 ec 08             	sub    $0x8,%esp
80101473:	68 ce 70 10 80       	push   $0x801070ce
80101478:	53                   	push   %ebx
80101479:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010147f:	e8 2c 2d 00 00       	call   801041b0 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
80101484:	83 c4 10             	add    $0x10,%esp
80101487:	81 fb 60 26 11 80    	cmp    $0x80112660,%ebx
8010148d:	75 e1                	jne    80101470 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }
  
  readsb(dev, &sb);
8010148f:	83 ec 08             	sub    $0x8,%esp
80101492:	68 e0 09 11 80       	push   $0x801109e0
80101497:	ff 75 08             	pushl  0x8(%ebp)
8010149a:	e8 f1 fe ff ff       	call   80101390 <readsb>
}
8010149f:	83 c4 10             	add    $0x10,%esp
801014a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014a5:	c9                   	leave  
801014a6:	c3                   	ret    
801014a7:	89 f6                	mov    %esi,%esi
801014a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801014b0 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801014b0:	55                   	push   %ebp
801014b1:	89 e5                	mov    %esp,%ebp
801014b3:	57                   	push   %edi
801014b4:	56                   	push   %esi
801014b5:	53                   	push   %ebx
801014b6:	83 ec 1c             	sub    $0x1c,%esp
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801014b9:	83 3d e8 09 11 80 01 	cmpl   $0x1,0x801109e8
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801014c0:	8b 45 0c             	mov    0xc(%ebp),%eax
801014c3:	8b 75 08             	mov    0x8(%ebp),%esi
801014c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801014c9:	0f 86 91 00 00 00    	jbe    80101560 <ialloc+0xb0>
801014cf:	bb 01 00 00 00       	mov    $0x1,%ebx
801014d4:	eb 21                	jmp    801014f7 <ialloc+0x47>
801014d6:	8d 76 00             	lea    0x0(%esi),%esi
801014d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
801014e0:	83 ec 0c             	sub    $0xc,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801014e3:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
801014e6:	57                   	push   %edi
801014e7:	e8 f4 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801014ec:	83 c4 10             	add    $0x10,%esp
801014ef:	39 1d e8 09 11 80    	cmp    %ebx,0x801109e8
801014f5:	76 69                	jbe    80101560 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801014f7:	89 d8                	mov    %ebx,%eax
801014f9:	83 ec 08             	sub    $0x8,%esp
801014fc:	c1 e8 03             	shr    $0x3,%eax
801014ff:	03 05 f4 09 11 80    	add    0x801109f4,%eax
80101505:	50                   	push   %eax
80101506:	56                   	push   %esi
80101507:	e8 c4 eb ff ff       	call   801000d0 <bread>
8010150c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010150e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101510:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
80101513:	83 e0 07             	and    $0x7,%eax
80101516:	c1 e0 06             	shl    $0x6,%eax
80101519:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010151d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101521:	75 bd                	jne    801014e0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101523:	83 ec 04             	sub    $0x4,%esp
80101526:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101529:	6a 40                	push   $0x40
8010152b:	6a 00                	push   $0x0
8010152d:	51                   	push   %ecx
8010152e:	e8 dd 2f 00 00       	call   80104510 <memset>
      dip->type = type;
80101533:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101537:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010153a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010153d:	89 3c 24             	mov    %edi,(%esp)
80101540:	e8 fb 18 00 00       	call   80102e40 <log_write>
      brelse(bp);
80101545:	89 3c 24             	mov    %edi,(%esp)
80101548:	e8 93 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010154d:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101550:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
80101553:	89 da                	mov    %ebx,%edx
80101555:	89 f0                	mov    %esi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101557:	5b                   	pop    %ebx
80101558:	5e                   	pop    %esi
80101559:	5f                   	pop    %edi
8010155a:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
8010155b:	e9 90 fc ff ff       	jmp    801011f0 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101560:	83 ec 0c             	sub    $0xc,%esp
80101563:	68 d4 70 10 80       	push   $0x801070d4
80101568:	e8 03 ee ff ff       	call   80100370 <panic>
8010156d:	8d 76 00             	lea    0x0(%esi),%esi

80101570 <iupdate>:
}

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
80101570:	55                   	push   %ebp
80101571:	89 e5                	mov    %esp,%ebp
80101573:	56                   	push   %esi
80101574:	53                   	push   %ebx
80101575:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101578:	83 ec 08             	sub    $0x8,%esp
8010157b:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010157e:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101581:	c1 e8 03             	shr    $0x3,%eax
80101584:	03 05 f4 09 11 80    	add    0x801109f4,%eax
8010158a:	50                   	push   %eax
8010158b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010158e:	e8 3d eb ff ff       	call   801000d0 <bread>
80101593:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101595:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101598:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010159c:	83 c4 0c             	add    $0xc,%esp
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010159f:	83 e0 07             	and    $0x7,%eax
801015a2:	c1 e0 06             	shl    $0x6,%eax
801015a5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801015a9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801015ac:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015b0:	83 c0 0c             	add    $0xc,%eax
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
801015b3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801015b7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801015bb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801015bf:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801015c3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801015c7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801015ca:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015cd:	6a 34                	push   $0x34
801015cf:	53                   	push   %ebx
801015d0:	50                   	push   %eax
801015d1:	e8 ea 2f 00 00       	call   801045c0 <memmove>
  log_write(bp);
801015d6:	89 34 24             	mov    %esi,(%esp)
801015d9:	e8 62 18 00 00       	call   80102e40 <log_write>
  brelse(bp);
801015de:	89 75 08             	mov    %esi,0x8(%ebp)
801015e1:	83 c4 10             	add    $0x10,%esp
}
801015e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015e7:	5b                   	pop    %ebx
801015e8:	5e                   	pop    %esi
801015e9:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
801015ea:	e9 f1 eb ff ff       	jmp    801001e0 <brelse>
801015ef:	90                   	nop

801015f0 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801015f0:	55                   	push   %ebp
801015f1:	89 e5                	mov    %esp,%ebp
801015f3:	53                   	push   %ebx
801015f4:	83 ec 10             	sub    $0x10,%esp
801015f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801015fa:	68 00 0a 11 80       	push   $0x80110a00
801015ff:	e8 dc 2c 00 00       	call   801042e0 <acquire>
  ip->ref++;
80101604:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101608:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
8010160f:	e8 ac 2e 00 00       	call   801044c0 <release>
  return ip;
}
80101614:	89 d8                	mov    %ebx,%eax
80101616:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101619:	c9                   	leave  
8010161a:	c3                   	ret    
8010161b:	90                   	nop
8010161c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101620 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101620:	55                   	push   %ebp
80101621:	89 e5                	mov    %esp,%ebp
80101623:	56                   	push   %esi
80101624:	53                   	push   %ebx
80101625:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101628:	85 db                	test   %ebx,%ebx
8010162a:	0f 84 b4 00 00 00    	je     801016e4 <ilock+0xc4>
80101630:	8b 43 08             	mov    0x8(%ebx),%eax
80101633:	85 c0                	test   %eax,%eax
80101635:	0f 8e a9 00 00 00    	jle    801016e4 <ilock+0xc4>
    panic("ilock");

  acquiresleep(&ip->lock);
8010163b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010163e:	83 ec 0c             	sub    $0xc,%esp
80101641:	50                   	push   %eax
80101642:	e8 a9 2b 00 00       	call   801041f0 <acquiresleep>

  if(!(ip->flags & I_VALID)){
80101647:	83 c4 10             	add    $0x10,%esp
8010164a:	f6 43 4c 02          	testb  $0x2,0x4c(%ebx)
8010164e:	74 10                	je     80101660 <ilock+0x40>
    brelse(bp);
    ip->flags |= I_VALID;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
80101650:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101653:	5b                   	pop    %ebx
80101654:	5e                   	pop    %esi
80101655:	5d                   	pop    %ebp
80101656:	c3                   	ret    
80101657:	89 f6                	mov    %esi,%esi
80101659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    panic("ilock");

  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101660:	8b 43 04             	mov    0x4(%ebx),%eax
80101663:	83 ec 08             	sub    $0x8,%esp
80101666:	c1 e8 03             	shr    $0x3,%eax
80101669:	03 05 f4 09 11 80    	add    0x801109f4,%eax
8010166f:	50                   	push   %eax
80101670:	ff 33                	pushl  (%ebx)
80101672:	e8 59 ea ff ff       	call   801000d0 <bread>
80101677:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101679:	8b 43 04             	mov    0x4(%ebx),%eax
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010167c:	83 c4 0c             	add    $0xc,%esp

  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010167f:	83 e0 07             	and    $0x7,%eax
80101682:	c1 e0 06             	shl    $0x6,%eax
80101685:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101689:	0f b7 10             	movzwl (%eax),%edx
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010168c:	83 c0 0c             	add    $0xc,%eax
  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
8010168f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101693:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101697:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010169b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010169f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801016a3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801016a7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801016ab:	8b 50 fc             	mov    -0x4(%eax),%edx
801016ae:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016b1:	6a 34                	push   $0x34
801016b3:	50                   	push   %eax
801016b4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801016b7:	50                   	push   %eax
801016b8:	e8 03 2f 00 00       	call   801045c0 <memmove>
    brelse(bp);
801016bd:	89 34 24             	mov    %esi,(%esp)
801016c0:	e8 1b eb ff ff       	call   801001e0 <brelse>
    ip->flags |= I_VALID;
801016c5:	83 4b 4c 02          	orl    $0x2,0x4c(%ebx)
    if(ip->type == 0)
801016c9:	83 c4 10             	add    $0x10,%esp
801016cc:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
801016d1:	0f 85 79 ff ff ff    	jne    80101650 <ilock+0x30>
      panic("ilock: no type");
801016d7:	83 ec 0c             	sub    $0xc,%esp
801016da:	68 ec 70 10 80       	push   $0x801070ec
801016df:	e8 8c ec ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
801016e4:	83 ec 0c             	sub    $0xc,%esp
801016e7:	68 e6 70 10 80       	push   $0x801070e6
801016ec:	e8 7f ec ff ff       	call   80100370 <panic>
801016f1:	eb 0d                	jmp    80101700 <iunlock>
801016f3:	90                   	nop
801016f4:	90                   	nop
801016f5:	90                   	nop
801016f6:	90                   	nop
801016f7:	90                   	nop
801016f8:	90                   	nop
801016f9:	90                   	nop
801016fa:	90                   	nop
801016fb:	90                   	nop
801016fc:	90                   	nop
801016fd:	90                   	nop
801016fe:	90                   	nop
801016ff:	90                   	nop

80101700 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101700:	55                   	push   %ebp
80101701:	89 e5                	mov    %esp,%ebp
80101703:	56                   	push   %esi
80101704:	53                   	push   %ebx
80101705:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101708:	85 db                	test   %ebx,%ebx
8010170a:	74 28                	je     80101734 <iunlock+0x34>
8010170c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010170f:	83 ec 0c             	sub    $0xc,%esp
80101712:	56                   	push   %esi
80101713:	e8 78 2b 00 00       	call   80104290 <holdingsleep>
80101718:	83 c4 10             	add    $0x10,%esp
8010171b:	85 c0                	test   %eax,%eax
8010171d:	74 15                	je     80101734 <iunlock+0x34>
8010171f:	8b 43 08             	mov    0x8(%ebx),%eax
80101722:	85 c0                	test   %eax,%eax
80101724:	7e 0e                	jle    80101734 <iunlock+0x34>
    panic("iunlock");

  releasesleep(&ip->lock);
80101726:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101729:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010172c:	5b                   	pop    %ebx
8010172d:	5e                   	pop    %esi
8010172e:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
8010172f:	e9 1c 2b 00 00       	jmp    80104250 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
80101734:	83 ec 0c             	sub    $0xc,%esp
80101737:	68 fb 70 10 80       	push   $0x801070fb
8010173c:	e8 2f ec ff ff       	call   80100370 <panic>
80101741:	eb 0d                	jmp    80101750 <iput>
80101743:	90                   	nop
80101744:	90                   	nop
80101745:	90                   	nop
80101746:	90                   	nop
80101747:	90                   	nop
80101748:	90                   	nop
80101749:	90                   	nop
8010174a:	90                   	nop
8010174b:	90                   	nop
8010174c:	90                   	nop
8010174d:	90                   	nop
8010174e:	90                   	nop
8010174f:	90                   	nop

80101750 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	57                   	push   %edi
80101754:	56                   	push   %esi
80101755:	53                   	push   %ebx
80101756:	83 ec 28             	sub    $0x28,%esp
80101759:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&icache.lock);
8010175c:	68 00 0a 11 80       	push   $0x80110a00
80101761:	e8 7a 2b 00 00       	call   801042e0 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101766:	8b 46 08             	mov    0x8(%esi),%eax
80101769:	83 c4 10             	add    $0x10,%esp
8010176c:	83 f8 01             	cmp    $0x1,%eax
8010176f:	74 1f                	je     80101790 <iput+0x40>
    ip->type = 0;
    iupdate(ip);
    acquire(&icache.lock);
    ip->flags = 0;
  }
  ip->ref--;
80101771:	83 e8 01             	sub    $0x1,%eax
80101774:	89 46 08             	mov    %eax,0x8(%esi)
  release(&icache.lock);
80101777:	c7 45 08 00 0a 11 80 	movl   $0x80110a00,0x8(%ebp)
}
8010177e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101781:	5b                   	pop    %ebx
80101782:	5e                   	pop    %esi
80101783:	5f                   	pop    %edi
80101784:	5d                   	pop    %ebp
    iupdate(ip);
    acquire(&icache.lock);
    ip->flags = 0;
  }
  ip->ref--;
  release(&icache.lock);
80101785:	e9 36 2d 00 00       	jmp    801044c0 <release>
8010178a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
// case it has to free the inode.
void
iput(struct inode *ip)
{
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101790:	f6 46 4c 02          	testb  $0x2,0x4c(%esi)
80101794:	74 db                	je     80101771 <iput+0x21>
80101796:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
8010179b:	75 d4                	jne    80101771 <iput+0x21>
    // inode has no links and no other references: truncate and free.
    release(&icache.lock);
8010179d:	83 ec 0c             	sub    $0xc,%esp
801017a0:	8d 5e 5c             	lea    0x5c(%esi),%ebx
801017a3:	8d be 8c 00 00 00    	lea    0x8c(%esi),%edi
801017a9:	68 00 0a 11 80       	push   $0x80110a00
801017ae:	e8 0d 2d 00 00       	call   801044c0 <release>
801017b3:	83 c4 10             	add    $0x10,%esp
801017b6:	eb 0f                	jmp    801017c7 <iput+0x77>
801017b8:	90                   	nop
801017b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017c0:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801017c3:	39 fb                	cmp    %edi,%ebx
801017c5:	74 19                	je     801017e0 <iput+0x90>
    if(ip->addrs[i]){
801017c7:	8b 13                	mov    (%ebx),%edx
801017c9:	85 d2                	test   %edx,%edx
801017cb:	74 f3                	je     801017c0 <iput+0x70>
      bfree(ip->dev, ip->addrs[i]);
801017cd:	8b 06                	mov    (%esi),%eax
801017cf:	e8 fc fb ff ff       	call   801013d0 <bfree>
      ip->addrs[i] = 0;
801017d4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801017da:	eb e4                	jmp    801017c0 <iput+0x70>
801017dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801017e0:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
801017e6:	85 c0                	test   %eax,%eax
801017e8:	75 46                	jne    80101830 <iput+0xe0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801017ea:	83 ec 0c             	sub    $0xc,%esp
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
801017ed:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
801017f4:	56                   	push   %esi
801017f5:	e8 76 fd ff ff       	call   80101570 <iupdate>
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode has no links and no other references: truncate and free.
    release(&icache.lock);
    itrunc(ip);
    ip->type = 0;
801017fa:	31 c0                	xor    %eax,%eax
801017fc:	66 89 46 50          	mov    %ax,0x50(%esi)
    iupdate(ip);
80101800:	89 34 24             	mov    %esi,(%esp)
80101803:	e8 68 fd ff ff       	call   80101570 <iupdate>
    acquire(&icache.lock);
80101808:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
8010180f:	e8 cc 2a 00 00       	call   801042e0 <acquire>
    ip->flags = 0;
80101814:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
8010181b:	8b 46 08             	mov    0x8(%esi),%eax
8010181e:	83 c4 10             	add    $0x10,%esp
80101821:	e9 4b ff ff ff       	jmp    80101771 <iput+0x21>
80101826:	8d 76 00             	lea    0x0(%esi),%esi
80101829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101830:	83 ec 08             	sub    $0x8,%esp
80101833:	50                   	push   %eax
80101834:	ff 36                	pushl  (%esi)
80101836:	e8 95 e8 ff ff       	call   801000d0 <bread>
8010183b:	83 c4 10             	add    $0x10,%esp
8010183e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101841:	8d 58 5c             	lea    0x5c(%eax),%ebx
80101844:	8d b8 5c 02 00 00    	lea    0x25c(%eax),%edi
8010184a:	eb 0b                	jmp    80101857 <iput+0x107>
8010184c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101850:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
80101853:	39 df                	cmp    %ebx,%edi
80101855:	74 0f                	je     80101866 <iput+0x116>
      if(a[j])
80101857:	8b 13                	mov    (%ebx),%edx
80101859:	85 d2                	test   %edx,%edx
8010185b:	74 f3                	je     80101850 <iput+0x100>
        bfree(ip->dev, a[j]);
8010185d:	8b 06                	mov    (%esi),%eax
8010185f:	e8 6c fb ff ff       	call   801013d0 <bfree>
80101864:	eb ea                	jmp    80101850 <iput+0x100>
    }
    brelse(bp);
80101866:	83 ec 0c             	sub    $0xc,%esp
80101869:	ff 75 e4             	pushl  -0x1c(%ebp)
8010186c:	e8 6f e9 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101871:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101877:	8b 06                	mov    (%esi),%eax
80101879:	e8 52 fb ff ff       	call   801013d0 <bfree>
    ip->addrs[NDIRECT] = 0;
8010187e:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101885:	00 00 00 
80101888:	83 c4 10             	add    $0x10,%esp
8010188b:	e9 5a ff ff ff       	jmp    801017ea <iput+0x9a>

80101890 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101890:	55                   	push   %ebp
80101891:	89 e5                	mov    %esp,%ebp
80101893:	53                   	push   %ebx
80101894:	83 ec 10             	sub    $0x10,%esp
80101897:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010189a:	53                   	push   %ebx
8010189b:	e8 60 fe ff ff       	call   80101700 <iunlock>
  iput(ip);
801018a0:	89 5d 08             	mov    %ebx,0x8(%ebp)
801018a3:	83 c4 10             	add    $0x10,%esp
}
801018a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801018a9:	c9                   	leave  
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
801018aa:	e9 a1 fe ff ff       	jmp    80101750 <iput>
801018af:	90                   	nop

801018b0 <stati>:
}

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	8b 55 08             	mov    0x8(%ebp),%edx
801018b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801018b9:	8b 0a                	mov    (%edx),%ecx
801018bb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801018be:	8b 4a 04             	mov    0x4(%edx),%ecx
801018c1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801018c4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
801018c8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801018cb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
801018cf:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801018d3:	8b 52 58             	mov    0x58(%edx),%edx
801018d6:	89 50 10             	mov    %edx,0x10(%eax)
}
801018d9:	5d                   	pop    %ebp
801018da:	c3                   	ret    
801018db:	90                   	nop
801018dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018e0 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801018e0:	55                   	push   %ebp
801018e1:	89 e5                	mov    %esp,%ebp
801018e3:	57                   	push   %edi
801018e4:	56                   	push   %esi
801018e5:	53                   	push   %ebx
801018e6:	83 ec 1c             	sub    $0x1c,%esp
801018e9:	8b 45 08             	mov    0x8(%ebp),%eax
801018ec:	8b 7d 0c             	mov    0xc(%ebp),%edi
801018ef:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801018f2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801018f7:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018fa:	8b 7d 14             	mov    0x14(%ebp),%edi
801018fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101900:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101903:	0f 84 a7 00 00 00    	je     801019b0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101909:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010190c:	8b 40 58             	mov    0x58(%eax),%eax
8010190f:	39 f0                	cmp    %esi,%eax
80101911:	0f 82 c1 00 00 00    	jb     801019d8 <readi+0xf8>
80101917:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010191a:	89 fa                	mov    %edi,%edx
8010191c:	01 f2                	add    %esi,%edx
8010191e:	0f 82 b4 00 00 00    	jb     801019d8 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101924:	89 c1                	mov    %eax,%ecx
80101926:	29 f1                	sub    %esi,%ecx
80101928:	39 d0                	cmp    %edx,%eax
8010192a:	0f 43 cf             	cmovae %edi,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010192d:	31 ff                	xor    %edi,%edi
8010192f:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101931:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101934:	74 6d                	je     801019a3 <readi+0xc3>
80101936:	8d 76 00             	lea    0x0(%esi),%esi
80101939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101940:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101943:	89 f2                	mov    %esi,%edx
80101945:	c1 ea 09             	shr    $0x9,%edx
80101948:	89 d8                	mov    %ebx,%eax
8010194a:	e8 71 f9 ff ff       	call   801012c0 <bmap>
8010194f:	83 ec 08             	sub    $0x8,%esp
80101952:	50                   	push   %eax
80101953:	ff 33                	pushl  (%ebx)
    m = min(n - tot, BSIZE - off%BSIZE);
80101955:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010195a:	e8 71 e7 ff ff       	call   801000d0 <bread>
8010195f:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101961:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101964:	89 f1                	mov    %esi,%ecx
80101966:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
8010196c:	83 c4 0c             	add    $0xc,%esp
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
8010196f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101972:	29 cb                	sub    %ecx,%ebx
80101974:	29 f8                	sub    %edi,%eax
80101976:	39 c3                	cmp    %eax,%ebx
80101978:	0f 47 d8             	cmova  %eax,%ebx
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
8010197b:	8d 44 0a 5c          	lea    0x5c(%edx,%ecx,1),%eax
8010197f:	53                   	push   %ebx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101980:	01 df                	add    %ebx,%edi
80101982:	01 de                	add    %ebx,%esi
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
80101984:	50                   	push   %eax
80101985:	ff 75 e0             	pushl  -0x20(%ebp)
80101988:	e8 33 2c 00 00       	call   801045c0 <memmove>
    brelse(bp);
8010198d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101990:	89 14 24             	mov    %edx,(%esp)
80101993:	e8 48 e8 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101998:	01 5d e0             	add    %ebx,-0x20(%ebp)
8010199b:	83 c4 10             	add    $0x10,%esp
8010199e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801019a1:	77 9d                	ja     80101940 <readi+0x60>
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
801019a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
801019a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019a9:	5b                   	pop    %ebx
801019aa:	5e                   	pop    %esi
801019ab:	5f                   	pop    %edi
801019ac:	5d                   	pop    %ebp
801019ad:	c3                   	ret    
801019ae:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801019b0:	0f bf 40 52          	movswl 0x52(%eax),%eax
801019b4:	66 83 f8 09          	cmp    $0x9,%ax
801019b8:	77 1e                	ja     801019d8 <readi+0xf8>
801019ba:	8b 04 c5 80 09 11 80 	mov    -0x7feef680(,%eax,8),%eax
801019c1:	85 c0                	test   %eax,%eax
801019c3:	74 13                	je     801019d8 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
801019c5:	89 7d 10             	mov    %edi,0x10(%ebp)
    */
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
801019c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019cb:	5b                   	pop    %ebx
801019cc:	5e                   	pop    %esi
801019cd:	5f                   	pop    %edi
801019ce:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
801019cf:	ff e0                	jmp    *%eax
801019d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
801019d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019dd:	eb c7                	jmp    801019a6 <readi+0xc6>
801019df:	90                   	nop

801019e0 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
801019e0:	55                   	push   %ebp
801019e1:	89 e5                	mov    %esp,%ebp
801019e3:	57                   	push   %edi
801019e4:	56                   	push   %esi
801019e5:	53                   	push   %ebx
801019e6:	83 ec 1c             	sub    $0x1c,%esp
801019e9:	8b 45 08             	mov    0x8(%ebp),%eax
801019ec:	8b 75 0c             	mov    0xc(%ebp),%esi
801019ef:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801019f2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
801019f7:	89 75 dc             	mov    %esi,-0x24(%ebp)
801019fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
801019fd:	8b 75 10             	mov    0x10(%ebp),%esi
80101a00:	89 7d e0             	mov    %edi,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a03:	0f 84 b7 00 00 00    	je     80101ac0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a09:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a0c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a0f:	0f 82 eb 00 00 00    	jb     80101b00 <writei+0x120>
80101a15:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a18:	89 f8                	mov    %edi,%eax
80101a1a:	01 f0                	add    %esi,%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101a1c:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101a21:	0f 87 d9 00 00 00    	ja     80101b00 <writei+0x120>
80101a27:	39 c6                	cmp    %eax,%esi
80101a29:	0f 87 d1 00 00 00    	ja     80101b00 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a2f:	85 ff                	test   %edi,%edi
80101a31:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101a38:	74 78                	je     80101ab2 <writei+0xd2>
80101a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a40:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101a43:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a45:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a4a:	c1 ea 09             	shr    $0x9,%edx
80101a4d:	89 f8                	mov    %edi,%eax
80101a4f:	e8 6c f8 ff ff       	call   801012c0 <bmap>
80101a54:	83 ec 08             	sub    $0x8,%esp
80101a57:	50                   	push   %eax
80101a58:	ff 37                	pushl  (%edi)
80101a5a:	e8 71 e6 ff ff       	call   801000d0 <bread>
80101a5f:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101a61:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101a64:	2b 45 e4             	sub    -0x1c(%ebp),%eax
80101a67:	89 f1                	mov    %esi,%ecx
80101a69:	83 c4 0c             	add    $0xc,%esp
80101a6c:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101a72:	29 cb                	sub    %ecx,%ebx
80101a74:	39 c3                	cmp    %eax,%ebx
80101a76:	0f 47 d8             	cmova  %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101a79:	8d 44 0f 5c          	lea    0x5c(%edi,%ecx,1),%eax
80101a7d:	53                   	push   %ebx
80101a7e:	ff 75 dc             	pushl  -0x24(%ebp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a81:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101a83:	50                   	push   %eax
80101a84:	e8 37 2b 00 00       	call   801045c0 <memmove>
    log_write(bp);
80101a89:	89 3c 24             	mov    %edi,(%esp)
80101a8c:	e8 af 13 00 00       	call   80102e40 <log_write>
    brelse(bp);
80101a91:	89 3c 24             	mov    %edi,(%esp)
80101a94:	e8 47 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a99:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101a9c:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101a9f:	83 c4 10             	add    $0x10,%esp
80101aa2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101aa5:	39 55 e0             	cmp    %edx,-0x20(%ebp)
80101aa8:	77 96                	ja     80101a40 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101aaa:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101aad:	3b 70 58             	cmp    0x58(%eax),%esi
80101ab0:	77 36                	ja     80101ae8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101ab2:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101ab5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ab8:	5b                   	pop    %ebx
80101ab9:	5e                   	pop    %esi
80101aba:	5f                   	pop    %edi
80101abb:	5d                   	pop    %ebp
80101abc:	c3                   	ret    
80101abd:	8d 76 00             	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101ac0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101ac4:	66 83 f8 09          	cmp    $0x9,%ax
80101ac8:	77 36                	ja     80101b00 <writei+0x120>
80101aca:	8b 04 c5 84 09 11 80 	mov    -0x7feef67c(,%eax,8),%eax
80101ad1:	85 c0                	test   %eax,%eax
80101ad3:	74 2b                	je     80101b00 <writei+0x120>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101ad5:	89 7d 10             	mov    %edi,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101ad8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101adb:	5b                   	pop    %ebx
80101adc:	5e                   	pop    %esi
80101add:	5f                   	pop    %edi
80101ade:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101adf:	ff e0                	jmp    *%eax
80101ae1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101ae8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101aeb:	83 ec 0c             	sub    $0xc,%esp
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101aee:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101af1:	50                   	push   %eax
80101af2:	e8 79 fa ff ff       	call   80101570 <iupdate>
80101af7:	83 c4 10             	add    $0x10,%esp
80101afa:	eb b6                	jmp    80101ab2 <writei+0xd2>
80101afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101b00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b05:	eb ae                	jmp    80101ab5 <writei+0xd5>
80101b07:	89 f6                	mov    %esi,%esi
80101b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b10 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b10:	55                   	push   %ebp
80101b11:	89 e5                	mov    %esp,%ebp
80101b13:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101b16:	6a 0e                	push   $0xe
80101b18:	ff 75 0c             	pushl  0xc(%ebp)
80101b1b:	ff 75 08             	pushl  0x8(%ebp)
80101b1e:	e8 1d 2b 00 00       	call   80104640 <strncmp>
}
80101b23:	c9                   	leave  
80101b24:	c3                   	ret    
80101b25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b30 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101b30:	55                   	push   %ebp
80101b31:	89 e5                	mov    %esp,%ebp
80101b33:	57                   	push   %edi
80101b34:	56                   	push   %esi
80101b35:	53                   	push   %ebx
80101b36:	83 ec 1c             	sub    $0x1c,%esp
80101b39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101b3c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101b41:	0f 85 80 00 00 00    	jne    80101bc7 <dirlookup+0x97>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101b47:	8b 53 58             	mov    0x58(%ebx),%edx
80101b4a:	31 ff                	xor    %edi,%edi
80101b4c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101b4f:	85 d2                	test   %edx,%edx
80101b51:	75 0d                	jne    80101b60 <dirlookup+0x30>
80101b53:	eb 5b                	jmp    80101bb0 <dirlookup+0x80>
80101b55:	8d 76 00             	lea    0x0(%esi),%esi
80101b58:	83 c7 10             	add    $0x10,%edi
80101b5b:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101b5e:	76 50                	jbe    80101bb0 <dirlookup+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101b60:	6a 10                	push   $0x10
80101b62:	57                   	push   %edi
80101b63:	56                   	push   %esi
80101b64:	53                   	push   %ebx
80101b65:	e8 76 fd ff ff       	call   801018e0 <readi>
80101b6a:	83 c4 10             	add    $0x10,%esp
80101b6d:	83 f8 10             	cmp    $0x10,%eax
80101b70:	75 48                	jne    80101bba <dirlookup+0x8a>
      panic("dirlink read");
    if(de.inum == 0)
80101b72:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101b77:	74 df                	je     80101b58 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101b79:	8d 45 da             	lea    -0x26(%ebp),%eax
80101b7c:	83 ec 04             	sub    $0x4,%esp
80101b7f:	6a 0e                	push   $0xe
80101b81:	50                   	push   %eax
80101b82:	ff 75 0c             	pushl  0xc(%ebp)
80101b85:	e8 b6 2a 00 00       	call   80104640 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101b8a:	83 c4 10             	add    $0x10,%esp
80101b8d:	85 c0                	test   %eax,%eax
80101b8f:	75 c7                	jne    80101b58 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101b91:	8b 45 10             	mov    0x10(%ebp),%eax
80101b94:	85 c0                	test   %eax,%eax
80101b96:	74 05                	je     80101b9d <dirlookup+0x6d>
        *poff = off;
80101b98:	8b 45 10             	mov    0x10(%ebp),%eax
80101b9b:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
80101b9d:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101ba1:	8b 03                	mov    (%ebx),%eax
80101ba3:	e8 48 f6 ff ff       	call   801011f0 <iget>
    }
  }

  return 0;
}
80101ba8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bab:	5b                   	pop    %ebx
80101bac:	5e                   	pop    %esi
80101bad:	5f                   	pop    %edi
80101bae:	5d                   	pop    %ebp
80101baf:	c3                   	ret    
80101bb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101bb3:	31 c0                	xor    %eax,%eax
}
80101bb5:	5b                   	pop    %ebx
80101bb6:	5e                   	pop    %esi
80101bb7:	5f                   	pop    %edi
80101bb8:	5d                   	pop    %ebp
80101bb9:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101bba:	83 ec 0c             	sub    $0xc,%esp
80101bbd:	68 15 71 10 80       	push   $0x80107115
80101bc2:	e8 a9 e7 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101bc7:	83 ec 0c             	sub    $0xc,%esp
80101bca:	68 03 71 10 80       	push   $0x80107103
80101bcf:	e8 9c e7 ff ff       	call   80100370 <panic>
80101bd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101bda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101be0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101be0:	55                   	push   %ebp
80101be1:	89 e5                	mov    %esp,%ebp
80101be3:	57                   	push   %edi
80101be4:	56                   	push   %esi
80101be5:	53                   	push   %ebx
80101be6:	89 cf                	mov    %ecx,%edi
80101be8:	89 c3                	mov    %eax,%ebx
80101bea:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101bed:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101bf0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101bf3:	0f 84 53 01 00 00    	je     80101d4c <namex+0x16c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80101bf9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101bff:	83 ec 0c             	sub    $0xc,%esp
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80101c02:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c05:	68 00 0a 11 80       	push   $0x80110a00
80101c0a:	e8 d1 26 00 00       	call   801042e0 <acquire>
  ip->ref++;
80101c0f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c13:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101c1a:	e8 a1 28 00 00       	call   801044c0 <release>
80101c1f:	83 c4 10             	add    $0x10,%esp
80101c22:	eb 07                	jmp    80101c2b <namex+0x4b>
80101c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101c28:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101c2b:	0f b6 03             	movzbl (%ebx),%eax
80101c2e:	3c 2f                	cmp    $0x2f,%al
80101c30:	74 f6                	je     80101c28 <namex+0x48>
    path++;
  if(*path == 0)
80101c32:	84 c0                	test   %al,%al
80101c34:	0f 84 e3 00 00 00    	je     80101d1d <namex+0x13d>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101c3a:	0f b6 03             	movzbl (%ebx),%eax
80101c3d:	89 da                	mov    %ebx,%edx
80101c3f:	84 c0                	test   %al,%al
80101c41:	0f 84 ac 00 00 00    	je     80101cf3 <namex+0x113>
80101c47:	3c 2f                	cmp    $0x2f,%al
80101c49:	75 09                	jne    80101c54 <namex+0x74>
80101c4b:	e9 a3 00 00 00       	jmp    80101cf3 <namex+0x113>
80101c50:	84 c0                	test   %al,%al
80101c52:	74 0a                	je     80101c5e <namex+0x7e>
    path++;
80101c54:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101c57:	0f b6 02             	movzbl (%edx),%eax
80101c5a:	3c 2f                	cmp    $0x2f,%al
80101c5c:	75 f2                	jne    80101c50 <namex+0x70>
80101c5e:	89 d1                	mov    %edx,%ecx
80101c60:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101c62:	83 f9 0d             	cmp    $0xd,%ecx
80101c65:	0f 8e 8d 00 00 00    	jle    80101cf8 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101c6b:	83 ec 04             	sub    $0x4,%esp
80101c6e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101c71:	6a 0e                	push   $0xe
80101c73:	53                   	push   %ebx
80101c74:	57                   	push   %edi
80101c75:	e8 46 29 00 00       	call   801045c0 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101c7a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
80101c7d:	83 c4 10             	add    $0x10,%esp
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101c80:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101c82:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101c85:	75 11                	jne    80101c98 <namex+0xb8>
80101c87:	89 f6                	mov    %esi,%esi
80101c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101c90:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101c93:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101c96:	74 f8                	je     80101c90 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101c98:	83 ec 0c             	sub    $0xc,%esp
80101c9b:	56                   	push   %esi
80101c9c:	e8 7f f9 ff ff       	call   80101620 <ilock>
    if(ip->type != T_DIR){
80101ca1:	83 c4 10             	add    $0x10,%esp
80101ca4:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101ca9:	0f 85 7f 00 00 00    	jne    80101d2e <namex+0x14e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101caf:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101cb2:	85 d2                	test   %edx,%edx
80101cb4:	74 09                	je     80101cbf <namex+0xdf>
80101cb6:	80 3b 00             	cmpb   $0x0,(%ebx)
80101cb9:	0f 84 a3 00 00 00    	je     80101d62 <namex+0x182>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101cbf:	83 ec 04             	sub    $0x4,%esp
80101cc2:	6a 00                	push   $0x0
80101cc4:	57                   	push   %edi
80101cc5:	56                   	push   %esi
80101cc6:	e8 65 fe ff ff       	call   80101b30 <dirlookup>
80101ccb:	83 c4 10             	add    $0x10,%esp
80101cce:	85 c0                	test   %eax,%eax
80101cd0:	74 5c                	je     80101d2e <namex+0x14e>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101cd2:	83 ec 0c             	sub    $0xc,%esp
80101cd5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101cd8:	56                   	push   %esi
80101cd9:	e8 22 fa ff ff       	call   80101700 <iunlock>
  iput(ip);
80101cde:	89 34 24             	mov    %esi,(%esp)
80101ce1:	e8 6a fa ff ff       	call   80101750 <iput>
80101ce6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101ce9:	83 c4 10             	add    $0x10,%esp
80101cec:	89 c6                	mov    %eax,%esi
80101cee:	e9 38 ff ff ff       	jmp    80101c2b <namex+0x4b>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101cf3:	31 c9                	xor    %ecx,%ecx
80101cf5:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101cf8:	83 ec 04             	sub    $0x4,%esp
80101cfb:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101cfe:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d01:	51                   	push   %ecx
80101d02:	53                   	push   %ebx
80101d03:	57                   	push   %edi
80101d04:	e8 b7 28 00 00       	call   801045c0 <memmove>
    name[len] = 0;
80101d09:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d0f:	83 c4 10             	add    $0x10,%esp
80101d12:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d16:	89 d3                	mov    %edx,%ebx
80101d18:	e9 65 ff ff ff       	jmp    80101c82 <namex+0xa2>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101d1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101d20:	85 c0                	test   %eax,%eax
80101d22:	75 54                	jne    80101d78 <namex+0x198>
80101d24:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101d26:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d29:	5b                   	pop    %ebx
80101d2a:	5e                   	pop    %esi
80101d2b:	5f                   	pop    %edi
80101d2c:	5d                   	pop    %ebp
80101d2d:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d2e:	83 ec 0c             	sub    $0xc,%esp
80101d31:	56                   	push   %esi
80101d32:	e8 c9 f9 ff ff       	call   80101700 <iunlock>
  iput(ip);
80101d37:	89 34 24             	mov    %esi,(%esp)
80101d3a:	e8 11 fa ff ff       	call   80101750 <iput>
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101d3f:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101d42:	8d 65 f4             	lea    -0xc(%ebp),%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101d45:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101d47:	5b                   	pop    %ebx
80101d48:	5e                   	pop    %esi
80101d49:	5f                   	pop    %edi
80101d4a:	5d                   	pop    %ebp
80101d4b:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101d4c:	ba 01 00 00 00       	mov    $0x1,%edx
80101d51:	b8 01 00 00 00       	mov    $0x1,%eax
80101d56:	e8 95 f4 ff ff       	call   801011f0 <iget>
80101d5b:	89 c6                	mov    %eax,%esi
80101d5d:	e9 c9 fe ff ff       	jmp    80101c2b <namex+0x4b>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101d62:	83 ec 0c             	sub    $0xc,%esp
80101d65:	56                   	push   %esi
80101d66:	e8 95 f9 ff ff       	call   80101700 <iunlock>
      return ip;
80101d6b:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101d6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101d71:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101d73:	5b                   	pop    %ebx
80101d74:	5e                   	pop    %esi
80101d75:	5f                   	pop    %edi
80101d76:	5d                   	pop    %ebp
80101d77:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101d78:	83 ec 0c             	sub    $0xc,%esp
80101d7b:	56                   	push   %esi
80101d7c:	e8 cf f9 ff ff       	call   80101750 <iput>
    return 0;
80101d81:	83 c4 10             	add    $0x10,%esp
80101d84:	31 c0                	xor    %eax,%eax
80101d86:	eb 9e                	jmp    80101d26 <namex+0x146>
80101d88:	90                   	nop
80101d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d90 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101d90:	55                   	push   %ebp
80101d91:	89 e5                	mov    %esp,%ebp
80101d93:	57                   	push   %edi
80101d94:	56                   	push   %esi
80101d95:	53                   	push   %ebx
80101d96:	83 ec 20             	sub    $0x20,%esp
80101d99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101d9c:	6a 00                	push   $0x0
80101d9e:	ff 75 0c             	pushl  0xc(%ebp)
80101da1:	53                   	push   %ebx
80101da2:	e8 89 fd ff ff       	call   80101b30 <dirlookup>
80101da7:	83 c4 10             	add    $0x10,%esp
80101daa:	85 c0                	test   %eax,%eax
80101dac:	75 67                	jne    80101e15 <dirlink+0x85>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101dae:	8b 7b 58             	mov    0x58(%ebx),%edi
80101db1:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101db4:	85 ff                	test   %edi,%edi
80101db6:	74 29                	je     80101de1 <dirlink+0x51>
80101db8:	31 ff                	xor    %edi,%edi
80101dba:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101dbd:	eb 09                	jmp    80101dc8 <dirlink+0x38>
80101dbf:	90                   	nop
80101dc0:	83 c7 10             	add    $0x10,%edi
80101dc3:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101dc6:	76 19                	jbe    80101de1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101dc8:	6a 10                	push   $0x10
80101dca:	57                   	push   %edi
80101dcb:	56                   	push   %esi
80101dcc:	53                   	push   %ebx
80101dcd:	e8 0e fb ff ff       	call   801018e0 <readi>
80101dd2:	83 c4 10             	add    $0x10,%esp
80101dd5:	83 f8 10             	cmp    $0x10,%eax
80101dd8:	75 4e                	jne    80101e28 <dirlink+0x98>
      panic("dirlink read");
    if(de.inum == 0)
80101dda:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101ddf:	75 df                	jne    80101dc0 <dirlink+0x30>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101de1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101de4:	83 ec 04             	sub    $0x4,%esp
80101de7:	6a 0e                	push   $0xe
80101de9:	ff 75 0c             	pushl  0xc(%ebp)
80101dec:	50                   	push   %eax
80101ded:	e8 be 28 00 00       	call   801046b0 <strncpy>
  de.inum = inum;
80101df2:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101df5:	6a 10                	push   $0x10
80101df7:	57                   	push   %edi
80101df8:	56                   	push   %esi
80101df9:	53                   	push   %ebx
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101dfa:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101dfe:	e8 dd fb ff ff       	call   801019e0 <writei>
80101e03:	83 c4 20             	add    $0x20,%esp
80101e06:	83 f8 10             	cmp    $0x10,%eax
80101e09:	75 2a                	jne    80101e35 <dirlink+0xa5>
    panic("dirlink");

  return 0;
80101e0b:	31 c0                	xor    %eax,%eax
}
80101e0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e10:	5b                   	pop    %ebx
80101e11:	5e                   	pop    %esi
80101e12:	5f                   	pop    %edi
80101e13:	5d                   	pop    %ebp
80101e14:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101e15:	83 ec 0c             	sub    $0xc,%esp
80101e18:	50                   	push   %eax
80101e19:	e8 32 f9 ff ff       	call   80101750 <iput>
    return -1;
80101e1e:	83 c4 10             	add    $0x10,%esp
80101e21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e26:	eb e5                	jmp    80101e0d <dirlink+0x7d>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101e28:	83 ec 0c             	sub    $0xc,%esp
80101e2b:	68 15 71 10 80       	push   $0x80107115
80101e30:	e8 3b e5 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101e35:	83 ec 0c             	sub    $0xc,%esp
80101e38:	68 86 76 10 80       	push   $0x80107686
80101e3d:	e8 2e e5 ff ff       	call   80100370 <panic>
80101e42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101e50 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101e50:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101e51:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101e53:	89 e5                	mov    %esp,%ebp
80101e55:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101e58:	8b 45 08             	mov    0x8(%ebp),%eax
80101e5b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101e5e:	e8 7d fd ff ff       	call   80101be0 <namex>
}
80101e63:	c9                   	leave  
80101e64:	c3                   	ret    
80101e65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101e70 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101e70:	55                   	push   %ebp
  return namex(path, 1, name);
80101e71:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101e76:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101e78:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101e7b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101e7e:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101e7f:	e9 5c fd ff ff       	jmp    80101be0 <namex>
80101e84:	66 90                	xchg   %ax,%ax
80101e86:	66 90                	xchg   %ax,%ax
80101e88:	66 90                	xchg   %ax,%ax
80101e8a:	66 90                	xchg   %ax,%ax
80101e8c:	66 90                	xchg   %ax,%ax
80101e8e:	66 90                	xchg   %ax,%ax

80101e90 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101e90:	55                   	push   %ebp
  if(b == 0)
80101e91:	85 c0                	test   %eax,%eax
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101e93:	89 e5                	mov    %esp,%ebp
80101e95:	56                   	push   %esi
80101e96:	53                   	push   %ebx
  if(b == 0)
80101e97:	0f 84 ad 00 00 00    	je     80101f4a <idestart+0xba>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101e9d:	8b 58 08             	mov    0x8(%eax),%ebx
80101ea0:	89 c1                	mov    %eax,%ecx
80101ea2:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101ea8:	0f 87 8f 00 00 00    	ja     80101f3d <idestart+0xad>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101eae:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101eb3:	90                   	nop
80101eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101eb8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101eb9:	83 e0 c0             	and    $0xffffffc0,%eax
80101ebc:	3c 40                	cmp    $0x40,%al
80101ebe:	75 f8                	jne    80101eb8 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101ec0:	31 f6                	xor    %esi,%esi
80101ec2:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101ec7:	89 f0                	mov    %esi,%eax
80101ec9:	ee                   	out    %al,(%dx)
80101eca:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101ecf:	b8 01 00 00 00       	mov    $0x1,%eax
80101ed4:	ee                   	out    %al,(%dx)
80101ed5:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101eda:	89 d8                	mov    %ebx,%eax
80101edc:	ee                   	out    %al,(%dx)
80101edd:	89 d8                	mov    %ebx,%eax
80101edf:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101ee4:	c1 f8 08             	sar    $0x8,%eax
80101ee7:	ee                   	out    %al,(%dx)
80101ee8:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101eed:	89 f0                	mov    %esi,%eax
80101eef:	ee                   	out    %al,(%dx)
80101ef0:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
80101ef4:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101ef9:	83 e0 01             	and    $0x1,%eax
80101efc:	c1 e0 04             	shl    $0x4,%eax
80101eff:	83 c8 e0             	or     $0xffffffe0,%eax
80101f02:	ee                   	out    %al,(%dx)
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
80101f03:	f6 01 04             	testb  $0x4,(%ecx)
80101f06:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f0b:	75 13                	jne    80101f20 <idestart+0x90>
80101f0d:	b8 20 00 00 00       	mov    $0x20,%eax
80101f12:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f13:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f16:	5b                   	pop    %ebx
80101f17:	5e                   	pop    %esi
80101f18:	5d                   	pop    %ebp
80101f19:	c3                   	ret    
80101f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101f20:	b8 30 00 00 00       	mov    $0x30,%eax
80101f25:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80101f26:	ba f0 01 00 00       	mov    $0x1f0,%edx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101f2b:	8d 71 5c             	lea    0x5c(%ecx),%esi
80101f2e:	b9 80 00 00 00       	mov    $0x80,%ecx
80101f33:	fc                   	cld    
80101f34:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f36:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f39:	5b                   	pop    %ebx
80101f3a:	5e                   	pop    %esi
80101f3b:	5d                   	pop    %ebp
80101f3c:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
80101f3d:	83 ec 0c             	sub    $0xc,%esp
80101f40:	68 2b 71 10 80       	push   $0x8010712b
80101f45:	e8 26 e4 ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
80101f4a:	83 ec 0c             	sub    $0xc,%esp
80101f4d:	68 22 71 10 80       	push   $0x80107122
80101f52:	e8 19 e4 ff ff       	call   80100370 <panic>
80101f57:	89 f6                	mov    %esi,%esi
80101f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f60 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80101f60:	55                   	push   %ebp
80101f61:	89 e5                	mov    %esp,%ebp
80101f63:	83 ec 10             	sub    $0x10,%esp
  int i;

  initlock(&idelock, "ide");
80101f66:	68 3d 71 10 80       	push   $0x8010713d
80101f6b:	68 80 a5 10 80       	push   $0x8010a580
80101f70:	e8 4b 23 00 00       	call   801042c0 <initlock>
  picenable(IRQ_IDE);
80101f75:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80101f7c:	e8 8f 13 00 00       	call   80103310 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101f81:	58                   	pop    %eax
80101f82:	a1 a0 ad 14 80       	mov    0x8014ada0,%eax
80101f87:	5a                   	pop    %edx
80101f88:	83 e8 01             	sub    $0x1,%eax
80101f8b:	50                   	push   %eax
80101f8c:	6a 0e                	push   $0xe
80101f8e:	e8 bd 02 00 00       	call   80102250 <ioapicenable>
80101f93:	83 c4 10             	add    $0x10,%esp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f96:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f9b:	90                   	nop
80101f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fa0:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101fa1:	83 e0 c0             	and    $0xffffffc0,%eax
80101fa4:	3c 40                	cmp    $0x40,%al
80101fa6:	75 f8                	jne    80101fa0 <ideinit+0x40>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101fa8:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101fad:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80101fb2:	ee                   	out    %al,(%dx)
80101fb3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101fb8:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fbd:	eb 06                	jmp    80101fc5 <ideinit+0x65>
80101fbf:	90                   	nop
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80101fc0:	83 e9 01             	sub    $0x1,%ecx
80101fc3:	74 0f                	je     80101fd4 <ideinit+0x74>
80101fc5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80101fc6:	84 c0                	test   %al,%al
80101fc8:	74 f6                	je     80101fc0 <ideinit+0x60>
      havedisk1 = 1;
80101fca:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80101fd1:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101fd4:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101fd9:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80101fde:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
80101fdf:	c9                   	leave  
80101fe0:	c3                   	ret    
80101fe1:	eb 0d                	jmp    80101ff0 <ideintr>
80101fe3:	90                   	nop
80101fe4:	90                   	nop
80101fe5:	90                   	nop
80101fe6:	90                   	nop
80101fe7:	90                   	nop
80101fe8:	90                   	nop
80101fe9:	90                   	nop
80101fea:	90                   	nop
80101feb:	90                   	nop
80101fec:	90                   	nop
80101fed:	90                   	nop
80101fee:	90                   	nop
80101fef:	90                   	nop

80101ff0 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80101ff0:	55                   	push   %ebp
80101ff1:	89 e5                	mov    %esp,%ebp
80101ff3:	57                   	push   %edi
80101ff4:	56                   	push   %esi
80101ff5:	53                   	push   %ebx
80101ff6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80101ff9:	68 80 a5 10 80       	push   $0x8010a580
80101ffe:	e8 dd 22 00 00       	call   801042e0 <acquire>
  if((b = idequeue) == 0){
80102003:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102009:	83 c4 10             	add    $0x10,%esp
8010200c:	85 db                	test   %ebx,%ebx
8010200e:	74 34                	je     80102044 <ideintr+0x54>
    release(&idelock);
    // cprintf("spurious IDE interrupt\n");
    return;
  }
  idequeue = b->qnext;
80102010:	8b 43 58             	mov    0x58(%ebx),%eax
80102013:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102018:	8b 33                	mov    (%ebx),%esi
8010201a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102020:	74 3e                	je     80102060 <ideintr+0x70>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102022:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102025:	83 ec 0c             	sub    $0xc,%esp
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102028:	83 ce 02             	or     $0x2,%esi
8010202b:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010202d:	53                   	push   %ebx
8010202e:	e8 cd 1f 00 00       	call   80104000 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102033:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102038:	83 c4 10             	add    $0x10,%esp
8010203b:	85 c0                	test   %eax,%eax
8010203d:	74 05                	je     80102044 <ideintr+0x54>
    idestart(idequeue);
8010203f:	e8 4c fe ff ff       	call   80101e90 <idestart>
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
  if((b = idequeue) == 0){
    release(&idelock);
80102044:	83 ec 0c             	sub    $0xc,%esp
80102047:	68 80 a5 10 80       	push   $0x8010a580
8010204c:	e8 6f 24 00 00       	call   801044c0 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
80102051:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102054:	5b                   	pop    %ebx
80102055:	5e                   	pop    %esi
80102056:	5f                   	pop    %edi
80102057:	5d                   	pop    %ebp
80102058:	c3                   	ret    
80102059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102060:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102065:	8d 76 00             	lea    0x0(%esi),%esi
80102068:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102069:	89 c1                	mov    %eax,%ecx
8010206b:	83 e1 c0             	and    $0xffffffc0,%ecx
8010206e:	80 f9 40             	cmp    $0x40,%cl
80102071:	75 f5                	jne    80102068 <ideintr+0x78>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102073:	a8 21                	test   $0x21,%al
80102075:	75 ab                	jne    80102022 <ideintr+0x32>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
80102077:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
8010207a:	b9 80 00 00 00       	mov    $0x80,%ecx
8010207f:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102084:	fc                   	cld    
80102085:	f3 6d                	rep insl (%dx),%es:(%edi)
80102087:	8b 33                	mov    (%ebx),%esi
80102089:	eb 97                	jmp    80102022 <ideintr+0x32>
8010208b:	90                   	nop
8010208c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102090 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102090:	55                   	push   %ebp
80102091:	89 e5                	mov    %esp,%ebp
80102093:	53                   	push   %ebx
80102094:	83 ec 10             	sub    $0x10,%esp
80102097:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010209a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010209d:	50                   	push   %eax
8010209e:	e8 ed 21 00 00       	call   80104290 <holdingsleep>
801020a3:	83 c4 10             	add    $0x10,%esp
801020a6:	85 c0                	test   %eax,%eax
801020a8:	0f 84 ad 00 00 00    	je     8010215b <iderw+0xcb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801020ae:	8b 03                	mov    (%ebx),%eax
801020b0:	83 e0 06             	and    $0x6,%eax
801020b3:	83 f8 02             	cmp    $0x2,%eax
801020b6:	0f 84 b9 00 00 00    	je     80102175 <iderw+0xe5>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801020bc:	8b 53 04             	mov    0x4(%ebx),%edx
801020bf:	85 d2                	test   %edx,%edx
801020c1:	74 0d                	je     801020d0 <iderw+0x40>
801020c3:	a1 60 a5 10 80       	mov    0x8010a560,%eax
801020c8:	85 c0                	test   %eax,%eax
801020ca:	0f 84 98 00 00 00    	je     80102168 <iderw+0xd8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801020d0:	83 ec 0c             	sub    $0xc,%esp
801020d3:	68 80 a5 10 80       	push   $0x8010a580
801020d8:	e8 03 22 00 00       	call   801042e0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801020dd:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
801020e3:	83 c4 10             	add    $0x10,%esp
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
801020e6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801020ed:	85 d2                	test   %edx,%edx
801020ef:	75 09                	jne    801020fa <iderw+0x6a>
801020f1:	eb 58                	jmp    8010214b <iderw+0xbb>
801020f3:	90                   	nop
801020f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020f8:	89 c2                	mov    %eax,%edx
801020fa:	8b 42 58             	mov    0x58(%edx),%eax
801020fd:	85 c0                	test   %eax,%eax
801020ff:	75 f7                	jne    801020f8 <iderw+0x68>
80102101:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102104:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102106:	3b 1d 64 a5 10 80    	cmp    0x8010a564,%ebx
8010210c:	74 44                	je     80102152 <iderw+0xc2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010210e:	8b 03                	mov    (%ebx),%eax
80102110:	83 e0 06             	and    $0x6,%eax
80102113:	83 f8 02             	cmp    $0x2,%eax
80102116:	74 23                	je     8010213b <iderw+0xab>
80102118:	90                   	nop
80102119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102120:	83 ec 08             	sub    $0x8,%esp
80102123:	68 80 a5 10 80       	push   $0x8010a580
80102128:	53                   	push   %ebx
80102129:	e8 32 1d 00 00       	call   80103e60 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010212e:	8b 03                	mov    (%ebx),%eax
80102130:	83 c4 10             	add    $0x10,%esp
80102133:	83 e0 06             	and    $0x6,%eax
80102136:	83 f8 02             	cmp    $0x2,%eax
80102139:	75 e5                	jne    80102120 <iderw+0x90>
    sleep(b, &idelock);
  }

  release(&idelock);
8010213b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102142:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102145:	c9                   	leave  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }

  release(&idelock);
80102146:	e9 75 23 00 00       	jmp    801044c0 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010214b:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102150:	eb b2                	jmp    80102104 <iderw+0x74>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
80102152:	89 d8                	mov    %ebx,%eax
80102154:	e8 37 fd ff ff       	call   80101e90 <idestart>
80102159:	eb b3                	jmp    8010210e <iderw+0x7e>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
8010215b:	83 ec 0c             	sub    $0xc,%esp
8010215e:	68 41 71 10 80       	push   $0x80107141
80102163:	e8 08 e2 ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
80102168:	83 ec 0c             	sub    $0xc,%esp
8010216b:	68 6c 71 10 80       	push   $0x8010716c
80102170:	e8 fb e1 ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
80102175:	83 ec 0c             	sub    $0xc,%esp
80102178:	68 57 71 10 80       	push   $0x80107157
8010217d:	e8 ee e1 ff ff       	call   80100370 <panic>
80102182:	66 90                	xchg   %ax,%ax
80102184:	66 90                	xchg   %ax,%ax
80102186:	66 90                	xchg   %ax,%ax
80102188:	66 90                	xchg   %ax,%ax
8010218a:	66 90                	xchg   %ax,%ax
8010218c:	66 90                	xchg   %ax,%ax
8010218e:	66 90                	xchg   %ax,%ax

80102190 <ioapicinit>:
void
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
80102190:	a1 a4 a7 14 80       	mov    0x8014a7a4,%eax
80102195:	85 c0                	test   %eax,%eax
80102197:	0f 84 a8 00 00 00    	je     80102245 <ioapicinit+0xb5>
  ioapic->data = data;
}

void
ioapicinit(void)
{
8010219d:	55                   	push   %ebp
  int i, id, maxintr;

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
8010219e:	c7 05 54 26 11 80 00 	movl   $0xfec00000,0x80112654
801021a5:	00 c0 fe 
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021a8:	89 e5                	mov    %esp,%ebp
801021aa:	56                   	push   %esi
801021ab:	53                   	push   %ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801021ac:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801021b3:	00 00 00 
  return ioapic->data;
801021b6:	8b 15 54 26 11 80    	mov    0x80112654,%edx
801021bc:	8b 72 10             	mov    0x10(%edx),%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801021bf:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801021c5:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801021cb:	0f b6 15 a0 a7 14 80 	movzbl 0x8014a7a0,%edx

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801021d2:	89 f0                	mov    %esi,%eax
801021d4:	c1 e8 10             	shr    $0x10,%eax
801021d7:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
801021da:	8b 41 10             	mov    0x10(%ecx),%eax
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801021dd:	c1 e8 18             	shr    $0x18,%eax
801021e0:	39 d0                	cmp    %edx,%eax
801021e2:	74 16                	je     801021fa <ioapicinit+0x6a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801021e4:	83 ec 0c             	sub    $0xc,%esp
801021e7:	68 8c 71 10 80       	push   $0x8010718c
801021ec:	e8 6f e4 ff ff       	call   80100660 <cprintf>
801021f1:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
801021f7:	83 c4 10             	add    $0x10,%esp
801021fa:	83 c6 21             	add    $0x21,%esi
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021fd:	ba 10 00 00 00       	mov    $0x10,%edx
80102202:	b8 20 00 00 00       	mov    $0x20,%eax
80102207:	89 f6                	mov    %esi,%esi
80102209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102210:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102212:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102218:	89 c3                	mov    %eax,%ebx
8010221a:	81 cb 00 00 01 00    	or     $0x10000,%ebx
80102220:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102223:	89 59 10             	mov    %ebx,0x10(%ecx)
80102226:	8d 5a 01             	lea    0x1(%edx),%ebx
80102229:	83 c2 02             	add    $0x2,%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010222c:	39 f0                	cmp    %esi,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010222e:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102230:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
80102236:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010223d:	75 d1                	jne    80102210 <ioapicinit+0x80>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010223f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102242:	5b                   	pop    %ebx
80102243:	5e                   	pop    %esi
80102244:	5d                   	pop    %ebp
80102245:	f3 c3                	repz ret 
80102247:	89 f6                	mov    %esi,%esi
80102249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102250 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
80102250:	8b 15 a4 a7 14 80    	mov    0x8014a7a4,%edx
  }
}

void
ioapicenable(int irq, int cpunum)
{
80102256:	55                   	push   %ebp
80102257:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102259:	85 d2                	test   %edx,%edx
  }
}

void
ioapicenable(int irq, int cpunum)
{
8010225b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!ismp)
8010225e:	74 2b                	je     8010228b <ioapicenable+0x3b>
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102260:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102266:	8d 50 20             	lea    0x20(%eax),%edx
80102269:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010226d:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010226f:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102275:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102278:	89 51 10             	mov    %edx,0x10(%ecx)

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010227b:	8b 55 0c             	mov    0xc(%ebp),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010227e:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102280:	a1 54 26 11 80       	mov    0x80112654,%eax

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102285:	c1 e2 18             	shl    $0x18,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102288:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
8010228b:	5d                   	pop    %ebp
8010228c:	c3                   	ret    
8010228d:	66 90                	xchg   %ax,%ax
8010228f:	90                   	nop

80102290 <kfree>:
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
// reference counter 감소해야 및 ref count가 0이되면 freelist에 추가해야함 20193062
void
kfree(char *v)
{
80102290:	55                   	push   %ebp
80102291:	89 e5                	mov    %esp,%ebp
80102293:	53                   	push   %ebx
80102294:	83 ec 04             	sub    $0x4,%esp
80102297:	8b 5d 08             	mov    0x8(%ebp),%ebx

  struct run *r;
  //uint cur_page_idx =(((uint) v  - (uint)end )/ PGSIZE);	//20139062

  
  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010229a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801022a0:	0f 85 bf 00 00 00    	jne    80102365 <kfree+0xd5>
801022a6:	81 fb 48 d5 14 80    	cmp    $0x8014d548,%ebx
801022ac:	0f 82 b3 00 00 00    	jb     80102365 <kfree+0xd5>
801022b2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801022b8:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801022bd:	0f 87 a2 00 00 00    	ja     80102365 <kfree+0xd5>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  
  if(kmem.use_lock)
801022c3:	8b 15 94 26 11 80    	mov    0x80112694,%edx
801022c9:	85 d2                	test   %edx,%edx
801022cb:	0f 85 7f 00 00 00    	jne    80102350 <kfree+0xc0>
    acquire(&kmem.lock);
  pgrefcount[(v-end)/PGSIZE]--;  //20193062
801022d1:	89 da                	mov    %ebx,%edx
801022d3:	81 ea 48 d5 14 80    	sub    $0x8014d548,%edx
801022d9:	8d 82 ff 0f 00 00    	lea    0xfff(%edx),%eax
801022df:	85 d2                	test   %edx,%edx
801022e1:	0f 49 c2             	cmovns %edx,%eax
801022e4:	c1 f8 0c             	sar    $0xc,%eax
801022e7:	8b 0c 85 a0 26 11 80 	mov    -0x7feed960(,%eax,4),%ecx
801022ee:	8d 51 ff             	lea    -0x1(%ecx),%edx
  if(pgrefcount[(v-end)/PGSIZE] == 0 )    //20193062
801022f1:	85 d2                	test   %edx,%edx

  // Fill with junk to catch dangling refs.
  
  if(kmem.use_lock)
    acquire(&kmem.lock);
  pgrefcount[(v-end)/PGSIZE]--;  //20193062
801022f3:	89 14 85 a0 26 11 80 	mov    %edx,-0x7feed960(,%eax,4)
  if(pgrefcount[(v-end)/PGSIZE] == 0 )    //20193062
801022fa:	74 24                	je     80102320 <kfree+0x90>
    r = (struct run*)v;
    r->next = kmem.freelist;
    kmem.freelist = r;   
  } //20193062 

  if(kmem.use_lock)
801022fc:	a1 94 26 11 80       	mov    0x80112694,%eax
80102301:	85 c0                	test   %eax,%eax
80102303:	75 0b                	jne    80102310 <kfree+0x80>
    release(&kmem.lock);
}
80102305:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102308:	c9                   	leave  
80102309:	c3                   	ret    
8010230a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    r->next = kmem.freelist;
    kmem.freelist = r;   
  } //20193062 

  if(kmem.use_lock)
    release(&kmem.lock);
80102310:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
80102317:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010231a:	c9                   	leave  
    r->next = kmem.freelist;
    kmem.freelist = r;   
  } //20193062 

  if(kmem.use_lock)
    release(&kmem.lock);
8010231b:	e9 a0 21 00 00       	jmp    801044c0 <release>
    acquire(&kmem.lock);
  pgrefcount[(v-end)/PGSIZE]--;  //20193062
  if(pgrefcount[(v-end)/PGSIZE] == 0 )    //20193062
  {    //20193062

    memset(v, 1, PGSIZE);
80102320:	83 ec 04             	sub    $0x4,%esp
80102323:	68 00 10 00 00       	push   $0x1000
80102328:	6a 01                	push   $0x1
8010232a:	53                   	push   %ebx
8010232b:	e8 e0 21 00 00       	call   80104510 <memset>
    numfreepages++; 
    r = (struct run*)v;
    r->next = kmem.freelist;
80102330:	a1 98 26 11 80       	mov    0x80112698,%eax
  pgrefcount[(v-end)/PGSIZE]--;  //20193062
  if(pgrefcount[(v-end)/PGSIZE] == 0 )    //20193062
  {    //20193062

    memset(v, 1, PGSIZE);
    numfreepages++; 
80102335:	83 05 b4 a5 10 80 01 	addl   $0x1,0x8010a5b4
    r = (struct run*)v;
    r->next = kmem.freelist;
    kmem.freelist = r;   
8010233c:	83 c4 10             	add    $0x10,%esp
  {    //20193062

    memset(v, 1, PGSIZE);
    numfreepages++; 
    r = (struct run*)v;
    r->next = kmem.freelist;
8010233f:	89 03                	mov    %eax,(%ebx)
    kmem.freelist = r;   
80102341:	89 1d 98 26 11 80    	mov    %ebx,0x80112698
80102347:	eb b3                	jmp    801022fc <kfree+0x6c>
80102349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("kfree");

  // Fill with junk to catch dangling refs.
  
  if(kmem.use_lock)
    acquire(&kmem.lock);
80102350:	83 ec 0c             	sub    $0xc,%esp
80102353:	68 60 26 11 80       	push   $0x80112660
80102358:	e8 83 1f 00 00       	call   801042e0 <acquire>
8010235d:	83 c4 10             	add    $0x10,%esp
80102360:	e9 6c ff ff ff       	jmp    801022d1 <kfree+0x41>
  struct run *r;
  //uint cur_page_idx =(((uint) v  - (uint)end )/ PGSIZE);	//20139062

  
  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
80102365:	83 ec 0c             	sub    $0xc,%esp
80102368:	68 be 71 10 80       	push   $0x801071be
8010236d:	e8 fe df ff ff       	call   80100370 <panic>
80102372:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102380 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102380:	55                   	push   %ebp
80102381:	89 e5                	mov    %esp,%ebp
80102383:	56                   	push   %esi
80102384:	53                   	push   %ebx
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102385:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102388:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010238b:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80102391:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  //cprintf("%d\n",idx);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102397:	8d 86 00 10 00 00    	lea    0x1000(%esi),%eax
8010239d:	39 c3                	cmp    %eax,%ebx
8010239f:	72 44                	jb     801023e5 <freerange+0x65>
801023a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  {  
    pgrefcount[(p - end)/PGSIZE] = 1; 
801023a8:	89 f2                	mov    %esi,%edx
801023aa:	81 ea 48 d5 14 80    	sub    $0x8014d548,%edx
801023b0:	8d 82 ff 0f 00 00    	lea    0xfff(%edx),%eax
801023b6:	85 d2                	test   %edx,%edx
801023b8:	0f 49 c2             	cmovns %edx,%eax
    kfree(p);
801023bb:	83 ec 0c             	sub    $0xc,%esp
801023be:	56                   	push   %esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  //cprintf("%d\n",idx);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
  {  
    pgrefcount[(p - end)/PGSIZE] = 1; 
801023bf:	c1 f8 0c             	sar    $0xc,%eax
801023c2:	c7 04 85 a0 26 11 80 	movl   $0x1,-0x7feed960(,%eax,4)
801023c9:	01 00 00 00 
    kfree(p);
801023cd:	e8 be fe ff ff       	call   80102290 <kfree>
801023d2:	8d 86 00 20 00 00    	lea    0x2000(%esi),%eax
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  //cprintf("%d\n",idx);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023d8:	83 c4 10             	add    $0x10,%esp
801023db:	81 c6 00 10 00 00    	add    $0x1000,%esi
801023e1:	39 d8                	cmp    %ebx,%eax
801023e3:	76 c3                	jbe    801023a8 <freerange+0x28>
  {  
    pgrefcount[(p - end)/PGSIZE] = 1; 
    kfree(p);
  }
}
801023e5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023e8:	5b                   	pop    %ebx
801023e9:	5e                   	pop    %esi
801023ea:	5d                   	pop    %ebp
801023eb:	c3                   	ret    
801023ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023f0 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	56                   	push   %esi
801023f4:	53                   	push   %ebx
801023f5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  initlock(&kmem.lock, "kmem");
801023f8:	83 ec 08             	sub    $0x8,%esp
801023fb:	68 c4 71 10 80       	push   $0x801071c4
80102400:	68 60 26 11 80       	push   $0x80112660
80102405:	e8 b6 1e 00 00       	call   801042c0 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010240a:	8b 45 08             	mov    0x8(%ebp),%eax
  //cprintf("%d\n",idx);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010240d:	83 c4 10             	add    $0x10,%esp
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
80102410:	c7 05 94 26 11 80 00 	movl   $0x0,0x80112694
80102417:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010241a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80102420:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  //cprintf("%d\n",idx);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102426:	8d 86 00 10 00 00    	lea    0x1000(%esi),%eax
8010242c:	39 c3                	cmp    %eax,%ebx
8010242e:	72 3d                	jb     8010246d <kinit1+0x7d>
  {  
    pgrefcount[(p - end)/PGSIZE] = 1; 
80102430:	89 f2                	mov    %esi,%edx
80102432:	81 ea 48 d5 14 80    	sub    $0x8014d548,%edx
80102438:	8d 82 ff 0f 00 00    	lea    0xfff(%edx),%eax
8010243e:	85 d2                	test   %edx,%edx
80102440:	0f 49 c2             	cmovns %edx,%eax
    kfree(p);
80102443:	83 ec 0c             	sub    $0xc,%esp
80102446:	56                   	push   %esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  //cprintf("%d\n",idx);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
  {  
    pgrefcount[(p - end)/PGSIZE] = 1; 
80102447:	c1 f8 0c             	sar    $0xc,%eax
8010244a:	c7 04 85 a0 26 11 80 	movl   $0x1,-0x7feed960(,%eax,4)
80102451:	01 00 00 00 
    kfree(p);
80102455:	e8 36 fe ff ff       	call   80102290 <kfree>
8010245a:	8d 86 00 20 00 00    	lea    0x2000(%esi),%eax
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  //cprintf("%d\n",idx);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102460:	83 c4 10             	add    $0x10,%esp
80102463:	81 c6 00 10 00 00    	add    $0x1000,%esi
80102469:	39 c3                	cmp    %eax,%ebx
8010246b:	73 c3                	jae    80102430 <kinit1+0x40>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010246d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102470:	5b                   	pop    %ebx
80102471:	5e                   	pop    %esi
80102472:	5d                   	pop    %ebp
80102473:	c3                   	ret    
80102474:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010247a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102480 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102480:	55                   	push   %ebp
80102481:	89 e5                	mov    %esp,%ebp
80102483:	56                   	push   %esi
80102484:	53                   	push   %ebx

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102485:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
80102488:	8b 5d 0c             	mov    0xc(%ebp),%ebx

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010248b:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80102491:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  //cprintf("%d\n",idx);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102497:	8d 86 00 10 00 00    	lea    0x1000(%esi),%eax
8010249d:	39 c3                	cmp    %eax,%ebx
8010249f:	72 44                	jb     801024e5 <kinit2+0x65>
801024a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  {  
    pgrefcount[(p - end)/PGSIZE] = 1; 
801024a8:	89 f2                	mov    %esi,%edx
801024aa:	81 ea 48 d5 14 80    	sub    $0x8014d548,%edx
801024b0:	8d 82 ff 0f 00 00    	lea    0xfff(%edx),%eax
801024b6:	85 d2                	test   %edx,%edx
801024b8:	0f 49 c2             	cmovns %edx,%eax
    kfree(p);
801024bb:	83 ec 0c             	sub    $0xc,%esp
801024be:	56                   	push   %esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  //cprintf("%d\n",idx);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
  {  
    pgrefcount[(p - end)/PGSIZE] = 1; 
801024bf:	c1 f8 0c             	sar    $0xc,%eax
801024c2:	c7 04 85 a0 26 11 80 	movl   $0x1,-0x7feed960(,%eax,4)
801024c9:	01 00 00 00 
    kfree(p);
801024cd:	e8 be fd ff ff       	call   80102290 <kfree>
801024d2:	8d 86 00 20 00 00    	lea    0x2000(%esi),%eax
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  //cprintf("%d\n",idx);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024d8:	83 c4 10             	add    $0x10,%esp
801024db:	81 c6 00 10 00 00    	add    $0x1000,%esi
801024e1:	39 c3                	cmp    %eax,%ebx
801024e3:	73 c3                	jae    801024a8 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
801024e5:	c7 05 94 26 11 80 01 	movl   $0x1,0x80112694
801024ec:	00 00 00 
}
801024ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024f2:	5b                   	pop    %ebx
801024f3:	5e                   	pop    %esi
801024f4:	5d                   	pop    %ebp
801024f5:	c3                   	ret    
801024f6:	8d 76 00             	lea    0x0(%esi),%esi
801024f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102500 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102500:	55                   	push   %ebp
80102501:	89 e5                	mov    %esp,%ebp
80102503:	53                   	push   %ebx
80102504:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102507:	8b 15 94 26 11 80    	mov    0x80112694,%edx
8010250d:	85 d2                	test   %edx,%edx
8010250f:	75 57                	jne    80102568 <kalloc+0x68>
    acquire(&kmem.lock);
  
  r = kmem.freelist;
80102511:	8b 1d 98 26 11 80    	mov    0x80112698,%ebx
  
  if(r)
80102517:	85 db                	test   %ebx,%ebx
80102519:	74 07                	je     80102522 <kalloc+0x22>
      numfreepages--;
8010251b:	83 2d b4 a5 10 80 01 	subl   $0x1,0x8010a5b4
      kmem.freelist = r->next;
80102522:	8b 03                	mov    (%ebx),%eax
      cprintf("IDX : %d\n",((char*)r - end) >> PGSHIFT);
80102524:	83 ec 08             	sub    $0x8,%esp
  
  r = kmem.freelist;
  
  if(r)
      numfreepages--;
      kmem.freelist = r->next;
80102527:	a3 98 26 11 80       	mov    %eax,0x80112698
      cprintf("IDX : %d\n",((char*)r - end) >> PGSHIFT);
8010252c:	89 d8                	mov    %ebx,%eax
8010252e:	2d 48 d5 14 80       	sub    $0x8014d548,%eax
80102533:	c1 f8 0c             	sar    $0xc,%eax
80102536:	50                   	push   %eax
80102537:	68 c9 71 10 80       	push   $0x801071c9
8010253c:	e8 1f e1 ff ff       	call   80100660 <cprintf>

  if(kmem.use_lock)
80102541:	a1 94 26 11 80       	mov    0x80112694,%eax
80102546:	83 c4 10             	add    $0x10,%esp
80102549:	85 c0                	test   %eax,%eax
8010254b:	74 10                	je     8010255d <kalloc+0x5d>
    release(&kmem.lock);
8010254d:	83 ec 0c             	sub    $0xc,%esp
80102550:	68 60 26 11 80       	push   $0x80112660
80102555:	e8 66 1f 00 00       	call   801044c0 <release>
8010255a:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
}
8010255d:	89 d8                	mov    %ebx,%eax
8010255f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102562:	c9                   	leave  
80102563:	c3                   	ret    
80102564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102568:	83 ec 0c             	sub    $0xc,%esp
8010256b:	68 60 26 11 80       	push   $0x80112660
80102570:	e8 6b 1d 00 00       	call   801042e0 <acquire>
80102575:	83 c4 10             	add    $0x10,%esp
80102578:	eb 97                	jmp    80102511 <kalloc+0x11>
8010257a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102580 <freemem>:
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}

int freemem(){
80102580:	55                   	push   %ebp
	return numfreepages;
}
80102581:	a1 b4 a5 10 80       	mov    0x8010a5b4,%eax
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}

int freemem(){
80102586:	89 e5                	mov    %esp,%ebp
	return numfreepages;
}
80102588:	5d                   	pop    %ebp
80102589:	c3                   	ret    
8010258a:	66 90                	xchg   %ax,%ax
8010258c:	66 90                	xchg   %ax,%ax
8010258e:	66 90                	xchg   %ax,%ax

80102590 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102590:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102591:	ba 64 00 00 00       	mov    $0x64,%edx
80102596:	89 e5                	mov    %esp,%ebp
80102598:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102599:	a8 01                	test   $0x1,%al
8010259b:	0f 84 af 00 00 00    	je     80102650 <kbdgetc+0xc0>
801025a1:	ba 60 00 00 00       	mov    $0x60,%edx
801025a6:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801025a7:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801025aa:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
801025b0:	74 7e                	je     80102630 <kbdgetc+0xa0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801025b2:	84 c0                	test   %al,%al
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801025b4:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801025ba:	79 24                	jns    801025e0 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801025bc:	f6 c1 40             	test   $0x40,%cl
801025bf:	75 05                	jne    801025c6 <kbdgetc+0x36>
801025c1:	89 c2                	mov    %eax,%edx
801025c3:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801025c6:	0f b6 82 00 73 10 80 	movzbl -0x7fef8d00(%edx),%eax
801025cd:	83 c8 40             	or     $0x40,%eax
801025d0:	0f b6 c0             	movzbl %al,%eax
801025d3:	f7 d0                	not    %eax
801025d5:	21 c8                	and    %ecx,%eax
801025d7:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
    return 0;
801025dc:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025de:	5d                   	pop    %ebp
801025df:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801025e0:	f6 c1 40             	test   $0x40,%cl
801025e3:	74 09                	je     801025ee <kbdgetc+0x5e>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801025e5:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801025e8:	83 e1 bf             	and    $0xffffffbf,%ecx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801025eb:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
801025ee:	0f b6 82 00 73 10 80 	movzbl -0x7fef8d00(%edx),%eax
801025f5:	09 c1                	or     %eax,%ecx
801025f7:	0f b6 82 00 72 10 80 	movzbl -0x7fef8e00(%edx),%eax
801025fe:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102600:	89 c8                	mov    %ecx,%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102602:	89 0d b8 a5 10 80    	mov    %ecx,0x8010a5b8
  c = charcode[shift & (CTL | SHIFT)][data];
80102608:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010260b:	83 e1 08             	and    $0x8,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010260e:	8b 04 85 e0 71 10 80 	mov    -0x7fef8e20(,%eax,4),%eax
80102615:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102619:	74 c3                	je     801025de <kbdgetc+0x4e>
    if('a' <= c && c <= 'z')
8010261b:	8d 50 9f             	lea    -0x61(%eax),%edx
8010261e:	83 fa 19             	cmp    $0x19,%edx
80102621:	77 1d                	ja     80102640 <kbdgetc+0xb0>
      c += 'A' - 'a';
80102623:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102626:	5d                   	pop    %ebp
80102627:	c3                   	ret    
80102628:	90                   	nop
80102629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
80102630:	31 c0                	xor    %eax,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102632:	83 0d b8 a5 10 80 40 	orl    $0x40,0x8010a5b8
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102639:	5d                   	pop    %ebp
8010263a:	c3                   	ret    
8010263b:	90                   	nop
8010263c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
80102640:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102643:	8d 50 20             	lea    0x20(%eax),%edx
  }
  return c;
}
80102646:	5d                   	pop    %ebp
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
80102647:	83 f9 19             	cmp    $0x19,%ecx
8010264a:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
8010264d:	c3                   	ret    
8010264e:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
80102650:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102655:	5d                   	pop    %ebp
80102656:	c3                   	ret    
80102657:	89 f6                	mov    %esi,%esi
80102659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102660 <kbdintr>:

void
kbdintr(void)
{
80102660:	55                   	push   %ebp
80102661:	89 e5                	mov    %esp,%ebp
80102663:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102666:	68 90 25 10 80       	push   $0x80102590
8010266b:	e8 80 e1 ff ff       	call   801007f0 <consoleintr>
}
80102670:	83 c4 10             	add    $0x10,%esp
80102673:	c9                   	leave  
80102674:	c3                   	ret    
80102675:	66 90                	xchg   %ax,%ax
80102677:	66 90                	xchg   %ax,%ax
80102679:	66 90                	xchg   %ax,%ax
8010267b:	66 90                	xchg   %ax,%ax
8010267d:	66 90                	xchg   %ax,%ax
8010267f:	90                   	nop

80102680 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
  if(!lapic)
80102680:	a1 a0 a6 14 80       	mov    0x8014a6a0,%eax
}
//PAGEBREAK!

void
lapicinit(void)
{
80102685:	55                   	push   %ebp
80102686:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102688:	85 c0                	test   %eax,%eax
8010268a:	0f 84 c8 00 00 00    	je     80102758 <lapicinit+0xd8>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102690:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102697:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010269a:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010269d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801026a4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026a7:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026aa:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801026b1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801026b4:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026b7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801026be:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801026c1:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026c4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026cb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ce:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026d1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026d8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026db:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026de:	8b 50 30             	mov    0x30(%eax),%edx
801026e1:	c1 ea 10             	shr    $0x10,%edx
801026e4:	80 fa 03             	cmp    $0x3,%dl
801026e7:	77 77                	ja     80102760 <lapicinit+0xe0>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026e9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026f0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026f3:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026f6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026fd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102700:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102703:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010270a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010270d:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102710:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102717:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010271a:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010271d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102724:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102727:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010272a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102731:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102734:	8b 50 20             	mov    0x20(%eax),%edx
80102737:	89 f6                	mov    %esi,%esi
80102739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102740:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102746:	80 e6 10             	and    $0x10,%dh
80102749:	75 f5                	jne    80102740 <lapicinit+0xc0>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010274b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102752:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102755:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102758:	5d                   	pop    %ebp
80102759:	c3                   	ret    
8010275a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102760:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102767:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010276a:	8b 50 20             	mov    0x20(%eax),%edx
8010276d:	e9 77 ff ff ff       	jmp    801026e9 <lapicinit+0x69>
80102772:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102780 <cpunum>:
  lapicw(TPR, 0);
}

int
cpunum(void)
{
80102780:	55                   	push   %ebp
80102781:	89 e5                	mov    %esp,%ebp
80102783:	56                   	push   %esi
80102784:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102785:	9c                   	pushf  
80102786:	58                   	pop    %eax
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102787:	f6 c4 02             	test   $0x2,%ah
8010278a:	74 12                	je     8010279e <cpunum+0x1e>
    static int n;
    if(n++ == 0)
8010278c:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80102791:	8d 50 01             	lea    0x1(%eax),%edx
80102794:	85 c0                	test   %eax,%eax
80102796:	89 15 bc a5 10 80    	mov    %edx,0x8010a5bc
8010279c:	74 4d                	je     801027eb <cpunum+0x6b>
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if (!lapic)
8010279e:	a1 a0 a6 14 80       	mov    0x8014a6a0,%eax
801027a3:	85 c0                	test   %eax,%eax
801027a5:	74 60                	je     80102807 <cpunum+0x87>
    return 0;

  apicid = lapic[ID] >> 24;
801027a7:	8b 58 20             	mov    0x20(%eax),%ebx
  for (i = 0; i < ncpu; ++i) {
801027aa:	8b 35 a0 ad 14 80    	mov    0x8014ada0,%esi
  }

  if (!lapic)
    return 0;

  apicid = lapic[ID] >> 24;
801027b0:	c1 eb 18             	shr    $0x18,%ebx
  for (i = 0; i < ncpu; ++i) {
801027b3:	85 f6                	test   %esi,%esi
801027b5:	7e 59                	jle    80102810 <cpunum+0x90>
    if (cpus[i].apicid == apicid)
801027b7:	0f b6 05 c0 a7 14 80 	movzbl 0x8014a7c0,%eax
801027be:	39 c3                	cmp    %eax,%ebx
801027c0:	74 45                	je     80102807 <cpunum+0x87>
801027c2:	ba 7c a8 14 80       	mov    $0x8014a87c,%edx
801027c7:	31 c0                	xor    %eax,%eax
801027c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  if (!lapic)
    return 0;

  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
801027d0:	83 c0 01             	add    $0x1,%eax
801027d3:	39 f0                	cmp    %esi,%eax
801027d5:	74 39                	je     80102810 <cpunum+0x90>
    if (cpus[i].apicid == apicid)
801027d7:	0f b6 0a             	movzbl (%edx),%ecx
801027da:	81 c2 bc 00 00 00    	add    $0xbc,%edx
801027e0:	39 cb                	cmp    %ecx,%ebx
801027e2:	75 ec                	jne    801027d0 <cpunum+0x50>
      return i;
  }
  panic("unknown apicid\n");
}
801027e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027e7:	5b                   	pop    %ebx
801027e8:	5e                   	pop    %esi
801027e9:	5d                   	pop    %ebp
801027ea:	c3                   	ret    
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
    static int n;
    if(n++ == 0)
      cprintf("cpu called from %x with interrupts enabled\n",
801027eb:	83 ec 08             	sub    $0x8,%esp
801027ee:	ff 75 04             	pushl  0x4(%ebp)
801027f1:	68 00 74 10 80       	push   $0x80107400
801027f6:	e8 65 de ff ff       	call   80100660 <cprintf>
        __builtin_return_address(0));
  }

  if (!lapic)
801027fb:	a1 a0 a6 14 80       	mov    0x8014a6a0,%eax
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
    static int n;
    if(n++ == 0)
      cprintf("cpu called from %x with interrupts enabled\n",
80102800:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if (!lapic)
80102803:	85 c0                	test   %eax,%eax
80102805:	75 a0                	jne    801027a7 <cpunum+0x27>
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
}
80102807:	8d 65 f8             	lea    -0x8(%ebp),%esp
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if (!lapic)
    return 0;
8010280a:	31 c0                	xor    %eax,%eax
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
}
8010280c:	5b                   	pop    %ebx
8010280d:	5e                   	pop    %esi
8010280e:	5d                   	pop    %ebp
8010280f:	c3                   	ret    
  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
80102810:	83 ec 0c             	sub    $0xc,%esp
80102813:	68 2c 74 10 80       	push   $0x8010742c
80102818:	e8 53 db ff ff       	call   80100370 <panic>
8010281d:	8d 76 00             	lea    0x0(%esi),%esi

80102820 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102820:	a1 a0 a6 14 80       	mov    0x8014a6a0,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102825:	55                   	push   %ebp
80102826:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102828:	85 c0                	test   %eax,%eax
8010282a:	74 0d                	je     80102839 <lapiceoi+0x19>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010282c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102833:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102836:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102839:	5d                   	pop    %ebp
8010283a:	c3                   	ret    
8010283b:	90                   	nop
8010283c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102840 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102840:	55                   	push   %ebp
80102841:	89 e5                	mov    %esp,%ebp
}
80102843:	5d                   	pop    %ebp
80102844:	c3                   	ret    
80102845:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102850 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102850:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102851:	ba 70 00 00 00       	mov    $0x70,%edx
80102856:	b8 0f 00 00 00       	mov    $0xf,%eax
8010285b:	89 e5                	mov    %esp,%ebp
8010285d:	53                   	push   %ebx
8010285e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102861:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102864:	ee                   	out    %al,(%dx)
80102865:	ba 71 00 00 00       	mov    $0x71,%edx
8010286a:	b8 0a 00 00 00       	mov    $0xa,%eax
8010286f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102870:	31 c0                	xor    %eax,%eax
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102872:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102875:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010287b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010287d:	c1 e9 0c             	shr    $0xc,%ecx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102880:	c1 e8 04             	shr    $0x4,%eax
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102883:	89 da                	mov    %ebx,%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102885:	80 cd 06             	or     $0x6,%ch
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102888:	66 a3 69 04 00 80    	mov    %ax,0x80000469
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010288e:	a1 a0 a6 14 80       	mov    0x8014a6a0,%eax
80102893:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102899:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010289c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801028a3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028a6:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028a9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801028b0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028b3:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028b6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028bc:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028bf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028c5:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028c8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028ce:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028d1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028d7:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801028da:	5b                   	pop    %ebx
801028db:	5d                   	pop    %ebp
801028dc:	c3                   	ret    
801028dd:	8d 76 00             	lea    0x0(%esi),%esi

801028e0 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801028e0:	55                   	push   %ebp
801028e1:	ba 70 00 00 00       	mov    $0x70,%edx
801028e6:	b8 0b 00 00 00       	mov    $0xb,%eax
801028eb:	89 e5                	mov    %esp,%ebp
801028ed:	57                   	push   %edi
801028ee:	56                   	push   %esi
801028ef:	53                   	push   %ebx
801028f0:	83 ec 4c             	sub    $0x4c,%esp
801028f3:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028f4:	ba 71 00 00 00       	mov    $0x71,%edx
801028f9:	ec                   	in     (%dx),%al
801028fa:	83 e0 04             	and    $0x4,%eax
801028fd:	8d 75 d0             	lea    -0x30(%ebp),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102900:	31 db                	xor    %ebx,%ebx
80102902:	88 45 b7             	mov    %al,-0x49(%ebp)
80102905:	bf 70 00 00 00       	mov    $0x70,%edi
8010290a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102910:	89 d8                	mov    %ebx,%eax
80102912:	89 fa                	mov    %edi,%edx
80102914:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102915:	b9 71 00 00 00       	mov    $0x71,%ecx
8010291a:	89 ca                	mov    %ecx,%edx
8010291c:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
8010291d:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102920:	89 fa                	mov    %edi,%edx
80102922:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102925:	b8 02 00 00 00       	mov    $0x2,%eax
8010292a:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010292b:	89 ca                	mov    %ecx,%edx
8010292d:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
8010292e:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102931:	89 fa                	mov    %edi,%edx
80102933:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102936:	b8 04 00 00 00       	mov    $0x4,%eax
8010293b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010293c:	89 ca                	mov    %ecx,%edx
8010293e:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
8010293f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102942:	89 fa                	mov    %edi,%edx
80102944:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102947:	b8 07 00 00 00       	mov    $0x7,%eax
8010294c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010294d:	89 ca                	mov    %ecx,%edx
8010294f:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102950:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102953:	89 fa                	mov    %edi,%edx
80102955:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102958:	b8 08 00 00 00       	mov    $0x8,%eax
8010295d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010295e:	89 ca                	mov    %ecx,%edx
80102960:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102961:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102964:	89 fa                	mov    %edi,%edx
80102966:	89 45 c8             	mov    %eax,-0x38(%ebp)
80102969:	b8 09 00 00 00       	mov    $0x9,%eax
8010296e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010296f:	89 ca                	mov    %ecx,%edx
80102971:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102972:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102975:	89 fa                	mov    %edi,%edx
80102977:	89 45 cc             	mov    %eax,-0x34(%ebp)
8010297a:	b8 0a 00 00 00       	mov    $0xa,%eax
8010297f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102980:	89 ca                	mov    %ecx,%edx
80102982:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102983:	84 c0                	test   %al,%al
80102985:	78 89                	js     80102910 <cmostime+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102987:	89 d8                	mov    %ebx,%eax
80102989:	89 fa                	mov    %edi,%edx
8010298b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010298c:	89 ca                	mov    %ecx,%edx
8010298e:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
8010298f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102992:	89 fa                	mov    %edi,%edx
80102994:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102997:	b8 02 00 00 00       	mov    $0x2,%eax
8010299c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010299d:	89 ca                	mov    %ecx,%edx
8010299f:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
801029a0:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029a3:	89 fa                	mov    %edi,%edx
801029a5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801029a8:	b8 04 00 00 00       	mov    $0x4,%eax
801029ad:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029ae:	89 ca                	mov    %ecx,%edx
801029b0:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
801029b1:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029b4:	89 fa                	mov    %edi,%edx
801029b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
801029b9:	b8 07 00 00 00       	mov    $0x7,%eax
801029be:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029bf:	89 ca                	mov    %ecx,%edx
801029c1:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
801029c2:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029c5:	89 fa                	mov    %edi,%edx
801029c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
801029ca:	b8 08 00 00 00       	mov    $0x8,%eax
801029cf:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029d0:	89 ca                	mov    %ecx,%edx
801029d2:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
801029d3:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029d6:	89 fa                	mov    %edi,%edx
801029d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801029db:	b8 09 00 00 00       	mov    $0x9,%eax
801029e0:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e1:	89 ca                	mov    %ecx,%edx
801029e3:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
801029e4:	0f b6 c0             	movzbl %al,%eax
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801029e7:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
801029ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801029ed:	8d 45 b8             	lea    -0x48(%ebp),%eax
801029f0:	6a 18                	push   $0x18
801029f2:	56                   	push   %esi
801029f3:	50                   	push   %eax
801029f4:	e8 67 1b 00 00       	call   80104560 <memcmp>
801029f9:	83 c4 10             	add    $0x10,%esp
801029fc:	85 c0                	test   %eax,%eax
801029fe:	0f 85 0c ff ff ff    	jne    80102910 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102a04:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102a08:	75 78                	jne    80102a82 <cmostime+0x1a2>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102a0a:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102a0d:	89 c2                	mov    %eax,%edx
80102a0f:	83 e0 0f             	and    $0xf,%eax
80102a12:	c1 ea 04             	shr    $0x4,%edx
80102a15:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a18:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a1b:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102a1e:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102a21:	89 c2                	mov    %eax,%edx
80102a23:	83 e0 0f             	and    $0xf,%eax
80102a26:	c1 ea 04             	shr    $0x4,%edx
80102a29:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a2c:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a2f:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102a32:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102a35:	89 c2                	mov    %eax,%edx
80102a37:	83 e0 0f             	and    $0xf,%eax
80102a3a:	c1 ea 04             	shr    $0x4,%edx
80102a3d:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a40:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a43:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102a46:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102a49:	89 c2                	mov    %eax,%edx
80102a4b:	83 e0 0f             	and    $0xf,%eax
80102a4e:	c1 ea 04             	shr    $0x4,%edx
80102a51:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a54:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a57:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102a5a:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a5d:	89 c2                	mov    %eax,%edx
80102a5f:	83 e0 0f             	and    $0xf,%eax
80102a62:	c1 ea 04             	shr    $0x4,%edx
80102a65:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a68:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a6b:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102a6e:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a71:	89 c2                	mov    %eax,%edx
80102a73:	83 e0 0f             	and    $0xf,%eax
80102a76:	c1 ea 04             	shr    $0x4,%edx
80102a79:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a7c:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a7f:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102a82:	8b 75 08             	mov    0x8(%ebp),%esi
80102a85:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102a88:	89 06                	mov    %eax,(%esi)
80102a8a:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102a8d:	89 46 04             	mov    %eax,0x4(%esi)
80102a90:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102a93:	89 46 08             	mov    %eax,0x8(%esi)
80102a96:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102a99:	89 46 0c             	mov    %eax,0xc(%esi)
80102a9c:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a9f:	89 46 10             	mov    %eax,0x10(%esi)
80102aa2:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102aa5:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102aa8:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102aaf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ab2:	5b                   	pop    %ebx
80102ab3:	5e                   	pop    %esi
80102ab4:	5f                   	pop    %edi
80102ab5:	5d                   	pop    %ebp
80102ab6:	c3                   	ret    
80102ab7:	66 90                	xchg   %ax,%ax
80102ab9:	66 90                	xchg   %ax,%ax
80102abb:	66 90                	xchg   %ax,%ax
80102abd:	66 90                	xchg   %ax,%ax
80102abf:	90                   	nop

80102ac0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ac0:	8b 0d 08 a7 14 80    	mov    0x8014a708,%ecx
80102ac6:	85 c9                	test   %ecx,%ecx
80102ac8:	0f 8e 85 00 00 00    	jle    80102b53 <install_trans+0x93>
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102ace:	55                   	push   %ebp
80102acf:	89 e5                	mov    %esp,%ebp
80102ad1:	57                   	push   %edi
80102ad2:	56                   	push   %esi
80102ad3:	53                   	push   %ebx
80102ad4:	31 db                	xor    %ebx,%ebx
80102ad6:	83 ec 0c             	sub    $0xc,%esp
80102ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102ae0:	a1 f4 a6 14 80       	mov    0x8014a6f4,%eax
80102ae5:	83 ec 08             	sub    $0x8,%esp
80102ae8:	01 d8                	add    %ebx,%eax
80102aea:	83 c0 01             	add    $0x1,%eax
80102aed:	50                   	push   %eax
80102aee:	ff 35 04 a7 14 80    	pushl  0x8014a704
80102af4:	e8 d7 d5 ff ff       	call   801000d0 <bread>
80102af9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102afb:	58                   	pop    %eax
80102afc:	5a                   	pop    %edx
80102afd:	ff 34 9d 0c a7 14 80 	pushl  -0x7feb58f4(,%ebx,4)
80102b04:	ff 35 04 a7 14 80    	pushl  0x8014a704
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102b0a:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b0d:	e8 be d5 ff ff       	call   801000d0 <bread>
80102b12:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102b14:	8d 47 5c             	lea    0x5c(%edi),%eax
80102b17:	83 c4 0c             	add    $0xc,%esp
80102b1a:	68 00 02 00 00       	push   $0x200
80102b1f:	50                   	push   %eax
80102b20:	8d 46 5c             	lea    0x5c(%esi),%eax
80102b23:	50                   	push   %eax
80102b24:	e8 97 1a 00 00       	call   801045c0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102b29:	89 34 24             	mov    %esi,(%esp)
80102b2c:	e8 6f d6 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102b31:	89 3c 24             	mov    %edi,(%esp)
80102b34:	e8 a7 d6 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102b39:	89 34 24             	mov    %esi,(%esp)
80102b3c:	e8 9f d6 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102b41:	83 c4 10             	add    $0x10,%esp
80102b44:	39 1d 08 a7 14 80    	cmp    %ebx,0x8014a708
80102b4a:	7f 94                	jg     80102ae0 <install_trans+0x20>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102b4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b4f:	5b                   	pop    %ebx
80102b50:	5e                   	pop    %esi
80102b51:	5f                   	pop    %edi
80102b52:	5d                   	pop    %ebp
80102b53:	f3 c3                	repz ret 
80102b55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b60 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102b60:	55                   	push   %ebp
80102b61:	89 e5                	mov    %esp,%ebp
80102b63:	53                   	push   %ebx
80102b64:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102b67:	ff 35 f4 a6 14 80    	pushl  0x8014a6f4
80102b6d:	ff 35 04 a7 14 80    	pushl  0x8014a704
80102b73:	e8 58 d5 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102b78:	8b 0d 08 a7 14 80    	mov    0x8014a708,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102b7e:	83 c4 10             	add    $0x10,%esp
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b81:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102b83:	85 c9                	test   %ecx,%ecx
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102b85:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102b88:	7e 1f                	jle    80102ba9 <write_head+0x49>
80102b8a:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80102b91:	31 d2                	xor    %edx,%edx
80102b93:	90                   	nop
80102b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102b98:	8b 8a 0c a7 14 80    	mov    -0x7feb58f4(%edx),%ecx
80102b9e:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
80102ba2:	83 c2 04             	add    $0x4,%edx
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102ba5:	39 c2                	cmp    %eax,%edx
80102ba7:	75 ef                	jne    80102b98 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102ba9:	83 ec 0c             	sub    $0xc,%esp
80102bac:	53                   	push   %ebx
80102bad:	e8 ee d5 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102bb2:	89 1c 24             	mov    %ebx,(%esp)
80102bb5:	e8 26 d6 ff ff       	call   801001e0 <brelse>
}
80102bba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bbd:	c9                   	leave  
80102bbe:	c3                   	ret    
80102bbf:	90                   	nop

80102bc0 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102bc0:	55                   	push   %ebp
80102bc1:	89 e5                	mov    %esp,%ebp
80102bc3:	53                   	push   %ebx
80102bc4:	83 ec 2c             	sub    $0x2c,%esp
80102bc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102bca:	68 3c 74 10 80       	push   $0x8010743c
80102bcf:	68 c0 a6 14 80       	push   $0x8014a6c0
80102bd4:	e8 e7 16 00 00       	call   801042c0 <initlock>
  readsb(dev, &sb);
80102bd9:	58                   	pop    %eax
80102bda:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102bdd:	5a                   	pop    %edx
80102bde:	50                   	push   %eax
80102bdf:	53                   	push   %ebx
80102be0:	e8 ab e7 ff ff       	call   80101390 <readsb>
  log.start = sb.logstart;
  log.size = sb.nlog;
80102be5:	8b 55 e8             	mov    -0x18(%ebp),%edx
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102be8:	8b 45 ec             	mov    -0x14(%ebp),%eax

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102beb:	59                   	pop    %ecx
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102bec:	89 1d 04 a7 14 80    	mov    %ebx,0x8014a704

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102bf2:	89 15 f8 a6 14 80    	mov    %edx,0x8014a6f8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102bf8:	a3 f4 a6 14 80       	mov    %eax,0x8014a6f4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102bfd:	5a                   	pop    %edx
80102bfe:	50                   	push   %eax
80102bff:	53                   	push   %ebx
80102c00:	e8 cb d4 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102c05:	8b 48 5c             	mov    0x5c(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102c08:	83 c4 10             	add    $0x10,%esp
80102c0b:	85 c9                	test   %ecx,%ecx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102c0d:	89 0d 08 a7 14 80    	mov    %ecx,0x8014a708
  for (i = 0; i < log.lh.n; i++) {
80102c13:	7e 1c                	jle    80102c31 <initlog+0x71>
80102c15:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102c1c:	31 d2                	xor    %edx,%edx
80102c1e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102c20:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102c24:	83 c2 04             	add    $0x4,%edx
80102c27:	89 8a 08 a7 14 80    	mov    %ecx,-0x7feb58f8(%edx)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102c2d:	39 da                	cmp    %ebx,%edx
80102c2f:	75 ef                	jne    80102c20 <initlog+0x60>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102c31:	83 ec 0c             	sub    $0xc,%esp
80102c34:	50                   	push   %eax
80102c35:	e8 a6 d5 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102c3a:	e8 81 fe ff ff       	call   80102ac0 <install_trans>
  log.lh.n = 0;
80102c3f:	c7 05 08 a7 14 80 00 	movl   $0x0,0x8014a708
80102c46:	00 00 00 
  write_head(); // clear the log
80102c49:	e8 12 ff ff ff       	call   80102b60 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102c4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c51:	c9                   	leave  
80102c52:	c3                   	ret    
80102c53:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c60 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102c60:	55                   	push   %ebp
80102c61:	89 e5                	mov    %esp,%ebp
80102c63:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102c66:	68 c0 a6 14 80       	push   $0x8014a6c0
80102c6b:	e8 70 16 00 00       	call   801042e0 <acquire>
80102c70:	83 c4 10             	add    $0x10,%esp
80102c73:	eb 18                	jmp    80102c8d <begin_op+0x2d>
80102c75:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102c78:	83 ec 08             	sub    $0x8,%esp
80102c7b:	68 c0 a6 14 80       	push   $0x8014a6c0
80102c80:	68 c0 a6 14 80       	push   $0x8014a6c0
80102c85:	e8 d6 11 00 00       	call   80103e60 <sleep>
80102c8a:	83 c4 10             	add    $0x10,%esp
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102c8d:	a1 00 a7 14 80       	mov    0x8014a700,%eax
80102c92:	85 c0                	test   %eax,%eax
80102c94:	75 e2                	jne    80102c78 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102c96:	a1 fc a6 14 80       	mov    0x8014a6fc,%eax
80102c9b:	8b 15 08 a7 14 80    	mov    0x8014a708,%edx
80102ca1:	83 c0 01             	add    $0x1,%eax
80102ca4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102ca7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102caa:	83 fa 1e             	cmp    $0x1e,%edx
80102cad:	7f c9                	jg     80102c78 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102caf:	83 ec 0c             	sub    $0xc,%esp
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102cb2:	a3 fc a6 14 80       	mov    %eax,0x8014a6fc
      release(&log.lock);
80102cb7:	68 c0 a6 14 80       	push   $0x8014a6c0
80102cbc:	e8 ff 17 00 00       	call   801044c0 <release>
      break;
    }
  }
}
80102cc1:	83 c4 10             	add    $0x10,%esp
80102cc4:	c9                   	leave  
80102cc5:	c3                   	ret    
80102cc6:	8d 76 00             	lea    0x0(%esi),%esi
80102cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102cd0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102cd0:	55                   	push   %ebp
80102cd1:	89 e5                	mov    %esp,%ebp
80102cd3:	57                   	push   %edi
80102cd4:	56                   	push   %esi
80102cd5:	53                   	push   %ebx
80102cd6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102cd9:	68 c0 a6 14 80       	push   $0x8014a6c0
80102cde:	e8 fd 15 00 00       	call   801042e0 <acquire>
  log.outstanding -= 1;
80102ce3:	a1 fc a6 14 80       	mov    0x8014a6fc,%eax
  if(log.committing)
80102ce8:	8b 1d 00 a7 14 80    	mov    0x8014a700,%ebx
80102cee:	83 c4 10             	add    $0x10,%esp
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102cf1:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102cf4:	85 db                	test   %ebx,%ebx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102cf6:	a3 fc a6 14 80       	mov    %eax,0x8014a6fc
  if(log.committing)
80102cfb:	0f 85 23 01 00 00    	jne    80102e24 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102d01:	85 c0                	test   %eax,%eax
80102d03:	0f 85 f7 00 00 00    	jne    80102e00 <end_op+0x130>
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
  }
  release(&log.lock);
80102d09:	83 ec 0c             	sub    $0xc,%esp
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102d0c:	c7 05 00 a7 14 80 01 	movl   $0x1,0x8014a700
80102d13:	00 00 00 
}

static void
commit()
{
  if (log.lh.n > 0) {
80102d16:	31 db                	xor    %ebx,%ebx
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
  }
  release(&log.lock);
80102d18:	68 c0 a6 14 80       	push   $0x8014a6c0
80102d1d:	e8 9e 17 00 00       	call   801044c0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102d22:	8b 0d 08 a7 14 80    	mov    0x8014a708,%ecx
80102d28:	83 c4 10             	add    $0x10,%esp
80102d2b:	85 c9                	test   %ecx,%ecx
80102d2d:	0f 8e 8a 00 00 00    	jle    80102dbd <end_op+0xed>
80102d33:	90                   	nop
80102d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102d38:	a1 f4 a6 14 80       	mov    0x8014a6f4,%eax
80102d3d:	83 ec 08             	sub    $0x8,%esp
80102d40:	01 d8                	add    %ebx,%eax
80102d42:	83 c0 01             	add    $0x1,%eax
80102d45:	50                   	push   %eax
80102d46:	ff 35 04 a7 14 80    	pushl  0x8014a704
80102d4c:	e8 7f d3 ff ff       	call   801000d0 <bread>
80102d51:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102d53:	58                   	pop    %eax
80102d54:	5a                   	pop    %edx
80102d55:	ff 34 9d 0c a7 14 80 	pushl  -0x7feb58f4(,%ebx,4)
80102d5c:	ff 35 04 a7 14 80    	pushl  0x8014a704
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d62:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102d65:	e8 66 d3 ff ff       	call   801000d0 <bread>
80102d6a:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102d6c:	8d 40 5c             	lea    0x5c(%eax),%eax
80102d6f:	83 c4 0c             	add    $0xc,%esp
80102d72:	68 00 02 00 00       	push   $0x200
80102d77:	50                   	push   %eax
80102d78:	8d 46 5c             	lea    0x5c(%esi),%eax
80102d7b:	50                   	push   %eax
80102d7c:	e8 3f 18 00 00       	call   801045c0 <memmove>
    bwrite(to);  // write the log
80102d81:	89 34 24             	mov    %esi,(%esp)
80102d84:	e8 17 d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102d89:	89 3c 24             	mov    %edi,(%esp)
80102d8c:	e8 4f d4 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102d91:	89 34 24             	mov    %esi,(%esp)
80102d94:	e8 47 d4 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d99:	83 c4 10             	add    $0x10,%esp
80102d9c:	3b 1d 08 a7 14 80    	cmp    0x8014a708,%ebx
80102da2:	7c 94                	jl     80102d38 <end_op+0x68>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102da4:	e8 b7 fd ff ff       	call   80102b60 <write_head>
    install_trans(); // Now install writes to home locations
80102da9:	e8 12 fd ff ff       	call   80102ac0 <install_trans>
    log.lh.n = 0;
80102dae:	c7 05 08 a7 14 80 00 	movl   $0x0,0x8014a708
80102db5:	00 00 00 
    write_head();    // Erase the transaction from the log
80102db8:	e8 a3 fd ff ff       	call   80102b60 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102dbd:	83 ec 0c             	sub    $0xc,%esp
80102dc0:	68 c0 a6 14 80       	push   $0x8014a6c0
80102dc5:	e8 16 15 00 00       	call   801042e0 <acquire>
    log.committing = 0;
    wakeup(&log);
80102dca:	c7 04 24 c0 a6 14 80 	movl   $0x8014a6c0,(%esp)
  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
80102dd1:	c7 05 00 a7 14 80 00 	movl   $0x0,0x8014a700
80102dd8:	00 00 00 
    wakeup(&log);
80102ddb:	e8 20 12 00 00       	call   80104000 <wakeup>
    release(&log.lock);
80102de0:	c7 04 24 c0 a6 14 80 	movl   $0x8014a6c0,(%esp)
80102de7:	e8 d4 16 00 00       	call   801044c0 <release>
80102dec:	83 c4 10             	add    $0x10,%esp
  }
}
80102def:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102df2:	5b                   	pop    %ebx
80102df3:	5e                   	pop    %esi
80102df4:	5f                   	pop    %edi
80102df5:	5d                   	pop    %ebp
80102df6:	c3                   	ret    
80102df7:	89 f6                	mov    %esi,%esi
80102df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
80102e00:	83 ec 0c             	sub    $0xc,%esp
80102e03:	68 c0 a6 14 80       	push   $0x8014a6c0
80102e08:	e8 f3 11 00 00       	call   80104000 <wakeup>
  }
  release(&log.lock);
80102e0d:	c7 04 24 c0 a6 14 80 	movl   $0x8014a6c0,(%esp)
80102e14:	e8 a7 16 00 00       	call   801044c0 <release>
80102e19:	83 c4 10             	add    $0x10,%esp
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}
80102e1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e1f:	5b                   	pop    %ebx
80102e20:	5e                   	pop    %esi
80102e21:	5f                   	pop    %edi
80102e22:	5d                   	pop    %ebp
80102e23:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102e24:	83 ec 0c             	sub    $0xc,%esp
80102e27:	68 40 74 10 80       	push   $0x80107440
80102e2c:	e8 3f d5 ff ff       	call   80100370 <panic>
80102e31:	eb 0d                	jmp    80102e40 <log_write>
80102e33:	90                   	nop
80102e34:	90                   	nop
80102e35:	90                   	nop
80102e36:	90                   	nop
80102e37:	90                   	nop
80102e38:	90                   	nop
80102e39:	90                   	nop
80102e3a:	90                   	nop
80102e3b:	90                   	nop
80102e3c:	90                   	nop
80102e3d:	90                   	nop
80102e3e:	90                   	nop
80102e3f:	90                   	nop

80102e40 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	53                   	push   %ebx
80102e44:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102e47:	8b 15 08 a7 14 80    	mov    0x8014a708,%edx
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102e4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102e50:	83 fa 1d             	cmp    $0x1d,%edx
80102e53:	0f 8f 97 00 00 00    	jg     80102ef0 <log_write+0xb0>
80102e59:	a1 f8 a6 14 80       	mov    0x8014a6f8,%eax
80102e5e:	83 e8 01             	sub    $0x1,%eax
80102e61:	39 c2                	cmp    %eax,%edx
80102e63:	0f 8d 87 00 00 00    	jge    80102ef0 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102e69:	a1 fc a6 14 80       	mov    0x8014a6fc,%eax
80102e6e:	85 c0                	test   %eax,%eax
80102e70:	0f 8e 87 00 00 00    	jle    80102efd <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102e76:	83 ec 0c             	sub    $0xc,%esp
80102e79:	68 c0 a6 14 80       	push   $0x8014a6c0
80102e7e:	e8 5d 14 00 00       	call   801042e0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102e83:	8b 15 08 a7 14 80    	mov    0x8014a708,%edx
80102e89:	83 c4 10             	add    $0x10,%esp
80102e8c:	83 fa 00             	cmp    $0x0,%edx
80102e8f:	7e 50                	jle    80102ee1 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102e91:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102e94:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102e96:	3b 0d 0c a7 14 80    	cmp    0x8014a70c,%ecx
80102e9c:	75 0b                	jne    80102ea9 <log_write+0x69>
80102e9e:	eb 38                	jmp    80102ed8 <log_write+0x98>
80102ea0:	39 0c 85 0c a7 14 80 	cmp    %ecx,-0x7feb58f4(,%eax,4)
80102ea7:	74 2f                	je     80102ed8 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102ea9:	83 c0 01             	add    $0x1,%eax
80102eac:	39 d0                	cmp    %edx,%eax
80102eae:	75 f0                	jne    80102ea0 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102eb0:	89 0c 95 0c a7 14 80 	mov    %ecx,-0x7feb58f4(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102eb7:	83 c2 01             	add    $0x1,%edx
80102eba:	89 15 08 a7 14 80    	mov    %edx,0x8014a708
  b->flags |= B_DIRTY; // prevent eviction
80102ec0:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102ec3:	c7 45 08 c0 a6 14 80 	movl   $0x8014a6c0,0x8(%ebp)
}
80102eca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ecd:	c9                   	leave  
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102ece:	e9 ed 15 00 00       	jmp    801044c0 <release>
80102ed3:	90                   	nop
80102ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102ed8:	89 0c 85 0c a7 14 80 	mov    %ecx,-0x7feb58f4(,%eax,4)
80102edf:	eb df                	jmp    80102ec0 <log_write+0x80>
80102ee1:	8b 43 08             	mov    0x8(%ebx),%eax
80102ee4:	a3 0c a7 14 80       	mov    %eax,0x8014a70c
  if (i == log.lh.n)
80102ee9:	75 d5                	jne    80102ec0 <log_write+0x80>
80102eeb:	eb ca                	jmp    80102eb7 <log_write+0x77>
80102eed:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102ef0:	83 ec 0c             	sub    $0xc,%esp
80102ef3:	68 4f 74 10 80       	push   $0x8010744f
80102ef8:	e8 73 d4 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102efd:	83 ec 0c             	sub    $0xc,%esp
80102f00:	68 65 74 10 80       	push   $0x80107465
80102f05:	e8 66 d4 ff ff       	call   80100370 <panic>
80102f0a:	66 90                	xchg   %ax,%ax
80102f0c:	66 90                	xchg   %ax,%ax
80102f0e:	66 90                	xchg   %ax,%ax

80102f10 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102f10:	55                   	push   %ebp
80102f11:	89 e5                	mov    %esp,%ebp
80102f13:	83 ec 08             	sub    $0x8,%esp
  idtinit();       // load idt register
80102f16:	e8 15 29 00 00       	call   80105830 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80102f1b:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102f22:	b8 01 00 00 00       	mov    $0x1,%eax
80102f27:	f0 87 82 a8 00 00 00 	lock xchg %eax,0xa8(%edx)
  scheduler();     // start running processes
80102f2e:	e8 4d 0c 00 00       	call   80103b80 <scheduler>
80102f33:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f40 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102f40:	55                   	push   %ebp
80102f41:	89 e5                	mov    %esp,%ebp
80102f43:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102f46:	e8 95 3a 00 00       	call   801069e0 <switchkvm>
  seginit();
80102f4b:	e8 b0 38 00 00       	call   80106800 <seginit>
  lapicinit();
80102f50:	e8 2b f7 ff ff       	call   80102680 <lapicinit>
  mpmain();
80102f55:	e8 b6 ff ff ff       	call   80102f10 <mpmain>
80102f5a:	66 90                	xchg   %ax,%ax
80102f5c:	66 90                	xchg   %ax,%ax
80102f5e:	66 90                	xchg   %ax,%ax

80102f60 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102f60:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102f64:	83 e4 f0             	and    $0xfffffff0,%esp
80102f67:	ff 71 fc             	pushl  -0x4(%ecx)
80102f6a:	55                   	push   %ebp
80102f6b:	89 e5                	mov    %esp,%ebp
80102f6d:	53                   	push   %ebx
80102f6e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102f6f:	83 ec 08             	sub    $0x8,%esp
80102f72:	68 00 00 40 80       	push   $0x80400000
80102f77:	68 48 d5 14 80       	push   $0x8014d548
80102f7c:	e8 6f f4 ff ff       	call   801023f0 <kinit1>
  kvmalloc();      // kernel page table
80102f81:	e8 3a 3a 00 00       	call   801069c0 <kvmalloc>
  mpinit();        // detect other processors
80102f86:	e8 a5 01 00 00       	call   80103130 <mpinit>
  lapicinit();     // interrupt controller
80102f8b:	e8 f0 f6 ff ff       	call   80102680 <lapicinit>
  seginit();       // segment descriptors
80102f90:	e8 6b 38 00 00       	call   80106800 <seginit>
  picinit();       // another interrupt controller
80102f95:	e8 a6 03 00 00       	call   80103340 <picinit>
  ioapicinit();    // another interrupt controller
80102f9a:	e8 f1 f1 ff ff       	call   80102190 <ioapicinit>
  consoleinit();   // console hardware
80102f9f:	e8 fc d9 ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
80102fa4:	e8 37 2b 00 00       	call   80105ae0 <uartinit>
  pinit();         // process table
80102fa9:	e8 32 09 00 00       	call   801038e0 <pinit>
  tvinit();        // trap vectors
80102fae:	e8 dd 27 00 00       	call   80105790 <tvinit>
  binit();         // buffer cache
80102fb3:	e8 88 d0 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102fb8:	e8 73 dd ff ff       	call   80100d30 <fileinit>
  ideinit();       // disk
80102fbd:	e8 9e ef ff ff       	call   80101f60 <ideinit>
  if(!ismp)
80102fc2:	a1 a4 a7 14 80       	mov    0x8014a7a4,%eax
80102fc7:	83 c4 10             	add    $0x10,%esp
80102fca:	85 c0                	test   %eax,%eax
80102fcc:	0f 84 c5 00 00 00    	je     80103097 <main+0x137>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102fd2:	83 ec 04             	sub    $0x4,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80102fd5:	bb c0 a7 14 80       	mov    $0x8014a7c0,%ebx

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102fda:	68 8a 00 00 00       	push   $0x8a
80102fdf:	68 8c a4 10 80       	push   $0x8010a48c
80102fe4:	68 00 70 00 80       	push   $0x80007000
80102fe9:	e8 d2 15 00 00       	call   801045c0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102fee:	69 05 a0 ad 14 80 bc 	imul   $0xbc,0x8014ada0,%eax
80102ff5:	00 00 00 
80102ff8:	83 c4 10             	add    $0x10,%esp
80102ffb:	05 c0 a7 14 80       	add    $0x8014a7c0,%eax
80103000:	39 d8                	cmp    %ebx,%eax
80103002:	76 77                	jbe    8010307b <main+0x11b>
80103004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == cpus+cpunum())  // We've started already.
80103008:	e8 73 f7 ff ff       	call   80102780 <cpunum>
8010300d:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103013:	05 c0 a7 14 80       	add    $0x8014a7c0,%eax
80103018:	39 c3                	cmp    %eax,%ebx
8010301a:	74 46                	je     80103062 <main+0x102>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
8010301c:	e8 df f4 ff ff       	call   80102500 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80103021:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
80103026:	c7 05 f8 6f 00 80 40 	movl   $0x80102f40,0x80006ff8
8010302d:	2f 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103030:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80103037:	90 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
8010303a:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
8010303f:	0f b6 03             	movzbl (%ebx),%eax
80103042:	83 ec 08             	sub    $0x8,%esp
80103045:	68 00 70 00 00       	push   $0x7000
8010304a:	50                   	push   %eax
8010304b:	e8 00 f8 ff ff       	call   80102850 <lapicstartap>
80103050:	83 c4 10             	add    $0x10,%esp
80103053:	90                   	nop
80103054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103058:	8b 83 a8 00 00 00    	mov    0xa8(%ebx),%eax
8010305e:	85 c0                	test   %eax,%eax
80103060:	74 f6                	je     80103058 <main+0xf8>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103062:	69 05 a0 ad 14 80 bc 	imul   $0xbc,0x8014ada0,%eax
80103069:	00 00 00 
8010306c:	81 c3 bc 00 00 00    	add    $0xbc,%ebx
80103072:	05 c0 a7 14 80       	add    $0x8014a7c0,%eax
80103077:	39 c3                	cmp    %eax,%ebx
80103079:	72 8d                	jb     80103008 <main+0xa8>
  fileinit();      // file table
  ideinit();       // disk
  if(!ismp)
    timerinit();   // uniprocessor timer
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
8010307b:	83 ec 08             	sub    $0x8,%esp
8010307e:	68 00 00 00 8e       	push   $0x8e000000
80103083:	68 00 00 40 80       	push   $0x80400000
80103088:	e8 f3 f3 ff ff       	call   80102480 <kinit2>
  userinit();      // first user process
8010308d:	e8 6e 08 00 00       	call   80103900 <userinit>
  mpmain();        // finish this processor's setup
80103092:	e8 79 fe ff ff       	call   80102f10 <mpmain>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk
  if(!ismp)
    timerinit();   // uniprocessor timer
80103097:	e8 94 26 00 00       	call   80105730 <timerinit>
8010309c:	e9 31 ff ff ff       	jmp    80102fd2 <main+0x72>
801030a1:	66 90                	xchg   %ax,%ax
801030a3:	66 90                	xchg   %ax,%ax
801030a5:	66 90                	xchg   %ax,%ax
801030a7:	66 90                	xchg   %ax,%ax
801030a9:	66 90                	xchg   %ax,%ax
801030ab:	66 90                	xchg   %ax,%ax
801030ad:	66 90                	xchg   %ax,%ax
801030af:	90                   	nop

801030b0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801030b0:	55                   	push   %ebp
801030b1:	89 e5                	mov    %esp,%ebp
801030b3:	57                   	push   %edi
801030b4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801030b5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801030bb:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
801030bc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801030bf:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
801030c2:	39 de                	cmp    %ebx,%esi
801030c4:	73 48                	jae    8010310e <mpsearch1+0x5e>
801030c6:	8d 76 00             	lea    0x0(%esi),%esi
801030c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801030d0:	83 ec 04             	sub    $0x4,%esp
801030d3:	8d 7e 10             	lea    0x10(%esi),%edi
801030d6:	6a 04                	push   $0x4
801030d8:	68 80 74 10 80       	push   $0x80107480
801030dd:	56                   	push   %esi
801030de:	e8 7d 14 00 00       	call   80104560 <memcmp>
801030e3:	83 c4 10             	add    $0x10,%esp
801030e6:	85 c0                	test   %eax,%eax
801030e8:	75 1e                	jne    80103108 <mpsearch1+0x58>
801030ea:	8d 7e 10             	lea    0x10(%esi),%edi
801030ed:	89 f2                	mov    %esi,%edx
801030ef:	31 c9                	xor    %ecx,%ecx
801030f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
801030f8:	0f b6 02             	movzbl (%edx),%eax
801030fb:	83 c2 01             	add    $0x1,%edx
801030fe:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103100:	39 fa                	cmp    %edi,%edx
80103102:	75 f4                	jne    801030f8 <mpsearch1+0x48>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103104:	84 c9                	test   %cl,%cl
80103106:	74 10                	je     80103118 <mpsearch1+0x68>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103108:	39 fb                	cmp    %edi,%ebx
8010310a:	89 fe                	mov    %edi,%esi
8010310c:	77 c2                	ja     801030d0 <mpsearch1+0x20>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
8010310e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103111:	31 c0                	xor    %eax,%eax
}
80103113:	5b                   	pop    %ebx
80103114:	5e                   	pop    %esi
80103115:	5f                   	pop    %edi
80103116:	5d                   	pop    %ebp
80103117:	c3                   	ret    
80103118:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010311b:	89 f0                	mov    %esi,%eax
8010311d:	5b                   	pop    %ebx
8010311e:	5e                   	pop    %esi
8010311f:	5f                   	pop    %edi
80103120:	5d                   	pop    %ebp
80103121:	c3                   	ret    
80103122:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103130 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103130:	55                   	push   %ebp
80103131:	89 e5                	mov    %esp,%ebp
80103133:	57                   	push   %edi
80103134:	56                   	push   %esi
80103135:	53                   	push   %ebx
80103136:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103139:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103140:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103147:	c1 e0 08             	shl    $0x8,%eax
8010314a:	09 d0                	or     %edx,%eax
8010314c:	c1 e0 04             	shl    $0x4,%eax
8010314f:	85 c0                	test   %eax,%eax
80103151:	75 1b                	jne    8010316e <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
80103153:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010315a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103161:	c1 e0 08             	shl    $0x8,%eax
80103164:	09 d0                	or     %edx,%eax
80103166:	c1 e0 0a             	shl    $0xa,%eax
80103169:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
8010316e:	ba 00 04 00 00       	mov    $0x400,%edx
80103173:	e8 38 ff ff ff       	call   801030b0 <mpsearch1>
80103178:	85 c0                	test   %eax,%eax
8010317a:	89 c6                	mov    %eax,%esi
8010317c:	0f 84 66 01 00 00    	je     801032e8 <mpinit+0x1b8>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103182:	8b 5e 04             	mov    0x4(%esi),%ebx
80103185:	85 db                	test   %ebx,%ebx
80103187:	0f 84 d6 00 00 00    	je     80103263 <mpinit+0x133>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010318d:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103193:	83 ec 04             	sub    $0x4,%esp
80103196:	6a 04                	push   $0x4
80103198:	68 85 74 10 80       	push   $0x80107485
8010319d:	50                   	push   %eax
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010319e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801031a1:	e8 ba 13 00 00       	call   80104560 <memcmp>
801031a6:	83 c4 10             	add    $0x10,%esp
801031a9:	85 c0                	test   %eax,%eax
801031ab:	0f 85 b2 00 00 00    	jne    80103263 <mpinit+0x133>
    return 0;
  if(conf->version != 1 && conf->version != 4)
801031b1:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801031b8:	3c 01                	cmp    $0x1,%al
801031ba:	74 08                	je     801031c4 <mpinit+0x94>
801031bc:	3c 04                	cmp    $0x4,%al
801031be:	0f 85 9f 00 00 00    	jne    80103263 <mpinit+0x133>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801031c4:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801031cb:	85 ff                	test   %edi,%edi
801031cd:	74 1e                	je     801031ed <mpinit+0xbd>
801031cf:	31 d2                	xor    %edx,%edx
801031d1:	31 c0                	xor    %eax,%eax
801031d3:	90                   	nop
801031d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801031d8:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
801031df:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801031e0:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801031e3:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801031e5:	39 c7                	cmp    %eax,%edi
801031e7:	75 ef                	jne    801031d8 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801031e9:	84 d2                	test   %dl,%dl
801031eb:	75 76                	jne    80103263 <mpinit+0x133>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801031ed:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801031f0:	85 ff                	test   %edi,%edi
801031f2:	74 6f                	je     80103263 <mpinit+0x133>
    return;
  ismp = 1;
801031f4:	c7 05 a4 a7 14 80 01 	movl   $0x1,0x8014a7a4
801031fb:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
801031fe:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103204:	a3 a0 a6 14 80       	mov    %eax,0x8014a6a0
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103209:	0f b7 8b 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%ecx
80103210:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103216:	01 f9                	add    %edi,%ecx
80103218:	39 c8                	cmp    %ecx,%eax
8010321a:	0f 83 a0 00 00 00    	jae    801032c0 <mpinit+0x190>
    switch(*p){
80103220:	80 38 04             	cmpb   $0x4,(%eax)
80103223:	0f 87 87 00 00 00    	ja     801032b0 <mpinit+0x180>
80103229:	0f b6 10             	movzbl (%eax),%edx
8010322c:	ff 24 95 8c 74 10 80 	jmp    *-0x7fef8b74(,%edx,4)
80103233:	90                   	nop
80103234:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103238:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010323b:	39 c1                	cmp    %eax,%ecx
8010323d:	77 e1                	ja     80103220 <mpinit+0xf0>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp){
8010323f:	a1 a4 a7 14 80       	mov    0x8014a7a4,%eax
80103244:	85 c0                	test   %eax,%eax
80103246:	75 78                	jne    801032c0 <mpinit+0x190>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103248:	c7 05 a0 ad 14 80 01 	movl   $0x1,0x8014ada0
8010324f:	00 00 00 
    lapic = 0;
80103252:	c7 05 a0 a6 14 80 00 	movl   $0x0,0x8014a6a0
80103259:	00 00 00 
    ioapicid = 0;
8010325c:	c6 05 a0 a7 14 80 00 	movb   $0x0,0x8014a7a0
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
80103263:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103266:	5b                   	pop    %ebx
80103267:	5e                   	pop    %esi
80103268:	5f                   	pop    %edi
80103269:	5d                   	pop    %ebp
8010326a:	c3                   	ret    
8010326b:	90                   	nop
8010326c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80103270:	8b 15 a0 ad 14 80    	mov    0x8014ada0,%edx
80103276:	83 fa 07             	cmp    $0x7,%edx
80103279:	7f 19                	jg     80103294 <mpinit+0x164>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010327b:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
8010327f:	69 fa bc 00 00 00    	imul   $0xbc,%edx,%edi
        ncpu++;
80103285:	83 c2 01             	add    $0x1,%edx
80103288:	89 15 a0 ad 14 80    	mov    %edx,0x8014ada0
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010328e:	88 9f c0 a7 14 80    	mov    %bl,-0x7feb5840(%edi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
80103294:	83 c0 14             	add    $0x14,%eax
      continue;
80103297:	eb a2                	jmp    8010323b <mpinit+0x10b>
80103299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801032a0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801032a4:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801032a7:	88 15 a0 a7 14 80    	mov    %dl,0x8014a7a0
      p += sizeof(struct mpioapic);
      continue;
801032ad:	eb 8c                	jmp    8010323b <mpinit+0x10b>
801032af:	90                   	nop
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
801032b0:	c7 05 a4 a7 14 80 00 	movl   $0x0,0x8014a7a4
801032b7:	00 00 00 
      break;
801032ba:	e9 7c ff ff ff       	jmp    8010323b <mpinit+0x10b>
801032bf:	90                   	nop
    lapic = 0;
    ioapicid = 0;
    return;
  }

  if(mp->imcrp){
801032c0:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
801032c4:	74 9d                	je     80103263 <mpinit+0x133>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032c6:	ba 22 00 00 00       	mov    $0x22,%edx
801032cb:	b8 70 00 00 00       	mov    $0x70,%eax
801032d0:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032d1:	ba 23 00 00 00       	mov    $0x23,%edx
801032d6:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032d7:	83 c8 01             	or     $0x1,%eax
801032da:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
801032db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032de:	5b                   	pop    %ebx
801032df:	5e                   	pop    %esi
801032e0:	5f                   	pop    %edi
801032e1:	5d                   	pop    %ebp
801032e2:	c3                   	ret    
801032e3:	90                   	nop
801032e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
801032e8:	ba 00 00 01 00       	mov    $0x10000,%edx
801032ed:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801032f2:	e8 b9 fd ff ff       	call   801030b0 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032f7:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
801032f9:	89 c6                	mov    %eax,%esi
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032fb:	0f 85 81 fe ff ff    	jne    80103182 <mpinit+0x52>
80103301:	e9 5d ff ff ff       	jmp    80103263 <mpinit+0x133>
80103306:	66 90                	xchg   %ax,%ax
80103308:	66 90                	xchg   %ax,%ax
8010330a:	66 90                	xchg   %ax,%ax
8010330c:	66 90                	xchg   %ax,%ax
8010330e:	66 90                	xchg   %ax,%ax

80103310 <picenable>:
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
80103310:	55                   	push   %ebp
  picsetmask(irqmask & ~(1<<irq));
80103311:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80103316:	ba 21 00 00 00       	mov    $0x21,%edx
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
8010331b:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
8010331d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103320:	d3 c0                	rol    %cl,%eax
80103322:	66 23 05 00 a0 10 80 	and    0x8010a000,%ax
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
  irqmask = mask;
80103329:	66 a3 00 a0 10 80    	mov    %ax,0x8010a000
8010332f:	ee                   	out    %al,(%dx)
80103330:	ba a1 00 00 00       	mov    $0xa1,%edx
80103335:	66 c1 e8 08          	shr    $0x8,%ax
80103339:	ee                   	out    %al,(%dx)

void
picenable(int irq)
{
  picsetmask(irqmask & ~(1<<irq));
}
8010333a:	5d                   	pop    %ebp
8010333b:	c3                   	ret    
8010333c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103340 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103340:	55                   	push   %ebp
80103341:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103346:	89 e5                	mov    %esp,%ebp
80103348:	57                   	push   %edi
80103349:	56                   	push   %esi
8010334a:	53                   	push   %ebx
8010334b:	bb 21 00 00 00       	mov    $0x21,%ebx
80103350:	89 da                	mov    %ebx,%edx
80103352:	ee                   	out    %al,(%dx)
80103353:	b9 a1 00 00 00       	mov    $0xa1,%ecx
80103358:	89 ca                	mov    %ecx,%edx
8010335a:	ee                   	out    %al,(%dx)
8010335b:	bf 11 00 00 00       	mov    $0x11,%edi
80103360:	be 20 00 00 00       	mov    $0x20,%esi
80103365:	89 f8                	mov    %edi,%eax
80103367:	89 f2                	mov    %esi,%edx
80103369:	ee                   	out    %al,(%dx)
8010336a:	b8 20 00 00 00       	mov    $0x20,%eax
8010336f:	89 da                	mov    %ebx,%edx
80103371:	ee                   	out    %al,(%dx)
80103372:	b8 04 00 00 00       	mov    $0x4,%eax
80103377:	ee                   	out    %al,(%dx)
80103378:	b8 03 00 00 00       	mov    $0x3,%eax
8010337d:	ee                   	out    %al,(%dx)
8010337e:	bb a0 00 00 00       	mov    $0xa0,%ebx
80103383:	89 f8                	mov    %edi,%eax
80103385:	89 da                	mov    %ebx,%edx
80103387:	ee                   	out    %al,(%dx)
80103388:	b8 28 00 00 00       	mov    $0x28,%eax
8010338d:	89 ca                	mov    %ecx,%edx
8010338f:	ee                   	out    %al,(%dx)
80103390:	b8 02 00 00 00       	mov    $0x2,%eax
80103395:	ee                   	out    %al,(%dx)
80103396:	b8 03 00 00 00       	mov    $0x3,%eax
8010339b:	ee                   	out    %al,(%dx)
8010339c:	bf 68 00 00 00       	mov    $0x68,%edi
801033a1:	89 f2                	mov    %esi,%edx
801033a3:	89 f8                	mov    %edi,%eax
801033a5:	ee                   	out    %al,(%dx)
801033a6:	b9 0a 00 00 00       	mov    $0xa,%ecx
801033ab:	89 c8                	mov    %ecx,%eax
801033ad:	ee                   	out    %al,(%dx)
801033ae:	89 f8                	mov    %edi,%eax
801033b0:	89 da                	mov    %ebx,%edx
801033b2:	ee                   	out    %al,(%dx)
801033b3:	89 c8                	mov    %ecx,%eax
801033b5:	ee                   	out    %al,(%dx)
  outb(IO_PIC1, 0x0a);             // read IRR by default

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
801033b6:	0f b7 05 00 a0 10 80 	movzwl 0x8010a000,%eax
801033bd:	66 83 f8 ff          	cmp    $0xffff,%ax
801033c1:	74 10                	je     801033d3 <picinit+0x93>
801033c3:	ba 21 00 00 00       	mov    $0x21,%edx
801033c8:	ee                   	out    %al,(%dx)
801033c9:	ba a1 00 00 00       	mov    $0xa1,%edx
801033ce:	66 c1 e8 08          	shr    $0x8,%ax
801033d2:	ee                   	out    %al,(%dx)
    picsetmask(irqmask);
}
801033d3:	5b                   	pop    %ebx
801033d4:	5e                   	pop    %esi
801033d5:	5f                   	pop    %edi
801033d6:	5d                   	pop    %ebp
801033d7:	c3                   	ret    
801033d8:	66 90                	xchg   %ax,%ax
801033da:	66 90                	xchg   %ax,%ax
801033dc:	66 90                	xchg   %ax,%ax
801033de:	66 90                	xchg   %ax,%ax

801033e0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801033e0:	55                   	push   %ebp
801033e1:	89 e5                	mov    %esp,%ebp
801033e3:	57                   	push   %edi
801033e4:	56                   	push   %esi
801033e5:	53                   	push   %ebx
801033e6:	83 ec 0c             	sub    $0xc,%esp
801033e9:	8b 75 08             	mov    0x8(%ebp),%esi
801033ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801033ef:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801033f5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801033fb:	e8 50 d9 ff ff       	call   80100d50 <filealloc>
80103400:	85 c0                	test   %eax,%eax
80103402:	89 06                	mov    %eax,(%esi)
80103404:	0f 84 a8 00 00 00    	je     801034b2 <pipealloc+0xd2>
8010340a:	e8 41 d9 ff ff       	call   80100d50 <filealloc>
8010340f:	85 c0                	test   %eax,%eax
80103411:	89 03                	mov    %eax,(%ebx)
80103413:	0f 84 87 00 00 00    	je     801034a0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103419:	e8 e2 f0 ff ff       	call   80102500 <kalloc>
8010341e:	85 c0                	test   %eax,%eax
80103420:	89 c7                	mov    %eax,%edi
80103422:	0f 84 b0 00 00 00    	je     801034d8 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103428:	83 ec 08             	sub    $0x8,%esp
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
  p->readopen = 1;
8010342b:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103432:	00 00 00 
  p->writeopen = 1;
80103435:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010343c:	00 00 00 
  p->nwrite = 0;
8010343f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103446:	00 00 00 
  p->nread = 0;
80103449:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103450:	00 00 00 
  initlock(&p->lock, "pipe");
80103453:	68 a0 74 10 80       	push   $0x801074a0
80103458:	50                   	push   %eax
80103459:	e8 62 0e 00 00       	call   801042c0 <initlock>
  (*f0)->type = FD_PIPE;
8010345e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103460:	83 c4 10             	add    $0x10,%esp
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
80103463:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103469:	8b 06                	mov    (%esi),%eax
8010346b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010346f:	8b 06                	mov    (%esi),%eax
80103471:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103475:	8b 06                	mov    (%esi),%eax
80103477:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010347a:	8b 03                	mov    (%ebx),%eax
8010347c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103482:	8b 03                	mov    (%ebx),%eax
80103484:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103488:	8b 03                	mov    (%ebx),%eax
8010348a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010348e:	8b 03                	mov    (%ebx),%eax
80103490:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103493:	8d 65 f4             	lea    -0xc(%ebp),%esp
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103496:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103498:	5b                   	pop    %ebx
80103499:	5e                   	pop    %esi
8010349a:	5f                   	pop    %edi
8010349b:	5d                   	pop    %ebp
8010349c:	c3                   	ret    
8010349d:	8d 76 00             	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801034a0:	8b 06                	mov    (%esi),%eax
801034a2:	85 c0                	test   %eax,%eax
801034a4:	74 1e                	je     801034c4 <pipealloc+0xe4>
    fileclose(*f0);
801034a6:	83 ec 0c             	sub    $0xc,%esp
801034a9:	50                   	push   %eax
801034aa:	e8 61 d9 ff ff       	call   80100e10 <fileclose>
801034af:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801034b2:	8b 03                	mov    (%ebx),%eax
801034b4:	85 c0                	test   %eax,%eax
801034b6:	74 0c                	je     801034c4 <pipealloc+0xe4>
    fileclose(*f1);
801034b8:	83 ec 0c             	sub    $0xc,%esp
801034bb:	50                   	push   %eax
801034bc:	e8 4f d9 ff ff       	call   80100e10 <fileclose>
801034c1:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801034c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
801034c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801034cc:	5b                   	pop    %ebx
801034cd:	5e                   	pop    %esi
801034ce:	5f                   	pop    %edi
801034cf:	5d                   	pop    %ebp
801034d0:	c3                   	ret    
801034d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801034d8:	8b 06                	mov    (%esi),%eax
801034da:	85 c0                	test   %eax,%eax
801034dc:	75 c8                	jne    801034a6 <pipealloc+0xc6>
801034de:	eb d2                	jmp    801034b2 <pipealloc+0xd2>

801034e0 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
801034e0:	55                   	push   %ebp
801034e1:	89 e5                	mov    %esp,%ebp
801034e3:	56                   	push   %esi
801034e4:	53                   	push   %ebx
801034e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801034e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801034eb:	83 ec 0c             	sub    $0xc,%esp
801034ee:	53                   	push   %ebx
801034ef:	e8 ec 0d 00 00       	call   801042e0 <acquire>
  if(writable){
801034f4:	83 c4 10             	add    $0x10,%esp
801034f7:	85 f6                	test   %esi,%esi
801034f9:	74 45                	je     80103540 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801034fb:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103501:	83 ec 0c             	sub    $0xc,%esp
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
80103504:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010350b:	00 00 00 
    wakeup(&p->nread);
8010350e:	50                   	push   %eax
8010350f:	e8 ec 0a 00 00       	call   80104000 <wakeup>
80103514:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103517:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010351d:	85 d2                	test   %edx,%edx
8010351f:	75 0a                	jne    8010352b <pipeclose+0x4b>
80103521:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103527:	85 c0                	test   %eax,%eax
80103529:	74 35                	je     80103560 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010352b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010352e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103531:	5b                   	pop    %ebx
80103532:	5e                   	pop    %esi
80103533:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103534:	e9 87 0f 00 00       	jmp    801044c0 <release>
80103539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
80103540:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103546:	83 ec 0c             	sub    $0xc,%esp
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
80103549:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103550:	00 00 00 
    wakeup(&p->nwrite);
80103553:	50                   	push   %eax
80103554:	e8 a7 0a 00 00       	call   80104000 <wakeup>
80103559:	83 c4 10             	add    $0x10,%esp
8010355c:	eb b9                	jmp    80103517 <pipeclose+0x37>
8010355e:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103560:	83 ec 0c             	sub    $0xc,%esp
80103563:	53                   	push   %ebx
80103564:	e8 57 0f 00 00       	call   801044c0 <release>
    kfree((char*)p);
80103569:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010356c:	83 c4 10             	add    $0x10,%esp
  } else
    release(&p->lock);
}
8010356f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103572:	5b                   	pop    %ebx
80103573:	5e                   	pop    %esi
80103574:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103575:	e9 16 ed ff ff       	jmp    80102290 <kfree>
8010357a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103580 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103580:	55                   	push   %ebp
80103581:	89 e5                	mov    %esp,%ebp
80103583:	57                   	push   %edi
80103584:	56                   	push   %esi
80103585:	53                   	push   %ebx
80103586:	83 ec 28             	sub    $0x28,%esp
80103589:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;

  acquire(&p->lock);
8010358c:	57                   	push   %edi
8010358d:	e8 4e 0d 00 00       	call   801042e0 <acquire>
  for(i = 0; i < n; i++){
80103592:	8b 45 10             	mov    0x10(%ebp),%eax
80103595:	83 c4 10             	add    $0x10,%esp
80103598:	85 c0                	test   %eax,%eax
8010359a:	0f 8e c6 00 00 00    	jle    80103666 <pipewrite+0xe6>
801035a0:	8b 45 0c             	mov    0xc(%ebp),%eax
801035a3:	8b 8f 38 02 00 00    	mov    0x238(%edi),%ecx
801035a9:	8d b7 34 02 00 00    	lea    0x234(%edi),%esi
801035af:	8d 9f 38 02 00 00    	lea    0x238(%edi),%ebx
801035b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801035b8:	03 45 10             	add    0x10(%ebp),%eax
801035bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035be:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
801035c4:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
801035ca:	39 d1                	cmp    %edx,%ecx
801035cc:	0f 85 cf 00 00 00    	jne    801036a1 <pipewrite+0x121>
      if(p->readopen == 0 || proc->killed){
801035d2:	8b 97 3c 02 00 00    	mov    0x23c(%edi),%edx
801035d8:	85 d2                	test   %edx,%edx
801035da:	0f 84 a8 00 00 00    	je     80103688 <pipewrite+0x108>
801035e0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801035e7:	8b 42 24             	mov    0x24(%edx),%eax
801035ea:	85 c0                	test   %eax,%eax
801035ec:	74 25                	je     80103613 <pipewrite+0x93>
801035ee:	e9 95 00 00 00       	jmp    80103688 <pipewrite+0x108>
801035f3:	90                   	nop
801035f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035f8:	8b 87 3c 02 00 00    	mov    0x23c(%edi),%eax
801035fe:	85 c0                	test   %eax,%eax
80103600:	0f 84 82 00 00 00    	je     80103688 <pipewrite+0x108>
80103606:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010360c:	8b 40 24             	mov    0x24(%eax),%eax
8010360f:	85 c0                	test   %eax,%eax
80103611:	75 75                	jne    80103688 <pipewrite+0x108>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103613:	83 ec 0c             	sub    $0xc,%esp
80103616:	56                   	push   %esi
80103617:	e8 e4 09 00 00       	call   80104000 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010361c:	59                   	pop    %ecx
8010361d:	58                   	pop    %eax
8010361e:	57                   	push   %edi
8010361f:	53                   	push   %ebx
80103620:	e8 3b 08 00 00       	call   80103e60 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103625:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
8010362b:	8b 97 38 02 00 00    	mov    0x238(%edi),%edx
80103631:	83 c4 10             	add    $0x10,%esp
80103634:	05 00 02 00 00       	add    $0x200,%eax
80103639:	39 c2                	cmp    %eax,%edx
8010363b:	74 bb                	je     801035f8 <pipewrite+0x78>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010363d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103640:	8d 4a 01             	lea    0x1(%edx),%ecx
80103643:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80103647:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010364d:	89 8f 38 02 00 00    	mov    %ecx,0x238(%edi)
80103653:	0f b6 00             	movzbl (%eax),%eax
80103656:	88 44 17 34          	mov    %al,0x34(%edi,%edx,1)
8010365a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
8010365d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
80103660:	0f 85 58 ff ff ff    	jne    801035be <pipewrite+0x3e>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103666:	8d 97 34 02 00 00    	lea    0x234(%edi),%edx
8010366c:	83 ec 0c             	sub    $0xc,%esp
8010366f:	52                   	push   %edx
80103670:	e8 8b 09 00 00       	call   80104000 <wakeup>
  release(&p->lock);
80103675:	89 3c 24             	mov    %edi,(%esp)
80103678:	e8 43 0e 00 00       	call   801044c0 <release>
  return n;
8010367d:	83 c4 10             	add    $0x10,%esp
80103680:	8b 45 10             	mov    0x10(%ebp),%eax
80103683:	eb 14                	jmp    80103699 <pipewrite+0x119>
80103685:	8d 76 00             	lea    0x0(%esi),%esi

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
        release(&p->lock);
80103688:	83 ec 0c             	sub    $0xc,%esp
8010368b:	57                   	push   %edi
8010368c:	e8 2f 0e 00 00       	call   801044c0 <release>
        return -1;
80103691:	83 c4 10             	add    $0x10,%esp
80103694:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103699:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010369c:	5b                   	pop    %ebx
8010369d:	5e                   	pop    %esi
8010369e:	5f                   	pop    %edi
8010369f:	5d                   	pop    %ebp
801036a0:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036a1:	89 ca                	mov    %ecx,%edx
801036a3:	eb 98                	jmp    8010363d <pipewrite+0xbd>
801036a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801036b0 <piperead>:
  return n;
}

int
piperead(struct pipe *p, char *addr, int n)
{
801036b0:	55                   	push   %ebp
801036b1:	89 e5                	mov    %esp,%ebp
801036b3:	57                   	push   %edi
801036b4:	56                   	push   %esi
801036b5:	53                   	push   %ebx
801036b6:	83 ec 18             	sub    $0x18,%esp
801036b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801036bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036bf:	53                   	push   %ebx
801036c0:	e8 1b 0c 00 00       	call   801042e0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036c5:	83 c4 10             	add    $0x10,%esp
801036c8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801036ce:	39 83 38 02 00 00    	cmp    %eax,0x238(%ebx)
801036d4:	75 6a                	jne    80103740 <piperead+0x90>
801036d6:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
801036dc:	85 f6                	test   %esi,%esi
801036de:	0f 84 cc 00 00 00    	je     801037b0 <piperead+0x100>
801036e4:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
801036ea:	eb 2d                	jmp    80103719 <piperead+0x69>
801036ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(proc->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801036f0:	83 ec 08             	sub    $0x8,%esp
801036f3:	53                   	push   %ebx
801036f4:	56                   	push   %esi
801036f5:	e8 66 07 00 00       	call   80103e60 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036fa:	83 c4 10             	add    $0x10,%esp
801036fd:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103703:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80103709:	75 35                	jne    80103740 <piperead+0x90>
8010370b:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
80103711:	85 d2                	test   %edx,%edx
80103713:	0f 84 97 00 00 00    	je     801037b0 <piperead+0x100>
    if(proc->killed){
80103719:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103720:	8b 4a 24             	mov    0x24(%edx),%ecx
80103723:	85 c9                	test   %ecx,%ecx
80103725:	74 c9                	je     801036f0 <piperead+0x40>
      release(&p->lock);
80103727:	83 ec 0c             	sub    $0xc,%esp
8010372a:	53                   	push   %ebx
8010372b:	e8 90 0d 00 00       	call   801044c0 <release>
      return -1;
80103730:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103733:	8d 65 f4             	lea    -0xc(%ebp),%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(proc->killed){
      release(&p->lock);
      return -1;
80103736:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
8010373b:	5b                   	pop    %ebx
8010373c:	5e                   	pop    %esi
8010373d:	5f                   	pop    %edi
8010373e:	5d                   	pop    %ebp
8010373f:	c3                   	ret    
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103740:	8b 45 10             	mov    0x10(%ebp),%eax
80103743:	85 c0                	test   %eax,%eax
80103745:	7e 69                	jle    801037b0 <piperead+0x100>
    if(p->nread == p->nwrite)
80103747:	8b 93 34 02 00 00    	mov    0x234(%ebx),%edx
8010374d:	31 c9                	xor    %ecx,%ecx
8010374f:	eb 15                	jmp    80103766 <piperead+0xb6>
80103751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103758:	8b 93 34 02 00 00    	mov    0x234(%ebx),%edx
8010375e:	3b 93 38 02 00 00    	cmp    0x238(%ebx),%edx
80103764:	74 5a                	je     801037c0 <piperead+0x110>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103766:	8d 72 01             	lea    0x1(%edx),%esi
80103769:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010376f:	89 b3 34 02 00 00    	mov    %esi,0x234(%ebx)
80103775:	0f b6 54 13 34       	movzbl 0x34(%ebx,%edx,1),%edx
8010377a:	88 14 0f             	mov    %dl,(%edi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010377d:	83 c1 01             	add    $0x1,%ecx
80103780:	39 4d 10             	cmp    %ecx,0x10(%ebp)
80103783:	75 d3                	jne    80103758 <piperead+0xa8>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103785:	8d 93 38 02 00 00    	lea    0x238(%ebx),%edx
8010378b:	83 ec 0c             	sub    $0xc,%esp
8010378e:	52                   	push   %edx
8010378f:	e8 6c 08 00 00       	call   80104000 <wakeup>
  release(&p->lock);
80103794:	89 1c 24             	mov    %ebx,(%esp)
80103797:	e8 24 0d 00 00       	call   801044c0 <release>
  return i;
8010379c:	8b 45 10             	mov    0x10(%ebp),%eax
8010379f:	83 c4 10             	add    $0x10,%esp
}
801037a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037a5:	5b                   	pop    %ebx
801037a6:	5e                   	pop    %esi
801037a7:	5f                   	pop    %edi
801037a8:	5d                   	pop    %ebp
801037a9:	c3                   	ret    
801037aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037b0:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
801037b7:	eb cc                	jmp    80103785 <piperead+0xd5>
801037b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037c0:	89 4d 10             	mov    %ecx,0x10(%ebp)
801037c3:	eb c0                	jmp    80103785 <piperead+0xd5>
801037c5:	66 90                	xchg   %ax,%ax
801037c7:	66 90                	xchg   %ax,%ax
801037c9:	66 90                	xchg   %ax,%ax
801037cb:	66 90                	xchg   %ax,%ax
801037cd:	66 90                	xchg   %ax,%ax
801037cf:	90                   	nop

801037d0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037d0:	55                   	push   %ebp
801037d1:	89 e5                	mov    %esp,%ebp
801037d3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037d4:	bb f4 ad 14 80       	mov    $0x8014adf4,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037d9:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801037dc:	68 c0 ad 14 80       	push   $0x8014adc0
801037e1:	e8 fa 0a 00 00       	call   801042e0 <acquire>
801037e6:	83 c4 10             	add    $0x10,%esp
801037e9:	eb 10                	jmp    801037fb <allocproc+0x2b>
801037eb:	90                   	nop
801037ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037f0:	83 c3 7c             	add    $0x7c,%ebx
801037f3:	81 fb f4 cc 14 80    	cmp    $0x8014ccf4,%ebx
801037f9:	74 75                	je     80103870 <allocproc+0xa0>
    if(p->state == UNUSED)
801037fb:	8b 43 0c             	mov    0xc(%ebx),%eax
801037fe:	85 c0                	test   %eax,%eax
80103800:	75 ee                	jne    801037f0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103802:	a1 08 a0 10 80       	mov    0x8010a008,%eax

  release(&ptable.lock);
80103807:	83 ec 0c             	sub    $0xc,%esp

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
8010380a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;

  release(&ptable.lock);
80103811:	68 c0 ad 14 80       	push   $0x8014adc0
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103816:	8d 50 01             	lea    0x1(%eax),%edx
80103819:	89 43 10             	mov    %eax,0x10(%ebx)
8010381c:	89 15 08 a0 10 80    	mov    %edx,0x8010a008

  release(&ptable.lock);
80103822:	e8 99 0c 00 00       	call   801044c0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103827:	e8 d4 ec ff ff       	call   80102500 <kalloc>
8010382c:	83 c4 10             	add    $0x10,%esp
8010382f:	85 c0                	test   %eax,%eax
80103831:	89 43 08             	mov    %eax,0x8(%ebx)
80103834:	74 51                	je     80103887 <allocproc+0xb7>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103836:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010383c:	83 ec 04             	sub    $0x4,%esp
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
8010383f:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103844:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
80103847:	c7 40 14 7e 57 10 80 	movl   $0x8010577e,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010384e:	6a 14                	push   $0x14
80103850:	6a 00                	push   $0x0
80103852:	50                   	push   %eax
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
80103853:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103856:	e8 b5 0c 00 00       	call   80104510 <memset>
  p->context->eip = (uint)forkret;
8010385b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010385e:	83 c4 10             	add    $0x10,%esp
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
80103861:	c7 40 10 90 38 10 80 	movl   $0x80103890,0x10(%eax)

  return p;
80103868:	89 d8                	mov    %ebx,%eax
}
8010386a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010386d:	c9                   	leave  
8010386e:	c3                   	ret    
8010386f:	90                   	nop

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103870:	83 ec 0c             	sub    $0xc,%esp
80103873:	68 c0 ad 14 80       	push   $0x8014adc0
80103878:	e8 43 0c 00 00       	call   801044c0 <release>
  return 0;
8010387d:	83 c4 10             	add    $0x10,%esp
80103880:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
80103882:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103885:	c9                   	leave  
80103886:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
80103887:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
8010388e:	eb da                	jmp    8010386a <allocproc+0x9a>

80103890 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103890:	55                   	push   %ebp
80103891:	89 e5                	mov    %esp,%ebp
80103893:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103896:	68 c0 ad 14 80       	push   $0x8014adc0
8010389b:	e8 20 0c 00 00       	call   801044c0 <release>

  if (first) {
801038a0:	a1 04 a0 10 80       	mov    0x8010a004,%eax
801038a5:	83 c4 10             	add    $0x10,%esp
801038a8:	85 c0                	test   %eax,%eax
801038aa:	75 04                	jne    801038b0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038ac:	c9                   	leave  
801038ad:	c3                   	ret    
801038ae:	66 90                	xchg   %ax,%ax
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
801038b0:	83 ec 0c             	sub    $0xc,%esp

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
801038b3:	c7 05 04 a0 10 80 00 	movl   $0x0,0x8010a004
801038ba:	00 00 00 
    iinit(ROOTDEV);
801038bd:	6a 01                	push   $0x1
801038bf:	e8 8c db ff ff       	call   80101450 <iinit>
    initlog(ROOTDEV);
801038c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038cb:	e8 f0 f2 ff ff       	call   80102bc0 <initlog>
801038d0:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038d3:	c9                   	leave  
801038d4:	c3                   	ret    
801038d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801038e0 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801038e0:	55                   	push   %ebp
801038e1:	89 e5                	mov    %esp,%ebp
801038e3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801038e6:	68 a5 74 10 80       	push   $0x801074a5
801038eb:	68 c0 ad 14 80       	push   $0x8014adc0
801038f0:	e8 cb 09 00 00       	call   801042c0 <initlock>
}
801038f5:	83 c4 10             	add    $0x10,%esp
801038f8:	c9                   	leave  
801038f9:	c3                   	ret    
801038fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103900 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	53                   	push   %ebx
80103904:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103907:	e8 c4 fe ff ff       	call   801037d0 <allocproc>
8010390c:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
8010390e:	a3 c0 a5 10 80       	mov    %eax,0x8010a5c0
  if((p->pgdir = setupkvm()) == 0)
80103913:	e8 38 30 00 00       	call   80106950 <setupkvm>
80103918:	85 c0                	test   %eax,%eax
8010391a:	89 43 04             	mov    %eax,0x4(%ebx)
8010391d:	0f 84 bd 00 00 00    	je     801039e0 <userinit+0xe0>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103923:	83 ec 04             	sub    $0x4,%esp
80103926:	68 2c 00 00 00       	push   $0x2c
8010392b:	68 60 a4 10 80       	push   $0x8010a460
80103930:	50                   	push   %eax
80103931:	e8 9a 31 00 00       	call   80106ad0 <inituvm>
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
80103936:	83 c4 0c             	add    $0xc,%esp
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
80103939:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010393f:	6a 4c                	push   $0x4c
80103941:	6a 00                	push   $0x0
80103943:	ff 73 18             	pushl  0x18(%ebx)
80103946:	e8 c5 0b 00 00       	call   80104510 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010394b:	8b 43 18             	mov    0x18(%ebx),%eax
8010394e:	ba 23 00 00 00       	mov    $0x23,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103953:	b9 2b 00 00 00       	mov    $0x2b,%ecx
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103958:	83 c4 0c             	add    $0xc,%esp
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010395b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010395f:	8b 43 18             	mov    0x18(%ebx),%eax
80103962:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103966:	8b 43 18             	mov    0x18(%ebx),%eax
80103969:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010396d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103971:	8b 43 18             	mov    0x18(%ebx),%eax
80103974:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103978:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010397c:	8b 43 18             	mov    0x18(%ebx),%eax
8010397f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103986:	8b 43 18             	mov    0x18(%ebx),%eax
80103989:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103990:	8b 43 18             	mov    0x18(%ebx),%eax
80103993:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
8010399a:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010399d:	6a 10                	push   $0x10
8010399f:	68 c5 74 10 80       	push   $0x801074c5
801039a4:	50                   	push   %eax
801039a5:	e8 66 0d 00 00       	call   80104710 <safestrcpy>
  p->cwd = namei("/");
801039aa:	c7 04 24 ce 74 10 80 	movl   $0x801074ce,(%esp)
801039b1:	e8 9a e4 ff ff       	call   80101e50 <namei>
801039b6:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
801039b9:	c7 04 24 c0 ad 14 80 	movl   $0x8014adc0,(%esp)
801039c0:	e8 1b 09 00 00       	call   801042e0 <acquire>

  p->state = RUNNABLE;
801039c5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
801039cc:	c7 04 24 c0 ad 14 80 	movl   $0x8014adc0,(%esp)
801039d3:	e8 e8 0a 00 00       	call   801044c0 <release>
}
801039d8:	83 c4 10             	add    $0x10,%esp
801039db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039de:	c9                   	leave  
801039df:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
801039e0:	83 ec 0c             	sub    $0xc,%esp
801039e3:	68 ac 74 10 80       	push   $0x801074ac
801039e8:	e8 83 c9 ff ff       	call   80100370 <panic>
801039ed:	8d 76 00             	lea    0x0(%esi),%esi

801039f0 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801039f0:	55                   	push   %ebp
801039f1:	89 e5                	mov    %esp,%ebp
801039f3:	83 ec 08             	sub    $0x8,%esp
  uint sz;

  sz = proc->sz;
801039f6:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801039fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint sz;

  sz = proc->sz;
80103a00:	8b 02                	mov    (%edx),%eax
  if(n > 0){
80103a02:	83 f9 00             	cmp    $0x0,%ecx
80103a05:	7e 39                	jle    80103a40 <growproc+0x50>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80103a07:	83 ec 04             	sub    $0x4,%esp
80103a0a:	01 c1                	add    %eax,%ecx
80103a0c:	51                   	push   %ecx
80103a0d:	50                   	push   %eax
80103a0e:	ff 72 04             	pushl  0x4(%edx)
80103a11:	e8 fa 31 00 00       	call   80106c10 <allocuvm>
80103a16:	83 c4 10             	add    $0x10,%esp
80103a19:	85 c0                	test   %eax,%eax
80103a1b:	74 3b                	je     80103a58 <growproc+0x68>
80103a1d:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  proc->sz = sz;
80103a24:	89 02                	mov    %eax,(%edx)
  switchuvm(proc);
80103a26:	83 ec 0c             	sub    $0xc,%esp
80103a29:	65 ff 35 04 00 00 00 	pushl  %gs:0x4
80103a30:	e8 cb 2f 00 00       	call   80106a00 <switchuvm>
  return 0;
80103a35:	83 c4 10             	add    $0x10,%esp
80103a38:	31 c0                	xor    %eax,%eax
}
80103a3a:	c9                   	leave  
80103a3b:	c3                   	ret    
80103a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
80103a40:	74 e2                	je     80103a24 <growproc+0x34>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80103a42:	83 ec 04             	sub    $0x4,%esp
80103a45:	01 c1                	add    %eax,%ecx
80103a47:	51                   	push   %ecx
80103a48:	50                   	push   %eax
80103a49:	ff 72 04             	pushl  0x4(%edx)
80103a4c:	e8 bf 32 00 00       	call   80106d10 <deallocuvm>
80103a51:	83 c4 10             	add    $0x10,%esp
80103a54:	85 c0                	test   %eax,%eax
80103a56:	75 c5                	jne    80103a1d <growproc+0x2d>
  uint sz;

  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
80103a58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
}
80103a5d:	c9                   	leave  
80103a5e:	c3                   	ret    
80103a5f:	90                   	nop

80103a60 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103a60:	55                   	push   %ebp
80103a61:	89 e5                	mov    %esp,%ebp
80103a63:	57                   	push   %edi
80103a64:	56                   	push   %esi
80103a65:	53                   	push   %ebx
80103a66:	83 ec 0c             	sub    $0xc,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0){
80103a69:	e8 62 fd ff ff       	call   801037d0 <allocproc>
80103a6e:	85 c0                	test   %eax,%eax
80103a70:	0f 84 d6 00 00 00    	je     80103b4c <fork+0xec>
80103a76:	89 c3                	mov    %eax,%ebx
    return -1;
  }

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80103a78:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103a7e:	83 ec 08             	sub    $0x8,%esp
80103a81:	ff 30                	pushl  (%eax)
80103a83:	ff 70 04             	pushl  0x4(%eax)
80103a86:	e8 65 33 00 00       	call   80106df0 <copyuvm>
80103a8b:	83 c4 10             	add    $0x10,%esp
80103a8e:	85 c0                	test   %eax,%eax
80103a90:	89 43 04             	mov    %eax,0x4(%ebx)
80103a93:	0f 84 ba 00 00 00    	je     80103b53 <fork+0xf3>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
80103a99:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  np->parent = proc;
  *np->tf = *proc->tf;
80103a9f:	8b 7b 18             	mov    0x18(%ebx),%edi
80103aa2:	b9 13 00 00 00       	mov    $0x13,%ecx
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
80103aa7:	8b 00                	mov    (%eax),%eax
80103aa9:	89 03                	mov    %eax,(%ebx)
  np->parent = proc;
80103aab:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103ab1:	89 43 14             	mov    %eax,0x14(%ebx)
  *np->tf = *proc->tf;
80103ab4:	8b 70 18             	mov    0x18(%eax),%esi
80103ab7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103ab9:	31 f6                	xor    %esi,%esi
  np->sz = proc->sz;
  np->parent = proc;
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103abb:	8b 43 18             	mov    0x18(%ebx),%eax
80103abe:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103ac5:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
80103ad0:	8b 44 b2 28          	mov    0x28(%edx,%esi,4),%eax
80103ad4:	85 c0                	test   %eax,%eax
80103ad6:	74 17                	je     80103aef <fork+0x8f>
      np->ofile[i] = filedup(proc->ofile[i]);
80103ad8:	83 ec 0c             	sub    $0xc,%esp
80103adb:	50                   	push   %eax
80103adc:	e8 df d2 ff ff       	call   80100dc0 <filedup>
80103ae1:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
80103ae5:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103aec:	83 c4 10             	add    $0x10,%esp
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103aef:	83 c6 01             	add    $0x1,%esi
80103af2:	83 fe 10             	cmp    $0x10,%esi
80103af5:	75 d9                	jne    80103ad0 <fork+0x70>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80103af7:	83 ec 0c             	sub    $0xc,%esp
80103afa:	ff 72 68             	pushl  0x68(%edx)
80103afd:	e8 ee da ff ff       	call   801015f0 <idup>
80103b02:	89 43 68             	mov    %eax,0x68(%ebx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80103b05:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103b0b:	83 c4 0c             	add    $0xc,%esp
80103b0e:	6a 10                	push   $0x10
80103b10:	83 c0 6c             	add    $0x6c,%eax
80103b13:	50                   	push   %eax
80103b14:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103b17:	50                   	push   %eax
80103b18:	e8 f3 0b 00 00       	call   80104710 <safestrcpy>

  pid = np->pid;
80103b1d:	8b 73 10             	mov    0x10(%ebx),%esi

  acquire(&ptable.lock);
80103b20:	c7 04 24 c0 ad 14 80 	movl   $0x8014adc0,(%esp)
80103b27:	e8 b4 07 00 00       	call   801042e0 <acquire>

  np->state = RUNNABLE;
80103b2c:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
80103b33:	c7 04 24 c0 ad 14 80 	movl   $0x8014adc0,(%esp)
80103b3a:	e8 81 09 00 00       	call   801044c0 <release>

  return pid;
80103b3f:	83 c4 10             	add    $0x10,%esp
80103b42:	89 f0                	mov    %esi,%eax
}
80103b44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b47:	5b                   	pop    %ebx
80103b48:	5e                   	pop    %esi
80103b49:	5f                   	pop    %edi
80103b4a:	5d                   	pop    %ebp
80103b4b:	c3                   	ret    
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103b4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b51:	eb f1                	jmp    80103b44 <fork+0xe4>
  }

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
80103b53:	83 ec 0c             	sub    $0xc,%esp
80103b56:	ff 73 08             	pushl  0x8(%ebx)
80103b59:	e8 32 e7 ff ff       	call   80102290 <kfree>
    np->kstack = 0;
80103b5e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103b65:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103b6c:	83 c4 10             	add    $0x10,%esp
80103b6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b74:	eb ce                	jmp    80103b44 <fork+0xe4>
80103b76:	8d 76 00             	lea    0x0(%esi),%esi
80103b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b80 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103b80:	55                   	push   %ebp
80103b81:	89 e5                	mov    %esp,%ebp
80103b83:	53                   	push   %ebx
80103b84:	83 ec 04             	sub    $0x4,%esp
80103b87:	89 f6                	mov    %esi,%esi
80103b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103b90:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103b91:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b94:	bb f4 ad 14 80       	mov    $0x8014adf4,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103b99:	68 c0 ad 14 80       	push   $0x8014adc0
80103b9e:	e8 3d 07 00 00       	call   801042e0 <acquire>
80103ba3:	83 c4 10             	add    $0x10,%esp
80103ba6:	eb 13                	jmp    80103bbb <scheduler+0x3b>
80103ba8:	90                   	nop
80103ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103bb0:	83 c3 7c             	add    $0x7c,%ebx
80103bb3:	81 fb f4 cc 14 80    	cmp    $0x8014ccf4,%ebx
80103bb9:	74 55                	je     80103c10 <scheduler+0x90>
      if(p->state != RUNNABLE)
80103bbb:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103bbf:	75 ef                	jne    80103bb0 <scheduler+0x30>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
80103bc1:	83 ec 0c             	sub    $0xc,%esp
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80103bc4:	65 89 1d 04 00 00 00 	mov    %ebx,%gs:0x4
      switchuvm(p);
80103bcb:	53                   	push   %ebx
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103bcc:	83 c3 7c             	add    $0x7c,%ebx

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
80103bcf:	e8 2c 2e 00 00       	call   80106a00 <switchuvm>
      p->state = RUNNING;
      swtch(&cpu->scheduler, p->context);
80103bd4:	58                   	pop    %eax
80103bd5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103bdb:	c7 43 90 04 00 00 00 	movl   $0x4,-0x70(%ebx)
      swtch(&cpu->scheduler, p->context);
80103be2:	5a                   	pop    %edx
80103be3:	ff 73 a0             	pushl  -0x60(%ebx)
80103be6:	83 c0 04             	add    $0x4,%eax
80103be9:	50                   	push   %eax
80103bea:	e8 7c 0b 00 00       	call   8010476b <swtch>
      switchkvm();
80103bef:	e8 ec 2d 00 00       	call   801069e0 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80103bf4:	83 c4 10             	add    $0x10,%esp
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103bf7:	81 fb f4 cc 14 80    	cmp    $0x8014ccf4,%ebx
      swtch(&cpu->scheduler, p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80103bfd:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80103c04:	00 00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c08:	75 b1                	jne    80103bbb <scheduler+0x3b>
80103c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80103c10:	83 ec 0c             	sub    $0xc,%esp
80103c13:	68 c0 ad 14 80       	push   $0x8014adc0
80103c18:	e8 a3 08 00 00       	call   801044c0 <release>

  }
80103c1d:	83 c4 10             	add    $0x10,%esp
80103c20:	e9 6b ff ff ff       	jmp    80103b90 <scheduler+0x10>
80103c25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c30 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103c30:	55                   	push   %ebp
80103c31:	89 e5                	mov    %esp,%ebp
80103c33:	53                   	push   %ebx
80103c34:	83 ec 10             	sub    $0x10,%esp
  int intena;

  if(!holding(&ptable.lock))
80103c37:	68 c0 ad 14 80       	push   $0x8014adc0
80103c3c:	e8 cf 07 00 00       	call   80104410 <holding>
80103c41:	83 c4 10             	add    $0x10,%esp
80103c44:	85 c0                	test   %eax,%eax
80103c46:	74 4c                	je     80103c94 <sched+0x64>
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
80103c48:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80103c4f:	83 ba ac 00 00 00 01 	cmpl   $0x1,0xac(%edx)
80103c56:	75 63                	jne    80103cbb <sched+0x8b>
    panic("sched locks");
  if(proc->state == RUNNING)
80103c58:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103c5e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80103c62:	74 4a                	je     80103cae <sched+0x7e>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103c64:	9c                   	pushf  
80103c65:	59                   	pop    %ecx
    panic("sched running");
  if(readeflags()&FL_IF)
80103c66:	80 e5 02             	and    $0x2,%ch
80103c69:	75 36                	jne    80103ca1 <sched+0x71>
    panic("sched interruptible");
  intena = cpu->intena;
  swtch(&proc->context, cpu->scheduler);
80103c6b:	83 ec 08             	sub    $0x8,%esp
80103c6e:	83 c0 1c             	add    $0x1c,%eax
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;
80103c71:	8b 9a b0 00 00 00    	mov    0xb0(%edx),%ebx
  swtch(&proc->context, cpu->scheduler);
80103c77:	ff 72 04             	pushl  0x4(%edx)
80103c7a:	50                   	push   %eax
80103c7b:	e8 eb 0a 00 00       	call   8010476b <swtch>
  cpu->intena = intena;
80103c80:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
}
80103c86:	83 c4 10             	add    $0x10,%esp
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;
  swtch(&proc->context, cpu->scheduler);
  cpu->intena = intena;
80103c89:	89 98 b0 00 00 00    	mov    %ebx,0xb0(%eax)
}
80103c8f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c92:	c9                   	leave  
80103c93:	c3                   	ret    
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103c94:	83 ec 0c             	sub    $0xc,%esp
80103c97:	68 d0 74 10 80       	push   $0x801074d0
80103c9c:	e8 cf c6 ff ff       	call   80100370 <panic>
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103ca1:	83 ec 0c             	sub    $0xc,%esp
80103ca4:	68 fc 74 10 80       	push   $0x801074fc
80103ca9:	e8 c2 c6 ff ff       	call   80100370 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
80103cae:	83 ec 0c             	sub    $0xc,%esp
80103cb1:	68 ee 74 10 80       	push   $0x801074ee
80103cb6:	e8 b5 c6 ff ff       	call   80100370 <panic>
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
80103cbb:	83 ec 0c             	sub    $0xc,%esp
80103cbe:	68 e2 74 10 80       	push   $0x801074e2
80103cc3:	e8 a8 c6 ff ff       	call   80100370 <panic>
80103cc8:	90                   	nop
80103cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103cd0 <exit>:
exit(void)
{
  struct proc *p;
  int fd;

  if(proc == initproc)
80103cd0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103cd7:	3b 15 c0 a5 10 80    	cmp    0x8010a5c0,%edx
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103cdd:	55                   	push   %ebp
80103cde:	89 e5                	mov    %esp,%ebp
80103ce0:	56                   	push   %esi
80103ce1:	53                   	push   %ebx
  struct proc *p;
  int fd;

  if(proc == initproc)
80103ce2:	0f 84 1f 01 00 00    	je     80103e07 <exit+0x137>
80103ce8:	31 db                	xor    %ebx,%ebx
80103cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
80103cf0:	8d 73 08             	lea    0x8(%ebx),%esi
80103cf3:	8b 44 b2 08          	mov    0x8(%edx,%esi,4),%eax
80103cf7:	85 c0                	test   %eax,%eax
80103cf9:	74 1b                	je     80103d16 <exit+0x46>
      fileclose(proc->ofile[fd]);
80103cfb:	83 ec 0c             	sub    $0xc,%esp
80103cfe:	50                   	push   %eax
80103cff:	e8 0c d1 ff ff       	call   80100e10 <fileclose>
      proc->ofile[fd] = 0;
80103d04:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103d0b:	83 c4 10             	add    $0x10,%esp
80103d0e:	c7 44 b2 08 00 00 00 	movl   $0x0,0x8(%edx,%esi,4)
80103d15:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103d16:	83 c3 01             	add    $0x1,%ebx
80103d19:	83 fb 10             	cmp    $0x10,%ebx
80103d1c:	75 d2                	jne    80103cf0 <exit+0x20>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80103d1e:	e8 3d ef ff ff       	call   80102c60 <begin_op>
  iput(proc->cwd);
80103d23:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103d29:	83 ec 0c             	sub    $0xc,%esp
80103d2c:	ff 70 68             	pushl  0x68(%eax)
80103d2f:	e8 1c da ff ff       	call   80101750 <iput>
  end_op();
80103d34:	e8 97 ef ff ff       	call   80102cd0 <end_op>
  proc->cwd = 0;
80103d39:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103d3f:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80103d46:	c7 04 24 c0 ad 14 80 	movl   $0x8014adc0,(%esp)
80103d4d:	e8 8e 05 00 00       	call   801042e0 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80103d52:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
80103d59:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d5c:	b8 f4 ad 14 80       	mov    $0x8014adf4,%eax
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80103d61:	8b 51 14             	mov    0x14(%ecx),%edx
80103d64:	eb 14                	jmp    80103d7a <exit+0xaa>
80103d66:	8d 76 00             	lea    0x0(%esi),%esi
80103d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d70:	83 c0 7c             	add    $0x7c,%eax
80103d73:	3d f4 cc 14 80       	cmp    $0x8014ccf4,%eax
80103d78:	74 1c                	je     80103d96 <exit+0xc6>
    if(p->state == SLEEPING && p->chan == chan)
80103d7a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d7e:	75 f0                	jne    80103d70 <exit+0xa0>
80103d80:	3b 50 20             	cmp    0x20(%eax),%edx
80103d83:	75 eb                	jne    80103d70 <exit+0xa0>
      p->state = RUNNABLE;
80103d85:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d8c:	83 c0 7c             	add    $0x7c,%eax
80103d8f:	3d f4 cc 14 80       	cmp    $0x8014ccf4,%eax
80103d94:	75 e4                	jne    80103d7a <exit+0xaa>
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
80103d96:	8b 1d c0 a5 10 80    	mov    0x8010a5c0,%ebx
80103d9c:	ba f4 ad 14 80       	mov    $0x8014adf4,%edx
80103da1:	eb 10                	jmp    80103db3 <exit+0xe3>
80103da3:	90                   	nop
80103da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103da8:	83 c2 7c             	add    $0x7c,%edx
80103dab:	81 fa f4 cc 14 80    	cmp    $0x8014ccf4,%edx
80103db1:	74 3b                	je     80103dee <exit+0x11e>
    if(p->parent == proc){
80103db3:	3b 4a 14             	cmp    0x14(%edx),%ecx
80103db6:	75 f0                	jne    80103da8 <exit+0xd8>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103db8:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
80103dbc:	89 5a 14             	mov    %ebx,0x14(%edx)
      if(p->state == ZOMBIE)
80103dbf:	75 e7                	jne    80103da8 <exit+0xd8>
80103dc1:	b8 f4 ad 14 80       	mov    $0x8014adf4,%eax
80103dc6:	eb 12                	jmp    80103dda <exit+0x10a>
80103dc8:	90                   	nop
80103dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103dd0:	83 c0 7c             	add    $0x7c,%eax
80103dd3:	3d f4 cc 14 80       	cmp    $0x8014ccf4,%eax
80103dd8:	74 ce                	je     80103da8 <exit+0xd8>
    if(p->state == SLEEPING && p->chan == chan)
80103dda:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103dde:	75 f0                	jne    80103dd0 <exit+0x100>
80103de0:	3b 58 20             	cmp    0x20(%eax),%ebx
80103de3:	75 eb                	jne    80103dd0 <exit+0x100>
      p->state = RUNNABLE;
80103de5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103dec:	eb e2                	jmp    80103dd0 <exit+0x100>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80103dee:	c7 41 0c 05 00 00 00 	movl   $0x5,0xc(%ecx)
  sched();
80103df5:	e8 36 fe ff ff       	call   80103c30 <sched>
  panic("zombie exit");
80103dfa:	83 ec 0c             	sub    $0xc,%esp
80103dfd:	68 1d 75 10 80       	push   $0x8010751d
80103e02:	e8 69 c5 ff ff       	call   80100370 <panic>
{
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");
80103e07:	83 ec 0c             	sub    $0xc,%esp
80103e0a:	68 10 75 10 80       	push   $0x80107510
80103e0f:	e8 5c c5 ff ff       	call   80100370 <panic>
80103e14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103e1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103e20 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103e20:	55                   	push   %ebp
80103e21:	89 e5                	mov    %esp,%ebp
80103e23:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103e26:	68 c0 ad 14 80       	push   $0x8014adc0
80103e2b:	e8 b0 04 00 00       	call   801042e0 <acquire>
  proc->state = RUNNABLE;
80103e30:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103e36:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103e3d:	e8 ee fd ff ff       	call   80103c30 <sched>
  release(&ptable.lock);
80103e42:	c7 04 24 c0 ad 14 80 	movl   $0x8014adc0,(%esp)
80103e49:	e8 72 06 00 00       	call   801044c0 <release>
}
80103e4e:	83 c4 10             	add    $0x10,%esp
80103e51:	c9                   	leave  
80103e52:	c3                   	ret    
80103e53:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e60 <sleep>:
// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
80103e60:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103e66:	55                   	push   %ebp
80103e67:	89 e5                	mov    %esp,%ebp
80103e69:	56                   	push   %esi
80103e6a:	53                   	push   %ebx
  if(proc == 0)
80103e6b:	85 c0                	test   %eax,%eax

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103e6d:	8b 75 08             	mov    0x8(%ebp),%esi
80103e70:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(proc == 0)
80103e73:	0f 84 97 00 00 00    	je     80103f10 <sleep+0xb0>
    panic("sleep");

  if(lk == 0)
80103e79:	85 db                	test   %ebx,%ebx
80103e7b:	0f 84 82 00 00 00    	je     80103f03 <sleep+0xa3>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103e81:	81 fb c0 ad 14 80    	cmp    $0x8014adc0,%ebx
80103e87:	74 57                	je     80103ee0 <sleep+0x80>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103e89:	83 ec 0c             	sub    $0xc,%esp
80103e8c:	68 c0 ad 14 80       	push   $0x8014adc0
80103e91:	e8 4a 04 00 00       	call   801042e0 <acquire>
    release(lk);
80103e96:	89 1c 24             	mov    %ebx,(%esp)
80103e99:	e8 22 06 00 00       	call   801044c0 <release>
  }

  // Go to sleep.
  proc->chan = chan;
80103e9e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103ea4:	89 70 20             	mov    %esi,0x20(%eax)
  proc->state = SLEEPING;
80103ea7:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103eae:	e8 7d fd ff ff       	call   80103c30 <sched>

  // Tidy up.
  proc->chan = 0;
80103eb3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103eb9:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103ec0:	c7 04 24 c0 ad 14 80 	movl   $0x8014adc0,(%esp)
80103ec7:	e8 f4 05 00 00       	call   801044c0 <release>
    acquire(lk);
80103ecc:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103ecf:	83 c4 10             	add    $0x10,%esp
  }
}
80103ed2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ed5:	5b                   	pop    %ebx
80103ed6:	5e                   	pop    %esi
80103ed7:	5d                   	pop    %ebp
  proc->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103ed8:	e9 03 04 00 00       	jmp    801042e0 <acquire>
80103edd:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }

  // Go to sleep.
  proc->chan = chan;
80103ee0:	89 70 20             	mov    %esi,0x20(%eax)
  proc->state = SLEEPING;
80103ee3:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103eea:	e8 41 fd ff ff       	call   80103c30 <sched>

  // Tidy up.
  proc->chan = 0;
80103eef:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103ef5:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103efc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103eff:	5b                   	pop    %ebx
80103f00:	5e                   	pop    %esi
80103f01:	5d                   	pop    %ebp
80103f02:	c3                   	ret    
{
  if(proc == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103f03:	83 ec 0c             	sub    $0xc,%esp
80103f06:	68 2f 75 10 80       	push   $0x8010752f
80103f0b:	e8 60 c4 ff ff       	call   80100370 <panic>
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");
80103f10:	83 ec 0c             	sub    $0xc,%esp
80103f13:	68 29 75 10 80       	push   $0x80107529
80103f18:	e8 53 c4 ff ff       	call   80100370 <panic>
80103f1d:	8d 76 00             	lea    0x0(%esi),%esi

80103f20 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103f20:	55                   	push   %ebp
80103f21:	89 e5                	mov    %esp,%ebp
80103f23:	56                   	push   %esi
80103f24:	53                   	push   %ebx
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80103f25:	83 ec 0c             	sub    $0xc,%esp
80103f28:	68 c0 ad 14 80       	push   $0x8014adc0
80103f2d:	e8 ae 03 00 00       	call   801042e0 <acquire>
80103f32:	83 c4 10             	add    $0x10,%esp
80103f35:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103f3b:	31 d2                	xor    %edx,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f3d:	bb f4 ad 14 80       	mov    $0x8014adf4,%ebx
80103f42:	eb 0f                	jmp    80103f53 <wait+0x33>
80103f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f48:	83 c3 7c             	add    $0x7c,%ebx
80103f4b:	81 fb f4 cc 14 80    	cmp    $0x8014ccf4,%ebx
80103f51:	74 1d                	je     80103f70 <wait+0x50>
      if(p->parent != proc)
80103f53:	3b 43 14             	cmp    0x14(%ebx),%eax
80103f56:	75 f0                	jne    80103f48 <wait+0x28>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103f58:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103f5c:	74 30                	je     80103f8e <wait+0x6e>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f5e:	83 c3 7c             	add    $0x7c,%ebx
      if(p->parent != proc)
        continue;
      havekids = 1;
80103f61:	ba 01 00 00 00       	mov    $0x1,%edx

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f66:	81 fb f4 cc 14 80    	cmp    $0x8014ccf4,%ebx
80103f6c:	75 e5                	jne    80103f53 <wait+0x33>
80103f6e:	66 90                	xchg   %ax,%ax
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80103f70:	85 d2                	test   %edx,%edx
80103f72:	74 70                	je     80103fe4 <wait+0xc4>
80103f74:	8b 50 24             	mov    0x24(%eax),%edx
80103f77:	85 d2                	test   %edx,%edx
80103f79:	75 69                	jne    80103fe4 <wait+0xc4>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80103f7b:	83 ec 08             	sub    $0x8,%esp
80103f7e:	68 c0 ad 14 80       	push   $0x8014adc0
80103f83:	50                   	push   %eax
80103f84:	e8 d7 fe ff ff       	call   80103e60 <sleep>
  }
80103f89:	83 c4 10             	add    $0x10,%esp
80103f8c:	eb a7                	jmp    80103f35 <wait+0x15>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80103f8e:	83 ec 0c             	sub    $0xc,%esp
80103f91:	ff 73 08             	pushl  0x8(%ebx)
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80103f94:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103f97:	e8 f4 e2 ff ff       	call   80102290 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80103f9c:	59                   	pop    %ecx
80103f9d:	ff 73 04             	pushl  0x4(%ebx)
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80103fa0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103fa7:	e8 94 2d 00 00       	call   80106d40 <freevm>
        p->pid = 0;
80103fac:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103fb3:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103fba:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103fbe:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103fc5:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103fcc:	c7 04 24 c0 ad 14 80 	movl   $0x8014adc0,(%esp)
80103fd3:	e8 e8 04 00 00       	call   801044c0 <release>
        return pid;
80103fd8:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103fdb:	8d 65 f8             	lea    -0x8(%ebp),%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80103fde:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103fe0:	5b                   	pop    %ebx
80103fe1:	5e                   	pop    %esi
80103fe2:	5d                   	pop    %ebp
80103fe3:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
80103fe4:	83 ec 0c             	sub    $0xc,%esp
80103fe7:	68 c0 ad 14 80       	push   $0x8014adc0
80103fec:	e8 cf 04 00 00       	call   801044c0 <release>
      return -1;
80103ff1:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103ff4:	8d 65 f8             	lea    -0x8(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
80103ff7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103ffc:	5b                   	pop    %ebx
80103ffd:	5e                   	pop    %esi
80103ffe:	5d                   	pop    %ebp
80103fff:	c3                   	ret    

80104000 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	53                   	push   %ebx
80104004:	83 ec 10             	sub    $0x10,%esp
80104007:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010400a:	68 c0 ad 14 80       	push   $0x8014adc0
8010400f:	e8 cc 02 00 00       	call   801042e0 <acquire>
80104014:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104017:	b8 f4 ad 14 80       	mov    $0x8014adf4,%eax
8010401c:	eb 0c                	jmp    8010402a <wakeup+0x2a>
8010401e:	66 90                	xchg   %ax,%ax
80104020:	83 c0 7c             	add    $0x7c,%eax
80104023:	3d f4 cc 14 80       	cmp    $0x8014ccf4,%eax
80104028:	74 1c                	je     80104046 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010402a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010402e:	75 f0                	jne    80104020 <wakeup+0x20>
80104030:	3b 58 20             	cmp    0x20(%eax),%ebx
80104033:	75 eb                	jne    80104020 <wakeup+0x20>
      p->state = RUNNABLE;
80104035:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010403c:	83 c0 7c             	add    $0x7c,%eax
8010403f:	3d f4 cc 14 80       	cmp    $0x8014ccf4,%eax
80104044:	75 e4                	jne    8010402a <wakeup+0x2a>
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80104046:	c7 45 08 c0 ad 14 80 	movl   $0x8014adc0,0x8(%ebp)
}
8010404d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104050:	c9                   	leave  
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80104051:	e9 6a 04 00 00       	jmp    801044c0 <release>
80104056:	8d 76 00             	lea    0x0(%esi),%esi
80104059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104060 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104060:	55                   	push   %ebp
80104061:	89 e5                	mov    %esp,%ebp
80104063:	53                   	push   %ebx
80104064:	83 ec 10             	sub    $0x10,%esp
80104067:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010406a:	68 c0 ad 14 80       	push   $0x8014adc0
8010406f:	e8 6c 02 00 00       	call   801042e0 <acquire>
80104074:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104077:	b8 f4 ad 14 80       	mov    $0x8014adf4,%eax
8010407c:	eb 0c                	jmp    8010408a <kill+0x2a>
8010407e:	66 90                	xchg   %ax,%ax
80104080:	83 c0 7c             	add    $0x7c,%eax
80104083:	3d f4 cc 14 80       	cmp    $0x8014ccf4,%eax
80104088:	74 3e                	je     801040c8 <kill+0x68>
    if(p->pid == pid){
8010408a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010408d:	75 f1                	jne    80104080 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010408f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80104093:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010409a:	74 1c                	je     801040b8 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
8010409c:	83 ec 0c             	sub    $0xc,%esp
8010409f:	68 c0 ad 14 80       	push   $0x8014adc0
801040a4:	e8 17 04 00 00       	call   801044c0 <release>
      return 0;
801040a9:	83 c4 10             	add    $0x10,%esp
801040ac:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801040ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040b1:	c9                   	leave  
801040b2:	c3                   	ret    
801040b3:	90                   	nop
801040b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
801040b8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801040bf:	eb db                	jmp    8010409c <kill+0x3c>
801040c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
801040c8:	83 ec 0c             	sub    $0xc,%esp
801040cb:	68 c0 ad 14 80       	push   $0x8014adc0
801040d0:	e8 eb 03 00 00       	call   801044c0 <release>
  return -1;
801040d5:	83 c4 10             	add    $0x10,%esp
801040d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801040dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040e0:	c9                   	leave  
801040e1:	c3                   	ret    
801040e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801040f0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801040f0:	55                   	push   %ebp
801040f1:	89 e5                	mov    %esp,%ebp
801040f3:	57                   	push   %edi
801040f4:	56                   	push   %esi
801040f5:	53                   	push   %ebx
801040f6:	8d 75 e8             	lea    -0x18(%ebp),%esi
801040f9:	bb 60 ae 14 80       	mov    $0x8014ae60,%ebx
801040fe:	83 ec 3c             	sub    $0x3c,%esp
80104101:	eb 24                	jmp    80104127 <procdump+0x37>
80104103:	90                   	nop
80104104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104108:	83 ec 0c             	sub    $0xc,%esp
8010410b:	68 97 78 10 80       	push   $0x80107897
80104110:	e8 4b c5 ff ff       	call   80100660 <cprintf>
80104115:	83 c4 10             	add    $0x10,%esp
80104118:	83 c3 7c             	add    $0x7c,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010411b:	81 fb 60 cd 14 80    	cmp    $0x8014cd60,%ebx
80104121:	0f 84 81 00 00 00    	je     801041a8 <procdump+0xb8>
    if(p->state == UNUSED)
80104127:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010412a:	85 c0                	test   %eax,%eax
8010412c:	74 ea                	je     80104118 <procdump+0x28>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010412e:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80104131:	ba 40 75 10 80       	mov    $0x80107540,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104136:	77 11                	ja     80104149 <procdump+0x59>
80104138:	8b 14 85 78 75 10 80 	mov    -0x7fef8a88(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
8010413f:	b8 40 75 10 80       	mov    $0x80107540,%eax
80104144:	85 d2                	test   %edx,%edx
80104146:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104149:	53                   	push   %ebx
8010414a:	52                   	push   %edx
8010414b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010414e:	68 44 75 10 80       	push   $0x80107544
80104153:	e8 08 c5 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
80104158:	83 c4 10             	add    $0x10,%esp
8010415b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010415f:	75 a7                	jne    80104108 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104161:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104164:	83 ec 08             	sub    $0x8,%esp
80104167:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010416a:	50                   	push   %eax
8010416b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010416e:	8b 40 0c             	mov    0xc(%eax),%eax
80104171:	83 c0 08             	add    $0x8,%eax
80104174:	50                   	push   %eax
80104175:	e8 36 02 00 00       	call   801043b0 <getcallerpcs>
8010417a:	83 c4 10             	add    $0x10,%esp
8010417d:	8d 76 00             	lea    0x0(%esi),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104180:	8b 17                	mov    (%edi),%edx
80104182:	85 d2                	test   %edx,%edx
80104184:	74 82                	je     80104108 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104186:	83 ec 08             	sub    $0x8,%esp
80104189:	83 c7 04             	add    $0x4,%edi
8010418c:	52                   	push   %edx
8010418d:	68 09 70 10 80       	push   $0x80107009
80104192:	e8 c9 c4 ff ff       	call   80100660 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104197:	83 c4 10             	add    $0x10,%esp
8010419a:	39 f7                	cmp    %esi,%edi
8010419c:	75 e2                	jne    80104180 <procdump+0x90>
8010419e:	e9 65 ff ff ff       	jmp    80104108 <procdump+0x18>
801041a3:	90                   	nop
801041a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
801041a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041ab:	5b                   	pop    %ebx
801041ac:	5e                   	pop    %esi
801041ad:	5f                   	pop    %edi
801041ae:	5d                   	pop    %ebp
801041af:	c3                   	ret    

801041b0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801041b0:	55                   	push   %ebp
801041b1:	89 e5                	mov    %esp,%ebp
801041b3:	53                   	push   %ebx
801041b4:	83 ec 0c             	sub    $0xc,%esp
801041b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801041ba:	68 90 75 10 80       	push   $0x80107590
801041bf:	8d 43 04             	lea    0x4(%ebx),%eax
801041c2:	50                   	push   %eax
801041c3:	e8 f8 00 00 00       	call   801042c0 <initlock>
  lk->name = name;
801041c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801041cb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801041d1:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
801041d4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
801041db:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
801041de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041e1:	c9                   	leave  
801041e2:	c3                   	ret    
801041e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801041e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041f0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801041f0:	55                   	push   %ebp
801041f1:	89 e5                	mov    %esp,%ebp
801041f3:	56                   	push   %esi
801041f4:	53                   	push   %ebx
801041f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801041f8:	83 ec 0c             	sub    $0xc,%esp
801041fb:	8d 73 04             	lea    0x4(%ebx),%esi
801041fe:	56                   	push   %esi
801041ff:	e8 dc 00 00 00       	call   801042e0 <acquire>
  while (lk->locked) {
80104204:	8b 13                	mov    (%ebx),%edx
80104206:	83 c4 10             	add    $0x10,%esp
80104209:	85 d2                	test   %edx,%edx
8010420b:	74 16                	je     80104223 <acquiresleep+0x33>
8010420d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104210:	83 ec 08             	sub    $0x8,%esp
80104213:	56                   	push   %esi
80104214:	53                   	push   %ebx
80104215:	e8 46 fc ff ff       	call   80103e60 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
8010421a:	8b 03                	mov    (%ebx),%eax
8010421c:	83 c4 10             	add    $0x10,%esp
8010421f:	85 c0                	test   %eax,%eax
80104221:	75 ed                	jne    80104210 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104223:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = proc->pid;
80104229:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010422f:	8b 40 10             	mov    0x10(%eax),%eax
80104232:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104235:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104238:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010423b:	5b                   	pop    %ebx
8010423c:	5e                   	pop    %esi
8010423d:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = proc->pid;
  release(&lk->lk);
8010423e:	e9 7d 02 00 00       	jmp    801044c0 <release>
80104243:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104250 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	56                   	push   %esi
80104254:	53                   	push   %ebx
80104255:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104258:	83 ec 0c             	sub    $0xc,%esp
8010425b:	8d 73 04             	lea    0x4(%ebx),%esi
8010425e:	56                   	push   %esi
8010425f:	e8 7c 00 00 00       	call   801042e0 <acquire>
  lk->locked = 0;
80104264:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010426a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104271:	89 1c 24             	mov    %ebx,(%esp)
80104274:	e8 87 fd ff ff       	call   80104000 <wakeup>
  release(&lk->lk);
80104279:	89 75 08             	mov    %esi,0x8(%ebp)
8010427c:	83 c4 10             	add    $0x10,%esp
}
8010427f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104282:	5b                   	pop    %ebx
80104283:	5e                   	pop    %esi
80104284:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104285:	e9 36 02 00 00       	jmp    801044c0 <release>
8010428a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104290 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104290:	55                   	push   %ebp
80104291:	89 e5                	mov    %esp,%ebp
80104293:	56                   	push   %esi
80104294:	53                   	push   %ebx
80104295:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104298:	83 ec 0c             	sub    $0xc,%esp
8010429b:	8d 5e 04             	lea    0x4(%esi),%ebx
8010429e:	53                   	push   %ebx
8010429f:	e8 3c 00 00 00       	call   801042e0 <acquire>
  r = lk->locked;
801042a4:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
801042a6:	89 1c 24             	mov    %ebx,(%esp)
801042a9:	e8 12 02 00 00       	call   801044c0 <release>
  return r;
}
801042ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042b1:	89 f0                	mov    %esi,%eax
801042b3:	5b                   	pop    %ebx
801042b4:	5e                   	pop    %esi
801042b5:	5d                   	pop    %ebp
801042b6:	c3                   	ret    
801042b7:	66 90                	xchg   %ax,%ax
801042b9:	66 90                	xchg   %ax,%ax
801042bb:	66 90                	xchg   %ax,%ax
801042bd:	66 90                	xchg   %ax,%ax
801042bf:	90                   	nop

801042c0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801042c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801042c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
801042cf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
801042d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801042d9:	5d                   	pop    %ebp
801042da:	c3                   	ret    
801042db:	90                   	nop
801042dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801042e0 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801042e0:	55                   	push   %ebp
801042e1:	89 e5                	mov    %esp,%ebp
801042e3:	53                   	push   %ebx
801042e4:	83 ec 04             	sub    $0x4,%esp
801042e7:	9c                   	pushf  
801042e8:	5a                   	pop    %edx
}

static inline void
cli(void)
{
  asm volatile("cli");
801042e9:	fa                   	cli    
{
  int eflags;

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
801042ea:	65 8b 0d 00 00 00 00 	mov    %gs:0x0,%ecx
801042f1:	8b 81 ac 00 00 00    	mov    0xac(%ecx),%eax
801042f7:	85 c0                	test   %eax,%eax
801042f9:	75 0c                	jne    80104307 <acquire+0x27>
    cpu->intena = eflags & FL_IF;
801042fb:	81 e2 00 02 00 00    	and    $0x200,%edx
80104301:	89 91 b0 00 00 00    	mov    %edx,0xb0(%ecx)
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
80104307:	8b 55 08             	mov    0x8(%ebp),%edx

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
    cpu->intena = eflags & FL_IF;
  cpu->ncli += 1;
8010430a:	83 c0 01             	add    $0x1,%eax
8010430d:	89 81 ac 00 00 00    	mov    %eax,0xac(%ecx)

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
80104313:	8b 02                	mov    (%edx),%eax
80104315:	85 c0                	test   %eax,%eax
80104317:	74 05                	je     8010431e <acquire+0x3e>
80104319:	39 4a 08             	cmp    %ecx,0x8(%edx)
8010431c:	74 7a                	je     80104398 <acquire+0xb8>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010431e:	b9 01 00 00 00       	mov    $0x1,%ecx
80104323:	90                   	nop
80104324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104328:	89 c8                	mov    %ecx,%eax
8010432a:	f0 87 02             	lock xchg %eax,(%edx)
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
8010432d:	85 c0                	test   %eax,%eax
8010432f:	75 f7                	jne    80104328 <acquire+0x48>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80104331:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104336:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104339:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010433f:	89 ea                	mov    %ebp,%edx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104341:	89 41 08             	mov    %eax,0x8(%ecx)
  getcallerpcs(&lk, lk->pcs);
80104344:	83 c1 0c             	add    $0xc,%ecx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104347:	31 c0                	xor    %eax,%eax
80104349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104350:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104356:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010435c:	77 1a                	ja     80104378 <acquire+0x98>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010435e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104361:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104364:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104367:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104369:	83 f8 0a             	cmp    $0xa,%eax
8010436c:	75 e2                	jne    80104350 <acquire+0x70>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
  getcallerpcs(&lk, lk->pcs);
}
8010436e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104371:	c9                   	leave  
80104372:	c3                   	ret    
80104373:	90                   	nop
80104374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104378:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010437f:	83 c0 01             	add    $0x1,%eax
80104382:	83 f8 0a             	cmp    $0xa,%eax
80104385:	74 e7                	je     8010436e <acquire+0x8e>
    pcs[i] = 0;
80104387:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010438e:	83 c0 01             	add    $0x1,%eax
80104391:	83 f8 0a             	cmp    $0xa,%eax
80104394:	75 e2                	jne    80104378 <acquire+0x98>
80104396:	eb d6                	jmp    8010436e <acquire+0x8e>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
80104398:	83 ec 0c             	sub    $0xc,%esp
8010439b:	68 9b 75 10 80       	push   $0x8010759b
801043a0:	e8 cb bf ff ff       	call   80100370 <panic>
801043a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043b0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801043b0:	55                   	push   %ebp
801043b1:	89 e5                	mov    %esp,%ebp
801043b3:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801043b4:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801043b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801043ba:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
801043bd:	31 c0                	xor    %eax,%eax
801043bf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801043c0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801043c6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801043cc:	77 1a                	ja     801043e8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801043ce:	8b 5a 04             	mov    0x4(%edx),%ebx
801043d1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801043d4:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801043d7:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801043d9:	83 f8 0a             	cmp    $0xa,%eax
801043dc:	75 e2                	jne    801043c0 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801043de:	5b                   	pop    %ebx
801043df:	5d                   	pop    %ebp
801043e0:	c3                   	ret    
801043e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801043e8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801043ef:	83 c0 01             	add    $0x1,%eax
801043f2:	83 f8 0a             	cmp    $0xa,%eax
801043f5:	74 e7                	je     801043de <getcallerpcs+0x2e>
    pcs[i] = 0;
801043f7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801043fe:	83 c0 01             	add    $0x1,%eax
80104401:	83 f8 0a             	cmp    $0xa,%eax
80104404:	75 e2                	jne    801043e8 <getcallerpcs+0x38>
80104406:	eb d6                	jmp    801043de <getcallerpcs+0x2e>
80104408:	90                   	nop
80104409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104410 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == cpu;
80104416:	8b 02                	mov    (%edx),%eax
80104418:	85 c0                	test   %eax,%eax
8010441a:	74 14                	je     80104430 <holding+0x20>
8010441c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104422:	39 42 08             	cmp    %eax,0x8(%edx)
}
80104425:	5d                   	pop    %ebp

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
80104426:	0f 94 c0             	sete   %al
80104429:	0f b6 c0             	movzbl %al,%eax
}
8010442c:	c3                   	ret    
8010442d:	8d 76 00             	lea    0x0(%esi),%esi
80104430:	31 c0                	xor    %eax,%eax
80104432:	5d                   	pop    %ebp
80104433:	c3                   	ret    
80104434:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010443a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104440 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104443:	9c                   	pushf  
80104444:	59                   	pop    %ecx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104445:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
80104446:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010444d:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80104453:	85 c0                	test   %eax,%eax
80104455:	75 0c                	jne    80104463 <pushcli+0x23>
    cpu->intena = eflags & FL_IF;
80104457:	81 e1 00 02 00 00    	and    $0x200,%ecx
8010445d:	89 8a b0 00 00 00    	mov    %ecx,0xb0(%edx)
  cpu->ncli += 1;
80104463:	83 c0 01             	add    $0x1,%eax
80104466:	89 82 ac 00 00 00    	mov    %eax,0xac(%edx)
}
8010446c:	5d                   	pop    %ebp
8010446d:	c3                   	ret    
8010446e:	66 90                	xchg   %ax,%ax

80104470 <popcli>:

void
popcli(void)
{
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104476:	9c                   	pushf  
80104477:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104478:	f6 c4 02             	test   $0x2,%ah
8010447b:	75 2c                	jne    801044a9 <popcli+0x39>
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
8010447d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104484:	83 aa ac 00 00 00 01 	subl   $0x1,0xac(%edx)
8010448b:	78 0f                	js     8010449c <popcli+0x2c>
    panic("popcli");
  if(cpu->ncli == 0 && cpu->intena)
8010448d:	75 0b                	jne    8010449a <popcli+0x2a>
8010448f:	8b 82 b0 00 00 00    	mov    0xb0(%edx),%eax
80104495:	85 c0                	test   %eax,%eax
80104497:	74 01                	je     8010449a <popcli+0x2a>
}

static inline void
sti(void)
{
  asm volatile("sti");
80104499:	fb                   	sti    
    sti();
}
8010449a:	c9                   	leave  
8010449b:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
    panic("popcli");
8010449c:	83 ec 0c             	sub    $0xc,%esp
8010449f:	68 ba 75 10 80       	push   $0x801075ba
801044a4:	e8 c7 be ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
801044a9:	83 ec 0c             	sub    $0xc,%esp
801044ac:	68 a3 75 10 80       	push   $0x801075a3
801044b1:	e8 ba be ff ff       	call   80100370 <panic>
801044b6:	8d 76 00             	lea    0x0(%esi),%esi
801044b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801044c0 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	83 ec 08             	sub    $0x8,%esp
801044c6:	8b 45 08             	mov    0x8(%ebp),%eax

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
801044c9:	8b 10                	mov    (%eax),%edx
801044cb:	85 d2                	test   %edx,%edx
801044cd:	74 0c                	je     801044db <release+0x1b>
801044cf:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801044d6:	39 50 08             	cmp    %edx,0x8(%eax)
801044d9:	74 15                	je     801044f0 <release+0x30>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
801044db:	83 ec 0c             	sub    $0xc,%esp
801044de:	68 c1 75 10 80       	push   $0x801075c1
801044e3:	e8 88 be ff ff       	call   80100370 <panic>
801044e8:	90                   	nop
801044e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  lk->pcs[0] = 0;
801044f0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
801044f7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
801044fe:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104503:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
}
80104509:	c9                   	leave  
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
8010450a:	e9 61 ff ff ff       	jmp    80104470 <popcli>
8010450f:	90                   	nop

80104510 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	57                   	push   %edi
80104514:	53                   	push   %ebx
80104515:	8b 55 08             	mov    0x8(%ebp),%edx
80104518:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010451b:	f6 c2 03             	test   $0x3,%dl
8010451e:	75 05                	jne    80104525 <memset+0x15>
80104520:	f6 c1 03             	test   $0x3,%cl
80104523:	74 13                	je     80104538 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104525:	89 d7                	mov    %edx,%edi
80104527:	8b 45 0c             	mov    0xc(%ebp),%eax
8010452a:	fc                   	cld    
8010452b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010452d:	5b                   	pop    %ebx
8010452e:	89 d0                	mov    %edx,%eax
80104530:	5f                   	pop    %edi
80104531:	5d                   	pop    %ebp
80104532:	c3                   	ret    
80104533:	90                   	nop
80104534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104538:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
8010453c:	c1 e9 02             	shr    $0x2,%ecx
8010453f:	89 fb                	mov    %edi,%ebx
80104541:	89 f8                	mov    %edi,%eax
80104543:	c1 e3 18             	shl    $0x18,%ebx
80104546:	c1 e0 10             	shl    $0x10,%eax
80104549:	09 d8                	or     %ebx,%eax
8010454b:	09 f8                	or     %edi,%eax
8010454d:	c1 e7 08             	shl    $0x8,%edi
80104550:	09 f8                	or     %edi,%eax
80104552:	89 d7                	mov    %edx,%edi
80104554:	fc                   	cld    
80104555:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104557:	5b                   	pop    %ebx
80104558:	89 d0                	mov    %edx,%eax
8010455a:	5f                   	pop    %edi
8010455b:	5d                   	pop    %ebp
8010455c:	c3                   	ret    
8010455d:	8d 76 00             	lea    0x0(%esi),%esi

80104560 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
80104563:	57                   	push   %edi
80104564:	56                   	push   %esi
80104565:	8b 45 10             	mov    0x10(%ebp),%eax
80104568:	53                   	push   %ebx
80104569:	8b 75 0c             	mov    0xc(%ebp),%esi
8010456c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010456f:	85 c0                	test   %eax,%eax
80104571:	74 29                	je     8010459c <memcmp+0x3c>
    if(*s1 != *s2)
80104573:	0f b6 13             	movzbl (%ebx),%edx
80104576:	0f b6 0e             	movzbl (%esi),%ecx
80104579:	38 d1                	cmp    %dl,%cl
8010457b:	75 2b                	jne    801045a8 <memcmp+0x48>
8010457d:	8d 78 ff             	lea    -0x1(%eax),%edi
80104580:	31 c0                	xor    %eax,%eax
80104582:	eb 14                	jmp    80104598 <memcmp+0x38>
80104584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104588:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
8010458d:	83 c0 01             	add    $0x1,%eax
80104590:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104594:	38 ca                	cmp    %cl,%dl
80104596:	75 10                	jne    801045a8 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104598:	39 f8                	cmp    %edi,%eax
8010459a:	75 ec                	jne    80104588 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010459c:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010459d:	31 c0                	xor    %eax,%eax
}
8010459f:	5e                   	pop    %esi
801045a0:	5f                   	pop    %edi
801045a1:	5d                   	pop    %ebp
801045a2:	c3                   	ret    
801045a3:	90                   	nop
801045a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
801045a8:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
801045ab:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
801045ac:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
801045ae:	5e                   	pop    %esi
801045af:	5f                   	pop    %edi
801045b0:	5d                   	pop    %ebp
801045b1:	c3                   	ret    
801045b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045c0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
801045c3:	56                   	push   %esi
801045c4:	53                   	push   %ebx
801045c5:	8b 45 08             	mov    0x8(%ebp),%eax
801045c8:	8b 75 0c             	mov    0xc(%ebp),%esi
801045cb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801045ce:	39 c6                	cmp    %eax,%esi
801045d0:	73 2e                	jae    80104600 <memmove+0x40>
801045d2:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
801045d5:	39 c8                	cmp    %ecx,%eax
801045d7:	73 27                	jae    80104600 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
801045d9:	85 db                	test   %ebx,%ebx
801045db:	8d 53 ff             	lea    -0x1(%ebx),%edx
801045de:	74 17                	je     801045f7 <memmove+0x37>
      *--d = *--s;
801045e0:	29 d9                	sub    %ebx,%ecx
801045e2:	89 cb                	mov    %ecx,%ebx
801045e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045e8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801045ec:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801045ef:	83 ea 01             	sub    $0x1,%edx
801045f2:	83 fa ff             	cmp    $0xffffffff,%edx
801045f5:	75 f1                	jne    801045e8 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801045f7:	5b                   	pop    %ebx
801045f8:	5e                   	pop    %esi
801045f9:	5d                   	pop    %ebp
801045fa:	c3                   	ret    
801045fb:	90                   	nop
801045fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104600:	31 d2                	xor    %edx,%edx
80104602:	85 db                	test   %ebx,%ebx
80104604:	74 f1                	je     801045f7 <memmove+0x37>
80104606:	8d 76 00             	lea    0x0(%esi),%esi
80104609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
80104610:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104614:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104617:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010461a:	39 d3                	cmp    %edx,%ebx
8010461c:	75 f2                	jne    80104610 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
8010461e:	5b                   	pop    %ebx
8010461f:	5e                   	pop    %esi
80104620:	5d                   	pop    %ebp
80104621:	c3                   	ret    
80104622:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104630 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104633:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104634:	eb 8a                	jmp    801045c0 <memmove>
80104636:	8d 76 00             	lea    0x0(%esi),%esi
80104639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104640 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	57                   	push   %edi
80104644:	56                   	push   %esi
80104645:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104648:	53                   	push   %ebx
80104649:	8b 7d 08             	mov    0x8(%ebp),%edi
8010464c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010464f:	85 c9                	test   %ecx,%ecx
80104651:	74 37                	je     8010468a <strncmp+0x4a>
80104653:	0f b6 17             	movzbl (%edi),%edx
80104656:	0f b6 1e             	movzbl (%esi),%ebx
80104659:	84 d2                	test   %dl,%dl
8010465b:	74 3f                	je     8010469c <strncmp+0x5c>
8010465d:	38 d3                	cmp    %dl,%bl
8010465f:	75 3b                	jne    8010469c <strncmp+0x5c>
80104661:	8d 47 01             	lea    0x1(%edi),%eax
80104664:	01 cf                	add    %ecx,%edi
80104666:	eb 1b                	jmp    80104683 <strncmp+0x43>
80104668:	90                   	nop
80104669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104670:	0f b6 10             	movzbl (%eax),%edx
80104673:	84 d2                	test   %dl,%dl
80104675:	74 21                	je     80104698 <strncmp+0x58>
80104677:	0f b6 19             	movzbl (%ecx),%ebx
8010467a:	83 c0 01             	add    $0x1,%eax
8010467d:	89 ce                	mov    %ecx,%esi
8010467f:	38 da                	cmp    %bl,%dl
80104681:	75 19                	jne    8010469c <strncmp+0x5c>
80104683:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
80104685:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104688:	75 e6                	jne    80104670 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
8010468a:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
8010468b:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
8010468d:	5e                   	pop    %esi
8010468e:	5f                   	pop    %edi
8010468f:	5d                   	pop    %ebp
80104690:	c3                   	ret    
80104691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104698:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
8010469c:	0f b6 c2             	movzbl %dl,%eax
8010469f:	29 d8                	sub    %ebx,%eax
}
801046a1:	5b                   	pop    %ebx
801046a2:	5e                   	pop    %esi
801046a3:	5f                   	pop    %edi
801046a4:	5d                   	pop    %ebp
801046a5:	c3                   	ret    
801046a6:	8d 76 00             	lea    0x0(%esi),%esi
801046a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046b0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	56                   	push   %esi
801046b4:	53                   	push   %ebx
801046b5:	8b 45 08             	mov    0x8(%ebp),%eax
801046b8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801046bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801046be:	89 c2                	mov    %eax,%edx
801046c0:	eb 19                	jmp    801046db <strncpy+0x2b>
801046c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801046c8:	83 c3 01             	add    $0x1,%ebx
801046cb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801046cf:	83 c2 01             	add    $0x1,%edx
801046d2:	84 c9                	test   %cl,%cl
801046d4:	88 4a ff             	mov    %cl,-0x1(%edx)
801046d7:	74 09                	je     801046e2 <strncpy+0x32>
801046d9:	89 f1                	mov    %esi,%ecx
801046db:	85 c9                	test   %ecx,%ecx
801046dd:	8d 71 ff             	lea    -0x1(%ecx),%esi
801046e0:	7f e6                	jg     801046c8 <strncpy+0x18>
    ;
  while(n-- > 0)
801046e2:	31 c9                	xor    %ecx,%ecx
801046e4:	85 f6                	test   %esi,%esi
801046e6:	7e 17                	jle    801046ff <strncpy+0x4f>
801046e8:	90                   	nop
801046e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801046f0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801046f4:	89 f3                	mov    %esi,%ebx
801046f6:	83 c1 01             	add    $0x1,%ecx
801046f9:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801046fb:	85 db                	test   %ebx,%ebx
801046fd:	7f f1                	jg     801046f0 <strncpy+0x40>
    *s++ = 0;
  return os;
}
801046ff:	5b                   	pop    %ebx
80104700:	5e                   	pop    %esi
80104701:	5d                   	pop    %ebp
80104702:	c3                   	ret    
80104703:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104710 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	56                   	push   %esi
80104714:	53                   	push   %ebx
80104715:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104718:	8b 45 08             	mov    0x8(%ebp),%eax
8010471b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010471e:	85 c9                	test   %ecx,%ecx
80104720:	7e 26                	jle    80104748 <safestrcpy+0x38>
80104722:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104726:	89 c1                	mov    %eax,%ecx
80104728:	eb 17                	jmp    80104741 <safestrcpy+0x31>
8010472a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104730:	83 c2 01             	add    $0x1,%edx
80104733:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104737:	83 c1 01             	add    $0x1,%ecx
8010473a:	84 db                	test   %bl,%bl
8010473c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010473f:	74 04                	je     80104745 <safestrcpy+0x35>
80104741:	39 f2                	cmp    %esi,%edx
80104743:	75 eb                	jne    80104730 <safestrcpy+0x20>
    ;
  *s = 0;
80104745:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104748:	5b                   	pop    %ebx
80104749:	5e                   	pop    %esi
8010474a:	5d                   	pop    %ebp
8010474b:	c3                   	ret    
8010474c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104750 <strlen>:

int
strlen(const char *s)
{
80104750:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104751:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104753:	89 e5                	mov    %esp,%ebp
80104755:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104758:	80 3a 00             	cmpb   $0x0,(%edx)
8010475b:	74 0c                	je     80104769 <strlen+0x19>
8010475d:	8d 76 00             	lea    0x0(%esi),%esi
80104760:	83 c0 01             	add    $0x1,%eax
80104763:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104767:	75 f7                	jne    80104760 <strlen+0x10>
    ;
  return n;
}
80104769:	5d                   	pop    %ebp
8010476a:	c3                   	ret    

8010476b <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010476b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010476f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104773:	55                   	push   %ebp
  pushl %ebx
80104774:	53                   	push   %ebx
  pushl %esi
80104775:	56                   	push   %esi
  pushl %edi
80104776:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104777:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104779:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010477b:	5f                   	pop    %edi
  popl %esi
8010477c:	5e                   	pop    %esi
  popl %ebx
8010477d:	5b                   	pop    %ebx
  popl %ebp
8010477e:	5d                   	pop    %ebp
  ret
8010477f:	c3                   	ret    

80104780 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104780:	55                   	push   %ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80104781:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104788:	89 e5                	mov    %esp,%ebp
8010478a:	8b 45 08             	mov    0x8(%ebp),%eax
  if(addr >= proc->sz || addr+4 > proc->sz)
8010478d:	8b 12                	mov    (%edx),%edx
8010478f:	39 c2                	cmp    %eax,%edx
80104791:	76 15                	jbe    801047a8 <fetchint+0x28>
80104793:	8d 48 04             	lea    0x4(%eax),%ecx
80104796:	39 ca                	cmp    %ecx,%edx
80104798:	72 0e                	jb     801047a8 <fetchint+0x28>
    return -1;
  *ip = *(int*)(addr);
8010479a:	8b 10                	mov    (%eax),%edx
8010479c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010479f:	89 10                	mov    %edx,(%eax)
  return 0;
801047a1:	31 c0                	xor    %eax,%eax
}
801047a3:	5d                   	pop    %ebp
801047a4:	c3                   	ret    
801047a5:	8d 76 00             	lea    0x0(%esi),%esi
// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
801047a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  *ip = *(int*)(addr);
  return 0;
}
801047ad:	5d                   	pop    %ebp
801047ae:	c3                   	ret    
801047af:	90                   	nop

801047b0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801047b0:	55                   	push   %ebp
  char *s, *ep;

  if(addr >= proc->sz)
801047b1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801047b7:	89 e5                	mov    %esp,%ebp
801047b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  char *s, *ep;

  if(addr >= proc->sz)
801047bc:	39 08                	cmp    %ecx,(%eax)
801047be:	76 2c                	jbe    801047ec <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
801047c0:	8b 55 0c             	mov    0xc(%ebp),%edx
801047c3:	89 c8                	mov    %ecx,%eax
801047c5:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
801047c7:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801047ce:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
801047d0:	39 d1                	cmp    %edx,%ecx
801047d2:	73 18                	jae    801047ec <fetchstr+0x3c>
    if(*s == 0)
801047d4:	80 39 00             	cmpb   $0x0,(%ecx)
801047d7:	75 0c                	jne    801047e5 <fetchstr+0x35>
801047d9:	eb 1d                	jmp    801047f8 <fetchstr+0x48>
801047db:	90                   	nop
801047dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047e0:	80 38 00             	cmpb   $0x0,(%eax)
801047e3:	74 13                	je     801047f8 <fetchstr+0x48>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
801047e5:	83 c0 01             	add    $0x1,%eax
801047e8:	39 c2                	cmp    %eax,%edx
801047ea:	77 f4                	ja     801047e0 <fetchstr+0x30>
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
    return -1;
801047ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
      return s - *pp;
  return -1;
}
801047f1:	5d                   	pop    %ebp
801047f2:	c3                   	ret    
801047f3:	90                   	nop
801047f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
      return s - *pp;
801047f8:	29 c8                	sub    %ecx,%eax
  return -1;
}
801047fa:	5d                   	pop    %ebp
801047fb:	c3                   	ret    
801047fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104800 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104800:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
}

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104807:	55                   	push   %ebp
80104808:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
8010480a:	8b 42 18             	mov    0x18(%edx),%eax
8010480d:	8b 4d 08             	mov    0x8(%ebp),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104810:	8b 12                	mov    (%edx),%edx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104812:	8b 40 44             	mov    0x44(%eax),%eax
80104815:	8d 04 88             	lea    (%eax,%ecx,4),%eax
80104818:	8d 48 04             	lea    0x4(%eax),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
8010481b:	39 d1                	cmp    %edx,%ecx
8010481d:	73 19                	jae    80104838 <argint+0x38>
8010481f:	8d 48 08             	lea    0x8(%eax),%ecx
80104822:	39 ca                	cmp    %ecx,%edx
80104824:	72 12                	jb     80104838 <argint+0x38>
    return -1;
  *ip = *(int*)(addr);
80104826:	8b 50 04             	mov    0x4(%eax),%edx
80104829:	8b 45 0c             	mov    0xc(%ebp),%eax
8010482c:	89 10                	mov    %edx,(%eax)
  return 0;
8010482e:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
}
80104830:	5d                   	pop    %ebp
80104831:	c3                   	ret    
80104832:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
80104838:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
}
8010483d:	5d                   	pop    %ebp
8010483e:	c3                   	ret    
8010483f:	90                   	nop

80104840 <argptr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104840:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104846:	55                   	push   %ebp
80104847:	89 e5                	mov    %esp,%ebp
80104849:	56                   	push   %esi
8010484a:	53                   	push   %ebx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
8010484b:	8b 48 18             	mov    0x18(%eax),%ecx
8010484e:	8b 5d 08             	mov    0x8(%ebp),%ebx
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104851:	8b 55 10             	mov    0x10(%ebp),%edx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104854:	8b 49 44             	mov    0x44(%ecx),%ecx
80104857:	8d 1c 99             	lea    (%ecx,%ebx,4),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
8010485a:	8b 08                	mov    (%eax),%ecx
argptr(int n, char **pp, int size)
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
8010485c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104861:	8d 73 04             	lea    0x4(%ebx),%esi

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104864:	39 ce                	cmp    %ecx,%esi
80104866:	73 1f                	jae    80104887 <argptr+0x47>
80104868:	8d 73 08             	lea    0x8(%ebx),%esi
8010486b:	39 f1                	cmp    %esi,%ecx
8010486d:	72 18                	jb     80104887 <argptr+0x47>
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= proc->sz || (uint)i+size > proc->sz)
8010486f:	85 d2                	test   %edx,%edx
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
  *ip = *(int*)(addr);
80104871:	8b 5b 04             	mov    0x4(%ebx),%ebx
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= proc->sz || (uint)i+size > proc->sz)
80104874:	78 11                	js     80104887 <argptr+0x47>
80104876:	39 cb                	cmp    %ecx,%ebx
80104878:	73 0d                	jae    80104887 <argptr+0x47>
8010487a:	01 da                	add    %ebx,%edx
8010487c:	39 ca                	cmp    %ecx,%edx
8010487e:	77 07                	ja     80104887 <argptr+0x47>
    return -1;
  *pp = (char*)i;
80104880:	8b 45 0c             	mov    0xc(%ebp),%eax
80104883:	89 18                	mov    %ebx,(%eax)
  return 0;
80104885:	31 c0                	xor    %eax,%eax
}
80104887:	5b                   	pop    %ebx
80104888:	5e                   	pop    %esi
80104889:	5d                   	pop    %ebp
8010488a:	c3                   	ret    
8010488b:	90                   	nop
8010488c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104890 <argstr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104890:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104896:	55                   	push   %ebp
80104897:	89 e5                	mov    %esp,%ebp

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104899:	8b 50 18             	mov    0x18(%eax),%edx
8010489c:	8b 4d 08             	mov    0x8(%ebp),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
8010489f:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801048a1:	8b 52 44             	mov    0x44(%edx),%edx
801048a4:	8d 14 8a             	lea    (%edx,%ecx,4),%edx
801048a7:	8d 4a 04             	lea    0x4(%edx),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
801048aa:	39 c1                	cmp    %eax,%ecx
801048ac:	73 07                	jae    801048b5 <argstr+0x25>
801048ae:	8d 4a 08             	lea    0x8(%edx),%ecx
801048b1:	39 c8                	cmp    %ecx,%eax
801048b3:	73 0b                	jae    801048c0 <argstr+0x30>
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
801048b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
801048ba:	5d                   	pop    %ebp
801048bb:	c3                   	ret    
801048bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
  *ip = *(int*)(addr);
801048c0:	8b 4a 04             	mov    0x4(%edx),%ecx
int
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
801048c3:	39 c1                	cmp    %eax,%ecx
801048c5:	73 ee                	jae    801048b5 <argstr+0x25>
    return -1;
  *pp = (char*)addr;
801048c7:	8b 55 0c             	mov    0xc(%ebp),%edx
801048ca:	89 c8                	mov    %ecx,%eax
801048cc:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
801048ce:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801048d5:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
801048d7:	39 d1                	cmp    %edx,%ecx
801048d9:	73 da                	jae    801048b5 <argstr+0x25>
    if(*s == 0)
801048db:	80 39 00             	cmpb   $0x0,(%ecx)
801048de:	75 0d                	jne    801048ed <argstr+0x5d>
801048e0:	eb 1e                	jmp    80104900 <argstr+0x70>
801048e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048e8:	80 38 00             	cmpb   $0x0,(%eax)
801048eb:	74 13                	je     80104900 <argstr+0x70>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
801048ed:	83 c0 01             	add    $0x1,%eax
801048f0:	39 c2                	cmp    %eax,%edx
801048f2:	77 f4                	ja     801048e8 <argstr+0x58>
801048f4:	eb bf                	jmp    801048b5 <argstr+0x25>
801048f6:	8d 76 00             	lea    0x0(%esi),%esi
801048f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(*s == 0)
      return s - *pp;
80104900:	29 c8                	sub    %ecx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104902:	5d                   	pop    %ebp
80104903:	c3                   	ret    
80104904:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010490a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104910 <syscall>:
[SYS_freemem] sys_freemem,
};

void
syscall(void)
{
80104910:	55                   	push   %ebp
80104911:	89 e5                	mov    %esp,%ebp
80104913:	53                   	push   %ebx
80104914:	83 ec 04             	sub    $0x4,%esp
  int num;

  num = proc->tf->eax;
80104917:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010491e:	8b 5a 18             	mov    0x18(%edx),%ebx
80104921:	8b 43 1c             	mov    0x1c(%ebx),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104924:	8d 48 ff             	lea    -0x1(%eax),%ecx
80104927:	83 f9 16             	cmp    $0x16,%ecx
8010492a:	77 1c                	ja     80104948 <syscall+0x38>
8010492c:	8b 0c 85 00 76 10 80 	mov    -0x7fef8a00(,%eax,4),%ecx
80104933:	85 c9                	test   %ecx,%ecx
80104935:	74 11                	je     80104948 <syscall+0x38>
    proc->tf->eax = syscalls[num]();
80104937:	ff d1                	call   *%ecx
80104939:	89 43 1c             	mov    %eax,0x1c(%ebx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
  }
}
8010493c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010493f:	c9                   	leave  
80104940:	c3                   	ret    
80104941:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104948:	50                   	push   %eax
            proc->pid, proc->name, num);
80104949:	8d 42 6c             	lea    0x6c(%edx),%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
8010494c:	50                   	push   %eax
8010494d:	ff 72 10             	pushl  0x10(%edx)
80104950:	68 c9 75 10 80       	push   $0x801075c9
80104955:	e8 06 bd ff ff       	call   80100660 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
8010495a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104960:	83 c4 10             	add    $0x10,%esp
80104963:	8b 40 18             	mov    0x18(%eax),%eax
80104966:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
8010496d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104970:	c9                   	leave  
80104971:	c3                   	ret    
80104972:	66 90                	xchg   %ax,%ax
80104974:	66 90                	xchg   %ax,%ax
80104976:	66 90                	xchg   %ax,%ax
80104978:	66 90                	xchg   %ax,%ax
8010497a:	66 90                	xchg   %ax,%ax
8010497c:	66 90                	xchg   %ax,%ax
8010497e:	66 90                	xchg   %ax,%ax

80104980 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	57                   	push   %edi
80104984:	56                   	push   %esi
80104985:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104986:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104989:	83 ec 44             	sub    $0x44,%esp
8010498c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010498f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104992:	56                   	push   %esi
80104993:	50                   	push   %eax
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104994:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104997:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010499a:	e8 d1 d4 ff ff       	call   80101e70 <nameiparent>
8010499f:	83 c4 10             	add    $0x10,%esp
801049a2:	85 c0                	test   %eax,%eax
801049a4:	0f 84 f6 00 00 00    	je     80104aa0 <create+0x120>
    return 0;
  ilock(dp);
801049aa:	83 ec 0c             	sub    $0xc,%esp
801049ad:	89 c7                	mov    %eax,%edi
801049af:	50                   	push   %eax
801049b0:	e8 6b cc ff ff       	call   80101620 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801049b5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
801049b8:	83 c4 0c             	add    $0xc,%esp
801049bb:	50                   	push   %eax
801049bc:	56                   	push   %esi
801049bd:	57                   	push   %edi
801049be:	e8 6d d1 ff ff       	call   80101b30 <dirlookup>
801049c3:	83 c4 10             	add    $0x10,%esp
801049c6:	85 c0                	test   %eax,%eax
801049c8:	89 c3                	mov    %eax,%ebx
801049ca:	74 54                	je     80104a20 <create+0xa0>
    iunlockput(dp);
801049cc:	83 ec 0c             	sub    $0xc,%esp
801049cf:	57                   	push   %edi
801049d0:	e8 bb ce ff ff       	call   80101890 <iunlockput>
    ilock(ip);
801049d5:	89 1c 24             	mov    %ebx,(%esp)
801049d8:	e8 43 cc ff ff       	call   80101620 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801049dd:	83 c4 10             	add    $0x10,%esp
801049e0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
801049e5:	75 19                	jne    80104a00 <create+0x80>
801049e7:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
801049ec:	89 d8                	mov    %ebx,%eax
801049ee:	75 10                	jne    80104a00 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801049f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801049f3:	5b                   	pop    %ebx
801049f4:	5e                   	pop    %esi
801049f5:	5f                   	pop    %edi
801049f6:	5d                   	pop    %ebp
801049f7:	c3                   	ret    
801049f8:	90                   	nop
801049f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80104a00:	83 ec 0c             	sub    $0xc,%esp
80104a03:	53                   	push   %ebx
80104a04:	e8 87 ce ff ff       	call   80101890 <iunlockput>
    return 0;
80104a09:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104a0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
80104a0f:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104a11:	5b                   	pop    %ebx
80104a12:	5e                   	pop    %esi
80104a13:	5f                   	pop    %edi
80104a14:	5d                   	pop    %ebp
80104a15:	c3                   	ret    
80104a16:	8d 76 00             	lea    0x0(%esi),%esi
80104a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80104a20:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104a24:	83 ec 08             	sub    $0x8,%esp
80104a27:	50                   	push   %eax
80104a28:	ff 37                	pushl  (%edi)
80104a2a:	e8 81 ca ff ff       	call   801014b0 <ialloc>
80104a2f:	83 c4 10             	add    $0x10,%esp
80104a32:	85 c0                	test   %eax,%eax
80104a34:	89 c3                	mov    %eax,%ebx
80104a36:	0f 84 cc 00 00 00    	je     80104b08 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
80104a3c:	83 ec 0c             	sub    $0xc,%esp
80104a3f:	50                   	push   %eax
80104a40:	e8 db cb ff ff       	call   80101620 <ilock>
  ip->major = major;
80104a45:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104a49:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
80104a4d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104a51:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
80104a55:	b8 01 00 00 00       	mov    $0x1,%eax
80104a5a:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
80104a5e:	89 1c 24             	mov    %ebx,(%esp)
80104a61:	e8 0a cb ff ff       	call   80101570 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80104a66:	83 c4 10             	add    $0x10,%esp
80104a69:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104a6e:	74 40                	je     80104ab0 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80104a70:	83 ec 04             	sub    $0x4,%esp
80104a73:	ff 73 04             	pushl  0x4(%ebx)
80104a76:	56                   	push   %esi
80104a77:	57                   	push   %edi
80104a78:	e8 13 d3 ff ff       	call   80101d90 <dirlink>
80104a7d:	83 c4 10             	add    $0x10,%esp
80104a80:	85 c0                	test   %eax,%eax
80104a82:	78 77                	js     80104afb <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
80104a84:	83 ec 0c             	sub    $0xc,%esp
80104a87:	57                   	push   %edi
80104a88:	e8 03 ce ff ff       	call   80101890 <iunlockput>

  return ip;
80104a8d:	83 c4 10             	add    $0x10,%esp
}
80104a90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
80104a93:	89 d8                	mov    %ebx,%eax
}
80104a95:	5b                   	pop    %ebx
80104a96:	5e                   	pop    %esi
80104a97:	5f                   	pop    %edi
80104a98:	5d                   	pop    %ebp
80104a99:	c3                   	ret    
80104a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80104aa0:	31 c0                	xor    %eax,%eax
80104aa2:	e9 49 ff ff ff       	jmp    801049f0 <create+0x70>
80104aa7:	89 f6                	mov    %esi,%esi
80104aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80104ab0:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104ab5:	83 ec 0c             	sub    $0xc,%esp
80104ab8:	57                   	push   %edi
80104ab9:	e8 b2 ca ff ff       	call   80101570 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104abe:	83 c4 0c             	add    $0xc,%esp
80104ac1:	ff 73 04             	pushl  0x4(%ebx)
80104ac4:	68 7c 76 10 80       	push   $0x8010767c
80104ac9:	53                   	push   %ebx
80104aca:	e8 c1 d2 ff ff       	call   80101d90 <dirlink>
80104acf:	83 c4 10             	add    $0x10,%esp
80104ad2:	85 c0                	test   %eax,%eax
80104ad4:	78 18                	js     80104aee <create+0x16e>
80104ad6:	83 ec 04             	sub    $0x4,%esp
80104ad9:	ff 77 04             	pushl  0x4(%edi)
80104adc:	68 7b 76 10 80       	push   $0x8010767b
80104ae1:	53                   	push   %ebx
80104ae2:	e8 a9 d2 ff ff       	call   80101d90 <dirlink>
80104ae7:	83 c4 10             	add    $0x10,%esp
80104aea:	85 c0                	test   %eax,%eax
80104aec:	79 82                	jns    80104a70 <create+0xf0>
      panic("create dots");
80104aee:	83 ec 0c             	sub    $0xc,%esp
80104af1:	68 6f 76 10 80       	push   $0x8010766f
80104af6:	e8 75 b8 ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
80104afb:	83 ec 0c             	sub    $0xc,%esp
80104afe:	68 7e 76 10 80       	push   $0x8010767e
80104b03:	e8 68 b8 ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80104b08:	83 ec 0c             	sub    $0xc,%esp
80104b0b:	68 60 76 10 80       	push   $0x80107660
80104b10:	e8 5b b8 ff ff       	call   80100370 <panic>
80104b15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b20 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	56                   	push   %esi
80104b24:	53                   	push   %ebx
80104b25:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104b27:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104b2a:	89 d3                	mov    %edx,%ebx
80104b2c:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104b2f:	50                   	push   %eax
80104b30:	6a 00                	push   $0x0
80104b32:	e8 c9 fc ff ff       	call   80104800 <argint>
80104b37:	83 c4 10             	add    $0x10,%esp
80104b3a:	85 c0                	test   %eax,%eax
80104b3c:	78 3a                	js     80104b78 <argfd.constprop.0+0x58>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80104b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b41:	83 f8 0f             	cmp    $0xf,%eax
80104b44:	77 32                	ja     80104b78 <argfd.constprop.0+0x58>
80104b46:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104b4d:	8b 54 82 28          	mov    0x28(%edx,%eax,4),%edx
80104b51:	85 d2                	test   %edx,%edx
80104b53:	74 23                	je     80104b78 <argfd.constprop.0+0x58>
    return -1;
  if(pfd)
80104b55:	85 f6                	test   %esi,%esi
80104b57:	74 02                	je     80104b5b <argfd.constprop.0+0x3b>
    *pfd = fd;
80104b59:	89 06                	mov    %eax,(%esi)
  if(pf)
80104b5b:	85 db                	test   %ebx,%ebx
80104b5d:	74 11                	je     80104b70 <argfd.constprop.0+0x50>
    *pf = f;
80104b5f:	89 13                	mov    %edx,(%ebx)
  return 0;
80104b61:	31 c0                	xor    %eax,%eax
}
80104b63:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b66:	5b                   	pop    %ebx
80104b67:	5e                   	pop    %esi
80104b68:	5d                   	pop    %ebp
80104b69:	c3                   	ret    
80104b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80104b70:	31 c0                	xor    %eax,%eax
80104b72:	eb ef                	jmp    80104b63 <argfd.constprop.0+0x43>
80104b74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80104b78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b7d:	eb e4                	jmp    80104b63 <argfd.constprop.0+0x43>
80104b7f:	90                   	nop

80104b80 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104b80:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104b81:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80104b83:	89 e5                	mov    %esp,%ebp
80104b85:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104b86:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
80104b89:	83 ec 14             	sub    $0x14,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104b8c:	e8 8f ff ff ff       	call   80104b20 <argfd.constprop.0>
80104b91:	85 c0                	test   %eax,%eax
80104b93:	78 1b                	js     80104bb0 <sys_dup+0x30>
    return -1;
  if((fd=fdalloc(f)) < 0)
80104b95:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104b98:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80104b9e:	31 db                	xor    %ebx,%ebx
    if(proc->ofile[fd] == 0){
80104ba0:	8b 4c 98 28          	mov    0x28(%eax,%ebx,4),%ecx
80104ba4:	85 c9                	test   %ecx,%ecx
80104ba6:	74 18                	je     80104bc0 <sys_dup+0x40>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80104ba8:	83 c3 01             	add    $0x1,%ebx
80104bab:	83 fb 10             	cmp    $0x10,%ebx
80104bae:	75 f0                	jne    80104ba0 <sys_dup+0x20>
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80104bb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104bb5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bb8:	c9                   	leave  
80104bb9:	c3                   	ret    
80104bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80104bc0:	83 ec 0c             	sub    $0xc,%esp
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80104bc3:	89 54 98 28          	mov    %edx,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80104bc7:	52                   	push   %edx
80104bc8:	e8 f3 c1 ff ff       	call   80100dc0 <filedup>
  return fd;
80104bcd:	89 d8                	mov    %ebx,%eax
80104bcf:	83 c4 10             	add    $0x10,%esp
}
80104bd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bd5:	c9                   	leave  
80104bd6:	c3                   	ret    
80104bd7:	89 f6                	mov    %esi,%esi
80104bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104be0 <sys_read>:

int
sys_read(void)
{
80104be0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104be1:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80104be3:	89 e5                	mov    %esp,%ebp
80104be5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104be8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104beb:	e8 30 ff ff ff       	call   80104b20 <argfd.constprop.0>
80104bf0:	85 c0                	test   %eax,%eax
80104bf2:	78 4c                	js     80104c40 <sys_read+0x60>
80104bf4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104bf7:	83 ec 08             	sub    $0x8,%esp
80104bfa:	50                   	push   %eax
80104bfb:	6a 02                	push   $0x2
80104bfd:	e8 fe fb ff ff       	call   80104800 <argint>
80104c02:	83 c4 10             	add    $0x10,%esp
80104c05:	85 c0                	test   %eax,%eax
80104c07:	78 37                	js     80104c40 <sys_read+0x60>
80104c09:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c0c:	83 ec 04             	sub    $0x4,%esp
80104c0f:	ff 75 f0             	pushl  -0x10(%ebp)
80104c12:	50                   	push   %eax
80104c13:	6a 01                	push   $0x1
80104c15:	e8 26 fc ff ff       	call   80104840 <argptr>
80104c1a:	83 c4 10             	add    $0x10,%esp
80104c1d:	85 c0                	test   %eax,%eax
80104c1f:	78 1f                	js     80104c40 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80104c21:	83 ec 04             	sub    $0x4,%esp
80104c24:	ff 75 f0             	pushl  -0x10(%ebp)
80104c27:	ff 75 f4             	pushl  -0xc(%ebp)
80104c2a:	ff 75 ec             	pushl  -0x14(%ebp)
80104c2d:	e8 fe c2 ff ff       	call   80100f30 <fileread>
80104c32:	83 c4 10             	add    $0x10,%esp
}
80104c35:	c9                   	leave  
80104c36:	c3                   	ret    
80104c37:	89 f6                	mov    %esi,%esi
80104c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104c40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80104c45:	c9                   	leave  
80104c46:	c3                   	ret    
80104c47:	89 f6                	mov    %esi,%esi
80104c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c50 <sys_write>:

int
sys_write(void)
{
80104c50:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104c51:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104c53:	89 e5                	mov    %esp,%ebp
80104c55:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104c58:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104c5b:	e8 c0 fe ff ff       	call   80104b20 <argfd.constprop.0>
80104c60:	85 c0                	test   %eax,%eax
80104c62:	78 4c                	js     80104cb0 <sys_write+0x60>
80104c64:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c67:	83 ec 08             	sub    $0x8,%esp
80104c6a:	50                   	push   %eax
80104c6b:	6a 02                	push   $0x2
80104c6d:	e8 8e fb ff ff       	call   80104800 <argint>
80104c72:	83 c4 10             	add    $0x10,%esp
80104c75:	85 c0                	test   %eax,%eax
80104c77:	78 37                	js     80104cb0 <sys_write+0x60>
80104c79:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c7c:	83 ec 04             	sub    $0x4,%esp
80104c7f:	ff 75 f0             	pushl  -0x10(%ebp)
80104c82:	50                   	push   %eax
80104c83:	6a 01                	push   $0x1
80104c85:	e8 b6 fb ff ff       	call   80104840 <argptr>
80104c8a:	83 c4 10             	add    $0x10,%esp
80104c8d:	85 c0                	test   %eax,%eax
80104c8f:	78 1f                	js     80104cb0 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80104c91:	83 ec 04             	sub    $0x4,%esp
80104c94:	ff 75 f0             	pushl  -0x10(%ebp)
80104c97:	ff 75 f4             	pushl  -0xc(%ebp)
80104c9a:	ff 75 ec             	pushl  -0x14(%ebp)
80104c9d:	e8 1e c3 ff ff       	call   80100fc0 <filewrite>
80104ca2:	83 c4 10             	add    $0x10,%esp
}
80104ca5:	c9                   	leave  
80104ca6:	c3                   	ret    
80104ca7:	89 f6                	mov    %esi,%esi
80104ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104cb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80104cb5:	c9                   	leave  
80104cb6:	c3                   	ret    
80104cb7:	89 f6                	mov    %esi,%esi
80104cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cc0 <sys_close>:

int
sys_close(void)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104cc6:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104cc9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ccc:	e8 4f fe ff ff       	call   80104b20 <argfd.constprop.0>
80104cd1:	85 c0                	test   %eax,%eax
80104cd3:	78 2b                	js     80104d00 <sys_close+0x40>
    return -1;
  proc->ofile[fd] = 0;
80104cd5:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104cd8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  fileclose(f);
80104cde:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  proc->ofile[fd] = 0;
80104ce1:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104ce8:	00 
  fileclose(f);
80104ce9:	ff 75 f4             	pushl  -0xc(%ebp)
80104cec:	e8 1f c1 ff ff       	call   80100e10 <fileclose>
  return 0;
80104cf1:	83 c4 10             	add    $0x10,%esp
80104cf4:	31 c0                	xor    %eax,%eax
}
80104cf6:	c9                   	leave  
80104cf7:	c3                   	ret    
80104cf8:	90                   	nop
80104cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80104d00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  proc->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80104d05:	c9                   	leave  
80104d06:	c3                   	ret    
80104d07:	89 f6                	mov    %esi,%esi
80104d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d10 <sys_fstat>:

int
sys_fstat(void)
{
80104d10:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104d11:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80104d13:	89 e5                	mov    %esp,%ebp
80104d15:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104d18:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104d1b:	e8 00 fe ff ff       	call   80104b20 <argfd.constprop.0>
80104d20:	85 c0                	test   %eax,%eax
80104d22:	78 2c                	js     80104d50 <sys_fstat+0x40>
80104d24:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d27:	83 ec 04             	sub    $0x4,%esp
80104d2a:	6a 14                	push   $0x14
80104d2c:	50                   	push   %eax
80104d2d:	6a 01                	push   $0x1
80104d2f:	e8 0c fb ff ff       	call   80104840 <argptr>
80104d34:	83 c4 10             	add    $0x10,%esp
80104d37:	85 c0                	test   %eax,%eax
80104d39:	78 15                	js     80104d50 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
80104d3b:	83 ec 08             	sub    $0x8,%esp
80104d3e:	ff 75 f4             	pushl  -0xc(%ebp)
80104d41:	ff 75 f0             	pushl  -0x10(%ebp)
80104d44:	e8 97 c1 ff ff       	call   80100ee0 <filestat>
80104d49:	83 c4 10             	add    $0x10,%esp
}
80104d4c:	c9                   	leave  
80104d4d:	c3                   	ret    
80104d4e:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80104d50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80104d55:	c9                   	leave  
80104d56:	c3                   	ret    
80104d57:	89 f6                	mov    %esi,%esi
80104d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d60 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104d60:	55                   	push   %ebp
80104d61:	89 e5                	mov    %esp,%ebp
80104d63:	57                   	push   %edi
80104d64:	56                   	push   %esi
80104d65:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104d66:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104d69:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104d6c:	50                   	push   %eax
80104d6d:	6a 00                	push   $0x0
80104d6f:	e8 1c fb ff ff       	call   80104890 <argstr>
80104d74:	83 c4 10             	add    $0x10,%esp
80104d77:	85 c0                	test   %eax,%eax
80104d79:	0f 88 fb 00 00 00    	js     80104e7a <sys_link+0x11a>
80104d7f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104d82:	83 ec 08             	sub    $0x8,%esp
80104d85:	50                   	push   %eax
80104d86:	6a 01                	push   $0x1
80104d88:	e8 03 fb ff ff       	call   80104890 <argstr>
80104d8d:	83 c4 10             	add    $0x10,%esp
80104d90:	85 c0                	test   %eax,%eax
80104d92:	0f 88 e2 00 00 00    	js     80104e7a <sys_link+0x11a>
    return -1;

  begin_op();
80104d98:	e8 c3 de ff ff       	call   80102c60 <begin_op>
  if((ip = namei(old)) == 0){
80104d9d:	83 ec 0c             	sub    $0xc,%esp
80104da0:	ff 75 d4             	pushl  -0x2c(%ebp)
80104da3:	e8 a8 d0 ff ff       	call   80101e50 <namei>
80104da8:	83 c4 10             	add    $0x10,%esp
80104dab:	85 c0                	test   %eax,%eax
80104dad:	89 c3                	mov    %eax,%ebx
80104daf:	0f 84 f3 00 00 00    	je     80104ea8 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
80104db5:	83 ec 0c             	sub    $0xc,%esp
80104db8:	50                   	push   %eax
80104db9:	e8 62 c8 ff ff       	call   80101620 <ilock>
  if(ip->type == T_DIR){
80104dbe:	83 c4 10             	add    $0x10,%esp
80104dc1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104dc6:	0f 84 c4 00 00 00    	je     80104e90 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104dcc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104dd1:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104dd4:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80104dd7:	53                   	push   %ebx
80104dd8:	e8 93 c7 ff ff       	call   80101570 <iupdate>
  iunlock(ip);
80104ddd:	89 1c 24             	mov    %ebx,(%esp)
80104de0:	e8 1b c9 ff ff       	call   80101700 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80104de5:	58                   	pop    %eax
80104de6:	5a                   	pop    %edx
80104de7:	57                   	push   %edi
80104de8:	ff 75 d0             	pushl  -0x30(%ebp)
80104deb:	e8 80 d0 ff ff       	call   80101e70 <nameiparent>
80104df0:	83 c4 10             	add    $0x10,%esp
80104df3:	85 c0                	test   %eax,%eax
80104df5:	89 c6                	mov    %eax,%esi
80104df7:	74 5b                	je     80104e54 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80104df9:	83 ec 0c             	sub    $0xc,%esp
80104dfc:	50                   	push   %eax
80104dfd:	e8 1e c8 ff ff       	call   80101620 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104e02:	83 c4 10             	add    $0x10,%esp
80104e05:	8b 03                	mov    (%ebx),%eax
80104e07:	39 06                	cmp    %eax,(%esi)
80104e09:	75 3d                	jne    80104e48 <sys_link+0xe8>
80104e0b:	83 ec 04             	sub    $0x4,%esp
80104e0e:	ff 73 04             	pushl  0x4(%ebx)
80104e11:	57                   	push   %edi
80104e12:	56                   	push   %esi
80104e13:	e8 78 cf ff ff       	call   80101d90 <dirlink>
80104e18:	83 c4 10             	add    $0x10,%esp
80104e1b:	85 c0                	test   %eax,%eax
80104e1d:	78 29                	js     80104e48 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104e1f:	83 ec 0c             	sub    $0xc,%esp
80104e22:	56                   	push   %esi
80104e23:	e8 68 ca ff ff       	call   80101890 <iunlockput>
  iput(ip);
80104e28:	89 1c 24             	mov    %ebx,(%esp)
80104e2b:	e8 20 c9 ff ff       	call   80101750 <iput>

  end_op();
80104e30:	e8 9b de ff ff       	call   80102cd0 <end_op>

  return 0;
80104e35:	83 c4 10             	add    $0x10,%esp
80104e38:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104e3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e3d:	5b                   	pop    %ebx
80104e3e:	5e                   	pop    %esi
80104e3f:	5f                   	pop    %edi
80104e40:	5d                   	pop    %ebp
80104e41:	c3                   	ret    
80104e42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80104e48:	83 ec 0c             	sub    $0xc,%esp
80104e4b:	56                   	push   %esi
80104e4c:	e8 3f ca ff ff       	call   80101890 <iunlockput>
    goto bad;
80104e51:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
80104e54:	83 ec 0c             	sub    $0xc,%esp
80104e57:	53                   	push   %ebx
80104e58:	e8 c3 c7 ff ff       	call   80101620 <ilock>
  ip->nlink--;
80104e5d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104e62:	89 1c 24             	mov    %ebx,(%esp)
80104e65:	e8 06 c7 ff ff       	call   80101570 <iupdate>
  iunlockput(ip);
80104e6a:	89 1c 24             	mov    %ebx,(%esp)
80104e6d:	e8 1e ca ff ff       	call   80101890 <iunlockput>
  end_op();
80104e72:	e8 59 de ff ff       	call   80102cd0 <end_op>
  return -1;
80104e77:	83 c4 10             	add    $0x10,%esp
}
80104e7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80104e7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e82:	5b                   	pop    %ebx
80104e83:	5e                   	pop    %esi
80104e84:	5f                   	pop    %edi
80104e85:	5d                   	pop    %ebp
80104e86:	c3                   	ret    
80104e87:	89 f6                	mov    %esi,%esi
80104e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
80104e90:	83 ec 0c             	sub    $0xc,%esp
80104e93:	53                   	push   %ebx
80104e94:	e8 f7 c9 ff ff       	call   80101890 <iunlockput>
    end_op();
80104e99:	e8 32 de ff ff       	call   80102cd0 <end_op>
    return -1;
80104e9e:	83 c4 10             	add    $0x10,%esp
80104ea1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ea6:	eb 92                	jmp    80104e3a <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
80104ea8:	e8 23 de ff ff       	call   80102cd0 <end_op>
    return -1;
80104ead:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104eb2:	eb 86                	jmp    80104e3a <sys_link+0xda>
80104eb4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104eba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104ec0 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104ec0:	55                   	push   %ebp
80104ec1:	89 e5                	mov    %esp,%ebp
80104ec3:	57                   	push   %edi
80104ec4:	56                   	push   %esi
80104ec5:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104ec6:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104ec9:	83 ec 54             	sub    $0x54,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104ecc:	50                   	push   %eax
80104ecd:	6a 00                	push   $0x0
80104ecf:	e8 bc f9 ff ff       	call   80104890 <argstr>
80104ed4:	83 c4 10             	add    $0x10,%esp
80104ed7:	85 c0                	test   %eax,%eax
80104ed9:	0f 88 82 01 00 00    	js     80105061 <sys_unlink+0x1a1>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
80104edf:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
80104ee2:	e8 79 dd ff ff       	call   80102c60 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104ee7:	83 ec 08             	sub    $0x8,%esp
80104eea:	53                   	push   %ebx
80104eeb:	ff 75 c0             	pushl  -0x40(%ebp)
80104eee:	e8 7d cf ff ff       	call   80101e70 <nameiparent>
80104ef3:	83 c4 10             	add    $0x10,%esp
80104ef6:	85 c0                	test   %eax,%eax
80104ef8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104efb:	0f 84 6a 01 00 00    	je     8010506b <sys_unlink+0x1ab>
    end_op();
    return -1;
  }

  ilock(dp);
80104f01:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104f04:	83 ec 0c             	sub    $0xc,%esp
80104f07:	56                   	push   %esi
80104f08:	e8 13 c7 ff ff       	call   80101620 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104f0d:	58                   	pop    %eax
80104f0e:	5a                   	pop    %edx
80104f0f:	68 7c 76 10 80       	push   $0x8010767c
80104f14:	53                   	push   %ebx
80104f15:	e8 f6 cb ff ff       	call   80101b10 <namecmp>
80104f1a:	83 c4 10             	add    $0x10,%esp
80104f1d:	85 c0                	test   %eax,%eax
80104f1f:	0f 84 fc 00 00 00    	je     80105021 <sys_unlink+0x161>
80104f25:	83 ec 08             	sub    $0x8,%esp
80104f28:	68 7b 76 10 80       	push   $0x8010767b
80104f2d:	53                   	push   %ebx
80104f2e:	e8 dd cb ff ff       	call   80101b10 <namecmp>
80104f33:	83 c4 10             	add    $0x10,%esp
80104f36:	85 c0                	test   %eax,%eax
80104f38:	0f 84 e3 00 00 00    	je     80105021 <sys_unlink+0x161>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80104f3e:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104f41:	83 ec 04             	sub    $0x4,%esp
80104f44:	50                   	push   %eax
80104f45:	53                   	push   %ebx
80104f46:	56                   	push   %esi
80104f47:	e8 e4 cb ff ff       	call   80101b30 <dirlookup>
80104f4c:	83 c4 10             	add    $0x10,%esp
80104f4f:	85 c0                	test   %eax,%eax
80104f51:	89 c3                	mov    %eax,%ebx
80104f53:	0f 84 c8 00 00 00    	je     80105021 <sys_unlink+0x161>
    goto bad;
  ilock(ip);
80104f59:	83 ec 0c             	sub    $0xc,%esp
80104f5c:	50                   	push   %eax
80104f5d:	e8 be c6 ff ff       	call   80101620 <ilock>

  if(ip->nlink < 1)
80104f62:	83 c4 10             	add    $0x10,%esp
80104f65:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104f6a:	0f 8e 24 01 00 00    	jle    80105094 <sys_unlink+0x1d4>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80104f70:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f75:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104f78:	74 66                	je     80104fe0 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80104f7a:	83 ec 04             	sub    $0x4,%esp
80104f7d:	6a 10                	push   $0x10
80104f7f:	6a 00                	push   $0x0
80104f81:	56                   	push   %esi
80104f82:	e8 89 f5 ff ff       	call   80104510 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104f87:	6a 10                	push   $0x10
80104f89:	ff 75 c4             	pushl  -0x3c(%ebp)
80104f8c:	56                   	push   %esi
80104f8d:	ff 75 b4             	pushl  -0x4c(%ebp)
80104f90:	e8 4b ca ff ff       	call   801019e0 <writei>
80104f95:	83 c4 20             	add    $0x20,%esp
80104f98:	83 f8 10             	cmp    $0x10,%eax
80104f9b:	0f 85 e6 00 00 00    	jne    80105087 <sys_unlink+0x1c7>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80104fa1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104fa6:	0f 84 9c 00 00 00    	je     80105048 <sys_unlink+0x188>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80104fac:	83 ec 0c             	sub    $0xc,%esp
80104faf:	ff 75 b4             	pushl  -0x4c(%ebp)
80104fb2:	e8 d9 c8 ff ff       	call   80101890 <iunlockput>

  ip->nlink--;
80104fb7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104fbc:	89 1c 24             	mov    %ebx,(%esp)
80104fbf:	e8 ac c5 ff ff       	call   80101570 <iupdate>
  iunlockput(ip);
80104fc4:	89 1c 24             	mov    %ebx,(%esp)
80104fc7:	e8 c4 c8 ff ff       	call   80101890 <iunlockput>

  end_op();
80104fcc:	e8 ff dc ff ff       	call   80102cd0 <end_op>

  return 0;
80104fd1:	83 c4 10             	add    $0x10,%esp
80104fd4:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104fd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fd9:	5b                   	pop    %ebx
80104fda:	5e                   	pop    %esi
80104fdb:	5f                   	pop    %edi
80104fdc:	5d                   	pop    %ebp
80104fdd:	c3                   	ret    
80104fde:	66 90                	xchg   %ax,%ax
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104fe0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104fe4:	76 94                	jbe    80104f7a <sys_unlink+0xba>
80104fe6:	bf 20 00 00 00       	mov    $0x20,%edi
80104feb:	eb 0f                	jmp    80104ffc <sys_unlink+0x13c>
80104fed:	8d 76 00             	lea    0x0(%esi),%esi
80104ff0:	83 c7 10             	add    $0x10,%edi
80104ff3:	3b 7b 58             	cmp    0x58(%ebx),%edi
80104ff6:	0f 83 7e ff ff ff    	jae    80104f7a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104ffc:	6a 10                	push   $0x10
80104ffe:	57                   	push   %edi
80104fff:	56                   	push   %esi
80105000:	53                   	push   %ebx
80105001:	e8 da c8 ff ff       	call   801018e0 <readi>
80105006:	83 c4 10             	add    $0x10,%esp
80105009:	83 f8 10             	cmp    $0x10,%eax
8010500c:	75 6c                	jne    8010507a <sys_unlink+0x1ba>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010500e:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105013:	74 db                	je     80104ff0 <sys_unlink+0x130>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80105015:	83 ec 0c             	sub    $0xc,%esp
80105018:	53                   	push   %ebx
80105019:	e8 72 c8 ff ff       	call   80101890 <iunlockput>
    goto bad;
8010501e:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
80105021:	83 ec 0c             	sub    $0xc,%esp
80105024:	ff 75 b4             	pushl  -0x4c(%ebp)
80105027:	e8 64 c8 ff ff       	call   80101890 <iunlockput>
  end_op();
8010502c:	e8 9f dc ff ff       	call   80102cd0 <end_op>
  return -1;
80105031:	83 c4 10             	add    $0x10,%esp
}
80105034:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80105037:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010503c:	5b                   	pop    %ebx
8010503d:	5e                   	pop    %esi
8010503e:	5f                   	pop    %edi
8010503f:	5d                   	pop    %ebp
80105040:	c3                   	ret    
80105041:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80105048:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
8010504b:	83 ec 0c             	sub    $0xc,%esp

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
8010504e:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105053:	50                   	push   %eax
80105054:	e8 17 c5 ff ff       	call   80101570 <iupdate>
80105059:	83 c4 10             	add    $0x10,%esp
8010505c:	e9 4b ff ff ff       	jmp    80104fac <sys_unlink+0xec>
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
80105061:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105066:	e9 6b ff ff ff       	jmp    80104fd6 <sys_unlink+0x116>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
8010506b:	e8 60 dc ff ff       	call   80102cd0 <end_op>
    return -1;
80105070:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105075:	e9 5c ff ff ff       	jmp    80104fd6 <sys_unlink+0x116>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
8010507a:	83 ec 0c             	sub    $0xc,%esp
8010507d:	68 a0 76 10 80       	push   $0x801076a0
80105082:	e8 e9 b2 ff ff       	call   80100370 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80105087:	83 ec 0c             	sub    $0xc,%esp
8010508a:	68 b2 76 10 80       	push   $0x801076b2
8010508f:	e8 dc b2 ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80105094:	83 ec 0c             	sub    $0xc,%esp
80105097:	68 8e 76 10 80       	push   $0x8010768e
8010509c:	e8 cf b2 ff ff       	call   80100370 <panic>
801050a1:	eb 0d                	jmp    801050b0 <sys_open>
801050a3:	90                   	nop
801050a4:	90                   	nop
801050a5:	90                   	nop
801050a6:	90                   	nop
801050a7:	90                   	nop
801050a8:	90                   	nop
801050a9:	90                   	nop
801050aa:	90                   	nop
801050ab:	90                   	nop
801050ac:	90                   	nop
801050ad:	90                   	nop
801050ae:	90                   	nop
801050af:	90                   	nop

801050b0 <sys_open>:
  return ip;
}

int
sys_open(void)
{
801050b0:	55                   	push   %ebp
801050b1:	89 e5                	mov    %esp,%ebp
801050b3:	57                   	push   %edi
801050b4:	56                   	push   %esi
801050b5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801050b6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
801050b9:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801050bc:	50                   	push   %eax
801050bd:	6a 00                	push   $0x0
801050bf:	e8 cc f7 ff ff       	call   80104890 <argstr>
801050c4:	83 c4 10             	add    $0x10,%esp
801050c7:	85 c0                	test   %eax,%eax
801050c9:	0f 88 9e 00 00 00    	js     8010516d <sys_open+0xbd>
801050cf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801050d2:	83 ec 08             	sub    $0x8,%esp
801050d5:	50                   	push   %eax
801050d6:	6a 01                	push   $0x1
801050d8:	e8 23 f7 ff ff       	call   80104800 <argint>
801050dd:	83 c4 10             	add    $0x10,%esp
801050e0:	85 c0                	test   %eax,%eax
801050e2:	0f 88 85 00 00 00    	js     8010516d <sys_open+0xbd>
    return -1;

  begin_op();
801050e8:	e8 73 db ff ff       	call   80102c60 <begin_op>

  if(omode & O_CREATE){
801050ed:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801050f1:	0f 85 89 00 00 00    	jne    80105180 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801050f7:	83 ec 0c             	sub    $0xc,%esp
801050fa:	ff 75 e0             	pushl  -0x20(%ebp)
801050fd:	e8 4e cd ff ff       	call   80101e50 <namei>
80105102:	83 c4 10             	add    $0x10,%esp
80105105:	85 c0                	test   %eax,%eax
80105107:	89 c7                	mov    %eax,%edi
80105109:	0f 84 8e 00 00 00    	je     8010519d <sys_open+0xed>
      end_op();
      return -1;
    }
    ilock(ip);
8010510f:	83 ec 0c             	sub    $0xc,%esp
80105112:	50                   	push   %eax
80105113:	e8 08 c5 ff ff       	call   80101620 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105118:	83 c4 10             	add    $0x10,%esp
8010511b:	66 83 7f 50 01       	cmpw   $0x1,0x50(%edi)
80105120:	0f 84 d2 00 00 00    	je     801051f8 <sys_open+0x148>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105126:	e8 25 bc ff ff       	call   80100d50 <filealloc>
8010512b:	85 c0                	test   %eax,%eax
8010512d:	89 c6                	mov    %eax,%esi
8010512f:	74 2b                	je     8010515c <sys_open+0xac>
80105131:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105138:	31 db                	xor    %ebx,%ebx
8010513a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
80105140:	8b 44 9a 28          	mov    0x28(%edx,%ebx,4),%eax
80105144:	85 c0                	test   %eax,%eax
80105146:	74 68                	je     801051b0 <sys_open+0x100>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105148:	83 c3 01             	add    $0x1,%ebx
8010514b:	83 fb 10             	cmp    $0x10,%ebx
8010514e:	75 f0                	jne    80105140 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80105150:	83 ec 0c             	sub    $0xc,%esp
80105153:	56                   	push   %esi
80105154:	e8 b7 bc ff ff       	call   80100e10 <fileclose>
80105159:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010515c:	83 ec 0c             	sub    $0xc,%esp
8010515f:	57                   	push   %edi
80105160:	e8 2b c7 ff ff       	call   80101890 <iunlockput>
    end_op();
80105165:	e8 66 db ff ff       	call   80102cd0 <end_op>
    return -1;
8010516a:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
8010516d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80105170:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80105175:	5b                   	pop    %ebx
80105176:	5e                   	pop    %esi
80105177:	5f                   	pop    %edi
80105178:	5d                   	pop    %ebp
80105179:	c3                   	ret    
8010517a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105180:	83 ec 0c             	sub    $0xc,%esp
80105183:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105186:	31 c9                	xor    %ecx,%ecx
80105188:	6a 00                	push   $0x0
8010518a:	ba 02 00 00 00       	mov    $0x2,%edx
8010518f:	e8 ec f7 ff ff       	call   80104980 <create>
    if(ip == 0){
80105194:	83 c4 10             	add    $0x10,%esp
80105197:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105199:	89 c7                	mov    %eax,%edi
    if(ip == 0){
8010519b:	75 89                	jne    80105126 <sys_open+0x76>
      end_op();
8010519d:	e8 2e db ff ff       	call   80102cd0 <end_op>
      return -1;
801051a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051a7:	eb 43                	jmp    801051ec <sys_open+0x13c>
801051a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801051b0:	83 ec 0c             	sub    $0xc,%esp
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
801051b3:	89 74 9a 28          	mov    %esi,0x28(%edx,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801051b7:	57                   	push   %edi
801051b8:	e8 43 c5 ff ff       	call   80101700 <iunlock>
  end_op();
801051bd:	e8 0e db ff ff       	call   80102cd0 <end_op>

  f->type = FD_INODE;
801051c2:	c7 06 02 00 00 00    	movl   $0x2,(%esi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801051c8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801051cb:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
801051ce:	89 7e 10             	mov    %edi,0x10(%esi)
  f->off = 0;
801051d1:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f->readable = !(omode & O_WRONLY);
801051d8:	89 d0                	mov    %edx,%eax
801051da:	83 e0 01             	and    $0x1,%eax
801051dd:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801051e0:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801051e3:	88 46 08             	mov    %al,0x8(%esi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801051e6:	0f 95 46 09          	setne  0x9(%esi)
  return fd;
801051ea:	89 d8                	mov    %ebx,%eax
}
801051ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051ef:	5b                   	pop    %ebx
801051f0:	5e                   	pop    %esi
801051f1:	5f                   	pop    %edi
801051f2:	5d                   	pop    %ebp
801051f3:	c3                   	ret    
801051f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
801051f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801051fb:	85 d2                	test   %edx,%edx
801051fd:	0f 84 23 ff ff ff    	je     80105126 <sys_open+0x76>
80105203:	e9 54 ff ff ff       	jmp    8010515c <sys_open+0xac>
80105208:	90                   	nop
80105209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105210 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80105210:	55                   	push   %ebp
80105211:	89 e5                	mov    %esp,%ebp
80105213:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105216:	e8 45 da ff ff       	call   80102c60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010521b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010521e:	83 ec 08             	sub    $0x8,%esp
80105221:	50                   	push   %eax
80105222:	6a 00                	push   $0x0
80105224:	e8 67 f6 ff ff       	call   80104890 <argstr>
80105229:	83 c4 10             	add    $0x10,%esp
8010522c:	85 c0                	test   %eax,%eax
8010522e:	78 30                	js     80105260 <sys_mkdir+0x50>
80105230:	83 ec 0c             	sub    $0xc,%esp
80105233:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105236:	31 c9                	xor    %ecx,%ecx
80105238:	6a 00                	push   $0x0
8010523a:	ba 01 00 00 00       	mov    $0x1,%edx
8010523f:	e8 3c f7 ff ff       	call   80104980 <create>
80105244:	83 c4 10             	add    $0x10,%esp
80105247:	85 c0                	test   %eax,%eax
80105249:	74 15                	je     80105260 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010524b:	83 ec 0c             	sub    $0xc,%esp
8010524e:	50                   	push   %eax
8010524f:	e8 3c c6 ff ff       	call   80101890 <iunlockput>
  end_op();
80105254:	e8 77 da ff ff       	call   80102cd0 <end_op>
  return 0;
80105259:	83 c4 10             	add    $0x10,%esp
8010525c:	31 c0                	xor    %eax,%eax
}
8010525e:	c9                   	leave  
8010525f:	c3                   	ret    
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80105260:	e8 6b da ff ff       	call   80102cd0 <end_op>
    return -1;
80105265:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010526a:	c9                   	leave  
8010526b:	c3                   	ret    
8010526c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105270 <sys_mknod>:

int
sys_mknod(void)
{
80105270:	55                   	push   %ebp
80105271:	89 e5                	mov    %esp,%ebp
80105273:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105276:	e8 e5 d9 ff ff       	call   80102c60 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010527b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010527e:	83 ec 08             	sub    $0x8,%esp
80105281:	50                   	push   %eax
80105282:	6a 00                	push   $0x0
80105284:	e8 07 f6 ff ff       	call   80104890 <argstr>
80105289:	83 c4 10             	add    $0x10,%esp
8010528c:	85 c0                	test   %eax,%eax
8010528e:	78 60                	js     801052f0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105290:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105293:	83 ec 08             	sub    $0x8,%esp
80105296:	50                   	push   %eax
80105297:	6a 01                	push   $0x1
80105299:	e8 62 f5 ff ff       	call   80104800 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
8010529e:	83 c4 10             	add    $0x10,%esp
801052a1:	85 c0                	test   %eax,%eax
801052a3:	78 4b                	js     801052f0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801052a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052a8:	83 ec 08             	sub    $0x8,%esp
801052ab:	50                   	push   %eax
801052ac:	6a 02                	push   $0x2
801052ae:	e8 4d f5 ff ff       	call   80104800 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
801052b3:	83 c4 10             	add    $0x10,%esp
801052b6:	85 c0                	test   %eax,%eax
801052b8:	78 36                	js     801052f0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801052ba:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801052be:	83 ec 0c             	sub    $0xc,%esp
801052c1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801052c5:	ba 03 00 00 00       	mov    $0x3,%edx
801052ca:	50                   	push   %eax
801052cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801052ce:	e8 ad f6 ff ff       	call   80104980 <create>
801052d3:	83 c4 10             	add    $0x10,%esp
801052d6:	85 c0                	test   %eax,%eax
801052d8:	74 16                	je     801052f0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
801052da:	83 ec 0c             	sub    $0xc,%esp
801052dd:	50                   	push   %eax
801052de:	e8 ad c5 ff ff       	call   80101890 <iunlockput>
  end_op();
801052e3:	e8 e8 d9 ff ff       	call   80102cd0 <end_op>
  return 0;
801052e8:	83 c4 10             	add    $0x10,%esp
801052eb:	31 c0                	xor    %eax,%eax
}
801052ed:	c9                   	leave  
801052ee:	c3                   	ret    
801052ef:	90                   	nop
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801052f0:	e8 db d9 ff ff       	call   80102cd0 <end_op>
    return -1;
801052f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
801052fa:	c9                   	leave  
801052fb:	c3                   	ret    
801052fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105300 <sys_chdir>:

int
sys_chdir(void)
{
80105300:	55                   	push   %ebp
80105301:	89 e5                	mov    %esp,%ebp
80105303:	53                   	push   %ebx
80105304:	83 ec 14             	sub    $0x14,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105307:	e8 54 d9 ff ff       	call   80102c60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
8010530c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010530f:	83 ec 08             	sub    $0x8,%esp
80105312:	50                   	push   %eax
80105313:	6a 00                	push   $0x0
80105315:	e8 76 f5 ff ff       	call   80104890 <argstr>
8010531a:	83 c4 10             	add    $0x10,%esp
8010531d:	85 c0                	test   %eax,%eax
8010531f:	78 7f                	js     801053a0 <sys_chdir+0xa0>
80105321:	83 ec 0c             	sub    $0xc,%esp
80105324:	ff 75 f4             	pushl  -0xc(%ebp)
80105327:	e8 24 cb ff ff       	call   80101e50 <namei>
8010532c:	83 c4 10             	add    $0x10,%esp
8010532f:	85 c0                	test   %eax,%eax
80105331:	89 c3                	mov    %eax,%ebx
80105333:	74 6b                	je     801053a0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105335:	83 ec 0c             	sub    $0xc,%esp
80105338:	50                   	push   %eax
80105339:	e8 e2 c2 ff ff       	call   80101620 <ilock>
  if(ip->type != T_DIR){
8010533e:	83 c4 10             	add    $0x10,%esp
80105341:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105346:	75 38                	jne    80105380 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105348:	83 ec 0c             	sub    $0xc,%esp
8010534b:	53                   	push   %ebx
8010534c:	e8 af c3 ff ff       	call   80101700 <iunlock>
  iput(proc->cwd);
80105351:	58                   	pop    %eax
80105352:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105358:	ff 70 68             	pushl  0x68(%eax)
8010535b:	e8 f0 c3 ff ff       	call   80101750 <iput>
  end_op();
80105360:	e8 6b d9 ff ff       	call   80102cd0 <end_op>
  proc->cwd = ip;
80105365:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  return 0;
8010536b:	83 c4 10             	add    $0x10,%esp
    return -1;
  }
  iunlock(ip);
  iput(proc->cwd);
  end_op();
  proc->cwd = ip;
8010536e:	89 58 68             	mov    %ebx,0x68(%eax)
  return 0;
80105371:	31 c0                	xor    %eax,%eax
}
80105373:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105376:	c9                   	leave  
80105377:	c3                   	ret    
80105378:	90                   	nop
80105379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80105380:	83 ec 0c             	sub    $0xc,%esp
80105383:	53                   	push   %ebx
80105384:	e8 07 c5 ff ff       	call   80101890 <iunlockput>
    end_op();
80105389:	e8 42 d9 ff ff       	call   80102cd0 <end_op>
    return -1;
8010538e:	83 c4 10             	add    $0x10,%esp
80105391:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105396:	eb db                	jmp    80105373 <sys_chdir+0x73>
80105398:	90                   	nop
80105399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
801053a0:	e8 2b d9 ff ff       	call   80102cd0 <end_op>
    return -1;
801053a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053aa:	eb c7                	jmp    80105373 <sys_chdir+0x73>
801053ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053b0 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
801053b0:	55                   	push   %ebp
801053b1:	89 e5                	mov    %esp,%ebp
801053b3:	57                   	push   %edi
801053b4:	56                   	push   %esi
801053b5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801053b6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
801053bc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801053c2:	50                   	push   %eax
801053c3:	6a 00                	push   $0x0
801053c5:	e8 c6 f4 ff ff       	call   80104890 <argstr>
801053ca:	83 c4 10             	add    $0x10,%esp
801053cd:	85 c0                	test   %eax,%eax
801053cf:	78 7f                	js     80105450 <sys_exec+0xa0>
801053d1:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801053d7:	83 ec 08             	sub    $0x8,%esp
801053da:	50                   	push   %eax
801053db:	6a 01                	push   $0x1
801053dd:	e8 1e f4 ff ff       	call   80104800 <argint>
801053e2:	83 c4 10             	add    $0x10,%esp
801053e5:	85 c0                	test   %eax,%eax
801053e7:	78 67                	js     80105450 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801053e9:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801053ef:	83 ec 04             	sub    $0x4,%esp
801053f2:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
801053f8:	68 80 00 00 00       	push   $0x80
801053fd:	6a 00                	push   $0x0
801053ff:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105405:	50                   	push   %eax
80105406:	31 db                	xor    %ebx,%ebx
80105408:	e8 03 f1 ff ff       	call   80104510 <memset>
8010540d:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105410:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105416:	83 ec 08             	sub    $0x8,%esp
80105419:	57                   	push   %edi
8010541a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010541d:	50                   	push   %eax
8010541e:	e8 5d f3 ff ff       	call   80104780 <fetchint>
80105423:	83 c4 10             	add    $0x10,%esp
80105426:	85 c0                	test   %eax,%eax
80105428:	78 26                	js     80105450 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
8010542a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105430:	85 c0                	test   %eax,%eax
80105432:	74 2c                	je     80105460 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105434:	83 ec 08             	sub    $0x8,%esp
80105437:	56                   	push   %esi
80105438:	50                   	push   %eax
80105439:	e8 72 f3 ff ff       	call   801047b0 <fetchstr>
8010543e:	83 c4 10             	add    $0x10,%esp
80105441:	85 c0                	test   %eax,%eax
80105443:	78 0b                	js     80105450 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105445:	83 c3 01             	add    $0x1,%ebx
80105448:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
8010544b:	83 fb 20             	cmp    $0x20,%ebx
8010544e:	75 c0                	jne    80105410 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105450:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105453:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105458:	5b                   	pop    %ebx
80105459:	5e                   	pop    %esi
8010545a:	5f                   	pop    %edi
8010545b:	5d                   	pop    %ebp
8010545c:	c3                   	ret    
8010545d:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105460:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105466:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105469:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105470:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105474:	50                   	push   %eax
80105475:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010547b:	e8 70 b5 ff ff       	call   801009f0 <exec>
80105480:	83 c4 10             	add    $0x10,%esp
}
80105483:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105486:	5b                   	pop    %ebx
80105487:	5e                   	pop    %esi
80105488:	5f                   	pop    %edi
80105489:	5d                   	pop    %ebp
8010548a:	c3                   	ret    
8010548b:	90                   	nop
8010548c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105490 <sys_pipe>:

int
sys_pipe(void)
{
80105490:	55                   	push   %ebp
80105491:	89 e5                	mov    %esp,%ebp
80105493:	57                   	push   %edi
80105494:	56                   	push   %esi
80105495:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105496:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
80105499:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010549c:	6a 08                	push   $0x8
8010549e:	50                   	push   %eax
8010549f:	6a 00                	push   $0x0
801054a1:	e8 9a f3 ff ff       	call   80104840 <argptr>
801054a6:	83 c4 10             	add    $0x10,%esp
801054a9:	85 c0                	test   %eax,%eax
801054ab:	78 48                	js     801054f5 <sys_pipe+0x65>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801054ad:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801054b0:	83 ec 08             	sub    $0x8,%esp
801054b3:	50                   	push   %eax
801054b4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801054b7:	50                   	push   %eax
801054b8:	e8 23 df ff ff       	call   801033e0 <pipealloc>
801054bd:	83 c4 10             	add    $0x10,%esp
801054c0:	85 c0                	test   %eax,%eax
801054c2:	78 31                	js     801054f5 <sys_pipe+0x65>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801054c4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
801054c7:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801054ce:	31 c0                	xor    %eax,%eax
    if(proc->ofile[fd] == 0){
801054d0:	8b 54 81 28          	mov    0x28(%ecx,%eax,4),%edx
801054d4:	85 d2                	test   %edx,%edx
801054d6:	74 28                	je     80105500 <sys_pipe+0x70>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801054d8:	83 c0 01             	add    $0x1,%eax
801054db:	83 f8 10             	cmp    $0x10,%eax
801054de:	75 f0                	jne    801054d0 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
    fileclose(rf);
801054e0:	83 ec 0c             	sub    $0xc,%esp
801054e3:	53                   	push   %ebx
801054e4:	e8 27 b9 ff ff       	call   80100e10 <fileclose>
    fileclose(wf);
801054e9:	58                   	pop    %eax
801054ea:	ff 75 e4             	pushl  -0x1c(%ebp)
801054ed:	e8 1e b9 ff ff       	call   80100e10 <fileclose>
    return -1;
801054f2:	83 c4 10             	add    $0x10,%esp
801054f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054fa:	eb 45                	jmp    80105541 <sys_pipe+0xb1>
801054fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105500:	8d 34 81             	lea    (%ecx,%eax,4),%esi
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105503:	8b 7d e4             	mov    -0x1c(%ebp),%edi
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105506:	31 d2                	xor    %edx,%edx
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80105508:	89 5e 28             	mov    %ebx,0x28(%esi)
8010550b:	90                   	nop
8010550c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
80105510:	83 7c 91 28 00       	cmpl   $0x0,0x28(%ecx,%edx,4)
80105515:	74 19                	je     80105530 <sys_pipe+0xa0>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105517:	83 c2 01             	add    $0x1,%edx
8010551a:	83 fa 10             	cmp    $0x10,%edx
8010551d:	75 f1                	jne    80105510 <sys_pipe+0x80>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
8010551f:	c7 46 28 00 00 00 00 	movl   $0x0,0x28(%esi)
80105526:	eb b8                	jmp    801054e0 <sys_pipe+0x50>
80105528:	90                   	nop
80105529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80105530:	89 7c 91 28          	mov    %edi,0x28(%ecx,%edx,4)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105534:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80105537:	89 01                	mov    %eax,(%ecx)
  fd[1] = fd1;
80105539:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010553c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010553f:	31 c0                	xor    %eax,%eax
}
80105541:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105544:	5b                   	pop    %ebx
80105545:	5e                   	pop    %esi
80105546:	5f                   	pop    %edi
80105547:	5d                   	pop    %ebp
80105548:	c3                   	ret    
80105549:	66 90                	xchg   %ax,%ax
8010554b:	66 90                	xchg   %ax,%ax
8010554d:	66 90                	xchg   %ax,%ax
8010554f:	90                   	nop

80105550 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105550:	55                   	push   %ebp
80105551:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105553:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105554:	e9 07 e5 ff ff       	jmp    80103a60 <fork>
80105559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105560 <sys_exit>:
}

int
sys_exit(void)
{
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
80105563:	83 ec 08             	sub    $0x8,%esp
  exit();
80105566:	e8 65 e7 ff ff       	call   80103cd0 <exit>
  return 0;  // not reached
}
8010556b:	31 c0                	xor    %eax,%eax
8010556d:	c9                   	leave  
8010556e:	c3                   	ret    
8010556f:	90                   	nop

80105570 <sys_wait>:

int
sys_wait(void)
{
80105570:	55                   	push   %ebp
80105571:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105573:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105574:	e9 a7 e9 ff ff       	jmp    80103f20 <wait>
80105579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105580 <sys_kill>:
}

int
sys_kill(void)
{
80105580:	55                   	push   %ebp
80105581:	89 e5                	mov    %esp,%ebp
80105583:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105586:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105589:	50                   	push   %eax
8010558a:	6a 00                	push   $0x0
8010558c:	e8 6f f2 ff ff       	call   80104800 <argint>
80105591:	83 c4 10             	add    $0x10,%esp
80105594:	85 c0                	test   %eax,%eax
80105596:	78 18                	js     801055b0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105598:	83 ec 0c             	sub    $0xc,%esp
8010559b:	ff 75 f4             	pushl  -0xc(%ebp)
8010559e:	e8 bd ea ff ff       	call   80104060 <kill>
801055a3:	83 c4 10             	add    $0x10,%esp
}
801055a6:	c9                   	leave  
801055a7:	c3                   	ret    
801055a8:	90                   	nop
801055a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
801055b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
801055b5:	c9                   	leave  
801055b6:	c3                   	ret    
801055b7:	89 f6                	mov    %esi,%esi
801055b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055c0 <sys_getpid>:

int
sys_getpid(void)
{
  return proc->pid;
801055c0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  return kill(pid);
}

int
sys_getpid(void)
{
801055c6:	55                   	push   %ebp
801055c7:	89 e5                	mov    %esp,%ebp
  return proc->pid;
801055c9:	8b 40 10             	mov    0x10(%eax),%eax
}
801055cc:	5d                   	pop    %ebp
801055cd:	c3                   	ret    
801055ce:	66 90                	xchg   %ax,%ax

801055d0 <sys_sbrk>:

int
sys_sbrk(void)
{
801055d0:	55                   	push   %ebp
801055d1:	89 e5                	mov    %esp,%ebp
801055d3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801055d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return proc->pid;
}

int
sys_sbrk(void)
{
801055d7:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801055da:	50                   	push   %eax
801055db:	6a 00                	push   $0x0
801055dd:	e8 1e f2 ff ff       	call   80104800 <argint>
801055e2:	83 c4 10             	add    $0x10,%esp
801055e5:	85 c0                	test   %eax,%eax
801055e7:	78 27                	js     80105610 <sys_sbrk+0x40>
    return -1;
  addr = proc->sz;
801055e9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  if(growproc(n) < 0)
801055ef:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
801055f2:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801055f4:	ff 75 f4             	pushl  -0xc(%ebp)
801055f7:	e8 f4 e3 ff ff       	call   801039f0 <growproc>
801055fc:	83 c4 10             	add    $0x10,%esp
801055ff:	85 c0                	test   %eax,%eax
80105601:	78 0d                	js     80105610 <sys_sbrk+0x40>
    return -1;
  return addr;
80105603:	89 d8                	mov    %ebx,%eax
}
80105605:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105608:	c9                   	leave  
80105609:	c3                   	ret    
8010560a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105610:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105615:	eb ee                	jmp    80105605 <sys_sbrk+0x35>
80105617:	89 f6                	mov    %esi,%esi
80105619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105620 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105620:	55                   	push   %ebp
80105621:	89 e5                	mov    %esp,%ebp
80105623:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105624:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return addr;
}

int
sys_sleep(void)
{
80105627:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
8010562a:	50                   	push   %eax
8010562b:	6a 00                	push   $0x0
8010562d:	e8 ce f1 ff ff       	call   80104800 <argint>
80105632:	83 c4 10             	add    $0x10,%esp
80105635:	85 c0                	test   %eax,%eax
80105637:	0f 88 8a 00 00 00    	js     801056c7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010563d:	83 ec 0c             	sub    $0xc,%esp
80105640:	68 00 cd 14 80       	push   $0x8014cd00
80105645:	e8 96 ec ff ff       	call   801042e0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010564a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010564d:	83 c4 10             	add    $0x10,%esp
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80105650:	8b 1d 40 d5 14 80    	mov    0x8014d540,%ebx
  while(ticks - ticks0 < n){
80105656:	85 d2                	test   %edx,%edx
80105658:	75 27                	jne    80105681 <sys_sleep+0x61>
8010565a:	eb 54                	jmp    801056b0 <sys_sleep+0x90>
8010565c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105660:	83 ec 08             	sub    $0x8,%esp
80105663:	68 00 cd 14 80       	push   $0x8014cd00
80105668:	68 40 d5 14 80       	push   $0x8014d540
8010566d:	e8 ee e7 ff ff       	call   80103e60 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105672:	a1 40 d5 14 80       	mov    0x8014d540,%eax
80105677:	83 c4 10             	add    $0x10,%esp
8010567a:	29 d8                	sub    %ebx,%eax
8010567c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010567f:	73 2f                	jae    801056b0 <sys_sleep+0x90>
    if(proc->killed){
80105681:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105687:	8b 40 24             	mov    0x24(%eax),%eax
8010568a:	85 c0                	test   %eax,%eax
8010568c:	74 d2                	je     80105660 <sys_sleep+0x40>
      release(&tickslock);
8010568e:	83 ec 0c             	sub    $0xc,%esp
80105691:	68 00 cd 14 80       	push   $0x8014cd00
80105696:	e8 25 ee ff ff       	call   801044c0 <release>
      return -1;
8010569b:	83 c4 10             	add    $0x10,%esp
8010569e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
801056a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056a6:	c9                   	leave  
801056a7:	c3                   	ret    
801056a8:	90                   	nop
801056a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801056b0:	83 ec 0c             	sub    $0xc,%esp
801056b3:	68 00 cd 14 80       	push   $0x8014cd00
801056b8:	e8 03 ee ff ff       	call   801044c0 <release>
  return 0;
801056bd:	83 c4 10             	add    $0x10,%esp
801056c0:	31 c0                	xor    %eax,%eax
}
801056c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056c5:	c9                   	leave  
801056c6:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
801056c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056cc:	eb d5                	jmp    801056a3 <sys_sleep+0x83>
801056ce:	66 90                	xchg   %ax,%ax

801056d0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
801056d3:	53                   	push   %ebx
801056d4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801056d7:	68 00 cd 14 80       	push   $0x8014cd00
801056dc:	e8 ff eb ff ff       	call   801042e0 <acquire>
  xticks = ticks;
801056e1:	8b 1d 40 d5 14 80    	mov    0x8014d540,%ebx
  release(&tickslock);
801056e7:	c7 04 24 00 cd 14 80 	movl   $0x8014cd00,(%esp)
801056ee:	e8 cd ed ff ff       	call   801044c0 <release>
  return xticks;
}
801056f3:	89 d8                	mov    %ebx,%eax
801056f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056f8:	c9                   	leave  
801056f9:	c3                   	ret    
801056fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105700 <sys_halt>:

int
sys_halt(void)
{
80105700:	55                   	push   %ebp
}

static inline void
outw(ushort port, ushort data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105701:	ba 04 b0 ff ff       	mov    $0xffffb004,%edx
80105706:	b8 00 20 00 00       	mov    $0x2000,%eax
8010570b:	89 e5                	mov    %esp,%ebp
8010570d:	66 ef                	out    %ax,(%dx)
  outw(0xB004, 0x0|0x2000);
  return 0;
}
8010570f:	31 c0                	xor    %eax,%eax
80105711:	5d                   	pop    %ebp
80105712:	c3                   	ret    
80105713:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105720 <sys_freemem>:

int sys_freemem(void){
80105720:	55                   	push   %ebp
80105721:	89 e5                	mov    %esp,%ebp
	return freemem();
}
80105723:	5d                   	pop    %ebp
  outw(0xB004, 0x0|0x2000);
  return 0;
}

int sys_freemem(void){
	return freemem();
80105724:	e9 57 ce ff ff       	jmp    80102580 <freemem>
80105729:	66 90                	xchg   %ax,%ax
8010572b:	66 90                	xchg   %ax,%ax
8010572d:	66 90                	xchg   %ax,%ax
8010572f:	90                   	nop

80105730 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80105730:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105731:	ba 43 00 00 00       	mov    $0x43,%edx
80105736:	b8 34 00 00 00       	mov    $0x34,%eax
8010573b:	89 e5                	mov    %esp,%ebp
8010573d:	83 ec 14             	sub    $0x14,%esp
80105740:	ee                   	out    %al,(%dx)
80105741:	ba 40 00 00 00       	mov    $0x40,%edx
80105746:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
8010574b:	ee                   	out    %al,(%dx)
8010574c:	b8 2e 00 00 00       	mov    $0x2e,%eax
80105751:	ee                   	out    %al,(%dx)
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
  picenable(IRQ_TIMER);
80105752:	6a 00                	push   $0x0
80105754:	e8 b7 db ff ff       	call   80103310 <picenable>
}
80105759:	83 c4 10             	add    $0x10,%esp
8010575c:	c9                   	leave  
8010575d:	c3                   	ret    

8010575e <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010575e:	1e                   	push   %ds
  pushl %es
8010575f:	06                   	push   %es
  pushl %fs
80105760:	0f a0                	push   %fs
  pushl %gs
80105762:	0f a8                	push   %gs
  pushal
80105764:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80105765:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105769:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010576b:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
8010576d:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80105771:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80105773:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80105775:	54                   	push   %esp
  call trap
80105776:	e8 e5 00 00 00       	call   80105860 <trap>
  addl $4, %esp
8010577b:	83 c4 04             	add    $0x4,%esp

8010577e <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010577e:	61                   	popa   
  popl %gs
8010577f:	0f a9                	pop    %gs
  popl %fs
80105781:	0f a1                	pop    %fs
  popl %es
80105783:	07                   	pop    %es
  popl %ds
80105784:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105785:	83 c4 08             	add    $0x8,%esp
  iret
80105788:	cf                   	iret   
80105789:	66 90                	xchg   %ax,%ax
8010578b:	66 90                	xchg   %ax,%ax
8010578d:	66 90                	xchg   %ax,%ax
8010578f:	90                   	nop

80105790 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105790:	31 c0                	xor    %eax,%eax
80105792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105798:	8b 14 85 0c a0 10 80 	mov    -0x7fef5ff4(,%eax,4),%edx
8010579f:	b9 08 00 00 00       	mov    $0x8,%ecx
801057a4:	c6 04 c5 44 cd 14 80 	movb   $0x0,-0x7feb32bc(,%eax,8)
801057ab:	00 
801057ac:	66 89 0c c5 42 cd 14 	mov    %cx,-0x7feb32be(,%eax,8)
801057b3:	80 
801057b4:	c6 04 c5 45 cd 14 80 	movb   $0x8e,-0x7feb32bb(,%eax,8)
801057bb:	8e 
801057bc:	66 89 14 c5 40 cd 14 	mov    %dx,-0x7feb32c0(,%eax,8)
801057c3:	80 
801057c4:	c1 ea 10             	shr    $0x10,%edx
801057c7:	66 89 14 c5 46 cd 14 	mov    %dx,-0x7feb32ba(,%eax,8)
801057ce:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801057cf:	83 c0 01             	add    $0x1,%eax
801057d2:	3d 00 01 00 00       	cmp    $0x100,%eax
801057d7:	75 bf                	jne    80105798 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801057d9:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801057da:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801057df:	89 e5                	mov    %esp,%ebp
801057e1:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801057e4:	a1 0c a1 10 80       	mov    0x8010a10c,%eax

  initlock(&tickslock, "time");
801057e9:	68 c1 76 10 80       	push   $0x801076c1
801057ee:	68 00 cd 14 80       	push   $0x8014cd00
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801057f3:	66 89 15 42 cf 14 80 	mov    %dx,0x8014cf42
801057fa:	c6 05 44 cf 14 80 00 	movb   $0x0,0x8014cf44
80105801:	66 a3 40 cf 14 80    	mov    %ax,0x8014cf40
80105807:	c1 e8 10             	shr    $0x10,%eax
8010580a:	c6 05 45 cf 14 80 ef 	movb   $0xef,0x8014cf45
80105811:	66 a3 46 cf 14 80    	mov    %ax,0x8014cf46

  initlock(&tickslock, "time");
80105817:	e8 a4 ea ff ff       	call   801042c0 <initlock>
}
8010581c:	83 c4 10             	add    $0x10,%esp
8010581f:	c9                   	leave  
80105820:	c3                   	ret    
80105821:	eb 0d                	jmp    80105830 <idtinit>
80105823:	90                   	nop
80105824:	90                   	nop
80105825:	90                   	nop
80105826:	90                   	nop
80105827:	90                   	nop
80105828:	90                   	nop
80105829:	90                   	nop
8010582a:	90                   	nop
8010582b:	90                   	nop
8010582c:	90                   	nop
8010582d:	90                   	nop
8010582e:	90                   	nop
8010582f:	90                   	nop

80105830 <idtinit>:

void
idtinit(void)
{
80105830:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80105831:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105836:	89 e5                	mov    %esp,%ebp
80105838:	83 ec 10             	sub    $0x10,%esp
8010583b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010583f:	b8 40 cd 14 80       	mov    $0x8014cd40,%eax
80105844:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105848:	c1 e8 10             	shr    $0x10,%eax
8010584b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010584f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105852:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105855:	c9                   	leave  
80105856:	c3                   	ret    
80105857:	89 f6                	mov    %esi,%esi
80105859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105860 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105860:	55                   	push   %ebp
80105861:	89 e5                	mov    %esp,%ebp
80105863:	57                   	push   %edi
80105864:	56                   	push   %esi
80105865:	53                   	push   %ebx
80105866:	83 ec 0c             	sub    $0xc,%esp
80105869:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010586c:	8b 43 30             	mov    0x30(%ebx),%eax
8010586f:	83 f8 40             	cmp    $0x40,%eax
80105872:	0f 84 f8 00 00 00    	je     80105970 <trap+0x110>
    if(proc->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105878:	83 e8 20             	sub    $0x20,%eax
8010587b:	83 f8 1f             	cmp    $0x1f,%eax
8010587e:	77 68                	ja     801058e8 <trap+0x88>
80105880:	ff 24 85 68 77 10 80 	jmp    *-0x7fef8898(,%eax,4)
80105887:	89 f6                	mov    %esi,%esi
80105889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
80105890:	e8 eb ce ff ff       	call   80102780 <cpunum>
80105895:	85 c0                	test   %eax,%eax
80105897:	0f 84 b3 01 00 00    	je     80105a50 <trap+0x1f0>
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
    lapiceoi();
8010589d:	e8 7e cf ff ff       	call   80102820 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801058a2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058a8:	85 c0                	test   %eax,%eax
801058aa:	74 2d                	je     801058d9 <trap+0x79>
801058ac:	8b 50 24             	mov    0x24(%eax),%edx
801058af:	85 d2                	test   %edx,%edx
801058b1:	0f 85 86 00 00 00    	jne    8010593d <trap+0xdd>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
801058b7:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801058bb:	0f 84 ef 00 00 00    	je     801059b0 <trap+0x150>
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801058c1:	8b 40 24             	mov    0x24(%eax),%eax
801058c4:	85 c0                	test   %eax,%eax
801058c6:	74 11                	je     801058d9 <trap+0x79>
801058c8:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801058cc:	83 e0 03             	and    $0x3,%eax
801058cf:	66 83 f8 03          	cmp    $0x3,%ax
801058d3:	0f 84 c1 00 00 00    	je     8010599a <trap+0x13a>
    exit();
}
801058d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058dc:	5b                   	pop    %ebx
801058dd:	5e                   	pop    %esi
801058de:	5f                   	pop    %edi
801058df:	5d                   	pop    %ebp
801058e0:	c3                   	ret    
801058e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
801058e8:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
801058ef:	85 c9                	test   %ecx,%ecx
801058f1:	0f 84 8d 01 00 00    	je     80105a84 <trap+0x224>
801058f7:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801058fb:	0f 84 83 01 00 00    	je     80105a84 <trap+0x224>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105901:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105904:	8b 73 38             	mov    0x38(%ebx),%esi
80105907:	e8 74 ce ff ff       	call   80102780 <cpunum>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
8010590c:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105913:	57                   	push   %edi
80105914:	56                   	push   %esi
80105915:	50                   	push   %eax
80105916:	ff 73 34             	pushl  0x34(%ebx)
80105919:	ff 73 30             	pushl  0x30(%ebx)
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
8010591c:	8d 42 6c             	lea    0x6c(%edx),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010591f:	50                   	push   %eax
80105920:	ff 72 10             	pushl  0x10(%edx)
80105923:	68 24 77 10 80       	push   $0x80107724
80105928:	e8 33 ad ff ff       	call   80100660 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
            rcr2());
    proc->killed = 1;
8010592d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105933:	83 c4 20             	add    $0x20,%esp
80105936:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
8010593d:	0f b7 53 3c          	movzwl 0x3c(%ebx),%edx
80105941:	83 e2 03             	and    $0x3,%edx
80105944:	66 83 fa 03          	cmp    $0x3,%dx
80105948:	0f 85 69 ff ff ff    	jne    801058b7 <trap+0x57>
    exit();
8010594e:	e8 7d e3 ff ff       	call   80103cd0 <exit>
80105953:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105959:	85 c0                	test   %eax,%eax
8010595b:	0f 85 56 ff ff ff    	jne    801058b7 <trap+0x57>
80105961:	e9 73 ff ff ff       	jmp    801058d9 <trap+0x79>
80105966:	8d 76 00             	lea    0x0(%esi),%esi
80105969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
80105970:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105976:	8b 70 24             	mov    0x24(%eax),%esi
80105979:	85 f6                	test   %esi,%esi
8010597b:	0f 85 bf 00 00 00    	jne    80105a40 <trap+0x1e0>
      exit();
    proc->tf = tf;
80105981:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105984:	e8 87 ef ff ff       	call   80104910 <syscall>
    if(proc->killed)
80105989:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010598f:	8b 58 24             	mov    0x24(%eax),%ebx
80105992:	85 db                	test   %ebx,%ebx
80105994:	0f 84 3f ff ff ff    	je     801058d9 <trap+0x79>
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
8010599a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010599d:	5b                   	pop    %ebx
8010599e:	5e                   	pop    %esi
8010599f:	5f                   	pop    %edi
801059a0:	5d                   	pop    %ebp
    if(proc->killed)
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
801059a1:	e9 2a e3 ff ff       	jmp    80103cd0 <exit>
801059a6:	8d 76 00             	lea    0x0(%esi),%esi
801059a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
801059b0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801059b4:	0f 85 07 ff ff ff    	jne    801058c1 <trap+0x61>
    yield();
801059ba:	e8 61 e4 ff ff       	call   80103e20 <yield>
801059bf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801059c5:	85 c0                	test   %eax,%eax
801059c7:	0f 85 f4 fe ff ff    	jne    801058c1 <trap+0x61>
801059cd:	e9 07 ff ff ff       	jmp    801058d9 <trap+0x79>
801059d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801059d8:	e8 83 cc ff ff       	call   80102660 <kbdintr>
    lapiceoi();
801059dd:	e8 3e ce ff ff       	call   80102820 <lapiceoi>
    break;
801059e2:	e9 bb fe ff ff       	jmp    801058a2 <trap+0x42>
801059e7:	89 f6                	mov    %esi,%esi
801059e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801059f0:	e8 cb 01 00 00       	call   80105bc0 <uartintr>
801059f5:	e9 a3 fe ff ff       	jmp    8010589d <trap+0x3d>
801059fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105a00:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105a04:	8b 7b 38             	mov    0x38(%ebx),%edi
80105a07:	e8 74 cd ff ff       	call   80102780 <cpunum>
80105a0c:	57                   	push   %edi
80105a0d:	56                   	push   %esi
80105a0e:	50                   	push   %eax
80105a0f:	68 cc 76 10 80       	push   $0x801076cc
80105a14:	e8 47 ac ff ff       	call   80100660 <cprintf>
            cpunum(), tf->cs, tf->eip);
    lapiceoi();
80105a19:	e8 02 ce ff ff       	call   80102820 <lapiceoi>
    break;
80105a1e:	83 c4 10             	add    $0x10,%esp
80105a21:	e9 7c fe ff ff       	jmp    801058a2 <trap+0x42>
80105a26:	8d 76 00             	lea    0x0(%esi),%esi
80105a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105a30:	e8 bb c5 ff ff       	call   80101ff0 <ideintr>
    lapiceoi();
80105a35:	e8 e6 cd ff ff       	call   80102820 <lapiceoi>
    break;
80105a3a:	e9 63 fe ff ff       	jmp    801058a2 <trap+0x42>
80105a3f:	90                   	nop
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
      exit();
80105a40:	e8 8b e2 ff ff       	call   80103cd0 <exit>
80105a45:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a4b:	e9 31 ff ff ff       	jmp    80105981 <trap+0x121>
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
      acquire(&tickslock);
80105a50:	83 ec 0c             	sub    $0xc,%esp
80105a53:	68 00 cd 14 80       	push   $0x8014cd00
80105a58:	e8 83 e8 ff ff       	call   801042e0 <acquire>
      ticks++;
      wakeup(&ticks);
80105a5d:	c7 04 24 40 d5 14 80 	movl   $0x8014d540,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
      acquire(&tickslock);
      ticks++;
80105a64:	83 05 40 d5 14 80 01 	addl   $0x1,0x8014d540
      wakeup(&ticks);
80105a6b:	e8 90 e5 ff ff       	call   80104000 <wakeup>
      release(&tickslock);
80105a70:	c7 04 24 00 cd 14 80 	movl   $0x8014cd00,(%esp)
80105a77:	e8 44 ea ff ff       	call   801044c0 <release>
80105a7c:	83 c4 10             	add    $0x10,%esp
80105a7f:	e9 19 fe ff ff       	jmp    8010589d <trap+0x3d>
80105a84:	0f 20 d7             	mov    %cr2,%edi

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105a87:	8b 73 38             	mov    0x38(%ebx),%esi
80105a8a:	e8 f1 cc ff ff       	call   80102780 <cpunum>
80105a8f:	83 ec 0c             	sub    $0xc,%esp
80105a92:	57                   	push   %edi
80105a93:	56                   	push   %esi
80105a94:	50                   	push   %eax
80105a95:	ff 73 30             	pushl  0x30(%ebx)
80105a98:	68 f0 76 10 80       	push   $0x801076f0
80105a9d:	e8 be ab ff ff       	call   80100660 <cprintf>
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
80105aa2:	83 c4 14             	add    $0x14,%esp
80105aa5:	68 c6 76 10 80       	push   $0x801076c6
80105aaa:	e8 c1 a8 ff ff       	call   80100370 <panic>
80105aaf:	90                   	nop

80105ab0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105ab0:	a1 c4 a5 10 80       	mov    0x8010a5c4,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105ab5:	55                   	push   %ebp
80105ab6:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105ab8:	85 c0                	test   %eax,%eax
80105aba:	74 1c                	je     80105ad8 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105abc:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ac1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105ac2:	a8 01                	test   $0x1,%al
80105ac4:	74 12                	je     80105ad8 <uartgetc+0x28>
80105ac6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105acb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105acc:	0f b6 c0             	movzbl %al,%eax
}
80105acf:	5d                   	pop    %ebp
80105ad0:	c3                   	ret    
80105ad1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80105ad8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
80105add:	5d                   	pop    %ebp
80105ade:	c3                   	ret    
80105adf:	90                   	nop

80105ae0 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80105ae0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105ae1:	31 c9                	xor    %ecx,%ecx
80105ae3:	89 c8                	mov    %ecx,%eax
80105ae5:	89 e5                	mov    %esp,%ebp
80105ae7:	57                   	push   %edi
80105ae8:	56                   	push   %esi
80105ae9:	53                   	push   %ebx
80105aea:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105aef:	89 da                	mov    %ebx,%edx
80105af1:	83 ec 0c             	sub    $0xc,%esp
80105af4:	ee                   	out    %al,(%dx)
80105af5:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105afa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105aff:	89 fa                	mov    %edi,%edx
80105b01:	ee                   	out    %al,(%dx)
80105b02:	b8 0c 00 00 00       	mov    $0xc,%eax
80105b07:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b0c:	ee                   	out    %al,(%dx)
80105b0d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105b12:	89 c8                	mov    %ecx,%eax
80105b14:	89 f2                	mov    %esi,%edx
80105b16:	ee                   	out    %al,(%dx)
80105b17:	b8 03 00 00 00       	mov    $0x3,%eax
80105b1c:	89 fa                	mov    %edi,%edx
80105b1e:	ee                   	out    %al,(%dx)
80105b1f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105b24:	89 c8                	mov    %ecx,%eax
80105b26:	ee                   	out    %al,(%dx)
80105b27:	b8 01 00 00 00       	mov    $0x1,%eax
80105b2c:	89 f2                	mov    %esi,%edx
80105b2e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105b2f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105b34:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80105b35:	3c ff                	cmp    $0xff,%al
80105b37:	74 2b                	je     80105b64 <uartinit+0x84>
    return;
  uart = 1;
80105b39:	c7 05 c4 a5 10 80 01 	movl   $0x1,0x8010a5c4
80105b40:	00 00 00 
80105b43:	89 da                	mov    %ebx,%edx
80105b45:	ec                   	in     (%dx),%al
80105b46:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b4b:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
80105b4c:	83 ec 0c             	sub    $0xc,%esp
80105b4f:	6a 04                	push   $0x4
80105b51:	e8 ba d7 ff ff       	call   80103310 <picenable>
  ioapicenable(IRQ_COM1, 0);
80105b56:	58                   	pop    %eax
80105b57:	5a                   	pop    %edx
80105b58:	6a 00                	push   $0x0
80105b5a:	6a 04                	push   $0x4
80105b5c:	e8 ef c6 ff ff       	call   80102250 <ioapicenable>
80105b61:	83 c4 10             	add    $0x10,%esp
}
80105b64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b67:	5b                   	pop    %ebx
80105b68:	5e                   	pop    %esi
80105b69:	5f                   	pop    %edi
80105b6a:	5d                   	pop    %ebp
80105b6b:	c3                   	ret    
80105b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b70 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80105b70:	a1 c4 a5 10 80       	mov    0x8010a5c4,%eax
80105b75:	85 c0                	test   %eax,%eax
80105b77:	74 3f                	je     80105bb8 <uartputc+0x48>
  ioapicenable(IRQ_COM1, 0);
}

void
uartputc(int c)
{
80105b79:	55                   	push   %ebp
80105b7a:	89 e5                	mov    %esp,%ebp
80105b7c:	56                   	push   %esi
80105b7d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105b82:	53                   	push   %ebx
80105b83:	bb 80 00 00 00       	mov    $0x80,%ebx
80105b88:	eb 18                	jmp    80105ba2 <uartputc+0x32>
80105b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80105b90:	83 ec 0c             	sub    $0xc,%esp
80105b93:	6a 0a                	push   $0xa
80105b95:	e8 a6 cc ff ff       	call   80102840 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105b9a:	83 c4 10             	add    $0x10,%esp
80105b9d:	83 eb 01             	sub    $0x1,%ebx
80105ba0:	74 07                	je     80105ba9 <uartputc+0x39>
80105ba2:	89 f2                	mov    %esi,%edx
80105ba4:	ec                   	in     (%dx),%al
80105ba5:	a8 20                	test   $0x20,%al
80105ba7:	74 e7                	je     80105b90 <uartputc+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105ba9:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105bae:	8b 45 08             	mov    0x8(%ebp),%eax
80105bb1:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80105bb2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105bb5:	5b                   	pop    %ebx
80105bb6:	5e                   	pop    %esi
80105bb7:	5d                   	pop    %ebp
80105bb8:	f3 c3                	repz ret 
80105bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105bc0 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80105bc0:	55                   	push   %ebp
80105bc1:	89 e5                	mov    %esp,%ebp
80105bc3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105bc6:	68 b0 5a 10 80       	push   $0x80105ab0
80105bcb:	e8 20 ac ff ff       	call   801007f0 <consoleintr>
}
80105bd0:	83 c4 10             	add    $0x10,%esp
80105bd3:	c9                   	leave  
80105bd4:	c3                   	ret    

80105bd5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105bd5:	6a 00                	push   $0x0
  pushl $0
80105bd7:	6a 00                	push   $0x0
  jmp alltraps
80105bd9:	e9 80 fb ff ff       	jmp    8010575e <alltraps>

80105bde <vector1>:
.globl vector1
vector1:
  pushl $0
80105bde:	6a 00                	push   $0x0
  pushl $1
80105be0:	6a 01                	push   $0x1
  jmp alltraps
80105be2:	e9 77 fb ff ff       	jmp    8010575e <alltraps>

80105be7 <vector2>:
.globl vector2
vector2:
  pushl $0
80105be7:	6a 00                	push   $0x0
  pushl $2
80105be9:	6a 02                	push   $0x2
  jmp alltraps
80105beb:	e9 6e fb ff ff       	jmp    8010575e <alltraps>

80105bf0 <vector3>:
.globl vector3
vector3:
  pushl $0
80105bf0:	6a 00                	push   $0x0
  pushl $3
80105bf2:	6a 03                	push   $0x3
  jmp alltraps
80105bf4:	e9 65 fb ff ff       	jmp    8010575e <alltraps>

80105bf9 <vector4>:
.globl vector4
vector4:
  pushl $0
80105bf9:	6a 00                	push   $0x0
  pushl $4
80105bfb:	6a 04                	push   $0x4
  jmp alltraps
80105bfd:	e9 5c fb ff ff       	jmp    8010575e <alltraps>

80105c02 <vector5>:
.globl vector5
vector5:
  pushl $0
80105c02:	6a 00                	push   $0x0
  pushl $5
80105c04:	6a 05                	push   $0x5
  jmp alltraps
80105c06:	e9 53 fb ff ff       	jmp    8010575e <alltraps>

80105c0b <vector6>:
.globl vector6
vector6:
  pushl $0
80105c0b:	6a 00                	push   $0x0
  pushl $6
80105c0d:	6a 06                	push   $0x6
  jmp alltraps
80105c0f:	e9 4a fb ff ff       	jmp    8010575e <alltraps>

80105c14 <vector7>:
.globl vector7
vector7:
  pushl $0
80105c14:	6a 00                	push   $0x0
  pushl $7
80105c16:	6a 07                	push   $0x7
  jmp alltraps
80105c18:	e9 41 fb ff ff       	jmp    8010575e <alltraps>

80105c1d <vector8>:
.globl vector8
vector8:
  pushl $8
80105c1d:	6a 08                	push   $0x8
  jmp alltraps
80105c1f:	e9 3a fb ff ff       	jmp    8010575e <alltraps>

80105c24 <vector9>:
.globl vector9
vector9:
  pushl $0
80105c24:	6a 00                	push   $0x0
  pushl $9
80105c26:	6a 09                	push   $0x9
  jmp alltraps
80105c28:	e9 31 fb ff ff       	jmp    8010575e <alltraps>

80105c2d <vector10>:
.globl vector10
vector10:
  pushl $10
80105c2d:	6a 0a                	push   $0xa
  jmp alltraps
80105c2f:	e9 2a fb ff ff       	jmp    8010575e <alltraps>

80105c34 <vector11>:
.globl vector11
vector11:
  pushl $11
80105c34:	6a 0b                	push   $0xb
  jmp alltraps
80105c36:	e9 23 fb ff ff       	jmp    8010575e <alltraps>

80105c3b <vector12>:
.globl vector12
vector12:
  pushl $12
80105c3b:	6a 0c                	push   $0xc
  jmp alltraps
80105c3d:	e9 1c fb ff ff       	jmp    8010575e <alltraps>

80105c42 <vector13>:
.globl vector13
vector13:
  pushl $13
80105c42:	6a 0d                	push   $0xd
  jmp alltraps
80105c44:	e9 15 fb ff ff       	jmp    8010575e <alltraps>

80105c49 <vector14>:
.globl vector14
vector14:
  pushl $14
80105c49:	6a 0e                	push   $0xe
  jmp alltraps
80105c4b:	e9 0e fb ff ff       	jmp    8010575e <alltraps>

80105c50 <vector15>:
.globl vector15
vector15:
  pushl $0
80105c50:	6a 00                	push   $0x0
  pushl $15
80105c52:	6a 0f                	push   $0xf
  jmp alltraps
80105c54:	e9 05 fb ff ff       	jmp    8010575e <alltraps>

80105c59 <vector16>:
.globl vector16
vector16:
  pushl $0
80105c59:	6a 00                	push   $0x0
  pushl $16
80105c5b:	6a 10                	push   $0x10
  jmp alltraps
80105c5d:	e9 fc fa ff ff       	jmp    8010575e <alltraps>

80105c62 <vector17>:
.globl vector17
vector17:
  pushl $17
80105c62:	6a 11                	push   $0x11
  jmp alltraps
80105c64:	e9 f5 fa ff ff       	jmp    8010575e <alltraps>

80105c69 <vector18>:
.globl vector18
vector18:
  pushl $0
80105c69:	6a 00                	push   $0x0
  pushl $18
80105c6b:	6a 12                	push   $0x12
  jmp alltraps
80105c6d:	e9 ec fa ff ff       	jmp    8010575e <alltraps>

80105c72 <vector19>:
.globl vector19
vector19:
  pushl $0
80105c72:	6a 00                	push   $0x0
  pushl $19
80105c74:	6a 13                	push   $0x13
  jmp alltraps
80105c76:	e9 e3 fa ff ff       	jmp    8010575e <alltraps>

80105c7b <vector20>:
.globl vector20
vector20:
  pushl $0
80105c7b:	6a 00                	push   $0x0
  pushl $20
80105c7d:	6a 14                	push   $0x14
  jmp alltraps
80105c7f:	e9 da fa ff ff       	jmp    8010575e <alltraps>

80105c84 <vector21>:
.globl vector21
vector21:
  pushl $0
80105c84:	6a 00                	push   $0x0
  pushl $21
80105c86:	6a 15                	push   $0x15
  jmp alltraps
80105c88:	e9 d1 fa ff ff       	jmp    8010575e <alltraps>

80105c8d <vector22>:
.globl vector22
vector22:
  pushl $0
80105c8d:	6a 00                	push   $0x0
  pushl $22
80105c8f:	6a 16                	push   $0x16
  jmp alltraps
80105c91:	e9 c8 fa ff ff       	jmp    8010575e <alltraps>

80105c96 <vector23>:
.globl vector23
vector23:
  pushl $0
80105c96:	6a 00                	push   $0x0
  pushl $23
80105c98:	6a 17                	push   $0x17
  jmp alltraps
80105c9a:	e9 bf fa ff ff       	jmp    8010575e <alltraps>

80105c9f <vector24>:
.globl vector24
vector24:
  pushl $0
80105c9f:	6a 00                	push   $0x0
  pushl $24
80105ca1:	6a 18                	push   $0x18
  jmp alltraps
80105ca3:	e9 b6 fa ff ff       	jmp    8010575e <alltraps>

80105ca8 <vector25>:
.globl vector25
vector25:
  pushl $0
80105ca8:	6a 00                	push   $0x0
  pushl $25
80105caa:	6a 19                	push   $0x19
  jmp alltraps
80105cac:	e9 ad fa ff ff       	jmp    8010575e <alltraps>

80105cb1 <vector26>:
.globl vector26
vector26:
  pushl $0
80105cb1:	6a 00                	push   $0x0
  pushl $26
80105cb3:	6a 1a                	push   $0x1a
  jmp alltraps
80105cb5:	e9 a4 fa ff ff       	jmp    8010575e <alltraps>

80105cba <vector27>:
.globl vector27
vector27:
  pushl $0
80105cba:	6a 00                	push   $0x0
  pushl $27
80105cbc:	6a 1b                	push   $0x1b
  jmp alltraps
80105cbe:	e9 9b fa ff ff       	jmp    8010575e <alltraps>

80105cc3 <vector28>:
.globl vector28
vector28:
  pushl $0
80105cc3:	6a 00                	push   $0x0
  pushl $28
80105cc5:	6a 1c                	push   $0x1c
  jmp alltraps
80105cc7:	e9 92 fa ff ff       	jmp    8010575e <alltraps>

80105ccc <vector29>:
.globl vector29
vector29:
  pushl $0
80105ccc:	6a 00                	push   $0x0
  pushl $29
80105cce:	6a 1d                	push   $0x1d
  jmp alltraps
80105cd0:	e9 89 fa ff ff       	jmp    8010575e <alltraps>

80105cd5 <vector30>:
.globl vector30
vector30:
  pushl $0
80105cd5:	6a 00                	push   $0x0
  pushl $30
80105cd7:	6a 1e                	push   $0x1e
  jmp alltraps
80105cd9:	e9 80 fa ff ff       	jmp    8010575e <alltraps>

80105cde <vector31>:
.globl vector31
vector31:
  pushl $0
80105cde:	6a 00                	push   $0x0
  pushl $31
80105ce0:	6a 1f                	push   $0x1f
  jmp alltraps
80105ce2:	e9 77 fa ff ff       	jmp    8010575e <alltraps>

80105ce7 <vector32>:
.globl vector32
vector32:
  pushl $0
80105ce7:	6a 00                	push   $0x0
  pushl $32
80105ce9:	6a 20                	push   $0x20
  jmp alltraps
80105ceb:	e9 6e fa ff ff       	jmp    8010575e <alltraps>

80105cf0 <vector33>:
.globl vector33
vector33:
  pushl $0
80105cf0:	6a 00                	push   $0x0
  pushl $33
80105cf2:	6a 21                	push   $0x21
  jmp alltraps
80105cf4:	e9 65 fa ff ff       	jmp    8010575e <alltraps>

80105cf9 <vector34>:
.globl vector34
vector34:
  pushl $0
80105cf9:	6a 00                	push   $0x0
  pushl $34
80105cfb:	6a 22                	push   $0x22
  jmp alltraps
80105cfd:	e9 5c fa ff ff       	jmp    8010575e <alltraps>

80105d02 <vector35>:
.globl vector35
vector35:
  pushl $0
80105d02:	6a 00                	push   $0x0
  pushl $35
80105d04:	6a 23                	push   $0x23
  jmp alltraps
80105d06:	e9 53 fa ff ff       	jmp    8010575e <alltraps>

80105d0b <vector36>:
.globl vector36
vector36:
  pushl $0
80105d0b:	6a 00                	push   $0x0
  pushl $36
80105d0d:	6a 24                	push   $0x24
  jmp alltraps
80105d0f:	e9 4a fa ff ff       	jmp    8010575e <alltraps>

80105d14 <vector37>:
.globl vector37
vector37:
  pushl $0
80105d14:	6a 00                	push   $0x0
  pushl $37
80105d16:	6a 25                	push   $0x25
  jmp alltraps
80105d18:	e9 41 fa ff ff       	jmp    8010575e <alltraps>

80105d1d <vector38>:
.globl vector38
vector38:
  pushl $0
80105d1d:	6a 00                	push   $0x0
  pushl $38
80105d1f:	6a 26                	push   $0x26
  jmp alltraps
80105d21:	e9 38 fa ff ff       	jmp    8010575e <alltraps>

80105d26 <vector39>:
.globl vector39
vector39:
  pushl $0
80105d26:	6a 00                	push   $0x0
  pushl $39
80105d28:	6a 27                	push   $0x27
  jmp alltraps
80105d2a:	e9 2f fa ff ff       	jmp    8010575e <alltraps>

80105d2f <vector40>:
.globl vector40
vector40:
  pushl $0
80105d2f:	6a 00                	push   $0x0
  pushl $40
80105d31:	6a 28                	push   $0x28
  jmp alltraps
80105d33:	e9 26 fa ff ff       	jmp    8010575e <alltraps>

80105d38 <vector41>:
.globl vector41
vector41:
  pushl $0
80105d38:	6a 00                	push   $0x0
  pushl $41
80105d3a:	6a 29                	push   $0x29
  jmp alltraps
80105d3c:	e9 1d fa ff ff       	jmp    8010575e <alltraps>

80105d41 <vector42>:
.globl vector42
vector42:
  pushl $0
80105d41:	6a 00                	push   $0x0
  pushl $42
80105d43:	6a 2a                	push   $0x2a
  jmp alltraps
80105d45:	e9 14 fa ff ff       	jmp    8010575e <alltraps>

80105d4a <vector43>:
.globl vector43
vector43:
  pushl $0
80105d4a:	6a 00                	push   $0x0
  pushl $43
80105d4c:	6a 2b                	push   $0x2b
  jmp alltraps
80105d4e:	e9 0b fa ff ff       	jmp    8010575e <alltraps>

80105d53 <vector44>:
.globl vector44
vector44:
  pushl $0
80105d53:	6a 00                	push   $0x0
  pushl $44
80105d55:	6a 2c                	push   $0x2c
  jmp alltraps
80105d57:	e9 02 fa ff ff       	jmp    8010575e <alltraps>

80105d5c <vector45>:
.globl vector45
vector45:
  pushl $0
80105d5c:	6a 00                	push   $0x0
  pushl $45
80105d5e:	6a 2d                	push   $0x2d
  jmp alltraps
80105d60:	e9 f9 f9 ff ff       	jmp    8010575e <alltraps>

80105d65 <vector46>:
.globl vector46
vector46:
  pushl $0
80105d65:	6a 00                	push   $0x0
  pushl $46
80105d67:	6a 2e                	push   $0x2e
  jmp alltraps
80105d69:	e9 f0 f9 ff ff       	jmp    8010575e <alltraps>

80105d6e <vector47>:
.globl vector47
vector47:
  pushl $0
80105d6e:	6a 00                	push   $0x0
  pushl $47
80105d70:	6a 2f                	push   $0x2f
  jmp alltraps
80105d72:	e9 e7 f9 ff ff       	jmp    8010575e <alltraps>

80105d77 <vector48>:
.globl vector48
vector48:
  pushl $0
80105d77:	6a 00                	push   $0x0
  pushl $48
80105d79:	6a 30                	push   $0x30
  jmp alltraps
80105d7b:	e9 de f9 ff ff       	jmp    8010575e <alltraps>

80105d80 <vector49>:
.globl vector49
vector49:
  pushl $0
80105d80:	6a 00                	push   $0x0
  pushl $49
80105d82:	6a 31                	push   $0x31
  jmp alltraps
80105d84:	e9 d5 f9 ff ff       	jmp    8010575e <alltraps>

80105d89 <vector50>:
.globl vector50
vector50:
  pushl $0
80105d89:	6a 00                	push   $0x0
  pushl $50
80105d8b:	6a 32                	push   $0x32
  jmp alltraps
80105d8d:	e9 cc f9 ff ff       	jmp    8010575e <alltraps>

80105d92 <vector51>:
.globl vector51
vector51:
  pushl $0
80105d92:	6a 00                	push   $0x0
  pushl $51
80105d94:	6a 33                	push   $0x33
  jmp alltraps
80105d96:	e9 c3 f9 ff ff       	jmp    8010575e <alltraps>

80105d9b <vector52>:
.globl vector52
vector52:
  pushl $0
80105d9b:	6a 00                	push   $0x0
  pushl $52
80105d9d:	6a 34                	push   $0x34
  jmp alltraps
80105d9f:	e9 ba f9 ff ff       	jmp    8010575e <alltraps>

80105da4 <vector53>:
.globl vector53
vector53:
  pushl $0
80105da4:	6a 00                	push   $0x0
  pushl $53
80105da6:	6a 35                	push   $0x35
  jmp alltraps
80105da8:	e9 b1 f9 ff ff       	jmp    8010575e <alltraps>

80105dad <vector54>:
.globl vector54
vector54:
  pushl $0
80105dad:	6a 00                	push   $0x0
  pushl $54
80105daf:	6a 36                	push   $0x36
  jmp alltraps
80105db1:	e9 a8 f9 ff ff       	jmp    8010575e <alltraps>

80105db6 <vector55>:
.globl vector55
vector55:
  pushl $0
80105db6:	6a 00                	push   $0x0
  pushl $55
80105db8:	6a 37                	push   $0x37
  jmp alltraps
80105dba:	e9 9f f9 ff ff       	jmp    8010575e <alltraps>

80105dbf <vector56>:
.globl vector56
vector56:
  pushl $0
80105dbf:	6a 00                	push   $0x0
  pushl $56
80105dc1:	6a 38                	push   $0x38
  jmp alltraps
80105dc3:	e9 96 f9 ff ff       	jmp    8010575e <alltraps>

80105dc8 <vector57>:
.globl vector57
vector57:
  pushl $0
80105dc8:	6a 00                	push   $0x0
  pushl $57
80105dca:	6a 39                	push   $0x39
  jmp alltraps
80105dcc:	e9 8d f9 ff ff       	jmp    8010575e <alltraps>

80105dd1 <vector58>:
.globl vector58
vector58:
  pushl $0
80105dd1:	6a 00                	push   $0x0
  pushl $58
80105dd3:	6a 3a                	push   $0x3a
  jmp alltraps
80105dd5:	e9 84 f9 ff ff       	jmp    8010575e <alltraps>

80105dda <vector59>:
.globl vector59
vector59:
  pushl $0
80105dda:	6a 00                	push   $0x0
  pushl $59
80105ddc:	6a 3b                	push   $0x3b
  jmp alltraps
80105dde:	e9 7b f9 ff ff       	jmp    8010575e <alltraps>

80105de3 <vector60>:
.globl vector60
vector60:
  pushl $0
80105de3:	6a 00                	push   $0x0
  pushl $60
80105de5:	6a 3c                	push   $0x3c
  jmp alltraps
80105de7:	e9 72 f9 ff ff       	jmp    8010575e <alltraps>

80105dec <vector61>:
.globl vector61
vector61:
  pushl $0
80105dec:	6a 00                	push   $0x0
  pushl $61
80105dee:	6a 3d                	push   $0x3d
  jmp alltraps
80105df0:	e9 69 f9 ff ff       	jmp    8010575e <alltraps>

80105df5 <vector62>:
.globl vector62
vector62:
  pushl $0
80105df5:	6a 00                	push   $0x0
  pushl $62
80105df7:	6a 3e                	push   $0x3e
  jmp alltraps
80105df9:	e9 60 f9 ff ff       	jmp    8010575e <alltraps>

80105dfe <vector63>:
.globl vector63
vector63:
  pushl $0
80105dfe:	6a 00                	push   $0x0
  pushl $63
80105e00:	6a 3f                	push   $0x3f
  jmp alltraps
80105e02:	e9 57 f9 ff ff       	jmp    8010575e <alltraps>

80105e07 <vector64>:
.globl vector64
vector64:
  pushl $0
80105e07:	6a 00                	push   $0x0
  pushl $64
80105e09:	6a 40                	push   $0x40
  jmp alltraps
80105e0b:	e9 4e f9 ff ff       	jmp    8010575e <alltraps>

80105e10 <vector65>:
.globl vector65
vector65:
  pushl $0
80105e10:	6a 00                	push   $0x0
  pushl $65
80105e12:	6a 41                	push   $0x41
  jmp alltraps
80105e14:	e9 45 f9 ff ff       	jmp    8010575e <alltraps>

80105e19 <vector66>:
.globl vector66
vector66:
  pushl $0
80105e19:	6a 00                	push   $0x0
  pushl $66
80105e1b:	6a 42                	push   $0x42
  jmp alltraps
80105e1d:	e9 3c f9 ff ff       	jmp    8010575e <alltraps>

80105e22 <vector67>:
.globl vector67
vector67:
  pushl $0
80105e22:	6a 00                	push   $0x0
  pushl $67
80105e24:	6a 43                	push   $0x43
  jmp alltraps
80105e26:	e9 33 f9 ff ff       	jmp    8010575e <alltraps>

80105e2b <vector68>:
.globl vector68
vector68:
  pushl $0
80105e2b:	6a 00                	push   $0x0
  pushl $68
80105e2d:	6a 44                	push   $0x44
  jmp alltraps
80105e2f:	e9 2a f9 ff ff       	jmp    8010575e <alltraps>

80105e34 <vector69>:
.globl vector69
vector69:
  pushl $0
80105e34:	6a 00                	push   $0x0
  pushl $69
80105e36:	6a 45                	push   $0x45
  jmp alltraps
80105e38:	e9 21 f9 ff ff       	jmp    8010575e <alltraps>

80105e3d <vector70>:
.globl vector70
vector70:
  pushl $0
80105e3d:	6a 00                	push   $0x0
  pushl $70
80105e3f:	6a 46                	push   $0x46
  jmp alltraps
80105e41:	e9 18 f9 ff ff       	jmp    8010575e <alltraps>

80105e46 <vector71>:
.globl vector71
vector71:
  pushl $0
80105e46:	6a 00                	push   $0x0
  pushl $71
80105e48:	6a 47                	push   $0x47
  jmp alltraps
80105e4a:	e9 0f f9 ff ff       	jmp    8010575e <alltraps>

80105e4f <vector72>:
.globl vector72
vector72:
  pushl $0
80105e4f:	6a 00                	push   $0x0
  pushl $72
80105e51:	6a 48                	push   $0x48
  jmp alltraps
80105e53:	e9 06 f9 ff ff       	jmp    8010575e <alltraps>

80105e58 <vector73>:
.globl vector73
vector73:
  pushl $0
80105e58:	6a 00                	push   $0x0
  pushl $73
80105e5a:	6a 49                	push   $0x49
  jmp alltraps
80105e5c:	e9 fd f8 ff ff       	jmp    8010575e <alltraps>

80105e61 <vector74>:
.globl vector74
vector74:
  pushl $0
80105e61:	6a 00                	push   $0x0
  pushl $74
80105e63:	6a 4a                	push   $0x4a
  jmp alltraps
80105e65:	e9 f4 f8 ff ff       	jmp    8010575e <alltraps>

80105e6a <vector75>:
.globl vector75
vector75:
  pushl $0
80105e6a:	6a 00                	push   $0x0
  pushl $75
80105e6c:	6a 4b                	push   $0x4b
  jmp alltraps
80105e6e:	e9 eb f8 ff ff       	jmp    8010575e <alltraps>

80105e73 <vector76>:
.globl vector76
vector76:
  pushl $0
80105e73:	6a 00                	push   $0x0
  pushl $76
80105e75:	6a 4c                	push   $0x4c
  jmp alltraps
80105e77:	e9 e2 f8 ff ff       	jmp    8010575e <alltraps>

80105e7c <vector77>:
.globl vector77
vector77:
  pushl $0
80105e7c:	6a 00                	push   $0x0
  pushl $77
80105e7e:	6a 4d                	push   $0x4d
  jmp alltraps
80105e80:	e9 d9 f8 ff ff       	jmp    8010575e <alltraps>

80105e85 <vector78>:
.globl vector78
vector78:
  pushl $0
80105e85:	6a 00                	push   $0x0
  pushl $78
80105e87:	6a 4e                	push   $0x4e
  jmp alltraps
80105e89:	e9 d0 f8 ff ff       	jmp    8010575e <alltraps>

80105e8e <vector79>:
.globl vector79
vector79:
  pushl $0
80105e8e:	6a 00                	push   $0x0
  pushl $79
80105e90:	6a 4f                	push   $0x4f
  jmp alltraps
80105e92:	e9 c7 f8 ff ff       	jmp    8010575e <alltraps>

80105e97 <vector80>:
.globl vector80
vector80:
  pushl $0
80105e97:	6a 00                	push   $0x0
  pushl $80
80105e99:	6a 50                	push   $0x50
  jmp alltraps
80105e9b:	e9 be f8 ff ff       	jmp    8010575e <alltraps>

80105ea0 <vector81>:
.globl vector81
vector81:
  pushl $0
80105ea0:	6a 00                	push   $0x0
  pushl $81
80105ea2:	6a 51                	push   $0x51
  jmp alltraps
80105ea4:	e9 b5 f8 ff ff       	jmp    8010575e <alltraps>

80105ea9 <vector82>:
.globl vector82
vector82:
  pushl $0
80105ea9:	6a 00                	push   $0x0
  pushl $82
80105eab:	6a 52                	push   $0x52
  jmp alltraps
80105ead:	e9 ac f8 ff ff       	jmp    8010575e <alltraps>

80105eb2 <vector83>:
.globl vector83
vector83:
  pushl $0
80105eb2:	6a 00                	push   $0x0
  pushl $83
80105eb4:	6a 53                	push   $0x53
  jmp alltraps
80105eb6:	e9 a3 f8 ff ff       	jmp    8010575e <alltraps>

80105ebb <vector84>:
.globl vector84
vector84:
  pushl $0
80105ebb:	6a 00                	push   $0x0
  pushl $84
80105ebd:	6a 54                	push   $0x54
  jmp alltraps
80105ebf:	e9 9a f8 ff ff       	jmp    8010575e <alltraps>

80105ec4 <vector85>:
.globl vector85
vector85:
  pushl $0
80105ec4:	6a 00                	push   $0x0
  pushl $85
80105ec6:	6a 55                	push   $0x55
  jmp alltraps
80105ec8:	e9 91 f8 ff ff       	jmp    8010575e <alltraps>

80105ecd <vector86>:
.globl vector86
vector86:
  pushl $0
80105ecd:	6a 00                	push   $0x0
  pushl $86
80105ecf:	6a 56                	push   $0x56
  jmp alltraps
80105ed1:	e9 88 f8 ff ff       	jmp    8010575e <alltraps>

80105ed6 <vector87>:
.globl vector87
vector87:
  pushl $0
80105ed6:	6a 00                	push   $0x0
  pushl $87
80105ed8:	6a 57                	push   $0x57
  jmp alltraps
80105eda:	e9 7f f8 ff ff       	jmp    8010575e <alltraps>

80105edf <vector88>:
.globl vector88
vector88:
  pushl $0
80105edf:	6a 00                	push   $0x0
  pushl $88
80105ee1:	6a 58                	push   $0x58
  jmp alltraps
80105ee3:	e9 76 f8 ff ff       	jmp    8010575e <alltraps>

80105ee8 <vector89>:
.globl vector89
vector89:
  pushl $0
80105ee8:	6a 00                	push   $0x0
  pushl $89
80105eea:	6a 59                	push   $0x59
  jmp alltraps
80105eec:	e9 6d f8 ff ff       	jmp    8010575e <alltraps>

80105ef1 <vector90>:
.globl vector90
vector90:
  pushl $0
80105ef1:	6a 00                	push   $0x0
  pushl $90
80105ef3:	6a 5a                	push   $0x5a
  jmp alltraps
80105ef5:	e9 64 f8 ff ff       	jmp    8010575e <alltraps>

80105efa <vector91>:
.globl vector91
vector91:
  pushl $0
80105efa:	6a 00                	push   $0x0
  pushl $91
80105efc:	6a 5b                	push   $0x5b
  jmp alltraps
80105efe:	e9 5b f8 ff ff       	jmp    8010575e <alltraps>

80105f03 <vector92>:
.globl vector92
vector92:
  pushl $0
80105f03:	6a 00                	push   $0x0
  pushl $92
80105f05:	6a 5c                	push   $0x5c
  jmp alltraps
80105f07:	e9 52 f8 ff ff       	jmp    8010575e <alltraps>

80105f0c <vector93>:
.globl vector93
vector93:
  pushl $0
80105f0c:	6a 00                	push   $0x0
  pushl $93
80105f0e:	6a 5d                	push   $0x5d
  jmp alltraps
80105f10:	e9 49 f8 ff ff       	jmp    8010575e <alltraps>

80105f15 <vector94>:
.globl vector94
vector94:
  pushl $0
80105f15:	6a 00                	push   $0x0
  pushl $94
80105f17:	6a 5e                	push   $0x5e
  jmp alltraps
80105f19:	e9 40 f8 ff ff       	jmp    8010575e <alltraps>

80105f1e <vector95>:
.globl vector95
vector95:
  pushl $0
80105f1e:	6a 00                	push   $0x0
  pushl $95
80105f20:	6a 5f                	push   $0x5f
  jmp alltraps
80105f22:	e9 37 f8 ff ff       	jmp    8010575e <alltraps>

80105f27 <vector96>:
.globl vector96
vector96:
  pushl $0
80105f27:	6a 00                	push   $0x0
  pushl $96
80105f29:	6a 60                	push   $0x60
  jmp alltraps
80105f2b:	e9 2e f8 ff ff       	jmp    8010575e <alltraps>

80105f30 <vector97>:
.globl vector97
vector97:
  pushl $0
80105f30:	6a 00                	push   $0x0
  pushl $97
80105f32:	6a 61                	push   $0x61
  jmp alltraps
80105f34:	e9 25 f8 ff ff       	jmp    8010575e <alltraps>

80105f39 <vector98>:
.globl vector98
vector98:
  pushl $0
80105f39:	6a 00                	push   $0x0
  pushl $98
80105f3b:	6a 62                	push   $0x62
  jmp alltraps
80105f3d:	e9 1c f8 ff ff       	jmp    8010575e <alltraps>

80105f42 <vector99>:
.globl vector99
vector99:
  pushl $0
80105f42:	6a 00                	push   $0x0
  pushl $99
80105f44:	6a 63                	push   $0x63
  jmp alltraps
80105f46:	e9 13 f8 ff ff       	jmp    8010575e <alltraps>

80105f4b <vector100>:
.globl vector100
vector100:
  pushl $0
80105f4b:	6a 00                	push   $0x0
  pushl $100
80105f4d:	6a 64                	push   $0x64
  jmp alltraps
80105f4f:	e9 0a f8 ff ff       	jmp    8010575e <alltraps>

80105f54 <vector101>:
.globl vector101
vector101:
  pushl $0
80105f54:	6a 00                	push   $0x0
  pushl $101
80105f56:	6a 65                	push   $0x65
  jmp alltraps
80105f58:	e9 01 f8 ff ff       	jmp    8010575e <alltraps>

80105f5d <vector102>:
.globl vector102
vector102:
  pushl $0
80105f5d:	6a 00                	push   $0x0
  pushl $102
80105f5f:	6a 66                	push   $0x66
  jmp alltraps
80105f61:	e9 f8 f7 ff ff       	jmp    8010575e <alltraps>

80105f66 <vector103>:
.globl vector103
vector103:
  pushl $0
80105f66:	6a 00                	push   $0x0
  pushl $103
80105f68:	6a 67                	push   $0x67
  jmp alltraps
80105f6a:	e9 ef f7 ff ff       	jmp    8010575e <alltraps>

80105f6f <vector104>:
.globl vector104
vector104:
  pushl $0
80105f6f:	6a 00                	push   $0x0
  pushl $104
80105f71:	6a 68                	push   $0x68
  jmp alltraps
80105f73:	e9 e6 f7 ff ff       	jmp    8010575e <alltraps>

80105f78 <vector105>:
.globl vector105
vector105:
  pushl $0
80105f78:	6a 00                	push   $0x0
  pushl $105
80105f7a:	6a 69                	push   $0x69
  jmp alltraps
80105f7c:	e9 dd f7 ff ff       	jmp    8010575e <alltraps>

80105f81 <vector106>:
.globl vector106
vector106:
  pushl $0
80105f81:	6a 00                	push   $0x0
  pushl $106
80105f83:	6a 6a                	push   $0x6a
  jmp alltraps
80105f85:	e9 d4 f7 ff ff       	jmp    8010575e <alltraps>

80105f8a <vector107>:
.globl vector107
vector107:
  pushl $0
80105f8a:	6a 00                	push   $0x0
  pushl $107
80105f8c:	6a 6b                	push   $0x6b
  jmp alltraps
80105f8e:	e9 cb f7 ff ff       	jmp    8010575e <alltraps>

80105f93 <vector108>:
.globl vector108
vector108:
  pushl $0
80105f93:	6a 00                	push   $0x0
  pushl $108
80105f95:	6a 6c                	push   $0x6c
  jmp alltraps
80105f97:	e9 c2 f7 ff ff       	jmp    8010575e <alltraps>

80105f9c <vector109>:
.globl vector109
vector109:
  pushl $0
80105f9c:	6a 00                	push   $0x0
  pushl $109
80105f9e:	6a 6d                	push   $0x6d
  jmp alltraps
80105fa0:	e9 b9 f7 ff ff       	jmp    8010575e <alltraps>

80105fa5 <vector110>:
.globl vector110
vector110:
  pushl $0
80105fa5:	6a 00                	push   $0x0
  pushl $110
80105fa7:	6a 6e                	push   $0x6e
  jmp alltraps
80105fa9:	e9 b0 f7 ff ff       	jmp    8010575e <alltraps>

80105fae <vector111>:
.globl vector111
vector111:
  pushl $0
80105fae:	6a 00                	push   $0x0
  pushl $111
80105fb0:	6a 6f                	push   $0x6f
  jmp alltraps
80105fb2:	e9 a7 f7 ff ff       	jmp    8010575e <alltraps>

80105fb7 <vector112>:
.globl vector112
vector112:
  pushl $0
80105fb7:	6a 00                	push   $0x0
  pushl $112
80105fb9:	6a 70                	push   $0x70
  jmp alltraps
80105fbb:	e9 9e f7 ff ff       	jmp    8010575e <alltraps>

80105fc0 <vector113>:
.globl vector113
vector113:
  pushl $0
80105fc0:	6a 00                	push   $0x0
  pushl $113
80105fc2:	6a 71                	push   $0x71
  jmp alltraps
80105fc4:	e9 95 f7 ff ff       	jmp    8010575e <alltraps>

80105fc9 <vector114>:
.globl vector114
vector114:
  pushl $0
80105fc9:	6a 00                	push   $0x0
  pushl $114
80105fcb:	6a 72                	push   $0x72
  jmp alltraps
80105fcd:	e9 8c f7 ff ff       	jmp    8010575e <alltraps>

80105fd2 <vector115>:
.globl vector115
vector115:
  pushl $0
80105fd2:	6a 00                	push   $0x0
  pushl $115
80105fd4:	6a 73                	push   $0x73
  jmp alltraps
80105fd6:	e9 83 f7 ff ff       	jmp    8010575e <alltraps>

80105fdb <vector116>:
.globl vector116
vector116:
  pushl $0
80105fdb:	6a 00                	push   $0x0
  pushl $116
80105fdd:	6a 74                	push   $0x74
  jmp alltraps
80105fdf:	e9 7a f7 ff ff       	jmp    8010575e <alltraps>

80105fe4 <vector117>:
.globl vector117
vector117:
  pushl $0
80105fe4:	6a 00                	push   $0x0
  pushl $117
80105fe6:	6a 75                	push   $0x75
  jmp alltraps
80105fe8:	e9 71 f7 ff ff       	jmp    8010575e <alltraps>

80105fed <vector118>:
.globl vector118
vector118:
  pushl $0
80105fed:	6a 00                	push   $0x0
  pushl $118
80105fef:	6a 76                	push   $0x76
  jmp alltraps
80105ff1:	e9 68 f7 ff ff       	jmp    8010575e <alltraps>

80105ff6 <vector119>:
.globl vector119
vector119:
  pushl $0
80105ff6:	6a 00                	push   $0x0
  pushl $119
80105ff8:	6a 77                	push   $0x77
  jmp alltraps
80105ffa:	e9 5f f7 ff ff       	jmp    8010575e <alltraps>

80105fff <vector120>:
.globl vector120
vector120:
  pushl $0
80105fff:	6a 00                	push   $0x0
  pushl $120
80106001:	6a 78                	push   $0x78
  jmp alltraps
80106003:	e9 56 f7 ff ff       	jmp    8010575e <alltraps>

80106008 <vector121>:
.globl vector121
vector121:
  pushl $0
80106008:	6a 00                	push   $0x0
  pushl $121
8010600a:	6a 79                	push   $0x79
  jmp alltraps
8010600c:	e9 4d f7 ff ff       	jmp    8010575e <alltraps>

80106011 <vector122>:
.globl vector122
vector122:
  pushl $0
80106011:	6a 00                	push   $0x0
  pushl $122
80106013:	6a 7a                	push   $0x7a
  jmp alltraps
80106015:	e9 44 f7 ff ff       	jmp    8010575e <alltraps>

8010601a <vector123>:
.globl vector123
vector123:
  pushl $0
8010601a:	6a 00                	push   $0x0
  pushl $123
8010601c:	6a 7b                	push   $0x7b
  jmp alltraps
8010601e:	e9 3b f7 ff ff       	jmp    8010575e <alltraps>

80106023 <vector124>:
.globl vector124
vector124:
  pushl $0
80106023:	6a 00                	push   $0x0
  pushl $124
80106025:	6a 7c                	push   $0x7c
  jmp alltraps
80106027:	e9 32 f7 ff ff       	jmp    8010575e <alltraps>

8010602c <vector125>:
.globl vector125
vector125:
  pushl $0
8010602c:	6a 00                	push   $0x0
  pushl $125
8010602e:	6a 7d                	push   $0x7d
  jmp alltraps
80106030:	e9 29 f7 ff ff       	jmp    8010575e <alltraps>

80106035 <vector126>:
.globl vector126
vector126:
  pushl $0
80106035:	6a 00                	push   $0x0
  pushl $126
80106037:	6a 7e                	push   $0x7e
  jmp alltraps
80106039:	e9 20 f7 ff ff       	jmp    8010575e <alltraps>

8010603e <vector127>:
.globl vector127
vector127:
  pushl $0
8010603e:	6a 00                	push   $0x0
  pushl $127
80106040:	6a 7f                	push   $0x7f
  jmp alltraps
80106042:	e9 17 f7 ff ff       	jmp    8010575e <alltraps>

80106047 <vector128>:
.globl vector128
vector128:
  pushl $0
80106047:	6a 00                	push   $0x0
  pushl $128
80106049:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010604e:	e9 0b f7 ff ff       	jmp    8010575e <alltraps>

80106053 <vector129>:
.globl vector129
vector129:
  pushl $0
80106053:	6a 00                	push   $0x0
  pushl $129
80106055:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010605a:	e9 ff f6 ff ff       	jmp    8010575e <alltraps>

8010605f <vector130>:
.globl vector130
vector130:
  pushl $0
8010605f:	6a 00                	push   $0x0
  pushl $130
80106061:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106066:	e9 f3 f6 ff ff       	jmp    8010575e <alltraps>

8010606b <vector131>:
.globl vector131
vector131:
  pushl $0
8010606b:	6a 00                	push   $0x0
  pushl $131
8010606d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106072:	e9 e7 f6 ff ff       	jmp    8010575e <alltraps>

80106077 <vector132>:
.globl vector132
vector132:
  pushl $0
80106077:	6a 00                	push   $0x0
  pushl $132
80106079:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010607e:	e9 db f6 ff ff       	jmp    8010575e <alltraps>

80106083 <vector133>:
.globl vector133
vector133:
  pushl $0
80106083:	6a 00                	push   $0x0
  pushl $133
80106085:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010608a:	e9 cf f6 ff ff       	jmp    8010575e <alltraps>

8010608f <vector134>:
.globl vector134
vector134:
  pushl $0
8010608f:	6a 00                	push   $0x0
  pushl $134
80106091:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106096:	e9 c3 f6 ff ff       	jmp    8010575e <alltraps>

8010609b <vector135>:
.globl vector135
vector135:
  pushl $0
8010609b:	6a 00                	push   $0x0
  pushl $135
8010609d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801060a2:	e9 b7 f6 ff ff       	jmp    8010575e <alltraps>

801060a7 <vector136>:
.globl vector136
vector136:
  pushl $0
801060a7:	6a 00                	push   $0x0
  pushl $136
801060a9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801060ae:	e9 ab f6 ff ff       	jmp    8010575e <alltraps>

801060b3 <vector137>:
.globl vector137
vector137:
  pushl $0
801060b3:	6a 00                	push   $0x0
  pushl $137
801060b5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801060ba:	e9 9f f6 ff ff       	jmp    8010575e <alltraps>

801060bf <vector138>:
.globl vector138
vector138:
  pushl $0
801060bf:	6a 00                	push   $0x0
  pushl $138
801060c1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801060c6:	e9 93 f6 ff ff       	jmp    8010575e <alltraps>

801060cb <vector139>:
.globl vector139
vector139:
  pushl $0
801060cb:	6a 00                	push   $0x0
  pushl $139
801060cd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801060d2:	e9 87 f6 ff ff       	jmp    8010575e <alltraps>

801060d7 <vector140>:
.globl vector140
vector140:
  pushl $0
801060d7:	6a 00                	push   $0x0
  pushl $140
801060d9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801060de:	e9 7b f6 ff ff       	jmp    8010575e <alltraps>

801060e3 <vector141>:
.globl vector141
vector141:
  pushl $0
801060e3:	6a 00                	push   $0x0
  pushl $141
801060e5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801060ea:	e9 6f f6 ff ff       	jmp    8010575e <alltraps>

801060ef <vector142>:
.globl vector142
vector142:
  pushl $0
801060ef:	6a 00                	push   $0x0
  pushl $142
801060f1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801060f6:	e9 63 f6 ff ff       	jmp    8010575e <alltraps>

801060fb <vector143>:
.globl vector143
vector143:
  pushl $0
801060fb:	6a 00                	push   $0x0
  pushl $143
801060fd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106102:	e9 57 f6 ff ff       	jmp    8010575e <alltraps>

80106107 <vector144>:
.globl vector144
vector144:
  pushl $0
80106107:	6a 00                	push   $0x0
  pushl $144
80106109:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010610e:	e9 4b f6 ff ff       	jmp    8010575e <alltraps>

80106113 <vector145>:
.globl vector145
vector145:
  pushl $0
80106113:	6a 00                	push   $0x0
  pushl $145
80106115:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010611a:	e9 3f f6 ff ff       	jmp    8010575e <alltraps>

8010611f <vector146>:
.globl vector146
vector146:
  pushl $0
8010611f:	6a 00                	push   $0x0
  pushl $146
80106121:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106126:	e9 33 f6 ff ff       	jmp    8010575e <alltraps>

8010612b <vector147>:
.globl vector147
vector147:
  pushl $0
8010612b:	6a 00                	push   $0x0
  pushl $147
8010612d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106132:	e9 27 f6 ff ff       	jmp    8010575e <alltraps>

80106137 <vector148>:
.globl vector148
vector148:
  pushl $0
80106137:	6a 00                	push   $0x0
  pushl $148
80106139:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010613e:	e9 1b f6 ff ff       	jmp    8010575e <alltraps>

80106143 <vector149>:
.globl vector149
vector149:
  pushl $0
80106143:	6a 00                	push   $0x0
  pushl $149
80106145:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010614a:	e9 0f f6 ff ff       	jmp    8010575e <alltraps>

8010614f <vector150>:
.globl vector150
vector150:
  pushl $0
8010614f:	6a 00                	push   $0x0
  pushl $150
80106151:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106156:	e9 03 f6 ff ff       	jmp    8010575e <alltraps>

8010615b <vector151>:
.globl vector151
vector151:
  pushl $0
8010615b:	6a 00                	push   $0x0
  pushl $151
8010615d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106162:	e9 f7 f5 ff ff       	jmp    8010575e <alltraps>

80106167 <vector152>:
.globl vector152
vector152:
  pushl $0
80106167:	6a 00                	push   $0x0
  pushl $152
80106169:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010616e:	e9 eb f5 ff ff       	jmp    8010575e <alltraps>

80106173 <vector153>:
.globl vector153
vector153:
  pushl $0
80106173:	6a 00                	push   $0x0
  pushl $153
80106175:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010617a:	e9 df f5 ff ff       	jmp    8010575e <alltraps>

8010617f <vector154>:
.globl vector154
vector154:
  pushl $0
8010617f:	6a 00                	push   $0x0
  pushl $154
80106181:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106186:	e9 d3 f5 ff ff       	jmp    8010575e <alltraps>

8010618b <vector155>:
.globl vector155
vector155:
  pushl $0
8010618b:	6a 00                	push   $0x0
  pushl $155
8010618d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106192:	e9 c7 f5 ff ff       	jmp    8010575e <alltraps>

80106197 <vector156>:
.globl vector156
vector156:
  pushl $0
80106197:	6a 00                	push   $0x0
  pushl $156
80106199:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010619e:	e9 bb f5 ff ff       	jmp    8010575e <alltraps>

801061a3 <vector157>:
.globl vector157
vector157:
  pushl $0
801061a3:	6a 00                	push   $0x0
  pushl $157
801061a5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801061aa:	e9 af f5 ff ff       	jmp    8010575e <alltraps>

801061af <vector158>:
.globl vector158
vector158:
  pushl $0
801061af:	6a 00                	push   $0x0
  pushl $158
801061b1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801061b6:	e9 a3 f5 ff ff       	jmp    8010575e <alltraps>

801061bb <vector159>:
.globl vector159
vector159:
  pushl $0
801061bb:	6a 00                	push   $0x0
  pushl $159
801061bd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801061c2:	e9 97 f5 ff ff       	jmp    8010575e <alltraps>

801061c7 <vector160>:
.globl vector160
vector160:
  pushl $0
801061c7:	6a 00                	push   $0x0
  pushl $160
801061c9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801061ce:	e9 8b f5 ff ff       	jmp    8010575e <alltraps>

801061d3 <vector161>:
.globl vector161
vector161:
  pushl $0
801061d3:	6a 00                	push   $0x0
  pushl $161
801061d5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801061da:	e9 7f f5 ff ff       	jmp    8010575e <alltraps>

801061df <vector162>:
.globl vector162
vector162:
  pushl $0
801061df:	6a 00                	push   $0x0
  pushl $162
801061e1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801061e6:	e9 73 f5 ff ff       	jmp    8010575e <alltraps>

801061eb <vector163>:
.globl vector163
vector163:
  pushl $0
801061eb:	6a 00                	push   $0x0
  pushl $163
801061ed:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801061f2:	e9 67 f5 ff ff       	jmp    8010575e <alltraps>

801061f7 <vector164>:
.globl vector164
vector164:
  pushl $0
801061f7:	6a 00                	push   $0x0
  pushl $164
801061f9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801061fe:	e9 5b f5 ff ff       	jmp    8010575e <alltraps>

80106203 <vector165>:
.globl vector165
vector165:
  pushl $0
80106203:	6a 00                	push   $0x0
  pushl $165
80106205:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010620a:	e9 4f f5 ff ff       	jmp    8010575e <alltraps>

8010620f <vector166>:
.globl vector166
vector166:
  pushl $0
8010620f:	6a 00                	push   $0x0
  pushl $166
80106211:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106216:	e9 43 f5 ff ff       	jmp    8010575e <alltraps>

8010621b <vector167>:
.globl vector167
vector167:
  pushl $0
8010621b:	6a 00                	push   $0x0
  pushl $167
8010621d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106222:	e9 37 f5 ff ff       	jmp    8010575e <alltraps>

80106227 <vector168>:
.globl vector168
vector168:
  pushl $0
80106227:	6a 00                	push   $0x0
  pushl $168
80106229:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010622e:	e9 2b f5 ff ff       	jmp    8010575e <alltraps>

80106233 <vector169>:
.globl vector169
vector169:
  pushl $0
80106233:	6a 00                	push   $0x0
  pushl $169
80106235:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010623a:	e9 1f f5 ff ff       	jmp    8010575e <alltraps>

8010623f <vector170>:
.globl vector170
vector170:
  pushl $0
8010623f:	6a 00                	push   $0x0
  pushl $170
80106241:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106246:	e9 13 f5 ff ff       	jmp    8010575e <alltraps>

8010624b <vector171>:
.globl vector171
vector171:
  pushl $0
8010624b:	6a 00                	push   $0x0
  pushl $171
8010624d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106252:	e9 07 f5 ff ff       	jmp    8010575e <alltraps>

80106257 <vector172>:
.globl vector172
vector172:
  pushl $0
80106257:	6a 00                	push   $0x0
  pushl $172
80106259:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010625e:	e9 fb f4 ff ff       	jmp    8010575e <alltraps>

80106263 <vector173>:
.globl vector173
vector173:
  pushl $0
80106263:	6a 00                	push   $0x0
  pushl $173
80106265:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010626a:	e9 ef f4 ff ff       	jmp    8010575e <alltraps>

8010626f <vector174>:
.globl vector174
vector174:
  pushl $0
8010626f:	6a 00                	push   $0x0
  pushl $174
80106271:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106276:	e9 e3 f4 ff ff       	jmp    8010575e <alltraps>

8010627b <vector175>:
.globl vector175
vector175:
  pushl $0
8010627b:	6a 00                	push   $0x0
  pushl $175
8010627d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106282:	e9 d7 f4 ff ff       	jmp    8010575e <alltraps>

80106287 <vector176>:
.globl vector176
vector176:
  pushl $0
80106287:	6a 00                	push   $0x0
  pushl $176
80106289:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010628e:	e9 cb f4 ff ff       	jmp    8010575e <alltraps>

80106293 <vector177>:
.globl vector177
vector177:
  pushl $0
80106293:	6a 00                	push   $0x0
  pushl $177
80106295:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010629a:	e9 bf f4 ff ff       	jmp    8010575e <alltraps>

8010629f <vector178>:
.globl vector178
vector178:
  pushl $0
8010629f:	6a 00                	push   $0x0
  pushl $178
801062a1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801062a6:	e9 b3 f4 ff ff       	jmp    8010575e <alltraps>

801062ab <vector179>:
.globl vector179
vector179:
  pushl $0
801062ab:	6a 00                	push   $0x0
  pushl $179
801062ad:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801062b2:	e9 a7 f4 ff ff       	jmp    8010575e <alltraps>

801062b7 <vector180>:
.globl vector180
vector180:
  pushl $0
801062b7:	6a 00                	push   $0x0
  pushl $180
801062b9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801062be:	e9 9b f4 ff ff       	jmp    8010575e <alltraps>

801062c3 <vector181>:
.globl vector181
vector181:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $181
801062c5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801062ca:	e9 8f f4 ff ff       	jmp    8010575e <alltraps>

801062cf <vector182>:
.globl vector182
vector182:
  pushl $0
801062cf:	6a 00                	push   $0x0
  pushl $182
801062d1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801062d6:	e9 83 f4 ff ff       	jmp    8010575e <alltraps>

801062db <vector183>:
.globl vector183
vector183:
  pushl $0
801062db:	6a 00                	push   $0x0
  pushl $183
801062dd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801062e2:	e9 77 f4 ff ff       	jmp    8010575e <alltraps>

801062e7 <vector184>:
.globl vector184
vector184:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $184
801062e9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801062ee:	e9 6b f4 ff ff       	jmp    8010575e <alltraps>

801062f3 <vector185>:
.globl vector185
vector185:
  pushl $0
801062f3:	6a 00                	push   $0x0
  pushl $185
801062f5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801062fa:	e9 5f f4 ff ff       	jmp    8010575e <alltraps>

801062ff <vector186>:
.globl vector186
vector186:
  pushl $0
801062ff:	6a 00                	push   $0x0
  pushl $186
80106301:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106306:	e9 53 f4 ff ff       	jmp    8010575e <alltraps>

8010630b <vector187>:
.globl vector187
vector187:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $187
8010630d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106312:	e9 47 f4 ff ff       	jmp    8010575e <alltraps>

80106317 <vector188>:
.globl vector188
vector188:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $188
80106319:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010631e:	e9 3b f4 ff ff       	jmp    8010575e <alltraps>

80106323 <vector189>:
.globl vector189
vector189:
  pushl $0
80106323:	6a 00                	push   $0x0
  pushl $189
80106325:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010632a:	e9 2f f4 ff ff       	jmp    8010575e <alltraps>

8010632f <vector190>:
.globl vector190
vector190:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $190
80106331:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106336:	e9 23 f4 ff ff       	jmp    8010575e <alltraps>

8010633b <vector191>:
.globl vector191
vector191:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $191
8010633d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106342:	e9 17 f4 ff ff       	jmp    8010575e <alltraps>

80106347 <vector192>:
.globl vector192
vector192:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $192
80106349:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010634e:	e9 0b f4 ff ff       	jmp    8010575e <alltraps>

80106353 <vector193>:
.globl vector193
vector193:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $193
80106355:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010635a:	e9 ff f3 ff ff       	jmp    8010575e <alltraps>

8010635f <vector194>:
.globl vector194
vector194:
  pushl $0
8010635f:	6a 00                	push   $0x0
  pushl $194
80106361:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106366:	e9 f3 f3 ff ff       	jmp    8010575e <alltraps>

8010636b <vector195>:
.globl vector195
vector195:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $195
8010636d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106372:	e9 e7 f3 ff ff       	jmp    8010575e <alltraps>

80106377 <vector196>:
.globl vector196
vector196:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $196
80106379:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010637e:	e9 db f3 ff ff       	jmp    8010575e <alltraps>

80106383 <vector197>:
.globl vector197
vector197:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $197
80106385:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010638a:	e9 cf f3 ff ff       	jmp    8010575e <alltraps>

8010638f <vector198>:
.globl vector198
vector198:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $198
80106391:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106396:	e9 c3 f3 ff ff       	jmp    8010575e <alltraps>

8010639b <vector199>:
.globl vector199
vector199:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $199
8010639d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801063a2:	e9 b7 f3 ff ff       	jmp    8010575e <alltraps>

801063a7 <vector200>:
.globl vector200
vector200:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $200
801063a9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801063ae:	e9 ab f3 ff ff       	jmp    8010575e <alltraps>

801063b3 <vector201>:
.globl vector201
vector201:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $201
801063b5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801063ba:	e9 9f f3 ff ff       	jmp    8010575e <alltraps>

801063bf <vector202>:
.globl vector202
vector202:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $202
801063c1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801063c6:	e9 93 f3 ff ff       	jmp    8010575e <alltraps>

801063cb <vector203>:
.globl vector203
vector203:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $203
801063cd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801063d2:	e9 87 f3 ff ff       	jmp    8010575e <alltraps>

801063d7 <vector204>:
.globl vector204
vector204:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $204
801063d9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801063de:	e9 7b f3 ff ff       	jmp    8010575e <alltraps>

801063e3 <vector205>:
.globl vector205
vector205:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $205
801063e5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801063ea:	e9 6f f3 ff ff       	jmp    8010575e <alltraps>

801063ef <vector206>:
.globl vector206
vector206:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $206
801063f1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801063f6:	e9 63 f3 ff ff       	jmp    8010575e <alltraps>

801063fb <vector207>:
.globl vector207
vector207:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $207
801063fd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106402:	e9 57 f3 ff ff       	jmp    8010575e <alltraps>

80106407 <vector208>:
.globl vector208
vector208:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $208
80106409:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010640e:	e9 4b f3 ff ff       	jmp    8010575e <alltraps>

80106413 <vector209>:
.globl vector209
vector209:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $209
80106415:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010641a:	e9 3f f3 ff ff       	jmp    8010575e <alltraps>

8010641f <vector210>:
.globl vector210
vector210:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $210
80106421:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106426:	e9 33 f3 ff ff       	jmp    8010575e <alltraps>

8010642b <vector211>:
.globl vector211
vector211:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $211
8010642d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106432:	e9 27 f3 ff ff       	jmp    8010575e <alltraps>

80106437 <vector212>:
.globl vector212
vector212:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $212
80106439:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010643e:	e9 1b f3 ff ff       	jmp    8010575e <alltraps>

80106443 <vector213>:
.globl vector213
vector213:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $213
80106445:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010644a:	e9 0f f3 ff ff       	jmp    8010575e <alltraps>

8010644f <vector214>:
.globl vector214
vector214:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $214
80106451:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106456:	e9 03 f3 ff ff       	jmp    8010575e <alltraps>

8010645b <vector215>:
.globl vector215
vector215:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $215
8010645d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106462:	e9 f7 f2 ff ff       	jmp    8010575e <alltraps>

80106467 <vector216>:
.globl vector216
vector216:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $216
80106469:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010646e:	e9 eb f2 ff ff       	jmp    8010575e <alltraps>

80106473 <vector217>:
.globl vector217
vector217:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $217
80106475:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010647a:	e9 df f2 ff ff       	jmp    8010575e <alltraps>

8010647f <vector218>:
.globl vector218
vector218:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $218
80106481:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106486:	e9 d3 f2 ff ff       	jmp    8010575e <alltraps>

8010648b <vector219>:
.globl vector219
vector219:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $219
8010648d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106492:	e9 c7 f2 ff ff       	jmp    8010575e <alltraps>

80106497 <vector220>:
.globl vector220
vector220:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $220
80106499:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010649e:	e9 bb f2 ff ff       	jmp    8010575e <alltraps>

801064a3 <vector221>:
.globl vector221
vector221:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $221
801064a5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801064aa:	e9 af f2 ff ff       	jmp    8010575e <alltraps>

801064af <vector222>:
.globl vector222
vector222:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $222
801064b1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801064b6:	e9 a3 f2 ff ff       	jmp    8010575e <alltraps>

801064bb <vector223>:
.globl vector223
vector223:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $223
801064bd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801064c2:	e9 97 f2 ff ff       	jmp    8010575e <alltraps>

801064c7 <vector224>:
.globl vector224
vector224:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $224
801064c9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801064ce:	e9 8b f2 ff ff       	jmp    8010575e <alltraps>

801064d3 <vector225>:
.globl vector225
vector225:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $225
801064d5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801064da:	e9 7f f2 ff ff       	jmp    8010575e <alltraps>

801064df <vector226>:
.globl vector226
vector226:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $226
801064e1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801064e6:	e9 73 f2 ff ff       	jmp    8010575e <alltraps>

801064eb <vector227>:
.globl vector227
vector227:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $227
801064ed:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801064f2:	e9 67 f2 ff ff       	jmp    8010575e <alltraps>

801064f7 <vector228>:
.globl vector228
vector228:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $228
801064f9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801064fe:	e9 5b f2 ff ff       	jmp    8010575e <alltraps>

80106503 <vector229>:
.globl vector229
vector229:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $229
80106505:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010650a:	e9 4f f2 ff ff       	jmp    8010575e <alltraps>

8010650f <vector230>:
.globl vector230
vector230:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $230
80106511:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106516:	e9 43 f2 ff ff       	jmp    8010575e <alltraps>

8010651b <vector231>:
.globl vector231
vector231:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $231
8010651d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106522:	e9 37 f2 ff ff       	jmp    8010575e <alltraps>

80106527 <vector232>:
.globl vector232
vector232:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $232
80106529:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010652e:	e9 2b f2 ff ff       	jmp    8010575e <alltraps>

80106533 <vector233>:
.globl vector233
vector233:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $233
80106535:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010653a:	e9 1f f2 ff ff       	jmp    8010575e <alltraps>

8010653f <vector234>:
.globl vector234
vector234:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $234
80106541:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106546:	e9 13 f2 ff ff       	jmp    8010575e <alltraps>

8010654b <vector235>:
.globl vector235
vector235:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $235
8010654d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106552:	e9 07 f2 ff ff       	jmp    8010575e <alltraps>

80106557 <vector236>:
.globl vector236
vector236:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $236
80106559:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010655e:	e9 fb f1 ff ff       	jmp    8010575e <alltraps>

80106563 <vector237>:
.globl vector237
vector237:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $237
80106565:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010656a:	e9 ef f1 ff ff       	jmp    8010575e <alltraps>

8010656f <vector238>:
.globl vector238
vector238:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $238
80106571:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106576:	e9 e3 f1 ff ff       	jmp    8010575e <alltraps>

8010657b <vector239>:
.globl vector239
vector239:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $239
8010657d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106582:	e9 d7 f1 ff ff       	jmp    8010575e <alltraps>

80106587 <vector240>:
.globl vector240
vector240:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $240
80106589:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010658e:	e9 cb f1 ff ff       	jmp    8010575e <alltraps>

80106593 <vector241>:
.globl vector241
vector241:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $241
80106595:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010659a:	e9 bf f1 ff ff       	jmp    8010575e <alltraps>

8010659f <vector242>:
.globl vector242
vector242:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $242
801065a1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801065a6:	e9 b3 f1 ff ff       	jmp    8010575e <alltraps>

801065ab <vector243>:
.globl vector243
vector243:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $243
801065ad:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801065b2:	e9 a7 f1 ff ff       	jmp    8010575e <alltraps>

801065b7 <vector244>:
.globl vector244
vector244:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $244
801065b9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801065be:	e9 9b f1 ff ff       	jmp    8010575e <alltraps>

801065c3 <vector245>:
.globl vector245
vector245:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $245
801065c5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801065ca:	e9 8f f1 ff ff       	jmp    8010575e <alltraps>

801065cf <vector246>:
.globl vector246
vector246:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $246
801065d1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801065d6:	e9 83 f1 ff ff       	jmp    8010575e <alltraps>

801065db <vector247>:
.globl vector247
vector247:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $247
801065dd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801065e2:	e9 77 f1 ff ff       	jmp    8010575e <alltraps>

801065e7 <vector248>:
.globl vector248
vector248:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $248
801065e9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801065ee:	e9 6b f1 ff ff       	jmp    8010575e <alltraps>

801065f3 <vector249>:
.globl vector249
vector249:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $249
801065f5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801065fa:	e9 5f f1 ff ff       	jmp    8010575e <alltraps>

801065ff <vector250>:
.globl vector250
vector250:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $250
80106601:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106606:	e9 53 f1 ff ff       	jmp    8010575e <alltraps>

8010660b <vector251>:
.globl vector251
vector251:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $251
8010660d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106612:	e9 47 f1 ff ff       	jmp    8010575e <alltraps>

80106617 <vector252>:
.globl vector252
vector252:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $252
80106619:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010661e:	e9 3b f1 ff ff       	jmp    8010575e <alltraps>

80106623 <vector253>:
.globl vector253
vector253:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $253
80106625:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010662a:	e9 2f f1 ff ff       	jmp    8010575e <alltraps>

8010662f <vector254>:
.globl vector254
vector254:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $254
80106631:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106636:	e9 23 f1 ff ff       	jmp    8010575e <alltraps>

8010663b <vector255>:
.globl vector255
vector255:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $255
8010663d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106642:	e9 17 f1 ff ff       	jmp    8010575e <alltraps>
80106647:	66 90                	xchg   %ax,%ax
80106649:	66 90                	xchg   %ax,%ax
8010664b:	66 90                	xchg   %ax,%ax
8010664d:	66 90                	xchg   %ax,%ax
8010664f:	90                   	nop

80106650 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106650:	55                   	push   %ebp
80106651:	89 e5                	mov    %esp,%ebp
80106653:	57                   	push   %edi
80106654:	56                   	push   %esi
80106655:	53                   	push   %ebx
80106656:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106658:	c1 ea 16             	shr    $0x16,%edx
8010665b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010665e:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80106661:	8b 07                	mov    (%edi),%eax
80106663:	a8 01                	test   $0x1,%al
80106665:	74 29                	je     80106690 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106667:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010666c:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106672:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106675:	c1 eb 0a             	shr    $0xa,%ebx
80106678:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
8010667e:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
80106681:	5b                   	pop    %ebx
80106682:	5e                   	pop    %esi
80106683:	5f                   	pop    %edi
80106684:	5d                   	pop    %ebp
80106685:	c3                   	ret    
80106686:	8d 76 00             	lea    0x0(%esi),%esi
80106689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106690:	85 c9                	test   %ecx,%ecx
80106692:	74 2c                	je     801066c0 <walkpgdir+0x70>
80106694:	e8 67 be ff ff       	call   80102500 <kalloc>
80106699:	85 c0                	test   %eax,%eax
8010669b:	89 c6                	mov    %eax,%esi
8010669d:	74 21                	je     801066c0 <walkpgdir+0x70>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010669f:	83 ec 04             	sub    $0x4,%esp
801066a2:	68 00 10 00 00       	push   $0x1000
801066a7:	6a 00                	push   $0x0
801066a9:	50                   	push   %eax
801066aa:	e8 61 de ff ff       	call   80104510 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801066af:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801066b5:	83 c4 10             	add    $0x10,%esp
801066b8:	83 c8 07             	or     $0x7,%eax
801066bb:	89 07                	mov    %eax,(%edi)
801066bd:	eb b3                	jmp    80106672 <walkpgdir+0x22>
801066bf:	90                   	nop
  }
  return &pgtab[PTX(va)];
}
801066c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
801066c3:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
801066c5:	5b                   	pop    %ebx
801066c6:	5e                   	pop    %esi
801066c7:	5f                   	pop    %edi
801066c8:	5d                   	pop    %ebp
801066c9:	c3                   	ret    
801066ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801066d0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801066d0:	55                   	push   %ebp
801066d1:	89 e5                	mov    %esp,%ebp
801066d3:	57                   	push   %edi
801066d4:	56                   	push   %esi
801066d5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801066d6:	89 d3                	mov    %edx,%ebx
801066d8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801066de:	83 ec 1c             	sub    $0x1c,%esp
801066e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801066e4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801066e8:	8b 7d 08             	mov    0x8(%ebp),%edi
801066eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801066f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801066f3:	8b 45 0c             	mov    0xc(%ebp),%eax
801066f6:	29 df                	sub    %ebx,%edi
801066f8:	83 c8 01             	or     $0x1,%eax
801066fb:	89 45 dc             	mov    %eax,-0x24(%ebp)
801066fe:	eb 15                	jmp    80106715 <mappages+0x45>
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106700:	f6 00 01             	testb  $0x1,(%eax)
80106703:	75 45                	jne    8010674a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106705:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106708:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
8010670b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010670d:	74 31                	je     80106740 <mappages+0x70>
      break;
    a += PGSIZE;
8010670f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106715:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106718:	b9 01 00 00 00       	mov    $0x1,%ecx
8010671d:	89 da                	mov    %ebx,%edx
8010671f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106722:	e8 29 ff ff ff       	call   80106650 <walkpgdir>
80106727:	85 c0                	test   %eax,%eax
80106729:	75 d5                	jne    80106700 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
8010672b:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
8010672e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106733:	5b                   	pop    %ebx
80106734:	5e                   	pop    %esi
80106735:	5f                   	pop    %edi
80106736:	5d                   	pop    %ebp
80106737:	c3                   	ret    
80106738:	90                   	nop
80106739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106740:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80106743:	31 c0                	xor    %eax,%eax
}
80106745:	5b                   	pop    %ebx
80106746:	5e                   	pop    %esi
80106747:	5f                   	pop    %edi
80106748:	5d                   	pop    %ebp
80106749:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
8010674a:	83 ec 0c             	sub    $0xc,%esp
8010674d:	68 e8 77 10 80       	push   $0x801077e8
80106752:	e8 19 9c ff ff       	call   80100370 <panic>
80106757:	89 f6                	mov    %esi,%esi
80106759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106760 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106760:	55                   	push   %ebp
80106761:	89 e5                	mov    %esp,%ebp
80106763:	57                   	push   %edi
80106764:	56                   	push   %esi
80106765:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106766:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010676c:	89 c7                	mov    %eax,%edi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010676e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106774:	83 ec 1c             	sub    $0x1c,%esp
80106777:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010677a:	39 d3                	cmp    %edx,%ebx
8010677c:	73 66                	jae    801067e4 <deallocuvm.part.0+0x84>
8010677e:	89 d6                	mov    %edx,%esi
80106780:	eb 3d                	jmp    801067bf <deallocuvm.part.0+0x5f>
80106782:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106788:	8b 10                	mov    (%eax),%edx
8010678a:	f6 c2 01             	test   $0x1,%dl
8010678d:	74 26                	je     801067b5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010678f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106795:	74 58                	je     801067ef <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106797:	83 ec 0c             	sub    $0xc,%esp
8010679a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801067a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801067a3:	52                   	push   %edx
801067a4:	e8 e7 ba ff ff       	call   80102290 <kfree>
      *pte = 0;
801067a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067ac:	83 c4 10             	add    $0x10,%esp
801067af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801067b5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801067bb:	39 f3                	cmp    %esi,%ebx
801067bd:	73 25                	jae    801067e4 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
801067bf:	31 c9                	xor    %ecx,%ecx
801067c1:	89 da                	mov    %ebx,%edx
801067c3:	89 f8                	mov    %edi,%eax
801067c5:	e8 86 fe ff ff       	call   80106650 <walkpgdir>
    if(!pte)
801067ca:	85 c0                	test   %eax,%eax
801067cc:	75 ba                	jne    80106788 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801067ce:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801067d4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801067da:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801067e0:	39 f3                	cmp    %esi,%ebx
801067e2:	72 db                	jb     801067bf <deallocuvm.part.0+0x5f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801067e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801067e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801067ea:	5b                   	pop    %ebx
801067eb:	5e                   	pop    %esi
801067ec:	5f                   	pop    %edi
801067ed:	5d                   	pop    %ebp
801067ee:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
801067ef:	83 ec 0c             	sub    $0xc,%esp
801067f2:	68 be 71 10 80       	push   $0x801071be
801067f7:	e8 74 9b ff ff       	call   80100370 <panic>
801067fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106800 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106800:	55                   	push   %ebp
80106801:	89 e5                	mov    %esp,%ebp
80106803:	53                   	push   %ebx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106804:	31 db                	xor    %ebx,%ebx

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106806:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80106809:	e8 72 bf ff ff       	call   80102780 <cpunum>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010680e:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80106814:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
80106819:	8d 90 c0 a7 14 80    	lea    -0x7feb5840(%eax),%edx
8010681f:	c6 80 3d a8 14 80 9a 	movb   $0x9a,-0x7feb57c3(%eax)
80106826:	c6 80 3e a8 14 80 cf 	movb   $0xcf,-0x7feb57c2(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010682d:	c6 80 45 a8 14 80 92 	movb   $0x92,-0x7feb57bb(%eax)
80106834:	c6 80 46 a8 14 80 cf 	movb   $0xcf,-0x7feb57ba(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010683b:	66 89 4a 78          	mov    %cx,0x78(%edx)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010683f:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106844:	66 89 5a 7a          	mov    %bx,0x7a(%edx)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106848:	66 89 8a 80 00 00 00 	mov    %cx,0x80(%edx)
8010684f:	31 db                	xor    %ebx,%ebx
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106851:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106856:	66 89 9a 82 00 00 00 	mov    %bx,0x82(%edx)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010685d:	66 89 8a 90 00 00 00 	mov    %cx,0x90(%edx)
80106864:	31 db                	xor    %ebx,%ebx
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106866:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010686b:	66 89 9a 92 00 00 00 	mov    %bx,0x92(%edx)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106872:	31 db                	xor    %ebx,%ebx
80106874:	66 89 8a 98 00 00 00 	mov    %cx,0x98(%edx)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
8010687b:	8d 88 74 a8 14 80    	lea    -0x7feb578c(%eax),%ecx
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106881:	66 89 9a 9a 00 00 00 	mov    %bx,0x9a(%edx)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106888:	31 db                	xor    %ebx,%ebx
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010688a:	c6 80 55 a8 14 80 fa 	movb   $0xfa,-0x7feb57ab(%eax)
80106891:	c6 80 56 a8 14 80 cf 	movb   $0xcf,-0x7feb57aa(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106898:	66 89 9a 88 00 00 00 	mov    %bx,0x88(%edx)
8010689f:	66 89 8a 8a 00 00 00 	mov    %cx,0x8a(%edx)
801068a6:	89 cb                	mov    %ecx,%ebx
801068a8:	c1 e9 18             	shr    $0x18,%ecx
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801068ab:	c6 80 5d a8 14 80 f2 	movb   $0xf2,-0x7feb57a3(%eax)
801068b2:	c6 80 5e a8 14 80 cf 	movb   $0xcf,-0x7feb57a2(%eax)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
801068b9:	88 8a 8f 00 00 00    	mov    %cl,0x8f(%edx)
801068bf:	c6 80 4d a8 14 80 92 	movb   $0x92,-0x7feb57b3(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801068c6:	b9 37 00 00 00       	mov    $0x37,%ecx
801068cb:	c6 80 4e a8 14 80 c0 	movb   $0xc0,-0x7feb57b2(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
801068d2:	05 30 a8 14 80       	add    $0x8014a830,%eax
801068d7:	66 89 4d f2          	mov    %cx,-0xe(%ebp)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
801068db:	c1 eb 10             	shr    $0x10,%ebx
  pd[1] = (uint)p;
801068de:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801068e2:	c1 e8 10             	shr    $0x10,%eax
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801068e5:	c6 42 7c 00          	movb   $0x0,0x7c(%edx)
801068e9:	c6 42 7f 00          	movb   $0x0,0x7f(%edx)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801068ed:	c6 82 84 00 00 00 00 	movb   $0x0,0x84(%edx)
801068f4:	c6 82 87 00 00 00 00 	movb   $0x0,0x87(%edx)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801068fb:	c6 82 94 00 00 00 00 	movb   $0x0,0x94(%edx)
80106902:	c6 82 97 00 00 00 00 	movb   $0x0,0x97(%edx)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106909:	c6 82 9c 00 00 00 00 	movb   $0x0,0x9c(%edx)
80106910:	c6 82 9f 00 00 00 00 	movb   $0x0,0x9f(%edx)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106917:	88 9a 8c 00 00 00    	mov    %bl,0x8c(%edx)
8010691d:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80106921:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106924:	0f 01 10             	lgdtl  (%eax)
}

static inline void
loadgs(ushort v)
{
  asm volatile("movw %0, %%gs" : : "r" (v));
80106927:	b8 18 00 00 00       	mov    $0x18,%eax
8010692c:	8e e8                	mov    %eax,%gs
  lgdt(c->gdt, sizeof(c->gdt));
  loadgs(SEG_KCPU << 3);

  // Initialize cpu-local storage.
  cpu = c;
  proc = 0;
8010692e:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80106935:	00 00 00 00 

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80106939:	65 89 15 00 00 00 00 	mov    %edx,%gs:0x0
  loadgs(SEG_KCPU << 3);

  // Initialize cpu-local storage.
  cpu = c;
  proc = 0;
}
80106940:	83 c4 14             	add    $0x14,%esp
80106943:	5b                   	pop    %ebx
80106944:	5d                   	pop    %ebp
80106945:	c3                   	ret    
80106946:	8d 76 00             	lea    0x0(%esi),%esi
80106949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106950 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80106950:	55                   	push   %ebp
80106951:	89 e5                	mov    %esp,%ebp
80106953:	56                   	push   %esi
80106954:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80106955:	e8 a6 bb ff ff       	call   80102500 <kalloc>
8010695a:	85 c0                	test   %eax,%eax
8010695c:	74 52                	je     801069b0 <setupkvm+0x60>
    return 0;
  memset(pgdir, 0, PGSIZE);
8010695e:	83 ec 04             	sub    $0x4,%esp
80106961:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106963:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80106968:	68 00 10 00 00       	push   $0x1000
8010696d:	6a 00                	push   $0x0
8010696f:	50                   	push   %eax
80106970:	e8 9b db ff ff       	call   80104510 <memset>
80106975:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106978:	8b 43 04             	mov    0x4(%ebx),%eax
8010697b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010697e:	83 ec 08             	sub    $0x8,%esp
80106981:	8b 13                	mov    (%ebx),%edx
80106983:	ff 73 0c             	pushl  0xc(%ebx)
80106986:	50                   	push   %eax
80106987:	29 c1                	sub    %eax,%ecx
80106989:	89 f0                	mov    %esi,%eax
8010698b:	e8 40 fd ff ff       	call   801066d0 <mappages>
80106990:	83 c4 10             	add    $0x10,%esp
80106993:	85 c0                	test   %eax,%eax
80106995:	78 19                	js     801069b0 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106997:	83 c3 10             	add    $0x10,%ebx
8010699a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
801069a0:	75 d6                	jne    80106978 <setupkvm+0x28>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
}
801069a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801069a5:	89 f0                	mov    %esi,%eax
801069a7:	5b                   	pop    %ebx
801069a8:	5e                   	pop    %esi
801069a9:	5d                   	pop    %ebp
801069aa:	c3                   	ret    
801069ab:	90                   	nop
801069ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801069b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
801069b3:	31 c0                	xor    %eax,%eax
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
}
801069b5:	5b                   	pop    %ebx
801069b6:	5e                   	pop    %esi
801069b7:	5d                   	pop    %ebp
801069b8:	c3                   	ret    
801069b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801069c0 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
801069c0:	55                   	push   %ebp
801069c1:	89 e5                	mov    %esp,%ebp
801069c3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801069c6:	e8 85 ff ff ff       	call   80106950 <setupkvm>
801069cb:	a3 44 d5 14 80       	mov    %eax,0x8014d544
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801069d0:	05 00 00 00 80       	add    $0x80000000,%eax
801069d5:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
801069d8:	c9                   	leave  
801069d9:	c3                   	ret    
801069da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801069e0 <switchkvm>:
801069e0:	a1 44 d5 14 80       	mov    0x8014d544,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801069e5:	55                   	push   %ebp
801069e6:	89 e5                	mov    %esp,%ebp
801069e8:	05 00 00 00 80       	add    $0x80000000,%eax
801069ed:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
801069f0:	5d                   	pop    %ebp
801069f1:	c3                   	ret    
801069f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a00 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106a00:	55                   	push   %ebp
80106a01:	89 e5                	mov    %esp,%ebp
80106a03:	53                   	push   %ebx
80106a04:	83 ec 04             	sub    $0x4,%esp
80106a07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106a0a:	85 db                	test   %ebx,%ebx
80106a0c:	0f 84 93 00 00 00    	je     80106aa5 <switchuvm+0xa5>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80106a12:	8b 43 08             	mov    0x8(%ebx),%eax
80106a15:	85 c0                	test   %eax,%eax
80106a17:	0f 84 a2 00 00 00    	je     80106abf <switchuvm+0xbf>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80106a1d:	8b 43 04             	mov    0x4(%ebx),%eax
80106a20:	85 c0                	test   %eax,%eax
80106a22:	0f 84 8a 00 00 00    	je     80106ab2 <switchuvm+0xb2>
    panic("switchuvm: no pgdir");

  pushcli();
80106a28:	e8 13 da ff ff       	call   80104440 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106a2d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106a33:	b9 67 00 00 00       	mov    $0x67,%ecx
80106a38:	8d 50 08             	lea    0x8(%eax),%edx
80106a3b:	66 89 88 a0 00 00 00 	mov    %cx,0xa0(%eax)
80106a42:	c6 80 a6 00 00 00 40 	movb   $0x40,0xa6(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80106a49:	c6 80 a5 00 00 00 89 	movb   $0x89,0xa5(%eax)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");

  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106a50:	66 89 90 a2 00 00 00 	mov    %dx,0xa2(%eax)
80106a57:	89 d1                	mov    %edx,%ecx
80106a59:	c1 ea 18             	shr    $0x18,%edx
80106a5c:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
80106a62:	c1 e9 10             	shr    $0x10,%ecx
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
80106a65:	ba 10 00 00 00       	mov    $0x10,%edx
80106a6a:	66 89 50 10          	mov    %dx,0x10(%eax)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");

  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106a6e:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106a74:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106a77:	8d 91 00 10 00 00    	lea    0x1000(%ecx),%edx
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
80106a7d:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
80106a82:	66 89 48 6e          	mov    %cx,0x6e(%eax)

  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106a86:	89 50 0c             	mov    %edx,0xc(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80106a89:	b8 30 00 00 00       	mov    $0x30,%eax
80106a8e:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106a91:	8b 43 04             	mov    0x4(%ebx),%eax
80106a94:	05 00 00 00 80       	add    $0x80000000,%eax
80106a99:	0f 22 d8             	mov    %eax,%cr3
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
80106a9c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106a9f:	c9                   	leave  
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
80106aa0:	e9 cb d9 ff ff       	jmp    80104470 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
80106aa5:	83 ec 0c             	sub    $0xc,%esp
80106aa8:	68 ee 77 10 80       	push   $0x801077ee
80106aad:	e8 be 98 ff ff       	call   80100370 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
80106ab2:	83 ec 0c             	sub    $0xc,%esp
80106ab5:	68 19 78 10 80       	push   $0x80107819
80106aba:	e8 b1 98 ff ff       	call   80100370 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
80106abf:	83 ec 0c             	sub    $0xc,%esp
80106ac2:	68 04 78 10 80       	push   $0x80107804
80106ac7:	e8 a4 98 ff ff       	call   80100370 <panic>
80106acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ad0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106ad0:	55                   	push   %ebp
80106ad1:	89 e5                	mov    %esp,%ebp
80106ad3:	57                   	push   %edi
80106ad4:	56                   	push   %esi
80106ad5:	53                   	push   %ebx
80106ad6:	83 ec 1c             	sub    $0x1c,%esp
80106ad9:	8b 75 10             	mov    0x10(%ebp),%esi
80106adc:	8b 45 08             	mov    0x8(%ebp),%eax
80106adf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80106ae2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106ae8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
80106aeb:	77 49                	ja     80106b36 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
80106aed:	e8 0e ba ff ff       	call   80102500 <kalloc>
  memset(mem, 0, PGSIZE);
80106af2:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80106af5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106af7:	68 00 10 00 00       	push   $0x1000
80106afc:	6a 00                	push   $0x0
80106afe:	50                   	push   %eax
80106aff:	e8 0c da ff ff       	call   80104510 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106b04:	58                   	pop    %eax
80106b05:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106b0b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106b10:	5a                   	pop    %edx
80106b11:	6a 06                	push   $0x6
80106b13:	50                   	push   %eax
80106b14:	31 d2                	xor    %edx,%edx
80106b16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b19:	e8 b2 fb ff ff       	call   801066d0 <mappages>
  memmove(mem, init, sz);
80106b1e:	89 75 10             	mov    %esi,0x10(%ebp)
80106b21:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106b24:	83 c4 10             	add    $0x10,%esp
80106b27:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106b2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b2d:	5b                   	pop    %ebx
80106b2e:	5e                   	pop    %esi
80106b2f:	5f                   	pop    %edi
80106b30:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80106b31:	e9 8a da ff ff       	jmp    801045c0 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80106b36:	83 ec 0c             	sub    $0xc,%esp
80106b39:	68 2d 78 10 80       	push   $0x8010782d
80106b3e:	e8 2d 98 ff ff       	call   80100370 <panic>
80106b43:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b50 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106b50:	55                   	push   %ebp
80106b51:	89 e5                	mov    %esp,%ebp
80106b53:	57                   	push   %edi
80106b54:	56                   	push   %esi
80106b55:	53                   	push   %ebx
80106b56:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106b59:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106b60:	0f 85 91 00 00 00    	jne    80106bf7 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106b66:	8b 75 18             	mov    0x18(%ebp),%esi
80106b69:	31 db                	xor    %ebx,%ebx
80106b6b:	85 f6                	test   %esi,%esi
80106b6d:	75 1a                	jne    80106b89 <loaduvm+0x39>
80106b6f:	eb 6f                	jmp    80106be0 <loaduvm+0x90>
80106b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b78:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b7e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106b84:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106b87:	76 57                	jbe    80106be0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106b89:	8b 55 0c             	mov    0xc(%ebp),%edx
80106b8c:	8b 45 08             	mov    0x8(%ebp),%eax
80106b8f:	31 c9                	xor    %ecx,%ecx
80106b91:	01 da                	add    %ebx,%edx
80106b93:	e8 b8 fa ff ff       	call   80106650 <walkpgdir>
80106b98:	85 c0                	test   %eax,%eax
80106b9a:	74 4e                	je     80106bea <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106b9c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106b9e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
80106ba1:	bf 00 10 00 00       	mov    $0x1000,%edi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106ba6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106bab:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106bb1:	0f 46 fe             	cmovbe %esi,%edi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106bb4:	01 d9                	add    %ebx,%ecx
80106bb6:	05 00 00 00 80       	add    $0x80000000,%eax
80106bbb:	57                   	push   %edi
80106bbc:	51                   	push   %ecx
80106bbd:	50                   	push   %eax
80106bbe:	ff 75 10             	pushl  0x10(%ebp)
80106bc1:	e8 1a ad ff ff       	call   801018e0 <readi>
80106bc6:	83 c4 10             	add    $0x10,%esp
80106bc9:	39 c7                	cmp    %eax,%edi
80106bcb:	74 ab                	je     80106b78 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80106bcd:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80106bd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106bd5:	5b                   	pop    %ebx
80106bd6:	5e                   	pop    %esi
80106bd7:	5f                   	pop    %edi
80106bd8:	5d                   	pop    %ebp
80106bd9:	c3                   	ret    
80106bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106be0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80106be3:	31 c0                	xor    %eax,%eax
}
80106be5:	5b                   	pop    %ebx
80106be6:	5e                   	pop    %esi
80106be7:	5f                   	pop    %edi
80106be8:	5d                   	pop    %ebp
80106be9:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106bea:	83 ec 0c             	sub    $0xc,%esp
80106bed:	68 47 78 10 80       	push   $0x80107847
80106bf2:	e8 79 97 ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80106bf7:	83 ec 0c             	sub    $0xc,%esp
80106bfa:	68 e8 78 10 80       	push   $0x801078e8
80106bff:	e8 6c 97 ff ff       	call   80100370 <panic>
80106c04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106c10 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106c10:	55                   	push   %ebp
80106c11:	89 e5                	mov    %esp,%ebp
80106c13:	57                   	push   %edi
80106c14:	56                   	push   %esi
80106c15:	53                   	push   %ebx
80106c16:	83 ec 0c             	sub    $0xc,%esp
80106c19:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80106c1c:	85 ff                	test   %edi,%edi
80106c1e:	0f 88 ca 00 00 00    	js     80106cee <allocuvm+0xde>
    return 0;
  if(newsz < oldsz)
80106c24:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106c27:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
80106c2a:	0f 82 82 00 00 00    	jb     80106cb2 <allocuvm+0xa2>
    return oldsz;

  a = PGROUNDUP(oldsz);
80106c30:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106c36:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106c3c:	39 df                	cmp    %ebx,%edi
80106c3e:	77 43                	ja     80106c83 <allocuvm+0x73>
80106c40:	e9 bb 00 00 00       	jmp    80106d00 <allocuvm+0xf0>
80106c45:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80106c48:	83 ec 04             	sub    $0x4,%esp
80106c4b:	68 00 10 00 00       	push   $0x1000
80106c50:	6a 00                	push   $0x0
80106c52:	50                   	push   %eax
80106c53:	e8 b8 d8 ff ff       	call   80104510 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106c58:	58                   	pop    %eax
80106c59:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106c5f:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106c64:	5a                   	pop    %edx
80106c65:	6a 06                	push   $0x6
80106c67:	50                   	push   %eax
80106c68:	89 da                	mov    %ebx,%edx
80106c6a:	8b 45 08             	mov    0x8(%ebp),%eax
80106c6d:	e8 5e fa ff ff       	call   801066d0 <mappages>
80106c72:	83 c4 10             	add    $0x10,%esp
80106c75:	85 c0                	test   %eax,%eax
80106c77:	78 47                	js     80106cc0 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106c79:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c7f:	39 df                	cmp    %ebx,%edi
80106c81:	76 7d                	jbe    80106d00 <allocuvm+0xf0>
    mem = kalloc();
80106c83:	e8 78 b8 ff ff       	call   80102500 <kalloc>
    if(mem == 0){
80106c88:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
80106c8a:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106c8c:	75 ba                	jne    80106c48 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
80106c8e:	83 ec 0c             	sub    $0xc,%esp
80106c91:	68 65 78 10 80       	push   $0x80107865
80106c96:	e8 c5 99 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106c9b:	83 c4 10             	add    $0x10,%esp
80106c9e:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106ca1:	76 4b                	jbe    80106cee <allocuvm+0xde>
80106ca3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106ca6:	8b 45 08             	mov    0x8(%ebp),%eax
80106ca9:	89 fa                	mov    %edi,%edx
80106cab:	e8 b0 fa ff ff       	call   80106760 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80106cb0:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106cb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cb5:	5b                   	pop    %ebx
80106cb6:	5e                   	pop    %esi
80106cb7:	5f                   	pop    %edi
80106cb8:	5d                   	pop    %ebp
80106cb9:	c3                   	ret    
80106cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80106cc0:	83 ec 0c             	sub    $0xc,%esp
80106cc3:	68 7d 78 10 80       	push   $0x8010787d
80106cc8:	e8 93 99 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106ccd:	83 c4 10             	add    $0x10,%esp
80106cd0:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106cd3:	76 0d                	jbe    80106ce2 <allocuvm+0xd2>
80106cd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106cd8:	8b 45 08             	mov    0x8(%ebp),%eax
80106cdb:	89 fa                	mov    %edi,%edx
80106cdd:	e8 7e fa ff ff       	call   80106760 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80106ce2:	83 ec 0c             	sub    $0xc,%esp
80106ce5:	56                   	push   %esi
80106ce6:	e8 a5 b5 ff ff       	call   80102290 <kfree>
      return 0;
80106ceb:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
80106cee:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80106cf1:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80106cf3:	5b                   	pop    %ebx
80106cf4:	5e                   	pop    %esi
80106cf5:	5f                   	pop    %edi
80106cf6:	5d                   	pop    %ebp
80106cf7:	c3                   	ret    
80106cf8:	90                   	nop
80106cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d00:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106d03:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106d05:	5b                   	pop    %ebx
80106d06:	5e                   	pop    %esi
80106d07:	5f                   	pop    %edi
80106d08:	5d                   	pop    %ebp
80106d09:	c3                   	ret    
80106d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106d10 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106d10:	55                   	push   %ebp
80106d11:	89 e5                	mov    %esp,%ebp
80106d13:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d16:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106d19:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106d1c:	39 d1                	cmp    %edx,%ecx
80106d1e:	73 10                	jae    80106d30 <deallocuvm+0x20>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106d20:	5d                   	pop    %ebp
80106d21:	e9 3a fa ff ff       	jmp    80106760 <deallocuvm.part.0>
80106d26:	8d 76 00             	lea    0x0(%esi),%esi
80106d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106d30:	89 d0                	mov    %edx,%eax
80106d32:	5d                   	pop    %ebp
80106d33:	c3                   	ret    
80106d34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106d40 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106d40:	55                   	push   %ebp
80106d41:	89 e5                	mov    %esp,%ebp
80106d43:	57                   	push   %edi
80106d44:	56                   	push   %esi
80106d45:	53                   	push   %ebx
80106d46:	83 ec 0c             	sub    $0xc,%esp
80106d49:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106d4c:	85 f6                	test   %esi,%esi
80106d4e:	74 59                	je     80106da9 <freevm+0x69>
80106d50:	31 c9                	xor    %ecx,%ecx
80106d52:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106d57:	89 f0                	mov    %esi,%eax
80106d59:	e8 02 fa ff ff       	call   80106760 <deallocuvm.part.0>
80106d5e:	89 f3                	mov    %esi,%ebx
80106d60:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106d66:	eb 0f                	jmp    80106d77 <freevm+0x37>
80106d68:	90                   	nop
80106d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d70:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106d73:	39 fb                	cmp    %edi,%ebx
80106d75:	74 23                	je     80106d9a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106d77:	8b 03                	mov    (%ebx),%eax
80106d79:	a8 01                	test   $0x1,%al
80106d7b:	74 f3                	je     80106d70 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
80106d7d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d82:	83 ec 0c             	sub    $0xc,%esp
80106d85:	83 c3 04             	add    $0x4,%ebx
80106d88:	05 00 00 00 80       	add    $0x80000000,%eax
80106d8d:	50                   	push   %eax
80106d8e:	e8 fd b4 ff ff       	call   80102290 <kfree>
80106d93:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106d96:	39 fb                	cmp    %edi,%ebx
80106d98:	75 dd                	jne    80106d77 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106d9a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106d9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106da0:	5b                   	pop    %ebx
80106da1:	5e                   	pop    %esi
80106da2:	5f                   	pop    %edi
80106da3:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106da4:	e9 e7 b4 ff ff       	jmp    80102290 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80106da9:	83 ec 0c             	sub    $0xc,%esp
80106dac:	68 99 78 10 80       	push   $0x80107899
80106db1:	e8 ba 95 ff ff       	call   80100370 <panic>
80106db6:	8d 76 00             	lea    0x0(%esi),%esi
80106db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106dc0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106dc0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106dc1:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106dc3:	89 e5                	mov    %esp,%ebp
80106dc5:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106dc8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106dcb:	8b 45 08             	mov    0x8(%ebp),%eax
80106dce:	e8 7d f8 ff ff       	call   80106650 <walkpgdir>
  if(pte == 0)
80106dd3:	85 c0                	test   %eax,%eax
80106dd5:	74 05                	je     80106ddc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106dd7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106dda:	c9                   	leave  
80106ddb:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106ddc:	83 ec 0c             	sub    $0xc,%esp
80106ddf:	68 aa 78 10 80       	push   $0x801078aa
80106de4:	e8 87 95 ff ff       	call   80100370 <panic>
80106de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106df0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106df0:	55                   	push   %ebp
80106df1:	89 e5                	mov    %esp,%ebp
80106df3:	57                   	push   %edi
80106df4:	56                   	push   %esi
80106df5:	53                   	push   %ebx
80106df6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106df9:	e8 52 fb ff ff       	call   80106950 <setupkvm>
80106dfe:	85 c0                	test   %eax,%eax
80106e00:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106e03:	0f 84 b2 00 00 00    	je     80106ebb <copyuvm+0xcb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106e09:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106e0c:	85 c9                	test   %ecx,%ecx
80106e0e:	0f 84 9c 00 00 00    	je     80106eb0 <copyuvm+0xc0>
80106e14:	31 f6                	xor    %esi,%esi
80106e16:	eb 4a                	jmp    80106e62 <copyuvm+0x72>
80106e18:	90                   	nop
80106e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106e20:	83 ec 04             	sub    $0x4,%esp
80106e23:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106e29:	68 00 10 00 00       	push   $0x1000
80106e2e:	57                   	push   %edi
80106e2f:	50                   	push   %eax
80106e30:	e8 8b d7 ff ff       	call   801045c0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106e35:	58                   	pop    %eax
80106e36:	5a                   	pop    %edx
80106e37:	8d 93 00 00 00 80    	lea    -0x80000000(%ebx),%edx
80106e3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106e40:	ff 75 e4             	pushl  -0x1c(%ebp)
80106e43:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e48:	52                   	push   %edx
80106e49:	89 f2                	mov    %esi,%edx
80106e4b:	e8 80 f8 ff ff       	call   801066d0 <mappages>
80106e50:	83 c4 10             	add    $0x10,%esp
80106e53:	85 c0                	test   %eax,%eax
80106e55:	78 3e                	js     80106e95 <copyuvm+0xa5>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106e57:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106e5d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80106e60:	76 4e                	jbe    80106eb0 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106e62:	8b 45 08             	mov    0x8(%ebp),%eax
80106e65:	31 c9                	xor    %ecx,%ecx
80106e67:	89 f2                	mov    %esi,%edx
80106e69:	e8 e2 f7 ff ff       	call   80106650 <walkpgdir>
80106e6e:	85 c0                	test   %eax,%eax
80106e70:	74 5a                	je     80106ecc <copyuvm+0xdc>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80106e72:	8b 18                	mov    (%eax),%ebx
80106e74:	f6 c3 01             	test   $0x1,%bl
80106e77:	74 46                	je     80106ebf <copyuvm+0xcf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106e79:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
80106e7b:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
80106e81:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106e84:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
80106e8a:	e8 71 b6 ff ff       	call   80102500 <kalloc>
80106e8f:	85 c0                	test   %eax,%eax
80106e91:	89 c3                	mov    %eax,%ebx
80106e93:	75 8b                	jne    80106e20 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80106e95:	83 ec 0c             	sub    $0xc,%esp
80106e98:	ff 75 e0             	pushl  -0x20(%ebp)
80106e9b:	e8 a0 fe ff ff       	call   80106d40 <freevm>
  return 0;
80106ea0:	83 c4 10             	add    $0x10,%esp
80106ea3:	31 c0                	xor    %eax,%eax
}
80106ea5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ea8:	5b                   	pop    %ebx
80106ea9:	5e                   	pop    %esi
80106eaa:	5f                   	pop    %edi
80106eab:	5d                   	pop    %ebp
80106eac:	c3                   	ret    
80106ead:	8d 76 00             	lea    0x0(%esi),%esi
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106eb0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
80106eb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106eb6:	5b                   	pop    %ebx
80106eb7:	5e                   	pop    %esi
80106eb8:	5f                   	pop    %edi
80106eb9:	5d                   	pop    %ebp
80106eba:	c3                   	ret    
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
80106ebb:	31 c0                	xor    %eax,%eax
80106ebd:	eb e6                	jmp    80106ea5 <copyuvm+0xb5>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
80106ebf:	83 ec 0c             	sub    $0xc,%esp
80106ec2:	68 ce 78 10 80       	push   $0x801078ce
80106ec7:	e8 a4 94 ff ff       	call   80100370 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80106ecc:	83 ec 0c             	sub    $0xc,%esp
80106ecf:	68 b4 78 10 80       	push   $0x801078b4
80106ed4:	e8 97 94 ff ff       	call   80100370 <panic>
80106ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ee0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106ee0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106ee1:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106ee3:	89 e5                	mov    %esp,%ebp
80106ee5:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106ee8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106eeb:	8b 45 08             	mov    0x8(%ebp),%eax
80106eee:	e8 5d f7 ff ff       	call   80106650 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106ef3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80106ef5:	89 c2                	mov    %eax,%edx
80106ef7:	83 e2 05             	and    $0x5,%edx
80106efa:	83 fa 05             	cmp    $0x5,%edx
80106efd:	75 11                	jne    80106f10 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106eff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
80106f04:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106f05:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106f0a:	c3                   	ret    
80106f0b:	90                   	nop
80106f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80106f10:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80106f12:	c9                   	leave  
80106f13:	c3                   	ret    
80106f14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106f20 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106f20:	55                   	push   %ebp
80106f21:	89 e5                	mov    %esp,%ebp
80106f23:	57                   	push   %edi
80106f24:	56                   	push   %esi
80106f25:	53                   	push   %ebx
80106f26:	83 ec 1c             	sub    $0x1c,%esp
80106f29:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106f2c:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f2f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106f32:	85 db                	test   %ebx,%ebx
80106f34:	75 40                	jne    80106f76 <copyout+0x56>
80106f36:	eb 70                	jmp    80106fa8 <copyout+0x88>
80106f38:	90                   	nop
80106f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106f40:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106f43:	89 f1                	mov    %esi,%ecx
80106f45:	29 d1                	sub    %edx,%ecx
80106f47:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80106f4d:	39 d9                	cmp    %ebx,%ecx
80106f4f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106f52:	29 f2                	sub    %esi,%edx
80106f54:	83 ec 04             	sub    $0x4,%esp
80106f57:	01 d0                	add    %edx,%eax
80106f59:	51                   	push   %ecx
80106f5a:	57                   	push   %edi
80106f5b:	50                   	push   %eax
80106f5c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80106f5f:	e8 5c d6 ff ff       	call   801045c0 <memmove>
    len -= n;
    buf += n;
80106f64:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106f67:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
80106f6a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80106f70:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106f72:	29 cb                	sub    %ecx,%ebx
80106f74:	74 32                	je     80106fa8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80106f76:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106f78:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80106f7b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106f7e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106f84:	56                   	push   %esi
80106f85:	ff 75 08             	pushl  0x8(%ebp)
80106f88:	e8 53 ff ff ff       	call   80106ee0 <uva2ka>
    if(pa0 == 0)
80106f8d:	83 c4 10             	add    $0x10,%esp
80106f90:	85 c0                	test   %eax,%eax
80106f92:	75 ac                	jne    80106f40 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106f94:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80106f97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106f9c:	5b                   	pop    %ebx
80106f9d:	5e                   	pop    %esi
80106f9e:	5f                   	pop    %edi
80106f9f:	5d                   	pop    %ebp
80106fa0:	c3                   	ret    
80106fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fa8:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80106fab:	31 c0                	xor    %eax,%eax
}
80106fad:	5b                   	pop    %ebx
80106fae:	5e                   	pop    %esi
80106faf:	5f                   	pop    %edi
80106fb0:	5d                   	pop    %ebp
80106fb1:	c3                   	ret    
