
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
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
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
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 b0 30 10 80       	mov    $0x801030b0,%eax
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
80100044:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	68 60 76 10 80       	push   $0x80107660
80100051:	68 c0 c5 10 80       	push   $0x8010c5c0
80100056:	e8 a5 46 00 00       	call   80104700 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
80100062:	0c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
8010006c:	0c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc 0c 11 80       	mov    $0x80110cbc,%edx
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
8010008b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 67 76 10 80       	push   $0x80107667
80100097:	50                   	push   %eax
80100098:	e8 33 45 00 00       	call   801045d0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 0d 11 80       	mov    0x80110d10,%eax

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
801000b0:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc 0c 11 80       	cmp    $0x80110cbc,%eax
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
801000df:	68 c0 c5 10 80       	push   $0x8010c5c0
801000e4:	e8 77 47 00 00       	call   80104860 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 0d 11 80    	mov    0x80110d10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
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

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c 0d 11 80    	mov    0x80110d0c,%ebx
80100126:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
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
8010015d:	68 c0 c5 10 80       	push   $0x8010c5c0
80100162:	e8 a9 47 00 00       	call   80104910 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 9e 44 00 00       	call   80104610 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 bd 21 00 00       	call   80102340 <iderw>
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
80100193:	68 6e 76 10 80       	push   $0x8010766e
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
801001ae:	e8 fd 44 00 00       	call   801046b0 <holdingsleep>
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
801001c4:	e9 77 21 00 00       	jmp    80102340 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 7f 76 10 80       	push   $0x8010767f
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
801001ef:	e8 bc 44 00 00       	call   801046b0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 6c 44 00 00       	call   80104670 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010020b:	e8 50 46 00 00       	call   80104860 <acquire>
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
80100232:	a1 10 0d 11 80       	mov    0x80110d10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100241:	a1 10 0d 11 80       	mov    0x80110d10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
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
8010025c:	e9 af 46 00 00       	jmp    80104910 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 86 76 10 80       	push   $0x80107686
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
80100280:	e8 1b 17 00 00       	call   801019a0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 cf 45 00 00       	call   80104860 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e 9a 00 00 00    	jle    8010033b <consoleread+0xcb>
    while(input.r == input.w){
801002a1:	a1 20 10 11 80       	mov    0x80111020,%eax
801002a6:	3b 05 24 10 11 80    	cmp    0x80111024,%eax
801002ac:	74 24                	je     801002d2 <consoleread+0x62>
801002ae:	eb 58                	jmp    80100308 <consoleread+0x98>
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b0:	83 ec 08             	sub    $0x8,%esp
801002b3:	68 20 b5 10 80       	push   $0x8010b520
801002b8:	68 20 10 11 80       	push   $0x80111020
801002bd:	e8 be 3c 00 00       	call   80103f80 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c2:	a1 20 10 11 80       	mov    0x80111020,%eax
801002c7:	83 c4 10             	add    $0x10,%esp
801002ca:	3b 05 24 10 11 80    	cmp    0x80111024,%eax
801002d0:	75 36                	jne    80100308 <consoleread+0x98>
      if(myproc()->killed){
801002d2:	e8 f9 36 00 00       	call   801039d0 <myproc>
801002d7:	8b 40 24             	mov    0x24(%eax),%eax
801002da:	85 c0                	test   %eax,%eax
801002dc:	74 d2                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002de:	83 ec 0c             	sub    $0xc,%esp
801002e1:	68 20 b5 10 80       	push   $0x8010b520
801002e6:	e8 25 46 00 00       	call   80104910 <release>
        ilock(ip);
801002eb:	89 3c 24             	mov    %edi,(%esp)
801002ee:	e8 cd 15 00 00       	call   801018c0 <ilock>
        return -1;
801002f3:	83 c4 10             	add    $0x10,%esp
801002f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002fe:	5b                   	pop    %ebx
801002ff:	5e                   	pop    %esi
80100300:	5f                   	pop    %edi
80100301:	5d                   	pop    %ebp
80100302:	c3                   	ret    
80100303:	90                   	nop
80100304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100308:	8d 50 01             	lea    0x1(%eax),%edx
8010030b:	89 15 20 10 11 80    	mov    %edx,0x80111020
80100311:	89 c2                	mov    %eax,%edx
80100313:	83 e2 7f             	and    $0x7f,%edx
80100316:	0f be 92 a0 0f 11 80 	movsbl -0x7feef060(%edx),%edx
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
80100341:	68 20 b5 10 80       	push   $0x8010b520
80100346:	e8 c5 45 00 00       	call   80104910 <release>
  ilock(ip);
8010034b:	89 3c 24             	mov    %edi,(%esp)
8010034e:	e8 6d 15 00 00       	call   801018c0 <ilock>

  return target - n;
80100353:	83 c4 10             	add    $0x10,%esp
80100356:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100359:	eb a0                	jmp    801002fb <consoleread+0x8b>
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
80100360:	a3 20 10 11 80       	mov    %eax,0x80111020
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
80100375:	83 ec 30             	sub    $0x30,%esp
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
80100379:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
80100380:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
80100383:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100386:	8d 75 f8             	lea    -0x8(%ebp),%esi
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100389:	e8 b2 25 00 00       	call   80102940 <lapicid>
8010038e:	83 ec 08             	sub    $0x8,%esp
80100391:	50                   	push   %eax
80100392:	68 8d 76 10 80       	push   $0x8010768d
80100397:	e8 c4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	pushl  0x8(%ebp)
801003a0:	e8 bb 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 88 7c 10 80 	movl   $0x80107c88,(%esp)
801003ac:	e8 af 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	5a                   	pop    %edx
801003b2:	8d 45 08             	lea    0x8(%ebp),%eax
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 63 43 00 00       	call   80104720 <getcallerpcs>
801003bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	pushl  (%ebx)
801003c5:	83 c3 04             	add    $0x4,%ebx
801003c8:	68 a1 76 10 80       	push   $0x801076a1
801003cd:	e8 8e 02 00 00       	call   80100660 <cprintf>
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003d2:	83 c4 10             	add    $0x10,%esp
801003d5:	39 f3                	cmp    %esi,%ebx
801003d7:	75 e7                	jne    801003c0 <panic+0x50>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003d9:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
801003e0:	00 00 00 
801003e3:	eb fe                	jmp    801003e3 <panic+0x73>
801003e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801003e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801003f0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003f0:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
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
8010041a:	e8 01 5e 00 00       	call   80106220 <uartputc>
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
801004d3:	e8 48 5d 00 00       	call   80106220 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 3c 5d 00 00       	call   80106220 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 30 5d 00 00       	call   80106220 <uartputc>
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
80100514:	e8 f7 44 00 00       	call   80104a10 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 32 44 00 00       	call   80104960 <memset>
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
80100540:	68 a5 76 10 80       	push   $0x801076a5
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
801005b1:	0f b6 92 d0 76 10 80 	movzbl -0x7fef8930(%edx),%edx
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
8010060f:	e8 8c 13 00 00       	call   801019a0 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 40 42 00 00       	call   80104860 <acquire>
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
80100642:	68 20 b5 10 80       	push   $0x8010b520
80100647:	e8 c4 42 00 00       	call   80104910 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 6b 12 00 00       	call   801018c0 <ilock>

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
80100669:	a1 54 b5 10 80       	mov    0x8010b554,%eax
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
80100708:	68 20 b5 10 80       	push   $0x8010b520
8010070d:	e8 fe 41 00 00       	call   80104910 <release>
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
80100788:	b8 b8 76 10 80       	mov    $0x801076b8,%eax
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
801007c3:	68 20 b5 10 80       	push   $0x8010b520
801007c8:	e8 93 40 00 00       	call   80104860 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 bf 76 10 80       	push   $0x801076bf
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
801007fe:	68 20 b5 10 80       	push   $0x8010b520
80100803:	e8 58 40 00 00       	call   80104860 <acquire>
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
80100831:	a1 28 10 11 80       	mov    0x80111028,%eax
80100836:	3b 05 24 10 11 80    	cmp    0x80111024,%eax
8010083c:	74 d2                	je     80100810 <consoleintr+0x20>
        input.e--;
8010083e:	83 e8 01             	sub    $0x1,%eax
80100841:	a3 28 10 11 80       	mov    %eax,0x80111028
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
80100863:	68 20 b5 10 80       	push   $0x8010b520
80100868:	e8 a3 40 00 00       	call   80104910 <release>
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
80100889:	a1 28 10 11 80       	mov    0x80111028,%eax
8010088e:	89 c2                	mov    %eax,%edx
80100890:	2b 15 20 10 11 80    	sub    0x80111020,%edx
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
801008a8:	89 15 28 10 11 80    	mov    %edx,0x80111028
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008ae:	0f 84 c8 00 00 00    	je     8010097c <consoleintr+0x18c>
        input.buf[input.e++ % INPUT_BUF] = c;
801008b4:	89 f9                	mov    %edi,%ecx
801008b6:	88 88 a0 0f 11 80    	mov    %cl,-0x7feef060(%eax)
        consputc(c);
801008bc:	89 f8                	mov    %edi,%eax
801008be:	e8 2d fb ff ff       	call   801003f0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c3:	83 ff 0a             	cmp    $0xa,%edi
801008c6:	0f 84 c1 00 00 00    	je     8010098d <consoleintr+0x19d>
801008cc:	83 ff 04             	cmp    $0x4,%edi
801008cf:	0f 84 b8 00 00 00    	je     8010098d <consoleintr+0x19d>
801008d5:	a1 20 10 11 80       	mov    0x80111020,%eax
801008da:	83 e8 80             	sub    $0xffffff80,%eax
801008dd:	39 05 28 10 11 80    	cmp    %eax,0x80111028
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
801008ec:	a3 24 10 11 80       	mov    %eax,0x80111024
          wakeup(&input.r);
801008f1:	68 20 10 11 80       	push   $0x80111020
801008f6:	e8 35 38 00 00       	call   80104130 <wakeup>
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
80100908:	a1 28 10 11 80       	mov    0x80111028,%eax
8010090d:	39 05 24 10 11 80    	cmp    %eax,0x80111024
80100913:	75 2b                	jne    80100940 <consoleintr+0x150>
80100915:	e9 f6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100920:	a3 28 10 11 80       	mov    %eax,0x80111028
        consputc(BACKSPACE);
80100925:	b8 00 01 00 00       	mov    $0x100,%eax
8010092a:	e8 c1 fa ff ff       	call   801003f0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010092f:	a1 28 10 11 80       	mov    0x80111028,%eax
80100934:	3b 05 24 10 11 80    	cmp    0x80111024,%eax
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
80100948:	80 ba a0 0f 11 80 0a 	cmpb   $0xa,-0x7feef060(%edx)
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
80100977:	e9 64 3a 00 00       	jmp    801043e0 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010097c:	c6 80 a0 0f 11 80 0a 	movb   $0xa,-0x7feef060(%eax)
        consputc(c);
80100983:	b8 0a 00 00 00       	mov    $0xa,%eax
80100988:	e8 63 fa ff ff       	call   801003f0 <consputc>
8010098d:	a1 28 10 11 80       	mov    0x80111028,%eax
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
801009a6:	68 c8 76 10 80       	push   $0x801076c8
801009ab:	68 20 b5 10 80       	push   $0x8010b520
801009b0:	e8 4b 3d 00 00       	call   80104700 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009b5:	58                   	pop    %eax
801009b6:	5a                   	pop    %edx
801009b7:	6a 00                	push   $0x0
801009b9:	6a 01                	push   $0x1
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
801009bb:	c7 05 ec 19 11 80 00 	movl   $0x80100600,0x801119ec
801009c2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009c5:	c7 05 e8 19 11 80 70 	movl   $0x80100270,0x801119e8
801009cc:	02 10 80 
  cons.locking = 1;
801009cf:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
801009d6:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
801009d9:	e8 12 1b 00 00       	call   801024f0 <ioapicenable>
}
801009de:	83 c4 10             	add    $0x10,%esp
801009e1:	c9                   	leave  
801009e2:	c3                   	ret    
801009e3:	66 90                	xchg   %ax,%ax
801009e5:	66 90                	xchg   %ax,%ax
801009e7:	66 90                	xchg   %ax,%ax
801009e9:	66 90                	xchg   %ax,%ax
801009eb:	66 90                	xchg   %ax,%ax
801009ed:	66 90                	xchg   %ax,%ax
801009ef:	90                   	nop

801009f0 <get_size_string>:
#include "proc.h"
#include "defs.h"
#include "x86.h"
#include "elf.h"

int get_size_string(char* string){
801009f0:	55                   	push   %ebp
    int i=0;
801009f1:	31 c0                	xor    %eax,%eax
#include "proc.h"
#include "defs.h"
#include "x86.h"
#include "elf.h"

int get_size_string(char* string){
801009f3:	89 e5                	mov    %esp,%ebp
801009f5:	8b 55 08             	mov    0x8(%ebp),%edx
    int i=0;
    while(1){
        if(string[i]=='\0')
801009f8:	80 3a 00             	cmpb   $0x0,(%edx)
801009fb:	74 0c                	je     80100a09 <get_size_string+0x19>
801009fd:	8d 76 00             	lea    0x0(%esi),%esi
            break;
        i++;
80100a00:	83 c0 01             	add    $0x1,%eax
#include "elf.h"

int get_size_string(char* string){
    int i=0;
    while(1){
        if(string[i]=='\0')
80100a03:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80100a07:	75 f7                	jne    80100a00 <get_size_string+0x10>
            break;
        i++;
    }
    return i;
}
80100a09:	5d                   	pop    %ebp
80100a0a:	c3                   	ret    
80100a0b:	90                   	nop
80100a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100a10 <exec>:

int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 7c 01 00 00    	sub    $0x17c,%esp
80100a1c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a1f:	e8 ac 2f 00 00       	call   801039d0 <myproc>
80100a24:	89 85 84 fe ff ff    	mov    %eax,-0x17c(%ebp)
#include "elf.h"

int get_size_string(char* string){
    int i=0;
    while(1){
        if(string[i]=='\0')
80100a2a:	0f b6 03             	movzbl (%ebx),%eax
80100a2d:	84 c0                	test   %al,%al
80100a2f:	0f 84 5f 03 00 00    	je     80100d94 <exec+0x384>
80100a35:	31 f6                	xor    %esi,%esi
80100a37:	89 f6                	mov    %esi,%esi
80100a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            break;
        i++;
80100a40:	83 c6 01             	add    $0x1,%esi
#include "elf.h"

int get_size_string(char* string){
    int i=0;
    while(1){
        if(string[i]=='\0')
80100a43:	80 3c 33 00          	cmpb   $0x0,(%ebx,%esi,1)
80100a47:	75 f7                	jne    80100a40 <exec+0x30>
80100a49:	80 3d 20 0f 11 80 00 	cmpb   $0x0,0x80110f20
80100a50:	0f 84 1b 03 00 00    	je     80100d71 <exec+0x361>
#include "defs.h"
#include "x86.h"
#include "elf.h"

int get_size_string(char* string){
    int i=0;
80100a56:	31 d2                	xor    %edx,%edx
80100a58:	90                   	nop
80100a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    while(1){
        if(string[i]=='\0')
            break;
        i++;
80100a60:	83 c2 01             	add    $0x1,%edx
#include "elf.h"

int get_size_string(char* string){
    int i=0;
    while(1){
        if(string[i]=='\0')
80100a63:	80 ba 20 0f 11 80 00 	cmpb   $0x0,-0x7feef0e0(%edx)
80100a6a:	75 f4                	jne    80100a60 <exec+0x50>
80100a6c:	84 c0                	test   %al,%al
80100a6e:	89 95 94 fe ff ff    	mov    %edx,-0x16c(%ebp)
80100a74:	0f 84 06 03 00 00    	je     80100d80 <exec+0x370>
80100a7a:	31 c0                	xor    %eax,%eax
80100a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            break;
        i++;
80100a80:	83 c0 01             	add    $0x1,%eax
#include "elf.h"

int get_size_string(char* string){
    int i=0;
    while(1){
        if(string[i]=='\0')
80100a83:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
80100a87:	75 f7                	jne    80100a80 <exec+0x70>
80100a89:	89 85 88 fe ff ff    	mov    %eax,-0x178(%ebp)
  int fsize=get_size_string(path);
  int found=0;//found == 0 if ip not found
  int size=get_size_string(add_path);
  int psize=get_size_string(path);
  int c=0;
  begin_op();
80100a8f:	e8 0c 23 00 00       	call   80102da0 <begin_op>
  //add
  if(size>0){
80100a94:	8b 95 94 fe ff ff    	mov    -0x16c(%ebp),%edx
80100a9a:	85 d2                	test   %edx,%edx
80100a9c:	0f 84 9f 01 00 00    	je     80100c41 <exec+0x231>
80100aa2:	85 f6                	test   %esi,%esi
80100aa4:	b8 00 00 00 00       	mov    $0x0,%eax
80100aa9:	0f 49 c6             	cmovns %esi,%eax
  int fsize=get_size_string(path);
  int found=0;//found == 0 if ip not found
  int size=get_size_string(add_path);
  int psize=get_size_string(path);
  int c=0;
  begin_op();
80100aac:	31 c9                	xor    %ecx,%ecx
80100aae:	89 85 8c fe ff ff    	mov    %eax,-0x174(%ebp)
80100ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ab8:	89 b5 90 fe ff ff    	mov    %esi,-0x170(%ebp)
80100abe:	89 cf                	mov    %ecx,%edi
80100ac0:	31 c0                	xor    %eax,%eax
80100ac2:	8b b5 94 fe ff ff    	mov    -0x16c(%ebp),%esi
80100ac8:	eb 17                	jmp    80100ae1 <exec+0xd1>
80100aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(size>0){
  for(j=0;j<size;j++){
     while(add_path[j]!=':'){
       	temp[ii]=add_path[j];
        ii++;
        j++; 
80100ad0:	83 c7 01             	add    $0x1,%edi
  begin_op();
  //add
  if(size>0){
  for(j=0;j<size;j++){
     while(add_path[j]!=':'){
       	temp[ii]=add_path[j];
80100ad3:	88 94 05 f4 fe ff ff 	mov    %dl,-0x10c(%ebp,%eax,1)
        ii++;
80100ada:	83 c0 01             	add    $0x1,%eax
        j++; 
        if(j>=size)
80100add:	39 f7                	cmp    %esi,%edi
80100adf:	7d 0d                	jge    80100aee <exec+0xde>
  int c=0;
  begin_op();
  //add
  if(size>0){
  for(j=0;j<size;j++){
     while(add_path[j]!=':'){
80100ae1:	0f b6 94 01 20 0f 11 	movzbl -0x7feef0e0(%ecx,%eax,1),%edx
80100ae8:	80 
80100ae9:	80 fa 3a             	cmp    $0x3a,%dl
80100aec:	75 e2                	jne    80100ad0 <exec+0xc0>
80100aee:	8b b5 90 fe ff ff    	mov    -0x170(%ebp),%esi
        ii++;
        j++; 
        if(j>=size)
            break;
     }
     temp[ii]='/';
80100af4:	c6 84 05 f4 fe ff ff 	movb   $0x2f,-0x10c(%ebp,%eax,1)
80100afb:	2f 
       ii++;
80100afc:	8d 48 01             	lea    0x1(%eax),%ecx
     for(c=0;c<fsize;c++){
80100aff:	85 f6                	test   %esi,%esi
80100b01:	74 2a                	je     80100b2d <exec+0x11d>
       temp[ii+c]=path[c];}
80100b03:	8d 95 f4 fe ff ff    	lea    -0x10c(%ebp),%edx
80100b09:	89 8d 90 fe ff ff    	mov    %ecx,-0x170(%ebp)
80100b0f:	01 d0                	add    %edx,%eax
80100b11:	31 d2                	xor    %edx,%edx
80100b13:	90                   	nop
80100b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100b18:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80100b1c:	88 4c 10 01          	mov    %cl,0x1(%eax,%edx,1)
        if(j>=size)
            break;
     }
     temp[ii]='/';
       ii++;
     for(c=0;c<fsize;c++){
80100b20:	83 c2 01             	add    $0x1,%edx
80100b23:	39 f2                	cmp    %esi,%edx
80100b25:	75 f1                	jne    80100b18 <exec+0x108>
80100b27:	8b 8d 90 fe ff ff    	mov    -0x170(%ebp),%ecx
       temp[ii+c]=path[c];}
       temp[ii+c]='\0';
80100b2d:	8d 45 e8             	lea    -0x18(%ebp),%eax
       ii=0;
       //cprintf("search path:%s\n",temp);
       ip=namei(temp);
80100b30:	83 ec 0c             	sub    $0xc,%esp
     }
     temp[ii]='/';
       ii++;
     for(c=0;c<fsize;c++){
       temp[ii+c]=path[c];}
       temp[ii+c]='\0';
80100b33:	01 c1                	add    %eax,%ecx
80100b35:	8b 85 8c fe ff ff    	mov    -0x174(%ebp),%eax
80100b3b:	c6 84 08 0c ff ff ff 	movb   $0x0,-0xf4(%eax,%ecx,1)
80100b42:	00 
       ii=0;
       //cprintf("search path:%s\n",temp);
       ip=namei(temp);
80100b43:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
80100b49:	50                   	push   %eax
80100b4a:	e8 c1 15 00 00       	call   80102110 <namei>
       if(ip != 0){
80100b4f:	83 c4 10             	add    $0x10,%esp
80100b52:	85 c0                	test   %eax,%eax
80100b54:	0f 85 8e 00 00 00    	jne    80100be8 <exec+0x1d8>
  int psize=get_size_string(path);
  int c=0;
  begin_op();
  //add
  if(size>0){
  for(j=0;j<size;j++){
80100b5a:	8d 4f 01             	lea    0x1(%edi),%ecx
80100b5d:	3b 8d 94 fe ff ff    	cmp    -0x16c(%ebp),%ecx
80100b63:	0f 8c 4f ff ff ff    	jl     80100ab8 <exec+0xa8>
	 found=1;
         break;
       }
     }
  if(!found){
        if(path[0]!='/'){
80100b69:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80100b6c:	0f 84 cf 00 00 00    	je     80100c41 <exec+0x231>
	   temp[0]='/';
  	   for (c=0;c<psize;c++){
80100b72:	8b 8d 88 fe ff ff    	mov    -0x178(%ebp),%ecx
         break;
       }
     }
  if(!found){
        if(path[0]!='/'){
	   temp[0]='/';
80100b78:	c6 85 f4 fe ff ff 2f 	movb   $0x2f,-0x10c(%ebp)
  	   for (c=0;c<psize;c++){
80100b7f:	85 c9                	test   %ecx,%ecx
80100b81:	0f 84 21 02 00 00    	je     80100da8 <exec+0x398>
80100b87:	31 c0                	xor    %eax,%eax
80100b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
             temp[c+1]=path[c];
80100b90:	83 c0 01             	add    $0x1,%eax
80100b93:	0f b6 54 03 ff       	movzbl -0x1(%ebx,%eax,1),%edx
       }
     }
  if(!found){
        if(path[0]!='/'){
	   temp[0]='/';
  	   for (c=0;c<psize;c++){
80100b98:	39 c8                	cmp    %ecx,%eax
             temp[c+1]=path[c];
80100b9a:	88 94 05 f4 fe ff ff 	mov    %dl,-0x10c(%ebp,%eax,1)
       }
     }
  if(!found){
        if(path[0]!='/'){
	   temp[0]='/';
  	   for (c=0;c<psize;c++){
80100ba1:	75 ed                	jne    80100b90 <exec+0x180>
80100ba3:	83 c0 01             	add    $0x1,%eax
             temp[c+1]=path[c];
           }
  	   temp[c+1]='\0';
80100ba6:	c6 84 05 f4 fe ff ff 	movb   $0x0,-0x10c(%ebp,%eax,1)
80100bad:	00 
         }
       if(path[0]!='/')
          ip=namei(temp);
80100bae:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
80100bb4:	83 ec 0c             	sub    $0xc,%esp
80100bb7:	50                   	push   %eax
80100bb8:	e8 53 15 00 00       	call   80102110 <namei>
80100bbd:	83 c4 10             	add    $0x10,%esp
80100bc0:	89 c2                	mov    %eax,%edx
    return -1;
  }
  }
  else{
   ip=namei(path);
   if(ip == 0){
80100bc2:	85 d2                	test   %edx,%edx
80100bc4:	75 24                	jne    80100bea <exec+0x1da>
    end_op();
80100bc6:	e8 45 22 00 00       	call   80102e10 <end_op>
    cprintf("exec: fail\n");
80100bcb:	83 ec 0c             	sub    $0xc,%esp
80100bce:	68 e1 76 10 80       	push   $0x801076e1
80100bd3:	e8 88 fa ff ff       	call   80100660 <cprintf>
    return -1;
80100bd8:	83 c4 10             	add    $0x10,%esp
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
}
80100bdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  else{
   ip=namei(path);
   if(ip == 0){
    end_op();
    cprintf("exec: fail\n");
    return -1;
80100bde:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
}
80100be3:	5b                   	pop    %ebx
80100be4:	5e                   	pop    %esi
80100be5:	5f                   	pop    %edi
80100be6:	5d                   	pop    %ebp
80100be7:	c3                   	ret    
80100be8:	89 c2                	mov    %eax,%edx
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  }
  ilock(ip);
80100bea:	83 ec 0c             	sub    $0xc,%esp
80100bed:	89 95 94 fe ff ff    	mov    %edx,-0x16c(%ebp)
80100bf3:	52                   	push   %edx
80100bf4:	e8 c7 0c 00 00       	call   801018c0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100bf9:	8b 95 94 fe ff ff    	mov    -0x16c(%ebp),%edx
80100bff:	8d 85 c0 fe ff ff    	lea    -0x140(%ebp),%eax
80100c05:	6a 34                	push   $0x34
80100c07:	6a 00                	push   $0x0
80100c09:	50                   	push   %eax
80100c0a:	52                   	push   %edx
80100c0b:	e8 90 0f 00 00       	call   80101ba0 <readi>
80100c10:	83 c4 20             	add    $0x20,%esp
80100c13:	83 f8 34             	cmp    $0x34,%eax
80100c16:	8b 95 94 fe ff ff    	mov    -0x16c(%ebp),%edx
80100c1c:	74 36                	je     80100c54 <exec+0x244>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100c1e:	83 ec 0c             	sub    $0xc,%esp
80100c21:	52                   	push   %edx
80100c22:	e8 29 0f 00 00       	call   80101b50 <iunlockput>
    end_op();
80100c27:	e8 e4 21 00 00       	call   80102e10 <end_op>
80100c2c:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100c2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100c34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c37:	5b                   	pop    %ebx
80100c38:	5e                   	pop    %esi
80100c39:	5f                   	pop    %edi
80100c3a:	5d                   	pop    %ebp
80100c3b:	c3                   	ret    
  int fsize=get_size_string(path);
  int found=0;//found == 0 if ip not found
  int size=get_size_string(add_path);
  int psize=get_size_string(path);
  int c=0;
  begin_op();
80100c3c:	e8 5f 21 00 00       	call   80102da0 <begin_op>
    cprintf("exec: fail\n");
    return -1;
  }
  }
  else{
   ip=namei(path);
80100c41:	83 ec 0c             	sub    $0xc,%esp
80100c44:	53                   	push   %ebx
80100c45:	e8 c6 14 00 00       	call   80102110 <namei>
   if(ip == 0){
80100c4a:	83 c4 10             	add    $0x10,%esp
    cprintf("exec: fail\n");
    return -1;
  }
  }
  else{
   ip=namei(path);
80100c4d:	89 c2                	mov    %eax,%edx
80100c4f:	e9 6e ff ff ff       	jmp    80100bc2 <exec+0x1b2>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100c54:	81 bd c0 fe ff ff 7f 	cmpl   $0x464c457f,-0x140(%ebp)
80100c5b:	45 4c 46 
80100c5e:	75 be                	jne    80100c1e <exec+0x20e>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100c60:	e8 4b 67 00 00       	call   801073b0 <setupkvm>
80100c65:	85 c0                	test   %eax,%eax
80100c67:	89 c6                	mov    %eax,%esi
80100c69:	8b 95 94 fe ff ff    	mov    -0x16c(%ebp),%edx
80100c6f:	74 ad                	je     80100c1e <exec+0x20e>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c71:	66 83 bd ec fe ff ff 	cmpw   $0x0,-0x114(%ebp)
80100c78:	00 
80100c79:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
80100c7f:	89 85 90 fe ff ff    	mov    %eax,-0x170(%ebp)
80100c85:	0f 84 27 01 00 00    	je     80100db2 <exec+0x3a2>
80100c8b:	89 5d 08             	mov    %ebx,0x8(%ebp)
80100c8e:	31 ff                	xor    %edi,%edi
80100c90:	c7 85 94 fe ff ff 00 	movl   $0x0,-0x16c(%ebp)
80100c97:	00 00 00 
80100c9a:	89 d3                	mov    %edx,%ebx
80100c9c:	eb 25                	jmp    80100cc3 <exec+0x2b3>
80100c9e:	66 90                	xchg   %ax,%ax
80100ca0:	83 85 94 fe ff ff 01 	addl   $0x1,-0x16c(%ebp)
80100ca7:	0f b7 85 ec fe ff ff 	movzwl -0x114(%ebp),%eax
80100cae:	8b 8d 94 fe ff ff    	mov    -0x16c(%ebp),%ecx
80100cb4:	83 85 90 fe ff ff 20 	addl   $0x20,-0x170(%ebp)
80100cbb:	39 c8                	cmp    %ecx,%eax
80100cbd:	0f 8e 2f 01 00 00    	jle    80100df2 <exec+0x3e2>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100cc3:	8d 85 a0 fe ff ff    	lea    -0x160(%ebp),%eax
80100cc9:	6a 20                	push   $0x20
80100ccb:	ff b5 90 fe ff ff    	pushl  -0x170(%ebp)
80100cd1:	50                   	push   %eax
80100cd2:	53                   	push   %ebx
80100cd3:	e8 c8 0e 00 00       	call   80101ba0 <readi>
80100cd8:	83 c4 10             	add    $0x10,%esp
80100cdb:	83 f8 20             	cmp    $0x20,%eax
80100cde:	75 62                	jne    80100d42 <exec+0x332>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100ce0:	83 bd a0 fe ff ff 01 	cmpl   $0x1,-0x160(%ebp)
80100ce7:	75 b7                	jne    80100ca0 <exec+0x290>
      continue;
    if(ph.memsz < ph.filesz)
80100ce9:	8b 85 b4 fe ff ff    	mov    -0x14c(%ebp),%eax
80100cef:	3b 85 b0 fe ff ff    	cmp    -0x150(%ebp),%eax
80100cf5:	72 4b                	jb     80100d42 <exec+0x332>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100cf7:	03 85 a8 fe ff ff    	add    -0x158(%ebp),%eax
80100cfd:	72 43                	jb     80100d42 <exec+0x332>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100cff:	83 ec 04             	sub    $0x4,%esp
80100d02:	50                   	push   %eax
80100d03:	57                   	push   %edi
80100d04:	56                   	push   %esi
80100d05:	e8 f6 64 00 00       	call   80107200 <allocuvm>
80100d0a:	83 c4 10             	add    $0x10,%esp
80100d0d:	85 c0                	test   %eax,%eax
80100d0f:	89 c7                	mov    %eax,%edi
80100d11:	74 2f                	je     80100d42 <exec+0x332>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100d13:	8b 85 a8 fe ff ff    	mov    -0x158(%ebp),%eax
80100d19:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100d1e:	75 22                	jne    80100d42 <exec+0x332>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100d20:	83 ec 0c             	sub    $0xc,%esp
80100d23:	ff b5 b0 fe ff ff    	pushl  -0x150(%ebp)
80100d29:	ff b5 a4 fe ff ff    	pushl  -0x15c(%ebp)
80100d2f:	53                   	push   %ebx
80100d30:	50                   	push   %eax
80100d31:	56                   	push   %esi
80100d32:	e8 09 64 00 00       	call   80107140 <loaduvm>
80100d37:	83 c4 20             	add    $0x20,%esp
80100d3a:	85 c0                	test   %eax,%eax
80100d3c:	0f 89 5e ff ff ff    	jns    80100ca0 <exec+0x290>
80100d42:	89 da                	mov    %ebx,%edx
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100d44:	83 ec 0c             	sub    $0xc,%esp
80100d47:	89 95 94 fe ff ff    	mov    %edx,-0x16c(%ebp)
80100d4d:	56                   	push   %esi
80100d4e:	e8 dd 65 00 00       	call   80107330 <freevm>
  if(ip){
80100d53:	8b 95 94 fe ff ff    	mov    -0x16c(%ebp),%edx
80100d59:	83 c4 10             	add    $0x10,%esp
80100d5c:	85 d2                	test   %edx,%edx
80100d5e:	0f 85 ba fe ff ff    	jne    80100c1e <exec+0x20e>
    iunlockput(ip);
    end_op();
  }
  return -1;
}
80100d64:	8d 65 f4             	lea    -0xc(%ebp),%esp
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100d67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100d6c:	5b                   	pop    %ebx
80100d6d:	5e                   	pop    %esi
80100d6e:	5f                   	pop    %edi
80100d6f:	5d                   	pop    %ebp
80100d70:	c3                   	ret    
#include "elf.h"

int get_size_string(char* string){
    int i=0;
    while(1){
        if(string[i]=='\0')
80100d71:	c7 85 94 fe ff ff 00 	movl   $0x0,-0x16c(%ebp)
80100d78:	00 00 00 
80100d7b:	e9 fa fc ff ff       	jmp    80100a7a <exec+0x6a>
  int fsize=get_size_string(path);
  int found=0;//found == 0 if ip not found
  int size=get_size_string(add_path);
  int psize=get_size_string(path);
  int c=0;
  begin_op();
80100d80:	e8 1b 20 00 00       	call   80102da0 <begin_op>
80100d85:	c7 85 88 fe ff ff 00 	movl   $0x0,-0x178(%ebp)
80100d8c:	00 00 00 
80100d8f:	e9 0e fd ff ff       	jmp    80100aa2 <exec+0x92>
#include "elf.h"

int get_size_string(char* string){
    int i=0;
    while(1){
        if(string[i]=='\0')
80100d94:	80 3d 20 0f 11 80 00 	cmpb   $0x0,0x80110f20
80100d9b:	0f 84 9b fe ff ff    	je     80100c3c <exec+0x22c>
#include "defs.h"
#include "x86.h"
#include "elf.h"

int get_size_string(char* string){
    int i=0;
80100da1:	31 f6                	xor    %esi,%esi
80100da3:	e9 ae fc ff ff       	jmp    80100a56 <exec+0x46>
       }
     }
  if(!found){
        if(path[0]!='/'){
	   temp[0]='/';
  	   for (c=0;c<psize;c++){
80100da8:	b8 01 00 00 00       	mov    $0x1,%eax
80100dad:	e9 f4 fd ff ff       	jmp    80100ba6 <exec+0x196>
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100db2:	b8 00 20 00 00       	mov    $0x2000,%eax
80100db7:	31 ff                	xor    %edi,%edi
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100db9:	83 ec 0c             	sub    $0xc,%esp
80100dbc:	89 85 94 fe ff ff    	mov    %eax,-0x16c(%ebp)
80100dc2:	52                   	push   %edx
80100dc3:	e8 88 0d 00 00       	call   80101b50 <iunlockput>
  end_op();
80100dc8:	e8 43 20 00 00       	call   80102e10 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100dcd:	8b 85 94 fe ff ff    	mov    -0x16c(%ebp),%eax
80100dd3:	83 c4 0c             	add    $0xc,%esp
80100dd6:	50                   	push   %eax
80100dd7:	57                   	push   %edi
80100dd8:	56                   	push   %esi
80100dd9:	e8 22 64 00 00       	call   80107200 <allocuvm>
80100dde:	83 c4 10             	add    $0x10,%esp
80100de1:	85 c0                	test   %eax,%eax
80100de3:	89 85 94 fe ff ff    	mov    %eax,-0x16c(%ebp)
80100de9:	75 20                	jne    80100e0b <exec+0x3fb>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
  end_op();
  ip = 0;
80100deb:	31 d2                	xor    %edx,%edx
80100ded:	e9 52 ff ff ff       	jmp    80100d44 <exec+0x334>
80100df2:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100df8:	89 da                	mov    %ebx,%edx
80100dfa:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100dfd:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100e03:	8d 87 00 20 00 00    	lea    0x2000(%edi),%eax
80100e09:	eb ae                	jmp    80100db9 <exec+0x3a9>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100e0b:	8b bd 94 fe ff ff    	mov    -0x16c(%ebp),%edi
80100e11:	83 ec 08             	sub    $0x8,%esp
80100e14:	89 f8                	mov    %edi,%eax
80100e16:	2d 00 20 00 00       	sub    $0x2000,%eax
80100e1b:	50                   	push   %eax
80100e1c:	56                   	push   %esi
80100e1d:	e8 2e 66 00 00       	call   80107450 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100e22:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e25:	83 c4 10             	add    $0x10,%esp
80100e28:	31 d2                	xor    %edx,%edx
80100e2a:	8b 08                	mov    (%eax),%ecx
80100e2c:	85 c9                	test   %ecx,%ecx
80100e2e:	74 6a                	je     80100e9a <exec+0x48a>
80100e30:	89 5d 08             	mov    %ebx,0x8(%ebp)
80100e33:	89 d3                	mov    %edx,%ebx
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e35:	83 ec 0c             	sub    $0xc,%esp
80100e38:	51                   	push   %ecx
80100e39:	e8 62 3d 00 00       	call   80104ba0 <strlen>
80100e3e:	f7 d0                	not    %eax
80100e40:	01 c7                	add    %eax,%edi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e42:	58                   	pop    %eax
80100e43:	8b 45 0c             	mov    0xc(%ebp),%eax

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e46:	83 e7 fc             	and    $0xfffffffc,%edi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e49:	ff 34 98             	pushl  (%eax,%ebx,4)
80100e4c:	e8 4f 3d 00 00       	call   80104ba0 <strlen>
80100e51:	83 c0 01             	add    $0x1,%eax
80100e54:	50                   	push   %eax
80100e55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e58:	ff 34 98             	pushl  (%eax,%ebx,4)
80100e5b:	57                   	push   %edi
80100e5c:	56                   	push   %esi
80100e5d:	e8 5e 67 00 00       	call   801075c0 <copyout>
80100e62:	83 c4 20             	add    $0x20,%esp
80100e65:	85 c0                	test   %eax,%eax
80100e67:	78 82                	js     80100deb <exec+0x3db>
      goto bad;
    ustack[3+argc] = sp;
80100e69:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100e6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100e72:	89 bc 9d 64 ff ff ff 	mov    %edi,-0x9c(%ebp,%ebx,4)
80100e79:	89 85 88 fe ff ff    	mov    %eax,-0x178(%ebp)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100e7f:	8d 43 01             	lea    0x1(%ebx),%eax
80100e82:	8b 0c 81             	mov    (%ecx,%eax,4),%ecx
80100e85:	85 c9                	test   %ecx,%ecx
80100e87:	0f 84 f8 00 00 00    	je     80100f85 <exec+0x575>
    if(argc >= MAXARG)
80100e8d:	83 f8 20             	cmp    $0x20,%eax
80100e90:	0f 84 55 ff ff ff    	je     80100deb <exec+0x3db>
80100e96:	89 c3                	mov    %eax,%ebx
80100e98:	eb 9b                	jmp    80100e35 <exec+0x425>
80100e9a:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100ea0:	8b bd 94 fe ff ff    	mov    -0x16c(%ebp),%edi
80100ea6:	b9 10 00 00 00       	mov    $0x10,%ecx
80100eab:	ba 04 00 00 00       	mov    $0x4,%edx
80100eb0:	c7 85 8c fe ff ff 03 	movl   $0x3,-0x174(%ebp)
80100eb7:	00 00 00 
80100eba:	c7 85 90 fe ff ff 00 	movl   $0x0,-0x170(%ebp)
80100ec1:	00 00 00 
80100ec4:	89 85 88 fe ff ff    	mov    %eax,-0x178(%ebp)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100eca:	8b 85 8c fe ff ff    	mov    -0x174(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ed0:	51                   	push   %ecx
80100ed1:	ff b5 88 fe ff ff    	pushl  -0x178(%ebp)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100ed7:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80100ede:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
80100ee2:	8b 85 90 fe ff ff    	mov    -0x170(%ebp),%eax
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
80100ee8:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100eef:	ff ff ff 
  ustack[1] = argc;
80100ef2:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ef8:	89 f8                	mov    %edi,%eax

  sp -= (3+argc+1) * 4;
80100efa:	29 cf                	sub    %ecx,%edi
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100efc:	57                   	push   %edi
80100efd:	56                   	push   %esi
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100efe:	29 d0                	sub    %edx,%eax
80100f00:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100f06:	e8 b5 66 00 00       	call   801075c0 <copyout>
80100f0b:	83 c4 10             	add    $0x10,%esp
80100f0e:	85 c0                	test   %eax,%eax
80100f10:	0f 88 d5 fe ff ff    	js     80100deb <exec+0x3db>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100f16:	0f b6 13             	movzbl (%ebx),%edx
80100f19:	84 d2                	test   %dl,%dl
80100f1b:	74 13                	je     80100f30 <exec+0x520>
80100f1d:	8d 43 01             	lea    0x1(%ebx),%eax
    if(*s == '/')
      last = s+1;
80100f20:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100f23:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100f26:	0f 44 d8             	cmove  %eax,%ebx
80100f29:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100f2c:	84 d2                	test   %dl,%dl
80100f2e:	75 f0                	jne    80100f20 <exec+0x510>
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100f30:	83 ec 04             	sub    $0x4,%esp
80100f33:	6a 10                	push   $0x10
80100f35:	53                   	push   %ebx
80100f36:	8b 9d 84 fe ff ff    	mov    -0x17c(%ebp),%ebx
80100f3c:	89 d8                	mov    %ebx,%eax
80100f3e:	83 c0 6c             	add    $0x6c,%eax
80100f41:	50                   	push   %eax
80100f42:	e8 19 3c 00 00       	call   80104b60 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100f47:	89 d8                	mov    %ebx,%eax
80100f49:	8b 5b 04             	mov    0x4(%ebx),%ebx
  curproc->pgdir = pgdir;
80100f4c:	89 70 04             	mov    %esi,0x4(%eax)
  curproc->sz = sz;
80100f4f:	8b b5 94 fe ff ff    	mov    -0x16c(%ebp),%esi
80100f55:	89 30                	mov    %esi,(%eax)
  curproc->tf->eip = elf.entry;  // main
80100f57:	89 c6                	mov    %eax,%esi
80100f59:	8b 95 d8 fe ff ff    	mov    -0x128(%ebp),%edx
80100f5f:	8b 40 18             	mov    0x18(%eax),%eax
80100f62:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100f65:	8b 46 18             	mov    0x18(%esi),%eax
80100f68:	89 78 44             	mov    %edi,0x44(%eax)
  switchuvm(curproc);
80100f6b:	89 34 24             	mov    %esi,(%esp)
80100f6e:	e8 3d 60 00 00       	call   80106fb0 <switchuvm>
  freevm(oldpgdir);
80100f73:	89 1c 24             	mov    %ebx,(%esp)
80100f76:	e8 b5 63 00 00       	call   80107330 <freevm>
  return 0;
80100f7b:	83 c4 10             	add    $0x10,%esp
80100f7e:	31 c0                	xor    %eax,%eax
80100f80:	e9 af fc ff ff       	jmp    80100c34 <exec+0x224>
80100f85:	89 da                	mov    %ebx,%edx
80100f87:	89 85 90 fe ff ff    	mov    %eax,-0x170(%ebp)
80100f8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f90:	8d 42 04             	lea    0x4(%edx),%eax
80100f93:	8d 14 95 08 00 00 00 	lea    0x8(,%edx,4),%edx
80100f9a:	89 85 8c fe ff ff    	mov    %eax,-0x174(%ebp)
80100fa0:	8d 4a 0c             	lea    0xc(%edx),%ecx
80100fa3:	e9 22 ff ff ff       	jmp    80100eca <exec+0x4ba>
80100fa8:	66 90                	xchg   %ax,%ax
80100faa:	66 90                	xchg   %ax,%ax
80100fac:	66 90                	xchg   %ax,%ax
80100fae:	66 90                	xchg   %ax,%ax

80100fb0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100fb0:	55                   	push   %ebp
80100fb1:	89 e5                	mov    %esp,%ebp
80100fb3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100fb6:	68 ed 76 10 80       	push   $0x801076ed
80100fbb:	68 40 10 11 80       	push   $0x80111040
80100fc0:	e8 3b 37 00 00       	call   80104700 <initlock>
}
80100fc5:	83 c4 10             	add    $0x10,%esp
80100fc8:	c9                   	leave  
80100fc9:	c3                   	ret    
80100fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100fd0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fd4:	bb 74 10 11 80       	mov    $0x80111074,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100fd9:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100fdc:	68 40 10 11 80       	push   $0x80111040
80100fe1:	e8 7a 38 00 00       	call   80104860 <acquire>
80100fe6:	83 c4 10             	add    $0x10,%esp
80100fe9:	eb 10                	jmp    80100ffb <filealloc+0x2b>
80100feb:	90                   	nop
80100fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ff0:	83 c3 18             	add    $0x18,%ebx
80100ff3:	81 fb d4 19 11 80    	cmp    $0x801119d4,%ebx
80100ff9:	74 25                	je     80101020 <filealloc+0x50>
    if(f->ref == 0){
80100ffb:	8b 43 04             	mov    0x4(%ebx),%eax
80100ffe:	85 c0                	test   %eax,%eax
80101000:	75 ee                	jne    80100ff0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101002:	83 ec 0c             	sub    $0xc,%esp
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80101005:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010100c:	68 40 10 11 80       	push   $0x80111040
80101011:	e8 fa 38 00 00       	call   80104910 <release>
      return f;
80101016:	89 d8                	mov    %ebx,%eax
80101018:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
8010101b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010101e:	c9                   	leave  
8010101f:	c3                   	ret    
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80101020:	83 ec 0c             	sub    $0xc,%esp
80101023:	68 40 10 11 80       	push   $0x80111040
80101028:	e8 e3 38 00 00       	call   80104910 <release>
  return 0;
8010102d:	83 c4 10             	add    $0x10,%esp
80101030:	31 c0                	xor    %eax,%eax
}
80101032:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101035:	c9                   	leave  
80101036:	c3                   	ret    
80101037:	89 f6                	mov    %esi,%esi
80101039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101040 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101040:	55                   	push   %ebp
80101041:	89 e5                	mov    %esp,%ebp
80101043:	53                   	push   %ebx
80101044:	83 ec 10             	sub    $0x10,%esp
80101047:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010104a:	68 40 10 11 80       	push   $0x80111040
8010104f:	e8 0c 38 00 00       	call   80104860 <acquire>
  if(f->ref < 1)
80101054:	8b 43 04             	mov    0x4(%ebx),%eax
80101057:	83 c4 10             	add    $0x10,%esp
8010105a:	85 c0                	test   %eax,%eax
8010105c:	7e 1a                	jle    80101078 <filedup+0x38>
    panic("filedup");
  f->ref++;
8010105e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101061:	83 ec 0c             	sub    $0xc,%esp
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
80101064:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80101067:	68 40 10 11 80       	push   $0x80111040
8010106c:	e8 9f 38 00 00       	call   80104910 <release>
  return f;
}
80101071:	89 d8                	mov    %ebx,%eax
80101073:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101076:	c9                   	leave  
80101077:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80101078:	83 ec 0c             	sub    $0xc,%esp
8010107b:	68 f4 76 10 80       	push   $0x801076f4
80101080:	e8 eb f2 ff ff       	call   80100370 <panic>
80101085:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101090 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101090:	55                   	push   %ebp
80101091:	89 e5                	mov    %esp,%ebp
80101093:	57                   	push   %edi
80101094:	56                   	push   %esi
80101095:	53                   	push   %ebx
80101096:	83 ec 28             	sub    $0x28,%esp
80101099:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
8010109c:	68 40 10 11 80       	push   $0x80111040
801010a1:	e8 ba 37 00 00       	call   80104860 <acquire>
  if(f->ref < 1)
801010a6:	8b 47 04             	mov    0x4(%edi),%eax
801010a9:	83 c4 10             	add    $0x10,%esp
801010ac:	85 c0                	test   %eax,%eax
801010ae:	0f 8e 9b 00 00 00    	jle    8010114f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
801010b4:	83 e8 01             	sub    $0x1,%eax
801010b7:	85 c0                	test   %eax,%eax
801010b9:	89 47 04             	mov    %eax,0x4(%edi)
801010bc:	74 1a                	je     801010d8 <fileclose+0x48>
    release(&ftable.lock);
801010be:	c7 45 08 40 10 11 80 	movl   $0x80111040,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
801010c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010c8:	5b                   	pop    %ebx
801010c9:	5e                   	pop    %esi
801010ca:	5f                   	pop    %edi
801010cb:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
801010cc:	e9 3f 38 00 00       	jmp    80104910 <release>
801010d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
801010d8:	0f b6 47 09          	movzbl 0x9(%edi),%eax
801010dc:	8b 1f                	mov    (%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
801010de:	83 ec 0c             	sub    $0xc,%esp
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
801010e1:	8b 77 0c             	mov    0xc(%edi),%esi
  f->ref = 0;
  f->type = FD_NONE;
801010e4:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
801010ea:	88 45 e7             	mov    %al,-0x19(%ebp)
801010ed:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
801010f0:	68 40 10 11 80       	push   $0x80111040
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
801010f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
801010f8:	e8 13 38 00 00       	call   80104910 <release>

  if(ff.type == FD_PIPE)
801010fd:	83 c4 10             	add    $0x10,%esp
80101100:	83 fb 01             	cmp    $0x1,%ebx
80101103:	74 13                	je     80101118 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80101105:	83 fb 02             	cmp    $0x2,%ebx
80101108:	74 26                	je     80101130 <fileclose+0xa0>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
8010110a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010110d:	5b                   	pop    %ebx
8010110e:	5e                   	pop    %esi
8010110f:	5f                   	pop    %edi
80101110:	5d                   	pop    %ebp
80101111:	c3                   	ret    
80101112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80101118:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
8010111c:	83 ec 08             	sub    $0x8,%esp
8010111f:	53                   	push   %ebx
80101120:	56                   	push   %esi
80101121:	e8 1a 24 00 00       	call   80103540 <pipeclose>
80101126:	83 c4 10             	add    $0x10,%esp
80101129:	eb df                	jmp    8010110a <fileclose+0x7a>
8010112b:	90                   	nop
8010112c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80101130:	e8 6b 1c 00 00       	call   80102da0 <begin_op>
    iput(ff.ip);
80101135:	83 ec 0c             	sub    $0xc,%esp
80101138:	ff 75 e0             	pushl  -0x20(%ebp)
8010113b:	e8 b0 08 00 00       	call   801019f0 <iput>
    end_op();
80101140:	83 c4 10             	add    $0x10,%esp
  }
}
80101143:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101146:	5b                   	pop    %ebx
80101147:	5e                   	pop    %esi
80101148:	5f                   	pop    %edi
80101149:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
8010114a:	e9 c1 1c 00 00       	jmp    80102e10 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
8010114f:	83 ec 0c             	sub    $0xc,%esp
80101152:	68 fc 76 10 80       	push   $0x801076fc
80101157:	e8 14 f2 ff ff       	call   80100370 <panic>
8010115c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101160 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101160:	55                   	push   %ebp
80101161:	89 e5                	mov    %esp,%ebp
80101163:	53                   	push   %ebx
80101164:	83 ec 04             	sub    $0x4,%esp
80101167:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010116a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010116d:	75 31                	jne    801011a0 <filestat+0x40>
    ilock(f->ip);
8010116f:	83 ec 0c             	sub    $0xc,%esp
80101172:	ff 73 10             	pushl  0x10(%ebx)
80101175:	e8 46 07 00 00       	call   801018c0 <ilock>
    stati(f->ip, st);
8010117a:	58                   	pop    %eax
8010117b:	5a                   	pop    %edx
8010117c:	ff 75 0c             	pushl  0xc(%ebp)
8010117f:	ff 73 10             	pushl  0x10(%ebx)
80101182:	e8 e9 09 00 00       	call   80101b70 <stati>
    iunlock(f->ip);
80101187:	59                   	pop    %ecx
80101188:	ff 73 10             	pushl  0x10(%ebx)
8010118b:	e8 10 08 00 00       	call   801019a0 <iunlock>
    return 0;
80101190:	83 c4 10             	add    $0x10,%esp
80101193:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80101195:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101198:	c9                   	leave  
80101199:	c3                   	ret    
8010119a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
801011a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801011a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801011a8:	c9                   	leave  
801011a9:	c3                   	ret    
801011aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801011b0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801011b0:	55                   	push   %ebp
801011b1:	89 e5                	mov    %esp,%ebp
801011b3:	57                   	push   %edi
801011b4:	56                   	push   %esi
801011b5:	53                   	push   %ebx
801011b6:	83 ec 0c             	sub    $0xc,%esp
801011b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801011bc:	8b 75 0c             	mov    0xc(%ebp),%esi
801011bf:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
801011c2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801011c6:	74 60                	je     80101228 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
801011c8:	8b 03                	mov    (%ebx),%eax
801011ca:	83 f8 01             	cmp    $0x1,%eax
801011cd:	74 41                	je     80101210 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801011cf:	83 f8 02             	cmp    $0x2,%eax
801011d2:	75 5b                	jne    8010122f <fileread+0x7f>
    ilock(f->ip);
801011d4:	83 ec 0c             	sub    $0xc,%esp
801011d7:	ff 73 10             	pushl  0x10(%ebx)
801011da:	e8 e1 06 00 00       	call   801018c0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801011df:	57                   	push   %edi
801011e0:	ff 73 14             	pushl  0x14(%ebx)
801011e3:	56                   	push   %esi
801011e4:	ff 73 10             	pushl  0x10(%ebx)
801011e7:	e8 b4 09 00 00       	call   80101ba0 <readi>
801011ec:	83 c4 20             	add    $0x20,%esp
801011ef:	85 c0                	test   %eax,%eax
801011f1:	89 c6                	mov    %eax,%esi
801011f3:	7e 03                	jle    801011f8 <fileread+0x48>
      f->off += r;
801011f5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801011f8:	83 ec 0c             	sub    $0xc,%esp
801011fb:	ff 73 10             	pushl  0x10(%ebx)
801011fe:	e8 9d 07 00 00       	call   801019a0 <iunlock>
    return r;
80101203:	83 c4 10             	add    $0x10,%esp
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101206:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80101208:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010120b:	5b                   	pop    %ebx
8010120c:	5e                   	pop    %esi
8010120d:	5f                   	pop    %edi
8010120e:	5d                   	pop    %ebp
8010120f:	c3                   	ret    
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80101210:	8b 43 0c             	mov    0xc(%ebx),%eax
80101213:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80101216:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101219:	5b                   	pop    %ebx
8010121a:	5e                   	pop    %esi
8010121b:	5f                   	pop    %edi
8010121c:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
8010121d:	e9 be 24 00 00       	jmp    801036e0 <piperead>
80101222:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80101228:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010122d:	eb d9                	jmp    80101208 <fileread+0x58>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
8010122f:	83 ec 0c             	sub    $0xc,%esp
80101232:	68 06 77 10 80       	push   $0x80107706
80101237:	e8 34 f1 ff ff       	call   80100370 <panic>
8010123c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101240 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	57                   	push   %edi
80101244:	56                   	push   %esi
80101245:	53                   	push   %ebx
80101246:	83 ec 1c             	sub    $0x1c,%esp
80101249:	8b 75 08             	mov    0x8(%ebp),%esi
8010124c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010124f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101253:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101256:	8b 45 10             	mov    0x10(%ebp),%eax
80101259:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
8010125c:	0f 84 aa 00 00 00    	je     8010130c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101262:	8b 06                	mov    (%esi),%eax
80101264:	83 f8 01             	cmp    $0x1,%eax
80101267:	0f 84 c2 00 00 00    	je     8010132f <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010126d:	83 f8 02             	cmp    $0x2,%eax
80101270:	0f 85 d8 00 00 00    	jne    8010134e <filewrite+0x10e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101276:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101279:	31 ff                	xor    %edi,%edi
8010127b:	85 c0                	test   %eax,%eax
8010127d:	7f 34                	jg     801012b3 <filewrite+0x73>
8010127f:	e9 9c 00 00 00       	jmp    80101320 <filewrite+0xe0>
80101284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101288:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010128b:	83 ec 0c             	sub    $0xc,%esp
8010128e:	ff 76 10             	pushl  0x10(%esi)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101291:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101294:	e8 07 07 00 00       	call   801019a0 <iunlock>
      end_op();
80101299:	e8 72 1b 00 00       	call   80102e10 <end_op>
8010129e:	8b 45 e0             	mov    -0x20(%ebp),%eax
801012a1:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
801012a4:	39 d8                	cmp    %ebx,%eax
801012a6:	0f 85 95 00 00 00    	jne    80101341 <filewrite+0x101>
        panic("short filewrite");
      i += r;
801012ac:	01 c7                	add    %eax,%edi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801012ae:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801012b1:	7e 6d                	jle    80101320 <filewrite+0xe0>
      int n1 = n - i;
801012b3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801012b6:	b8 00 06 00 00       	mov    $0x600,%eax
801012bb:	29 fb                	sub    %edi,%ebx
801012bd:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
801012c3:	0f 4f d8             	cmovg  %eax,%ebx
      if(n1 > max)
        n1 = max;

      begin_op();
801012c6:	e8 d5 1a 00 00       	call   80102da0 <begin_op>
      ilock(f->ip);
801012cb:	83 ec 0c             	sub    $0xc,%esp
801012ce:	ff 76 10             	pushl  0x10(%esi)
801012d1:	e8 ea 05 00 00       	call   801018c0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801012d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012d9:	53                   	push   %ebx
801012da:	ff 76 14             	pushl  0x14(%esi)
801012dd:	01 f8                	add    %edi,%eax
801012df:	50                   	push   %eax
801012e0:	ff 76 10             	pushl  0x10(%esi)
801012e3:	e8 b8 09 00 00       	call   80101ca0 <writei>
801012e8:	83 c4 20             	add    $0x20,%esp
801012eb:	85 c0                	test   %eax,%eax
801012ed:	7f 99                	jg     80101288 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
801012ef:	83 ec 0c             	sub    $0xc,%esp
801012f2:	ff 76 10             	pushl  0x10(%esi)
801012f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801012f8:	e8 a3 06 00 00       	call   801019a0 <iunlock>
      end_op();
801012fd:	e8 0e 1b 00 00       	call   80102e10 <end_op>

      if(r < 0)
80101302:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101305:	83 c4 10             	add    $0x10,%esp
80101308:	85 c0                	test   %eax,%eax
8010130a:	74 98                	je     801012a4 <filewrite+0x64>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010130c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
8010130f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101314:	5b                   	pop    %ebx
80101315:	5e                   	pop    %esi
80101316:	5f                   	pop    %edi
80101317:	5d                   	pop    %ebp
80101318:	c3                   	ret    
80101319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80101320:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101323:	75 e7                	jne    8010130c <filewrite+0xcc>
  }
  panic("filewrite");
}
80101325:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101328:	89 f8                	mov    %edi,%eax
8010132a:	5b                   	pop    %ebx
8010132b:	5e                   	pop    %esi
8010132c:	5f                   	pop    %edi
8010132d:	5d                   	pop    %ebp
8010132e:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
8010132f:	8b 46 0c             	mov    0xc(%esi),%eax
80101332:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
80101335:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101338:	5b                   	pop    %ebx
80101339:	5e                   	pop    %esi
8010133a:	5f                   	pop    %edi
8010133b:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
8010133c:	e9 9f 22 00 00       	jmp    801035e0 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
80101341:	83 ec 0c             	sub    $0xc,%esp
80101344:	68 0f 77 10 80       	push   $0x8010770f
80101349:	e8 22 f0 ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
8010134e:	83 ec 0c             	sub    $0xc,%esp
80101351:	68 15 77 10 80       	push   $0x80107715
80101356:	e8 15 f0 ff ff       	call   80100370 <panic>
8010135b:	66 90                	xchg   %ax,%ax
8010135d:	66 90                	xchg   %ax,%ax
8010135f:	90                   	nop

80101360 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	56                   	push   %esi
80101364:	53                   	push   %ebx
80101365:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101367:	c1 ea 0c             	shr    $0xc,%edx
8010136a:	03 15 58 1a 11 80    	add    0x80111a58,%edx
80101370:	83 ec 08             	sub    $0x8,%esp
80101373:	52                   	push   %edx
80101374:	50                   	push   %eax
80101375:	e8 56 ed ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010137a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010137c:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101382:	ba 01 00 00 00       	mov    $0x1,%edx
80101387:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010138a:	c1 fb 03             	sar    $0x3,%ebx
8010138d:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101390:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101392:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101397:	85 d1                	test   %edx,%ecx
80101399:	74 27                	je     801013c2 <bfree+0x62>
8010139b:	89 c6                	mov    %eax,%esi
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010139d:	f7 d2                	not    %edx
8010139f:	89 c8                	mov    %ecx,%eax
  log_write(bp);
801013a1:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801013a4:	21 d0                	and    %edx,%eax
801013a6:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
801013aa:	56                   	push   %esi
801013ab:	e8 d0 1b 00 00       	call   80102f80 <log_write>
  brelse(bp);
801013b0:	89 34 24             	mov    %esi,(%esp)
801013b3:	e8 28 ee ff ff       	call   801001e0 <brelse>
}
801013b8:	83 c4 10             	add    $0x10,%esp
801013bb:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013be:	5b                   	pop    %ebx
801013bf:	5e                   	pop    %esi
801013c0:	5d                   	pop    %ebp
801013c1:	c3                   	ret    

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
801013c2:	83 ec 0c             	sub    $0xc,%esp
801013c5:	68 1f 77 10 80       	push   $0x8010771f
801013ca:	e8 a1 ef ff ff       	call   80100370 <panic>
801013cf:	90                   	nop

801013d0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801013d0:	55                   	push   %ebp
801013d1:	89 e5                	mov    %esp,%ebp
801013d3:	57                   	push   %edi
801013d4:	56                   	push   %esi
801013d5:	53                   	push   %ebx
801013d6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801013d9:	8b 0d 40 1a 11 80    	mov    0x80111a40,%ecx
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801013df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801013e2:	85 c9                	test   %ecx,%ecx
801013e4:	0f 84 85 00 00 00    	je     8010146f <balloc+0x9f>
801013ea:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801013f1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801013f4:	83 ec 08             	sub    $0x8,%esp
801013f7:	89 f0                	mov    %esi,%eax
801013f9:	c1 f8 0c             	sar    $0xc,%eax
801013fc:	03 05 58 1a 11 80    	add    0x80111a58,%eax
80101402:	50                   	push   %eax
80101403:	ff 75 d8             	pushl  -0x28(%ebp)
80101406:	e8 c5 ec ff ff       	call   801000d0 <bread>
8010140b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010140e:	a1 40 1a 11 80       	mov    0x80111a40,%eax
80101413:	83 c4 10             	add    $0x10,%esp
80101416:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101419:	31 c0                	xor    %eax,%eax
8010141b:	eb 2d                	jmp    8010144a <balloc+0x7a>
8010141d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101420:	89 c1                	mov    %eax,%ecx
80101422:	ba 01 00 00 00       	mov    $0x1,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101427:	8b 5d e4             	mov    -0x1c(%ebp),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010142a:	83 e1 07             	and    $0x7,%ecx
8010142d:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010142f:	89 c1                	mov    %eax,%ecx
80101431:	c1 f9 03             	sar    $0x3,%ecx
80101434:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
80101439:	85 d7                	test   %edx,%edi
8010143b:	74 43                	je     80101480 <balloc+0xb0>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010143d:	83 c0 01             	add    $0x1,%eax
80101440:	83 c6 01             	add    $0x1,%esi
80101443:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101448:	74 05                	je     8010144f <balloc+0x7f>
8010144a:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010144d:	72 d1                	jb     80101420 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010144f:	83 ec 0c             	sub    $0xc,%esp
80101452:	ff 75 e4             	pushl  -0x1c(%ebp)
80101455:	e8 86 ed ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010145a:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101461:	83 c4 10             	add    $0x10,%esp
80101464:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101467:	39 05 40 1a 11 80    	cmp    %eax,0x80111a40
8010146d:	77 82                	ja     801013f1 <balloc+0x21>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010146f:	83 ec 0c             	sub    $0xc,%esp
80101472:	68 32 77 10 80       	push   $0x80107732
80101477:	e8 f4 ee ff ff       	call   80100370 <panic>
8010147c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101480:	09 fa                	or     %edi,%edx
80101482:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101485:	83 ec 0c             	sub    $0xc,%esp
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101488:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010148c:	57                   	push   %edi
8010148d:	e8 ee 1a 00 00       	call   80102f80 <log_write>
        brelse(bp);
80101492:	89 3c 24             	mov    %edi,(%esp)
80101495:	e8 46 ed ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
8010149a:	58                   	pop    %eax
8010149b:	5a                   	pop    %edx
8010149c:	56                   	push   %esi
8010149d:	ff 75 d8             	pushl  -0x28(%ebp)
801014a0:	e8 2b ec ff ff       	call   801000d0 <bread>
801014a5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801014a7:	8d 40 5c             	lea    0x5c(%eax),%eax
801014aa:	83 c4 0c             	add    $0xc,%esp
801014ad:	68 00 02 00 00       	push   $0x200
801014b2:	6a 00                	push   $0x0
801014b4:	50                   	push   %eax
801014b5:	e8 a6 34 00 00       	call   80104960 <memset>
  log_write(bp);
801014ba:	89 1c 24             	mov    %ebx,(%esp)
801014bd:	e8 be 1a 00 00       	call   80102f80 <log_write>
  brelse(bp);
801014c2:	89 1c 24             	mov    %ebx,(%esp)
801014c5:	e8 16 ed ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
801014ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014cd:	89 f0                	mov    %esi,%eax
801014cf:	5b                   	pop    %ebx
801014d0:	5e                   	pop    %esi
801014d1:	5f                   	pop    %edi
801014d2:	5d                   	pop    %ebp
801014d3:	c3                   	ret    
801014d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801014e0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801014e0:	55                   	push   %ebp
801014e1:	89 e5                	mov    %esp,%ebp
801014e3:	57                   	push   %edi
801014e4:	56                   	push   %esi
801014e5:	53                   	push   %ebx
801014e6:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801014e8:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801014ea:	bb 94 1a 11 80       	mov    $0x80111a94,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801014ef:	83 ec 28             	sub    $0x28,%esp
801014f2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
801014f5:	68 60 1a 11 80       	push   $0x80111a60
801014fa:	e8 61 33 00 00       	call   80104860 <acquire>
801014ff:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101502:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101505:	eb 1b                	jmp    80101522 <iget+0x42>
80101507:	89 f6                	mov    %esi,%esi
80101509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101510:	85 f6                	test   %esi,%esi
80101512:	74 44                	je     80101558 <iget+0x78>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101514:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010151a:	81 fb b4 36 11 80    	cmp    $0x801136b4,%ebx
80101520:	74 4e                	je     80101570 <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101522:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101525:	85 c9                	test   %ecx,%ecx
80101527:	7e e7                	jle    80101510 <iget+0x30>
80101529:	39 3b                	cmp    %edi,(%ebx)
8010152b:	75 e3                	jne    80101510 <iget+0x30>
8010152d:	39 53 04             	cmp    %edx,0x4(%ebx)
80101530:	75 de                	jne    80101510 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
80101532:	83 ec 0c             	sub    $0xc,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101535:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
80101538:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010153a:	68 60 1a 11 80       	push   $0x80111a60

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
8010153f:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101542:	e8 c9 33 00 00       	call   80104910 <release>
      return ip;
80101547:	83 c4 10             	add    $0x10,%esp
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010154a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010154d:	89 f0                	mov    %esi,%eax
8010154f:	5b                   	pop    %ebx
80101550:	5e                   	pop    %esi
80101551:	5f                   	pop    %edi
80101552:	5d                   	pop    %ebp
80101553:	c3                   	ret    
80101554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101558:	85 c9                	test   %ecx,%ecx
8010155a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010155d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101563:	81 fb b4 36 11 80    	cmp    $0x801136b4,%ebx
80101569:	75 b7                	jne    80101522 <iget+0x42>
8010156b:	90                   	nop
8010156c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101570:	85 f6                	test   %esi,%esi
80101572:	74 2d                	je     801015a1 <iget+0xc1>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101574:	83 ec 0c             	sub    $0xc,%esp
  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101577:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101579:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010157c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101583:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010158a:	68 60 1a 11 80       	push   $0x80111a60
8010158f:	e8 7c 33 00 00       	call   80104910 <release>

  return ip;
80101594:	83 c4 10             	add    $0x10,%esp
}
80101597:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010159a:	89 f0                	mov    %esi,%eax
8010159c:	5b                   	pop    %ebx
8010159d:	5e                   	pop    %esi
8010159e:	5f                   	pop    %edi
8010159f:	5d                   	pop    %ebp
801015a0:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
801015a1:	83 ec 0c             	sub    $0xc,%esp
801015a4:	68 48 77 10 80       	push   $0x80107748
801015a9:	e8 c2 ed ff ff       	call   80100370 <panic>
801015ae:	66 90                	xchg   %ax,%ax

801015b0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801015b0:	55                   	push   %ebp
801015b1:	89 e5                	mov    %esp,%ebp
801015b3:	57                   	push   %edi
801015b4:	56                   	push   %esi
801015b5:	53                   	push   %ebx
801015b6:	89 c6                	mov    %eax,%esi
801015b8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801015bb:	83 fa 0b             	cmp    $0xb,%edx
801015be:	77 18                	ja     801015d8 <bmap+0x28>
801015c0:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    if((addr = ip->addrs[bn]) == 0)
801015c3:	8b 43 5c             	mov    0x5c(%ebx),%eax
801015c6:	85 c0                	test   %eax,%eax
801015c8:	74 76                	je     80101640 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801015ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015cd:	5b                   	pop    %ebx
801015ce:	5e                   	pop    %esi
801015cf:	5f                   	pop    %edi
801015d0:	5d                   	pop    %ebp
801015d1:	c3                   	ret    
801015d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801015d8:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801015db:	83 fb 7f             	cmp    $0x7f,%ebx
801015de:	0f 87 83 00 00 00    	ja     80101667 <bmap+0xb7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801015e4:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801015ea:	85 c0                	test   %eax,%eax
801015ec:	74 6a                	je     80101658 <bmap+0xa8>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801015ee:	83 ec 08             	sub    $0x8,%esp
801015f1:	50                   	push   %eax
801015f2:	ff 36                	pushl  (%esi)
801015f4:	e8 d7 ea ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801015f9:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801015fd:	83 c4 10             	add    $0x10,%esp

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101600:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101602:	8b 1a                	mov    (%edx),%ebx
80101604:	85 db                	test   %ebx,%ebx
80101606:	75 1d                	jne    80101625 <bmap+0x75>
      a[bn] = addr = balloc(ip->dev);
80101608:	8b 06                	mov    (%esi),%eax
8010160a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010160d:	e8 be fd ff ff       	call   801013d0 <balloc>
80101612:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101615:	83 ec 0c             	sub    $0xc,%esp
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
80101618:	89 c3                	mov    %eax,%ebx
8010161a:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010161c:	57                   	push   %edi
8010161d:	e8 5e 19 00 00       	call   80102f80 <log_write>
80101622:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101625:	83 ec 0c             	sub    $0xc,%esp
80101628:	57                   	push   %edi
80101629:	e8 b2 eb ff ff       	call   801001e0 <brelse>
8010162e:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101631:	8d 65 f4             	lea    -0xc(%ebp),%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101634:	89 d8                	mov    %ebx,%eax
    return addr;
  }

  panic("bmap: out of range");
}
80101636:	5b                   	pop    %ebx
80101637:	5e                   	pop    %esi
80101638:	5f                   	pop    %edi
80101639:	5d                   	pop    %ebp
8010163a:	c3                   	ret    
8010163b:	90                   	nop
8010163c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101640:	8b 06                	mov    (%esi),%eax
80101642:	e8 89 fd ff ff       	call   801013d0 <balloc>
80101647:	89 43 5c             	mov    %eax,0x5c(%ebx)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010164a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010164d:	5b                   	pop    %ebx
8010164e:	5e                   	pop    %esi
8010164f:	5f                   	pop    %edi
80101650:	5d                   	pop    %ebp
80101651:	c3                   	ret    
80101652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101658:	8b 06                	mov    (%esi),%eax
8010165a:	e8 71 fd ff ff       	call   801013d0 <balloc>
8010165f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101665:	eb 87                	jmp    801015ee <bmap+0x3e>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101667:	83 ec 0c             	sub    $0xc,%esp
8010166a:	68 58 77 10 80       	push   $0x80107758
8010166f:	e8 fc ec ff ff       	call   80100370 <panic>
80101674:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010167a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101680 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	56                   	push   %esi
80101684:	53                   	push   %ebx
80101685:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
80101688:	83 ec 08             	sub    $0x8,%esp
8010168b:	6a 01                	push   $0x1
8010168d:	ff 75 08             	pushl  0x8(%ebp)
80101690:	e8 3b ea ff ff       	call   801000d0 <bread>
80101695:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101697:	8d 40 5c             	lea    0x5c(%eax),%eax
8010169a:	83 c4 0c             	add    $0xc,%esp
8010169d:	6a 1c                	push   $0x1c
8010169f:	50                   	push   %eax
801016a0:	56                   	push   %esi
801016a1:	e8 6a 33 00 00       	call   80104a10 <memmove>
  brelse(bp);
801016a6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801016a9:	83 c4 10             	add    $0x10,%esp
}
801016ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016af:	5b                   	pop    %ebx
801016b0:	5e                   	pop    %esi
801016b1:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
801016b2:	e9 29 eb ff ff       	jmp    801001e0 <brelse>
801016b7:	89 f6                	mov    %esi,%esi
801016b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801016c0 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
801016c0:	55                   	push   %ebp
801016c1:	89 e5                	mov    %esp,%ebp
801016c3:	53                   	push   %ebx
801016c4:	bb a0 1a 11 80       	mov    $0x80111aa0,%ebx
801016c9:	83 ec 0c             	sub    $0xc,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
801016cc:	68 6b 77 10 80       	push   $0x8010776b
801016d1:	68 60 1a 11 80       	push   $0x80111a60
801016d6:	e8 25 30 00 00       	call   80104700 <initlock>
801016db:	83 c4 10             	add    $0x10,%esp
801016de:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
801016e0:	83 ec 08             	sub    $0x8,%esp
801016e3:	68 72 77 10 80       	push   $0x80107772
801016e8:	53                   	push   %ebx
801016e9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801016ef:	e8 dc 2e 00 00       	call   801045d0 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
801016f4:	83 c4 10             	add    $0x10,%esp
801016f7:	81 fb c0 36 11 80    	cmp    $0x801136c0,%ebx
801016fd:	75 e1                	jne    801016e0 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
801016ff:	83 ec 08             	sub    $0x8,%esp
80101702:	68 40 1a 11 80       	push   $0x80111a40
80101707:	ff 75 08             	pushl  0x8(%ebp)
8010170a:	e8 71 ff ff ff       	call   80101680 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010170f:	ff 35 58 1a 11 80    	pushl  0x80111a58
80101715:	ff 35 54 1a 11 80    	pushl  0x80111a54
8010171b:	ff 35 50 1a 11 80    	pushl  0x80111a50
80101721:	ff 35 4c 1a 11 80    	pushl  0x80111a4c
80101727:	ff 35 48 1a 11 80    	pushl  0x80111a48
8010172d:	ff 35 44 1a 11 80    	pushl  0x80111a44
80101733:	ff 35 40 1a 11 80    	pushl  0x80111a40
80101739:	68 d8 77 10 80       	push   $0x801077d8
8010173e:	e8 1d ef ff ff       	call   80100660 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
80101743:	83 c4 30             	add    $0x30,%esp
80101746:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101749:	c9                   	leave  
8010174a:	c3                   	ret    
8010174b:	90                   	nop
8010174c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101750 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	57                   	push   %edi
80101754:	56                   	push   %esi
80101755:	53                   	push   %ebx
80101756:	83 ec 1c             	sub    $0x1c,%esp
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101759:	83 3d 48 1a 11 80 01 	cmpl   $0x1,0x80111a48
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101760:	8b 45 0c             	mov    0xc(%ebp),%eax
80101763:	8b 75 08             	mov    0x8(%ebp),%esi
80101766:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101769:	0f 86 91 00 00 00    	jbe    80101800 <ialloc+0xb0>
8010176f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101774:	eb 21                	jmp    80101797 <ialloc+0x47>
80101776:	8d 76 00             	lea    0x0(%esi),%esi
80101779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101780:	83 ec 0c             	sub    $0xc,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101783:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101786:	57                   	push   %edi
80101787:	e8 54 ea ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010178c:	83 c4 10             	add    $0x10,%esp
8010178f:	39 1d 48 1a 11 80    	cmp    %ebx,0x80111a48
80101795:	76 69                	jbe    80101800 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101797:	89 d8                	mov    %ebx,%eax
80101799:	83 ec 08             	sub    $0x8,%esp
8010179c:	c1 e8 03             	shr    $0x3,%eax
8010179f:	03 05 54 1a 11 80    	add    0x80111a54,%eax
801017a5:	50                   	push   %eax
801017a6:	56                   	push   %esi
801017a7:	e8 24 e9 ff ff       	call   801000d0 <bread>
801017ac:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
801017ae:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
801017b0:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
801017b3:	83 e0 07             	and    $0x7,%eax
801017b6:	c1 e0 06             	shl    $0x6,%eax
801017b9:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801017bd:	66 83 39 00          	cmpw   $0x0,(%ecx)
801017c1:	75 bd                	jne    80101780 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801017c3:	83 ec 04             	sub    $0x4,%esp
801017c6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801017c9:	6a 40                	push   $0x40
801017cb:	6a 00                	push   $0x0
801017cd:	51                   	push   %ecx
801017ce:	e8 8d 31 00 00       	call   80104960 <memset>
      dip->type = type;
801017d3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801017d7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801017da:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801017dd:	89 3c 24             	mov    %edi,(%esp)
801017e0:	e8 9b 17 00 00       	call   80102f80 <log_write>
      brelse(bp);
801017e5:	89 3c 24             	mov    %edi,(%esp)
801017e8:	e8 f3 e9 ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801017ed:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801017f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801017f3:	89 da                	mov    %ebx,%edx
801017f5:	89 f0                	mov    %esi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801017f7:	5b                   	pop    %ebx
801017f8:	5e                   	pop    %esi
801017f9:	5f                   	pop    %edi
801017fa:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801017fb:	e9 e0 fc ff ff       	jmp    801014e0 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101800:	83 ec 0c             	sub    $0xc,%esp
80101803:	68 78 77 10 80       	push   $0x80107778
80101808:	e8 63 eb ff ff       	call   80100370 <panic>
8010180d:	8d 76 00             	lea    0x0(%esi),%esi

80101810 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
80101810:	55                   	push   %ebp
80101811:	89 e5                	mov    %esp,%ebp
80101813:	56                   	push   %esi
80101814:	53                   	push   %ebx
80101815:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101818:	83 ec 08             	sub    $0x8,%esp
8010181b:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010181e:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101821:	c1 e8 03             	shr    $0x3,%eax
80101824:	03 05 54 1a 11 80    	add    0x80111a54,%eax
8010182a:	50                   	push   %eax
8010182b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010182e:	e8 9d e8 ff ff       	call   801000d0 <bread>
80101833:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101835:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101838:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010183c:	83 c4 0c             	add    $0xc,%esp
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010183f:	83 e0 07             	and    $0x7,%eax
80101842:	c1 e0 06             	shl    $0x6,%eax
80101845:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101849:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010184c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101850:	83 c0 0c             	add    $0xc,%eax
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
80101853:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101857:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010185b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010185f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101863:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101867:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010186a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010186d:	6a 34                	push   $0x34
8010186f:	53                   	push   %ebx
80101870:	50                   	push   %eax
80101871:	e8 9a 31 00 00       	call   80104a10 <memmove>
  log_write(bp);
80101876:	89 34 24             	mov    %esi,(%esp)
80101879:	e8 02 17 00 00       	call   80102f80 <log_write>
  brelse(bp);
8010187e:	89 75 08             	mov    %esi,0x8(%ebp)
80101881:	83 c4 10             	add    $0x10,%esp
}
80101884:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101887:	5b                   	pop    %ebx
80101888:	5e                   	pop    %esi
80101889:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
8010188a:	e9 51 e9 ff ff       	jmp    801001e0 <brelse>
8010188f:	90                   	nop

80101890 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101890:	55                   	push   %ebp
80101891:	89 e5                	mov    %esp,%ebp
80101893:	53                   	push   %ebx
80101894:	83 ec 10             	sub    $0x10,%esp
80101897:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010189a:	68 60 1a 11 80       	push   $0x80111a60
8010189f:	e8 bc 2f 00 00       	call   80104860 <acquire>
  ip->ref++;
801018a4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018a8:	c7 04 24 60 1a 11 80 	movl   $0x80111a60,(%esp)
801018af:	e8 5c 30 00 00       	call   80104910 <release>
  return ip;
}
801018b4:	89 d8                	mov    %ebx,%eax
801018b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801018b9:	c9                   	leave  
801018ba:	c3                   	ret    
801018bb:	90                   	nop
801018bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018c0 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801018c0:	55                   	push   %ebp
801018c1:	89 e5                	mov    %esp,%ebp
801018c3:	56                   	push   %esi
801018c4:	53                   	push   %ebx
801018c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801018c8:	85 db                	test   %ebx,%ebx
801018ca:	0f 84 b7 00 00 00    	je     80101987 <ilock+0xc7>
801018d0:	8b 53 08             	mov    0x8(%ebx),%edx
801018d3:	85 d2                	test   %edx,%edx
801018d5:	0f 8e ac 00 00 00    	jle    80101987 <ilock+0xc7>
    panic("ilock");

  acquiresleep(&ip->lock);
801018db:	8d 43 0c             	lea    0xc(%ebx),%eax
801018de:	83 ec 0c             	sub    $0xc,%esp
801018e1:	50                   	push   %eax
801018e2:	e8 29 2d 00 00       	call   80104610 <acquiresleep>

  if(ip->valid == 0){
801018e7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801018ea:	83 c4 10             	add    $0x10,%esp
801018ed:	85 c0                	test   %eax,%eax
801018ef:	74 0f                	je     80101900 <ilock+0x40>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
801018f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018f4:	5b                   	pop    %ebx
801018f5:	5e                   	pop    %esi
801018f6:	5d                   	pop    %ebp
801018f7:	c3                   	ret    
801018f8:	90                   	nop
801018f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101900:	8b 43 04             	mov    0x4(%ebx),%eax
80101903:	83 ec 08             	sub    $0x8,%esp
80101906:	c1 e8 03             	shr    $0x3,%eax
80101909:	03 05 54 1a 11 80    	add    0x80111a54,%eax
8010190f:	50                   	push   %eax
80101910:	ff 33                	pushl  (%ebx)
80101912:	e8 b9 e7 ff ff       	call   801000d0 <bread>
80101917:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101919:	8b 43 04             	mov    0x4(%ebx),%eax
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010191c:	83 c4 0c             	add    $0xc,%esp

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010191f:	83 e0 07             	and    $0x7,%eax
80101922:	c1 e0 06             	shl    $0x6,%eax
80101925:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101929:	0f b7 10             	movzwl (%eax),%edx
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010192c:	83 c0 0c             	add    $0xc,%eax
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
8010192f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101933:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101937:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010193b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010193f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101943:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101947:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010194b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010194e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101951:	6a 34                	push   $0x34
80101953:	50                   	push   %eax
80101954:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101957:	50                   	push   %eax
80101958:	e8 b3 30 00 00       	call   80104a10 <memmove>
    brelse(bp);
8010195d:	89 34 24             	mov    %esi,(%esp)
80101960:	e8 7b e8 ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
80101965:	83 c4 10             	add    $0x10,%esp
80101968:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
8010196d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101974:	0f 85 77 ff ff ff    	jne    801018f1 <ilock+0x31>
      panic("ilock: no type");
8010197a:	83 ec 0c             	sub    $0xc,%esp
8010197d:	68 90 77 10 80       	push   $0x80107790
80101982:	e8 e9 e9 ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101987:	83 ec 0c             	sub    $0xc,%esp
8010198a:	68 8a 77 10 80       	push   $0x8010778a
8010198f:	e8 dc e9 ff ff       	call   80100370 <panic>
80101994:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010199a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801019a0 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
801019a0:	55                   	push   %ebp
801019a1:	89 e5                	mov    %esp,%ebp
801019a3:	56                   	push   %esi
801019a4:	53                   	push   %ebx
801019a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801019a8:	85 db                	test   %ebx,%ebx
801019aa:	74 28                	je     801019d4 <iunlock+0x34>
801019ac:	8d 73 0c             	lea    0xc(%ebx),%esi
801019af:	83 ec 0c             	sub    $0xc,%esp
801019b2:	56                   	push   %esi
801019b3:	e8 f8 2c 00 00       	call   801046b0 <holdingsleep>
801019b8:	83 c4 10             	add    $0x10,%esp
801019bb:	85 c0                	test   %eax,%eax
801019bd:	74 15                	je     801019d4 <iunlock+0x34>
801019bf:	8b 43 08             	mov    0x8(%ebx),%eax
801019c2:	85 c0                	test   %eax,%eax
801019c4:	7e 0e                	jle    801019d4 <iunlock+0x34>
    panic("iunlock");

  releasesleep(&ip->lock);
801019c6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801019c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801019cc:	5b                   	pop    %ebx
801019cd:	5e                   	pop    %esi
801019ce:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
801019cf:	e9 9c 2c 00 00       	jmp    80104670 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
801019d4:	83 ec 0c             	sub    $0xc,%esp
801019d7:	68 9f 77 10 80       	push   $0x8010779f
801019dc:	e8 8f e9 ff ff       	call   80100370 <panic>
801019e1:	eb 0d                	jmp    801019f0 <iput>
801019e3:	90                   	nop
801019e4:	90                   	nop
801019e5:	90                   	nop
801019e6:	90                   	nop
801019e7:	90                   	nop
801019e8:	90                   	nop
801019e9:	90                   	nop
801019ea:	90                   	nop
801019eb:	90                   	nop
801019ec:	90                   	nop
801019ed:	90                   	nop
801019ee:	90                   	nop
801019ef:	90                   	nop

801019f0 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
801019f0:	55                   	push   %ebp
801019f1:	89 e5                	mov    %esp,%ebp
801019f3:	57                   	push   %edi
801019f4:	56                   	push   %esi
801019f5:	53                   	push   %ebx
801019f6:	83 ec 28             	sub    $0x28,%esp
801019f9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
801019fc:	8d 7e 0c             	lea    0xc(%esi),%edi
801019ff:	57                   	push   %edi
80101a00:	e8 0b 2c 00 00       	call   80104610 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101a05:	8b 56 4c             	mov    0x4c(%esi),%edx
80101a08:	83 c4 10             	add    $0x10,%esp
80101a0b:	85 d2                	test   %edx,%edx
80101a0d:	74 07                	je     80101a16 <iput+0x26>
80101a0f:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
80101a14:	74 32                	je     80101a48 <iput+0x58>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
80101a16:	83 ec 0c             	sub    $0xc,%esp
80101a19:	57                   	push   %edi
80101a1a:	e8 51 2c 00 00       	call   80104670 <releasesleep>

  acquire(&icache.lock);
80101a1f:	c7 04 24 60 1a 11 80 	movl   $0x80111a60,(%esp)
80101a26:	e8 35 2e 00 00       	call   80104860 <acquire>
  ip->ref--;
80101a2b:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
80101a2f:	83 c4 10             	add    $0x10,%esp
80101a32:	c7 45 08 60 1a 11 80 	movl   $0x80111a60,0x8(%ebp)
}
80101a39:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a3c:	5b                   	pop    %ebx
80101a3d:	5e                   	pop    %esi
80101a3e:	5f                   	pop    %edi
80101a3f:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
80101a40:	e9 cb 2e 00 00       	jmp    80104910 <release>
80101a45:	8d 76 00             	lea    0x0(%esi),%esi
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
80101a48:	83 ec 0c             	sub    $0xc,%esp
80101a4b:	68 60 1a 11 80       	push   $0x80111a60
80101a50:	e8 0b 2e 00 00       	call   80104860 <acquire>
    int r = ip->ref;
80101a55:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
80101a58:	c7 04 24 60 1a 11 80 	movl   $0x80111a60,(%esp)
80101a5f:	e8 ac 2e 00 00       	call   80104910 <release>
    if(r == 1){
80101a64:	83 c4 10             	add    $0x10,%esp
80101a67:	83 fb 01             	cmp    $0x1,%ebx
80101a6a:	75 aa                	jne    80101a16 <iput+0x26>
80101a6c:	8d 8e 8c 00 00 00    	lea    0x8c(%esi),%ecx
80101a72:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101a75:	8d 5e 5c             	lea    0x5c(%esi),%ebx
80101a78:	89 cf                	mov    %ecx,%edi
80101a7a:	eb 0b                	jmp    80101a87 <iput+0x97>
80101a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a80:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101a83:	39 fb                	cmp    %edi,%ebx
80101a85:	74 19                	je     80101aa0 <iput+0xb0>
    if(ip->addrs[i]){
80101a87:	8b 13                	mov    (%ebx),%edx
80101a89:	85 d2                	test   %edx,%edx
80101a8b:	74 f3                	je     80101a80 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101a8d:	8b 06                	mov    (%esi),%eax
80101a8f:	e8 cc f8 ff ff       	call   80101360 <bfree>
      ip->addrs[i] = 0;
80101a94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80101a9a:	eb e4                	jmp    80101a80 <iput+0x90>
80101a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101aa0:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101aa6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101aa9:	85 c0                	test   %eax,%eax
80101aab:	75 33                	jne    80101ae0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101aad:	83 ec 0c             	sub    $0xc,%esp
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
80101ab0:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101ab7:	56                   	push   %esi
80101ab8:	e8 53 fd ff ff       	call   80101810 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
80101abd:	31 c0                	xor    %eax,%eax
80101abf:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101ac3:	89 34 24             	mov    %esi,(%esp)
80101ac6:	e8 45 fd ff ff       	call   80101810 <iupdate>
      ip->valid = 0;
80101acb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101ad2:	83 c4 10             	add    $0x10,%esp
80101ad5:	e9 3c ff ff ff       	jmp    80101a16 <iput+0x26>
80101ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101ae0:	83 ec 08             	sub    $0x8,%esp
80101ae3:	50                   	push   %eax
80101ae4:	ff 36                	pushl  (%esi)
80101ae6:	e8 e5 e5 ff ff       	call   801000d0 <bread>
80101aeb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101af1:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101af4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101af7:	8d 58 5c             	lea    0x5c(%eax),%ebx
80101afa:	83 c4 10             	add    $0x10,%esp
80101afd:	89 cf                	mov    %ecx,%edi
80101aff:	eb 0e                	jmp    80101b0f <iput+0x11f>
80101b01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b08:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
80101b0b:	39 fb                	cmp    %edi,%ebx
80101b0d:	74 0f                	je     80101b1e <iput+0x12e>
      if(a[j])
80101b0f:	8b 13                	mov    (%ebx),%edx
80101b11:	85 d2                	test   %edx,%edx
80101b13:	74 f3                	je     80101b08 <iput+0x118>
        bfree(ip->dev, a[j]);
80101b15:	8b 06                	mov    (%esi),%eax
80101b17:	e8 44 f8 ff ff       	call   80101360 <bfree>
80101b1c:	eb ea                	jmp    80101b08 <iput+0x118>
    }
    brelse(bp);
80101b1e:	83 ec 0c             	sub    $0xc,%esp
80101b21:	ff 75 e4             	pushl  -0x1c(%ebp)
80101b24:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b27:	e8 b4 e6 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101b2c:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101b32:	8b 06                	mov    (%esi),%eax
80101b34:	e8 27 f8 ff ff       	call   80101360 <bfree>
    ip->addrs[NDIRECT] = 0;
80101b39:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101b40:	00 00 00 
80101b43:	83 c4 10             	add    $0x10,%esp
80101b46:	e9 62 ff ff ff       	jmp    80101aad <iput+0xbd>
80101b4b:	90                   	nop
80101b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101b50 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101b50:	55                   	push   %ebp
80101b51:	89 e5                	mov    %esp,%ebp
80101b53:	53                   	push   %ebx
80101b54:	83 ec 10             	sub    $0x10,%esp
80101b57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101b5a:	53                   	push   %ebx
80101b5b:	e8 40 fe ff ff       	call   801019a0 <iunlock>
  iput(ip);
80101b60:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101b63:	83 c4 10             	add    $0x10,%esp
}
80101b66:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101b69:	c9                   	leave  
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
80101b6a:	e9 81 fe ff ff       	jmp    801019f0 <iput>
80101b6f:	90                   	nop

80101b70 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101b70:	55                   	push   %ebp
80101b71:	89 e5                	mov    %esp,%ebp
80101b73:	8b 55 08             	mov    0x8(%ebp),%edx
80101b76:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101b79:	8b 0a                	mov    (%edx),%ecx
80101b7b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101b7e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101b81:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101b84:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101b88:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101b8b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101b8f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101b93:	8b 52 58             	mov    0x58(%edx),%edx
80101b96:	89 50 10             	mov    %edx,0x10(%eax)
}
80101b99:	5d                   	pop    %ebp
80101b9a:	c3                   	ret    
80101b9b:	90                   	nop
80101b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ba0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	57                   	push   %edi
80101ba4:	56                   	push   %esi
80101ba5:	53                   	push   %ebx
80101ba6:	83 ec 1c             	sub    $0x1c,%esp
80101ba9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bac:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101baf:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bb2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101bb7:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101bba:	8b 7d 14             	mov    0x14(%ebp),%edi
80101bbd:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bc0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bc3:	0f 84 a7 00 00 00    	je     80101c70 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101bc9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bcc:	8b 40 58             	mov    0x58(%eax),%eax
80101bcf:	39 f0                	cmp    %esi,%eax
80101bd1:	0f 82 c1 00 00 00    	jb     80101c98 <readi+0xf8>
80101bd7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101bda:	89 fa                	mov    %edi,%edx
80101bdc:	01 f2                	add    %esi,%edx
80101bde:	0f 82 b4 00 00 00    	jb     80101c98 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101be4:	89 c1                	mov    %eax,%ecx
80101be6:	29 f1                	sub    %esi,%ecx
80101be8:	39 d0                	cmp    %edx,%eax
80101bea:	0f 43 cf             	cmovae %edi,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bed:	31 ff                	xor    %edi,%edi
80101bef:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101bf1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bf4:	74 6d                	je     80101c63 <readi+0xc3>
80101bf6:	8d 76 00             	lea    0x0(%esi),%esi
80101bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c00:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101c03:	89 f2                	mov    %esi,%edx
80101c05:	c1 ea 09             	shr    $0x9,%edx
80101c08:	89 d8                	mov    %ebx,%eax
80101c0a:	e8 a1 f9 ff ff       	call   801015b0 <bmap>
80101c0f:	83 ec 08             	sub    $0x8,%esp
80101c12:	50                   	push   %eax
80101c13:	ff 33                	pushl  (%ebx)
    m = min(n - tot, BSIZE - off%BSIZE);
80101c15:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c1a:	e8 b1 e4 ff ff       	call   801000d0 <bread>
80101c1f:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101c21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c24:	89 f1                	mov    %esi,%ecx
80101c26:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101c2c:	83 c4 0c             	add    $0xc,%esp
    memmove(dst, bp->data + off%BSIZE, m);
80101c2f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101c32:	29 cb                	sub    %ecx,%ebx
80101c34:	29 f8                	sub    %edi,%eax
80101c36:	39 c3                	cmp    %eax,%ebx
80101c38:	0f 47 d8             	cmova  %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101c3b:	8d 44 0a 5c          	lea    0x5c(%edx,%ecx,1),%eax
80101c3f:	53                   	push   %ebx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c40:	01 df                	add    %ebx,%edi
80101c42:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
80101c44:	50                   	push   %eax
80101c45:	ff 75 e0             	pushl  -0x20(%ebp)
80101c48:	e8 c3 2d 00 00       	call   80104a10 <memmove>
    brelse(bp);
80101c4d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101c50:	89 14 24             	mov    %edx,(%esp)
80101c53:	e8 88 e5 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c58:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101c5b:	83 c4 10             	add    $0x10,%esp
80101c5e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101c61:	77 9d                	ja     80101c00 <readi+0x60>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101c63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101c66:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c69:	5b                   	pop    %ebx
80101c6a:	5e                   	pop    %esi
80101c6b:	5f                   	pop    %edi
80101c6c:	5d                   	pop    %ebp
80101c6d:	c3                   	ret    
80101c6e:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101c70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c74:	66 83 f8 09          	cmp    $0x9,%ax
80101c78:	77 1e                	ja     80101c98 <readi+0xf8>
80101c7a:	8b 04 c5 e0 19 11 80 	mov    -0x7feee620(,%eax,8),%eax
80101c81:	85 c0                	test   %eax,%eax
80101c83:	74 13                	je     80101c98 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101c85:	89 7d 10             	mov    %edi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5f                   	pop    %edi
80101c8e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101c8f:	ff e0                	jmp    *%eax
80101c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101c98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c9d:	eb c7                	jmp    80101c66 <readi+0xc6>
80101c9f:	90                   	nop

80101ca0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ca0:	55                   	push   %ebp
80101ca1:	89 e5                	mov    %esp,%ebp
80101ca3:	57                   	push   %edi
80101ca4:	56                   	push   %esi
80101ca5:	53                   	push   %ebx
80101ca6:	83 ec 1c             	sub    $0x1c,%esp
80101ca9:	8b 45 08             	mov    0x8(%ebp),%eax
80101cac:	8b 75 0c             	mov    0xc(%ebp),%esi
80101caf:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101cb2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101cb7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101cba:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101cbd:	8b 75 10             	mov    0x10(%ebp),%esi
80101cc0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101cc3:	0f 84 b7 00 00 00    	je     80101d80 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101cc9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101ccc:	39 70 58             	cmp    %esi,0x58(%eax)
80101ccf:	0f 82 eb 00 00 00    	jb     80101dc0 <writei+0x120>
80101cd5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101cd8:	89 f8                	mov    %edi,%eax
80101cda:	01 f0                	add    %esi,%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101cdc:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ce1:	0f 87 d9 00 00 00    	ja     80101dc0 <writei+0x120>
80101ce7:	39 c6                	cmp    %eax,%esi
80101ce9:	0f 87 d1 00 00 00    	ja     80101dc0 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cef:	85 ff                	test   %edi,%edi
80101cf1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101cf8:	74 78                	je     80101d72 <writei+0xd2>
80101cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d00:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101d03:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101d05:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d0a:	c1 ea 09             	shr    $0x9,%edx
80101d0d:	89 f8                	mov    %edi,%eax
80101d0f:	e8 9c f8 ff ff       	call   801015b0 <bmap>
80101d14:	83 ec 08             	sub    $0x8,%esp
80101d17:	50                   	push   %eax
80101d18:	ff 37                	pushl  (%edi)
80101d1a:	e8 b1 e3 ff ff       	call   801000d0 <bread>
80101d1f:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101d21:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101d24:	2b 45 e4             	sub    -0x1c(%ebp),%eax
80101d27:	89 f1                	mov    %esi,%ecx
80101d29:	83 c4 0c             	add    $0xc,%esp
80101d2c:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101d32:	29 cb                	sub    %ecx,%ebx
80101d34:	39 c3                	cmp    %eax,%ebx
80101d36:	0f 47 d8             	cmova  %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101d39:	8d 44 0f 5c          	lea    0x5c(%edi,%ecx,1),%eax
80101d3d:	53                   	push   %ebx
80101d3e:	ff 75 dc             	pushl  -0x24(%ebp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d41:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101d43:	50                   	push   %eax
80101d44:	e8 c7 2c 00 00       	call   80104a10 <memmove>
    log_write(bp);
80101d49:	89 3c 24             	mov    %edi,(%esp)
80101d4c:	e8 2f 12 00 00       	call   80102f80 <log_write>
    brelse(bp);
80101d51:	89 3c 24             	mov    %edi,(%esp)
80101d54:	e8 87 e4 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d59:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101d5c:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101d5f:	83 c4 10             	add    $0x10,%esp
80101d62:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d65:	39 55 e0             	cmp    %edx,-0x20(%ebp)
80101d68:	77 96                	ja     80101d00 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101d6a:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d6d:	3b 70 58             	cmp    0x58(%eax),%esi
80101d70:	77 36                	ja     80101da8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101d72:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101d75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d78:	5b                   	pop    %ebx
80101d79:	5e                   	pop    %esi
80101d7a:	5f                   	pop    %edi
80101d7b:	5d                   	pop    %ebp
80101d7c:	c3                   	ret    
80101d7d:	8d 76 00             	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101d80:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101d84:	66 83 f8 09          	cmp    $0x9,%ax
80101d88:	77 36                	ja     80101dc0 <writei+0x120>
80101d8a:	8b 04 c5 e4 19 11 80 	mov    -0x7feee61c(,%eax,8),%eax
80101d91:	85 c0                	test   %eax,%eax
80101d93:	74 2b                	je     80101dc0 <writei+0x120>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101d95:	89 7d 10             	mov    %edi,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101d98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d9b:	5b                   	pop    %ebx
80101d9c:	5e                   	pop    %esi
80101d9d:	5f                   	pop    %edi
80101d9e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101d9f:	ff e0                	jmp    *%eax
80101da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101da8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101dab:	83 ec 0c             	sub    $0xc,%esp
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101dae:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101db1:	50                   	push   %eax
80101db2:	e8 59 fa ff ff       	call   80101810 <iupdate>
80101db7:	83 c4 10             	add    $0x10,%esp
80101dba:	eb b6                	jmp    80101d72 <writei+0xd2>
80101dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101dc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101dc5:	eb ae                	jmp    80101d75 <writei+0xd5>
80101dc7:	89 f6                	mov    %esi,%esi
80101dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101dd0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101dd0:	55                   	push   %ebp
80101dd1:	89 e5                	mov    %esp,%ebp
80101dd3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101dd6:	6a 0e                	push   $0xe
80101dd8:	ff 75 0c             	pushl  0xc(%ebp)
80101ddb:	ff 75 08             	pushl  0x8(%ebp)
80101dde:	e8 ad 2c 00 00       	call   80104a90 <strncmp>
}
80101de3:	c9                   	leave  
80101de4:	c3                   	ret    
80101de5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101df0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101df0:	55                   	push   %ebp
80101df1:	89 e5                	mov    %esp,%ebp
80101df3:	57                   	push   %edi
80101df4:	56                   	push   %esi
80101df5:	53                   	push   %ebx
80101df6:	83 ec 1c             	sub    $0x1c,%esp
80101df9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101dfc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101e01:	0f 85 80 00 00 00    	jne    80101e87 <dirlookup+0x97>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101e07:	8b 53 58             	mov    0x58(%ebx),%edx
80101e0a:	31 ff                	xor    %edi,%edi
80101e0c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e0f:	85 d2                	test   %edx,%edx
80101e11:	75 0d                	jne    80101e20 <dirlookup+0x30>
80101e13:	eb 5b                	jmp    80101e70 <dirlookup+0x80>
80101e15:	8d 76 00             	lea    0x0(%esi),%esi
80101e18:	83 c7 10             	add    $0x10,%edi
80101e1b:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101e1e:	76 50                	jbe    80101e70 <dirlookup+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e20:	6a 10                	push   $0x10
80101e22:	57                   	push   %edi
80101e23:	56                   	push   %esi
80101e24:	53                   	push   %ebx
80101e25:	e8 76 fd ff ff       	call   80101ba0 <readi>
80101e2a:	83 c4 10             	add    $0x10,%esp
80101e2d:	83 f8 10             	cmp    $0x10,%eax
80101e30:	75 48                	jne    80101e7a <dirlookup+0x8a>
      panic("dirlookup read");
    if(de.inum == 0)
80101e32:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e37:	74 df                	je     80101e18 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101e39:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e3c:	83 ec 04             	sub    $0x4,%esp
80101e3f:	6a 0e                	push   $0xe
80101e41:	50                   	push   %eax
80101e42:	ff 75 0c             	pushl  0xc(%ebp)
80101e45:	e8 46 2c 00 00       	call   80104a90 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101e4a:	83 c4 10             	add    $0x10,%esp
80101e4d:	85 c0                	test   %eax,%eax
80101e4f:	75 c7                	jne    80101e18 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101e51:	8b 45 10             	mov    0x10(%ebp),%eax
80101e54:	85 c0                	test   %eax,%eax
80101e56:	74 05                	je     80101e5d <dirlookup+0x6d>
        *poff = off;
80101e58:	8b 45 10             	mov    0x10(%ebp),%eax
80101e5b:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
80101e5d:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101e61:	8b 03                	mov    (%ebx),%eax
80101e63:	e8 78 f6 ff ff       	call   801014e0 <iget>
    }
  }

  return 0;
}
80101e68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e6b:	5b                   	pop    %ebx
80101e6c:	5e                   	pop    %esi
80101e6d:	5f                   	pop    %edi
80101e6e:	5d                   	pop    %ebp
80101e6f:	c3                   	ret    
80101e70:	8d 65 f4             	lea    -0xc(%ebp),%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101e73:	31 c0                	xor    %eax,%eax
}
80101e75:	5b                   	pop    %ebx
80101e76:	5e                   	pop    %esi
80101e77:	5f                   	pop    %edi
80101e78:	5d                   	pop    %ebp
80101e79:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
80101e7a:	83 ec 0c             	sub    $0xc,%esp
80101e7d:	68 b9 77 10 80       	push   $0x801077b9
80101e82:	e8 e9 e4 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101e87:	83 ec 0c             	sub    $0xc,%esp
80101e8a:	68 a7 77 10 80       	push   $0x801077a7
80101e8f:	e8 dc e4 ff ff       	call   80100370 <panic>
80101e94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101e9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101ea0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101ea0:	55                   	push   %ebp
80101ea1:	89 e5                	mov    %esp,%ebp
80101ea3:	57                   	push   %edi
80101ea4:	56                   	push   %esi
80101ea5:	53                   	push   %ebx
80101ea6:	89 cf                	mov    %ecx,%edi
80101ea8:	89 c3                	mov    %eax,%ebx
80101eaa:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101ead:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101eb0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101eb3:	0f 84 53 01 00 00    	je     8010200c <namex+0x16c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101eb9:	e8 12 1b 00 00       	call   801039d0 <myproc>
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101ebe:	83 ec 0c             	sub    $0xc,%esp
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101ec1:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101ec4:	68 60 1a 11 80       	push   $0x80111a60
80101ec9:	e8 92 29 00 00       	call   80104860 <acquire>
  ip->ref++;
80101ece:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ed2:	c7 04 24 60 1a 11 80 	movl   $0x80111a60,(%esp)
80101ed9:	e8 32 2a 00 00       	call   80104910 <release>
80101ede:	83 c4 10             	add    $0x10,%esp
80101ee1:	eb 08                	jmp    80101eeb <namex+0x4b>
80101ee3:	90                   	nop
80101ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101ee8:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101eeb:	0f b6 03             	movzbl (%ebx),%eax
80101eee:	3c 2f                	cmp    $0x2f,%al
80101ef0:	74 f6                	je     80101ee8 <namex+0x48>
    path++;
  if(*path == 0)
80101ef2:	84 c0                	test   %al,%al
80101ef4:	0f 84 e3 00 00 00    	je     80101fdd <namex+0x13d>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101efa:	0f b6 03             	movzbl (%ebx),%eax
80101efd:	89 da                	mov    %ebx,%edx
80101eff:	84 c0                	test   %al,%al
80101f01:	0f 84 ac 00 00 00    	je     80101fb3 <namex+0x113>
80101f07:	3c 2f                	cmp    $0x2f,%al
80101f09:	75 09                	jne    80101f14 <namex+0x74>
80101f0b:	e9 a3 00 00 00       	jmp    80101fb3 <namex+0x113>
80101f10:	84 c0                	test   %al,%al
80101f12:	74 0a                	je     80101f1e <namex+0x7e>
    path++;
80101f14:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101f17:	0f b6 02             	movzbl (%edx),%eax
80101f1a:	3c 2f                	cmp    $0x2f,%al
80101f1c:	75 f2                	jne    80101f10 <namex+0x70>
80101f1e:	89 d1                	mov    %edx,%ecx
80101f20:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101f22:	83 f9 0d             	cmp    $0xd,%ecx
80101f25:	0f 8e 8d 00 00 00    	jle    80101fb8 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101f2b:	83 ec 04             	sub    $0x4,%esp
80101f2e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f31:	6a 0e                	push   $0xe
80101f33:	53                   	push   %ebx
80101f34:	57                   	push   %edi
80101f35:	e8 d6 2a 00 00       	call   80104a10 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101f3a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
80101f3d:	83 c4 10             	add    $0x10,%esp
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101f40:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101f42:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101f45:	75 11                	jne    80101f58 <namex+0xb8>
80101f47:	89 f6                	mov    %esi,%esi
80101f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101f50:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101f53:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101f56:	74 f8                	je     80101f50 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101f58:	83 ec 0c             	sub    $0xc,%esp
80101f5b:	56                   	push   %esi
80101f5c:	e8 5f f9 ff ff       	call   801018c0 <ilock>
    if(ip->type != T_DIR){
80101f61:	83 c4 10             	add    $0x10,%esp
80101f64:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101f69:	0f 85 7f 00 00 00    	jne    80101fee <namex+0x14e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101f6f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101f72:	85 d2                	test   %edx,%edx
80101f74:	74 09                	je     80101f7f <namex+0xdf>
80101f76:	80 3b 00             	cmpb   $0x0,(%ebx)
80101f79:	0f 84 a3 00 00 00    	je     80102022 <namex+0x182>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101f7f:	83 ec 04             	sub    $0x4,%esp
80101f82:	6a 00                	push   $0x0
80101f84:	57                   	push   %edi
80101f85:	56                   	push   %esi
80101f86:	e8 65 fe ff ff       	call   80101df0 <dirlookup>
80101f8b:	83 c4 10             	add    $0x10,%esp
80101f8e:	85 c0                	test   %eax,%eax
80101f90:	74 5c                	je     80101fee <namex+0x14e>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101f92:	83 ec 0c             	sub    $0xc,%esp
80101f95:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101f98:	56                   	push   %esi
80101f99:	e8 02 fa ff ff       	call   801019a0 <iunlock>
  iput(ip);
80101f9e:	89 34 24             	mov    %esi,(%esp)
80101fa1:	e8 4a fa ff ff       	call   801019f0 <iput>
80101fa6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101fa9:	83 c4 10             	add    $0x10,%esp
80101fac:	89 c6                	mov    %eax,%esi
80101fae:	e9 38 ff ff ff       	jmp    80101eeb <namex+0x4b>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101fb3:	31 c9                	xor    %ecx,%ecx
80101fb5:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101fb8:	83 ec 04             	sub    $0x4,%esp
80101fbb:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101fbe:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101fc1:	51                   	push   %ecx
80101fc2:	53                   	push   %ebx
80101fc3:	57                   	push   %edi
80101fc4:	e8 47 2a 00 00       	call   80104a10 <memmove>
    name[len] = 0;
80101fc9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101fcc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101fcf:	83 c4 10             	add    $0x10,%esp
80101fd2:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101fd6:	89 d3                	mov    %edx,%ebx
80101fd8:	e9 65 ff ff ff       	jmp    80101f42 <namex+0xa2>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101fdd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101fe0:	85 c0                	test   %eax,%eax
80101fe2:	75 54                	jne    80102038 <namex+0x198>
80101fe4:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101fe6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fe9:	5b                   	pop    %ebx
80101fea:	5e                   	pop    %esi
80101feb:	5f                   	pop    %edi
80101fec:	5d                   	pop    %ebp
80101fed:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101fee:	83 ec 0c             	sub    $0xc,%esp
80101ff1:	56                   	push   %esi
80101ff2:	e8 a9 f9 ff ff       	call   801019a0 <iunlock>
  iput(ip);
80101ff7:	89 34 24             	mov    %esi,(%esp)
80101ffa:	e8 f1 f9 ff ff       	call   801019f0 <iput>
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101fff:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80102002:	8d 65 f4             	lea    -0xc(%ebp),%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80102005:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80102007:	5b                   	pop    %ebx
80102008:	5e                   	pop    %esi
80102009:	5f                   	pop    %edi
8010200a:	5d                   	pop    %ebp
8010200b:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
8010200c:	ba 01 00 00 00       	mov    $0x1,%edx
80102011:	b8 01 00 00 00       	mov    $0x1,%eax
80102016:	e8 c5 f4 ff ff       	call   801014e0 <iget>
8010201b:	89 c6                	mov    %eax,%esi
8010201d:	e9 c9 fe ff ff       	jmp    80101eeb <namex+0x4b>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80102022:	83 ec 0c             	sub    $0xc,%esp
80102025:	56                   	push   %esi
80102026:	e8 75 f9 ff ff       	call   801019a0 <iunlock>
      return ip;
8010202b:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
8010202e:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80102031:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80102033:	5b                   	pop    %ebx
80102034:	5e                   	pop    %esi
80102035:	5f                   	pop    %edi
80102036:	5d                   	pop    %ebp
80102037:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80102038:	83 ec 0c             	sub    $0xc,%esp
8010203b:	56                   	push   %esi
8010203c:	e8 af f9 ff ff       	call   801019f0 <iput>
    return 0;
80102041:	83 c4 10             	add    $0x10,%esp
80102044:	31 c0                	xor    %eax,%eax
80102046:	eb 9e                	jmp    80101fe6 <namex+0x146>
80102048:	90                   	nop
80102049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102050 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102050:	55                   	push   %ebp
80102051:	89 e5                	mov    %esp,%ebp
80102053:	57                   	push   %edi
80102054:	56                   	push   %esi
80102055:	53                   	push   %ebx
80102056:	83 ec 20             	sub    $0x20,%esp
80102059:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
8010205c:	6a 00                	push   $0x0
8010205e:	ff 75 0c             	pushl  0xc(%ebp)
80102061:	53                   	push   %ebx
80102062:	e8 89 fd ff ff       	call   80101df0 <dirlookup>
80102067:	83 c4 10             	add    $0x10,%esp
8010206a:	85 c0                	test   %eax,%eax
8010206c:	75 67                	jne    801020d5 <dirlink+0x85>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010206e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102071:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102074:	85 ff                	test   %edi,%edi
80102076:	74 29                	je     801020a1 <dirlink+0x51>
80102078:	31 ff                	xor    %edi,%edi
8010207a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010207d:	eb 09                	jmp    80102088 <dirlink+0x38>
8010207f:	90                   	nop
80102080:	83 c7 10             	add    $0x10,%edi
80102083:	39 7b 58             	cmp    %edi,0x58(%ebx)
80102086:	76 19                	jbe    801020a1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102088:	6a 10                	push   $0x10
8010208a:	57                   	push   %edi
8010208b:	56                   	push   %esi
8010208c:	53                   	push   %ebx
8010208d:	e8 0e fb ff ff       	call   80101ba0 <readi>
80102092:	83 c4 10             	add    $0x10,%esp
80102095:	83 f8 10             	cmp    $0x10,%eax
80102098:	75 4e                	jne    801020e8 <dirlink+0x98>
      panic("dirlink read");
    if(de.inum == 0)
8010209a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010209f:	75 df                	jne    80102080 <dirlink+0x30>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
801020a1:	8d 45 da             	lea    -0x26(%ebp),%eax
801020a4:	83 ec 04             	sub    $0x4,%esp
801020a7:	6a 0e                	push   $0xe
801020a9:	ff 75 0c             	pushl  0xc(%ebp)
801020ac:	50                   	push   %eax
801020ad:	e8 4e 2a 00 00       	call   80104b00 <strncpy>
  de.inum = inum;
801020b2:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020b5:	6a 10                	push   $0x10
801020b7:	57                   	push   %edi
801020b8:	56                   	push   %esi
801020b9:	53                   	push   %ebx
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
801020ba:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020be:	e8 dd fb ff ff       	call   80101ca0 <writei>
801020c3:	83 c4 20             	add    $0x20,%esp
801020c6:	83 f8 10             	cmp    $0x10,%eax
801020c9:	75 2a                	jne    801020f5 <dirlink+0xa5>
    panic("dirlink");

  return 0;
801020cb:	31 c0                	xor    %eax,%eax
}
801020cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020d0:	5b                   	pop    %ebx
801020d1:	5e                   	pop    %esi
801020d2:	5f                   	pop    %edi
801020d3:	5d                   	pop    %ebp
801020d4:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
801020d5:	83 ec 0c             	sub    $0xc,%esp
801020d8:	50                   	push   %eax
801020d9:	e8 12 f9 ff ff       	call   801019f0 <iput>
    return -1;
801020de:	83 c4 10             	add    $0x10,%esp
801020e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020e6:	eb e5                	jmp    801020cd <dirlink+0x7d>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
801020e8:	83 ec 0c             	sub    $0xc,%esp
801020eb:	68 c8 77 10 80       	push   $0x801077c8
801020f0:	e8 7b e2 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
801020f5:	83 ec 0c             	sub    $0xc,%esp
801020f8:	68 f6 7d 10 80       	push   $0x80107df6
801020fd:	e8 6e e2 ff ff       	call   80100370 <panic>
80102102:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102110 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80102110:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102111:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80102113:	89 e5                	mov    %esp,%ebp
80102115:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102118:	8b 45 08             	mov    0x8(%ebp),%eax
8010211b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010211e:	e8 7d fd ff ff       	call   80101ea0 <namex>
}
80102123:	c9                   	leave  
80102124:	c3                   	ret    
80102125:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102130 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102130:	55                   	push   %ebp
  return namex(path, 1, name);
80102131:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80102136:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102138:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010213b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010213e:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
8010213f:	e9 5c fd ff ff       	jmp    80101ea0 <namex>
80102144:	66 90                	xchg   %ax,%ax
80102146:	66 90                	xchg   %ax,%ax
80102148:	66 90                	xchg   %ax,%ax
8010214a:	66 90                	xchg   %ax,%ax
8010214c:	66 90                	xchg   %ax,%ax
8010214e:	66 90                	xchg   %ax,%ax

80102150 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102150:	55                   	push   %ebp
  if(b == 0)
80102151:	85 c0                	test   %eax,%eax
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102153:	89 e5                	mov    %esp,%ebp
80102155:	56                   	push   %esi
80102156:	53                   	push   %ebx
  if(b == 0)
80102157:	0f 84 ad 00 00 00    	je     8010220a <idestart+0xba>
    panic("idestart");
  if(b->blockno >= FSSIZE)
8010215d:	8b 58 08             	mov    0x8(%eax),%ebx
80102160:	89 c1                	mov    %eax,%ecx
80102162:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80102168:	0f 87 8f 00 00 00    	ja     801021fd <idestart+0xad>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010216e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102173:	90                   	nop
80102174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102178:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102179:	83 e0 c0             	and    $0xffffffc0,%eax
8010217c:	3c 40                	cmp    $0x40,%al
8010217e:	75 f8                	jne    80102178 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102180:	31 f6                	xor    %esi,%esi
80102182:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102187:	89 f0                	mov    %esi,%eax
80102189:	ee                   	out    %al,(%dx)
8010218a:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010218f:	b8 01 00 00 00       	mov    $0x1,%eax
80102194:	ee                   	out    %al,(%dx)
80102195:	ba f3 01 00 00       	mov    $0x1f3,%edx
8010219a:	89 d8                	mov    %ebx,%eax
8010219c:	ee                   	out    %al,(%dx)
8010219d:	89 d8                	mov    %ebx,%eax
8010219f:	ba f4 01 00 00       	mov    $0x1f4,%edx
801021a4:	c1 f8 08             	sar    $0x8,%eax
801021a7:	ee                   	out    %al,(%dx)
801021a8:	ba f5 01 00 00       	mov    $0x1f5,%edx
801021ad:	89 f0                	mov    %esi,%eax
801021af:	ee                   	out    %al,(%dx)
801021b0:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
801021b4:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021b9:	83 e0 01             	and    $0x1,%eax
801021bc:	c1 e0 04             	shl    $0x4,%eax
801021bf:	83 c8 e0             	or     $0xffffffe0,%eax
801021c2:	ee                   	out    %al,(%dx)
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
801021c3:	f6 01 04             	testb  $0x4,(%ecx)
801021c6:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021cb:	75 13                	jne    801021e0 <idestart+0x90>
801021cd:	b8 20 00 00 00       	mov    $0x20,%eax
801021d2:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801021d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801021d6:	5b                   	pop    %ebx
801021d7:	5e                   	pop    %esi
801021d8:	5d                   	pop    %ebp
801021d9:	c3                   	ret    
801021da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801021e0:	b8 30 00 00 00       	mov    $0x30,%eax
801021e5:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
801021e6:	ba f0 01 00 00       	mov    $0x1f0,%edx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
801021eb:	8d 71 5c             	lea    0x5c(%ecx),%esi
801021ee:	b9 80 00 00 00       	mov    $0x80,%ecx
801021f3:	fc                   	cld    
801021f4:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
801021f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801021f9:	5b                   	pop    %ebx
801021fa:	5e                   	pop    %esi
801021fb:	5d                   	pop    %ebp
801021fc:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
801021fd:	83 ec 0c             	sub    $0xc,%esp
80102200:	68 34 78 10 80       	push   $0x80107834
80102205:	e8 66 e1 ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
8010220a:	83 ec 0c             	sub    $0xc,%esp
8010220d:	68 2b 78 10 80       	push   $0x8010782b
80102212:	e8 59 e1 ff ff       	call   80100370 <panic>
80102217:	89 f6                	mov    %esi,%esi
80102219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102220 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80102220:	55                   	push   %ebp
80102221:	89 e5                	mov    %esp,%ebp
80102223:	83 ec 10             	sub    $0x10,%esp
  int i;

  initlock(&idelock, "ide");
80102226:	68 46 78 10 80       	push   $0x80107846
8010222b:	68 80 b5 10 80       	push   $0x8010b580
80102230:	e8 cb 24 00 00       	call   80104700 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102235:	58                   	pop    %eax
80102236:	a1 80 3d 11 80       	mov    0x80113d80,%eax
8010223b:	5a                   	pop    %edx
8010223c:	83 e8 01             	sub    $0x1,%eax
8010223f:	50                   	push   %eax
80102240:	6a 0e                	push   $0xe
80102242:	e8 a9 02 00 00       	call   801024f0 <ioapicenable>
80102247:	83 c4 10             	add    $0x10,%esp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010224a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010224f:	90                   	nop
80102250:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102251:	83 e0 c0             	and    $0xffffffc0,%eax
80102254:	3c 40                	cmp    $0x40,%al
80102256:	75 f8                	jne    80102250 <ideinit+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102258:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010225d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102262:	ee                   	out    %al,(%dx)
80102263:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102268:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010226d:	eb 06                	jmp    80102275 <ideinit+0x55>
8010226f:	90                   	nop
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102270:	83 e9 01             	sub    $0x1,%ecx
80102273:	74 0f                	je     80102284 <ideinit+0x64>
80102275:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102276:	84 c0                	test   %al,%al
80102278:	74 f6                	je     80102270 <ideinit+0x50>
      havedisk1 = 1;
8010227a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102281:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102284:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102289:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
8010228e:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
8010228f:	c9                   	leave  
80102290:	c3                   	ret    
80102291:	eb 0d                	jmp    801022a0 <ideintr>
80102293:	90                   	nop
80102294:	90                   	nop
80102295:	90                   	nop
80102296:	90                   	nop
80102297:	90                   	nop
80102298:	90                   	nop
80102299:	90                   	nop
8010229a:	90                   	nop
8010229b:	90                   	nop
8010229c:	90                   	nop
8010229d:	90                   	nop
8010229e:	90                   	nop
8010229f:	90                   	nop

801022a0 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
801022a0:	55                   	push   %ebp
801022a1:	89 e5                	mov    %esp,%ebp
801022a3:	57                   	push   %edi
801022a4:	56                   	push   %esi
801022a5:	53                   	push   %ebx
801022a6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801022a9:	68 80 b5 10 80       	push   $0x8010b580
801022ae:	e8 ad 25 00 00       	call   80104860 <acquire>

  if((b = idequeue) == 0){
801022b3:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
801022b9:	83 c4 10             	add    $0x10,%esp
801022bc:	85 db                	test   %ebx,%ebx
801022be:	74 34                	je     801022f4 <ideintr+0x54>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801022c0:	8b 43 58             	mov    0x58(%ebx),%eax
801022c3:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801022c8:	8b 33                	mov    (%ebx),%esi
801022ca:	f7 c6 04 00 00 00    	test   $0x4,%esi
801022d0:	74 3e                	je     80102310 <ideintr+0x70>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801022d2:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022d5:	83 ec 0c             	sub    $0xc,%esp
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801022d8:	83 ce 02             	or     $0x2,%esi
801022db:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022dd:	53                   	push   %ebx
801022de:	e8 4d 1e 00 00       	call   80104130 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022e3:	a1 64 b5 10 80       	mov    0x8010b564,%eax
801022e8:	83 c4 10             	add    $0x10,%esp
801022eb:	85 c0                	test   %eax,%eax
801022ed:	74 05                	je     801022f4 <ideintr+0x54>
    idestart(idequeue);
801022ef:	e8 5c fe ff ff       	call   80102150 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
801022f4:	83 ec 0c             	sub    $0xc,%esp
801022f7:	68 80 b5 10 80       	push   $0x8010b580
801022fc:	e8 0f 26 00 00       	call   80104910 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
80102301:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102304:	5b                   	pop    %ebx
80102305:	5e                   	pop    %esi
80102306:	5f                   	pop    %edi
80102307:	5d                   	pop    %ebp
80102308:	c3                   	ret    
80102309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102310:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102315:	8d 76 00             	lea    0x0(%esi),%esi
80102318:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102319:	89 c1                	mov    %eax,%ecx
8010231b:	83 e1 c0             	and    $0xffffffc0,%ecx
8010231e:	80 f9 40             	cmp    $0x40,%cl
80102321:	75 f5                	jne    80102318 <ideintr+0x78>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102323:	a8 21                	test   $0x21,%al
80102325:	75 ab                	jne    801022d2 <ideintr+0x32>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
80102327:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
8010232a:	b9 80 00 00 00       	mov    $0x80,%ecx
8010232f:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102334:	fc                   	cld    
80102335:	f3 6d                	rep insl (%dx),%es:(%edi)
80102337:	8b 33                	mov    (%ebx),%esi
80102339:	eb 97                	jmp    801022d2 <ideintr+0x32>
8010233b:	90                   	nop
8010233c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102340 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102340:	55                   	push   %ebp
80102341:	89 e5                	mov    %esp,%ebp
80102343:	53                   	push   %ebx
80102344:	83 ec 10             	sub    $0x10,%esp
80102347:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010234a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010234d:	50                   	push   %eax
8010234e:	e8 5d 23 00 00       	call   801046b0 <holdingsleep>
80102353:	83 c4 10             	add    $0x10,%esp
80102356:	85 c0                	test   %eax,%eax
80102358:	0f 84 ad 00 00 00    	je     8010240b <iderw+0xcb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010235e:	8b 03                	mov    (%ebx),%eax
80102360:	83 e0 06             	and    $0x6,%eax
80102363:	83 f8 02             	cmp    $0x2,%eax
80102366:	0f 84 b9 00 00 00    	je     80102425 <iderw+0xe5>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010236c:	8b 53 04             	mov    0x4(%ebx),%edx
8010236f:	85 d2                	test   %edx,%edx
80102371:	74 0d                	je     80102380 <iderw+0x40>
80102373:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102378:	85 c0                	test   %eax,%eax
8010237a:	0f 84 98 00 00 00    	je     80102418 <iderw+0xd8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102380:	83 ec 0c             	sub    $0xc,%esp
80102383:	68 80 b5 10 80       	push   $0x8010b580
80102388:	e8 d3 24 00 00       	call   80104860 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010238d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
80102393:	83 c4 10             	add    $0x10,%esp
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102396:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010239d:	85 d2                	test   %edx,%edx
8010239f:	75 09                	jne    801023aa <iderw+0x6a>
801023a1:	eb 58                	jmp    801023fb <iderw+0xbb>
801023a3:	90                   	nop
801023a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023a8:	89 c2                	mov    %eax,%edx
801023aa:	8b 42 58             	mov    0x58(%edx),%eax
801023ad:	85 c0                	test   %eax,%eax
801023af:	75 f7                	jne    801023a8 <iderw+0x68>
801023b1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801023b4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801023b6:	3b 1d 64 b5 10 80    	cmp    0x8010b564,%ebx
801023bc:	74 44                	je     80102402 <iderw+0xc2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023be:	8b 03                	mov    (%ebx),%eax
801023c0:	83 e0 06             	and    $0x6,%eax
801023c3:	83 f8 02             	cmp    $0x2,%eax
801023c6:	74 23                	je     801023eb <iderw+0xab>
801023c8:	90                   	nop
801023c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801023d0:	83 ec 08             	sub    $0x8,%esp
801023d3:	68 80 b5 10 80       	push   $0x8010b580
801023d8:	53                   	push   %ebx
801023d9:	e8 a2 1b 00 00       	call   80103f80 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023de:	8b 03                	mov    (%ebx),%eax
801023e0:	83 c4 10             	add    $0x10,%esp
801023e3:	83 e0 06             	and    $0x6,%eax
801023e6:	83 f8 02             	cmp    $0x2,%eax
801023e9:	75 e5                	jne    801023d0 <iderw+0x90>
    sleep(b, &idelock);
  }


  release(&idelock);
801023eb:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
801023f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023f5:	c9                   	leave  
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
801023f6:	e9 15 25 00 00       	jmp    80104910 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023fb:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102400:	eb b2                	jmp    801023b4 <iderw+0x74>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
80102402:	89 d8                	mov    %ebx,%eax
80102404:	e8 47 fd ff ff       	call   80102150 <idestart>
80102409:	eb b3                	jmp    801023be <iderw+0x7e>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
8010240b:	83 ec 0c             	sub    $0xc,%esp
8010240e:	68 4a 78 10 80       	push   $0x8010784a
80102413:	e8 58 df ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
80102418:	83 ec 0c             	sub    $0xc,%esp
8010241b:	68 75 78 10 80       	push   $0x80107875
80102420:	e8 4b df ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
80102425:	83 ec 0c             	sub    $0xc,%esp
80102428:	68 60 78 10 80       	push   $0x80107860
8010242d:	e8 3e df ff ff       	call   80100370 <panic>
80102432:	66 90                	xchg   %ax,%ax
80102434:	66 90                	xchg   %ax,%ax
80102436:	66 90                	xchg   %ax,%ax
80102438:	66 90                	xchg   %ax,%ax
8010243a:	66 90                	xchg   %ax,%ax
8010243c:	66 90                	xchg   %ax,%ax
8010243e:	66 90                	xchg   %ax,%ax

80102440 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102440:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102441:	c7 05 b4 36 11 80 00 	movl   $0xfec00000,0x801136b4
80102448:	00 c0 fe 
  ioapic->data = data;
}

void
ioapicinit(void)
{
8010244b:	89 e5                	mov    %esp,%ebp
8010244d:	56                   	push   %esi
8010244e:	53                   	push   %ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
8010244f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102456:	00 00 00 
  return ioapic->data;
80102459:	8b 15 b4 36 11 80    	mov    0x801136b4,%edx
8010245f:	8b 72 10             	mov    0x10(%edx),%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102462:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102468:	8b 0d b4 36 11 80    	mov    0x801136b4,%ecx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010246e:	0f b6 15 e0 37 11 80 	movzbl 0x801137e0,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102475:	89 f0                	mov    %esi,%eax
80102477:	c1 e8 10             	shr    $0x10,%eax
8010247a:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010247d:	8b 41 10             	mov    0x10(%ecx),%eax
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102480:	c1 e8 18             	shr    $0x18,%eax
80102483:	39 d0                	cmp    %edx,%eax
80102485:	74 16                	je     8010249d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102487:	83 ec 0c             	sub    $0xc,%esp
8010248a:	68 94 78 10 80       	push   $0x80107894
8010248f:	e8 cc e1 ff ff       	call   80100660 <cprintf>
80102494:	8b 0d b4 36 11 80    	mov    0x801136b4,%ecx
8010249a:	83 c4 10             	add    $0x10,%esp
8010249d:	83 c6 21             	add    $0x21,%esi
  ioapic->data = data;
}

void
ioapicinit(void)
{
801024a0:	ba 10 00 00 00       	mov    $0x10,%edx
801024a5:	b8 20 00 00 00       	mov    $0x20,%eax
801024aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801024b0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801024b2:	8b 0d b4 36 11 80    	mov    0x801136b4,%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801024b8:	89 c3                	mov    %eax,%ebx
801024ba:	81 cb 00 00 01 00    	or     $0x10000,%ebx
801024c0:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801024c3:	89 59 10             	mov    %ebx,0x10(%ecx)
801024c6:	8d 5a 01             	lea    0x1(%edx),%ebx
801024c9:	83 c2 02             	add    $0x2,%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801024cc:	39 f0                	cmp    %esi,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801024ce:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
801024d0:	8b 0d b4 36 11 80    	mov    0x801136b4,%ecx
801024d6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801024dd:	75 d1                	jne    801024b0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801024df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024e2:	5b                   	pop    %ebx
801024e3:	5e                   	pop    %esi
801024e4:	5d                   	pop    %ebp
801024e5:	c3                   	ret    
801024e6:	8d 76 00             	lea    0x0(%esi),%esi
801024e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024f0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801024f0:	55                   	push   %ebp
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801024f1:	8b 0d b4 36 11 80    	mov    0x801136b4,%ecx
  }
}

void
ioapicenable(int irq, int cpunum)
{
801024f7:	89 e5                	mov    %esp,%ebp
801024f9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801024fc:	8d 50 20             	lea    0x20(%eax),%edx
801024ff:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102503:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102505:	8b 0d b4 36 11 80    	mov    0x801136b4,%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010250b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010250e:	89 51 10             	mov    %edx,0x10(%ecx)
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102511:	8b 55 0c             	mov    0xc(%ebp),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102514:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102516:	a1 b4 36 11 80       	mov    0x801136b4,%eax
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010251b:	c1 e2 18             	shl    $0x18,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
8010251e:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102521:	5d                   	pop    %ebp
80102522:	c3                   	ret    
80102523:	66 90                	xchg   %ax,%ax
80102525:	66 90                	xchg   %ax,%ax
80102527:	66 90                	xchg   %ax,%ax
80102529:	66 90                	xchg   %ax,%ax
8010252b:	66 90                	xchg   %ax,%ax
8010252d:	66 90                	xchg   %ax,%ax
8010252f:	90                   	nop

80102530 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102530:	55                   	push   %ebp
80102531:	89 e5                	mov    %esp,%ebp
80102533:	53                   	push   %ebx
80102534:	83 ec 04             	sub    $0x4,%esp
80102537:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010253a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102540:	75 70                	jne    801025b2 <kfree+0x82>
80102542:	81 fb 48 66 11 80    	cmp    $0x80116648,%ebx
80102548:	72 68                	jb     801025b2 <kfree+0x82>
8010254a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102550:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102555:	77 5b                	ja     801025b2 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102557:	83 ec 04             	sub    $0x4,%esp
8010255a:	68 00 10 00 00       	push   $0x1000
8010255f:	6a 01                	push   $0x1
80102561:	53                   	push   %ebx
80102562:	e8 f9 23 00 00       	call   80104960 <memset>

  if(kmem.use_lock)
80102567:	8b 15 f4 36 11 80    	mov    0x801136f4,%edx
8010256d:	83 c4 10             	add    $0x10,%esp
80102570:	85 d2                	test   %edx,%edx
80102572:	75 2c                	jne    801025a0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102574:	a1 f8 36 11 80       	mov    0x801136f8,%eax
80102579:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010257b:	a1 f4 36 11 80       	mov    0x801136f4,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102580:	89 1d f8 36 11 80    	mov    %ebx,0x801136f8
  if(kmem.use_lock)
80102586:	85 c0                	test   %eax,%eax
80102588:	75 06                	jne    80102590 <kfree+0x60>
    release(&kmem.lock);
}
8010258a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010258d:	c9                   	leave  
8010258e:	c3                   	ret    
8010258f:	90                   	nop
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102590:	c7 45 08 c0 36 11 80 	movl   $0x801136c0,0x8(%ebp)
}
80102597:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010259a:	c9                   	leave  
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
8010259b:	e9 70 23 00 00       	jmp    80104910 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
801025a0:	83 ec 0c             	sub    $0xc,%esp
801025a3:	68 c0 36 11 80       	push   $0x801136c0
801025a8:	e8 b3 22 00 00       	call   80104860 <acquire>
801025ad:	83 c4 10             	add    $0x10,%esp
801025b0:	eb c2                	jmp    80102574 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
801025b2:	83 ec 0c             	sub    $0xc,%esp
801025b5:	68 c6 78 10 80       	push   $0x801078c6
801025ba:	e8 b1 dd ff ff       	call   80100370 <panic>
801025bf:	90                   	nop

801025c0 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	56                   	push   %esi
801025c4:	53                   	push   %ebx
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801025c5:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
801025c8:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801025cb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025dd:	39 de                	cmp    %ebx,%esi
801025df:	72 23                	jb     80102604 <freerange+0x44>
801025e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025e8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801025ee:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025f7:	50                   	push   %eax
801025f8:	e8 33 ff ff ff       	call   80102530 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025fd:	83 c4 10             	add    $0x10,%esp
80102600:	39 f3                	cmp    %esi,%ebx
80102602:	76 e4                	jbe    801025e8 <freerange+0x28>
    kfree(p);
}
80102604:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102607:	5b                   	pop    %ebx
80102608:	5e                   	pop    %esi
80102609:	5d                   	pop    %ebp
8010260a:	c3                   	ret    
8010260b:	90                   	nop
8010260c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102610 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	56                   	push   %esi
80102614:	53                   	push   %ebx
80102615:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102618:	83 ec 08             	sub    $0x8,%esp
8010261b:	68 cc 78 10 80       	push   $0x801078cc
80102620:	68 c0 36 11 80       	push   $0x801136c0
80102625:	e8 d6 20 00 00       	call   80104700 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010262a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010262d:	83 c4 10             	add    $0x10,%esp
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
80102630:	c7 05 f4 36 11 80 00 	movl   $0x0,0x801136f4
80102637:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010263a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102640:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102646:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010264c:	39 de                	cmp    %ebx,%esi
8010264e:	72 1c                	jb     8010266c <kinit1+0x5c>
    kfree(p);
80102650:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102656:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102659:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010265f:	50                   	push   %eax
80102660:	e8 cb fe ff ff       	call   80102530 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102665:	83 c4 10             	add    $0x10,%esp
80102668:	39 de                	cmp    %ebx,%esi
8010266a:	73 e4                	jae    80102650 <kinit1+0x40>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010266c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010266f:	5b                   	pop    %ebx
80102670:	5e                   	pop    %esi
80102671:	5d                   	pop    %ebp
80102672:	c3                   	ret    
80102673:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102680 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102680:	55                   	push   %ebp
80102681:	89 e5                	mov    %esp,%ebp
80102683:	56                   	push   %esi
80102684:	53                   	push   %ebx

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102685:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
80102688:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010268b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102691:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102697:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010269d:	39 de                	cmp    %ebx,%esi
8010269f:	72 23                	jb     801026c4 <kinit2+0x44>
801026a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801026a8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801026ae:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026b7:	50                   	push   %eax
801026b8:	e8 73 fe ff ff       	call   80102530 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026bd:	83 c4 10             	add    $0x10,%esp
801026c0:	39 de                	cmp    %ebx,%esi
801026c2:	73 e4                	jae    801026a8 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
801026c4:	c7 05 f4 36 11 80 01 	movl   $0x1,0x801136f4
801026cb:	00 00 00 
}
801026ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026d1:	5b                   	pop    %ebx
801026d2:	5e                   	pop    %esi
801026d3:	5d                   	pop    %ebp
801026d4:	c3                   	ret    
801026d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026e0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801026e0:	55                   	push   %ebp
801026e1:	89 e5                	mov    %esp,%ebp
801026e3:	53                   	push   %ebx
801026e4:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
801026e7:	a1 f4 36 11 80       	mov    0x801136f4,%eax
801026ec:	85 c0                	test   %eax,%eax
801026ee:	75 30                	jne    80102720 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801026f0:	8b 1d f8 36 11 80    	mov    0x801136f8,%ebx
  if(r)
801026f6:	85 db                	test   %ebx,%ebx
801026f8:	74 1c                	je     80102716 <kalloc+0x36>
    kmem.freelist = r->next;
801026fa:	8b 13                	mov    (%ebx),%edx
801026fc:	89 15 f8 36 11 80    	mov    %edx,0x801136f8
  if(kmem.use_lock)
80102702:	85 c0                	test   %eax,%eax
80102704:	74 10                	je     80102716 <kalloc+0x36>
    release(&kmem.lock);
80102706:	83 ec 0c             	sub    $0xc,%esp
80102709:	68 c0 36 11 80       	push   $0x801136c0
8010270e:	e8 fd 21 00 00       	call   80104910 <release>
80102713:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
}
80102716:	89 d8                	mov    %ebx,%eax
80102718:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010271b:	c9                   	leave  
8010271c:	c3                   	ret    
8010271d:	8d 76 00             	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102720:	83 ec 0c             	sub    $0xc,%esp
80102723:	68 c0 36 11 80       	push   $0x801136c0
80102728:	e8 33 21 00 00       	call   80104860 <acquire>
  r = kmem.freelist;
8010272d:	8b 1d f8 36 11 80    	mov    0x801136f8,%ebx
  if(r)
80102733:	83 c4 10             	add    $0x10,%esp
80102736:	a1 f4 36 11 80       	mov    0x801136f4,%eax
8010273b:	85 db                	test   %ebx,%ebx
8010273d:	75 bb                	jne    801026fa <kalloc+0x1a>
8010273f:	eb c1                	jmp    80102702 <kalloc+0x22>
80102741:	66 90                	xchg   %ax,%ax
80102743:	66 90                	xchg   %ax,%ax
80102745:	66 90                	xchg   %ax,%ax
80102747:	66 90                	xchg   %ax,%ax
80102749:	66 90                	xchg   %ax,%ax
8010274b:	66 90                	xchg   %ax,%ax
8010274d:	66 90                	xchg   %ax,%ax
8010274f:	90                   	nop

80102750 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102750:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102751:	ba 64 00 00 00       	mov    $0x64,%edx
80102756:	89 e5                	mov    %esp,%ebp
80102758:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102759:	a8 01                	test   $0x1,%al
8010275b:	0f 84 af 00 00 00    	je     80102810 <kbdgetc+0xc0>
80102761:	ba 60 00 00 00       	mov    $0x60,%edx
80102766:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102767:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
8010276a:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102770:	74 7e                	je     801027f0 <kbdgetc+0xa0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102772:	84 c0                	test   %al,%al
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102774:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
8010277a:	79 24                	jns    801027a0 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
8010277c:	f6 c1 40             	test   $0x40,%cl
8010277f:	75 05                	jne    80102786 <kbdgetc+0x36>
80102781:	89 c2                	mov    %eax,%edx
80102783:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102786:	0f b6 82 00 7a 10 80 	movzbl -0x7fef8600(%edx),%eax
8010278d:	83 c8 40             	or     $0x40,%eax
80102790:	0f b6 c0             	movzbl %al,%eax
80102793:	f7 d0                	not    %eax
80102795:	21 c8                	and    %ecx,%eax
80102797:	a3 b4 b5 10 80       	mov    %eax,0x8010b5b4
    return 0;
8010279c:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010279e:	5d                   	pop    %ebp
8010279f:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801027a0:	f6 c1 40             	test   $0x40,%cl
801027a3:	74 09                	je     801027ae <kbdgetc+0x5e>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801027a5:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801027a8:	83 e1 bf             	and    $0xffffffbf,%ecx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801027ab:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
801027ae:	0f b6 82 00 7a 10 80 	movzbl -0x7fef8600(%edx),%eax
801027b5:	09 c1                	or     %eax,%ecx
801027b7:	0f b6 82 00 79 10 80 	movzbl -0x7fef8700(%edx),%eax
801027be:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801027c0:	89 c8                	mov    %ecx,%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
801027c2:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801027c8:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801027cb:	83 e1 08             	and    $0x8,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
801027ce:	8b 04 85 e0 78 10 80 	mov    -0x7fef8720(,%eax,4),%eax
801027d5:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801027d9:	74 c3                	je     8010279e <kbdgetc+0x4e>
    if('a' <= c && c <= 'z')
801027db:	8d 50 9f             	lea    -0x61(%eax),%edx
801027de:	83 fa 19             	cmp    $0x19,%edx
801027e1:	77 1d                	ja     80102800 <kbdgetc+0xb0>
      c += 'A' - 'a';
801027e3:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801027e6:	5d                   	pop    %ebp
801027e7:	c3                   	ret    
801027e8:	90                   	nop
801027e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
801027f0:	31 c0                	xor    %eax,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801027f2:	83 0d b4 b5 10 80 40 	orl    $0x40,0x8010b5b4
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801027f9:	5d                   	pop    %ebp
801027fa:	c3                   	ret    
801027fb:	90                   	nop
801027fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
80102800:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102803:	8d 50 20             	lea    0x20(%eax),%edx
  }
  return c;
}
80102806:	5d                   	pop    %ebp
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
80102807:	83 f9 19             	cmp    $0x19,%ecx
8010280a:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
8010280d:	c3                   	ret    
8010280e:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
80102810:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102815:	5d                   	pop    %ebp
80102816:	c3                   	ret    
80102817:	89 f6                	mov    %esi,%esi
80102819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102820 <kbdintr>:

void
kbdintr(void)
{
80102820:	55                   	push   %ebp
80102821:	89 e5                	mov    %esp,%ebp
80102823:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102826:	68 50 27 10 80       	push   $0x80102750
8010282b:	e8 c0 df ff ff       	call   801007f0 <consoleintr>
}
80102830:	83 c4 10             	add    $0x10,%esp
80102833:	c9                   	leave  
80102834:	c3                   	ret    
80102835:	66 90                	xchg   %ax,%ax
80102837:	66 90                	xchg   %ax,%ax
80102839:	66 90                	xchg   %ax,%ax
8010283b:	66 90                	xchg   %ax,%ax
8010283d:	66 90                	xchg   %ax,%ax
8010283f:	90                   	nop

80102840 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102840:	a1 fc 36 11 80       	mov    0x801136fc,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102845:	55                   	push   %ebp
80102846:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102848:	85 c0                	test   %eax,%eax
8010284a:	0f 84 c8 00 00 00    	je     80102918 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102850:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102857:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010285a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010285d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102864:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102867:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010286a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102871:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102874:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102877:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010287e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102881:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102884:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010288b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010288e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102891:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102898:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010289b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010289e:	8b 50 30             	mov    0x30(%eax),%edx
801028a1:	c1 ea 10             	shr    $0x10,%edx
801028a4:	80 fa 03             	cmp    $0x3,%dl
801028a7:	77 77                	ja     80102920 <lapicinit+0xe0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028a9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801028b0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028b3:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028b6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028bd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028c0:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028c3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028ca:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028cd:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028d0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028d7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028da:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028dd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801028e4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028e7:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028ea:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028f1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801028f4:	8b 50 20             	mov    0x20(%eax),%edx
801028f7:	89 f6                	mov    %esi,%esi
801028f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102900:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102906:	80 e6 10             	and    $0x10,%dh
80102909:	75 f5                	jne    80102900 <lapicinit+0xc0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010290b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102912:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102915:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102918:	5d                   	pop    %ebp
80102919:	c3                   	ret    
8010291a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102920:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102927:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010292a:	8b 50 20             	mov    0x20(%eax),%edx
8010292d:	e9 77 ff ff ff       	jmp    801028a9 <lapicinit+0x69>
80102932:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102940 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
80102940:	a1 fc 36 11 80       	mov    0x801136fc,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
80102945:	55                   	push   %ebp
80102946:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102948:	85 c0                	test   %eax,%eax
8010294a:	74 0c                	je     80102958 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
8010294c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010294f:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
80102950:	c1 e8 18             	shr    $0x18,%eax
}
80102953:	c3                   	ret    
80102954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
80102958:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
8010295a:	5d                   	pop    %ebp
8010295b:	c3                   	ret    
8010295c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102960 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102960:	a1 fc 36 11 80       	mov    0x801136fc,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102965:	55                   	push   %ebp
80102966:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102968:	85 c0                	test   %eax,%eax
8010296a:	74 0d                	je     80102979 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010296c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102973:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102976:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102979:	5d                   	pop    %ebp
8010297a:	c3                   	ret    
8010297b:	90                   	nop
8010297c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102980 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102980:	55                   	push   %ebp
80102981:	89 e5                	mov    %esp,%ebp
}
80102983:	5d                   	pop    %ebp
80102984:	c3                   	ret    
80102985:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102990 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102990:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102991:	ba 70 00 00 00       	mov    $0x70,%edx
80102996:	b8 0f 00 00 00       	mov    $0xf,%eax
8010299b:	89 e5                	mov    %esp,%ebp
8010299d:	53                   	push   %ebx
8010299e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801029a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801029a4:	ee                   	out    %al,(%dx)
801029a5:	ba 71 00 00 00       	mov    $0x71,%edx
801029aa:	b8 0a 00 00 00       	mov    $0xa,%eax
801029af:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801029b0:	31 c0                	xor    %eax,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029b2:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801029b5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801029bb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801029bd:	c1 e9 0c             	shr    $0xc,%ecx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
801029c0:	c1 e8 04             	shr    $0x4,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029c3:	89 da                	mov    %ebx,%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801029c5:	80 cd 06             	or     $0x6,%ch
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
801029c8:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029ce:	a1 fc 36 11 80       	mov    0x801136fc,%eax
801029d3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029d9:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029dc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801029e3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029e6:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029e9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029f0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029f3:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029f6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029fc:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029ff:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a05:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a08:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a0e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a11:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a17:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80102a1a:	5b                   	pop    %ebx
80102a1b:	5d                   	pop    %ebp
80102a1c:	c3                   	ret    
80102a1d:	8d 76 00             	lea    0x0(%esi),%esi

80102a20 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102a20:	55                   	push   %ebp
80102a21:	ba 70 00 00 00       	mov    $0x70,%edx
80102a26:	b8 0b 00 00 00       	mov    $0xb,%eax
80102a2b:	89 e5                	mov    %esp,%ebp
80102a2d:	57                   	push   %edi
80102a2e:	56                   	push   %esi
80102a2f:	53                   	push   %ebx
80102a30:	83 ec 4c             	sub    $0x4c,%esp
80102a33:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a34:	ba 71 00 00 00       	mov    $0x71,%edx
80102a39:	ec                   	in     (%dx),%al
80102a3a:	83 e0 04             	and    $0x4,%eax
80102a3d:	8d 75 d0             	lea    -0x30(%ebp),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a40:	31 db                	xor    %ebx,%ebx
80102a42:	88 45 b7             	mov    %al,-0x49(%ebp)
80102a45:	bf 70 00 00 00       	mov    $0x70,%edi
80102a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102a50:	89 d8                	mov    %ebx,%eax
80102a52:	89 fa                	mov    %edi,%edx
80102a54:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a55:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a5a:	89 ca                	mov    %ecx,%edx
80102a5c:	ec                   	in     (%dx),%al
}

static void
fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
80102a5d:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a60:	89 fa                	mov    %edi,%edx
80102a62:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a65:	b8 02 00 00 00       	mov    $0x2,%eax
80102a6a:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a6b:	89 ca                	mov    %ecx,%edx
80102a6d:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102a6e:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a71:	89 fa                	mov    %edi,%edx
80102a73:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a76:	b8 04 00 00 00       	mov    $0x4,%eax
80102a7b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a7c:	89 ca                	mov    %ecx,%edx
80102a7e:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102a7f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a82:	89 fa                	mov    %edi,%edx
80102a84:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a87:	b8 07 00 00 00       	mov    $0x7,%eax
80102a8c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8d:	89 ca                	mov    %ecx,%edx
80102a8f:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102a90:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a93:	89 fa                	mov    %edi,%edx
80102a95:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a98:	b8 08 00 00 00       	mov    $0x8,%eax
80102a9d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9e:	89 ca                	mov    %ecx,%edx
80102aa0:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102aa1:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa4:	89 fa                	mov    %edi,%edx
80102aa6:	89 45 c8             	mov    %eax,-0x38(%ebp)
80102aa9:	b8 09 00 00 00       	mov    $0x9,%eax
80102aae:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aaf:	89 ca                	mov    %ecx,%edx
80102ab1:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102ab2:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab5:	89 fa                	mov    %edi,%edx
80102ab7:	89 45 cc             	mov    %eax,-0x34(%ebp)
80102aba:	b8 0a 00 00 00       	mov    $0xa,%eax
80102abf:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ac0:	89 ca                	mov    %ecx,%edx
80102ac2:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102ac3:	84 c0                	test   %al,%al
80102ac5:	78 89                	js     80102a50 <cmostime+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac7:	89 d8                	mov    %ebx,%eax
80102ac9:	89 fa                	mov    %edi,%edx
80102acb:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102acc:	89 ca                	mov    %ecx,%edx
80102ace:	ec                   	in     (%dx),%al
}

static void
fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
80102acf:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad2:	89 fa                	mov    %edi,%edx
80102ad4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102ad7:	b8 02 00 00 00       	mov    $0x2,%eax
80102adc:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102add:	89 ca                	mov    %ecx,%edx
80102adf:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102ae0:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ae3:	89 fa                	mov    %edi,%edx
80102ae5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102ae8:	b8 04 00 00 00       	mov    $0x4,%eax
80102aed:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aee:	89 ca                	mov    %ecx,%edx
80102af0:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102af1:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102af4:	89 fa                	mov    %edi,%edx
80102af6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102af9:	b8 07 00 00 00       	mov    $0x7,%eax
80102afe:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aff:	89 ca                	mov    %ecx,%edx
80102b01:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102b02:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b05:	89 fa                	mov    %edi,%edx
80102b07:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102b0a:	b8 08 00 00 00       	mov    $0x8,%eax
80102b0f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b10:	89 ca                	mov    %ecx,%edx
80102b12:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102b13:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b16:	89 fa                	mov    %edi,%edx
80102b18:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102b1b:	b8 09 00 00 00       	mov    $0x9,%eax
80102b20:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b21:	89 ca                	mov    %ecx,%edx
80102b23:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102b24:	0f b6 c0             	movzbl %al,%eax
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b27:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
80102b2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b2d:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b30:	6a 18                	push   $0x18
80102b32:	56                   	push   %esi
80102b33:	50                   	push   %eax
80102b34:	e8 77 1e 00 00       	call   801049b0 <memcmp>
80102b39:	83 c4 10             	add    $0x10,%esp
80102b3c:	85 c0                	test   %eax,%eax
80102b3e:	0f 85 0c ff ff ff    	jne    80102a50 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102b44:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102b48:	75 78                	jne    80102bc2 <cmostime+0x1a2>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b4a:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b4d:	89 c2                	mov    %eax,%edx
80102b4f:	83 e0 0f             	and    $0xf,%eax
80102b52:	c1 ea 04             	shr    $0x4,%edx
80102b55:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b58:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b5b:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b5e:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b61:	89 c2                	mov    %eax,%edx
80102b63:	83 e0 0f             	and    $0xf,%eax
80102b66:	c1 ea 04             	shr    $0x4,%edx
80102b69:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b6c:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b6f:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b72:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b75:	89 c2                	mov    %eax,%edx
80102b77:	83 e0 0f             	and    $0xf,%eax
80102b7a:	c1 ea 04             	shr    $0x4,%edx
80102b7d:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b80:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b83:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b86:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b89:	89 c2                	mov    %eax,%edx
80102b8b:	83 e0 0f             	and    $0xf,%eax
80102b8e:	c1 ea 04             	shr    $0x4,%edx
80102b91:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b94:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b97:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b9a:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b9d:	89 c2                	mov    %eax,%edx
80102b9f:	83 e0 0f             	and    $0xf,%eax
80102ba2:	c1 ea 04             	shr    $0x4,%edx
80102ba5:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ba8:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bab:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102bae:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102bb1:	89 c2                	mov    %eax,%edx
80102bb3:	83 e0 0f             	and    $0xf,%eax
80102bb6:	c1 ea 04             	shr    $0x4,%edx
80102bb9:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bbc:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bbf:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102bc2:	8b 75 08             	mov    0x8(%ebp),%esi
80102bc5:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102bc8:	89 06                	mov    %eax,(%esi)
80102bca:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102bcd:	89 46 04             	mov    %eax,0x4(%esi)
80102bd0:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102bd3:	89 46 08             	mov    %eax,0x8(%esi)
80102bd6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bd9:	89 46 0c             	mov    %eax,0xc(%esi)
80102bdc:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bdf:	89 46 10             	mov    %eax,0x10(%esi)
80102be2:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102be5:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102be8:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102bef:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bf2:	5b                   	pop    %ebx
80102bf3:	5e                   	pop    %esi
80102bf4:	5f                   	pop    %edi
80102bf5:	5d                   	pop    %ebp
80102bf6:	c3                   	ret    
80102bf7:	66 90                	xchg   %ax,%ax
80102bf9:	66 90                	xchg   %ax,%ax
80102bfb:	66 90                	xchg   %ax,%ax
80102bfd:	66 90                	xchg   %ax,%ax
80102bff:	90                   	nop

80102c00 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c00:	8b 0d 48 37 11 80    	mov    0x80113748,%ecx
80102c06:	85 c9                	test   %ecx,%ecx
80102c08:	0f 8e 85 00 00 00    	jle    80102c93 <install_trans+0x93>
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102c0e:	55                   	push   %ebp
80102c0f:	89 e5                	mov    %esp,%ebp
80102c11:	57                   	push   %edi
80102c12:	56                   	push   %esi
80102c13:	53                   	push   %ebx
80102c14:	31 db                	xor    %ebx,%ebx
80102c16:	83 ec 0c             	sub    $0xc,%esp
80102c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102c20:	a1 34 37 11 80       	mov    0x80113734,%eax
80102c25:	83 ec 08             	sub    $0x8,%esp
80102c28:	01 d8                	add    %ebx,%eax
80102c2a:	83 c0 01             	add    $0x1,%eax
80102c2d:	50                   	push   %eax
80102c2e:	ff 35 44 37 11 80    	pushl  0x80113744
80102c34:	e8 97 d4 ff ff       	call   801000d0 <bread>
80102c39:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c3b:	58                   	pop    %eax
80102c3c:	5a                   	pop    %edx
80102c3d:	ff 34 9d 4c 37 11 80 	pushl  -0x7feec8b4(,%ebx,4)
80102c44:	ff 35 44 37 11 80    	pushl  0x80113744
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c4a:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c4d:	e8 7e d4 ff ff       	call   801000d0 <bread>
80102c52:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c54:	8d 47 5c             	lea    0x5c(%edi),%eax
80102c57:	83 c4 0c             	add    $0xc,%esp
80102c5a:	68 00 02 00 00       	push   $0x200
80102c5f:	50                   	push   %eax
80102c60:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c63:	50                   	push   %eax
80102c64:	e8 a7 1d 00 00       	call   80104a10 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c69:	89 34 24             	mov    %esi,(%esp)
80102c6c:	e8 2f d5 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102c71:	89 3c 24             	mov    %edi,(%esp)
80102c74:	e8 67 d5 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102c79:	89 34 24             	mov    %esi,(%esp)
80102c7c:	e8 5f d5 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c81:	83 c4 10             	add    $0x10,%esp
80102c84:	39 1d 48 37 11 80    	cmp    %ebx,0x80113748
80102c8a:	7f 94                	jg     80102c20 <install_trans+0x20>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102c8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c8f:	5b                   	pop    %ebx
80102c90:	5e                   	pop    %esi
80102c91:	5f                   	pop    %edi
80102c92:	5d                   	pop    %ebp
80102c93:	f3 c3                	repz ret 
80102c95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ca0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ca0:	55                   	push   %ebp
80102ca1:	89 e5                	mov    %esp,%ebp
80102ca3:	53                   	push   %ebx
80102ca4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ca7:	ff 35 34 37 11 80    	pushl  0x80113734
80102cad:	ff 35 44 37 11 80    	pushl  0x80113744
80102cb3:	e8 18 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102cb8:	8b 0d 48 37 11 80    	mov    0x80113748,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102cbe:	83 c4 10             	add    $0x10,%esp
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102cc1:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102cc3:	85 c9                	test   %ecx,%ecx
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102cc5:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102cc8:	7e 1f                	jle    80102ce9 <write_head+0x49>
80102cca:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80102cd1:	31 d2                	xor    %edx,%edx
80102cd3:	90                   	nop
80102cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102cd8:	8b 8a 4c 37 11 80    	mov    -0x7feec8b4(%edx),%ecx
80102cde:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
80102ce2:	83 c2 04             	add    $0x4,%edx
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102ce5:	39 c2                	cmp    %eax,%edx
80102ce7:	75 ef                	jne    80102cd8 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102ce9:	83 ec 0c             	sub    $0xc,%esp
80102cec:	53                   	push   %ebx
80102ced:	e8 ae d4 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102cf2:	89 1c 24             	mov    %ebx,(%esp)
80102cf5:	e8 e6 d4 ff ff       	call   801001e0 <brelse>
}
80102cfa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cfd:	c9                   	leave  
80102cfe:	c3                   	ret    
80102cff:	90                   	nop

80102d00 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102d00:	55                   	push   %ebp
80102d01:	89 e5                	mov    %esp,%ebp
80102d03:	53                   	push   %ebx
80102d04:	83 ec 2c             	sub    $0x2c,%esp
80102d07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102d0a:	68 00 7b 10 80       	push   $0x80107b00
80102d0f:	68 00 37 11 80       	push   $0x80113700
80102d14:	e8 e7 19 00 00       	call   80104700 <initlock>
  readsb(dev, &sb);
80102d19:	58                   	pop    %eax
80102d1a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102d1d:	5a                   	pop    %edx
80102d1e:	50                   	push   %eax
80102d1f:	53                   	push   %ebx
80102d20:	e8 5b e9 ff ff       	call   80101680 <readsb>
  log.start = sb.logstart;
  log.size = sb.nlog;
80102d25:	8b 55 e8             	mov    -0x18(%ebp),%edx
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102d28:	8b 45 ec             	mov    -0x14(%ebp),%eax

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102d2b:	59                   	pop    %ecx
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102d2c:	89 1d 44 37 11 80    	mov    %ebx,0x80113744

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102d32:	89 15 38 37 11 80    	mov    %edx,0x80113738
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102d38:	a3 34 37 11 80       	mov    %eax,0x80113734

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102d3d:	5a                   	pop    %edx
80102d3e:	50                   	push   %eax
80102d3f:	53                   	push   %ebx
80102d40:	e8 8b d3 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102d45:	8b 48 5c             	mov    0x5c(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102d48:	83 c4 10             	add    $0x10,%esp
80102d4b:	85 c9                	test   %ecx,%ecx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102d4d:	89 0d 48 37 11 80    	mov    %ecx,0x80113748
  for (i = 0; i < log.lh.n; i++) {
80102d53:	7e 1c                	jle    80102d71 <initlog+0x71>
80102d55:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102d5c:	31 d2                	xor    %edx,%edx
80102d5e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102d60:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102d64:	83 c2 04             	add    $0x4,%edx
80102d67:	89 8a 48 37 11 80    	mov    %ecx,-0x7feec8b8(%edx)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102d6d:	39 da                	cmp    %ebx,%edx
80102d6f:	75 ef                	jne    80102d60 <initlog+0x60>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102d71:	83 ec 0c             	sub    $0xc,%esp
80102d74:	50                   	push   %eax
80102d75:	e8 66 d4 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d7a:	e8 81 fe ff ff       	call   80102c00 <install_trans>
  log.lh.n = 0;
80102d7f:	c7 05 48 37 11 80 00 	movl   $0x0,0x80113748
80102d86:	00 00 00 
  write_head(); // clear the log
80102d89:	e8 12 ff ff ff       	call   80102ca0 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102d8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d91:	c9                   	leave  
80102d92:	c3                   	ret    
80102d93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102da0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102da0:	55                   	push   %ebp
80102da1:	89 e5                	mov    %esp,%ebp
80102da3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102da6:	68 00 37 11 80       	push   $0x80113700
80102dab:	e8 b0 1a 00 00       	call   80104860 <acquire>
80102db0:	83 c4 10             	add    $0x10,%esp
80102db3:	eb 18                	jmp    80102dcd <begin_op+0x2d>
80102db5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102db8:	83 ec 08             	sub    $0x8,%esp
80102dbb:	68 00 37 11 80       	push   $0x80113700
80102dc0:	68 00 37 11 80       	push   $0x80113700
80102dc5:	e8 b6 11 00 00       	call   80103f80 <sleep>
80102dca:	83 c4 10             	add    $0x10,%esp
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102dcd:	a1 40 37 11 80       	mov    0x80113740,%eax
80102dd2:	85 c0                	test   %eax,%eax
80102dd4:	75 e2                	jne    80102db8 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102dd6:	a1 3c 37 11 80       	mov    0x8011373c,%eax
80102ddb:	8b 15 48 37 11 80    	mov    0x80113748,%edx
80102de1:	83 c0 01             	add    $0x1,%eax
80102de4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102de7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102dea:	83 fa 1e             	cmp    $0x1e,%edx
80102ded:	7f c9                	jg     80102db8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102def:	83 ec 0c             	sub    $0xc,%esp
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102df2:	a3 3c 37 11 80       	mov    %eax,0x8011373c
      release(&log.lock);
80102df7:	68 00 37 11 80       	push   $0x80113700
80102dfc:	e8 0f 1b 00 00       	call   80104910 <release>
      break;
    }
  }
}
80102e01:	83 c4 10             	add    $0x10,%esp
80102e04:	c9                   	leave  
80102e05:	c3                   	ret    
80102e06:	8d 76 00             	lea    0x0(%esi),%esi
80102e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102e10 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102e10:	55                   	push   %ebp
80102e11:	89 e5                	mov    %esp,%ebp
80102e13:	57                   	push   %edi
80102e14:	56                   	push   %esi
80102e15:	53                   	push   %ebx
80102e16:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102e19:	68 00 37 11 80       	push   $0x80113700
80102e1e:	e8 3d 1a 00 00       	call   80104860 <acquire>
  log.outstanding -= 1;
80102e23:	a1 3c 37 11 80       	mov    0x8011373c,%eax
  if(log.committing)
80102e28:	8b 1d 40 37 11 80    	mov    0x80113740,%ebx
80102e2e:	83 c4 10             	add    $0x10,%esp
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102e31:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102e34:	85 db                	test   %ebx,%ebx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102e36:	a3 3c 37 11 80       	mov    %eax,0x8011373c
  if(log.committing)
80102e3b:	0f 85 23 01 00 00    	jne    80102f64 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e41:	85 c0                	test   %eax,%eax
80102e43:	0f 85 f7 00 00 00    	jne    80102f40 <end_op+0x130>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e49:	83 ec 0c             	sub    $0xc,%esp
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102e4c:	c7 05 40 37 11 80 01 	movl   $0x1,0x80113740
80102e53:	00 00 00 
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e56:	31 db                	xor    %ebx,%ebx
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e58:	68 00 37 11 80       	push   $0x80113700
80102e5d:	e8 ae 1a 00 00       	call   80104910 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e62:	8b 0d 48 37 11 80    	mov    0x80113748,%ecx
80102e68:	83 c4 10             	add    $0x10,%esp
80102e6b:	85 c9                	test   %ecx,%ecx
80102e6d:	0f 8e 8a 00 00 00    	jle    80102efd <end_op+0xed>
80102e73:	90                   	nop
80102e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e78:	a1 34 37 11 80       	mov    0x80113734,%eax
80102e7d:	83 ec 08             	sub    $0x8,%esp
80102e80:	01 d8                	add    %ebx,%eax
80102e82:	83 c0 01             	add    $0x1,%eax
80102e85:	50                   	push   %eax
80102e86:	ff 35 44 37 11 80    	pushl  0x80113744
80102e8c:	e8 3f d2 ff ff       	call   801000d0 <bread>
80102e91:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e93:	58                   	pop    %eax
80102e94:	5a                   	pop    %edx
80102e95:	ff 34 9d 4c 37 11 80 	pushl  -0x7feec8b4(,%ebx,4)
80102e9c:	ff 35 44 37 11 80    	pushl  0x80113744
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ea2:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ea5:	e8 26 d2 ff ff       	call   801000d0 <bread>
80102eaa:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102eac:	8d 40 5c             	lea    0x5c(%eax),%eax
80102eaf:	83 c4 0c             	add    $0xc,%esp
80102eb2:	68 00 02 00 00       	push   $0x200
80102eb7:	50                   	push   %eax
80102eb8:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ebb:	50                   	push   %eax
80102ebc:	e8 4f 1b 00 00       	call   80104a10 <memmove>
    bwrite(to);  // write the log
80102ec1:	89 34 24             	mov    %esi,(%esp)
80102ec4:	e8 d7 d2 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102ec9:	89 3c 24             	mov    %edi,(%esp)
80102ecc:	e8 0f d3 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102ed1:	89 34 24             	mov    %esi,(%esp)
80102ed4:	e8 07 d3 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ed9:	83 c4 10             	add    $0x10,%esp
80102edc:	3b 1d 48 37 11 80    	cmp    0x80113748,%ebx
80102ee2:	7c 94                	jl     80102e78 <end_op+0x68>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102ee4:	e8 b7 fd ff ff       	call   80102ca0 <write_head>
    install_trans(); // Now install writes to home locations
80102ee9:	e8 12 fd ff ff       	call   80102c00 <install_trans>
    log.lh.n = 0;
80102eee:	c7 05 48 37 11 80 00 	movl   $0x0,0x80113748
80102ef5:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ef8:	e8 a3 fd ff ff       	call   80102ca0 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102efd:	83 ec 0c             	sub    $0xc,%esp
80102f00:	68 00 37 11 80       	push   $0x80113700
80102f05:	e8 56 19 00 00       	call   80104860 <acquire>
    log.committing = 0;
    wakeup(&log);
80102f0a:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
80102f11:	c7 05 40 37 11 80 00 	movl   $0x0,0x80113740
80102f18:	00 00 00 
    wakeup(&log);
80102f1b:	e8 10 12 00 00       	call   80104130 <wakeup>
    release(&log.lock);
80102f20:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
80102f27:	e8 e4 19 00 00       	call   80104910 <release>
80102f2c:	83 c4 10             	add    $0x10,%esp
  }
}
80102f2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f32:	5b                   	pop    %ebx
80102f33:	5e                   	pop    %esi
80102f34:	5f                   	pop    %edi
80102f35:	5d                   	pop    %ebp
80102f36:	c3                   	ret    
80102f37:	89 f6                	mov    %esi,%esi
80102f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
80102f40:	83 ec 0c             	sub    $0xc,%esp
80102f43:	68 00 37 11 80       	push   $0x80113700
80102f48:	e8 e3 11 00 00       	call   80104130 <wakeup>
  }
  release(&log.lock);
80102f4d:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
80102f54:	e8 b7 19 00 00       	call   80104910 <release>
80102f59:	83 c4 10             	add    $0x10,%esp
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}
80102f5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f5f:	5b                   	pop    %ebx
80102f60:	5e                   	pop    %esi
80102f61:	5f                   	pop    %edi
80102f62:	5d                   	pop    %ebp
80102f63:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102f64:	83 ec 0c             	sub    $0xc,%esp
80102f67:	68 04 7b 10 80       	push   $0x80107b04
80102f6c:	e8 ff d3 ff ff       	call   80100370 <panic>
80102f71:	eb 0d                	jmp    80102f80 <log_write>
80102f73:	90                   	nop
80102f74:	90                   	nop
80102f75:	90                   	nop
80102f76:	90                   	nop
80102f77:	90                   	nop
80102f78:	90                   	nop
80102f79:	90                   	nop
80102f7a:	90                   	nop
80102f7b:	90                   	nop
80102f7c:	90                   	nop
80102f7d:	90                   	nop
80102f7e:	90                   	nop
80102f7f:	90                   	nop

80102f80 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f80:	55                   	push   %ebp
80102f81:	89 e5                	mov    %esp,%ebp
80102f83:	53                   	push   %ebx
80102f84:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f87:	8b 15 48 37 11 80    	mov    0x80113748,%edx
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f90:	83 fa 1d             	cmp    $0x1d,%edx
80102f93:	0f 8f 97 00 00 00    	jg     80103030 <log_write+0xb0>
80102f99:	a1 38 37 11 80       	mov    0x80113738,%eax
80102f9e:	83 e8 01             	sub    $0x1,%eax
80102fa1:	39 c2                	cmp    %eax,%edx
80102fa3:	0f 8d 87 00 00 00    	jge    80103030 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102fa9:	a1 3c 37 11 80       	mov    0x8011373c,%eax
80102fae:	85 c0                	test   %eax,%eax
80102fb0:	0f 8e 87 00 00 00    	jle    8010303d <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102fb6:	83 ec 0c             	sub    $0xc,%esp
80102fb9:	68 00 37 11 80       	push   $0x80113700
80102fbe:	e8 9d 18 00 00       	call   80104860 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102fc3:	8b 15 48 37 11 80    	mov    0x80113748,%edx
80102fc9:	83 c4 10             	add    $0x10,%esp
80102fcc:	83 fa 00             	cmp    $0x0,%edx
80102fcf:	7e 50                	jle    80103021 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fd1:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102fd4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fd6:	3b 0d 4c 37 11 80    	cmp    0x8011374c,%ecx
80102fdc:	75 0b                	jne    80102fe9 <log_write+0x69>
80102fde:	eb 38                	jmp    80103018 <log_write+0x98>
80102fe0:	39 0c 85 4c 37 11 80 	cmp    %ecx,-0x7feec8b4(,%eax,4)
80102fe7:	74 2f                	je     80103018 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102fe9:	83 c0 01             	add    $0x1,%eax
80102fec:	39 d0                	cmp    %edx,%eax
80102fee:	75 f0                	jne    80102fe0 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102ff0:	89 0c 95 4c 37 11 80 	mov    %ecx,-0x7feec8b4(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102ff7:	83 c2 01             	add    $0x1,%edx
80102ffa:	89 15 48 37 11 80    	mov    %edx,0x80113748
  b->flags |= B_DIRTY; // prevent eviction
80103000:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103003:	c7 45 08 00 37 11 80 	movl   $0x80113700,0x8(%ebp)
}
8010300a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010300d:	c9                   	leave  
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
8010300e:	e9 fd 18 00 00       	jmp    80104910 <release>
80103013:	90                   	nop
80103014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80103018:	89 0c 85 4c 37 11 80 	mov    %ecx,-0x7feec8b4(,%eax,4)
8010301f:	eb df                	jmp    80103000 <log_write+0x80>
80103021:	8b 43 08             	mov    0x8(%ebx),%eax
80103024:	a3 4c 37 11 80       	mov    %eax,0x8011374c
  if (i == log.lh.n)
80103029:	75 d5                	jne    80103000 <log_write+0x80>
8010302b:	eb ca                	jmp    80102ff7 <log_write+0x77>
8010302d:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80103030:	83 ec 0c             	sub    $0xc,%esp
80103033:	68 13 7b 10 80       	push   $0x80107b13
80103038:	e8 33 d3 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
8010303d:	83 ec 0c             	sub    $0xc,%esp
80103040:	68 29 7b 10 80       	push   $0x80107b29
80103045:	e8 26 d3 ff ff       	call   80100370 <panic>
8010304a:	66 90                	xchg   %ax,%ax
8010304c:	66 90                	xchg   %ax,%ax
8010304e:	66 90                	xchg   %ax,%ax

80103050 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103050:	55                   	push   %ebp
80103051:	89 e5                	mov    %esp,%ebp
80103053:	53                   	push   %ebx
80103054:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103057:	e8 54 09 00 00       	call   801039b0 <cpuid>
8010305c:	89 c3                	mov    %eax,%ebx
8010305e:	e8 4d 09 00 00       	call   801039b0 <cpuid>
80103063:	83 ec 04             	sub    $0x4,%esp
80103066:	53                   	push   %ebx
80103067:	50                   	push   %eax
80103068:	68 44 7b 10 80       	push   $0x80107b44
8010306d:	e8 ee d5 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103072:	e8 f9 2d 00 00       	call   80105e70 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103077:	e8 b4 08 00 00       	call   80103930 <mycpu>
8010307c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010307e:	b8 01 00 00 00       	mov    $0x1,%eax
80103083:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010308a:	e8 01 0c 00 00       	call   80103c90 <scheduler>
8010308f:	90                   	nop

80103090 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103090:	55                   	push   %ebp
80103091:	89 e5                	mov    %esp,%ebp
80103093:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103096:	e8 f5 3e 00 00       	call   80106f90 <switchkvm>
  seginit();
8010309b:	e8 f0 3d 00 00       	call   80106e90 <seginit>
  lapicinit();
801030a0:	e8 9b f7 ff ff       	call   80102840 <lapicinit>
  mpmain();
801030a5:	e8 a6 ff ff ff       	call   80103050 <mpmain>
801030aa:	66 90                	xchg   %ax,%ax
801030ac:	66 90                	xchg   %ax,%ax
801030ae:	66 90                	xchg   %ax,%ax

801030b0 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
801030b0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801030b4:	83 e4 f0             	and    $0xfffffff0,%esp
801030b7:	ff 71 fc             	pushl  -0x4(%ecx)
801030ba:	55                   	push   %ebp
801030bb:	89 e5                	mov    %esp,%ebp
801030bd:	53                   	push   %ebx
801030be:	51                   	push   %ecx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
801030bf:	bb 00 38 11 80       	mov    $0x80113800,%ebx
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801030c4:	83 ec 08             	sub    $0x8,%esp
801030c7:	68 00 00 40 80       	push   $0x80400000
801030cc:	68 48 66 11 80       	push   $0x80116648
801030d1:	e8 3a f5 ff ff       	call   80102610 <kinit1>
  kvmalloc();      // kernel page table
801030d6:	e8 55 43 00 00       	call   80107430 <kvmalloc>
  mpinit();        // detect other processors
801030db:	e8 70 01 00 00       	call   80103250 <mpinit>
  lapicinit();     // interrupt controller
801030e0:	e8 5b f7 ff ff       	call   80102840 <lapicinit>
  seginit();       // segment descriptors
801030e5:	e8 a6 3d 00 00       	call   80106e90 <seginit>
  picinit();       // disable pic
801030ea:	e8 31 03 00 00       	call   80103420 <picinit>
  ioapicinit();    // another interrupt controller
801030ef:	e8 4c f3 ff ff       	call   80102440 <ioapicinit>
  consoleinit();   // console hardware
801030f4:	e8 a7 d8 ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
801030f9:	e8 62 30 00 00       	call   80106160 <uartinit>
  pinit();         // process table
801030fe:	e8 0d 08 00 00       	call   80103910 <pinit>
  tvinit();        // trap vectors
80103103:	e8 c8 2c 00 00       	call   80105dd0 <tvinit>
  binit();         // buffer cache
80103108:	e8 33 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010310d:	e8 9e de ff ff       	call   80100fb0 <fileinit>
  ideinit();       // disk 
80103112:	e8 09 f1 ff ff       	call   80102220 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103117:	83 c4 0c             	add    $0xc,%esp
8010311a:	68 8a 00 00 00       	push   $0x8a
8010311f:	68 8c b4 10 80       	push   $0x8010b48c
80103124:	68 00 70 00 80       	push   $0x80007000
80103129:	e8 e2 18 00 00       	call   80104a10 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010312e:	69 05 80 3d 11 80 b0 	imul   $0xb0,0x80113d80,%eax
80103135:	00 00 00 
80103138:	83 c4 10             	add    $0x10,%esp
8010313b:	05 00 38 11 80       	add    $0x80113800,%eax
80103140:	39 d8                	cmp    %ebx,%eax
80103142:	76 6f                	jbe    801031b3 <main+0x103>
80103144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80103148:	e8 e3 07 00 00       	call   80103930 <mycpu>
8010314d:	39 d8                	cmp    %ebx,%eax
8010314f:	74 49                	je     8010319a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103151:	e8 8a f5 ff ff       	call   801026e0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80103156:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
8010315b:	c7 05 f8 6f 00 80 90 	movl   $0x80103090,0x80006ff8
80103162:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103165:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010316c:	a0 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
8010316f:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103174:	0f b6 03             	movzbl (%ebx),%eax
80103177:	83 ec 08             	sub    $0x8,%esp
8010317a:	68 00 70 00 00       	push   $0x7000
8010317f:	50                   	push   %eax
80103180:	e8 0b f8 ff ff       	call   80102990 <lapicstartap>
80103185:	83 c4 10             	add    $0x10,%esp
80103188:	90                   	nop
80103189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103190:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103196:	85 c0                	test   %eax,%eax
80103198:	74 f6                	je     80103190 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
8010319a:	69 05 80 3d 11 80 b0 	imul   $0xb0,0x80113d80,%eax
801031a1:	00 00 00 
801031a4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801031aa:	05 00 38 11 80       	add    $0x80113800,%eax
801031af:	39 c3                	cmp    %eax,%ebx
801031b1:	72 95                	jb     80103148 <main+0x98>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801031b3:	83 ec 08             	sub    $0x8,%esp
801031b6:	68 00 00 00 8e       	push   $0x8e000000
801031bb:	68 00 00 40 80       	push   $0x80400000
801031c0:	e8 bb f4 ff ff       	call   80102680 <kinit2>
  userinit();      // first user process
801031c5:	e8 36 08 00 00       	call   80103a00 <userinit>
  mpmain();        // finish this processor's setup
801031ca:	e8 81 fe ff ff       	call   80103050 <mpmain>
801031cf:	90                   	nop

801031d0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031d0:	55                   	push   %ebp
801031d1:	89 e5                	mov    %esp,%ebp
801031d3:	57                   	push   %edi
801031d4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801031d5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031db:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
801031dc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031df:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
801031e2:	39 de                	cmp    %ebx,%esi
801031e4:	73 48                	jae    8010322e <mpsearch1+0x5e>
801031e6:	8d 76 00             	lea    0x0(%esi),%esi
801031e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031f0:	83 ec 04             	sub    $0x4,%esp
801031f3:	8d 7e 10             	lea    0x10(%esi),%edi
801031f6:	6a 04                	push   $0x4
801031f8:	68 58 7b 10 80       	push   $0x80107b58
801031fd:	56                   	push   %esi
801031fe:	e8 ad 17 00 00       	call   801049b0 <memcmp>
80103203:	83 c4 10             	add    $0x10,%esp
80103206:	85 c0                	test   %eax,%eax
80103208:	75 1e                	jne    80103228 <mpsearch1+0x58>
8010320a:	8d 7e 10             	lea    0x10(%esi),%edi
8010320d:	89 f2                	mov    %esi,%edx
8010320f:	31 c9                	xor    %ecx,%ecx
80103211:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80103218:	0f b6 02             	movzbl (%edx),%eax
8010321b:	83 c2 01             	add    $0x1,%edx
8010321e:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103220:	39 fa                	cmp    %edi,%edx
80103222:	75 f4                	jne    80103218 <mpsearch1+0x48>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103224:	84 c9                	test   %cl,%cl
80103226:	74 10                	je     80103238 <mpsearch1+0x68>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103228:	39 fb                	cmp    %edi,%ebx
8010322a:	89 fe                	mov    %edi,%esi
8010322c:	77 c2                	ja     801031f0 <mpsearch1+0x20>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
8010322e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103231:	31 c0                	xor    %eax,%eax
}
80103233:	5b                   	pop    %ebx
80103234:	5e                   	pop    %esi
80103235:	5f                   	pop    %edi
80103236:	5d                   	pop    %ebp
80103237:	c3                   	ret    
80103238:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010323b:	89 f0                	mov    %esi,%eax
8010323d:	5b                   	pop    %ebx
8010323e:	5e                   	pop    %esi
8010323f:	5f                   	pop    %edi
80103240:	5d                   	pop    %ebp
80103241:	c3                   	ret    
80103242:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103250 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103250:	55                   	push   %ebp
80103251:	89 e5                	mov    %esp,%ebp
80103253:	57                   	push   %edi
80103254:	56                   	push   %esi
80103255:	53                   	push   %ebx
80103256:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103259:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103260:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103267:	c1 e0 08             	shl    $0x8,%eax
8010326a:	09 d0                	or     %edx,%eax
8010326c:	c1 e0 04             	shl    $0x4,%eax
8010326f:	85 c0                	test   %eax,%eax
80103271:	75 1b                	jne    8010328e <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
80103273:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010327a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103281:	c1 e0 08             	shl    $0x8,%eax
80103284:	09 d0                	or     %edx,%eax
80103286:	c1 e0 0a             	shl    $0xa,%eax
80103289:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
8010328e:	ba 00 04 00 00       	mov    $0x400,%edx
80103293:	e8 38 ff ff ff       	call   801031d0 <mpsearch1>
80103298:	85 c0                	test   %eax,%eax
8010329a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010329d:	0f 84 37 01 00 00    	je     801033da <mpinit+0x18a>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801032a6:	8b 58 04             	mov    0x4(%eax),%ebx
801032a9:	85 db                	test   %ebx,%ebx
801032ab:	0f 84 43 01 00 00    	je     801033f4 <mpinit+0x1a4>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032b1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801032b7:	83 ec 04             	sub    $0x4,%esp
801032ba:	6a 04                	push   $0x4
801032bc:	68 5d 7b 10 80       	push   $0x80107b5d
801032c1:	56                   	push   %esi
801032c2:	e8 e9 16 00 00       	call   801049b0 <memcmp>
801032c7:	83 c4 10             	add    $0x10,%esp
801032ca:	85 c0                	test   %eax,%eax
801032cc:	0f 85 22 01 00 00    	jne    801033f4 <mpinit+0x1a4>
    return 0;
  if(conf->version != 1 && conf->version != 4)
801032d2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801032d9:	3c 01                	cmp    $0x1,%al
801032db:	74 08                	je     801032e5 <mpinit+0x95>
801032dd:	3c 04                	cmp    $0x4,%al
801032df:	0f 85 0f 01 00 00    	jne    801033f4 <mpinit+0x1a4>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801032e5:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801032ec:	85 ff                	test   %edi,%edi
801032ee:	74 21                	je     80103311 <mpinit+0xc1>
801032f0:	31 d2                	xor    %edx,%edx
801032f2:	31 c0                	xor    %eax,%eax
801032f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801032f8:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
801032ff:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103300:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103303:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103305:	39 c7                	cmp    %eax,%edi
80103307:	75 ef                	jne    801032f8 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103309:	84 d2                	test   %dl,%dl
8010330b:	0f 85 e3 00 00 00    	jne    801033f4 <mpinit+0x1a4>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103311:	85 f6                	test   %esi,%esi
80103313:	0f 84 db 00 00 00    	je     801033f4 <mpinit+0x1a4>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103319:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010331f:	a3 fc 36 11 80       	mov    %eax,0x801136fc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103324:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
8010332b:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
80103331:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103336:	01 d6                	add    %edx,%esi
80103338:	90                   	nop
80103339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103340:	39 c6                	cmp    %eax,%esi
80103342:	76 23                	jbe    80103367 <mpinit+0x117>
80103344:	0f b6 10             	movzbl (%eax),%edx
    switch(*p){
80103347:	80 fa 04             	cmp    $0x4,%dl
8010334a:	0f 87 c0 00 00 00    	ja     80103410 <mpinit+0x1c0>
80103350:	ff 24 95 9c 7b 10 80 	jmp    *-0x7fef8464(,%edx,4)
80103357:	89 f6                	mov    %esi,%esi
80103359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103360:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103363:	39 c6                	cmp    %eax,%esi
80103365:	77 dd                	ja     80103344 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103367:	85 db                	test   %ebx,%ebx
80103369:	0f 84 92 00 00 00    	je     80103401 <mpinit+0x1b1>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010336f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103372:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103376:	74 15                	je     8010338d <mpinit+0x13d>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103378:	ba 22 00 00 00       	mov    $0x22,%edx
8010337d:	b8 70 00 00 00       	mov    $0x70,%eax
80103382:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103383:	ba 23 00 00 00       	mov    $0x23,%edx
80103388:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103389:	83 c8 01             	or     $0x1,%eax
8010338c:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
8010338d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103390:	5b                   	pop    %ebx
80103391:	5e                   	pop    %esi
80103392:	5f                   	pop    %edi
80103393:	5d                   	pop    %ebp
80103394:	c3                   	ret    
80103395:	8d 76 00             	lea    0x0(%esi),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80103398:	8b 0d 80 3d 11 80    	mov    0x80113d80,%ecx
8010339e:	83 f9 07             	cmp    $0x7,%ecx
801033a1:	7f 19                	jg     801033bc <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033a3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801033a7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801033ad:	83 c1 01             	add    $0x1,%ecx
801033b0:	89 0d 80 3d 11 80    	mov    %ecx,0x80113d80
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033b6:	88 97 00 38 11 80    	mov    %dl,-0x7feec800(%edi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
801033bc:	83 c0 14             	add    $0x14,%eax
      continue;
801033bf:	e9 7c ff ff ff       	jmp    80103340 <mpinit+0xf0>
801033c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801033c8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801033cc:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801033cf:	88 15 e0 37 11 80    	mov    %dl,0x801137e0
      p += sizeof(struct mpioapic);
      continue;
801033d5:	e9 66 ff ff ff       	jmp    80103340 <mpinit+0xf0>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
801033da:	ba 00 00 01 00       	mov    $0x10000,%edx
801033df:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801033e4:	e8 e7 fd ff ff       	call   801031d0 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033e9:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
801033eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033ee:	0f 85 af fe ff ff    	jne    801032a3 <mpinit+0x53>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
801033f4:	83 ec 0c             	sub    $0xc,%esp
801033f7:	68 62 7b 10 80       	push   $0x80107b62
801033fc:	e8 6f cf ff ff       	call   80100370 <panic>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
80103401:	83 ec 0c             	sub    $0xc,%esp
80103404:	68 7c 7b 10 80       	push   $0x80107b7c
80103409:	e8 62 cf ff ff       	call   80100370 <panic>
8010340e:	66 90                	xchg   %ax,%ax
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80103410:	31 db                	xor    %ebx,%ebx
80103412:	e9 30 ff ff ff       	jmp    80103347 <mpinit+0xf7>
80103417:	66 90                	xchg   %ax,%ax
80103419:	66 90                	xchg   %ax,%ax
8010341b:	66 90                	xchg   %ax,%ax
8010341d:	66 90                	xchg   %ax,%ax
8010341f:	90                   	nop

80103420 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103420:	55                   	push   %ebp
80103421:	ba 21 00 00 00       	mov    $0x21,%edx
80103426:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010342b:	89 e5                	mov    %esp,%ebp
8010342d:	ee                   	out    %al,(%dx)
8010342e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103433:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103434:	5d                   	pop    %ebp
80103435:	c3                   	ret    
80103436:	66 90                	xchg   %ax,%ax
80103438:	66 90                	xchg   %ax,%ax
8010343a:	66 90                	xchg   %ax,%ax
8010343c:	66 90                	xchg   %ax,%ax
8010343e:	66 90                	xchg   %ax,%ax

80103440 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103440:	55                   	push   %ebp
80103441:	89 e5                	mov    %esp,%ebp
80103443:	57                   	push   %edi
80103444:	56                   	push   %esi
80103445:	53                   	push   %ebx
80103446:	83 ec 0c             	sub    $0xc,%esp
80103449:	8b 75 08             	mov    0x8(%ebp),%esi
8010344c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010344f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103455:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010345b:	e8 70 db ff ff       	call   80100fd0 <filealloc>
80103460:	85 c0                	test   %eax,%eax
80103462:	89 06                	mov    %eax,(%esi)
80103464:	0f 84 a8 00 00 00    	je     80103512 <pipealloc+0xd2>
8010346a:	e8 61 db ff ff       	call   80100fd0 <filealloc>
8010346f:	85 c0                	test   %eax,%eax
80103471:	89 03                	mov    %eax,(%ebx)
80103473:	0f 84 87 00 00 00    	je     80103500 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103479:	e8 62 f2 ff ff       	call   801026e0 <kalloc>
8010347e:	85 c0                	test   %eax,%eax
80103480:	89 c7                	mov    %eax,%edi
80103482:	0f 84 b0 00 00 00    	je     80103538 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103488:	83 ec 08             	sub    $0x8,%esp
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
  p->readopen = 1;
8010348b:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103492:	00 00 00 
  p->writeopen = 1;
80103495:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010349c:	00 00 00 
  p->nwrite = 0;
8010349f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801034a6:	00 00 00 
  p->nread = 0;
801034a9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034b0:	00 00 00 
  initlock(&p->lock, "pipe");
801034b3:	68 b0 7b 10 80       	push   $0x80107bb0
801034b8:	50                   	push   %eax
801034b9:	e8 42 12 00 00       	call   80104700 <initlock>
  (*f0)->type = FD_PIPE;
801034be:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801034c0:	83 c4 10             	add    $0x10,%esp
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
801034c3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034c9:	8b 06                	mov    (%esi),%eax
801034cb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034cf:	8b 06                	mov    (%esi),%eax
801034d1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034d5:	8b 06                	mov    (%esi),%eax
801034d7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034da:	8b 03                	mov    (%ebx),%eax
801034dc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034e2:	8b 03                	mov    (%ebx),%eax
801034e4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034e8:	8b 03                	mov    (%ebx),%eax
801034ea:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034ee:	8b 03                	mov    (%ebx),%eax
801034f0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801034f6:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034f8:	5b                   	pop    %ebx
801034f9:	5e                   	pop    %esi
801034fa:	5f                   	pop    %edi
801034fb:	5d                   	pop    %ebp
801034fc:	c3                   	ret    
801034fd:	8d 76 00             	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103500:	8b 06                	mov    (%esi),%eax
80103502:	85 c0                	test   %eax,%eax
80103504:	74 1e                	je     80103524 <pipealloc+0xe4>
    fileclose(*f0);
80103506:	83 ec 0c             	sub    $0xc,%esp
80103509:	50                   	push   %eax
8010350a:	e8 81 db ff ff       	call   80101090 <fileclose>
8010350f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103512:	8b 03                	mov    (%ebx),%eax
80103514:	85 c0                	test   %eax,%eax
80103516:	74 0c                	je     80103524 <pipealloc+0xe4>
    fileclose(*f1);
80103518:	83 ec 0c             	sub    $0xc,%esp
8010351b:	50                   	push   %eax
8010351c:	e8 6f db ff ff       	call   80101090 <fileclose>
80103521:	83 c4 10             	add    $0x10,%esp
  return -1;
}
80103524:	8d 65 f4             	lea    -0xc(%ebp),%esp
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
80103527:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010352c:	5b                   	pop    %ebx
8010352d:	5e                   	pop    %esi
8010352e:	5f                   	pop    %edi
8010352f:	5d                   	pop    %ebp
80103530:	c3                   	ret    
80103531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103538:	8b 06                	mov    (%esi),%eax
8010353a:	85 c0                	test   %eax,%eax
8010353c:	75 c8                	jne    80103506 <pipealloc+0xc6>
8010353e:	eb d2                	jmp    80103512 <pipealloc+0xd2>

80103540 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
80103540:	55                   	push   %ebp
80103541:	89 e5                	mov    %esp,%ebp
80103543:	56                   	push   %esi
80103544:	53                   	push   %ebx
80103545:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103548:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010354b:	83 ec 0c             	sub    $0xc,%esp
8010354e:	53                   	push   %ebx
8010354f:	e8 0c 13 00 00       	call   80104860 <acquire>
  if(writable){
80103554:	83 c4 10             	add    $0x10,%esp
80103557:	85 f6                	test   %esi,%esi
80103559:	74 45                	je     801035a0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010355b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103561:	83 ec 0c             	sub    $0xc,%esp
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
80103564:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010356b:	00 00 00 
    wakeup(&p->nread);
8010356e:	50                   	push   %eax
8010356f:	e8 bc 0b 00 00       	call   80104130 <wakeup>
80103574:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103577:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010357d:	85 d2                	test   %edx,%edx
8010357f:	75 0a                	jne    8010358b <pipeclose+0x4b>
80103581:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103587:	85 c0                	test   %eax,%eax
80103589:	74 35                	je     801035c0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010358b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010358e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103591:	5b                   	pop    %ebx
80103592:	5e                   	pop    %esi
80103593:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103594:	e9 77 13 00 00       	jmp    80104910 <release>
80103599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
801035a0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801035a6:	83 ec 0c             	sub    $0xc,%esp
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
801035a9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035b0:	00 00 00 
    wakeup(&p->nwrite);
801035b3:	50                   	push   %eax
801035b4:	e8 77 0b 00 00       	call   80104130 <wakeup>
801035b9:	83 c4 10             	add    $0x10,%esp
801035bc:	eb b9                	jmp    80103577 <pipeclose+0x37>
801035be:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
801035c0:	83 ec 0c             	sub    $0xc,%esp
801035c3:	53                   	push   %ebx
801035c4:	e8 47 13 00 00       	call   80104910 <release>
    kfree((char*)p);
801035c9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801035cc:	83 c4 10             	add    $0x10,%esp
  } else
    release(&p->lock);
}
801035cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035d2:	5b                   	pop    %ebx
801035d3:	5e                   	pop    %esi
801035d4:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
801035d5:	e9 56 ef ff ff       	jmp    80102530 <kfree>
801035da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801035e0 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035e0:	55                   	push   %ebp
801035e1:	89 e5                	mov    %esp,%ebp
801035e3:	57                   	push   %edi
801035e4:	56                   	push   %esi
801035e5:	53                   	push   %ebx
801035e6:	83 ec 28             	sub    $0x28,%esp
801035e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035ec:	53                   	push   %ebx
801035ed:	e8 6e 12 00 00       	call   80104860 <acquire>
  for(i = 0; i < n; i++){
801035f2:	8b 45 10             	mov    0x10(%ebp),%eax
801035f5:	83 c4 10             	add    $0x10,%esp
801035f8:	85 c0                	test   %eax,%eax
801035fa:	0f 8e b9 00 00 00    	jle    801036b9 <pipewrite+0xd9>
80103600:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103603:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103609:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010360f:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103615:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103618:	03 4d 10             	add    0x10(%ebp),%ecx
8010361b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010361e:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103624:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
8010362a:	39 d0                	cmp    %edx,%eax
8010362c:	74 38                	je     80103666 <pipewrite+0x86>
8010362e:	eb 59                	jmp    80103689 <pipewrite+0xa9>
      if(p->readopen == 0 || myproc()->killed){
80103630:	e8 9b 03 00 00       	call   801039d0 <myproc>
80103635:	8b 48 24             	mov    0x24(%eax),%ecx
80103638:	85 c9                	test   %ecx,%ecx
8010363a:	75 34                	jne    80103670 <pipewrite+0x90>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010363c:	83 ec 0c             	sub    $0xc,%esp
8010363f:	57                   	push   %edi
80103640:	e8 eb 0a 00 00       	call   80104130 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103645:	58                   	pop    %eax
80103646:	5a                   	pop    %edx
80103647:	53                   	push   %ebx
80103648:	56                   	push   %esi
80103649:	e8 32 09 00 00       	call   80103f80 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010364e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103654:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010365a:	83 c4 10             	add    $0x10,%esp
8010365d:	05 00 02 00 00       	add    $0x200,%eax
80103662:	39 c2                	cmp    %eax,%edx
80103664:	75 2a                	jne    80103690 <pipewrite+0xb0>
      if(p->readopen == 0 || myproc()->killed){
80103666:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010366c:	85 c0                	test   %eax,%eax
8010366e:	75 c0                	jne    80103630 <pipewrite+0x50>
        release(&p->lock);
80103670:	83 ec 0c             	sub    $0xc,%esp
80103673:	53                   	push   %ebx
80103674:	e8 97 12 00 00       	call   80104910 <release>
        return -1;
80103679:	83 c4 10             	add    $0x10,%esp
8010367c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103681:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103684:	5b                   	pop    %ebx
80103685:	5e                   	pop    %esi
80103686:	5f                   	pop    %edi
80103687:	5d                   	pop    %ebp
80103688:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103689:	89 c2                	mov    %eax,%edx
8010368b:	90                   	nop
8010368c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103690:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103693:	8d 42 01             	lea    0x1(%edx),%eax
80103696:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010369a:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801036a0:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801036a6:	0f b6 09             	movzbl (%ecx),%ecx
801036a9:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
801036ad:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801036b0:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
801036b3:	0f 85 65 ff ff ff    	jne    8010361e <pipewrite+0x3e>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036b9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036bf:	83 ec 0c             	sub    $0xc,%esp
801036c2:	50                   	push   %eax
801036c3:	e8 68 0a 00 00       	call   80104130 <wakeup>
  release(&p->lock);
801036c8:	89 1c 24             	mov    %ebx,(%esp)
801036cb:	e8 40 12 00 00       	call   80104910 <release>
  return n;
801036d0:	83 c4 10             	add    $0x10,%esp
801036d3:	8b 45 10             	mov    0x10(%ebp),%eax
801036d6:	eb a9                	jmp    80103681 <pipewrite+0xa1>
801036d8:	90                   	nop
801036d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801036e0 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
801036e0:	55                   	push   %ebp
801036e1:	89 e5                	mov    %esp,%ebp
801036e3:	57                   	push   %edi
801036e4:	56                   	push   %esi
801036e5:	53                   	push   %ebx
801036e6:	83 ec 18             	sub    $0x18,%esp
801036e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801036ec:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036ef:	53                   	push   %ebx
801036f0:	e8 6b 11 00 00       	call   80104860 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036f5:	83 c4 10             	add    $0x10,%esp
801036f8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801036fe:	39 83 38 02 00 00    	cmp    %eax,0x238(%ebx)
80103704:	75 6a                	jne    80103770 <piperead+0x90>
80103706:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
8010370c:	85 f6                	test   %esi,%esi
8010370e:	0f 84 cc 00 00 00    	je     801037e0 <piperead+0x100>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103714:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
8010371a:	eb 2d                	jmp    80103749 <piperead+0x69>
8010371c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103720:	83 ec 08             	sub    $0x8,%esp
80103723:	53                   	push   %ebx
80103724:	56                   	push   %esi
80103725:	e8 56 08 00 00       	call   80103f80 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010372a:	83 c4 10             	add    $0x10,%esp
8010372d:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103733:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80103739:	75 35                	jne    80103770 <piperead+0x90>
8010373b:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
80103741:	85 d2                	test   %edx,%edx
80103743:	0f 84 97 00 00 00    	je     801037e0 <piperead+0x100>
    if(myproc()->killed){
80103749:	e8 82 02 00 00       	call   801039d0 <myproc>
8010374e:	8b 48 24             	mov    0x24(%eax),%ecx
80103751:	85 c9                	test   %ecx,%ecx
80103753:	74 cb                	je     80103720 <piperead+0x40>
      release(&p->lock);
80103755:	83 ec 0c             	sub    $0xc,%esp
80103758:	53                   	push   %ebx
80103759:	e8 b2 11 00 00       	call   80104910 <release>
      return -1;
8010375e:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103761:	8d 65 f4             	lea    -0xc(%ebp),%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
80103764:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103769:	5b                   	pop    %ebx
8010376a:	5e                   	pop    %esi
8010376b:	5f                   	pop    %edi
8010376c:	5d                   	pop    %ebp
8010376d:	c3                   	ret    
8010376e:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103770:	8b 45 10             	mov    0x10(%ebp),%eax
80103773:	85 c0                	test   %eax,%eax
80103775:	7e 69                	jle    801037e0 <piperead+0x100>
    if(p->nread == p->nwrite)
80103777:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010377d:	31 c9                	xor    %ecx,%ecx
8010377f:	eb 15                	jmp    80103796 <piperead+0xb6>
80103781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103788:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010378e:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
80103794:	74 5a                	je     801037f0 <piperead+0x110>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103796:	8d 70 01             	lea    0x1(%eax),%esi
80103799:	25 ff 01 00 00       	and    $0x1ff,%eax
8010379e:	89 b3 34 02 00 00    	mov    %esi,0x234(%ebx)
801037a4:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
801037a9:	88 04 0f             	mov    %al,(%edi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037ac:	83 c1 01             	add    $0x1,%ecx
801037af:	39 4d 10             	cmp    %ecx,0x10(%ebp)
801037b2:	75 d4                	jne    80103788 <piperead+0xa8>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801037b4:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801037ba:	83 ec 0c             	sub    $0xc,%esp
801037bd:	50                   	push   %eax
801037be:	e8 6d 09 00 00       	call   80104130 <wakeup>
  release(&p->lock);
801037c3:	89 1c 24             	mov    %ebx,(%esp)
801037c6:	e8 45 11 00 00       	call   80104910 <release>
  return i;
801037cb:	8b 45 10             	mov    0x10(%ebp),%eax
801037ce:	83 c4 10             	add    $0x10,%esp
}
801037d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037d4:	5b                   	pop    %ebx
801037d5:	5e                   	pop    %esi
801037d6:	5f                   	pop    %edi
801037d7:	5d                   	pop    %ebp
801037d8:	c3                   	ret    
801037d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037e0:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
801037e7:	eb cb                	jmp    801037b4 <piperead+0xd4>
801037e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037f0:	89 4d 10             	mov    %ecx,0x10(%ebp)
801037f3:	eb bf                	jmp    801037b4 <piperead+0xd4>
801037f5:	66 90                	xchg   %ax,%ax
801037f7:	66 90                	xchg   %ax,%ax
801037f9:	66 90                	xchg   %ax,%ax
801037fb:	66 90                	xchg   %ax,%ax
801037fd:	66 90                	xchg   %ax,%ax
801037ff:	90                   	nop

80103800 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103800:	55                   	push   %ebp
80103801:	89 e5                	mov    %esp,%ebp
80103803:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103804:	bb f4 3d 11 80       	mov    $0x80113df4,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103809:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010380c:	68 c0 3d 11 80       	push   $0x80113dc0
80103811:	e8 4a 10 00 00       	call   80104860 <acquire>
80103816:	83 c4 10             	add    $0x10,%esp
80103819:	eb 10                	jmp    8010382b <allocproc+0x2b>
8010381b:	90                   	nop
8010381c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103820:	83 eb 80             	sub    $0xffffff80,%ebx
80103823:	81 fb f4 5d 11 80    	cmp    $0x80115df4,%ebx
80103829:	74 75                	je     801038a0 <allocproc+0xa0>
    if(p->state == UNUSED)
8010382b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010382e:	85 c0                	test   %eax,%eax
80103830:	75 ee                	jne    80103820 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103832:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103837:	83 ec 0c             	sub    $0xc,%esp

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
8010383a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;

  release(&ptable.lock);
80103841:	68 c0 3d 11 80       	push   $0x80113dc0
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103846:	8d 50 01             	lea    0x1(%eax),%edx
80103849:	89 43 10             	mov    %eax,0x10(%ebx)
8010384c:	89 15 04 b0 10 80    	mov    %edx,0x8010b004

  release(&ptable.lock);
80103852:	e8 b9 10 00 00       	call   80104910 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103857:	e8 84 ee ff ff       	call   801026e0 <kalloc>
8010385c:	83 c4 10             	add    $0x10,%esp
8010385f:	85 c0                	test   %eax,%eax
80103861:	89 43 08             	mov    %eax,0x8(%ebx)
80103864:	74 51                	je     801038b7 <allocproc+0xb7>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103866:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010386c:	83 ec 04             	sub    $0x4,%esp
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
8010386f:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103874:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
80103877:	c7 40 14 c3 5d 10 80 	movl   $0x80105dc3,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010387e:	6a 14                	push   $0x14
80103880:	6a 00                	push   $0x0
80103882:	50                   	push   %eax
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
80103883:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103886:	e8 d5 10 00 00       	call   80104960 <memset>
  p->context->eip = (uint)forkret;
8010388b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010388e:	83 c4 10             	add    $0x10,%esp
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
80103891:	c7 40 10 c0 38 10 80 	movl   $0x801038c0,0x10(%eax)

  return p;
80103898:	89 d8                	mov    %ebx,%eax
}
8010389a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010389d:	c9                   	leave  
8010389e:	c3                   	ret    
8010389f:	90                   	nop

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
801038a0:	83 ec 0c             	sub    $0xc,%esp
801038a3:	68 c0 3d 11 80       	push   $0x80113dc0
801038a8:	e8 63 10 00 00       	call   80104910 <release>
  return 0;
801038ad:	83 c4 10             	add    $0x10,%esp
801038b0:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
801038b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038b5:	c9                   	leave  
801038b6:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
801038b7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801038be:	eb da                	jmp    8010389a <allocproc+0x9a>

801038c0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801038c0:	55                   	push   %ebp
801038c1:	89 e5                	mov    %esp,%ebp
801038c3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038c6:	68 c0 3d 11 80       	push   $0x80113dc0
801038cb:	e8 40 10 00 00       	call   80104910 <release>

  if (first) {
801038d0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801038d5:	83 c4 10             	add    $0x10,%esp
801038d8:	85 c0                	test   %eax,%eax
801038da:	75 04                	jne    801038e0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038dc:	c9                   	leave  
801038dd:	c3                   	ret    
801038de:	66 90                	xchg   %ax,%ax
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
801038e0:	83 ec 0c             	sub    $0xc,%esp

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
801038e3:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801038ea:	00 00 00 
    iinit(ROOTDEV);
801038ed:	6a 01                	push   $0x1
801038ef:	e8 cc dd ff ff       	call   801016c0 <iinit>
    initlog(ROOTDEV);
801038f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038fb:	e8 00 f4 ff ff       	call   80102d00 <initlog>
80103900:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103903:	c9                   	leave  
80103904:	c3                   	ret    
80103905:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103910 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103910:	55                   	push   %ebp
80103911:	89 e5                	mov    %esp,%ebp
80103913:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103916:	68 b5 7b 10 80       	push   $0x80107bb5
8010391b:	68 c0 3d 11 80       	push   $0x80113dc0
80103920:	e8 db 0d 00 00       	call   80104700 <initlock>
}
80103925:	83 c4 10             	add    $0x10,%esp
80103928:	c9                   	leave  
80103929:	c3                   	ret    
8010392a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103930 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80103930:	55                   	push   %ebp
80103931:	89 e5                	mov    %esp,%ebp
80103933:	56                   	push   %esi
80103934:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103935:	9c                   	pushf  
80103936:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
80103937:	f6 c4 02             	test   $0x2,%ah
8010393a:	75 5b                	jne    80103997 <mycpu+0x67>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
8010393c:	e8 ff ef ff ff       	call   80102940 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103941:	8b 35 80 3d 11 80    	mov    0x80113d80,%esi
80103947:	85 f6                	test   %esi,%esi
80103949:	7e 3f                	jle    8010398a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
8010394b:	0f b6 15 00 38 11 80 	movzbl 0x80113800,%edx
80103952:	39 d0                	cmp    %edx,%eax
80103954:	74 30                	je     80103986 <mycpu+0x56>
80103956:	b9 b0 38 11 80       	mov    $0x801138b0,%ecx
8010395b:	31 d2                	xor    %edx,%edx
8010395d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103960:	83 c2 01             	add    $0x1,%edx
80103963:	39 f2                	cmp    %esi,%edx
80103965:	74 23                	je     8010398a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103967:	0f b6 19             	movzbl (%ecx),%ebx
8010396a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103970:	39 d8                	cmp    %ebx,%eax
80103972:	75 ec                	jne    80103960 <mycpu+0x30>
      return &cpus[i];
80103974:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
  }
  panic("unknown apicid\n");
}
8010397a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010397d:	5b                   	pop    %ebx
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
8010397e:	05 00 38 11 80       	add    $0x80113800,%eax
  }
  panic("unknown apicid\n");
}
80103983:	5e                   	pop    %esi
80103984:	5d                   	pop    %ebp
80103985:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103986:	31 d2                	xor    %edx,%edx
80103988:	eb ea                	jmp    80103974 <mycpu+0x44>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
8010398a:	83 ec 0c             	sub    $0xc,%esp
8010398d:	68 bc 7b 10 80       	push   $0x80107bbc
80103992:	e8 d9 c9 ff ff       	call   80100370 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
80103997:	83 ec 0c             	sub    $0xc,%esp
8010399a:	68 b4 7c 10 80       	push   $0x80107cb4
8010399f:	e8 cc c9 ff ff       	call   80100370 <panic>
801039a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801039aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801039b0 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801039b6:	e8 75 ff ff ff       	call   80103930 <mycpu>
801039bb:	2d 00 38 11 80       	sub    $0x80113800,%eax
}
801039c0:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
801039c1:	c1 f8 04             	sar    $0x4,%eax
801039c4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801039ca:	c3                   	ret    
801039cb:	90                   	nop
801039cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801039d0 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
801039d0:	55                   	push   %ebp
801039d1:	89 e5                	mov    %esp,%ebp
801039d3:	53                   	push   %ebx
801039d4:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
801039d7:	e8 a4 0d 00 00       	call   80104780 <pushcli>
  c = mycpu();
801039dc:	e8 4f ff ff ff       	call   80103930 <mycpu>
  p = c->proc;
801039e1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039e7:	e8 d4 0d 00 00       	call   801047c0 <popcli>
  return p;
}
801039ec:	83 c4 04             	add    $0x4,%esp
801039ef:	89 d8                	mov    %ebx,%eax
801039f1:	5b                   	pop    %ebx
801039f2:	5d                   	pop    %ebp
801039f3:	c3                   	ret    
801039f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801039fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103a00 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103a00:	55                   	push   %ebp
80103a01:	89 e5                	mov    %esp,%ebp
80103a03:	53                   	push   %ebx
80103a04:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103a07:	e8 f4 fd ff ff       	call   80103800 <allocproc>
80103a0c:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
80103a0e:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103a13:	e8 98 39 00 00       	call   801073b0 <setupkvm>
80103a18:	85 c0                	test   %eax,%eax
80103a1a:	89 43 04             	mov    %eax,0x4(%ebx)
80103a1d:	0f 84 bd 00 00 00    	je     80103ae0 <userinit+0xe0>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a23:	83 ec 04             	sub    $0x4,%esp
80103a26:	68 2c 00 00 00       	push   $0x2c
80103a2b:	68 60 b4 10 80       	push   $0x8010b460
80103a30:	50                   	push   %eax
80103a31:	e8 8a 36 00 00       	call   801070c0 <inituvm>
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
80103a36:	83 c4 0c             	add    $0xc,%esp
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
80103a39:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a3f:	6a 4c                	push   $0x4c
80103a41:	6a 00                	push   $0x0
80103a43:	ff 73 18             	pushl  0x18(%ebx)
80103a46:	e8 15 0f 00 00       	call   80104960 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a4b:	8b 43 18             	mov    0x18(%ebx),%eax
80103a4e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a53:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a58:	83 c4 0c             	add    $0xc,%esp
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a5b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a5f:	8b 43 18             	mov    0x18(%ebx),%eax
80103a62:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a66:	8b 43 18             	mov    0x18(%ebx),%eax
80103a69:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a6d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a71:	8b 43 18             	mov    0x18(%ebx),%eax
80103a74:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a78:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a7c:	8b 43 18             	mov    0x18(%ebx),%eax
80103a7f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a86:	8b 43 18             	mov    0x18(%ebx),%eax
80103a89:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a90:	8b 43 18             	mov    0x18(%ebx),%eax
80103a93:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a9a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a9d:	6a 10                	push   $0x10
80103a9f:	68 e5 7b 10 80       	push   $0x80107be5
80103aa4:	50                   	push   %eax
80103aa5:	e8 b6 10 00 00       	call   80104b60 <safestrcpy>
  p->cwd = namei("/");
80103aaa:	c7 04 24 ee 7b 10 80 	movl   $0x80107bee,(%esp)
80103ab1:	e8 5a e6 ff ff       	call   80102110 <namei>
80103ab6:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103ab9:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80103ac0:	e8 9b 0d 00 00       	call   80104860 <acquire>

  p->state = RUNNABLE;
80103ac5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
80103acc:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80103ad3:	e8 38 0e 00 00       	call   80104910 <release>
}
80103ad8:	83 c4 10             	add    $0x10,%esp
80103adb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ade:	c9                   	leave  
80103adf:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
80103ae0:	83 ec 0c             	sub    $0xc,%esp
80103ae3:	68 cc 7b 10 80       	push   $0x80107bcc
80103ae8:	e8 83 c8 ff ff       	call   80100370 <panic>
80103aed:	8d 76 00             	lea    0x0(%esi),%esi

80103af0 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103af0:	55                   	push   %ebp
80103af1:	89 e5                	mov    %esp,%ebp
80103af3:	56                   	push   %esi
80103af4:	53                   	push   %ebx
80103af5:	8b 75 08             	mov    0x8(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103af8:	e8 83 0c 00 00       	call   80104780 <pushcli>
  c = mycpu();
80103afd:	e8 2e fe ff ff       	call   80103930 <mycpu>
  p = c->proc;
80103b02:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b08:	e8 b3 0c 00 00       	call   801047c0 <popcli>
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
80103b0d:	83 fe 00             	cmp    $0x0,%esi
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
80103b10:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103b12:	7e 34                	jle    80103b48 <growproc+0x58>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b14:	83 ec 04             	sub    $0x4,%esp
80103b17:	01 c6                	add    %eax,%esi
80103b19:	56                   	push   %esi
80103b1a:	50                   	push   %eax
80103b1b:	ff 73 04             	pushl  0x4(%ebx)
80103b1e:	e8 dd 36 00 00       	call   80107200 <allocuvm>
80103b23:	83 c4 10             	add    $0x10,%esp
80103b26:	85 c0                	test   %eax,%eax
80103b28:	74 36                	je     80103b60 <growproc+0x70>
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
80103b2a:	83 ec 0c             	sub    $0xc,%esp
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
80103b2d:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103b2f:	53                   	push   %ebx
80103b30:	e8 7b 34 00 00       	call   80106fb0 <switchuvm>
  return 0;
80103b35:	83 c4 10             	add    $0x10,%esp
80103b38:	31 c0                	xor    %eax,%eax
}
80103b3a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b3d:	5b                   	pop    %ebx
80103b3e:	5e                   	pop    %esi
80103b3f:	5d                   	pop    %ebp
80103b40:	c3                   	ret    
80103b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
80103b48:	74 e0                	je     80103b2a <growproc+0x3a>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b4a:	83 ec 04             	sub    $0x4,%esp
80103b4d:	01 c6                	add    %eax,%esi
80103b4f:	56                   	push   %esi
80103b50:	50                   	push   %eax
80103b51:	ff 73 04             	pushl  0x4(%ebx)
80103b54:	e8 a7 37 00 00       	call   80107300 <deallocuvm>
80103b59:	83 c4 10             	add    $0x10,%esp
80103b5c:	85 c0                	test   %eax,%eax
80103b5e:	75 ca                	jne    80103b2a <growproc+0x3a>
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
80103b60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b65:	eb d3                	jmp    80103b3a <growproc+0x4a>
80103b67:	89 f6                	mov    %esi,%esi
80103b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b70 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103b70:	55                   	push   %ebp
80103b71:	89 e5                	mov    %esp,%ebp
80103b73:	57                   	push   %edi
80103b74:	56                   	push   %esi
80103b75:	53                   	push   %ebx
80103b76:	83 ec 1c             	sub    $0x1c,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103b79:	e8 02 0c 00 00       	call   80104780 <pushcli>
  c = mycpu();
80103b7e:	e8 ad fd ff ff       	call   80103930 <mycpu>
  p = c->proc;
80103b83:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b89:	e8 32 0c 00 00       	call   801047c0 <popcli>
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
80103b8e:	e8 6d fc ff ff       	call   80103800 <allocproc>
80103b93:	85 c0                	test   %eax,%eax
80103b95:	89 c7                	mov    %eax,%edi
80103b97:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b9a:	0f 84 b5 00 00 00    	je     80103c55 <fork+0xe5>
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103ba0:	83 ec 08             	sub    $0x8,%esp
80103ba3:	ff 33                	pushl  (%ebx)
80103ba5:	ff 73 04             	pushl  0x4(%ebx)
80103ba8:	e8 d3 38 00 00       	call   80107480 <copyuvm>
80103bad:	83 c4 10             	add    $0x10,%esp
80103bb0:	85 c0                	test   %eax,%eax
80103bb2:	89 47 04             	mov    %eax,0x4(%edi)
80103bb5:	0f 84 a1 00 00 00    	je     80103c5c <fork+0xec>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
80103bbb:	8b 03                	mov    (%ebx),%eax
80103bbd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103bc0:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103bc2:	89 59 14             	mov    %ebx,0x14(%ecx)

  *np->tf = *curproc->tf;
80103bc5:	89 c8                	mov    %ecx,%eax
80103bc7:	8b 79 18             	mov    0x18(%ecx),%edi
80103bca:	8b 73 18             	mov    0x18(%ebx),%esi
80103bcd:	b9 13 00 00 00       	mov    $0x13,%ecx
80103bd2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103bd4:	31 f6                	xor    %esi,%esi
  np->parent = curproc;

  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103bd6:	8b 40 18             	mov    0x18(%eax),%eax
80103bd9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
80103be0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103be4:	85 c0                	test   %eax,%eax
80103be6:	74 13                	je     80103bfb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103be8:	83 ec 0c             	sub    $0xc,%esp
80103beb:	50                   	push   %eax
80103bec:	e8 4f d4 ff ff       	call   80101040 <filedup>
80103bf1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103bf4:	83 c4 10             	add    $0x10,%esp
80103bf7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103bfb:	83 c6 01             	add    $0x1,%esi
80103bfe:	83 fe 10             	cmp    $0x10,%esi
80103c01:	75 dd                	jne    80103be0 <fork+0x70>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103c03:	83 ec 0c             	sub    $0xc,%esp
80103c06:	ff 73 68             	pushl  0x68(%ebx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c09:	83 c3 6c             	add    $0x6c,%ebx
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103c0c:	e8 7f dc ff ff       	call   80101890 <idup>
80103c11:	8b 7d e4             	mov    -0x1c(%ebp),%edi

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c14:	83 c4 0c             	add    $0xc,%esp
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103c17:	89 47 68             	mov    %eax,0x68(%edi)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c1a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103c1d:	6a 10                	push   $0x10
80103c1f:	53                   	push   %ebx
80103c20:	50                   	push   %eax
80103c21:	e8 3a 0f 00 00       	call   80104b60 <safestrcpy>

  pid = np->pid;
80103c26:	8b 5f 10             	mov    0x10(%edi),%ebx

  acquire(&ptable.lock);
80103c29:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80103c30:	e8 2b 0c 00 00       	call   80104860 <acquire>


  np->state = RUNNABLE;
80103c35:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)

  release(&ptable.lock);
80103c3c:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80103c43:	e8 c8 0c 00 00       	call   80104910 <release>

  return pid;
80103c48:	83 c4 10             	add    $0x10,%esp
80103c4b:	89 d8                	mov    %ebx,%eax
}
80103c4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c50:	5b                   	pop    %ebx
80103c51:	5e                   	pop    %esi
80103c52:	5f                   	pop    %edi
80103c53:	5d                   	pop    %ebp
80103c54:	c3                   	ret    
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103c55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c5a:	eb f1                	jmp    80103c4d <fork+0xdd>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
80103c5c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103c5f:	83 ec 0c             	sub    $0xc,%esp
80103c62:	ff 77 08             	pushl  0x8(%edi)
80103c65:	e8 c6 e8 ff ff       	call   80102530 <kfree>
    np->kstack = 0;
80103c6a:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
80103c71:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103c78:	83 c4 10             	add    $0x10,%esp
80103c7b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c80:	eb cb                	jmp    80103c4d <fork+0xdd>
80103c82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c90 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103c90:	55                   	push   %ebp
80103c91:	89 e5                	mov    %esp,%ebp
80103c93:	57                   	push   %edi
80103c94:	56                   	push   %esi
80103c95:	53                   	push   %ebx
80103c96:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80103c99:	e8 92 fc ff ff       	call   80103930 <mycpu>
80103c9e:	8d 78 04             	lea    0x4(%eax),%edi
80103ca1:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103ca3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103caa:	00 00 00 
80103cad:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103cb0:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103cb1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cb4:	bb f4 3d 11 80       	mov    $0x80113df4,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103cb9:	68 c0 3d 11 80       	push   $0x80113dc0
80103cbe:	e8 9d 0b 00 00       	call   80104860 <acquire>
80103cc3:	83 c4 10             	add    $0x10,%esp
80103cc6:	eb 13                	jmp    80103cdb <scheduler+0x4b>
80103cc8:	90                   	nop
80103cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cd0:	83 eb 80             	sub    $0xffffff80,%ebx
80103cd3:	81 fb f4 5d 11 80    	cmp    $0x80115df4,%ebx
80103cd9:	74 45                	je     80103d20 <scheduler+0x90>
      if(p->state != RUNNABLE)
80103cdb:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103cdf:	75 ef                	jne    80103cd0 <scheduler+0x40>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103ce1:	83 ec 0c             	sub    $0xc,%esp
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80103ce4:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103cea:	53                   	push   %ebx
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ceb:	83 eb 80             	sub    $0xffffff80,%ebx

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103cee:	e8 bd 32 00 00       	call   80106fb0 <switchuvm>
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
80103cf3:	58                   	pop    %eax
80103cf4:	5a                   	pop    %edx
80103cf5:	ff 73 9c             	pushl  -0x64(%ebx)
80103cf8:	57                   	push   %edi
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103cf9:	c7 43 8c 04 00 00 00 	movl   $0x4,-0x74(%ebx)

      swtch(&(c->scheduler), p->context);
80103d00:	e8 b6 0e 00 00       	call   80104bbb <swtch>
      switchkvm();
80103d05:	e8 86 32 00 00       	call   80106f90 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103d0a:	83 c4 10             	add    $0x10,%esp
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d0d:	81 fb f4 5d 11 80    	cmp    $0x80115df4,%ebx
      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103d13:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103d1a:	00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d1d:	75 bc                	jne    80103cdb <scheduler+0x4b>
80103d1f:	90                   	nop

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80103d20:	83 ec 0c             	sub    $0xc,%esp
80103d23:	68 c0 3d 11 80       	push   $0x80113dc0
80103d28:	e8 e3 0b 00 00       	call   80104910 <release>

  }
80103d2d:	83 c4 10             	add    $0x10,%esp
80103d30:	e9 7b ff ff ff       	jmp    80103cb0 <scheduler+0x20>
80103d35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d40 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103d40:	55                   	push   %ebp
80103d41:	89 e5                	mov    %esp,%ebp
80103d43:	56                   	push   %esi
80103d44:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103d45:	e8 36 0a 00 00       	call   80104780 <pushcli>
  c = mycpu();
80103d4a:	e8 e1 fb ff ff       	call   80103930 <mycpu>
  p = c->proc;
80103d4f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d55:	e8 66 0a 00 00       	call   801047c0 <popcli>
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
80103d5a:	83 ec 0c             	sub    $0xc,%esp
80103d5d:	68 c0 3d 11 80       	push   $0x80113dc0
80103d62:	e8 c9 0a 00 00       	call   80104830 <holding>
80103d67:	83 c4 10             	add    $0x10,%esp
80103d6a:	85 c0                	test   %eax,%eax
80103d6c:	74 4f                	je     80103dbd <sched+0x7d>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
80103d6e:	e8 bd fb ff ff       	call   80103930 <mycpu>
80103d73:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103d7a:	75 68                	jne    80103de4 <sched+0xa4>
    panic("sched locks");
  if(p->state == RUNNING)
80103d7c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103d80:	74 55                	je     80103dd7 <sched+0x97>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d82:	9c                   	pushf  
80103d83:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80103d84:	f6 c4 02             	test   $0x2,%ah
80103d87:	75 41                	jne    80103dca <sched+0x8a>
    panic("sched interruptible");
  intena = mycpu()->intena;
80103d89:	e8 a2 fb ff ff       	call   80103930 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103d8e:	83 c3 1c             	add    $0x1c,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
80103d91:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103d97:	e8 94 fb ff ff       	call   80103930 <mycpu>
80103d9c:	83 ec 08             	sub    $0x8,%esp
80103d9f:	ff 70 04             	pushl  0x4(%eax)
80103da2:	53                   	push   %ebx
80103da3:	e8 13 0e 00 00       	call   80104bbb <swtch>
  mycpu()->intena = intena;
80103da8:	e8 83 fb ff ff       	call   80103930 <mycpu>
}
80103dad:	83 c4 10             	add    $0x10,%esp
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
80103db0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103db6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103db9:	5b                   	pop    %ebx
80103dba:	5e                   	pop    %esi
80103dbb:	5d                   	pop    %ebp
80103dbc:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103dbd:	83 ec 0c             	sub    $0xc,%esp
80103dc0:	68 f0 7b 10 80       	push   $0x80107bf0
80103dc5:	e8 a6 c5 ff ff       	call   80100370 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103dca:	83 ec 0c             	sub    $0xc,%esp
80103dcd:	68 1c 7c 10 80       	push   $0x80107c1c
80103dd2:	e8 99 c5 ff ff       	call   80100370 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80103dd7:	83 ec 0c             	sub    $0xc,%esp
80103dda:	68 0e 7c 10 80       	push   $0x80107c0e
80103ddf:	e8 8c c5 ff ff       	call   80100370 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80103de4:	83 ec 0c             	sub    $0xc,%esp
80103de7:	68 02 7c 10 80       	push   $0x80107c02
80103dec:	e8 7f c5 ff ff       	call   80100370 <panic>
80103df1:	eb 0d                	jmp    80103e00 <exit>
80103df3:	90                   	nop
80103df4:	90                   	nop
80103df5:	90                   	nop
80103df6:	90                   	nop
80103df7:	90                   	nop
80103df8:	90                   	nop
80103df9:	90                   	nop
80103dfa:	90                   	nop
80103dfb:	90                   	nop
80103dfc:	90                   	nop
80103dfd:	90                   	nop
80103dfe:	90                   	nop
80103dff:	90                   	nop

80103e00 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103e00:	55                   	push   %ebp
80103e01:	89 e5                	mov    %esp,%ebp
80103e03:	57                   	push   %edi
80103e04:	56                   	push   %esi
80103e05:	53                   	push   %ebx
80103e06:	83 ec 0c             	sub    $0xc,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103e09:	e8 72 09 00 00       	call   80104780 <pushcli>
  c = mycpu();
80103e0e:	e8 1d fb ff ff       	call   80103930 <mycpu>
  p = c->proc;
80103e13:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103e19:	e8 a2 09 00 00       	call   801047c0 <popcli>
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103e1e:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
80103e24:	8d 5e 28             	lea    0x28(%esi),%ebx
80103e27:	8d 7e 68             	lea    0x68(%esi),%edi
80103e2a:	0f 84 e7 00 00 00    	je     80103f17 <exit+0x117>
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
80103e30:	8b 03                	mov    (%ebx),%eax
80103e32:	85 c0                	test   %eax,%eax
80103e34:	74 12                	je     80103e48 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103e36:	83 ec 0c             	sub    $0xc,%esp
80103e39:	50                   	push   %eax
80103e3a:	e8 51 d2 ff ff       	call   80101090 <fileclose>
      curproc->ofile[fd] = 0;
80103e3f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103e45:	83 c4 10             	add    $0x10,%esp
80103e48:	83 c3 04             	add    $0x4,%ebx

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103e4b:	39 df                	cmp    %ebx,%edi
80103e4d:	75 e1                	jne    80103e30 <exit+0x30>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
80103e4f:	e8 4c ef ff ff       	call   80102da0 <begin_op>
  iput(curproc->cwd);
80103e54:	83 ec 0c             	sub    $0xc,%esp
80103e57:	ff 76 68             	pushl  0x68(%esi)
80103e5a:	e8 91 db ff ff       	call   801019f0 <iput>
  end_op();
80103e5f:	e8 ac ef ff ff       	call   80102e10 <end_op>
  curproc->cwd = 0;
80103e64:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)

  acquire(&ptable.lock);
80103e6b:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80103e72:	e8 e9 09 00 00       	call   80104860 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80103e77:	8b 56 14             	mov    0x14(%esi),%edx
80103e7a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e7d:	b8 f4 3d 11 80       	mov    $0x80113df4,%eax
80103e82:	eb 0e                	jmp    80103e92 <exit+0x92>
80103e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e88:	83 e8 80             	sub    $0xffffff80,%eax
80103e8b:	3d f4 5d 11 80       	cmp    $0x80115df4,%eax
80103e90:	74 1c                	je     80103eae <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80103e92:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e96:	75 f0                	jne    80103e88 <exit+0x88>
80103e98:	3b 50 20             	cmp    0x20(%eax),%edx
80103e9b:	75 eb                	jne    80103e88 <exit+0x88>
      p->state = RUNNABLE;
80103e9d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ea4:	83 e8 80             	sub    $0xffffff80,%eax
80103ea7:	3d f4 5d 11 80       	cmp    $0x80115df4,%eax
80103eac:	75 e4                	jne    80103e92 <exit+0x92>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103eae:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
80103eb4:	ba f4 3d 11 80       	mov    $0x80113df4,%edx
80103eb9:	eb 10                	jmp    80103ecb <exit+0xcb>
80103ebb:	90                   	nop
80103ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ec0:	83 ea 80             	sub    $0xffffff80,%edx
80103ec3:	81 fa f4 5d 11 80    	cmp    $0x80115df4,%edx
80103ec9:	74 33                	je     80103efe <exit+0xfe>
    if(p->parent == curproc){
80103ecb:	39 72 14             	cmp    %esi,0x14(%edx)
80103ece:	75 f0                	jne    80103ec0 <exit+0xc0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103ed0:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103ed4:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103ed7:	75 e7                	jne    80103ec0 <exit+0xc0>
80103ed9:	b8 f4 3d 11 80       	mov    $0x80113df4,%eax
80103ede:	eb 0a                	jmp    80103eea <exit+0xea>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ee0:	83 e8 80             	sub    $0xffffff80,%eax
80103ee3:	3d f4 5d 11 80       	cmp    $0x80115df4,%eax
80103ee8:	74 d6                	je     80103ec0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103eea:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103eee:	75 f0                	jne    80103ee0 <exit+0xe0>
80103ef0:	3b 48 20             	cmp    0x20(%eax),%ecx
80103ef3:	75 eb                	jne    80103ee0 <exit+0xe0>
      p->state = RUNNABLE;
80103ef5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103efc:	eb e2                	jmp    80103ee0 <exit+0xe0>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80103efe:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103f05:	e8 36 fe ff ff       	call   80103d40 <sched>
  panic("zombie exit");
80103f0a:	83 ec 0c             	sub    $0xc,%esp
80103f0d:	68 3d 7c 10 80       	push   $0x80107c3d
80103f12:	e8 59 c4 ff ff       	call   80100370 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
80103f17:	83 ec 0c             	sub    $0xc,%esp
80103f1a:	68 30 7c 10 80       	push   $0x80107c30
80103f1f:	e8 4c c4 ff ff       	call   80100370 <panic>
80103f24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103f2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103f30 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103f30:	55                   	push   %ebp
80103f31:	89 e5                	mov    %esp,%ebp
80103f33:	53                   	push   %ebx
80103f34:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103f37:	68 c0 3d 11 80       	push   $0x80113dc0
80103f3c:	e8 1f 09 00 00       	call   80104860 <acquire>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103f41:	e8 3a 08 00 00       	call   80104780 <pushcli>
  c = mycpu();
80103f46:	e8 e5 f9 ff ff       	call   80103930 <mycpu>
  p = c->proc;
80103f4b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f51:	e8 6a 08 00 00       	call   801047c0 <popcli>
// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
80103f56:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103f5d:	e8 de fd ff ff       	call   80103d40 <sched>
  release(&ptable.lock);
80103f62:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80103f69:	e8 a2 09 00 00       	call   80104910 <release>
}
80103f6e:	83 c4 10             	add    $0x10,%esp
80103f71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f74:	c9                   	leave  
80103f75:	c3                   	ret    
80103f76:	8d 76 00             	lea    0x0(%esi),%esi
80103f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f80 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103f80:	55                   	push   %ebp
80103f81:	89 e5                	mov    %esp,%ebp
80103f83:	57                   	push   %edi
80103f84:	56                   	push   %esi
80103f85:	53                   	push   %ebx
80103f86:	83 ec 0c             	sub    $0xc,%esp
80103f89:	8b 7d 08             	mov    0x8(%ebp),%edi
80103f8c:	8b 75 0c             	mov    0xc(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103f8f:	e8 ec 07 00 00       	call   80104780 <pushcli>
  c = mycpu();
80103f94:	e8 97 f9 ff ff       	call   80103930 <mycpu>
  p = c->proc;
80103f99:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f9f:	e8 1c 08 00 00       	call   801047c0 <popcli>
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
80103fa4:	85 db                	test   %ebx,%ebx
80103fa6:	0f 84 87 00 00 00    	je     80104033 <sleep+0xb3>
    panic("sleep");

  if(lk == 0)
80103fac:	85 f6                	test   %esi,%esi
80103fae:	74 76                	je     80104026 <sleep+0xa6>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103fb0:	81 fe c0 3d 11 80    	cmp    $0x80113dc0,%esi
80103fb6:	74 50                	je     80104008 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103fb8:	83 ec 0c             	sub    $0xc,%esp
80103fbb:	68 c0 3d 11 80       	push   $0x80113dc0
80103fc0:	e8 9b 08 00 00       	call   80104860 <acquire>
    release(lk);
80103fc5:	89 34 24             	mov    %esi,(%esp)
80103fc8:	e8 43 09 00 00       	call   80104910 <release>
  }
  // Go to sleep.
  p->chan = chan;
80103fcd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103fd0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80103fd7:	e8 64 fd ff ff       	call   80103d40 <sched>

  // Tidy up.
  p->chan = 0;
80103fdc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103fe3:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80103fea:	e8 21 09 00 00       	call   80104910 <release>
    acquire(lk);
80103fef:	89 75 08             	mov    %esi,0x8(%ebp)
80103ff2:	83 c4 10             	add    $0x10,%esp
  }
}
80103ff5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ff8:	5b                   	pop    %ebx
80103ff9:	5e                   	pop    %esi
80103ffa:	5f                   	pop    %edi
80103ffb:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103ffc:	e9 5f 08 00 00       	jmp    80104860 <acquire>
80104001:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
80104008:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010400b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80104012:	e8 29 fd ff ff       	call   80103d40 <sched>

  // Tidy up.
  p->chan = 0;
80104017:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
8010401e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104021:	5b                   	pop    %ebx
80104022:	5e                   	pop    %esi
80104023:	5f                   	pop    %edi
80104024:	5d                   	pop    %ebp
80104025:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80104026:	83 ec 0c             	sub    $0xc,%esp
80104029:	68 4f 7c 10 80       	push   $0x80107c4f
8010402e:	e8 3d c3 ff ff       	call   80100370 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
80104033:	83 ec 0c             	sub    $0xc,%esp
80104036:	68 49 7c 10 80       	push   $0x80107c49
8010403b:	e8 30 c3 ff ff       	call   80100370 <panic>

80104040 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	56                   	push   %esi
80104044:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104045:	e8 36 07 00 00       	call   80104780 <pushcli>
  c = mycpu();
8010404a:	e8 e1 f8 ff ff       	call   80103930 <mycpu>
  p = c->proc;
8010404f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104055:	e8 66 07 00 00       	call   801047c0 <popcli>
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
8010405a:	83 ec 0c             	sub    $0xc,%esp
8010405d:	68 c0 3d 11 80       	push   $0x80113dc0
80104062:	e8 f9 07 00 00       	call   80104860 <acquire>
80104067:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
8010406a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010406c:	bb f4 3d 11 80       	mov    $0x80113df4,%ebx
80104071:	eb 10                	jmp    80104083 <wait+0x43>
80104073:	90                   	nop
80104074:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104078:	83 eb 80             	sub    $0xffffff80,%ebx
8010407b:	81 fb f4 5d 11 80    	cmp    $0x80115df4,%ebx
80104081:	74 1d                	je     801040a0 <wait+0x60>
      if(p->parent != curproc)
80104083:	39 73 14             	cmp    %esi,0x14(%ebx)
80104086:	75 f0                	jne    80104078 <wait+0x38>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80104088:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010408c:	74 30                	je     801040be <wait+0x7e>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010408e:	83 eb 80             	sub    $0xffffff80,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
80104091:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104096:	81 fb f4 5d 11 80    	cmp    $0x80115df4,%ebx
8010409c:	75 e5                	jne    80104083 <wait+0x43>
8010409e:	66 90                	xchg   %ax,%ax
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
801040a0:	85 c0                	test   %eax,%eax
801040a2:	74 70                	je     80104114 <wait+0xd4>
801040a4:	8b 46 24             	mov    0x24(%esi),%eax
801040a7:	85 c0                	test   %eax,%eax
801040a9:	75 69                	jne    80104114 <wait+0xd4>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801040ab:	83 ec 08             	sub    $0x8,%esp
801040ae:	68 c0 3d 11 80       	push   $0x80113dc0
801040b3:	56                   	push   %esi
801040b4:	e8 c7 fe ff ff       	call   80103f80 <sleep>
  }
801040b9:	83 c4 10             	add    $0x10,%esp
801040bc:	eb ac                	jmp    8010406a <wait+0x2a>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
801040be:	83 ec 0c             	sub    $0xc,%esp
801040c1:	ff 73 08             	pushl  0x8(%ebx)
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
801040c4:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801040c7:	e8 64 e4 ff ff       	call   80102530 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
801040cc:	5a                   	pop    %edx
801040cd:	ff 73 04             	pushl  0x4(%ebx)
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
801040d0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801040d7:	e8 54 32 00 00       	call   80107330 <freevm>
        p->pid = 0;
801040dc:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801040e3:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801040ea:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801040ee:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801040f5:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801040fc:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80104103:	e8 08 08 00 00       	call   80104910 <release>
        return pid;
80104108:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
8010410b:	8d 65 f8             	lea    -0x8(%ebp),%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
8010410e:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104110:	5b                   	pop    %ebx
80104111:	5e                   	pop    %esi
80104112:	5d                   	pop    %ebp
80104113:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
80104114:	83 ec 0c             	sub    $0xc,%esp
80104117:	68 c0 3d 11 80       	push   $0x80113dc0
8010411c:	e8 ef 07 00 00       	call   80104910 <release>
      return -1;
80104121:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104124:	8d 65 f8             	lea    -0x8(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
80104127:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
8010412c:	5b                   	pop    %ebx
8010412d:	5e                   	pop    %esi
8010412e:	5d                   	pop    %ebp
8010412f:	c3                   	ret    

80104130 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104130:	55                   	push   %ebp
80104131:	89 e5                	mov    %esp,%ebp
80104133:	53                   	push   %ebx
80104134:	83 ec 10             	sub    $0x10,%esp
80104137:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010413a:	68 c0 3d 11 80       	push   $0x80113dc0
8010413f:	e8 1c 07 00 00       	call   80104860 <acquire>
80104144:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104147:	b8 f4 3d 11 80       	mov    $0x80113df4,%eax
8010414c:	eb 0c                	jmp    8010415a <wakeup+0x2a>
8010414e:	66 90                	xchg   %ax,%ax
80104150:	83 e8 80             	sub    $0xffffff80,%eax
80104153:	3d f4 5d 11 80       	cmp    $0x80115df4,%eax
80104158:	74 1c                	je     80104176 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010415a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010415e:	75 f0                	jne    80104150 <wakeup+0x20>
80104160:	3b 58 20             	cmp    0x20(%eax),%ebx
80104163:	75 eb                	jne    80104150 <wakeup+0x20>
      p->state = RUNNABLE;
80104165:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010416c:	83 e8 80             	sub    $0xffffff80,%eax
8010416f:	3d f4 5d 11 80       	cmp    $0x80115df4,%eax
80104174:	75 e4                	jne    8010415a <wakeup+0x2a>
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80104176:	c7 45 08 c0 3d 11 80 	movl   $0x80113dc0,0x8(%ebp)
}
8010417d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104180:	c9                   	leave  
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80104181:	e9 8a 07 00 00       	jmp    80104910 <release>
80104186:	8d 76 00             	lea    0x0(%esi),%esi
80104189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104190 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104190:	55                   	push   %ebp
80104191:	89 e5                	mov    %esp,%ebp
80104193:	53                   	push   %ebx
80104194:	83 ec 10             	sub    $0x10,%esp
80104197:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010419a:	68 c0 3d 11 80       	push   $0x80113dc0
8010419f:	e8 bc 06 00 00       	call   80104860 <acquire>
801041a4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041a7:	b8 f4 3d 11 80       	mov    $0x80113df4,%eax
801041ac:	eb 0c                	jmp    801041ba <kill+0x2a>
801041ae:	66 90                	xchg   %ax,%ax
801041b0:	83 e8 80             	sub    $0xffffff80,%eax
801041b3:	3d f4 5d 11 80       	cmp    $0x80115df4,%eax
801041b8:	74 3e                	je     801041f8 <kill+0x68>
    if(p->pid == pid){
801041ba:	39 58 10             	cmp    %ebx,0x10(%eax)
801041bd:	75 f1                	jne    801041b0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801041bf:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
801041c3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801041ca:	74 1c                	je     801041e8 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
801041cc:	83 ec 0c             	sub    $0xc,%esp
801041cf:	68 c0 3d 11 80       	push   $0x80113dc0
801041d4:	e8 37 07 00 00       	call   80104910 <release>
      return 0;
801041d9:	83 c4 10             	add    $0x10,%esp
801041dc:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801041de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041e1:	c9                   	leave  
801041e2:	c3                   	ret    
801041e3:	90                   	nop
801041e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
801041e8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801041ef:	eb db                	jmp    801041cc <kill+0x3c>
801041f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
801041f8:	83 ec 0c             	sub    $0xc,%esp
801041fb:	68 c0 3d 11 80       	push   $0x80113dc0
80104200:	e8 0b 07 00 00       	call   80104910 <release>
  return -1;
80104205:	83 c4 10             	add    $0x10,%esp
80104208:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010420d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104210:	c9                   	leave  
80104211:	c3                   	ret    
80104212:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104220 <findch>:

    return chname;
}


int findch(int pid){
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	57                   	push   %edi
80104224:	56                   	push   %esi
80104225:	53                   	push   %ebx
  r2 = 1;
  int i = 0;
80104226:	31 db                	xor    %ebx,%ebx

    return chname;
}


int findch(int pid){
80104228:	83 ec 28             	sub    $0x28,%esp
  r2 = 1;
8010422b:	c7 05 a0 3d 11 80 01 	movl   $0x1,0x80113da0
80104232:	00 00 00 

    return chname;
}


int findch(int pid){
80104235:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i = 0;
  int j = 0;
  int r = 1;
  struct proc *p;
  int name = 0;
  acquire(&ptable.lock);
80104238:	68 c0 3d 11 80       	push   $0x80113dc0
8010423d:	e8 1e 06 00 00       	call   80104860 <acquire>
80104242:	8b 35 a0 3d 11 80    	mov    0x80113da0,%esi
80104248:	83 c4 10             	add    $0x10,%esp
8010424b:	31 d2                	xor    %edx,%edx
  r2 = 1;
  int i = 0;
  int j = 0;
  int r = 1;
  struct proc *p;
  int name = 0;
8010424d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104254:	b9 f4 3d 11 80       	mov    $0x80113df4,%ecx
80104259:	eb 10                	jmp    8010426b <findch+0x4b>
8010425b:	90                   	nop
8010425c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104260:	83 e9 80             	sub    $0xffffff80,%ecx
80104263:	81 f9 f4 5d 11 80    	cmp    $0x80115df4,%ecx
80104269:	74 40                	je     801042ab <findch+0x8b>
    if(p->parent->pid == pid){
8010426b:	8b 41 14             	mov    0x14(%ecx),%eax
8010426e:	39 78 10             	cmp    %edi,0x10(%eax)
80104271:	75 ed                	jne    80104260 <findch+0x40>
       for(j=0;j<i;j++){
80104273:	85 db                	test   %ebx,%ebx
80104275:	b8 01 00 00 00       	mov    $0x1,%eax
8010427a:	74 10                	je     8010428c <findch+0x6c>
8010427c:	31 d2                	xor    %edx,%edx
8010427e:	66 90                	xchg   %ax,%ax
           r *= 10;
80104280:	8d 04 80             	lea    (%eax,%eax,4),%eax
  struct proc *p;
  int name = 0;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent->pid == pid){
       for(j=0;j<i;j++){
80104283:	83 c2 01             	add    $0x1,%edx
           r *= 10;
80104286:	01 c0                	add    %eax,%eax
  struct proc *p;
  int name = 0;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent->pid == pid){
       for(j=0;j<i;j++){
80104288:	39 da                	cmp    %ebx,%edx
8010428a:	75 f4                	jne    80104280 <findch+0x60>
           r *= 10;
       }
       r2 *= 10;
       name += r * p->pid;
8010428c:	0f af 41 10          	imul   0x10(%ecx),%eax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent->pid == pid){
       for(j=0;j<i;j++){
           r *= 10;
       }
       r2 *= 10;
80104290:	8d 34 b6             	lea    (%esi,%esi,4),%esi
  int j = 0;
  int r = 1;
  struct proc *p;
  int name = 0;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104293:	83 e9 80             	sub    $0xffffff80,%ecx
       for(j=0;j<i;j++){
           r *= 10;
       }
       r2 *= 10;
       name += r * p->pid;
       i = i + 1;
80104296:	83 c3 01             	add    $0x1,%ebx
80104299:	ba 01 00 00 00       	mov    $0x1,%edx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent->pid == pid){
       for(j=0;j<i;j++){
           r *= 10;
       }
       r2 *= 10;
8010429e:	01 f6                	add    %esi,%esi
       name += r * p->pid;
801042a0:	01 45 e4             	add    %eax,-0x1c(%ebp)
  int j = 0;
  int r = 1;
  struct proc *p;
  int name = 0;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042a3:	81 f9 f4 5d 11 80    	cmp    $0x80115df4,%ecx
801042a9:	75 c0                	jne    8010426b <findch+0x4b>
801042ab:	84 d2                	test   %dl,%dl
801042ad:	75 18                	jne    801042c7 <findch+0xa7>
       name += r * p->pid;
       i = i + 1;
       r = 1;
    }
  }
  release(&ptable.lock);
801042af:	83 ec 0c             	sub    $0xc,%esp
801042b2:	68 c0 3d 11 80       	push   $0x80113dc0
801042b7:	e8 54 06 00 00       	call   80104910 <release>
  return name;

}
801042bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801042bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042c2:	5b                   	pop    %ebx
801042c3:	5e                   	pop    %esi
801042c4:	5f                   	pop    %edi
801042c5:	5d                   	pop    %ebp
801042c6:	c3                   	ret    
801042c7:	89 35 a0 3d 11 80    	mov    %esi,0x80113da0
801042cd:	eb e0                	jmp    801042af <findch+0x8f>
801042cf:	90                   	nop

801042d0 <getchildren>:

//getchildren of a parent
////////////////////////////////////////////////////////////////////////PART 3///////////////////////////////////////////////////////////////////////

int r2;
int getchildren(int pid) {
801042d0:	55                   	push   %ebp
801042d1:	89 e5                	mov    %esp,%ebp
801042d3:	57                   	push   %edi
801042d4:	56                   	push   %esi
801042d5:	53                   	push   %ebx
801042d6:	81 ec 28 01 00 00    	sub    $0x128,%esp
801042dc:	8b 7d 08             	mov    0x8(%ebp),%edi

    int chname = 0;
    struct proc *p;
    int queue[NPROC], front = -1,rear = -1;
    int delete_item;
    acquire(&ptable.lock);
801042df:	68 c0 3d 11 80       	push   $0x80113dc0
801042e4:	e8 77 05 00 00       	call   80104860 <acquire>
801042e9:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042ec:	b8 f4 3d 11 80       	mov    $0x80113df4,%eax
801042f1:	eb 0f                	jmp    80104302 <getchildren+0x32>
801042f3:	90                   	nop
801042f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042f8:	83 e8 80             	sub    $0xffffff80,%eax
801042fb:	3d f4 5d 11 80       	cmp    $0x80115df4,%eax
80104300:	74 16                	je     80104318 <getchildren+0x48>
       if(p->pid == pid)
80104302:	39 78 10             	cmp    %edi,0x10(%eax)
80104305:	75 f1                	jne    801042f8 <getchildren+0x28>
	  p->visited = 1;
80104307:	c7 40 7c 01 00 00 00 	movl   $0x1,0x7c(%eax)
    int chname = 0;
    struct proc *p;
    int queue[NPROC], front = -1,rear = -1;
    int delete_item;
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010430e:	83 e8 80             	sub    $0xffffff80,%eax
80104311:	3d f4 5d 11 80       	cmp    $0x80115df4,%eax
80104316:	75 ea                	jne    80104302 <getchildren+0x32>
       if(p->pid == pid)
	  p->visited = 1;
    }
    release(&ptable.lock);
80104318:	83 ec 0c             	sub    $0xc,%esp
    if(rear != NPROC - 1)
    {
       if(front == -1) 
	  front = 0;
       rear = rear+1;
       queue[rear] = pid;
8010431b:	31 f6                	xor    %esi,%esi
8010431d:	31 db                	xor    %ebx,%ebx
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
       if(p->pid == pid)
	  p->visited = 1;
    }
    release(&ptable.lock);
8010431f:	68 c0 3d 11 80       	push   $0x80113dc0
80104324:	e8 e7 05 00 00       	call   80104910 <release>
    if(rear != NPROC - 1)
    {
       if(front == -1) 
	  front = 0;
       rear = rear+1;
       queue[rear] = pid;
80104329:	89 bd e8 fe ff ff    	mov    %edi,-0x118(%ebp)
8010432f:	83 c4 10             	add    $0x10,%esp
80104332:	c7 85 e4 fe ff ff 00 	movl   $0x0,-0x11c(%ebp)
80104339:	00 00 00 
8010433c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }

    while((front != -1) && (front <= rear)){
        delete_item = queue[front];
	front = front+1;
        chname = findch(delete_item) + (chname * r2);
80104340:	83 ec 0c             	sub    $0xc,%esp
       queue[rear] = pid;
    }

    while((front != -1) && (front <= rear)){
        delete_item = queue[front];
	front = front+1;
80104343:	83 85 e4 fe ff ff 01 	addl   $0x1,-0x11c(%ebp)
        chname = findch(delete_item) + (chname * r2);
8010434a:	57                   	push   %edi
8010434b:	e8 d0 fe ff ff       	call   80104220 <findch>
80104350:	0f af 1d a0 3d 11 80 	imul   0x80113da0,%ebx
        acquire(&ptable.lock);
80104357:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
    }

    while((front != -1) && (front <= rear)){
        delete_item = queue[front];
	front = front+1;
        chname = findch(delete_item) + (chname * r2);
8010435e:	01 c3                	add    %eax,%ebx
        acquire(&ptable.lock);
80104360:	e8 fb 04 00 00       	call   80104860 <acquire>
80104365:	83 c4 10             	add    $0x10,%esp
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104368:	b8 f4 3d 11 80       	mov    $0x80113df4,%eax
8010436d:	eb 0b                	jmp    8010437a <getchildren+0xaa>
8010436f:	90                   	nop
80104370:	83 e8 80             	sub    $0xffffff80,%eax
80104373:	3d f4 5d 11 80       	cmp    $0x80115df4,%eax
80104378:	74 31                	je     801043ab <getchildren+0xdb>
          if((p->parent->pid == delete_item) && (p->visited != 1)){
8010437a:	8b 48 14             	mov    0x14(%eax),%ecx
8010437d:	39 79 10             	cmp    %edi,0x10(%ecx)
80104380:	75 ee                	jne    80104370 <getchildren+0xa0>
80104382:	83 78 7c 01          	cmpl   $0x1,0x7c(%eax)
80104386:	74 e8                	je     80104370 <getchildren+0xa0>
             if(rear != NPROC - 1)
80104388:	83 fe 3f             	cmp    $0x3f,%esi
8010438b:	74 0d                	je     8010439a <getchildren+0xca>
             {
                if(front == -1) 
	           front = 0;
                rear = rear+1;
                queue[rear] = p->pid;
8010438d:	8b 48 10             	mov    0x10(%eax),%ecx
          if((p->parent->pid == delete_item) && (p->visited != 1)){
             if(rear != NPROC - 1)
             {
                if(front == -1) 
	           front = 0;
                rear = rear+1;
80104390:	83 c6 01             	add    $0x1,%esi
                queue[rear] = p->pid;
80104393:	89 8c b5 e8 fe ff ff 	mov    %ecx,-0x118(%ebp,%esi,4)
             }
             p->visited = 1;
8010439a:	c7 40 7c 01 00 00 00 	movl   $0x1,0x7c(%eax)
    while((front != -1) && (front <= rear)){
        delete_item = queue[front];
	front = front+1;
        chname = findch(delete_item) + (chname * r2);
        acquire(&ptable.lock);
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043a1:	83 e8 80             	sub    $0xffffff80,%eax
801043a4:	3d f4 5d 11 80       	cmp    $0x80115df4,%eax
801043a9:	75 cf                	jne    8010437a <getchildren+0xaa>
             }
             p->visited = 1;

          }
        }
        release(&ptable.lock);
801043ab:	83 ec 0c             	sub    $0xc,%esp
801043ae:	68 c0 3d 11 80       	push   $0x80113dc0
801043b3:	e8 58 05 00 00       	call   80104910 <release>
	  front = 0;
       rear = rear+1;
       queue[rear] = pid;
    }

    while((front != -1) && (front <= rear)){
801043b8:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
801043be:	83 c4 10             	add    $0x10,%esp
801043c1:	39 c6                	cmp    %eax,%esi
801043c3:	7c 0c                	jl     801043d1 <getchildren+0x101>
801043c5:	8b bc 85 e8 fe ff ff 	mov    -0x118(%ebp,%eax,4),%edi
801043cc:	e9 6f ff ff ff       	jmp    80104340 <getchildren+0x70>
        }
        release(&ptable.lock);
    }

    return chname;
}
801043d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043d4:	89 d8                	mov    %ebx,%eax
801043d6:	5b                   	pop    %ebx
801043d7:	5e                   	pop    %esi
801043d8:	5f                   	pop    %edi
801043d9:	5d                   	pop    %ebp
801043da:	c3                   	ret    
801043db:	90                   	nop
801043dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801043e0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	57                   	push   %edi
801043e4:	56                   	push   %esi
801043e5:	53                   	push   %ebx
801043e6:	8d 75 e8             	lea    -0x18(%ebp),%esi
801043e9:	bb 60 3e 11 80       	mov    $0x80113e60,%ebx
801043ee:	83 ec 3c             	sub    $0x3c,%esp
801043f1:	eb 24                	jmp    80104417 <procdump+0x37>
801043f3:	90                   	nop
801043f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801043f8:	83 ec 0c             	sub    $0xc,%esp
801043fb:	68 88 7c 10 80       	push   $0x80107c88
80104400:	e8 5b c2 ff ff       	call   80100660 <cprintf>
80104405:	83 c4 10             	add    $0x10,%esp
80104408:	83 eb 80             	sub    $0xffffff80,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010440b:	81 fb 60 5e 11 80    	cmp    $0x80115e60,%ebx
80104411:	0f 84 81 00 00 00    	je     80104498 <procdump+0xb8>
    if(p->state == UNUSED)
80104417:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010441a:	85 c0                	test   %eax,%eax
8010441c:	74 ea                	je     80104408 <procdump+0x28>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010441e:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80104421:	ba 60 7c 10 80       	mov    $0x80107c60,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104426:	77 11                	ja     80104439 <procdump+0x59>
80104428:	8b 14 85 dc 7c 10 80 	mov    -0x7fef8324(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
8010442f:	b8 60 7c 10 80       	mov    $0x80107c60,%eax
80104434:	85 d2                	test   %edx,%edx
80104436:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104439:	53                   	push   %ebx
8010443a:	52                   	push   %edx
8010443b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010443e:	68 64 7c 10 80       	push   $0x80107c64
80104443:	e8 18 c2 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
80104448:	83 c4 10             	add    $0x10,%esp
8010444b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010444f:	75 a7                	jne    801043f8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104451:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104454:	83 ec 08             	sub    $0x8,%esp
80104457:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010445a:	50                   	push   %eax
8010445b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010445e:	8b 40 0c             	mov    0xc(%eax),%eax
80104461:	83 c0 08             	add    $0x8,%eax
80104464:	50                   	push   %eax
80104465:	e8 b6 02 00 00       	call   80104720 <getcallerpcs>
8010446a:	83 c4 10             	add    $0x10,%esp
8010446d:	8d 76 00             	lea    0x0(%esi),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104470:	8b 17                	mov    (%edi),%edx
80104472:	85 d2                	test   %edx,%edx
80104474:	74 82                	je     801043f8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104476:	83 ec 08             	sub    $0x8,%esp
80104479:	83 c7 04             	add    $0x4,%edi
8010447c:	52                   	push   %edx
8010447d:	68 a1 76 10 80       	push   $0x801076a1
80104482:	e8 d9 c1 ff ff       	call   80100660 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104487:	83 c4 10             	add    $0x10,%esp
8010448a:	39 f7                	cmp    %esi,%edi
8010448c:	75 e2                	jne    80104470 <procdump+0x90>
8010448e:	e9 65 ff ff ff       	jmp    801043f8 <procdump+0x18>
80104493:	90                   	nop
80104494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104498:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010449b:	5b                   	pop    %ebx
8010449c:	5e                   	pop    %esi
8010449d:	5f                   	pop    %edi
8010449e:	5d                   	pop    %ebp
8010449f:	c3                   	ret    

801044a0 <set>:

int
set(char * path)
{ 
801044a0:	55                   	push   %ebp
    int i=0;
    int j;
    char temp[100];
    struct inode *ip;
    int size;
    while(path[i]!='\0'){
801044a1:	31 c0                	xor    %eax,%eax
  }
}

int
set(char * path)
{ 
801044a3:	89 e5                	mov    %esp,%ebp
801044a5:	57                   	push   %edi
801044a6:	56                   	push   %esi
801044a7:	53                   	push   %ebx
801044a8:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
801044ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
    int i=0;
    int j;
    char temp[100];
    struct inode *ip;
    int size;
    while(path[i]!='\0'){
801044b1:	0f b6 11             	movzbl (%ecx),%edx
801044b4:	84 d2                	test   %dl,%dl
801044b6:	74 19                	je     801044d1 <set+0x31>
801044b8:	90                   	nop
801044b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      add_path[i]=path[i];
801044c0:	88 90 20 0f 11 80    	mov    %dl,-0x7feef0e0(%eax)
      i++;
801044c6:	83 c0 01             	add    $0x1,%eax
    int i=0;
    int j;
    char temp[100];
    struct inode *ip;
    int size;
    while(path[i]!='\0'){
801044c9:	0f b6 14 01          	movzbl (%ecx,%eax,1),%edx
801044cd:	84 d2                	test   %dl,%dl
801044cf:	75 ef                	jne    801044c0 <set+0x20>
      add_path[i]=path[i];
      i++;
    }
    add_path[i]='\0';
    size=get_size_string(add_path);
801044d1:	83 ec 0c             	sub    $0xc,%esp
    int size;
    while(path[i]!='\0'){
      add_path[i]=path[i];
      i++;
    }
    add_path[i]='\0';
801044d4:	c6 80 20 0f 11 80 00 	movb   $0x0,-0x7feef0e0(%eax)
801044db:	8d 7d 84             	lea    -0x7c(%ebp),%edi
    size=get_size_string(add_path);
801044de:	68 20 0f 11 80       	push   $0x80110f20
801044e3:	e8 08 c5 ff ff       	call   801009f0 <get_size_string>
    for(j=0;j<size;j++){
801044e8:	83 c4 10             	add    $0x10,%esp
801044eb:	31 c9                	xor    %ecx,%ecx
801044ed:	85 c0                	test   %eax,%eax
    while(path[i]!='\0'){
      add_path[i]=path[i];
      i++;
    }
    add_path[i]='\0';
    size=get_size_string(add_path);
801044ef:	89 c6                	mov    %eax,%esi
    for(j=0;j<size;j++){
801044f1:	c7 85 74 ff ff ff 00 	movl   $0x0,-0x8c(%ebp)
801044f8:	00 00 00 
801044fb:	7e 53                	jle    80104550 <set+0xb0>
801044fd:	8d 76 00             	lea    0x0(%esi),%esi
80104500:	89 cb                	mov    %ecx,%ebx
80104502:	31 c0                	xor    %eax,%eax
80104504:	eb 17                	jmp    8010451d <set+0x7d>
80104506:	8d 76 00             	lea    0x0(%esi),%esi
80104509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
     while(add_path[j]!=':'){
       	temp[ii]=add_path[j];
        ii++;
        j++; 
80104510:	83 c3 01             	add    $0x1,%ebx
    }
    add_path[i]='\0';
    size=get_size_string(add_path);
    for(j=0;j<size;j++){
     while(add_path[j]!=':'){
       	temp[ii]=add_path[j];
80104513:	88 14 07             	mov    %dl,(%edi,%eax,1)
        ii++;
80104516:	83 c0 01             	add    $0x1,%eax
        j++; 
        if(j>=size)
80104519:	39 de                	cmp    %ebx,%esi
8010451b:	7e 0d                	jle    8010452a <set+0x8a>
      i++;
    }
    add_path[i]='\0';
    size=get_size_string(add_path);
    for(j=0;j<size;j++){
     while(add_path[j]!=':'){
8010451d:	0f b6 94 01 20 0f 11 	movzbl -0x7feef0e0(%ecx,%eax,1),%edx
80104524:	80 
80104525:	80 fa 3a             	cmp    $0x3a,%dl
80104528:	75 e6                	jne    80104510 <set+0x70>
            break;
     }
     temp[ii]='\0';
       ii++;
       ii=0;
       ip=namei(temp);
8010452a:	83 ec 0c             	sub    $0xc,%esp
        ii++;
        j++; 
        if(j>=size)
            break;
     }
     temp[ii]='\0';
8010452d:	c6 44 05 84 00       	movb   $0x0,-0x7c(%ebp,%eax,1)
       ii++;
       ii=0;
       ip=namei(temp);
80104532:	57                   	push   %edi
80104533:	e8 d8 db ff ff       	call   80102110 <namei>
       if(ip == 0){
80104538:	83 c4 10             	add    $0x10,%esp
8010453b:	85 c0                	test   %eax,%eax
8010453d:	74 1b                	je     8010455a <set+0xba>
      add_path[i]=path[i];
      i++;
    }
    add_path[i]='\0';
    size=get_size_string(add_path);
    for(j=0;j<size;j++){
8010453f:	8d 4b 01             	lea    0x1(%ebx),%ecx
80104542:	39 ce                	cmp    %ecx,%esi
80104544:	7f ba                	jg     80104500 <set+0x60>
       if(ip == 0){
	 cprintf("%s directory doesn't exist!\n",temp);
         error=1;
       }
     }
     if(error)
80104546:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
8010454c:	85 c0                	test   %eax,%eax
8010454e:	75 27                	jne    80104577 <set+0xd7>
	exit();
    return 0;
}
80104550:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104553:	31 c0                	xor    %eax,%eax
80104555:	5b                   	pop    %ebx
80104556:	5e                   	pop    %esi
80104557:	5f                   	pop    %edi
80104558:	5d                   	pop    %ebp
80104559:	c3                   	ret    
     temp[ii]='\0';
       ii++;
       ii=0;
       ip=namei(temp);
       if(ip == 0){
	 cprintf("%s directory doesn't exist!\n",temp);
8010455a:	83 ec 08             	sub    $0x8,%esp
8010455d:	57                   	push   %edi
8010455e:	68 6d 7c 10 80       	push   $0x80107c6d
80104563:	e8 f8 c0 ff ff       	call   80100660 <cprintf>
80104568:	83 c4 10             	add    $0x10,%esp
         error=1;
8010456b:	c7 85 74 ff ff ff 01 	movl   $0x1,-0x8c(%ebp)
80104572:	00 00 00 
80104575:	eb c8                	jmp    8010453f <set+0x9f>
       }
     }
     if(error)
	exit();
80104577:	e8 84 f8 ff ff       	call   80103e00 <exit>
8010457c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104580 <count>:
    return 0;
}
int
count(int num)
{
80104580:	55                   	push   %ebp
80104581:	89 e5                	mov    %esp,%ebp
80104583:	56                   	push   %esi
80104584:	53                   	push   %ebx
80104585:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int c=0;
	while(num/10 > 0){
80104588:	83 f9 09             	cmp    $0x9,%ecx
8010458b:	7e 32                	jle    801045bf <count+0x3f>
8010458d:	31 db                	xor    %ebx,%ebx
                  num = num / 10;
8010458f:	be 67 66 66 66       	mov    $0x66666667,%esi
80104594:	eb 0c                	jmp    801045a2 <count+0x22>
80104596:	8d 76 00             	lea    0x0(%esi),%esi
80104599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                  c += 1;
801045a0:	89 c3                	mov    %eax,%ebx
int
count(int num)
{
	int c=0;
	while(num/10 > 0){
                  num = num / 10;
801045a2:	89 c8                	mov    %ecx,%eax
801045a4:	c1 f9 1f             	sar    $0x1f,%ecx
801045a7:	f7 ee                	imul   %esi
                  c += 1;
801045a9:	8d 43 01             	lea    0x1(%ebx),%eax
int
count(int num)
{
	int c=0;
	while(num/10 > 0){
                  num = num / 10;
801045ac:	c1 fa 02             	sar    $0x2,%edx
801045af:	29 ca                	sub    %ecx,%edx
}
int
count(int num)
{
	int c=0;
	while(num/10 > 0){
801045b1:	83 fa 09             	cmp    $0x9,%edx
                  num = num / 10;
801045b4:	89 d1                	mov    %edx,%ecx
}
int
count(int num)
{
	int c=0;
	while(num/10 > 0){
801045b6:	7f e8                	jg     801045a0 <count+0x20>
801045b8:	8d 43 02             	lea    0x2(%ebx),%eax
                  num = num / 10;
                  c += 1;
        }

	return c+1;
}
801045bb:	5b                   	pop    %ebx
801045bc:	5e                   	pop    %esi
801045bd:	5d                   	pop    %ebp
801045be:	c3                   	ret    
}
int
count(int num)
{
	int c=0;
	while(num/10 > 0){
801045bf:	b8 01 00 00 00       	mov    $0x1,%eax
801045c4:	eb f5                	jmp    801045bb <count+0x3b>
801045c6:	66 90                	xchg   %ax,%ax
801045c8:	66 90                	xchg   %ax,%ax
801045ca:	66 90                	xchg   %ax,%ax
801045cc:	66 90                	xchg   %ax,%ax
801045ce:	66 90                	xchg   %ax,%ax

801045d0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	53                   	push   %ebx
801045d4:	83 ec 0c             	sub    $0xc,%esp
801045d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801045da:	68 f4 7c 10 80       	push   $0x80107cf4
801045df:	8d 43 04             	lea    0x4(%ebx),%eax
801045e2:	50                   	push   %eax
801045e3:	e8 18 01 00 00       	call   80104700 <initlock>
  lk->name = name;
801045e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801045eb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801045f1:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
801045f4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
801045fb:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
801045fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104601:	c9                   	leave  
80104602:	c3                   	ret    
80104603:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104610 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104610:	55                   	push   %ebp
80104611:	89 e5                	mov    %esp,%ebp
80104613:	56                   	push   %esi
80104614:	53                   	push   %ebx
80104615:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104618:	83 ec 0c             	sub    $0xc,%esp
8010461b:	8d 73 04             	lea    0x4(%ebx),%esi
8010461e:	56                   	push   %esi
8010461f:	e8 3c 02 00 00       	call   80104860 <acquire>
  while (lk->locked) {
80104624:	8b 13                	mov    (%ebx),%edx
80104626:	83 c4 10             	add    $0x10,%esp
80104629:	85 d2                	test   %edx,%edx
8010462b:	74 16                	je     80104643 <acquiresleep+0x33>
8010462d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104630:	83 ec 08             	sub    $0x8,%esp
80104633:	56                   	push   %esi
80104634:	53                   	push   %ebx
80104635:	e8 46 f9 ff ff       	call   80103f80 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
8010463a:	8b 03                	mov    (%ebx),%eax
8010463c:	83 c4 10             	add    $0x10,%esp
8010463f:	85 c0                	test   %eax,%eax
80104641:	75 ed                	jne    80104630 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104643:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104649:	e8 82 f3 ff ff       	call   801039d0 <myproc>
8010464e:	8b 40 10             	mov    0x10(%eax),%eax
80104651:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104654:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104657:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010465a:	5b                   	pop    %ebx
8010465b:	5e                   	pop    %esi
8010465c:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
8010465d:	e9 ae 02 00 00       	jmp    80104910 <release>
80104662:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104670 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	56                   	push   %esi
80104674:	53                   	push   %ebx
80104675:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104678:	83 ec 0c             	sub    $0xc,%esp
8010467b:	8d 73 04             	lea    0x4(%ebx),%esi
8010467e:	56                   	push   %esi
8010467f:	e8 dc 01 00 00       	call   80104860 <acquire>
  lk->locked = 0;
80104684:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010468a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104691:	89 1c 24             	mov    %ebx,(%esp)
80104694:	e8 97 fa ff ff       	call   80104130 <wakeup>
  release(&lk->lk);
80104699:	89 75 08             	mov    %esi,0x8(%ebp)
8010469c:	83 c4 10             	add    $0x10,%esp
}
8010469f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046a2:	5b                   	pop    %ebx
801046a3:	5e                   	pop    %esi
801046a4:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
801046a5:	e9 66 02 00 00       	jmp    80104910 <release>
801046aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046b0 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	57                   	push   %edi
801046b4:	56                   	push   %esi
801046b5:	53                   	push   %ebx
801046b6:	31 ff                	xor    %edi,%edi
801046b8:	83 ec 18             	sub    $0x18,%esp
801046bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801046be:	8d 73 04             	lea    0x4(%ebx),%esi
801046c1:	56                   	push   %esi
801046c2:	e8 99 01 00 00       	call   80104860 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801046c7:	8b 03                	mov    (%ebx),%eax
801046c9:	83 c4 10             	add    $0x10,%esp
801046cc:	85 c0                	test   %eax,%eax
801046ce:	74 13                	je     801046e3 <holdingsleep+0x33>
801046d0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801046d3:	e8 f8 f2 ff ff       	call   801039d0 <myproc>
801046d8:	39 58 10             	cmp    %ebx,0x10(%eax)
801046db:	0f 94 c0             	sete   %al
801046de:	0f b6 c0             	movzbl %al,%eax
801046e1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
801046e3:	83 ec 0c             	sub    $0xc,%esp
801046e6:	56                   	push   %esi
801046e7:	e8 24 02 00 00       	call   80104910 <release>
  return r;
}
801046ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046ef:	89 f8                	mov    %edi,%eax
801046f1:	5b                   	pop    %ebx
801046f2:	5e                   	pop    %esi
801046f3:	5f                   	pop    %edi
801046f4:	5d                   	pop    %ebp
801046f5:	c3                   	ret    
801046f6:	66 90                	xchg   %ax,%ax
801046f8:	66 90                	xchg   %ax,%ax
801046fa:	66 90                	xchg   %ax,%ax
801046fc:	66 90                	xchg   %ax,%ax
801046fe:	66 90                	xchg   %ax,%ax

80104700 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104706:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104709:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010470f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104712:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104719:	5d                   	pop    %ebp
8010471a:	c3                   	ret    
8010471b:	90                   	nop
8010471c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104720 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104724:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104727:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010472a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010472d:	31 c0                	xor    %eax,%eax
8010472f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104730:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104736:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010473c:	77 1a                	ja     80104758 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010473e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104741:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104744:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104747:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104749:	83 f8 0a             	cmp    $0xa,%eax
8010474c:	75 e2                	jne    80104730 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010474e:	5b                   	pop    %ebx
8010474f:	5d                   	pop    %ebp
80104750:	c3                   	ret    
80104751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104758:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010475f:	83 c0 01             	add    $0x1,%eax
80104762:	83 f8 0a             	cmp    $0xa,%eax
80104765:	74 e7                	je     8010474e <getcallerpcs+0x2e>
    pcs[i] = 0;
80104767:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010476e:	83 c0 01             	add    $0x1,%eax
80104771:	83 f8 0a             	cmp    $0xa,%eax
80104774:	75 e2                	jne    80104758 <getcallerpcs+0x38>
80104776:	eb d6                	jmp    8010474e <getcallerpcs+0x2e>
80104778:	90                   	nop
80104779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104780 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	53                   	push   %ebx
80104784:	83 ec 04             	sub    $0x4,%esp
80104787:	9c                   	pushf  
80104788:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104789:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010478a:	e8 a1 f1 ff ff       	call   80103930 <mycpu>
8010478f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104795:	85 c0                	test   %eax,%eax
80104797:	75 11                	jne    801047aa <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104799:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010479f:	e8 8c f1 ff ff       	call   80103930 <mycpu>
801047a4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801047aa:	e8 81 f1 ff ff       	call   80103930 <mycpu>
801047af:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801047b6:	83 c4 04             	add    $0x4,%esp
801047b9:	5b                   	pop    %ebx
801047ba:	5d                   	pop    %ebp
801047bb:	c3                   	ret    
801047bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047c0 <popcli>:

void
popcli(void)
{
801047c0:	55                   	push   %ebp
801047c1:	89 e5                	mov    %esp,%ebp
801047c3:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801047c6:	9c                   	pushf  
801047c7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801047c8:	f6 c4 02             	test   $0x2,%ah
801047cb:	75 52                	jne    8010481f <popcli+0x5f>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801047cd:	e8 5e f1 ff ff       	call   80103930 <mycpu>
801047d2:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
801047d8:	8d 51 ff             	lea    -0x1(%ecx),%edx
801047db:	85 d2                	test   %edx,%edx
801047dd:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
801047e3:	78 2d                	js     80104812 <popcli+0x52>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801047e5:	e8 46 f1 ff ff       	call   80103930 <mycpu>
801047ea:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801047f0:	85 d2                	test   %edx,%edx
801047f2:	74 0c                	je     80104800 <popcli+0x40>
    sti();
}
801047f4:	c9                   	leave  
801047f5:	c3                   	ret    
801047f6:	8d 76 00             	lea    0x0(%esi),%esi
801047f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104800:	e8 2b f1 ff ff       	call   80103930 <mycpu>
80104805:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010480b:	85 c0                	test   %eax,%eax
8010480d:	74 e5                	je     801047f4 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
8010480f:	fb                   	sti    
    sti();
}
80104810:	c9                   	leave  
80104811:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
80104812:	83 ec 0c             	sub    $0xc,%esp
80104815:	68 16 7d 10 80       	push   $0x80107d16
8010481a:	e8 51 bb ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
8010481f:	83 ec 0c             	sub    $0xc,%esp
80104822:	68 ff 7c 10 80       	push   $0x80107cff
80104827:	e8 44 bb ff ff       	call   80100370 <panic>
8010482c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104830 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	56                   	push   %esi
80104834:	53                   	push   %ebx
80104835:	8b 75 08             	mov    0x8(%ebp),%esi
80104838:	31 db                	xor    %ebx,%ebx
  int r;
  pushcli();
8010483a:	e8 41 ff ff ff       	call   80104780 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010483f:	8b 06                	mov    (%esi),%eax
80104841:	85 c0                	test   %eax,%eax
80104843:	74 10                	je     80104855 <holding+0x25>
80104845:	8b 5e 08             	mov    0x8(%esi),%ebx
80104848:	e8 e3 f0 ff ff       	call   80103930 <mycpu>
8010484d:	39 c3                	cmp    %eax,%ebx
8010484f:	0f 94 c3             	sete   %bl
80104852:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104855:	e8 66 ff ff ff       	call   801047c0 <popcli>
  return r;
}
8010485a:	89 d8                	mov    %ebx,%eax
8010485c:	5b                   	pop    %ebx
8010485d:	5e                   	pop    %esi
8010485e:	5d                   	pop    %ebp
8010485f:	c3                   	ret    

80104860 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	53                   	push   %ebx
80104864:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104867:	e8 14 ff ff ff       	call   80104780 <pushcli>
  if(holding(lk))
8010486c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010486f:	83 ec 0c             	sub    $0xc,%esp
80104872:	53                   	push   %ebx
80104873:	e8 b8 ff ff ff       	call   80104830 <holding>
80104878:	83 c4 10             	add    $0x10,%esp
8010487b:	85 c0                	test   %eax,%eax
8010487d:	0f 85 7d 00 00 00    	jne    80104900 <acquire+0xa0>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104883:	ba 01 00 00 00       	mov    $0x1,%edx
80104888:	eb 09                	jmp    80104893 <acquire+0x33>
8010488a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104890:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104893:	89 d0                	mov    %edx,%eax
80104895:	f0 87 03             	lock xchg %eax,(%ebx)
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104898:	85 c0                	test   %eax,%eax
8010489a:	75 f4                	jne    80104890 <acquire+0x30>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
8010489c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801048a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801048a4:	e8 87 f0 ff ff       	call   80103930 <mycpu>
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801048a9:	89 ea                	mov    %ebp,%edx
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
801048ab:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801048ae:	89 43 08             	mov    %eax,0x8(%ebx)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801048b1:	31 c0                	xor    %eax,%eax
801048b3:	90                   	nop
801048b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801048b8:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801048be:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801048c4:	77 1a                	ja     801048e0 <acquire+0x80>
      break;
    pcs[i] = ebp[1];     // saved %eip
801048c6:	8b 5a 04             	mov    0x4(%edx),%ebx
801048c9:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801048cc:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801048cf:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801048d1:	83 f8 0a             	cmp    $0xa,%eax
801048d4:	75 e2                	jne    801048b8 <acquire+0x58>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
}
801048d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048d9:	c9                   	leave  
801048da:	c3                   	ret    
801048db:	90                   	nop
801048dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801048e0:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801048e7:	83 c0 01             	add    $0x1,%eax
801048ea:	83 f8 0a             	cmp    $0xa,%eax
801048ed:	74 e7                	je     801048d6 <acquire+0x76>
    pcs[i] = 0;
801048ef:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801048f6:	83 c0 01             	add    $0x1,%eax
801048f9:	83 f8 0a             	cmp    $0xa,%eax
801048fc:	75 e2                	jne    801048e0 <acquire+0x80>
801048fe:	eb d6                	jmp    801048d6 <acquire+0x76>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
80104900:	83 ec 0c             	sub    $0xc,%esp
80104903:	68 1d 7d 10 80       	push   $0x80107d1d
80104908:	e8 63 ba ff ff       	call   80100370 <panic>
8010490d:	8d 76 00             	lea    0x0(%esi),%esi

80104910 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104910:	55                   	push   %ebp
80104911:	89 e5                	mov    %esp,%ebp
80104913:	53                   	push   %ebx
80104914:	83 ec 10             	sub    $0x10,%esp
80104917:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010491a:	53                   	push   %ebx
8010491b:	e8 10 ff ff ff       	call   80104830 <holding>
80104920:	83 c4 10             	add    $0x10,%esp
80104923:	85 c0                	test   %eax,%eax
80104925:	74 22                	je     80104949 <release+0x39>
    panic("release");

  lk->pcs[0] = 0;
80104927:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010492e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104935:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010493a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
80104940:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104943:	c9                   	leave  
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
80104944:	e9 77 fe ff ff       	jmp    801047c0 <popcli>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
80104949:	83 ec 0c             	sub    $0xc,%esp
8010494c:	68 25 7d 10 80       	push   $0x80107d25
80104951:	e8 1a ba ff ff       	call   80100370 <panic>
80104956:	66 90                	xchg   %ax,%ax
80104958:	66 90                	xchg   %ax,%ax
8010495a:	66 90                	xchg   %ax,%ax
8010495c:	66 90                	xchg   %ax,%ax
8010495e:	66 90                	xchg   %ax,%ax

80104960 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	57                   	push   %edi
80104964:	53                   	push   %ebx
80104965:	8b 55 08             	mov    0x8(%ebp),%edx
80104968:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010496b:	f6 c2 03             	test   $0x3,%dl
8010496e:	75 05                	jne    80104975 <memset+0x15>
80104970:	f6 c1 03             	test   $0x3,%cl
80104973:	74 13                	je     80104988 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104975:	89 d7                	mov    %edx,%edi
80104977:	8b 45 0c             	mov    0xc(%ebp),%eax
8010497a:	fc                   	cld    
8010497b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010497d:	5b                   	pop    %ebx
8010497e:	89 d0                	mov    %edx,%eax
80104980:	5f                   	pop    %edi
80104981:	5d                   	pop    %ebp
80104982:	c3                   	ret    
80104983:	90                   	nop
80104984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104988:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
8010498c:	c1 e9 02             	shr    $0x2,%ecx
8010498f:	89 fb                	mov    %edi,%ebx
80104991:	89 f8                	mov    %edi,%eax
80104993:	c1 e3 18             	shl    $0x18,%ebx
80104996:	c1 e0 10             	shl    $0x10,%eax
80104999:	09 d8                	or     %ebx,%eax
8010499b:	09 f8                	or     %edi,%eax
8010499d:	c1 e7 08             	shl    $0x8,%edi
801049a0:	09 f8                	or     %edi,%eax
801049a2:	89 d7                	mov    %edx,%edi
801049a4:	fc                   	cld    
801049a5:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801049a7:	5b                   	pop    %ebx
801049a8:	89 d0                	mov    %edx,%eax
801049aa:	5f                   	pop    %edi
801049ab:	5d                   	pop    %ebp
801049ac:	c3                   	ret    
801049ad:	8d 76 00             	lea    0x0(%esi),%esi

801049b0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	57                   	push   %edi
801049b4:	56                   	push   %esi
801049b5:	8b 45 10             	mov    0x10(%ebp),%eax
801049b8:	53                   	push   %ebx
801049b9:	8b 75 0c             	mov    0xc(%ebp),%esi
801049bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801049bf:	85 c0                	test   %eax,%eax
801049c1:	74 29                	je     801049ec <memcmp+0x3c>
    if(*s1 != *s2)
801049c3:	0f b6 13             	movzbl (%ebx),%edx
801049c6:	0f b6 0e             	movzbl (%esi),%ecx
801049c9:	38 d1                	cmp    %dl,%cl
801049cb:	75 2b                	jne    801049f8 <memcmp+0x48>
801049cd:	8d 78 ff             	lea    -0x1(%eax),%edi
801049d0:	31 c0                	xor    %eax,%eax
801049d2:	eb 14                	jmp    801049e8 <memcmp+0x38>
801049d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049d8:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
801049dd:	83 c0 01             	add    $0x1,%eax
801049e0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801049e4:	38 ca                	cmp    %cl,%dl
801049e6:	75 10                	jne    801049f8 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801049e8:	39 f8                	cmp    %edi,%eax
801049ea:	75 ec                	jne    801049d8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801049ec:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
801049ed:	31 c0                	xor    %eax,%eax
}
801049ef:	5e                   	pop    %esi
801049f0:	5f                   	pop    %edi
801049f1:	5d                   	pop    %ebp
801049f2:	c3                   	ret    
801049f3:	90                   	nop
801049f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
801049f8:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
801049fb:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
801049fc:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
801049fe:	5e                   	pop    %esi
801049ff:	5f                   	pop    %edi
80104a00:	5d                   	pop    %ebp
80104a01:	c3                   	ret    
80104a02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a10 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	56                   	push   %esi
80104a14:	53                   	push   %ebx
80104a15:	8b 45 08             	mov    0x8(%ebp),%eax
80104a18:	8b 75 0c             	mov    0xc(%ebp),%esi
80104a1b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104a1e:	39 c6                	cmp    %eax,%esi
80104a20:	73 2e                	jae    80104a50 <memmove+0x40>
80104a22:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104a25:	39 c8                	cmp    %ecx,%eax
80104a27:	73 27                	jae    80104a50 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
80104a29:	85 db                	test   %ebx,%ebx
80104a2b:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104a2e:	74 17                	je     80104a47 <memmove+0x37>
      *--d = *--s;
80104a30:	29 d9                	sub    %ebx,%ecx
80104a32:	89 cb                	mov    %ecx,%ebx
80104a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a38:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104a3c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104a3f:	83 ea 01             	sub    $0x1,%edx
80104a42:	83 fa ff             	cmp    $0xffffffff,%edx
80104a45:	75 f1                	jne    80104a38 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104a47:	5b                   	pop    %ebx
80104a48:	5e                   	pop    %esi
80104a49:	5d                   	pop    %ebp
80104a4a:	c3                   	ret    
80104a4b:	90                   	nop
80104a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104a50:	31 d2                	xor    %edx,%edx
80104a52:	85 db                	test   %ebx,%ebx
80104a54:	74 f1                	je     80104a47 <memmove+0x37>
80104a56:	8d 76 00             	lea    0x0(%esi),%esi
80104a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
80104a60:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104a64:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104a67:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104a6a:	39 d3                	cmp    %edx,%ebx
80104a6c:	75 f2                	jne    80104a60 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
80104a6e:	5b                   	pop    %ebx
80104a6f:	5e                   	pop    %esi
80104a70:	5d                   	pop    %ebp
80104a71:	c3                   	ret    
80104a72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a80 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104a83:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104a84:	eb 8a                	jmp    80104a10 <memmove>
80104a86:	8d 76 00             	lea    0x0(%esi),%esi
80104a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a90 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	57                   	push   %edi
80104a94:	56                   	push   %esi
80104a95:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104a98:	53                   	push   %ebx
80104a99:	8b 7d 08             	mov    0x8(%ebp),%edi
80104a9c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104a9f:	85 c9                	test   %ecx,%ecx
80104aa1:	74 37                	je     80104ada <strncmp+0x4a>
80104aa3:	0f b6 17             	movzbl (%edi),%edx
80104aa6:	0f b6 1e             	movzbl (%esi),%ebx
80104aa9:	84 d2                	test   %dl,%dl
80104aab:	74 3f                	je     80104aec <strncmp+0x5c>
80104aad:	38 d3                	cmp    %dl,%bl
80104aaf:	75 3b                	jne    80104aec <strncmp+0x5c>
80104ab1:	8d 47 01             	lea    0x1(%edi),%eax
80104ab4:	01 cf                	add    %ecx,%edi
80104ab6:	eb 1b                	jmp    80104ad3 <strncmp+0x43>
80104ab8:	90                   	nop
80104ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ac0:	0f b6 10             	movzbl (%eax),%edx
80104ac3:	84 d2                	test   %dl,%dl
80104ac5:	74 21                	je     80104ae8 <strncmp+0x58>
80104ac7:	0f b6 19             	movzbl (%ecx),%ebx
80104aca:	83 c0 01             	add    $0x1,%eax
80104acd:	89 ce                	mov    %ecx,%esi
80104acf:	38 da                	cmp    %bl,%dl
80104ad1:	75 19                	jne    80104aec <strncmp+0x5c>
80104ad3:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
80104ad5:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104ad8:	75 e6                	jne    80104ac0 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104ada:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
80104adb:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
80104add:	5e                   	pop    %esi
80104ade:	5f                   	pop    %edi
80104adf:	5d                   	pop    %ebp
80104ae0:	c3                   	ret    
80104ae1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ae8:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104aec:	0f b6 c2             	movzbl %dl,%eax
80104aef:	29 d8                	sub    %ebx,%eax
}
80104af1:	5b                   	pop    %ebx
80104af2:	5e                   	pop    %esi
80104af3:	5f                   	pop    %edi
80104af4:	5d                   	pop    %ebp
80104af5:	c3                   	ret    
80104af6:	8d 76 00             	lea    0x0(%esi),%esi
80104af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b00 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	56                   	push   %esi
80104b04:	53                   	push   %ebx
80104b05:	8b 45 08             	mov    0x8(%ebp),%eax
80104b08:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104b0b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104b0e:	89 c2                	mov    %eax,%edx
80104b10:	eb 19                	jmp    80104b2b <strncpy+0x2b>
80104b12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b18:	83 c3 01             	add    $0x1,%ebx
80104b1b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104b1f:	83 c2 01             	add    $0x1,%edx
80104b22:	84 c9                	test   %cl,%cl
80104b24:	88 4a ff             	mov    %cl,-0x1(%edx)
80104b27:	74 09                	je     80104b32 <strncpy+0x32>
80104b29:	89 f1                	mov    %esi,%ecx
80104b2b:	85 c9                	test   %ecx,%ecx
80104b2d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104b30:	7f e6                	jg     80104b18 <strncpy+0x18>
    ;
  while(n-- > 0)
80104b32:	31 c9                	xor    %ecx,%ecx
80104b34:	85 f6                	test   %esi,%esi
80104b36:	7e 17                	jle    80104b4f <strncpy+0x4f>
80104b38:	90                   	nop
80104b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104b40:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104b44:	89 f3                	mov    %esi,%ebx
80104b46:	83 c1 01             	add    $0x1,%ecx
80104b49:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104b4b:	85 db                	test   %ebx,%ebx
80104b4d:	7f f1                	jg     80104b40 <strncpy+0x40>
    *s++ = 0;
  return os;
}
80104b4f:	5b                   	pop    %ebx
80104b50:	5e                   	pop    %esi
80104b51:	5d                   	pop    %ebp
80104b52:	c3                   	ret    
80104b53:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b60 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	56                   	push   %esi
80104b64:	53                   	push   %ebx
80104b65:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104b68:	8b 45 08             	mov    0x8(%ebp),%eax
80104b6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104b6e:	85 c9                	test   %ecx,%ecx
80104b70:	7e 26                	jle    80104b98 <safestrcpy+0x38>
80104b72:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104b76:	89 c1                	mov    %eax,%ecx
80104b78:	eb 17                	jmp    80104b91 <safestrcpy+0x31>
80104b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104b80:	83 c2 01             	add    $0x1,%edx
80104b83:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104b87:	83 c1 01             	add    $0x1,%ecx
80104b8a:	84 db                	test   %bl,%bl
80104b8c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104b8f:	74 04                	je     80104b95 <safestrcpy+0x35>
80104b91:	39 f2                	cmp    %esi,%edx
80104b93:	75 eb                	jne    80104b80 <safestrcpy+0x20>
    ;
  *s = 0;
80104b95:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104b98:	5b                   	pop    %ebx
80104b99:	5e                   	pop    %esi
80104b9a:	5d                   	pop    %ebp
80104b9b:	c3                   	ret    
80104b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ba0 <strlen>:

int
strlen(const char *s)
{
80104ba0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104ba1:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104ba3:	89 e5                	mov    %esp,%ebp
80104ba5:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104ba8:	80 3a 00             	cmpb   $0x0,(%edx)
80104bab:	74 0c                	je     80104bb9 <strlen+0x19>
80104bad:	8d 76 00             	lea    0x0(%esi),%esi
80104bb0:	83 c0 01             	add    $0x1,%eax
80104bb3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104bb7:	75 f7                	jne    80104bb0 <strlen+0x10>
    ;
  return n;
}
80104bb9:	5d                   	pop    %ebp
80104bba:	c3                   	ret    

80104bbb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104bbb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104bbf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104bc3:	55                   	push   %ebp
  pushl %ebx
80104bc4:	53                   	push   %ebx
  pushl %esi
80104bc5:	56                   	push   %esi
  pushl %edi
80104bc6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104bc7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104bc9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104bcb:	5f                   	pop    %edi
  popl %esi
80104bcc:	5e                   	pop    %esi
  popl %ebx
80104bcd:	5b                   	pop    %ebx
  popl %ebp
80104bce:	5d                   	pop    %ebp
  ret
80104bcf:	c3                   	ret    

80104bd0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	53                   	push   %ebx
80104bd4:	83 ec 04             	sub    $0x4,%esp
80104bd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104bda:	e8 f1 ed ff ff       	call   801039d0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104bdf:	8b 00                	mov    (%eax),%eax
80104be1:	39 d8                	cmp    %ebx,%eax
80104be3:	76 1b                	jbe    80104c00 <fetchint+0x30>
80104be5:	8d 53 04             	lea    0x4(%ebx),%edx
80104be8:	39 d0                	cmp    %edx,%eax
80104bea:	72 14                	jb     80104c00 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104bec:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bef:	8b 13                	mov    (%ebx),%edx
80104bf1:	89 10                	mov    %edx,(%eax)
  return 0;
80104bf3:	31 c0                	xor    %eax,%eax
}
80104bf5:	83 c4 04             	add    $0x4,%esp
80104bf8:	5b                   	pop    %ebx
80104bf9:	5d                   	pop    %ebp
80104bfa:	c3                   	ret    
80104bfb:	90                   	nop
80104bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104c00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c05:	eb ee                	jmp    80104bf5 <fetchint+0x25>
80104c07:	89 f6                	mov    %esi,%esi
80104c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c10 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	53                   	push   %ebx
80104c14:	83 ec 04             	sub    $0x4,%esp
80104c17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104c1a:	e8 b1 ed ff ff       	call   801039d0 <myproc>

  if(addr >= curproc->sz)
80104c1f:	39 18                	cmp    %ebx,(%eax)
80104c21:	76 29                	jbe    80104c4c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104c23:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104c26:	89 da                	mov    %ebx,%edx
80104c28:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104c2a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104c2c:	39 c3                	cmp    %eax,%ebx
80104c2e:	73 1c                	jae    80104c4c <fetchstr+0x3c>
    if(*s == 0)
80104c30:	80 3b 00             	cmpb   $0x0,(%ebx)
80104c33:	75 10                	jne    80104c45 <fetchstr+0x35>
80104c35:	eb 29                	jmp    80104c60 <fetchstr+0x50>
80104c37:	89 f6                	mov    %esi,%esi
80104c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104c40:	80 3a 00             	cmpb   $0x0,(%edx)
80104c43:	74 1b                	je     80104c60 <fetchstr+0x50>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
80104c45:	83 c2 01             	add    $0x1,%edx
80104c48:	39 d0                	cmp    %edx,%eax
80104c4a:	77 f4                	ja     80104c40 <fetchstr+0x30>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104c4c:	83 c4 04             	add    $0x4,%esp
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
80104c4f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104c54:	5b                   	pop    %ebx
80104c55:	5d                   	pop    %ebp
80104c56:	c3                   	ret    
80104c57:	89 f6                	mov    %esi,%esi
80104c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104c60:	83 c4 04             	add    $0x4,%esp
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
80104c63:	89 d0                	mov    %edx,%eax
80104c65:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104c67:	5b                   	pop    %ebx
80104c68:	5d                   	pop    %ebp
80104c69:	c3                   	ret    
80104c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c70 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	56                   	push   %esi
80104c74:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c75:	e8 56 ed ff ff       	call   801039d0 <myproc>
80104c7a:	8b 40 18             	mov    0x18(%eax),%eax
80104c7d:	8b 55 08             	mov    0x8(%ebp),%edx
80104c80:	8b 40 44             	mov    0x44(%eax),%eax
80104c83:	8d 1c 90             	lea    (%eax,%edx,4),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();
80104c86:	e8 45 ed ff ff       	call   801039d0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c8b:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c8d:	8d 73 04             	lea    0x4(%ebx),%esi
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c90:	39 c6                	cmp    %eax,%esi
80104c92:	73 1c                	jae    80104cb0 <argint+0x40>
80104c94:	8d 53 08             	lea    0x8(%ebx),%edx
80104c97:	39 d0                	cmp    %edx,%eax
80104c99:	72 15                	jb     80104cb0 <argint+0x40>
    return -1;
  *ip = *(int*)(addr);
80104c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c9e:	8b 53 04             	mov    0x4(%ebx),%edx
80104ca1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ca3:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}
80104ca5:	5b                   	pop    %ebx
80104ca6:	5e                   	pop    %esi
80104ca7:	5d                   	pop    %ebp
80104ca8:	c3                   	ret    
80104ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104cb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cb5:	eb ee                	jmp    80104ca5 <argint+0x35>
80104cb7:	89 f6                	mov    %esi,%esi
80104cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cc0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	56                   	push   %esi
80104cc4:	53                   	push   %ebx
80104cc5:	83 ec 10             	sub    $0x10,%esp
80104cc8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104ccb:	e8 00 ed ff ff       	call   801039d0 <myproc>
80104cd0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104cd2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104cd5:	83 ec 08             	sub    $0x8,%esp
80104cd8:	50                   	push   %eax
80104cd9:	ff 75 08             	pushl  0x8(%ebp)
80104cdc:	e8 8f ff ff ff       	call   80104c70 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104ce1:	c1 e8 1f             	shr    $0x1f,%eax
80104ce4:	83 c4 10             	add    $0x10,%esp
80104ce7:	84 c0                	test   %al,%al
80104ce9:	75 2d                	jne    80104d18 <argptr+0x58>
80104ceb:	89 d8                	mov    %ebx,%eax
80104ced:	c1 e8 1f             	shr    $0x1f,%eax
80104cf0:	84 c0                	test   %al,%al
80104cf2:	75 24                	jne    80104d18 <argptr+0x58>
80104cf4:	8b 16                	mov    (%esi),%edx
80104cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cf9:	39 c2                	cmp    %eax,%edx
80104cfb:	76 1b                	jbe    80104d18 <argptr+0x58>
80104cfd:	01 c3                	add    %eax,%ebx
80104cff:	39 da                	cmp    %ebx,%edx
80104d01:	72 15                	jb     80104d18 <argptr+0x58>
    return -1;
  *pp = (char*)i;
80104d03:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d06:	89 02                	mov    %eax,(%edx)
  return 0;
80104d08:	31 c0                	xor    %eax,%eax
}
80104d0a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d0d:	5b                   	pop    %ebx
80104d0e:	5e                   	pop    %esi
80104d0f:	5d                   	pop    %ebp
80104d10:	c3                   	ret    
80104d11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
80104d18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d1d:	eb eb                	jmp    80104d0a <argptr+0x4a>
80104d1f:	90                   	nop

80104d20 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104d26:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d29:	50                   	push   %eax
80104d2a:	ff 75 08             	pushl  0x8(%ebp)
80104d2d:	e8 3e ff ff ff       	call   80104c70 <argint>
80104d32:	83 c4 10             	add    $0x10,%esp
80104d35:	85 c0                	test   %eax,%eax
80104d37:	78 17                	js     80104d50 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104d39:	83 ec 08             	sub    $0x8,%esp
80104d3c:	ff 75 0c             	pushl  0xc(%ebp)
80104d3f:	ff 75 f4             	pushl  -0xc(%ebp)
80104d42:	e8 c9 fe ff ff       	call   80104c10 <fetchstr>
80104d47:	83 c4 10             	add    $0x10,%esp
}
80104d4a:	c9                   	leave  
80104d4b:	c3                   	ret    
80104d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80104d50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
80104d55:	c9                   	leave  
80104d56:	c3                   	ret    
80104d57:	89 f6                	mov    %esi,%esi
80104d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d60 <syscall>:
[SYS_cmos]    sys_cmos,
};

void
syscall(void)
{
80104d60:	55                   	push   %ebp
80104d61:	89 e5                	mov    %esp,%ebp
80104d63:	56                   	push   %esi
80104d64:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80104d65:	e8 66 ec ff ff       	call   801039d0 <myproc>

  num = curproc->tf->eax;
80104d6a:	8b 70 18             	mov    0x18(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
80104d6d:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104d6f:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104d72:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d75:	83 fa 1a             	cmp    $0x1a,%edx
80104d78:	77 1e                	ja     80104d98 <syscall+0x38>
80104d7a:	8b 14 85 60 7d 10 80 	mov    -0x7fef82a0(,%eax,4),%edx
80104d81:	85 d2                	test   %edx,%edx
80104d83:	74 13                	je     80104d98 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104d85:	ff d2                	call   *%edx
80104d87:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104d8a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d8d:	5b                   	pop    %ebx
80104d8e:	5e                   	pop    %esi
80104d8f:	5d                   	pop    %ebp
80104d90:	c3                   	ret    
80104d91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104d98:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104d99:	8d 43 6c             	lea    0x6c(%ebx),%eax

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104d9c:	50                   	push   %eax
80104d9d:	ff 73 10             	pushl  0x10(%ebx)
80104da0:	68 2d 7d 10 80       	push   $0x80107d2d
80104da5:	e8 b6 b8 ff ff       	call   80100660 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
80104daa:	8b 43 18             	mov    0x18(%ebx),%eax
80104dad:	83 c4 10             	add    $0x10,%esp
80104db0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80104db7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104dba:	5b                   	pop    %ebx
80104dbb:	5e                   	pop    %esi
80104dbc:	5d                   	pop    %ebp
80104dbd:	c3                   	ret    
80104dbe:	66 90                	xchg   %ax,%ax

80104dc0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104dc0:	55                   	push   %ebp
80104dc1:	89 e5                	mov    %esp,%ebp
80104dc3:	57                   	push   %edi
80104dc4:	56                   	push   %esi
80104dc5:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104dc6:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104dc9:	83 ec 34             	sub    $0x34,%esp
80104dcc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104dcf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104dd2:	56                   	push   %esi
80104dd3:	50                   	push   %eax
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104dd4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104dd7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104dda:	e8 51 d3 ff ff       	call   80102130 <nameiparent>
80104ddf:	83 c4 10             	add    $0x10,%esp
80104de2:	85 c0                	test   %eax,%eax
80104de4:	0f 84 f6 00 00 00    	je     80104ee0 <create+0x120>
    return 0;
  ilock(dp);
80104dea:	83 ec 0c             	sub    $0xc,%esp
80104ded:	89 c7                	mov    %eax,%edi
80104def:	50                   	push   %eax
80104df0:	e8 cb ca ff ff       	call   801018c0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104df5:	83 c4 0c             	add    $0xc,%esp
80104df8:	6a 00                	push   $0x0
80104dfa:	56                   	push   %esi
80104dfb:	57                   	push   %edi
80104dfc:	e8 ef cf ff ff       	call   80101df0 <dirlookup>
80104e01:	83 c4 10             	add    $0x10,%esp
80104e04:	85 c0                	test   %eax,%eax
80104e06:	89 c3                	mov    %eax,%ebx
80104e08:	74 56                	je     80104e60 <create+0xa0>
    iunlockput(dp);
80104e0a:	83 ec 0c             	sub    $0xc,%esp
80104e0d:	57                   	push   %edi
80104e0e:	e8 3d cd ff ff       	call   80101b50 <iunlockput>
    ilock(ip);
80104e13:	89 1c 24             	mov    %ebx,(%esp)
80104e16:	e8 a5 ca ff ff       	call   801018c0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104e1b:	83 c4 10             	add    $0x10,%esp
80104e1e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104e23:	75 1b                	jne    80104e40 <create+0x80>
80104e25:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
80104e2a:	89 d8                	mov    %ebx,%eax
80104e2c:	75 12                	jne    80104e40 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104e2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e31:	5b                   	pop    %ebx
80104e32:	5e                   	pop    %esi
80104e33:	5f                   	pop    %edi
80104e34:	5d                   	pop    %ebp
80104e35:	c3                   	ret    
80104e36:	8d 76 00             	lea    0x0(%esi),%esi
80104e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if((ip = dirlookup(dp, name, 0)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80104e40:	83 ec 0c             	sub    $0xc,%esp
80104e43:	53                   	push   %ebx
80104e44:	e8 07 cd ff ff       	call   80101b50 <iunlockput>
    return 0;
80104e49:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104e4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
80104e4f:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104e51:	5b                   	pop    %ebx
80104e52:	5e                   	pop    %esi
80104e53:	5f                   	pop    %edi
80104e54:	5d                   	pop    %ebp
80104e55:	c3                   	ret    
80104e56:	8d 76 00             	lea    0x0(%esi),%esi
80104e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80104e60:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104e64:	83 ec 08             	sub    $0x8,%esp
80104e67:	50                   	push   %eax
80104e68:	ff 37                	pushl  (%edi)
80104e6a:	e8 e1 c8 ff ff       	call   80101750 <ialloc>
80104e6f:	83 c4 10             	add    $0x10,%esp
80104e72:	85 c0                	test   %eax,%eax
80104e74:	89 c3                	mov    %eax,%ebx
80104e76:	0f 84 cc 00 00 00    	je     80104f48 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
80104e7c:	83 ec 0c             	sub    $0xc,%esp
80104e7f:	50                   	push   %eax
80104e80:	e8 3b ca ff ff       	call   801018c0 <ilock>
  ip->major = major;
80104e85:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104e89:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
80104e8d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104e91:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
80104e95:	b8 01 00 00 00       	mov    $0x1,%eax
80104e9a:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
80104e9e:	89 1c 24             	mov    %ebx,(%esp)
80104ea1:	e8 6a c9 ff ff       	call   80101810 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80104ea6:	83 c4 10             	add    $0x10,%esp
80104ea9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104eae:	74 40                	je     80104ef0 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80104eb0:	83 ec 04             	sub    $0x4,%esp
80104eb3:	ff 73 04             	pushl  0x4(%ebx)
80104eb6:	56                   	push   %esi
80104eb7:	57                   	push   %edi
80104eb8:	e8 93 d1 ff ff       	call   80102050 <dirlink>
80104ebd:	83 c4 10             	add    $0x10,%esp
80104ec0:	85 c0                	test   %eax,%eax
80104ec2:	78 77                	js     80104f3b <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
80104ec4:	83 ec 0c             	sub    $0xc,%esp
80104ec7:	57                   	push   %edi
80104ec8:	e8 83 cc ff ff       	call   80101b50 <iunlockput>

  return ip;
80104ecd:	83 c4 10             	add    $0x10,%esp
}
80104ed0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
80104ed3:	89 d8                	mov    %ebx,%eax
}
80104ed5:	5b                   	pop    %ebx
80104ed6:	5e                   	pop    %esi
80104ed7:	5f                   	pop    %edi
80104ed8:	5d                   	pop    %ebp
80104ed9:	c3                   	ret    
80104eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80104ee0:	31 c0                	xor    %eax,%eax
80104ee2:	e9 47 ff ff ff       	jmp    80104e2e <create+0x6e>
80104ee7:	89 f6                	mov    %esi,%esi
80104ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80104ef0:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104ef5:	83 ec 0c             	sub    $0xc,%esp
80104ef8:	57                   	push   %edi
80104ef9:	e8 12 c9 ff ff       	call   80101810 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104efe:	83 c4 0c             	add    $0xc,%esp
80104f01:	ff 73 04             	pushl  0x4(%ebx)
80104f04:	68 ec 7d 10 80       	push   $0x80107dec
80104f09:	53                   	push   %ebx
80104f0a:	e8 41 d1 ff ff       	call   80102050 <dirlink>
80104f0f:	83 c4 10             	add    $0x10,%esp
80104f12:	85 c0                	test   %eax,%eax
80104f14:	78 18                	js     80104f2e <create+0x16e>
80104f16:	83 ec 04             	sub    $0x4,%esp
80104f19:	ff 77 04             	pushl  0x4(%edi)
80104f1c:	68 eb 7d 10 80       	push   $0x80107deb
80104f21:	53                   	push   %ebx
80104f22:	e8 29 d1 ff ff       	call   80102050 <dirlink>
80104f27:	83 c4 10             	add    $0x10,%esp
80104f2a:	85 c0                	test   %eax,%eax
80104f2c:	79 82                	jns    80104eb0 <create+0xf0>
      panic("create dots");
80104f2e:	83 ec 0c             	sub    $0xc,%esp
80104f31:	68 df 7d 10 80       	push   $0x80107ddf
80104f36:	e8 35 b4 ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
80104f3b:	83 ec 0c             	sub    $0xc,%esp
80104f3e:	68 ee 7d 10 80       	push   $0x80107dee
80104f43:	e8 28 b4 ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80104f48:	83 ec 0c             	sub    $0xc,%esp
80104f4b:	68 d0 7d 10 80       	push   $0x80107dd0
80104f50:	e8 1b b4 ff ff       	call   80100370 <panic>
80104f55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f60 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104f60:	55                   	push   %ebp
80104f61:	89 e5                	mov    %esp,%ebp
80104f63:	56                   	push   %esi
80104f64:	53                   	push   %ebx
80104f65:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104f67:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104f6a:	89 d3                	mov    %edx,%ebx
80104f6c:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104f6f:	50                   	push   %eax
80104f70:	6a 00                	push   $0x0
80104f72:	e8 f9 fc ff ff       	call   80104c70 <argint>
80104f77:	83 c4 10             	add    $0x10,%esp
80104f7a:	85 c0                	test   %eax,%eax
80104f7c:	78 32                	js     80104fb0 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f7e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f82:	77 2c                	ja     80104fb0 <argfd.constprop.0+0x50>
80104f84:	e8 47 ea ff ff       	call   801039d0 <myproc>
80104f89:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f8c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104f90:	85 c0                	test   %eax,%eax
80104f92:	74 1c                	je     80104fb0 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
80104f94:	85 f6                	test   %esi,%esi
80104f96:	74 02                	je     80104f9a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104f98:	89 16                	mov    %edx,(%esi)
  if(pf)
80104f9a:	85 db                	test   %ebx,%ebx
80104f9c:	74 22                	je     80104fc0 <argfd.constprop.0+0x60>
    *pf = f;
80104f9e:	89 03                	mov    %eax,(%ebx)
  return 0;
80104fa0:	31 c0                	xor    %eax,%eax
}
80104fa2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fa5:	5b                   	pop    %ebx
80104fa6:	5e                   	pop    %esi
80104fa7:	5d                   	pop    %ebp
80104fa8:	c3                   	ret    
80104fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fb0:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80104fb3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
80104fb8:	5b                   	pop    %ebx
80104fb9:	5e                   	pop    %esi
80104fba:	5d                   	pop    %ebp
80104fbb:	c3                   	ret    
80104fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80104fc0:	31 c0                	xor    %eax,%eax
80104fc2:	eb de                	jmp    80104fa2 <argfd.constprop.0+0x42>
80104fc4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104fca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104fd0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104fd0:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104fd1:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80104fd3:	89 e5                	mov    %esp,%ebp
80104fd5:	56                   	push   %esi
80104fd6:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104fd7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
80104fda:	83 ec 10             	sub    $0x10,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104fdd:	e8 7e ff ff ff       	call   80104f60 <argfd.constprop.0>
80104fe2:	85 c0                	test   %eax,%eax
80104fe4:	78 1a                	js     80105000 <sys_dup+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104fe6:	31 db                	xor    %ebx,%ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
80104fe8:	8b 75 f4             	mov    -0xc(%ebp),%esi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80104feb:	e8 e0 e9 ff ff       	call   801039d0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80104ff0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104ff4:	85 d2                	test   %edx,%edx
80104ff6:	74 18                	je     80105010 <sys_dup+0x40>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104ff8:	83 c3 01             	add    $0x1,%ebx
80104ffb:	83 fb 10             	cmp    $0x10,%ebx
80104ffe:	75 f0                	jne    80104ff0 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80105000:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80105003:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80105008:	5b                   	pop    %ebx
80105009:	5e                   	pop    %esi
8010500a:	5d                   	pop    %ebp
8010500b:	c3                   	ret    
8010500c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105010:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80105014:	83 ec 0c             	sub    $0xc,%esp
80105017:	ff 75 f4             	pushl  -0xc(%ebp)
8010501a:	e8 21 c0 ff ff       	call   80101040 <filedup>
  return fd;
8010501f:	83 c4 10             	add    $0x10,%esp
}
80105022:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
80105025:	89 d8                	mov    %ebx,%eax
}
80105027:	5b                   	pop    %ebx
80105028:	5e                   	pop    %esi
80105029:	5d                   	pop    %ebp
8010502a:	c3                   	ret    
8010502b:	90                   	nop
8010502c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105030 <sys_read>:

int
sys_read(void)
{
80105030:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105031:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80105033:	89 e5                	mov    %esp,%ebp
80105035:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105038:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010503b:	e8 20 ff ff ff       	call   80104f60 <argfd.constprop.0>
80105040:	85 c0                	test   %eax,%eax
80105042:	78 4c                	js     80105090 <sys_read+0x60>
80105044:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105047:	83 ec 08             	sub    $0x8,%esp
8010504a:	50                   	push   %eax
8010504b:	6a 02                	push   $0x2
8010504d:	e8 1e fc ff ff       	call   80104c70 <argint>
80105052:	83 c4 10             	add    $0x10,%esp
80105055:	85 c0                	test   %eax,%eax
80105057:	78 37                	js     80105090 <sys_read+0x60>
80105059:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010505c:	83 ec 04             	sub    $0x4,%esp
8010505f:	ff 75 f0             	pushl  -0x10(%ebp)
80105062:	50                   	push   %eax
80105063:	6a 01                	push   $0x1
80105065:	e8 56 fc ff ff       	call   80104cc0 <argptr>
8010506a:	83 c4 10             	add    $0x10,%esp
8010506d:	85 c0                	test   %eax,%eax
8010506f:	78 1f                	js     80105090 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80105071:	83 ec 04             	sub    $0x4,%esp
80105074:	ff 75 f0             	pushl  -0x10(%ebp)
80105077:	ff 75 f4             	pushl  -0xc(%ebp)
8010507a:	ff 75 ec             	pushl  -0x14(%ebp)
8010507d:	e8 2e c1 ff ff       	call   801011b0 <fileread>
80105082:	83 c4 10             	add    $0x10,%esp
}
80105085:	c9                   	leave  
80105086:	c3                   	ret    
80105087:	89 f6                	mov    %esi,%esi
80105089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80105090:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80105095:	c9                   	leave  
80105096:	c3                   	ret    
80105097:	89 f6                	mov    %esi,%esi
80105099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050a0 <sys_write>:

int
sys_write(void)
{
801050a0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050a1:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
801050a3:	89 e5                	mov    %esp,%ebp
801050a5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050a8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801050ab:	e8 b0 fe ff ff       	call   80104f60 <argfd.constprop.0>
801050b0:	85 c0                	test   %eax,%eax
801050b2:	78 4c                	js     80105100 <sys_write+0x60>
801050b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050b7:	83 ec 08             	sub    $0x8,%esp
801050ba:	50                   	push   %eax
801050bb:	6a 02                	push   $0x2
801050bd:	e8 ae fb ff ff       	call   80104c70 <argint>
801050c2:	83 c4 10             	add    $0x10,%esp
801050c5:	85 c0                	test   %eax,%eax
801050c7:	78 37                	js     80105100 <sys_write+0x60>
801050c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050cc:	83 ec 04             	sub    $0x4,%esp
801050cf:	ff 75 f0             	pushl  -0x10(%ebp)
801050d2:	50                   	push   %eax
801050d3:	6a 01                	push   $0x1
801050d5:	e8 e6 fb ff ff       	call   80104cc0 <argptr>
801050da:	83 c4 10             	add    $0x10,%esp
801050dd:	85 c0                	test   %eax,%eax
801050df:	78 1f                	js     80105100 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
801050e1:	83 ec 04             	sub    $0x4,%esp
801050e4:	ff 75 f0             	pushl  -0x10(%ebp)
801050e7:	ff 75 f4             	pushl  -0xc(%ebp)
801050ea:	ff 75 ec             	pushl  -0x14(%ebp)
801050ed:	e8 4e c1 ff ff       	call   80101240 <filewrite>
801050f2:	83 c4 10             	add    $0x10,%esp
}
801050f5:	c9                   	leave  
801050f6:	c3                   	ret    
801050f7:	89 f6                	mov    %esi,%esi
801050f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80105100:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80105105:	c9                   	leave  
80105106:	c3                   	ret    
80105107:	89 f6                	mov    %esi,%esi
80105109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105110 <sys_close>:

int
sys_close(void)
{
80105110:	55                   	push   %ebp
80105111:	89 e5                	mov    %esp,%ebp
80105113:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105116:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105119:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010511c:	e8 3f fe ff ff       	call   80104f60 <argfd.constprop.0>
80105121:	85 c0                	test   %eax,%eax
80105123:	78 2b                	js     80105150 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80105125:	e8 a6 e8 ff ff       	call   801039d0 <myproc>
8010512a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010512d:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
80105130:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105137:	00 
  fileclose(f);
80105138:	ff 75 f4             	pushl  -0xc(%ebp)
8010513b:	e8 50 bf ff ff       	call   80101090 <fileclose>
  return 0;
80105140:	83 c4 10             	add    $0x10,%esp
80105143:	31 c0                	xor    %eax,%eax
}
80105145:	c9                   	leave  
80105146:	c3                   	ret    
80105147:	89 f6                	mov    %esi,%esi
80105149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80105150:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80105155:	c9                   	leave  
80105156:	c3                   	ret    
80105157:	89 f6                	mov    %esi,%esi
80105159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105160 <sys_fstat>:

int
sys_fstat(void)
{
80105160:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105161:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80105163:	89 e5                	mov    %esp,%ebp
80105165:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105168:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010516b:	e8 f0 fd ff ff       	call   80104f60 <argfd.constprop.0>
80105170:	85 c0                	test   %eax,%eax
80105172:	78 2c                	js     801051a0 <sys_fstat+0x40>
80105174:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105177:	83 ec 04             	sub    $0x4,%esp
8010517a:	6a 14                	push   $0x14
8010517c:	50                   	push   %eax
8010517d:	6a 01                	push   $0x1
8010517f:	e8 3c fb ff ff       	call   80104cc0 <argptr>
80105184:	83 c4 10             	add    $0x10,%esp
80105187:	85 c0                	test   %eax,%eax
80105189:	78 15                	js     801051a0 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
8010518b:	83 ec 08             	sub    $0x8,%esp
8010518e:	ff 75 f4             	pushl  -0xc(%ebp)
80105191:	ff 75 f0             	pushl  -0x10(%ebp)
80105194:	e8 c7 bf ff ff       	call   80101160 <filestat>
80105199:	83 c4 10             	add    $0x10,%esp
}
8010519c:	c9                   	leave  
8010519d:	c3                   	ret    
8010519e:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
801051a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
801051a5:	c9                   	leave  
801051a6:	c3                   	ret    
801051a7:	89 f6                	mov    %esi,%esi
801051a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051b0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801051b0:	55                   	push   %ebp
801051b1:	89 e5                	mov    %esp,%ebp
801051b3:	57                   	push   %edi
801051b4:	56                   	push   %esi
801051b5:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801051b6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801051b9:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801051bc:	50                   	push   %eax
801051bd:	6a 00                	push   $0x0
801051bf:	e8 5c fb ff ff       	call   80104d20 <argstr>
801051c4:	83 c4 10             	add    $0x10,%esp
801051c7:	85 c0                	test   %eax,%eax
801051c9:	0f 88 fb 00 00 00    	js     801052ca <sys_link+0x11a>
801051cf:	8d 45 d0             	lea    -0x30(%ebp),%eax
801051d2:	83 ec 08             	sub    $0x8,%esp
801051d5:	50                   	push   %eax
801051d6:	6a 01                	push   $0x1
801051d8:	e8 43 fb ff ff       	call   80104d20 <argstr>
801051dd:	83 c4 10             	add    $0x10,%esp
801051e0:	85 c0                	test   %eax,%eax
801051e2:	0f 88 e2 00 00 00    	js     801052ca <sys_link+0x11a>
    return -1;

  begin_op();
801051e8:	e8 b3 db ff ff       	call   80102da0 <begin_op>
  if((ip = namei(old)) == 0){
801051ed:	83 ec 0c             	sub    $0xc,%esp
801051f0:	ff 75 d4             	pushl  -0x2c(%ebp)
801051f3:	e8 18 cf ff ff       	call   80102110 <namei>
801051f8:	83 c4 10             	add    $0x10,%esp
801051fb:	85 c0                	test   %eax,%eax
801051fd:	89 c3                	mov    %eax,%ebx
801051ff:	0f 84 f3 00 00 00    	je     801052f8 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
80105205:	83 ec 0c             	sub    $0xc,%esp
80105208:	50                   	push   %eax
80105209:	e8 b2 c6 ff ff       	call   801018c0 <ilock>
  if(ip->type == T_DIR){
8010520e:	83 c4 10             	add    $0x10,%esp
80105211:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105216:	0f 84 c4 00 00 00    	je     801052e0 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
8010521c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105221:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105224:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80105227:	53                   	push   %ebx
80105228:	e8 e3 c5 ff ff       	call   80101810 <iupdate>
  iunlock(ip);
8010522d:	89 1c 24             	mov    %ebx,(%esp)
80105230:	e8 6b c7 ff ff       	call   801019a0 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105235:	58                   	pop    %eax
80105236:	5a                   	pop    %edx
80105237:	57                   	push   %edi
80105238:	ff 75 d0             	pushl  -0x30(%ebp)
8010523b:	e8 f0 ce ff ff       	call   80102130 <nameiparent>
80105240:	83 c4 10             	add    $0x10,%esp
80105243:	85 c0                	test   %eax,%eax
80105245:	89 c6                	mov    %eax,%esi
80105247:	74 5b                	je     801052a4 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80105249:	83 ec 0c             	sub    $0xc,%esp
8010524c:	50                   	push   %eax
8010524d:	e8 6e c6 ff ff       	call   801018c0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105252:	83 c4 10             	add    $0x10,%esp
80105255:	8b 03                	mov    (%ebx),%eax
80105257:	39 06                	cmp    %eax,(%esi)
80105259:	75 3d                	jne    80105298 <sys_link+0xe8>
8010525b:	83 ec 04             	sub    $0x4,%esp
8010525e:	ff 73 04             	pushl  0x4(%ebx)
80105261:	57                   	push   %edi
80105262:	56                   	push   %esi
80105263:	e8 e8 cd ff ff       	call   80102050 <dirlink>
80105268:	83 c4 10             	add    $0x10,%esp
8010526b:	85 c0                	test   %eax,%eax
8010526d:	78 29                	js     80105298 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
8010526f:	83 ec 0c             	sub    $0xc,%esp
80105272:	56                   	push   %esi
80105273:	e8 d8 c8 ff ff       	call   80101b50 <iunlockput>
  iput(ip);
80105278:	89 1c 24             	mov    %ebx,(%esp)
8010527b:	e8 70 c7 ff ff       	call   801019f0 <iput>

  end_op();
80105280:	e8 8b db ff ff       	call   80102e10 <end_op>

  return 0;
80105285:	83 c4 10             	add    $0x10,%esp
80105288:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
8010528a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010528d:	5b                   	pop    %ebx
8010528e:	5e                   	pop    %esi
8010528f:	5f                   	pop    %edi
80105290:	5d                   	pop    %ebp
80105291:	c3                   	ret    
80105292:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80105298:	83 ec 0c             	sub    $0xc,%esp
8010529b:	56                   	push   %esi
8010529c:	e8 af c8 ff ff       	call   80101b50 <iunlockput>
    goto bad;
801052a1:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
801052a4:	83 ec 0c             	sub    $0xc,%esp
801052a7:	53                   	push   %ebx
801052a8:	e8 13 c6 ff ff       	call   801018c0 <ilock>
  ip->nlink--;
801052ad:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801052b2:	89 1c 24             	mov    %ebx,(%esp)
801052b5:	e8 56 c5 ff ff       	call   80101810 <iupdate>
  iunlockput(ip);
801052ba:	89 1c 24             	mov    %ebx,(%esp)
801052bd:	e8 8e c8 ff ff       	call   80101b50 <iunlockput>
  end_op();
801052c2:	e8 49 db ff ff       	call   80102e10 <end_op>
  return -1;
801052c7:	83 c4 10             	add    $0x10,%esp
}
801052ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
801052cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052d2:	5b                   	pop    %ebx
801052d3:	5e                   	pop    %esi
801052d4:	5f                   	pop    %edi
801052d5:	5d                   	pop    %ebp
801052d6:	c3                   	ret    
801052d7:	89 f6                	mov    %esi,%esi
801052d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
801052e0:	83 ec 0c             	sub    $0xc,%esp
801052e3:	53                   	push   %ebx
801052e4:	e8 67 c8 ff ff       	call   80101b50 <iunlockput>
    end_op();
801052e9:	e8 22 db ff ff       	call   80102e10 <end_op>
    return -1;
801052ee:	83 c4 10             	add    $0x10,%esp
801052f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052f6:	eb 92                	jmp    8010528a <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
801052f8:	e8 13 db ff ff       	call   80102e10 <end_op>
    return -1;
801052fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105302:	eb 86                	jmp    8010528a <sys_link+0xda>
80105304:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010530a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105310 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105310:	55                   	push   %ebp
80105311:	89 e5                	mov    %esp,%ebp
80105313:	57                   	push   %edi
80105314:	56                   	push   %esi
80105315:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105316:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105319:	83 ec 54             	sub    $0x54,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
8010531c:	50                   	push   %eax
8010531d:	6a 00                	push   $0x0
8010531f:	e8 fc f9 ff ff       	call   80104d20 <argstr>
80105324:	83 c4 10             	add    $0x10,%esp
80105327:	85 c0                	test   %eax,%eax
80105329:	0f 88 82 01 00 00    	js     801054b1 <sys_unlink+0x1a1>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
8010532f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
80105332:	e8 69 da ff ff       	call   80102da0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105337:	83 ec 08             	sub    $0x8,%esp
8010533a:	53                   	push   %ebx
8010533b:	ff 75 c0             	pushl  -0x40(%ebp)
8010533e:	e8 ed cd ff ff       	call   80102130 <nameiparent>
80105343:	83 c4 10             	add    $0x10,%esp
80105346:	85 c0                	test   %eax,%eax
80105348:	89 45 b4             	mov    %eax,-0x4c(%ebp)
8010534b:	0f 84 6a 01 00 00    	je     801054bb <sys_unlink+0x1ab>
    end_op();
    return -1;
  }

  ilock(dp);
80105351:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80105354:	83 ec 0c             	sub    $0xc,%esp
80105357:	56                   	push   %esi
80105358:	e8 63 c5 ff ff       	call   801018c0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010535d:	58                   	pop    %eax
8010535e:	5a                   	pop    %edx
8010535f:	68 ec 7d 10 80       	push   $0x80107dec
80105364:	53                   	push   %ebx
80105365:	e8 66 ca ff ff       	call   80101dd0 <namecmp>
8010536a:	83 c4 10             	add    $0x10,%esp
8010536d:	85 c0                	test   %eax,%eax
8010536f:	0f 84 fc 00 00 00    	je     80105471 <sys_unlink+0x161>
80105375:	83 ec 08             	sub    $0x8,%esp
80105378:	68 eb 7d 10 80       	push   $0x80107deb
8010537d:	53                   	push   %ebx
8010537e:	e8 4d ca ff ff       	call   80101dd0 <namecmp>
80105383:	83 c4 10             	add    $0x10,%esp
80105386:	85 c0                	test   %eax,%eax
80105388:	0f 84 e3 00 00 00    	je     80105471 <sys_unlink+0x161>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010538e:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105391:	83 ec 04             	sub    $0x4,%esp
80105394:	50                   	push   %eax
80105395:	53                   	push   %ebx
80105396:	56                   	push   %esi
80105397:	e8 54 ca ff ff       	call   80101df0 <dirlookup>
8010539c:	83 c4 10             	add    $0x10,%esp
8010539f:	85 c0                	test   %eax,%eax
801053a1:	89 c3                	mov    %eax,%ebx
801053a3:	0f 84 c8 00 00 00    	je     80105471 <sys_unlink+0x161>
    goto bad;
  ilock(ip);
801053a9:	83 ec 0c             	sub    $0xc,%esp
801053ac:	50                   	push   %eax
801053ad:	e8 0e c5 ff ff       	call   801018c0 <ilock>

  if(ip->nlink < 1)
801053b2:	83 c4 10             	add    $0x10,%esp
801053b5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801053ba:	0f 8e 24 01 00 00    	jle    801054e4 <sys_unlink+0x1d4>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801053c0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053c5:	8d 75 d8             	lea    -0x28(%ebp),%esi
801053c8:	74 66                	je     80105430 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
801053ca:	83 ec 04             	sub    $0x4,%esp
801053cd:	6a 10                	push   $0x10
801053cf:	6a 00                	push   $0x0
801053d1:	56                   	push   %esi
801053d2:	e8 89 f5 ff ff       	call   80104960 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801053d7:	6a 10                	push   $0x10
801053d9:	ff 75 c4             	pushl  -0x3c(%ebp)
801053dc:	56                   	push   %esi
801053dd:	ff 75 b4             	pushl  -0x4c(%ebp)
801053e0:	e8 bb c8 ff ff       	call   80101ca0 <writei>
801053e5:	83 c4 20             	add    $0x20,%esp
801053e8:	83 f8 10             	cmp    $0x10,%eax
801053eb:	0f 85 e6 00 00 00    	jne    801054d7 <sys_unlink+0x1c7>
    panic("unlink: writei");
  if(ip->type == T_DIR){
801053f1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053f6:	0f 84 9c 00 00 00    	je     80105498 <sys_unlink+0x188>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
801053fc:	83 ec 0c             	sub    $0xc,%esp
801053ff:	ff 75 b4             	pushl  -0x4c(%ebp)
80105402:	e8 49 c7 ff ff       	call   80101b50 <iunlockput>

  ip->nlink--;
80105407:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010540c:	89 1c 24             	mov    %ebx,(%esp)
8010540f:	e8 fc c3 ff ff       	call   80101810 <iupdate>
  iunlockput(ip);
80105414:	89 1c 24             	mov    %ebx,(%esp)
80105417:	e8 34 c7 ff ff       	call   80101b50 <iunlockput>

  end_op();
8010541c:	e8 ef d9 ff ff       	call   80102e10 <end_op>

  return 0;
80105421:	83 c4 10             	add    $0x10,%esp
80105424:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80105426:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105429:	5b                   	pop    %ebx
8010542a:	5e                   	pop    %esi
8010542b:	5f                   	pop    %edi
8010542c:	5d                   	pop    %ebp
8010542d:	c3                   	ret    
8010542e:	66 90                	xchg   %ax,%ax
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105430:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105434:	76 94                	jbe    801053ca <sys_unlink+0xba>
80105436:	bf 20 00 00 00       	mov    $0x20,%edi
8010543b:	eb 0f                	jmp    8010544c <sys_unlink+0x13c>
8010543d:	8d 76 00             	lea    0x0(%esi),%esi
80105440:	83 c7 10             	add    $0x10,%edi
80105443:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105446:	0f 83 7e ff ff ff    	jae    801053ca <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010544c:	6a 10                	push   $0x10
8010544e:	57                   	push   %edi
8010544f:	56                   	push   %esi
80105450:	53                   	push   %ebx
80105451:	e8 4a c7 ff ff       	call   80101ba0 <readi>
80105456:	83 c4 10             	add    $0x10,%esp
80105459:	83 f8 10             	cmp    $0x10,%eax
8010545c:	75 6c                	jne    801054ca <sys_unlink+0x1ba>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010545e:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105463:	74 db                	je     80105440 <sys_unlink+0x130>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80105465:	83 ec 0c             	sub    $0xc,%esp
80105468:	53                   	push   %ebx
80105469:	e8 e2 c6 ff ff       	call   80101b50 <iunlockput>
    goto bad;
8010546e:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
80105471:	83 ec 0c             	sub    $0xc,%esp
80105474:	ff 75 b4             	pushl  -0x4c(%ebp)
80105477:	e8 d4 c6 ff ff       	call   80101b50 <iunlockput>
  end_op();
8010547c:	e8 8f d9 ff ff       	call   80102e10 <end_op>
  return -1;
80105481:	83 c4 10             	add    $0x10,%esp
}
80105484:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80105487:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010548c:	5b                   	pop    %ebx
8010548d:	5e                   	pop    %esi
8010548e:	5f                   	pop    %edi
8010548f:	5d                   	pop    %ebp
80105490:	c3                   	ret    
80105491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80105498:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
8010549b:	83 ec 0c             	sub    $0xc,%esp

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
8010549e:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801054a3:	50                   	push   %eax
801054a4:	e8 67 c3 ff ff       	call   80101810 <iupdate>
801054a9:	83 c4 10             	add    $0x10,%esp
801054ac:	e9 4b ff ff ff       	jmp    801053fc <sys_unlink+0xec>
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
801054b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054b6:	e9 6b ff ff ff       	jmp    80105426 <sys_unlink+0x116>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
801054bb:	e8 50 d9 ff ff       	call   80102e10 <end_op>
    return -1;
801054c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054c5:	e9 5c ff ff ff       	jmp    80105426 <sys_unlink+0x116>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
801054ca:	83 ec 0c             	sub    $0xc,%esp
801054cd:	68 10 7e 10 80       	push   $0x80107e10
801054d2:	e8 99 ae ff ff       	call   80100370 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
801054d7:	83 ec 0c             	sub    $0xc,%esp
801054da:	68 22 7e 10 80       	push   $0x80107e22
801054df:	e8 8c ae ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
801054e4:	83 ec 0c             	sub    $0xc,%esp
801054e7:	68 fe 7d 10 80       	push   $0x80107dfe
801054ec:	e8 7f ae ff ff       	call   80100370 <panic>
801054f1:	eb 0d                	jmp    80105500 <sys_open>
801054f3:	90                   	nop
801054f4:	90                   	nop
801054f5:	90                   	nop
801054f6:	90                   	nop
801054f7:	90                   	nop
801054f8:	90                   	nop
801054f9:	90                   	nop
801054fa:	90                   	nop
801054fb:	90                   	nop
801054fc:	90                   	nop
801054fd:	90                   	nop
801054fe:	90                   	nop
801054ff:	90                   	nop

80105500 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80105500:	55                   	push   %ebp
80105501:	89 e5                	mov    %esp,%ebp
80105503:	57                   	push   %edi
80105504:	56                   	push   %esi
80105505:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105506:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
80105509:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010550c:	50                   	push   %eax
8010550d:	6a 00                	push   $0x0
8010550f:	e8 0c f8 ff ff       	call   80104d20 <argstr>
80105514:	83 c4 10             	add    $0x10,%esp
80105517:	85 c0                	test   %eax,%eax
80105519:	0f 88 9e 00 00 00    	js     801055bd <sys_open+0xbd>
8010551f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105522:	83 ec 08             	sub    $0x8,%esp
80105525:	50                   	push   %eax
80105526:	6a 01                	push   $0x1
80105528:	e8 43 f7 ff ff       	call   80104c70 <argint>
8010552d:	83 c4 10             	add    $0x10,%esp
80105530:	85 c0                	test   %eax,%eax
80105532:	0f 88 85 00 00 00    	js     801055bd <sys_open+0xbd>
    return -1;

  begin_op();
80105538:	e8 63 d8 ff ff       	call   80102da0 <begin_op>

  if(omode & O_CREATE){
8010553d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105541:	0f 85 89 00 00 00    	jne    801055d0 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105547:	83 ec 0c             	sub    $0xc,%esp
8010554a:	ff 75 e0             	pushl  -0x20(%ebp)
8010554d:	e8 be cb ff ff       	call   80102110 <namei>
80105552:	83 c4 10             	add    $0x10,%esp
80105555:	85 c0                	test   %eax,%eax
80105557:	89 c6                	mov    %eax,%esi
80105559:	0f 84 8e 00 00 00    	je     801055ed <sys_open+0xed>
      end_op();
      return -1;
    }
    ilock(ip);
8010555f:	83 ec 0c             	sub    $0xc,%esp
80105562:	50                   	push   %eax
80105563:	e8 58 c3 ff ff       	call   801018c0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105568:	83 c4 10             	add    $0x10,%esp
8010556b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105570:	0f 84 d2 00 00 00    	je     80105648 <sys_open+0x148>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105576:	e8 55 ba ff ff       	call   80100fd0 <filealloc>
8010557b:	85 c0                	test   %eax,%eax
8010557d:	89 c7                	mov    %eax,%edi
8010557f:	74 2b                	je     801055ac <sys_open+0xac>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105581:	31 db                	xor    %ebx,%ebx
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105583:	e8 48 e4 ff ff       	call   801039d0 <myproc>
80105588:	90                   	nop
80105589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105590:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105594:	85 d2                	test   %edx,%edx
80105596:	74 68                	je     80105600 <sys_open+0x100>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105598:	83 c3 01             	add    $0x1,%ebx
8010559b:	83 fb 10             	cmp    $0x10,%ebx
8010559e:	75 f0                	jne    80105590 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
801055a0:	83 ec 0c             	sub    $0xc,%esp
801055a3:	57                   	push   %edi
801055a4:	e8 e7 ba ff ff       	call   80101090 <fileclose>
801055a9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801055ac:	83 ec 0c             	sub    $0xc,%esp
801055af:	56                   	push   %esi
801055b0:	e8 9b c5 ff ff       	call   80101b50 <iunlockput>
    end_op();
801055b5:	e8 56 d8 ff ff       	call   80102e10 <end_op>
    return -1;
801055ba:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801055bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
801055c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801055c5:	5b                   	pop    %ebx
801055c6:	5e                   	pop    %esi
801055c7:	5f                   	pop    %edi
801055c8:	5d                   	pop    %ebp
801055c9:	c3                   	ret    
801055ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
801055d0:	83 ec 0c             	sub    $0xc,%esp
801055d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801055d6:	31 c9                	xor    %ecx,%ecx
801055d8:	6a 00                	push   $0x0
801055da:	ba 02 00 00 00       	mov    $0x2,%edx
801055df:	e8 dc f7 ff ff       	call   80104dc0 <create>
    if(ip == 0){
801055e4:	83 c4 10             	add    $0x10,%esp
801055e7:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
801055e9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801055eb:	75 89                	jne    80105576 <sys_open+0x76>
      end_op();
801055ed:	e8 1e d8 ff ff       	call   80102e10 <end_op>
      return -1;
801055f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055f7:	eb 43                	jmp    8010563c <sys_open+0x13c>
801055f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105600:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105603:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105607:	56                   	push   %esi
80105608:	e8 93 c3 ff ff       	call   801019a0 <iunlock>
  end_op();
8010560d:	e8 fe d7 ff ff       	call   80102e10 <end_op>

  f->type = FD_INODE;
80105612:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105618:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010561b:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
8010561e:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105621:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105628:	89 d0                	mov    %edx,%eax
8010562a:	83 e0 01             	and    $0x1,%eax
8010562d:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105630:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105633:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105636:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
8010563a:	89 d8                	mov    %ebx,%eax
}
8010563c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010563f:	5b                   	pop    %ebx
80105640:	5e                   	pop    %esi
80105641:	5f                   	pop    %edi
80105642:	5d                   	pop    %ebp
80105643:	c3                   	ret    
80105644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80105648:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010564b:	85 c9                	test   %ecx,%ecx
8010564d:	0f 84 23 ff ff ff    	je     80105576 <sys_open+0x76>
80105653:	e9 54 ff ff ff       	jmp    801055ac <sys_open+0xac>
80105658:	90                   	nop
80105659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105660 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80105660:	55                   	push   %ebp
80105661:	89 e5                	mov    %esp,%ebp
80105663:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105666:	e8 35 d7 ff ff       	call   80102da0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010566b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010566e:	83 ec 08             	sub    $0x8,%esp
80105671:	50                   	push   %eax
80105672:	6a 00                	push   $0x0
80105674:	e8 a7 f6 ff ff       	call   80104d20 <argstr>
80105679:	83 c4 10             	add    $0x10,%esp
8010567c:	85 c0                	test   %eax,%eax
8010567e:	78 30                	js     801056b0 <sys_mkdir+0x50>
80105680:	83 ec 0c             	sub    $0xc,%esp
80105683:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105686:	31 c9                	xor    %ecx,%ecx
80105688:	6a 00                	push   $0x0
8010568a:	ba 01 00 00 00       	mov    $0x1,%edx
8010568f:	e8 2c f7 ff ff       	call   80104dc0 <create>
80105694:	83 c4 10             	add    $0x10,%esp
80105697:	85 c0                	test   %eax,%eax
80105699:	74 15                	je     801056b0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010569b:	83 ec 0c             	sub    $0xc,%esp
8010569e:	50                   	push   %eax
8010569f:	e8 ac c4 ff ff       	call   80101b50 <iunlockput>
  end_op();
801056a4:	e8 67 d7 ff ff       	call   80102e10 <end_op>
  return 0;
801056a9:	83 c4 10             	add    $0x10,%esp
801056ac:	31 c0                	xor    %eax,%eax
}
801056ae:	c9                   	leave  
801056af:	c3                   	ret    
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
801056b0:	e8 5b d7 ff ff       	call   80102e10 <end_op>
    return -1;
801056b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
801056ba:	c9                   	leave  
801056bb:	c3                   	ret    
801056bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056c0 <sys_mknod>:

int
sys_mknod(void)
{
801056c0:	55                   	push   %ebp
801056c1:	89 e5                	mov    %esp,%ebp
801056c3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801056c6:	e8 d5 d6 ff ff       	call   80102da0 <begin_op>
  if((argstr(0, &path)) < 0 ||
801056cb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801056ce:	83 ec 08             	sub    $0x8,%esp
801056d1:	50                   	push   %eax
801056d2:	6a 00                	push   $0x0
801056d4:	e8 47 f6 ff ff       	call   80104d20 <argstr>
801056d9:	83 c4 10             	add    $0x10,%esp
801056dc:	85 c0                	test   %eax,%eax
801056de:	78 60                	js     80105740 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801056e0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056e3:	83 ec 08             	sub    $0x8,%esp
801056e6:	50                   	push   %eax
801056e7:	6a 01                	push   $0x1
801056e9:	e8 82 f5 ff ff       	call   80104c70 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
801056ee:	83 c4 10             	add    $0x10,%esp
801056f1:	85 c0                	test   %eax,%eax
801056f3:	78 4b                	js     80105740 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801056f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056f8:	83 ec 08             	sub    $0x8,%esp
801056fb:	50                   	push   %eax
801056fc:	6a 02                	push   $0x2
801056fe:	e8 6d f5 ff ff       	call   80104c70 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105703:	83 c4 10             	add    $0x10,%esp
80105706:	85 c0                	test   %eax,%eax
80105708:	78 36                	js     80105740 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
8010570a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010570e:	83 ec 0c             	sub    $0xc,%esp
80105711:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105715:	ba 03 00 00 00       	mov    $0x3,%edx
8010571a:	50                   	push   %eax
8010571b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010571e:	e8 9d f6 ff ff       	call   80104dc0 <create>
80105723:	83 c4 10             	add    $0x10,%esp
80105726:	85 c0                	test   %eax,%eax
80105728:	74 16                	je     80105740 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
8010572a:	83 ec 0c             	sub    $0xc,%esp
8010572d:	50                   	push   %eax
8010572e:	e8 1d c4 ff ff       	call   80101b50 <iunlockput>
  end_op();
80105733:	e8 d8 d6 ff ff       	call   80102e10 <end_op>
  return 0;
80105738:	83 c4 10             	add    $0x10,%esp
8010573b:	31 c0                	xor    %eax,%eax
}
8010573d:	c9                   	leave  
8010573e:	c3                   	ret    
8010573f:	90                   	nop
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105740:	e8 cb d6 ff ff       	call   80102e10 <end_op>
    return -1;
80105745:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010574a:	c9                   	leave  
8010574b:	c3                   	ret    
8010574c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105750 <sys_chdir>:

int
sys_chdir(void)
{
80105750:	55                   	push   %ebp
80105751:	89 e5                	mov    %esp,%ebp
80105753:	56                   	push   %esi
80105754:	53                   	push   %ebx
80105755:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105758:	e8 73 e2 ff ff       	call   801039d0 <myproc>
8010575d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010575f:	e8 3c d6 ff ff       	call   80102da0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105764:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105767:	83 ec 08             	sub    $0x8,%esp
8010576a:	50                   	push   %eax
8010576b:	6a 00                	push   $0x0
8010576d:	e8 ae f5 ff ff       	call   80104d20 <argstr>
80105772:	83 c4 10             	add    $0x10,%esp
80105775:	85 c0                	test   %eax,%eax
80105777:	78 77                	js     801057f0 <sys_chdir+0xa0>
80105779:	83 ec 0c             	sub    $0xc,%esp
8010577c:	ff 75 f4             	pushl  -0xc(%ebp)
8010577f:	e8 8c c9 ff ff       	call   80102110 <namei>
80105784:	83 c4 10             	add    $0x10,%esp
80105787:	85 c0                	test   %eax,%eax
80105789:	89 c3                	mov    %eax,%ebx
8010578b:	74 63                	je     801057f0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010578d:	83 ec 0c             	sub    $0xc,%esp
80105790:	50                   	push   %eax
80105791:	e8 2a c1 ff ff       	call   801018c0 <ilock>
  if(ip->type != T_DIR){
80105796:	83 c4 10             	add    $0x10,%esp
80105799:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010579e:	75 30                	jne    801057d0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801057a0:	83 ec 0c             	sub    $0xc,%esp
801057a3:	53                   	push   %ebx
801057a4:	e8 f7 c1 ff ff       	call   801019a0 <iunlock>
  iput(curproc->cwd);
801057a9:	58                   	pop    %eax
801057aa:	ff 76 68             	pushl  0x68(%esi)
801057ad:	e8 3e c2 ff ff       	call   801019f0 <iput>
  end_op();
801057b2:	e8 59 d6 ff ff       	call   80102e10 <end_op>
  curproc->cwd = ip;
801057b7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801057ba:	83 c4 10             	add    $0x10,%esp
801057bd:	31 c0                	xor    %eax,%eax
}
801057bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801057c2:	5b                   	pop    %ebx
801057c3:	5e                   	pop    %esi
801057c4:	5d                   	pop    %ebp
801057c5:	c3                   	ret    
801057c6:	8d 76 00             	lea    0x0(%esi),%esi
801057c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
801057d0:	83 ec 0c             	sub    $0xc,%esp
801057d3:	53                   	push   %ebx
801057d4:	e8 77 c3 ff ff       	call   80101b50 <iunlockput>
    end_op();
801057d9:	e8 32 d6 ff ff       	call   80102e10 <end_op>
    return -1;
801057de:	83 c4 10             	add    $0x10,%esp
801057e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057e6:	eb d7                	jmp    801057bf <sys_chdir+0x6f>
801057e8:	90                   	nop
801057e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct inode *ip;
  struct proc *curproc = myproc();
  
  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
801057f0:	e8 1b d6 ff ff       	call   80102e10 <end_op>
    return -1;
801057f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057fa:	eb c3                	jmp    801057bf <sys_chdir+0x6f>
801057fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105800 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
80105800:	55                   	push   %ebp
80105801:	89 e5                	mov    %esp,%ebp
80105803:	57                   	push   %edi
80105804:	56                   	push   %esi
80105805:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105806:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
8010580c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105812:	50                   	push   %eax
80105813:	6a 00                	push   $0x0
80105815:	e8 06 f5 ff ff       	call   80104d20 <argstr>
8010581a:	83 c4 10             	add    $0x10,%esp
8010581d:	85 c0                	test   %eax,%eax
8010581f:	0f 88 ab 00 00 00    	js     801058d0 <sys_exec+0xd0>
80105825:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010582b:	83 ec 08             	sub    $0x8,%esp
8010582e:	50                   	push   %eax
8010582f:	6a 01                	push   $0x1
80105831:	e8 3a f4 ff ff       	call   80104c70 <argint>
80105836:	83 c4 10             	add    $0x10,%esp
80105839:	85 c0                	test   %eax,%eax
8010583b:	0f 88 8f 00 00 00    	js     801058d0 <sys_exec+0xd0>
    return -1;
  }
  cprintf("1\n");
80105841:	83 ec 0c             	sub    $0xc,%esp
80105844:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
8010584a:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105850:	68 31 7e 10 80       	push   $0x80107e31
  cprintf("%s\n",path);
  memset(argv, 0, sizeof(argv));
80105855:	31 db                	xor    %ebx,%ebx
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  cprintf("1\n");
80105857:	e8 04 ae ff ff       	call   80100660 <cprintf>
  cprintf("%s\n",path);
8010585c:	58                   	pop    %eax
8010585d:	5a                   	pop    %edx
8010585e:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105864:	68 34 7e 10 80       	push   $0x80107e34
80105869:	e8 f2 ad ff ff       	call   80100660 <cprintf>
  memset(argv, 0, sizeof(argv));
8010586e:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105874:	83 c4 0c             	add    $0xc,%esp
80105877:	68 80 00 00 00       	push   $0x80
8010587c:	6a 00                	push   $0x0
8010587e:	50                   	push   %eax
8010587f:	e8 dc f0 ff ff       	call   80104960 <memset>
80105884:	83 c4 10             	add    $0x10,%esp
80105887:	89 f6                	mov    %esi,%esi
80105889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105890:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105896:	83 ec 08             	sub    $0x8,%esp
80105899:	57                   	push   %edi
8010589a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010589d:	50                   	push   %eax
8010589e:	e8 2d f3 ff ff       	call   80104bd0 <fetchint>
801058a3:	83 c4 10             	add    $0x10,%esp
801058a6:	85 c0                	test   %eax,%eax
801058a8:	78 26                	js     801058d0 <sys_exec+0xd0>
      return -1;
    if(uarg == 0){
801058aa:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801058b0:	85 c0                	test   %eax,%eax
801058b2:	74 2c                	je     801058e0 <sys_exec+0xe0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801058b4:	83 ec 08             	sub    $0x8,%esp
801058b7:	56                   	push   %esi
801058b8:	50                   	push   %eax
801058b9:	e8 52 f3 ff ff       	call   80104c10 <fetchstr>
801058be:	83 c4 10             	add    $0x10,%esp
801058c1:	85 c0                	test   %eax,%eax
801058c3:	78 0b                	js     801058d0 <sys_exec+0xd0>
    return -1;
  }
  cprintf("1\n");
  cprintf("%s\n",path);
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801058c5:	83 c3 01             	add    $0x1,%ebx
801058c8:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
801058cb:	83 fb 20             	cmp    $0x20,%ebx
801058ce:	75 c0                	jne    80105890 <sys_exec+0x90>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801058d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
801058d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801058d8:	5b                   	pop    %ebx
801058d9:	5e                   	pop    %esi
801058da:	5f                   	pop    %edi
801058db:	5d                   	pop    %ebp
801058dc:	c3                   	ret    
801058dd:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801058e0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801058e6:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
801058e9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801058f0:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801058f4:	50                   	push   %eax
801058f5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801058fb:	e8 10 b1 ff ff       	call   80100a10 <exec>
80105900:	83 c4 10             	add    $0x10,%esp
}
80105903:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105906:	5b                   	pop    %ebx
80105907:	5e                   	pop    %esi
80105908:	5f                   	pop    %edi
80105909:	5d                   	pop    %ebp
8010590a:	c3                   	ret    
8010590b:	90                   	nop
8010590c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105910 <sys_pipe>:

int
sys_pipe(void)
{
80105910:	55                   	push   %ebp
80105911:	89 e5                	mov    %esp,%ebp
80105913:	57                   	push   %edi
80105914:	56                   	push   %esi
80105915:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105916:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
80105919:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010591c:	6a 08                	push   $0x8
8010591e:	50                   	push   %eax
8010591f:	6a 00                	push   $0x0
80105921:	e8 9a f3 ff ff       	call   80104cc0 <argptr>
80105926:	83 c4 10             	add    $0x10,%esp
80105929:	85 c0                	test   %eax,%eax
8010592b:	78 4a                	js     80105977 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010592d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105930:	83 ec 08             	sub    $0x8,%esp
80105933:	50                   	push   %eax
80105934:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105937:	50                   	push   %eax
80105938:	e8 03 db ff ff       	call   80103440 <pipealloc>
8010593d:	83 c4 10             	add    $0x10,%esp
80105940:	85 c0                	test   %eax,%eax
80105942:	78 33                	js     80105977 <sys_pipe+0x67>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105944:	31 db                	xor    %ebx,%ebx
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105946:	8b 7d e0             	mov    -0x20(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105949:	e8 82 e0 ff ff       	call   801039d0 <myproc>
8010594e:	66 90                	xchg   %ax,%ax

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105950:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105954:	85 f6                	test   %esi,%esi
80105956:	74 30                	je     80105988 <sys_pipe+0x78>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105958:	83 c3 01             	add    $0x1,%ebx
8010595b:	83 fb 10             	cmp    $0x10,%ebx
8010595e:	75 f0                	jne    80105950 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105960:	83 ec 0c             	sub    $0xc,%esp
80105963:	ff 75 e0             	pushl  -0x20(%ebp)
80105966:	e8 25 b7 ff ff       	call   80101090 <fileclose>
    fileclose(wf);
8010596b:	58                   	pop    %eax
8010596c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010596f:	e8 1c b7 ff ff       	call   80101090 <fileclose>
    return -1;
80105974:	83 c4 10             	add    $0x10,%esp
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105977:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
8010597a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
8010597f:	5b                   	pop    %ebx
80105980:	5e                   	pop    %esi
80105981:	5f                   	pop    %edi
80105982:	5d                   	pop    %ebp
80105983:	c3                   	ret    
80105984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105988:	8d 73 08             	lea    0x8(%ebx),%esi
8010598b:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010598f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105992:	e8 39 e0 ff ff       	call   801039d0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
80105997:	31 d2                	xor    %edx,%edx
80105999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801059a0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801059a4:	85 c9                	test   %ecx,%ecx
801059a6:	74 18                	je     801059c0 <sys_pipe+0xb0>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801059a8:	83 c2 01             	add    $0x1,%edx
801059ab:	83 fa 10             	cmp    $0x10,%edx
801059ae:	75 f0                	jne    801059a0 <sys_pipe+0x90>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
801059b0:	e8 1b e0 ff ff       	call   801039d0 <myproc>
801059b5:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801059bc:	00 
801059bd:	eb a1                	jmp    80105960 <sys_pipe+0x50>
801059bf:	90                   	nop
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
801059c0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801059c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801059c7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801059c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801059cc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
801059cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
801059d2:	31 c0                	xor    %eax,%eax
}
801059d4:	5b                   	pop    %ebx
801059d5:	5e                   	pop    %esi
801059d6:	5f                   	pop    %edi
801059d7:	5d                   	pop    %ebp
801059d8:	c3                   	ret    
801059d9:	66 90                	xchg   %ax,%ax
801059db:	66 90                	xchg   %ax,%ax
801059dd:	66 90                	xchg   %ax,%ax
801059df:	90                   	nop

801059e0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801059e0:	55                   	push   %ebp
801059e1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801059e3:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
801059e4:	e9 87 e1 ff ff       	jmp    80103b70 <fork>
801059e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801059f0 <sys_exit>:
}

int
sys_exit(void)
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	83 ec 08             	sub    $0x8,%esp
  exit();
801059f6:	e8 05 e4 ff ff       	call   80103e00 <exit>
  return 0;  // not reached
}
801059fb:	31 c0                	xor    %eax,%eax
801059fd:	c9                   	leave  
801059fe:	c3                   	ret    
801059ff:	90                   	nop

80105a00 <sys_wait>:

int
sys_wait(void)
{
80105a00:	55                   	push   %ebp
80105a01:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105a03:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105a04:	e9 37 e6 ff ff       	jmp    80104040 <wait>
80105a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a10 <sys_kill>:
}

int
sys_kill(void)
{
80105a10:	55                   	push   %ebp
80105a11:	89 e5                	mov    %esp,%ebp
80105a13:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105a16:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a19:	50                   	push   %eax
80105a1a:	6a 00                	push   $0x0
80105a1c:	e8 4f f2 ff ff       	call   80104c70 <argint>
80105a21:	83 c4 10             	add    $0x10,%esp
80105a24:	85 c0                	test   %eax,%eax
80105a26:	78 18                	js     80105a40 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105a28:	83 ec 0c             	sub    $0xc,%esp
80105a2b:	ff 75 f4             	pushl  -0xc(%ebp)
80105a2e:	e8 5d e7 ff ff       	call   80104190 <kill>
80105a33:	83 c4 10             	add    $0x10,%esp
}
80105a36:	c9                   	leave  
80105a37:	c3                   	ret    
80105a38:	90                   	nop
80105a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105a40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105a45:	c9                   	leave  
80105a46:	c3                   	ret    
80105a47:	89 f6                	mov    %esi,%esi
80105a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a50 <sys_getpid>:

int
sys_getpid(void)
{
80105a50:	55                   	push   %ebp
80105a51:	89 e5                	mov    %esp,%ebp
80105a53:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105a56:	e8 75 df ff ff       	call   801039d0 <myproc>
80105a5b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105a5e:	c9                   	leave  
80105a5f:	c3                   	ret    

80105a60 <sys_get_parent_id>:

int
sys_get_parent_id(void)
{
80105a60:	55                   	push   %ebp
80105a61:	89 e5                	mov    %esp,%ebp
80105a63:	83 ec 08             	sub    $0x8,%esp
  return myproc()->parent->pid;
80105a66:	e8 65 df ff ff       	call   801039d0 <myproc>
80105a6b:	8b 40 14             	mov    0x14(%eax),%eax
80105a6e:	8b 40 10             	mov    0x10(%eax),%eax
}
80105a71:	c9                   	leave  
80105a72:	c3                   	ret    
80105a73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a80 <sys_getchildren>:

int
sys_getchildren(void)
{
80105a80:	55                   	push   %ebp
80105a81:	89 e5                	mov    %esp,%ebp
80105a83:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105a86:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a89:	50                   	push   %eax
80105a8a:	6a 00                	push   $0x0
80105a8c:	e8 df f1 ff ff       	call   80104c70 <argint>
80105a91:	83 c4 10             	add    $0x10,%esp
80105a94:	85 c0                	test   %eax,%eax
80105a96:	78 18                	js     80105ab0 <sys_getchildren+0x30>
    return -1;
  return getchildren(pid);
80105a98:	83 ec 0c             	sub    $0xc,%esp
80105a9b:	ff 75 f4             	pushl  -0xc(%ebp)
80105a9e:	e8 2d e8 ff ff       	call   801042d0 <getchildren>
80105aa3:	83 c4 10             	add    $0x10,%esp
}
80105aa6:	c9                   	leave  
80105aa7:	c3                   	ret    
80105aa8:	90                   	nop
80105aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_getchildren(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105ab0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return getchildren(pid);
}
80105ab5:	c9                   	leave  
80105ab6:	c3                   	ret    
80105ab7:	89 f6                	mov    %esi,%esi
80105ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ac0 <sys_sbrk>:


int
sys_sbrk(void)
{
80105ac0:	55                   	push   %ebp
80105ac1:	89 e5                	mov    %esp,%ebp
80105ac3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105ac4:	8d 45 f4             	lea    -0xc(%ebp),%eax
}


int
sys_sbrk(void)
{
80105ac7:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105aca:	50                   	push   %eax
80105acb:	6a 00                	push   $0x0
80105acd:	e8 9e f1 ff ff       	call   80104c70 <argint>
80105ad2:	83 c4 10             	add    $0x10,%esp
80105ad5:	85 c0                	test   %eax,%eax
80105ad7:	78 27                	js     80105b00 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105ad9:	e8 f2 de ff ff       	call   801039d0 <myproc>
  if(growproc(n) < 0)
80105ade:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
80105ae1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105ae3:	ff 75 f4             	pushl  -0xc(%ebp)
80105ae6:	e8 05 e0 ff ff       	call   80103af0 <growproc>
80105aeb:	83 c4 10             	add    $0x10,%esp
80105aee:	85 c0                	test   %eax,%eax
80105af0:	78 0e                	js     80105b00 <sys_sbrk+0x40>
    return -1;
  return addr;
80105af2:	89 d8                	mov    %ebx,%eax
}
80105af4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105af7:	c9                   	leave  
80105af8:	c3                   	ret    
80105af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105b00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b05:	eb ed                	jmp    80105af4 <sys_sbrk+0x34>
80105b07:	89 f6                	mov    %esi,%esi
80105b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b10 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
80105b13:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105b14:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return addr;
}

int
sys_sleep(void)
{
80105b17:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105b1a:	50                   	push   %eax
80105b1b:	6a 00                	push   $0x0
80105b1d:	e8 4e f1 ff ff       	call   80104c70 <argint>
80105b22:	83 c4 10             	add    $0x10,%esp
80105b25:	85 c0                	test   %eax,%eax
80105b27:	0f 88 8a 00 00 00    	js     80105bb7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105b2d:	83 ec 0c             	sub    $0xc,%esp
80105b30:	68 00 5e 11 80       	push   $0x80115e00
80105b35:	e8 26 ed ff ff       	call   80104860 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105b3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b3d:	83 c4 10             	add    $0x10,%esp
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80105b40:	8b 1d 40 66 11 80    	mov    0x80116640,%ebx
  while(ticks - ticks0 < n){
80105b46:	85 d2                	test   %edx,%edx
80105b48:	75 27                	jne    80105b71 <sys_sleep+0x61>
80105b4a:	eb 54                	jmp    80105ba0 <sys_sleep+0x90>
80105b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105b50:	83 ec 08             	sub    $0x8,%esp
80105b53:	68 00 5e 11 80       	push   $0x80115e00
80105b58:	68 40 66 11 80       	push   $0x80116640
80105b5d:	e8 1e e4 ff ff       	call   80103f80 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105b62:	a1 40 66 11 80       	mov    0x80116640,%eax
80105b67:	83 c4 10             	add    $0x10,%esp
80105b6a:	29 d8                	sub    %ebx,%eax
80105b6c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105b6f:	73 2f                	jae    80105ba0 <sys_sleep+0x90>
    if(myproc()->killed){
80105b71:	e8 5a de ff ff       	call   801039d0 <myproc>
80105b76:	8b 40 24             	mov    0x24(%eax),%eax
80105b79:	85 c0                	test   %eax,%eax
80105b7b:	74 d3                	je     80105b50 <sys_sleep+0x40>
      release(&tickslock);
80105b7d:	83 ec 0c             	sub    $0xc,%esp
80105b80:	68 00 5e 11 80       	push   $0x80115e00
80105b85:	e8 86 ed ff ff       	call   80104910 <release>
      return -1;
80105b8a:	83 c4 10             	add    $0x10,%esp
80105b8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
80105b92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b95:	c9                   	leave  
80105b96:	c3                   	ret    
80105b97:	89 f6                	mov    %esi,%esi
80105b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105ba0:	83 ec 0c             	sub    $0xc,%esp
80105ba3:	68 00 5e 11 80       	push   $0x80115e00
80105ba8:	e8 63 ed ff ff       	call   80104910 <release>
  return 0;
80105bad:	83 c4 10             	add    $0x10,%esp
80105bb0:	31 c0                	xor    %eax,%eax
}
80105bb2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105bb5:	c9                   	leave  
80105bb6:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
80105bb7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bbc:	eb d4                	jmp    80105b92 <sys_sleep+0x82>
80105bbe:	66 90                	xchg   %ax,%ax

80105bc0 <sys_sleepp>:
  return 0;
}

int
sys_sleepp(void)
{
80105bc0:	55                   	push   %ebp
80105bc1:	89 e5                	mov    %esp,%ebp
80105bc3:	53                   	push   %ebx
  struct rtcdate r1;
struct rtcdate r2;
  int n=10;
  argint(0 , &n);
80105bc4:	8d 45 c4             	lea    -0x3c(%ebp),%eax
  return 0;
}

int
sys_sleepp(void)
{
80105bc7:	83 ec 4c             	sub    $0x4c,%esp
  struct rtcdate r1;
struct rtcdate r2;
  int n=10;
80105bca:	c7 45 c4 0a 00 00 00 	movl   $0xa,-0x3c(%ebp)
  argint(0 , &n);
80105bd1:	50                   	push   %eax
80105bd2:	6a 00                	push   $0x0
80105bd4:	e8 97 f0 ff ff       	call   80104c70 <argint>
  
  uint ticks0;
  cmostime(&r1);
80105bd9:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105bdc:	89 04 24             	mov    %eax,(%esp)
80105bdf:	e8 3c ce ff ff       	call   80102a20 <cmostime>
  cprintf("start second:%d\n" , r1.second);
80105be4:	58                   	pop    %eax
80105be5:	5a                   	pop    %edx
80105be6:	ff 75 c8             	pushl  -0x38(%ebp)
80105be9:	68 38 7e 10 80       	push   $0x80107e38
80105bee:	e8 6d aa ff ff       	call   80100660 <cprintf>
  cprintf("start mintute:%d\n" , r1.minute);
80105bf3:	59                   	pop    %ecx
80105bf4:	5b                   	pop    %ebx
80105bf5:	ff 75 cc             	pushl  -0x34(%ebp)
80105bf8:	68 49 7e 10 80       	push   $0x80107e49
80105bfd:	e8 5e aa ff ff       	call   80100660 <cprintf>
 
  acquire(&tickslock);
80105c02:	c7 04 24 00 5e 11 80 	movl   $0x80115e00,(%esp)
80105c09:	e8 52 ec ff ff       	call   80104860 <acquire>
  ticks0 = ticks;
 
  
  while(ticks - ticks0 < 100*n){
80105c0e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80105c11:	83 c4 10             	add    $0x10,%esp
  cmostime(&r1);
  cprintf("start second:%d\n" , r1.second);
  cprintf("start mintute:%d\n" , r1.minute);
 
  acquire(&tickslock);
  ticks0 = ticks;
80105c14:	8b 1d 40 66 11 80    	mov    0x80116640,%ebx
 
  
  while(ticks - ticks0 < 100*n){
80105c1a:	85 c0                	test   %eax,%eax
80105c1c:	75 2d                	jne    80105c4b <sys_sleepp+0x8b>
80105c1e:	eb 58                	jmp    80105c78 <sys_sleepp+0xb8>
 
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    release(&tickslock);
80105c20:	83 ec 0c             	sub    $0xc,%esp
80105c23:	68 00 5e 11 80       	push   $0x80115e00
80105c28:	e8 e3 ec ff ff       	call   80104910 <release>
    acquire(&tickslock);
80105c2d:	c7 04 24 00 5e 11 80 	movl   $0x80115e00,(%esp)
80105c34:	e8 27 ec ff ff       	call   80104860 <acquire>
 
  acquire(&tickslock);
  ticks0 = ticks;
 
  
  while(ticks - ticks0 < 100*n){
80105c39:	6b 55 c4 64          	imul   $0x64,-0x3c(%ebp),%edx
80105c3d:	a1 40 66 11 80       	mov    0x80116640,%eax
80105c42:	83 c4 10             	add    $0x10,%esp
80105c45:	29 d8                	sub    %ebx,%eax
80105c47:	39 d0                	cmp    %edx,%eax
80105c49:	73 2d                	jae    80105c78 <sys_sleepp+0xb8>
 
    if(myproc()->killed){
80105c4b:	e8 80 dd ff ff       	call   801039d0 <myproc>
80105c50:	8b 40 24             	mov    0x24(%eax),%eax
80105c53:	85 c0                	test   %eax,%eax
80105c55:	74 c9                	je     80105c20 <sys_sleepp+0x60>
      release(&tickslock);
80105c57:	83 ec 0c             	sub    $0xc,%esp
80105c5a:	68 00 5e 11 80       	push   $0x80115e00
80105c5f:	e8 ac ec ff ff       	call   80104910 <release>
      return -1;
80105c64:	83 c4 10             	add    $0x10,%esp
80105c67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 }
  else{
   cprintf("ekhtelaf daqiqe:%d sanie:%d\n" , r2.minute - r1.minute -1 ,60 + ( r2.second - r1.second));
 }
  return 0;
}
80105c6c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c6f:	c9                   	leave  
80105c70:	c3                   	ret    
80105c71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return -1;
    }
    release(&tickslock);
    acquire(&tickslock);
  }
  release(&tickslock);
80105c78:	83 ec 0c             	sub    $0xc,%esp
80105c7b:	68 00 5e 11 80       	push   $0x80115e00
80105c80:	e8 8b ec ff ff       	call   80104910 <release>
  cmostime(&r2);
80105c85:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c88:	89 04 24             	mov    %eax,(%esp)
80105c8b:	e8 90 cd ff ff       	call   80102a20 <cmostime>
  cprintf("end second:%d\n" , r2.second);
80105c90:	5a                   	pop    %edx
80105c91:	59                   	pop    %ecx
80105c92:	ff 75 e0             	pushl  -0x20(%ebp)
80105c95:	68 5b 7e 10 80       	push   $0x80107e5b
80105c9a:	e8 c1 a9 ff ff       	call   80100660 <cprintf>
  cprintf("end mintute:%d\n" , r2.minute);
80105c9f:	5b                   	pop    %ebx
80105ca0:	58                   	pop    %eax
80105ca1:	ff 75 e4             	pushl  -0x1c(%ebp)
80105ca4:	68 6a 7e 10 80       	push   $0x80107e6a
80105ca9:	e8 b2 a9 ff ff       	call   80100660 <cprintf>
  if( r2.second >= r1.second){
80105cae:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105cb1:	8b 55 c8             	mov    -0x38(%ebp),%edx
80105cb4:	83 c4 10             	add    $0x10,%esp
80105cb7:	39 d0                	cmp    %edx,%eax
80105cb9:	73 2d                	jae    80105ce8 <sys_sleepp+0x128>
   cprintf("ekhtelaf daqiqe:%d sanie:%d\n" , r2.minute - r1.minute , r2.second - r1.second);
 }
  else{
   cprintf("ekhtelaf daqiqe:%d sanie:%d\n" , r2.minute - r1.minute -1 ,60 + ( r2.second - r1.second));
80105cbb:	83 c0 3c             	add    $0x3c,%eax
80105cbe:	83 ec 04             	sub    $0x4,%esp
80105cc1:	29 d0                	sub    %edx,%eax
80105cc3:	50                   	push   %eax
80105cc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105cc7:	83 e8 01             	sub    $0x1,%eax
80105cca:	2b 45 cc             	sub    -0x34(%ebp),%eax
80105ccd:	50                   	push   %eax
80105cce:	68 7a 7e 10 80       	push   $0x80107e7a
80105cd3:	e8 88 a9 ff ff       	call   80100660 <cprintf>
80105cd8:	83 c4 10             	add    $0x10,%esp
 }
  return 0;
80105cdb:	31 c0                	xor    %eax,%eax
}
80105cdd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ce0:	c9                   	leave  
80105ce1:	c3                   	ret    
80105ce2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&tickslock);
  cmostime(&r2);
  cprintf("end second:%d\n" , r2.second);
  cprintf("end mintute:%d\n" , r2.minute);
  if( r2.second >= r1.second){
   cprintf("ekhtelaf daqiqe:%d sanie:%d\n" , r2.minute - r1.minute , r2.second - r1.second);
80105ce8:	29 d0                	sub    %edx,%eax
80105cea:	83 ec 04             	sub    $0x4,%esp
80105ced:	50                   	push   %eax
80105cee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105cf1:	eb d7                	jmp    80105cca <sys_sleepp+0x10a>
80105cf3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d00 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105d00:	55                   	push   %ebp
80105d01:	89 e5                	mov    %esp,%ebp
80105d03:	53                   	push   %ebx
80105d04:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105d07:	68 00 5e 11 80       	push   $0x80115e00
80105d0c:	e8 4f eb ff ff       	call   80104860 <acquire>
  xticks = ticks;
80105d11:	8b 1d 40 66 11 80    	mov    0x80116640,%ebx
  release(&tickslock);
80105d17:	c7 04 24 00 5e 11 80 	movl   $0x80115e00,(%esp)
80105d1e:	e8 ed eb ff ff       	call   80104910 <release>
  return xticks;
}
80105d23:	89 d8                	mov    %ebx,%eax
80105d25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d28:	c9                   	leave  
80105d29:	c3                   	ret    
80105d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105d30 <sys_cmos>:
void
sys_cmos(void)
{
80105d30:	55                   	push   %ebp
80105d31:	89 e5                	mov    %esp,%ebp
80105d33:	83 ec 34             	sub    $0x34,%esp
  struct rtcdate r;
  cmostime(&r);
80105d36:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105d39:	50                   	push   %eax
80105d3a:	e8 e1 cc ff ff       	call   80102a20 <cmostime>
  cprintf("second:%d\n" , r.second);
80105d3f:	58                   	pop    %eax
80105d40:	5a                   	pop    %edx
80105d41:	ff 75 e0             	pushl  -0x20(%ebp)
80105d44:	68 5f 7e 10 80       	push   $0x80107e5f
80105d49:	e8 12 a9 ff ff       	call   80100660 <cprintf>
  cprintf("mintute:%d\n" , r.minute);
80105d4e:	59                   	pop    %ecx
80105d4f:	58                   	pop    %eax
80105d50:	ff 75 e4             	pushl  -0x1c(%ebp)
80105d53:	68 6e 7e 10 80       	push   $0x80107e6e
80105d58:	e8 03 a9 ff ff       	call   80100660 <cprintf>
}
80105d5d:	83 c4 10             	add    $0x10,%esp
80105d60:	c9                   	leave  
80105d61:	c3                   	ret    
80105d62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d70 <sys_set>:


int
sys_set(void)
{       
80105d70:	55                   	push   %ebp
80105d71:	89 e5                	mov    %esp,%ebp
80105d73:	83 ec 10             	sub    $0x10,%esp
        argstr(0,&spath);
80105d76:	68 18 0f 11 80       	push   $0x80110f18
80105d7b:	6a 00                	push   $0x0
80105d7d:	e8 9e ef ff ff       	call   80104d20 <argstr>
	return set(spath);
80105d82:	58                   	pop    %eax
80105d83:	ff 35 18 0f 11 80    	pushl  0x80110f18
80105d89:	e8 12 e7 ff ff       	call   801044a0 <set>
}
80105d8e:	c9                   	leave  
80105d8f:	c3                   	ret    

80105d90 <sys_count>:

int sys_count(void)
{
80105d90:	55                   	push   %ebp
80105d91:	89 e5                	mov    %esp,%ebp
80105d93:	83 ec 08             	sub    $0x8,%esp
	int num,m;
	num=myproc()->tf->esi;
80105d96:	e8 35 dc ff ff       	call   801039d0 <myproc>
80105d9b:	8b 40 18             	mov    0x18(%eax),%eax
	m=count(num);
80105d9e:	83 ec 0c             	sub    $0xc,%esp
80105da1:	ff 70 04             	pushl  0x4(%eax)
80105da4:	e8 d7 e7 ff ff       	call   80104580 <count>
	return m;

}
80105da9:	c9                   	leave  
80105daa:	c3                   	ret    

80105dab <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105dab:	1e                   	push   %ds
  pushl %es
80105dac:	06                   	push   %es
  pushl %fs
80105dad:	0f a0                	push   %fs
  pushl %gs
80105daf:	0f a8                	push   %gs
  pushal
80105db1:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105db2:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105db6:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105db8:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105dba:	54                   	push   %esp
  call trap
80105dbb:	e8 e0 00 00 00       	call   80105ea0 <trap>
  addl $4, %esp
80105dc0:	83 c4 04             	add    $0x4,%esp

80105dc3 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105dc3:	61                   	popa   
  popl %gs
80105dc4:	0f a9                	pop    %gs
  popl %fs
80105dc6:	0f a1                	pop    %fs
  popl %es
80105dc8:	07                   	pop    %es
  popl %ds
80105dc9:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105dca:	83 c4 08             	add    $0x8,%esp
  iret
80105dcd:	cf                   	iret   
80105dce:	66 90                	xchg   %ax,%ax

80105dd0 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105dd0:	31 c0                	xor    %eax,%eax
80105dd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105dd8:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105ddf:	b9 08 00 00 00       	mov    $0x8,%ecx
80105de4:	c6 04 c5 44 5e 11 80 	movb   $0x0,-0x7feea1bc(,%eax,8)
80105deb:	00 
80105dec:	66 89 0c c5 42 5e 11 	mov    %cx,-0x7feea1be(,%eax,8)
80105df3:	80 
80105df4:	c6 04 c5 45 5e 11 80 	movb   $0x8e,-0x7feea1bb(,%eax,8)
80105dfb:	8e 
80105dfc:	66 89 14 c5 40 5e 11 	mov    %dx,-0x7feea1c0(,%eax,8)
80105e03:	80 
80105e04:	c1 ea 10             	shr    $0x10,%edx
80105e07:	66 89 14 c5 46 5e 11 	mov    %dx,-0x7feea1ba(,%eax,8)
80105e0e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105e0f:	83 c0 01             	add    $0x1,%eax
80105e12:	3d 00 01 00 00       	cmp    $0x100,%eax
80105e17:	75 bf                	jne    80105dd8 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105e19:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105e1a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105e1f:	89 e5                	mov    %esp,%ebp
80105e21:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105e24:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80105e29:	68 97 7e 10 80       	push   $0x80107e97
80105e2e:	68 00 5e 11 80       	push   $0x80115e00
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105e33:	66 89 15 42 60 11 80 	mov    %dx,0x80116042
80105e3a:	c6 05 44 60 11 80 00 	movb   $0x0,0x80116044
80105e41:	66 a3 40 60 11 80    	mov    %ax,0x80116040
80105e47:	c1 e8 10             	shr    $0x10,%eax
80105e4a:	c6 05 45 60 11 80 ef 	movb   $0xef,0x80116045
80105e51:	66 a3 46 60 11 80    	mov    %ax,0x80116046

  initlock(&tickslock, "time");
80105e57:	e8 a4 e8 ff ff       	call   80104700 <initlock>
}
80105e5c:	83 c4 10             	add    $0x10,%esp
80105e5f:	c9                   	leave  
80105e60:	c3                   	ret    
80105e61:	eb 0d                	jmp    80105e70 <idtinit>
80105e63:	90                   	nop
80105e64:	90                   	nop
80105e65:	90                   	nop
80105e66:	90                   	nop
80105e67:	90                   	nop
80105e68:	90                   	nop
80105e69:	90                   	nop
80105e6a:	90                   	nop
80105e6b:	90                   	nop
80105e6c:	90                   	nop
80105e6d:	90                   	nop
80105e6e:	90                   	nop
80105e6f:	90                   	nop

80105e70 <idtinit>:

void
idtinit(void)
{
80105e70:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80105e71:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105e76:	89 e5                	mov    %esp,%ebp
80105e78:	83 ec 10             	sub    $0x10,%esp
80105e7b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105e7f:	b8 40 5e 11 80       	mov    $0x80115e40,%eax
80105e84:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105e88:	c1 e8 10             	shr    $0x10,%eax
80105e8b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80105e8f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105e92:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105e95:	c9                   	leave  
80105e96:	c3                   	ret    
80105e97:	89 f6                	mov    %esi,%esi
80105e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ea0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105ea0:	55                   	push   %ebp
80105ea1:	89 e5                	mov    %esp,%ebp
80105ea3:	57                   	push   %edi
80105ea4:	56                   	push   %esi
80105ea5:	53                   	push   %ebx
80105ea6:	83 ec 1c             	sub    $0x1c,%esp
80105ea9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105eac:	8b 47 30             	mov    0x30(%edi),%eax
80105eaf:	83 f8 40             	cmp    $0x40,%eax
80105eb2:	0f 84 88 01 00 00    	je     80106040 <trap+0x1a0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105eb8:	83 e8 20             	sub    $0x20,%eax
80105ebb:	83 f8 1f             	cmp    $0x1f,%eax
80105ebe:	77 10                	ja     80105ed0 <trap+0x30>
80105ec0:	ff 24 85 40 7f 10 80 	jmp    *-0x7fef80c0(,%eax,4)
80105ec7:	89 f6                	mov    %esi,%esi
80105ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105ed0:	e8 fb da ff ff       	call   801039d0 <myproc>
80105ed5:	85 c0                	test   %eax,%eax
80105ed7:	0f 84 d7 01 00 00    	je     801060b4 <trap+0x214>
80105edd:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105ee1:	0f 84 cd 01 00 00    	je     801060b4 <trap+0x214>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105ee7:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105eea:	8b 57 38             	mov    0x38(%edi),%edx
80105eed:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105ef0:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105ef3:	e8 b8 da ff ff       	call   801039b0 <cpuid>
80105ef8:	8b 77 34             	mov    0x34(%edi),%esi
80105efb:	8b 5f 30             	mov    0x30(%edi),%ebx
80105efe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105f01:	e8 ca da ff ff       	call   801039d0 <myproc>
80105f06:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105f09:	e8 c2 da ff ff       	call   801039d0 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f0e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105f11:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105f14:	51                   	push   %ecx
80105f15:	52                   	push   %edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105f16:	8b 55 e0             	mov    -0x20(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f19:	ff 75 e4             	pushl  -0x1c(%ebp)
80105f1c:	56                   	push   %esi
80105f1d:	53                   	push   %ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105f1e:	83 c2 6c             	add    $0x6c,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f21:	52                   	push   %edx
80105f22:	ff 70 10             	pushl  0x10(%eax)
80105f25:	68 fc 7e 10 80       	push   $0x80107efc
80105f2a:	e8 31 a7 ff ff       	call   80100660 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105f2f:	83 c4 20             	add    $0x20,%esp
80105f32:	e8 99 da ff ff       	call   801039d0 <myproc>
80105f37:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105f3e:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f40:	e8 8b da ff ff       	call   801039d0 <myproc>
80105f45:	85 c0                	test   %eax,%eax
80105f47:	74 0c                	je     80105f55 <trap+0xb5>
80105f49:	e8 82 da ff ff       	call   801039d0 <myproc>
80105f4e:	8b 50 24             	mov    0x24(%eax),%edx
80105f51:	85 d2                	test   %edx,%edx
80105f53:	75 4b                	jne    80105fa0 <trap+0x100>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105f55:	e8 76 da ff ff       	call   801039d0 <myproc>
80105f5a:	85 c0                	test   %eax,%eax
80105f5c:	74 0b                	je     80105f69 <trap+0xc9>
80105f5e:	e8 6d da ff ff       	call   801039d0 <myproc>
80105f63:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105f67:	74 4f                	je     80105fb8 <trap+0x118>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f69:	e8 62 da ff ff       	call   801039d0 <myproc>
80105f6e:	85 c0                	test   %eax,%eax
80105f70:	74 1d                	je     80105f8f <trap+0xef>
80105f72:	e8 59 da ff ff       	call   801039d0 <myproc>
80105f77:	8b 40 24             	mov    0x24(%eax),%eax
80105f7a:	85 c0                	test   %eax,%eax
80105f7c:	74 11                	je     80105f8f <trap+0xef>
80105f7e:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105f82:	83 e0 03             	and    $0x3,%eax
80105f85:	66 83 f8 03          	cmp    $0x3,%ax
80105f89:	0f 84 da 00 00 00    	je     80106069 <trap+0x1c9>
    exit();
}
80105f8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f92:	5b                   	pop    %ebx
80105f93:	5e                   	pop    %esi
80105f94:	5f                   	pop    %edi
80105f95:	5d                   	pop    %ebp
80105f96:	c3                   	ret    
80105f97:	89 f6                	mov    %esi,%esi
80105f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fa0:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105fa4:	83 e0 03             	and    $0x3,%eax
80105fa7:	66 83 f8 03          	cmp    $0x3,%ax
80105fab:	75 a8                	jne    80105f55 <trap+0xb5>
    exit();
80105fad:	e8 4e de ff ff       	call   80103e00 <exit>
80105fb2:	eb a1                	jmp    80105f55 <trap+0xb5>
80105fb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105fb8:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105fbc:	75 ab                	jne    80105f69 <trap+0xc9>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
80105fbe:	e8 6d df ff ff       	call   80103f30 <yield>
80105fc3:	eb a4                	jmp    80105f69 <trap+0xc9>
80105fc5:	8d 76 00             	lea    0x0(%esi),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105fc8:	e8 e3 d9 ff ff       	call   801039b0 <cpuid>
80105fcd:	85 c0                	test   %eax,%eax
80105fcf:	0f 84 ab 00 00 00    	je     80106080 <trap+0x1e0>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105fd5:	e8 86 c9 ff ff       	call   80102960 <lapiceoi>
    break;
80105fda:	e9 61 ff ff ff       	jmp    80105f40 <trap+0xa0>
80105fdf:	90                   	nop
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105fe0:	e8 3b c8 ff ff       	call   80102820 <kbdintr>
    lapiceoi();
80105fe5:	e8 76 c9 ff ff       	call   80102960 <lapiceoi>
    break;
80105fea:	e9 51 ff ff ff       	jmp    80105f40 <trap+0xa0>
80105fef:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80105ff0:	e8 5b 02 00 00       	call   80106250 <uartintr>
    lapiceoi();
80105ff5:	e8 66 c9 ff ff       	call   80102960 <lapiceoi>
    break;
80105ffa:	e9 41 ff ff ff       	jmp    80105f40 <trap+0xa0>
80105fff:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106000:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80106004:	8b 77 38             	mov    0x38(%edi),%esi
80106007:	e8 a4 d9 ff ff       	call   801039b0 <cpuid>
8010600c:	56                   	push   %esi
8010600d:	53                   	push   %ebx
8010600e:	50                   	push   %eax
8010600f:	68 a4 7e 10 80       	push   $0x80107ea4
80106014:	e8 47 a6 ff ff       	call   80100660 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80106019:	e8 42 c9 ff ff       	call   80102960 <lapiceoi>
    break;
8010601e:	83 c4 10             	add    $0x10,%esp
80106021:	e9 1a ff ff ff       	jmp    80105f40 <trap+0xa0>
80106026:	8d 76 00             	lea    0x0(%esi),%esi
80106029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106030:	e8 6b c2 ff ff       	call   801022a0 <ideintr>
80106035:	eb 9e                	jmp    80105fd5 <trap+0x135>
80106037:	89 f6                	mov    %esi,%esi
80106039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
80106040:	e8 8b d9 ff ff       	call   801039d0 <myproc>
80106045:	8b 58 24             	mov    0x24(%eax),%ebx
80106048:	85 db                	test   %ebx,%ebx
8010604a:	75 2c                	jne    80106078 <trap+0x1d8>
      exit();
    myproc()->tf = tf;
8010604c:	e8 7f d9 ff ff       	call   801039d0 <myproc>
80106051:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106054:	e8 07 ed ff ff       	call   80104d60 <syscall>
    if(myproc()->killed)
80106059:	e8 72 d9 ff ff       	call   801039d0 <myproc>
8010605e:	8b 48 24             	mov    0x24(%eax),%ecx
80106061:	85 c9                	test   %ecx,%ecx
80106063:	0f 84 26 ff ff ff    	je     80105f8f <trap+0xef>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80106069:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010606c:	5b                   	pop    %ebx
8010606d:	5e                   	pop    %esi
8010606e:	5f                   	pop    %edi
8010606f:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
80106070:	e9 8b dd ff ff       	jmp    80103e00 <exit>
80106075:	8d 76 00             	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
80106078:	e8 83 dd ff ff       	call   80103e00 <exit>
8010607d:	eb cd                	jmp    8010604c <trap+0x1ac>
8010607f:	90                   	nop
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
80106080:	83 ec 0c             	sub    $0xc,%esp
80106083:	68 00 5e 11 80       	push   $0x80115e00
80106088:	e8 d3 e7 ff ff       	call   80104860 <acquire>
      ticks++;
      wakeup(&ticks);
8010608d:	c7 04 24 40 66 11 80 	movl   $0x80116640,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
80106094:	83 05 40 66 11 80 01 	addl   $0x1,0x80116640
      wakeup(&ticks);
8010609b:	e8 90 e0 ff ff       	call   80104130 <wakeup>
      release(&tickslock);
801060a0:	c7 04 24 00 5e 11 80 	movl   $0x80115e00,(%esp)
801060a7:	e8 64 e8 ff ff       	call   80104910 <release>
801060ac:	83 c4 10             	add    $0x10,%esp
801060af:	e9 21 ff ff ff       	jmp    80105fd5 <trap+0x135>
801060b4:	0f 20 d6             	mov    %cr2,%esi

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801060b7:	8b 5f 38             	mov    0x38(%edi),%ebx
801060ba:	e8 f1 d8 ff ff       	call   801039b0 <cpuid>
801060bf:	83 ec 0c             	sub    $0xc,%esp
801060c2:	56                   	push   %esi
801060c3:	53                   	push   %ebx
801060c4:	50                   	push   %eax
801060c5:	ff 77 30             	pushl  0x30(%edi)
801060c8:	68 c8 7e 10 80       	push   $0x80107ec8
801060cd:	e8 8e a5 ff ff       	call   80100660 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
801060d2:	83 c4 14             	add    $0x14,%esp
801060d5:	68 9c 7e 10 80       	push   $0x80107e9c
801060da:	e8 91 a2 ff ff       	call   80100370 <panic>
801060df:	90                   	nop

801060e0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801060e0:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801060e5:	55                   	push   %ebp
801060e6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801060e8:	85 c0                	test   %eax,%eax
801060ea:	74 1c                	je     80106108 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801060ec:	ba fd 03 00 00       	mov    $0x3fd,%edx
801060f1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801060f2:	a8 01                	test   $0x1,%al
801060f4:	74 12                	je     80106108 <uartgetc+0x28>
801060f6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060fb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801060fc:	0f b6 c0             	movzbl %al,%eax
}
801060ff:	5d                   	pop    %ebp
80106100:	c3                   	ret    
80106101:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80106108:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
8010610d:	5d                   	pop    %ebp
8010610e:	c3                   	ret    
8010610f:	90                   	nop

80106110 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
80106110:	55                   	push   %ebp
80106111:	89 e5                	mov    %esp,%ebp
80106113:	57                   	push   %edi
80106114:	56                   	push   %esi
80106115:	53                   	push   %ebx
80106116:	89 c7                	mov    %eax,%edi
80106118:	bb 80 00 00 00       	mov    $0x80,%ebx
8010611d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106122:	83 ec 0c             	sub    $0xc,%esp
80106125:	eb 1b                	jmp    80106142 <uartputc.part.0+0x32>
80106127:	89 f6                	mov    %esi,%esi
80106129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80106130:	83 ec 0c             	sub    $0xc,%esp
80106133:	6a 0a                	push   $0xa
80106135:	e8 46 c8 ff ff       	call   80102980 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010613a:	83 c4 10             	add    $0x10,%esp
8010613d:	83 eb 01             	sub    $0x1,%ebx
80106140:	74 07                	je     80106149 <uartputc.part.0+0x39>
80106142:	89 f2                	mov    %esi,%edx
80106144:	ec                   	in     (%dx),%al
80106145:	a8 20                	test   $0x20,%al
80106147:	74 e7                	je     80106130 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106149:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010614e:	89 f8                	mov    %edi,%eax
80106150:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80106151:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106154:	5b                   	pop    %ebx
80106155:	5e                   	pop    %esi
80106156:	5f                   	pop    %edi
80106157:	5d                   	pop    %ebp
80106158:	c3                   	ret    
80106159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106160 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106160:	55                   	push   %ebp
80106161:	31 c9                	xor    %ecx,%ecx
80106163:	89 c8                	mov    %ecx,%eax
80106165:	89 e5                	mov    %esp,%ebp
80106167:	57                   	push   %edi
80106168:	56                   	push   %esi
80106169:	53                   	push   %ebx
8010616a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010616f:	89 da                	mov    %ebx,%edx
80106171:	83 ec 0c             	sub    $0xc,%esp
80106174:	ee                   	out    %al,(%dx)
80106175:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010617a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010617f:	89 fa                	mov    %edi,%edx
80106181:	ee                   	out    %al,(%dx)
80106182:	b8 0c 00 00 00       	mov    $0xc,%eax
80106187:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010618c:	ee                   	out    %al,(%dx)
8010618d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106192:	89 c8                	mov    %ecx,%eax
80106194:	89 f2                	mov    %esi,%edx
80106196:	ee                   	out    %al,(%dx)
80106197:	b8 03 00 00 00       	mov    $0x3,%eax
8010619c:	89 fa                	mov    %edi,%edx
8010619e:	ee                   	out    %al,(%dx)
8010619f:	ba fc 03 00 00       	mov    $0x3fc,%edx
801061a4:	89 c8                	mov    %ecx,%eax
801061a6:	ee                   	out    %al,(%dx)
801061a7:	b8 01 00 00 00       	mov    $0x1,%eax
801061ac:	89 f2                	mov    %esi,%edx
801061ae:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801061af:	ba fd 03 00 00       	mov    $0x3fd,%edx
801061b4:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801061b5:	3c ff                	cmp    $0xff,%al
801061b7:	74 5a                	je     80106213 <uartinit+0xb3>
    return;
  uart = 1;
801061b9:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
801061c0:	00 00 00 
801061c3:	89 da                	mov    %ebx,%edx
801061c5:	ec                   	in     (%dx),%al
801061c6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801061cb:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
801061cc:	83 ec 08             	sub    $0x8,%esp
801061cf:	bb c0 7f 10 80       	mov    $0x80107fc0,%ebx
801061d4:	6a 00                	push   $0x0
801061d6:	6a 04                	push   $0x4
801061d8:	e8 13 c3 ff ff       	call   801024f0 <ioapicenable>
801061dd:	83 c4 10             	add    $0x10,%esp
801061e0:	b8 78 00 00 00       	mov    $0x78,%eax
801061e5:	eb 13                	jmp    801061fa <uartinit+0x9a>
801061e7:	89 f6                	mov    %esi,%esi
801061e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801061f0:	83 c3 01             	add    $0x1,%ebx
801061f3:	0f be 03             	movsbl (%ebx),%eax
801061f6:	84 c0                	test   %al,%al
801061f8:	74 19                	je     80106213 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
801061fa:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80106200:	85 d2                	test   %edx,%edx
80106202:	74 ec                	je     801061f0 <uartinit+0x90>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106204:	83 c3 01             	add    $0x1,%ebx
80106207:	e8 04 ff ff ff       	call   80106110 <uartputc.part.0>
8010620c:	0f be 03             	movsbl (%ebx),%eax
8010620f:	84 c0                	test   %al,%al
80106211:	75 e7                	jne    801061fa <uartinit+0x9a>
    uartputc(*p);
}
80106213:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106216:	5b                   	pop    %ebx
80106217:	5e                   	pop    %esi
80106218:	5f                   	pop    %edi
80106219:	5d                   	pop    %ebp
8010621a:	c3                   	ret    
8010621b:	90                   	nop
8010621c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106220 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80106220:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80106226:	55                   	push   %ebp
80106227:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
80106229:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
8010622b:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
8010622e:	74 10                	je     80106240 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80106230:	5d                   	pop    %ebp
80106231:	e9 da fe ff ff       	jmp    80106110 <uartputc.part.0>
80106236:	8d 76 00             	lea    0x0(%esi),%esi
80106239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106240:	5d                   	pop    %ebp
80106241:	c3                   	ret    
80106242:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106250 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80106250:	55                   	push   %ebp
80106251:	89 e5                	mov    %esp,%ebp
80106253:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106256:	68 e0 60 10 80       	push   $0x801060e0
8010625b:	e8 90 a5 ff ff       	call   801007f0 <consoleintr>
}
80106260:	83 c4 10             	add    $0x10,%esp
80106263:	c9                   	leave  
80106264:	c3                   	ret    

80106265 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106265:	6a 00                	push   $0x0
  pushl $0
80106267:	6a 00                	push   $0x0
  jmp alltraps
80106269:	e9 3d fb ff ff       	jmp    80105dab <alltraps>

8010626e <vector1>:
.globl vector1
vector1:
  pushl $0
8010626e:	6a 00                	push   $0x0
  pushl $1
80106270:	6a 01                	push   $0x1
  jmp alltraps
80106272:	e9 34 fb ff ff       	jmp    80105dab <alltraps>

80106277 <vector2>:
.globl vector2
vector2:
  pushl $0
80106277:	6a 00                	push   $0x0
  pushl $2
80106279:	6a 02                	push   $0x2
  jmp alltraps
8010627b:	e9 2b fb ff ff       	jmp    80105dab <alltraps>

80106280 <vector3>:
.globl vector3
vector3:
  pushl $0
80106280:	6a 00                	push   $0x0
  pushl $3
80106282:	6a 03                	push   $0x3
  jmp alltraps
80106284:	e9 22 fb ff ff       	jmp    80105dab <alltraps>

80106289 <vector4>:
.globl vector4
vector4:
  pushl $0
80106289:	6a 00                	push   $0x0
  pushl $4
8010628b:	6a 04                	push   $0x4
  jmp alltraps
8010628d:	e9 19 fb ff ff       	jmp    80105dab <alltraps>

80106292 <vector5>:
.globl vector5
vector5:
  pushl $0
80106292:	6a 00                	push   $0x0
  pushl $5
80106294:	6a 05                	push   $0x5
  jmp alltraps
80106296:	e9 10 fb ff ff       	jmp    80105dab <alltraps>

8010629b <vector6>:
.globl vector6
vector6:
  pushl $0
8010629b:	6a 00                	push   $0x0
  pushl $6
8010629d:	6a 06                	push   $0x6
  jmp alltraps
8010629f:	e9 07 fb ff ff       	jmp    80105dab <alltraps>

801062a4 <vector7>:
.globl vector7
vector7:
  pushl $0
801062a4:	6a 00                	push   $0x0
  pushl $7
801062a6:	6a 07                	push   $0x7
  jmp alltraps
801062a8:	e9 fe fa ff ff       	jmp    80105dab <alltraps>

801062ad <vector8>:
.globl vector8
vector8:
  pushl $8
801062ad:	6a 08                	push   $0x8
  jmp alltraps
801062af:	e9 f7 fa ff ff       	jmp    80105dab <alltraps>

801062b4 <vector9>:
.globl vector9
vector9:
  pushl $0
801062b4:	6a 00                	push   $0x0
  pushl $9
801062b6:	6a 09                	push   $0x9
  jmp alltraps
801062b8:	e9 ee fa ff ff       	jmp    80105dab <alltraps>

801062bd <vector10>:
.globl vector10
vector10:
  pushl $10
801062bd:	6a 0a                	push   $0xa
  jmp alltraps
801062bf:	e9 e7 fa ff ff       	jmp    80105dab <alltraps>

801062c4 <vector11>:
.globl vector11
vector11:
  pushl $11
801062c4:	6a 0b                	push   $0xb
  jmp alltraps
801062c6:	e9 e0 fa ff ff       	jmp    80105dab <alltraps>

801062cb <vector12>:
.globl vector12
vector12:
  pushl $12
801062cb:	6a 0c                	push   $0xc
  jmp alltraps
801062cd:	e9 d9 fa ff ff       	jmp    80105dab <alltraps>

801062d2 <vector13>:
.globl vector13
vector13:
  pushl $13
801062d2:	6a 0d                	push   $0xd
  jmp alltraps
801062d4:	e9 d2 fa ff ff       	jmp    80105dab <alltraps>

801062d9 <vector14>:
.globl vector14
vector14:
  pushl $14
801062d9:	6a 0e                	push   $0xe
  jmp alltraps
801062db:	e9 cb fa ff ff       	jmp    80105dab <alltraps>

801062e0 <vector15>:
.globl vector15
vector15:
  pushl $0
801062e0:	6a 00                	push   $0x0
  pushl $15
801062e2:	6a 0f                	push   $0xf
  jmp alltraps
801062e4:	e9 c2 fa ff ff       	jmp    80105dab <alltraps>

801062e9 <vector16>:
.globl vector16
vector16:
  pushl $0
801062e9:	6a 00                	push   $0x0
  pushl $16
801062eb:	6a 10                	push   $0x10
  jmp alltraps
801062ed:	e9 b9 fa ff ff       	jmp    80105dab <alltraps>

801062f2 <vector17>:
.globl vector17
vector17:
  pushl $17
801062f2:	6a 11                	push   $0x11
  jmp alltraps
801062f4:	e9 b2 fa ff ff       	jmp    80105dab <alltraps>

801062f9 <vector18>:
.globl vector18
vector18:
  pushl $0
801062f9:	6a 00                	push   $0x0
  pushl $18
801062fb:	6a 12                	push   $0x12
  jmp alltraps
801062fd:	e9 a9 fa ff ff       	jmp    80105dab <alltraps>

80106302 <vector19>:
.globl vector19
vector19:
  pushl $0
80106302:	6a 00                	push   $0x0
  pushl $19
80106304:	6a 13                	push   $0x13
  jmp alltraps
80106306:	e9 a0 fa ff ff       	jmp    80105dab <alltraps>

8010630b <vector20>:
.globl vector20
vector20:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $20
8010630d:	6a 14                	push   $0x14
  jmp alltraps
8010630f:	e9 97 fa ff ff       	jmp    80105dab <alltraps>

80106314 <vector21>:
.globl vector21
vector21:
  pushl $0
80106314:	6a 00                	push   $0x0
  pushl $21
80106316:	6a 15                	push   $0x15
  jmp alltraps
80106318:	e9 8e fa ff ff       	jmp    80105dab <alltraps>

8010631d <vector22>:
.globl vector22
vector22:
  pushl $0
8010631d:	6a 00                	push   $0x0
  pushl $22
8010631f:	6a 16                	push   $0x16
  jmp alltraps
80106321:	e9 85 fa ff ff       	jmp    80105dab <alltraps>

80106326 <vector23>:
.globl vector23
vector23:
  pushl $0
80106326:	6a 00                	push   $0x0
  pushl $23
80106328:	6a 17                	push   $0x17
  jmp alltraps
8010632a:	e9 7c fa ff ff       	jmp    80105dab <alltraps>

8010632f <vector24>:
.globl vector24
vector24:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $24
80106331:	6a 18                	push   $0x18
  jmp alltraps
80106333:	e9 73 fa ff ff       	jmp    80105dab <alltraps>

80106338 <vector25>:
.globl vector25
vector25:
  pushl $0
80106338:	6a 00                	push   $0x0
  pushl $25
8010633a:	6a 19                	push   $0x19
  jmp alltraps
8010633c:	e9 6a fa ff ff       	jmp    80105dab <alltraps>

80106341 <vector26>:
.globl vector26
vector26:
  pushl $0
80106341:	6a 00                	push   $0x0
  pushl $26
80106343:	6a 1a                	push   $0x1a
  jmp alltraps
80106345:	e9 61 fa ff ff       	jmp    80105dab <alltraps>

8010634a <vector27>:
.globl vector27
vector27:
  pushl $0
8010634a:	6a 00                	push   $0x0
  pushl $27
8010634c:	6a 1b                	push   $0x1b
  jmp alltraps
8010634e:	e9 58 fa ff ff       	jmp    80105dab <alltraps>

80106353 <vector28>:
.globl vector28
vector28:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $28
80106355:	6a 1c                	push   $0x1c
  jmp alltraps
80106357:	e9 4f fa ff ff       	jmp    80105dab <alltraps>

8010635c <vector29>:
.globl vector29
vector29:
  pushl $0
8010635c:	6a 00                	push   $0x0
  pushl $29
8010635e:	6a 1d                	push   $0x1d
  jmp alltraps
80106360:	e9 46 fa ff ff       	jmp    80105dab <alltraps>

80106365 <vector30>:
.globl vector30
vector30:
  pushl $0
80106365:	6a 00                	push   $0x0
  pushl $30
80106367:	6a 1e                	push   $0x1e
  jmp alltraps
80106369:	e9 3d fa ff ff       	jmp    80105dab <alltraps>

8010636e <vector31>:
.globl vector31
vector31:
  pushl $0
8010636e:	6a 00                	push   $0x0
  pushl $31
80106370:	6a 1f                	push   $0x1f
  jmp alltraps
80106372:	e9 34 fa ff ff       	jmp    80105dab <alltraps>

80106377 <vector32>:
.globl vector32
vector32:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $32
80106379:	6a 20                	push   $0x20
  jmp alltraps
8010637b:	e9 2b fa ff ff       	jmp    80105dab <alltraps>

80106380 <vector33>:
.globl vector33
vector33:
  pushl $0
80106380:	6a 00                	push   $0x0
  pushl $33
80106382:	6a 21                	push   $0x21
  jmp alltraps
80106384:	e9 22 fa ff ff       	jmp    80105dab <alltraps>

80106389 <vector34>:
.globl vector34
vector34:
  pushl $0
80106389:	6a 00                	push   $0x0
  pushl $34
8010638b:	6a 22                	push   $0x22
  jmp alltraps
8010638d:	e9 19 fa ff ff       	jmp    80105dab <alltraps>

80106392 <vector35>:
.globl vector35
vector35:
  pushl $0
80106392:	6a 00                	push   $0x0
  pushl $35
80106394:	6a 23                	push   $0x23
  jmp alltraps
80106396:	e9 10 fa ff ff       	jmp    80105dab <alltraps>

8010639b <vector36>:
.globl vector36
vector36:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $36
8010639d:	6a 24                	push   $0x24
  jmp alltraps
8010639f:	e9 07 fa ff ff       	jmp    80105dab <alltraps>

801063a4 <vector37>:
.globl vector37
vector37:
  pushl $0
801063a4:	6a 00                	push   $0x0
  pushl $37
801063a6:	6a 25                	push   $0x25
  jmp alltraps
801063a8:	e9 fe f9 ff ff       	jmp    80105dab <alltraps>

801063ad <vector38>:
.globl vector38
vector38:
  pushl $0
801063ad:	6a 00                	push   $0x0
  pushl $38
801063af:	6a 26                	push   $0x26
  jmp alltraps
801063b1:	e9 f5 f9 ff ff       	jmp    80105dab <alltraps>

801063b6 <vector39>:
.globl vector39
vector39:
  pushl $0
801063b6:	6a 00                	push   $0x0
  pushl $39
801063b8:	6a 27                	push   $0x27
  jmp alltraps
801063ba:	e9 ec f9 ff ff       	jmp    80105dab <alltraps>

801063bf <vector40>:
.globl vector40
vector40:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $40
801063c1:	6a 28                	push   $0x28
  jmp alltraps
801063c3:	e9 e3 f9 ff ff       	jmp    80105dab <alltraps>

801063c8 <vector41>:
.globl vector41
vector41:
  pushl $0
801063c8:	6a 00                	push   $0x0
  pushl $41
801063ca:	6a 29                	push   $0x29
  jmp alltraps
801063cc:	e9 da f9 ff ff       	jmp    80105dab <alltraps>

801063d1 <vector42>:
.globl vector42
vector42:
  pushl $0
801063d1:	6a 00                	push   $0x0
  pushl $42
801063d3:	6a 2a                	push   $0x2a
  jmp alltraps
801063d5:	e9 d1 f9 ff ff       	jmp    80105dab <alltraps>

801063da <vector43>:
.globl vector43
vector43:
  pushl $0
801063da:	6a 00                	push   $0x0
  pushl $43
801063dc:	6a 2b                	push   $0x2b
  jmp alltraps
801063de:	e9 c8 f9 ff ff       	jmp    80105dab <alltraps>

801063e3 <vector44>:
.globl vector44
vector44:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $44
801063e5:	6a 2c                	push   $0x2c
  jmp alltraps
801063e7:	e9 bf f9 ff ff       	jmp    80105dab <alltraps>

801063ec <vector45>:
.globl vector45
vector45:
  pushl $0
801063ec:	6a 00                	push   $0x0
  pushl $45
801063ee:	6a 2d                	push   $0x2d
  jmp alltraps
801063f0:	e9 b6 f9 ff ff       	jmp    80105dab <alltraps>

801063f5 <vector46>:
.globl vector46
vector46:
  pushl $0
801063f5:	6a 00                	push   $0x0
  pushl $46
801063f7:	6a 2e                	push   $0x2e
  jmp alltraps
801063f9:	e9 ad f9 ff ff       	jmp    80105dab <alltraps>

801063fe <vector47>:
.globl vector47
vector47:
  pushl $0
801063fe:	6a 00                	push   $0x0
  pushl $47
80106400:	6a 2f                	push   $0x2f
  jmp alltraps
80106402:	e9 a4 f9 ff ff       	jmp    80105dab <alltraps>

80106407 <vector48>:
.globl vector48
vector48:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $48
80106409:	6a 30                	push   $0x30
  jmp alltraps
8010640b:	e9 9b f9 ff ff       	jmp    80105dab <alltraps>

80106410 <vector49>:
.globl vector49
vector49:
  pushl $0
80106410:	6a 00                	push   $0x0
  pushl $49
80106412:	6a 31                	push   $0x31
  jmp alltraps
80106414:	e9 92 f9 ff ff       	jmp    80105dab <alltraps>

80106419 <vector50>:
.globl vector50
vector50:
  pushl $0
80106419:	6a 00                	push   $0x0
  pushl $50
8010641b:	6a 32                	push   $0x32
  jmp alltraps
8010641d:	e9 89 f9 ff ff       	jmp    80105dab <alltraps>

80106422 <vector51>:
.globl vector51
vector51:
  pushl $0
80106422:	6a 00                	push   $0x0
  pushl $51
80106424:	6a 33                	push   $0x33
  jmp alltraps
80106426:	e9 80 f9 ff ff       	jmp    80105dab <alltraps>

8010642b <vector52>:
.globl vector52
vector52:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $52
8010642d:	6a 34                	push   $0x34
  jmp alltraps
8010642f:	e9 77 f9 ff ff       	jmp    80105dab <alltraps>

80106434 <vector53>:
.globl vector53
vector53:
  pushl $0
80106434:	6a 00                	push   $0x0
  pushl $53
80106436:	6a 35                	push   $0x35
  jmp alltraps
80106438:	e9 6e f9 ff ff       	jmp    80105dab <alltraps>

8010643d <vector54>:
.globl vector54
vector54:
  pushl $0
8010643d:	6a 00                	push   $0x0
  pushl $54
8010643f:	6a 36                	push   $0x36
  jmp alltraps
80106441:	e9 65 f9 ff ff       	jmp    80105dab <alltraps>

80106446 <vector55>:
.globl vector55
vector55:
  pushl $0
80106446:	6a 00                	push   $0x0
  pushl $55
80106448:	6a 37                	push   $0x37
  jmp alltraps
8010644a:	e9 5c f9 ff ff       	jmp    80105dab <alltraps>

8010644f <vector56>:
.globl vector56
vector56:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $56
80106451:	6a 38                	push   $0x38
  jmp alltraps
80106453:	e9 53 f9 ff ff       	jmp    80105dab <alltraps>

80106458 <vector57>:
.globl vector57
vector57:
  pushl $0
80106458:	6a 00                	push   $0x0
  pushl $57
8010645a:	6a 39                	push   $0x39
  jmp alltraps
8010645c:	e9 4a f9 ff ff       	jmp    80105dab <alltraps>

80106461 <vector58>:
.globl vector58
vector58:
  pushl $0
80106461:	6a 00                	push   $0x0
  pushl $58
80106463:	6a 3a                	push   $0x3a
  jmp alltraps
80106465:	e9 41 f9 ff ff       	jmp    80105dab <alltraps>

8010646a <vector59>:
.globl vector59
vector59:
  pushl $0
8010646a:	6a 00                	push   $0x0
  pushl $59
8010646c:	6a 3b                	push   $0x3b
  jmp alltraps
8010646e:	e9 38 f9 ff ff       	jmp    80105dab <alltraps>

80106473 <vector60>:
.globl vector60
vector60:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $60
80106475:	6a 3c                	push   $0x3c
  jmp alltraps
80106477:	e9 2f f9 ff ff       	jmp    80105dab <alltraps>

8010647c <vector61>:
.globl vector61
vector61:
  pushl $0
8010647c:	6a 00                	push   $0x0
  pushl $61
8010647e:	6a 3d                	push   $0x3d
  jmp alltraps
80106480:	e9 26 f9 ff ff       	jmp    80105dab <alltraps>

80106485 <vector62>:
.globl vector62
vector62:
  pushl $0
80106485:	6a 00                	push   $0x0
  pushl $62
80106487:	6a 3e                	push   $0x3e
  jmp alltraps
80106489:	e9 1d f9 ff ff       	jmp    80105dab <alltraps>

8010648e <vector63>:
.globl vector63
vector63:
  pushl $0
8010648e:	6a 00                	push   $0x0
  pushl $63
80106490:	6a 3f                	push   $0x3f
  jmp alltraps
80106492:	e9 14 f9 ff ff       	jmp    80105dab <alltraps>

80106497 <vector64>:
.globl vector64
vector64:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $64
80106499:	6a 40                	push   $0x40
  jmp alltraps
8010649b:	e9 0b f9 ff ff       	jmp    80105dab <alltraps>

801064a0 <vector65>:
.globl vector65
vector65:
  pushl $0
801064a0:	6a 00                	push   $0x0
  pushl $65
801064a2:	6a 41                	push   $0x41
  jmp alltraps
801064a4:	e9 02 f9 ff ff       	jmp    80105dab <alltraps>

801064a9 <vector66>:
.globl vector66
vector66:
  pushl $0
801064a9:	6a 00                	push   $0x0
  pushl $66
801064ab:	6a 42                	push   $0x42
  jmp alltraps
801064ad:	e9 f9 f8 ff ff       	jmp    80105dab <alltraps>

801064b2 <vector67>:
.globl vector67
vector67:
  pushl $0
801064b2:	6a 00                	push   $0x0
  pushl $67
801064b4:	6a 43                	push   $0x43
  jmp alltraps
801064b6:	e9 f0 f8 ff ff       	jmp    80105dab <alltraps>

801064bb <vector68>:
.globl vector68
vector68:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $68
801064bd:	6a 44                	push   $0x44
  jmp alltraps
801064bf:	e9 e7 f8 ff ff       	jmp    80105dab <alltraps>

801064c4 <vector69>:
.globl vector69
vector69:
  pushl $0
801064c4:	6a 00                	push   $0x0
  pushl $69
801064c6:	6a 45                	push   $0x45
  jmp alltraps
801064c8:	e9 de f8 ff ff       	jmp    80105dab <alltraps>

801064cd <vector70>:
.globl vector70
vector70:
  pushl $0
801064cd:	6a 00                	push   $0x0
  pushl $70
801064cf:	6a 46                	push   $0x46
  jmp alltraps
801064d1:	e9 d5 f8 ff ff       	jmp    80105dab <alltraps>

801064d6 <vector71>:
.globl vector71
vector71:
  pushl $0
801064d6:	6a 00                	push   $0x0
  pushl $71
801064d8:	6a 47                	push   $0x47
  jmp alltraps
801064da:	e9 cc f8 ff ff       	jmp    80105dab <alltraps>

801064df <vector72>:
.globl vector72
vector72:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $72
801064e1:	6a 48                	push   $0x48
  jmp alltraps
801064e3:	e9 c3 f8 ff ff       	jmp    80105dab <alltraps>

801064e8 <vector73>:
.globl vector73
vector73:
  pushl $0
801064e8:	6a 00                	push   $0x0
  pushl $73
801064ea:	6a 49                	push   $0x49
  jmp alltraps
801064ec:	e9 ba f8 ff ff       	jmp    80105dab <alltraps>

801064f1 <vector74>:
.globl vector74
vector74:
  pushl $0
801064f1:	6a 00                	push   $0x0
  pushl $74
801064f3:	6a 4a                	push   $0x4a
  jmp alltraps
801064f5:	e9 b1 f8 ff ff       	jmp    80105dab <alltraps>

801064fa <vector75>:
.globl vector75
vector75:
  pushl $0
801064fa:	6a 00                	push   $0x0
  pushl $75
801064fc:	6a 4b                	push   $0x4b
  jmp alltraps
801064fe:	e9 a8 f8 ff ff       	jmp    80105dab <alltraps>

80106503 <vector76>:
.globl vector76
vector76:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $76
80106505:	6a 4c                	push   $0x4c
  jmp alltraps
80106507:	e9 9f f8 ff ff       	jmp    80105dab <alltraps>

8010650c <vector77>:
.globl vector77
vector77:
  pushl $0
8010650c:	6a 00                	push   $0x0
  pushl $77
8010650e:	6a 4d                	push   $0x4d
  jmp alltraps
80106510:	e9 96 f8 ff ff       	jmp    80105dab <alltraps>

80106515 <vector78>:
.globl vector78
vector78:
  pushl $0
80106515:	6a 00                	push   $0x0
  pushl $78
80106517:	6a 4e                	push   $0x4e
  jmp alltraps
80106519:	e9 8d f8 ff ff       	jmp    80105dab <alltraps>

8010651e <vector79>:
.globl vector79
vector79:
  pushl $0
8010651e:	6a 00                	push   $0x0
  pushl $79
80106520:	6a 4f                	push   $0x4f
  jmp alltraps
80106522:	e9 84 f8 ff ff       	jmp    80105dab <alltraps>

80106527 <vector80>:
.globl vector80
vector80:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $80
80106529:	6a 50                	push   $0x50
  jmp alltraps
8010652b:	e9 7b f8 ff ff       	jmp    80105dab <alltraps>

80106530 <vector81>:
.globl vector81
vector81:
  pushl $0
80106530:	6a 00                	push   $0x0
  pushl $81
80106532:	6a 51                	push   $0x51
  jmp alltraps
80106534:	e9 72 f8 ff ff       	jmp    80105dab <alltraps>

80106539 <vector82>:
.globl vector82
vector82:
  pushl $0
80106539:	6a 00                	push   $0x0
  pushl $82
8010653b:	6a 52                	push   $0x52
  jmp alltraps
8010653d:	e9 69 f8 ff ff       	jmp    80105dab <alltraps>

80106542 <vector83>:
.globl vector83
vector83:
  pushl $0
80106542:	6a 00                	push   $0x0
  pushl $83
80106544:	6a 53                	push   $0x53
  jmp alltraps
80106546:	e9 60 f8 ff ff       	jmp    80105dab <alltraps>

8010654b <vector84>:
.globl vector84
vector84:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $84
8010654d:	6a 54                	push   $0x54
  jmp alltraps
8010654f:	e9 57 f8 ff ff       	jmp    80105dab <alltraps>

80106554 <vector85>:
.globl vector85
vector85:
  pushl $0
80106554:	6a 00                	push   $0x0
  pushl $85
80106556:	6a 55                	push   $0x55
  jmp alltraps
80106558:	e9 4e f8 ff ff       	jmp    80105dab <alltraps>

8010655d <vector86>:
.globl vector86
vector86:
  pushl $0
8010655d:	6a 00                	push   $0x0
  pushl $86
8010655f:	6a 56                	push   $0x56
  jmp alltraps
80106561:	e9 45 f8 ff ff       	jmp    80105dab <alltraps>

80106566 <vector87>:
.globl vector87
vector87:
  pushl $0
80106566:	6a 00                	push   $0x0
  pushl $87
80106568:	6a 57                	push   $0x57
  jmp alltraps
8010656a:	e9 3c f8 ff ff       	jmp    80105dab <alltraps>

8010656f <vector88>:
.globl vector88
vector88:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $88
80106571:	6a 58                	push   $0x58
  jmp alltraps
80106573:	e9 33 f8 ff ff       	jmp    80105dab <alltraps>

80106578 <vector89>:
.globl vector89
vector89:
  pushl $0
80106578:	6a 00                	push   $0x0
  pushl $89
8010657a:	6a 59                	push   $0x59
  jmp alltraps
8010657c:	e9 2a f8 ff ff       	jmp    80105dab <alltraps>

80106581 <vector90>:
.globl vector90
vector90:
  pushl $0
80106581:	6a 00                	push   $0x0
  pushl $90
80106583:	6a 5a                	push   $0x5a
  jmp alltraps
80106585:	e9 21 f8 ff ff       	jmp    80105dab <alltraps>

8010658a <vector91>:
.globl vector91
vector91:
  pushl $0
8010658a:	6a 00                	push   $0x0
  pushl $91
8010658c:	6a 5b                	push   $0x5b
  jmp alltraps
8010658e:	e9 18 f8 ff ff       	jmp    80105dab <alltraps>

80106593 <vector92>:
.globl vector92
vector92:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $92
80106595:	6a 5c                	push   $0x5c
  jmp alltraps
80106597:	e9 0f f8 ff ff       	jmp    80105dab <alltraps>

8010659c <vector93>:
.globl vector93
vector93:
  pushl $0
8010659c:	6a 00                	push   $0x0
  pushl $93
8010659e:	6a 5d                	push   $0x5d
  jmp alltraps
801065a0:	e9 06 f8 ff ff       	jmp    80105dab <alltraps>

801065a5 <vector94>:
.globl vector94
vector94:
  pushl $0
801065a5:	6a 00                	push   $0x0
  pushl $94
801065a7:	6a 5e                	push   $0x5e
  jmp alltraps
801065a9:	e9 fd f7 ff ff       	jmp    80105dab <alltraps>

801065ae <vector95>:
.globl vector95
vector95:
  pushl $0
801065ae:	6a 00                	push   $0x0
  pushl $95
801065b0:	6a 5f                	push   $0x5f
  jmp alltraps
801065b2:	e9 f4 f7 ff ff       	jmp    80105dab <alltraps>

801065b7 <vector96>:
.globl vector96
vector96:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $96
801065b9:	6a 60                	push   $0x60
  jmp alltraps
801065bb:	e9 eb f7 ff ff       	jmp    80105dab <alltraps>

801065c0 <vector97>:
.globl vector97
vector97:
  pushl $0
801065c0:	6a 00                	push   $0x0
  pushl $97
801065c2:	6a 61                	push   $0x61
  jmp alltraps
801065c4:	e9 e2 f7 ff ff       	jmp    80105dab <alltraps>

801065c9 <vector98>:
.globl vector98
vector98:
  pushl $0
801065c9:	6a 00                	push   $0x0
  pushl $98
801065cb:	6a 62                	push   $0x62
  jmp alltraps
801065cd:	e9 d9 f7 ff ff       	jmp    80105dab <alltraps>

801065d2 <vector99>:
.globl vector99
vector99:
  pushl $0
801065d2:	6a 00                	push   $0x0
  pushl $99
801065d4:	6a 63                	push   $0x63
  jmp alltraps
801065d6:	e9 d0 f7 ff ff       	jmp    80105dab <alltraps>

801065db <vector100>:
.globl vector100
vector100:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $100
801065dd:	6a 64                	push   $0x64
  jmp alltraps
801065df:	e9 c7 f7 ff ff       	jmp    80105dab <alltraps>

801065e4 <vector101>:
.globl vector101
vector101:
  pushl $0
801065e4:	6a 00                	push   $0x0
  pushl $101
801065e6:	6a 65                	push   $0x65
  jmp alltraps
801065e8:	e9 be f7 ff ff       	jmp    80105dab <alltraps>

801065ed <vector102>:
.globl vector102
vector102:
  pushl $0
801065ed:	6a 00                	push   $0x0
  pushl $102
801065ef:	6a 66                	push   $0x66
  jmp alltraps
801065f1:	e9 b5 f7 ff ff       	jmp    80105dab <alltraps>

801065f6 <vector103>:
.globl vector103
vector103:
  pushl $0
801065f6:	6a 00                	push   $0x0
  pushl $103
801065f8:	6a 67                	push   $0x67
  jmp alltraps
801065fa:	e9 ac f7 ff ff       	jmp    80105dab <alltraps>

801065ff <vector104>:
.globl vector104
vector104:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $104
80106601:	6a 68                	push   $0x68
  jmp alltraps
80106603:	e9 a3 f7 ff ff       	jmp    80105dab <alltraps>

80106608 <vector105>:
.globl vector105
vector105:
  pushl $0
80106608:	6a 00                	push   $0x0
  pushl $105
8010660a:	6a 69                	push   $0x69
  jmp alltraps
8010660c:	e9 9a f7 ff ff       	jmp    80105dab <alltraps>

80106611 <vector106>:
.globl vector106
vector106:
  pushl $0
80106611:	6a 00                	push   $0x0
  pushl $106
80106613:	6a 6a                	push   $0x6a
  jmp alltraps
80106615:	e9 91 f7 ff ff       	jmp    80105dab <alltraps>

8010661a <vector107>:
.globl vector107
vector107:
  pushl $0
8010661a:	6a 00                	push   $0x0
  pushl $107
8010661c:	6a 6b                	push   $0x6b
  jmp alltraps
8010661e:	e9 88 f7 ff ff       	jmp    80105dab <alltraps>

80106623 <vector108>:
.globl vector108
vector108:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $108
80106625:	6a 6c                	push   $0x6c
  jmp alltraps
80106627:	e9 7f f7 ff ff       	jmp    80105dab <alltraps>

8010662c <vector109>:
.globl vector109
vector109:
  pushl $0
8010662c:	6a 00                	push   $0x0
  pushl $109
8010662e:	6a 6d                	push   $0x6d
  jmp alltraps
80106630:	e9 76 f7 ff ff       	jmp    80105dab <alltraps>

80106635 <vector110>:
.globl vector110
vector110:
  pushl $0
80106635:	6a 00                	push   $0x0
  pushl $110
80106637:	6a 6e                	push   $0x6e
  jmp alltraps
80106639:	e9 6d f7 ff ff       	jmp    80105dab <alltraps>

8010663e <vector111>:
.globl vector111
vector111:
  pushl $0
8010663e:	6a 00                	push   $0x0
  pushl $111
80106640:	6a 6f                	push   $0x6f
  jmp alltraps
80106642:	e9 64 f7 ff ff       	jmp    80105dab <alltraps>

80106647 <vector112>:
.globl vector112
vector112:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $112
80106649:	6a 70                	push   $0x70
  jmp alltraps
8010664b:	e9 5b f7 ff ff       	jmp    80105dab <alltraps>

80106650 <vector113>:
.globl vector113
vector113:
  pushl $0
80106650:	6a 00                	push   $0x0
  pushl $113
80106652:	6a 71                	push   $0x71
  jmp alltraps
80106654:	e9 52 f7 ff ff       	jmp    80105dab <alltraps>

80106659 <vector114>:
.globl vector114
vector114:
  pushl $0
80106659:	6a 00                	push   $0x0
  pushl $114
8010665b:	6a 72                	push   $0x72
  jmp alltraps
8010665d:	e9 49 f7 ff ff       	jmp    80105dab <alltraps>

80106662 <vector115>:
.globl vector115
vector115:
  pushl $0
80106662:	6a 00                	push   $0x0
  pushl $115
80106664:	6a 73                	push   $0x73
  jmp alltraps
80106666:	e9 40 f7 ff ff       	jmp    80105dab <alltraps>

8010666b <vector116>:
.globl vector116
vector116:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $116
8010666d:	6a 74                	push   $0x74
  jmp alltraps
8010666f:	e9 37 f7 ff ff       	jmp    80105dab <alltraps>

80106674 <vector117>:
.globl vector117
vector117:
  pushl $0
80106674:	6a 00                	push   $0x0
  pushl $117
80106676:	6a 75                	push   $0x75
  jmp alltraps
80106678:	e9 2e f7 ff ff       	jmp    80105dab <alltraps>

8010667d <vector118>:
.globl vector118
vector118:
  pushl $0
8010667d:	6a 00                	push   $0x0
  pushl $118
8010667f:	6a 76                	push   $0x76
  jmp alltraps
80106681:	e9 25 f7 ff ff       	jmp    80105dab <alltraps>

80106686 <vector119>:
.globl vector119
vector119:
  pushl $0
80106686:	6a 00                	push   $0x0
  pushl $119
80106688:	6a 77                	push   $0x77
  jmp alltraps
8010668a:	e9 1c f7 ff ff       	jmp    80105dab <alltraps>

8010668f <vector120>:
.globl vector120
vector120:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $120
80106691:	6a 78                	push   $0x78
  jmp alltraps
80106693:	e9 13 f7 ff ff       	jmp    80105dab <alltraps>

80106698 <vector121>:
.globl vector121
vector121:
  pushl $0
80106698:	6a 00                	push   $0x0
  pushl $121
8010669a:	6a 79                	push   $0x79
  jmp alltraps
8010669c:	e9 0a f7 ff ff       	jmp    80105dab <alltraps>

801066a1 <vector122>:
.globl vector122
vector122:
  pushl $0
801066a1:	6a 00                	push   $0x0
  pushl $122
801066a3:	6a 7a                	push   $0x7a
  jmp alltraps
801066a5:	e9 01 f7 ff ff       	jmp    80105dab <alltraps>

801066aa <vector123>:
.globl vector123
vector123:
  pushl $0
801066aa:	6a 00                	push   $0x0
  pushl $123
801066ac:	6a 7b                	push   $0x7b
  jmp alltraps
801066ae:	e9 f8 f6 ff ff       	jmp    80105dab <alltraps>

801066b3 <vector124>:
.globl vector124
vector124:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $124
801066b5:	6a 7c                	push   $0x7c
  jmp alltraps
801066b7:	e9 ef f6 ff ff       	jmp    80105dab <alltraps>

801066bc <vector125>:
.globl vector125
vector125:
  pushl $0
801066bc:	6a 00                	push   $0x0
  pushl $125
801066be:	6a 7d                	push   $0x7d
  jmp alltraps
801066c0:	e9 e6 f6 ff ff       	jmp    80105dab <alltraps>

801066c5 <vector126>:
.globl vector126
vector126:
  pushl $0
801066c5:	6a 00                	push   $0x0
  pushl $126
801066c7:	6a 7e                	push   $0x7e
  jmp alltraps
801066c9:	e9 dd f6 ff ff       	jmp    80105dab <alltraps>

801066ce <vector127>:
.globl vector127
vector127:
  pushl $0
801066ce:	6a 00                	push   $0x0
  pushl $127
801066d0:	6a 7f                	push   $0x7f
  jmp alltraps
801066d2:	e9 d4 f6 ff ff       	jmp    80105dab <alltraps>

801066d7 <vector128>:
.globl vector128
vector128:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $128
801066d9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801066de:	e9 c8 f6 ff ff       	jmp    80105dab <alltraps>

801066e3 <vector129>:
.globl vector129
vector129:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $129
801066e5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801066ea:	e9 bc f6 ff ff       	jmp    80105dab <alltraps>

801066ef <vector130>:
.globl vector130
vector130:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $130
801066f1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801066f6:	e9 b0 f6 ff ff       	jmp    80105dab <alltraps>

801066fb <vector131>:
.globl vector131
vector131:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $131
801066fd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106702:	e9 a4 f6 ff ff       	jmp    80105dab <alltraps>

80106707 <vector132>:
.globl vector132
vector132:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $132
80106709:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010670e:	e9 98 f6 ff ff       	jmp    80105dab <alltraps>

80106713 <vector133>:
.globl vector133
vector133:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $133
80106715:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010671a:	e9 8c f6 ff ff       	jmp    80105dab <alltraps>

8010671f <vector134>:
.globl vector134
vector134:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $134
80106721:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106726:	e9 80 f6 ff ff       	jmp    80105dab <alltraps>

8010672b <vector135>:
.globl vector135
vector135:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $135
8010672d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106732:	e9 74 f6 ff ff       	jmp    80105dab <alltraps>

80106737 <vector136>:
.globl vector136
vector136:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $136
80106739:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010673e:	e9 68 f6 ff ff       	jmp    80105dab <alltraps>

80106743 <vector137>:
.globl vector137
vector137:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $137
80106745:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010674a:	e9 5c f6 ff ff       	jmp    80105dab <alltraps>

8010674f <vector138>:
.globl vector138
vector138:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $138
80106751:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106756:	e9 50 f6 ff ff       	jmp    80105dab <alltraps>

8010675b <vector139>:
.globl vector139
vector139:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $139
8010675d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106762:	e9 44 f6 ff ff       	jmp    80105dab <alltraps>

80106767 <vector140>:
.globl vector140
vector140:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $140
80106769:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010676e:	e9 38 f6 ff ff       	jmp    80105dab <alltraps>

80106773 <vector141>:
.globl vector141
vector141:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $141
80106775:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010677a:	e9 2c f6 ff ff       	jmp    80105dab <alltraps>

8010677f <vector142>:
.globl vector142
vector142:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $142
80106781:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106786:	e9 20 f6 ff ff       	jmp    80105dab <alltraps>

8010678b <vector143>:
.globl vector143
vector143:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $143
8010678d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106792:	e9 14 f6 ff ff       	jmp    80105dab <alltraps>

80106797 <vector144>:
.globl vector144
vector144:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $144
80106799:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010679e:	e9 08 f6 ff ff       	jmp    80105dab <alltraps>

801067a3 <vector145>:
.globl vector145
vector145:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $145
801067a5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801067aa:	e9 fc f5 ff ff       	jmp    80105dab <alltraps>

801067af <vector146>:
.globl vector146
vector146:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $146
801067b1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801067b6:	e9 f0 f5 ff ff       	jmp    80105dab <alltraps>

801067bb <vector147>:
.globl vector147
vector147:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $147
801067bd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801067c2:	e9 e4 f5 ff ff       	jmp    80105dab <alltraps>

801067c7 <vector148>:
.globl vector148
vector148:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $148
801067c9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801067ce:	e9 d8 f5 ff ff       	jmp    80105dab <alltraps>

801067d3 <vector149>:
.globl vector149
vector149:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $149
801067d5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801067da:	e9 cc f5 ff ff       	jmp    80105dab <alltraps>

801067df <vector150>:
.globl vector150
vector150:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $150
801067e1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801067e6:	e9 c0 f5 ff ff       	jmp    80105dab <alltraps>

801067eb <vector151>:
.globl vector151
vector151:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $151
801067ed:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801067f2:	e9 b4 f5 ff ff       	jmp    80105dab <alltraps>

801067f7 <vector152>:
.globl vector152
vector152:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $152
801067f9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801067fe:	e9 a8 f5 ff ff       	jmp    80105dab <alltraps>

80106803 <vector153>:
.globl vector153
vector153:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $153
80106805:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010680a:	e9 9c f5 ff ff       	jmp    80105dab <alltraps>

8010680f <vector154>:
.globl vector154
vector154:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $154
80106811:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106816:	e9 90 f5 ff ff       	jmp    80105dab <alltraps>

8010681b <vector155>:
.globl vector155
vector155:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $155
8010681d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106822:	e9 84 f5 ff ff       	jmp    80105dab <alltraps>

80106827 <vector156>:
.globl vector156
vector156:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $156
80106829:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010682e:	e9 78 f5 ff ff       	jmp    80105dab <alltraps>

80106833 <vector157>:
.globl vector157
vector157:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $157
80106835:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010683a:	e9 6c f5 ff ff       	jmp    80105dab <alltraps>

8010683f <vector158>:
.globl vector158
vector158:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $158
80106841:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106846:	e9 60 f5 ff ff       	jmp    80105dab <alltraps>

8010684b <vector159>:
.globl vector159
vector159:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $159
8010684d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106852:	e9 54 f5 ff ff       	jmp    80105dab <alltraps>

80106857 <vector160>:
.globl vector160
vector160:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $160
80106859:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010685e:	e9 48 f5 ff ff       	jmp    80105dab <alltraps>

80106863 <vector161>:
.globl vector161
vector161:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $161
80106865:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010686a:	e9 3c f5 ff ff       	jmp    80105dab <alltraps>

8010686f <vector162>:
.globl vector162
vector162:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $162
80106871:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106876:	e9 30 f5 ff ff       	jmp    80105dab <alltraps>

8010687b <vector163>:
.globl vector163
vector163:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $163
8010687d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106882:	e9 24 f5 ff ff       	jmp    80105dab <alltraps>

80106887 <vector164>:
.globl vector164
vector164:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $164
80106889:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010688e:	e9 18 f5 ff ff       	jmp    80105dab <alltraps>

80106893 <vector165>:
.globl vector165
vector165:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $165
80106895:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010689a:	e9 0c f5 ff ff       	jmp    80105dab <alltraps>

8010689f <vector166>:
.globl vector166
vector166:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $166
801068a1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801068a6:	e9 00 f5 ff ff       	jmp    80105dab <alltraps>

801068ab <vector167>:
.globl vector167
vector167:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $167
801068ad:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801068b2:	e9 f4 f4 ff ff       	jmp    80105dab <alltraps>

801068b7 <vector168>:
.globl vector168
vector168:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $168
801068b9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801068be:	e9 e8 f4 ff ff       	jmp    80105dab <alltraps>

801068c3 <vector169>:
.globl vector169
vector169:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $169
801068c5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801068ca:	e9 dc f4 ff ff       	jmp    80105dab <alltraps>

801068cf <vector170>:
.globl vector170
vector170:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $170
801068d1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801068d6:	e9 d0 f4 ff ff       	jmp    80105dab <alltraps>

801068db <vector171>:
.globl vector171
vector171:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $171
801068dd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801068e2:	e9 c4 f4 ff ff       	jmp    80105dab <alltraps>

801068e7 <vector172>:
.globl vector172
vector172:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $172
801068e9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801068ee:	e9 b8 f4 ff ff       	jmp    80105dab <alltraps>

801068f3 <vector173>:
.globl vector173
vector173:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $173
801068f5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801068fa:	e9 ac f4 ff ff       	jmp    80105dab <alltraps>

801068ff <vector174>:
.globl vector174
vector174:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $174
80106901:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106906:	e9 a0 f4 ff ff       	jmp    80105dab <alltraps>

8010690b <vector175>:
.globl vector175
vector175:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $175
8010690d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106912:	e9 94 f4 ff ff       	jmp    80105dab <alltraps>

80106917 <vector176>:
.globl vector176
vector176:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $176
80106919:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010691e:	e9 88 f4 ff ff       	jmp    80105dab <alltraps>

80106923 <vector177>:
.globl vector177
vector177:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $177
80106925:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010692a:	e9 7c f4 ff ff       	jmp    80105dab <alltraps>

8010692f <vector178>:
.globl vector178
vector178:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $178
80106931:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106936:	e9 70 f4 ff ff       	jmp    80105dab <alltraps>

8010693b <vector179>:
.globl vector179
vector179:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $179
8010693d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106942:	e9 64 f4 ff ff       	jmp    80105dab <alltraps>

80106947 <vector180>:
.globl vector180
vector180:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $180
80106949:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010694e:	e9 58 f4 ff ff       	jmp    80105dab <alltraps>

80106953 <vector181>:
.globl vector181
vector181:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $181
80106955:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010695a:	e9 4c f4 ff ff       	jmp    80105dab <alltraps>

8010695f <vector182>:
.globl vector182
vector182:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $182
80106961:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106966:	e9 40 f4 ff ff       	jmp    80105dab <alltraps>

8010696b <vector183>:
.globl vector183
vector183:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $183
8010696d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106972:	e9 34 f4 ff ff       	jmp    80105dab <alltraps>

80106977 <vector184>:
.globl vector184
vector184:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $184
80106979:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010697e:	e9 28 f4 ff ff       	jmp    80105dab <alltraps>

80106983 <vector185>:
.globl vector185
vector185:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $185
80106985:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010698a:	e9 1c f4 ff ff       	jmp    80105dab <alltraps>

8010698f <vector186>:
.globl vector186
vector186:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $186
80106991:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106996:	e9 10 f4 ff ff       	jmp    80105dab <alltraps>

8010699b <vector187>:
.globl vector187
vector187:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $187
8010699d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801069a2:	e9 04 f4 ff ff       	jmp    80105dab <alltraps>

801069a7 <vector188>:
.globl vector188
vector188:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $188
801069a9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801069ae:	e9 f8 f3 ff ff       	jmp    80105dab <alltraps>

801069b3 <vector189>:
.globl vector189
vector189:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $189
801069b5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801069ba:	e9 ec f3 ff ff       	jmp    80105dab <alltraps>

801069bf <vector190>:
.globl vector190
vector190:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $190
801069c1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801069c6:	e9 e0 f3 ff ff       	jmp    80105dab <alltraps>

801069cb <vector191>:
.globl vector191
vector191:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $191
801069cd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801069d2:	e9 d4 f3 ff ff       	jmp    80105dab <alltraps>

801069d7 <vector192>:
.globl vector192
vector192:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $192
801069d9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801069de:	e9 c8 f3 ff ff       	jmp    80105dab <alltraps>

801069e3 <vector193>:
.globl vector193
vector193:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $193
801069e5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801069ea:	e9 bc f3 ff ff       	jmp    80105dab <alltraps>

801069ef <vector194>:
.globl vector194
vector194:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $194
801069f1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801069f6:	e9 b0 f3 ff ff       	jmp    80105dab <alltraps>

801069fb <vector195>:
.globl vector195
vector195:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $195
801069fd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106a02:	e9 a4 f3 ff ff       	jmp    80105dab <alltraps>

80106a07 <vector196>:
.globl vector196
vector196:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $196
80106a09:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106a0e:	e9 98 f3 ff ff       	jmp    80105dab <alltraps>

80106a13 <vector197>:
.globl vector197
vector197:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $197
80106a15:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106a1a:	e9 8c f3 ff ff       	jmp    80105dab <alltraps>

80106a1f <vector198>:
.globl vector198
vector198:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $198
80106a21:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106a26:	e9 80 f3 ff ff       	jmp    80105dab <alltraps>

80106a2b <vector199>:
.globl vector199
vector199:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $199
80106a2d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106a32:	e9 74 f3 ff ff       	jmp    80105dab <alltraps>

80106a37 <vector200>:
.globl vector200
vector200:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $200
80106a39:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106a3e:	e9 68 f3 ff ff       	jmp    80105dab <alltraps>

80106a43 <vector201>:
.globl vector201
vector201:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $201
80106a45:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106a4a:	e9 5c f3 ff ff       	jmp    80105dab <alltraps>

80106a4f <vector202>:
.globl vector202
vector202:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $202
80106a51:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106a56:	e9 50 f3 ff ff       	jmp    80105dab <alltraps>

80106a5b <vector203>:
.globl vector203
vector203:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $203
80106a5d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106a62:	e9 44 f3 ff ff       	jmp    80105dab <alltraps>

80106a67 <vector204>:
.globl vector204
vector204:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $204
80106a69:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106a6e:	e9 38 f3 ff ff       	jmp    80105dab <alltraps>

80106a73 <vector205>:
.globl vector205
vector205:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $205
80106a75:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106a7a:	e9 2c f3 ff ff       	jmp    80105dab <alltraps>

80106a7f <vector206>:
.globl vector206
vector206:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $206
80106a81:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106a86:	e9 20 f3 ff ff       	jmp    80105dab <alltraps>

80106a8b <vector207>:
.globl vector207
vector207:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $207
80106a8d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106a92:	e9 14 f3 ff ff       	jmp    80105dab <alltraps>

80106a97 <vector208>:
.globl vector208
vector208:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $208
80106a99:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106a9e:	e9 08 f3 ff ff       	jmp    80105dab <alltraps>

80106aa3 <vector209>:
.globl vector209
vector209:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $209
80106aa5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106aaa:	e9 fc f2 ff ff       	jmp    80105dab <alltraps>

80106aaf <vector210>:
.globl vector210
vector210:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $210
80106ab1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106ab6:	e9 f0 f2 ff ff       	jmp    80105dab <alltraps>

80106abb <vector211>:
.globl vector211
vector211:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $211
80106abd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106ac2:	e9 e4 f2 ff ff       	jmp    80105dab <alltraps>

80106ac7 <vector212>:
.globl vector212
vector212:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $212
80106ac9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106ace:	e9 d8 f2 ff ff       	jmp    80105dab <alltraps>

80106ad3 <vector213>:
.globl vector213
vector213:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $213
80106ad5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106ada:	e9 cc f2 ff ff       	jmp    80105dab <alltraps>

80106adf <vector214>:
.globl vector214
vector214:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $214
80106ae1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106ae6:	e9 c0 f2 ff ff       	jmp    80105dab <alltraps>

80106aeb <vector215>:
.globl vector215
vector215:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $215
80106aed:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106af2:	e9 b4 f2 ff ff       	jmp    80105dab <alltraps>

80106af7 <vector216>:
.globl vector216
vector216:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $216
80106af9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106afe:	e9 a8 f2 ff ff       	jmp    80105dab <alltraps>

80106b03 <vector217>:
.globl vector217
vector217:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $217
80106b05:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106b0a:	e9 9c f2 ff ff       	jmp    80105dab <alltraps>

80106b0f <vector218>:
.globl vector218
vector218:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $218
80106b11:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106b16:	e9 90 f2 ff ff       	jmp    80105dab <alltraps>

80106b1b <vector219>:
.globl vector219
vector219:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $219
80106b1d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106b22:	e9 84 f2 ff ff       	jmp    80105dab <alltraps>

80106b27 <vector220>:
.globl vector220
vector220:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $220
80106b29:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106b2e:	e9 78 f2 ff ff       	jmp    80105dab <alltraps>

80106b33 <vector221>:
.globl vector221
vector221:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $221
80106b35:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106b3a:	e9 6c f2 ff ff       	jmp    80105dab <alltraps>

80106b3f <vector222>:
.globl vector222
vector222:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $222
80106b41:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106b46:	e9 60 f2 ff ff       	jmp    80105dab <alltraps>

80106b4b <vector223>:
.globl vector223
vector223:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $223
80106b4d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106b52:	e9 54 f2 ff ff       	jmp    80105dab <alltraps>

80106b57 <vector224>:
.globl vector224
vector224:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $224
80106b59:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106b5e:	e9 48 f2 ff ff       	jmp    80105dab <alltraps>

80106b63 <vector225>:
.globl vector225
vector225:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $225
80106b65:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106b6a:	e9 3c f2 ff ff       	jmp    80105dab <alltraps>

80106b6f <vector226>:
.globl vector226
vector226:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $226
80106b71:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106b76:	e9 30 f2 ff ff       	jmp    80105dab <alltraps>

80106b7b <vector227>:
.globl vector227
vector227:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $227
80106b7d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106b82:	e9 24 f2 ff ff       	jmp    80105dab <alltraps>

80106b87 <vector228>:
.globl vector228
vector228:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $228
80106b89:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106b8e:	e9 18 f2 ff ff       	jmp    80105dab <alltraps>

80106b93 <vector229>:
.globl vector229
vector229:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $229
80106b95:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106b9a:	e9 0c f2 ff ff       	jmp    80105dab <alltraps>

80106b9f <vector230>:
.globl vector230
vector230:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $230
80106ba1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106ba6:	e9 00 f2 ff ff       	jmp    80105dab <alltraps>

80106bab <vector231>:
.globl vector231
vector231:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $231
80106bad:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106bb2:	e9 f4 f1 ff ff       	jmp    80105dab <alltraps>

80106bb7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $232
80106bb9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106bbe:	e9 e8 f1 ff ff       	jmp    80105dab <alltraps>

80106bc3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $233
80106bc5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106bca:	e9 dc f1 ff ff       	jmp    80105dab <alltraps>

80106bcf <vector234>:
.globl vector234
vector234:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $234
80106bd1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106bd6:	e9 d0 f1 ff ff       	jmp    80105dab <alltraps>

80106bdb <vector235>:
.globl vector235
vector235:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $235
80106bdd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106be2:	e9 c4 f1 ff ff       	jmp    80105dab <alltraps>

80106be7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $236
80106be9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106bee:	e9 b8 f1 ff ff       	jmp    80105dab <alltraps>

80106bf3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $237
80106bf5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106bfa:	e9 ac f1 ff ff       	jmp    80105dab <alltraps>

80106bff <vector238>:
.globl vector238
vector238:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $238
80106c01:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106c06:	e9 a0 f1 ff ff       	jmp    80105dab <alltraps>

80106c0b <vector239>:
.globl vector239
vector239:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $239
80106c0d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106c12:	e9 94 f1 ff ff       	jmp    80105dab <alltraps>

80106c17 <vector240>:
.globl vector240
vector240:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $240
80106c19:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106c1e:	e9 88 f1 ff ff       	jmp    80105dab <alltraps>

80106c23 <vector241>:
.globl vector241
vector241:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $241
80106c25:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106c2a:	e9 7c f1 ff ff       	jmp    80105dab <alltraps>

80106c2f <vector242>:
.globl vector242
vector242:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $242
80106c31:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106c36:	e9 70 f1 ff ff       	jmp    80105dab <alltraps>

80106c3b <vector243>:
.globl vector243
vector243:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $243
80106c3d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106c42:	e9 64 f1 ff ff       	jmp    80105dab <alltraps>

80106c47 <vector244>:
.globl vector244
vector244:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $244
80106c49:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106c4e:	e9 58 f1 ff ff       	jmp    80105dab <alltraps>

80106c53 <vector245>:
.globl vector245
vector245:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $245
80106c55:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106c5a:	e9 4c f1 ff ff       	jmp    80105dab <alltraps>

80106c5f <vector246>:
.globl vector246
vector246:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $246
80106c61:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106c66:	e9 40 f1 ff ff       	jmp    80105dab <alltraps>

80106c6b <vector247>:
.globl vector247
vector247:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $247
80106c6d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106c72:	e9 34 f1 ff ff       	jmp    80105dab <alltraps>

80106c77 <vector248>:
.globl vector248
vector248:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $248
80106c79:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106c7e:	e9 28 f1 ff ff       	jmp    80105dab <alltraps>

80106c83 <vector249>:
.globl vector249
vector249:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $249
80106c85:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106c8a:	e9 1c f1 ff ff       	jmp    80105dab <alltraps>

80106c8f <vector250>:
.globl vector250
vector250:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $250
80106c91:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106c96:	e9 10 f1 ff ff       	jmp    80105dab <alltraps>

80106c9b <vector251>:
.globl vector251
vector251:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $251
80106c9d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106ca2:	e9 04 f1 ff ff       	jmp    80105dab <alltraps>

80106ca7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $252
80106ca9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106cae:	e9 f8 f0 ff ff       	jmp    80105dab <alltraps>

80106cb3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $253
80106cb5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106cba:	e9 ec f0 ff ff       	jmp    80105dab <alltraps>

80106cbf <vector254>:
.globl vector254
vector254:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $254
80106cc1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106cc6:	e9 e0 f0 ff ff       	jmp    80105dab <alltraps>

80106ccb <vector255>:
.globl vector255
vector255:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $255
80106ccd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106cd2:	e9 d4 f0 ff ff       	jmp    80105dab <alltraps>
80106cd7:	66 90                	xchg   %ax,%ax
80106cd9:	66 90                	xchg   %ax,%ax
80106cdb:	66 90                	xchg   %ax,%ax
80106cdd:	66 90                	xchg   %ax,%ax
80106cdf:	90                   	nop

80106ce0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106ce0:	55                   	push   %ebp
80106ce1:	89 e5                	mov    %esp,%ebp
80106ce3:	57                   	push   %edi
80106ce4:	56                   	push   %esi
80106ce5:	53                   	push   %ebx
80106ce6:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106ce8:	c1 ea 16             	shr    $0x16,%edx
80106ceb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106cee:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80106cf1:	8b 07                	mov    (%edi),%eax
80106cf3:	a8 01                	test   $0x1,%al
80106cf5:	74 29                	je     80106d20 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106cf7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106cfc:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106d02:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106d05:	c1 eb 0a             	shr    $0xa,%ebx
80106d08:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
80106d0e:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
80106d11:	5b                   	pop    %ebx
80106d12:	5e                   	pop    %esi
80106d13:	5f                   	pop    %edi
80106d14:	5d                   	pop    %ebp
80106d15:	c3                   	ret    
80106d16:	8d 76 00             	lea    0x0(%esi),%esi
80106d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106d20:	85 c9                	test   %ecx,%ecx
80106d22:	74 2c                	je     80106d50 <walkpgdir+0x70>
80106d24:	e8 b7 b9 ff ff       	call   801026e0 <kalloc>
80106d29:	85 c0                	test   %eax,%eax
80106d2b:	89 c6                	mov    %eax,%esi
80106d2d:	74 21                	je     80106d50 <walkpgdir+0x70>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80106d2f:	83 ec 04             	sub    $0x4,%esp
80106d32:	68 00 10 00 00       	push   $0x1000
80106d37:	6a 00                	push   $0x0
80106d39:	50                   	push   %eax
80106d3a:	e8 21 dc ff ff       	call   80104960 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106d3f:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106d45:	83 c4 10             	add    $0x10,%esp
80106d48:	83 c8 07             	or     $0x7,%eax
80106d4b:	89 07                	mov    %eax,(%edi)
80106d4d:	eb b3                	jmp    80106d02 <walkpgdir+0x22>
80106d4f:	90                   	nop
  }
  return &pgtab[PTX(va)];
}
80106d50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
80106d53:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106d55:	5b                   	pop    %ebx
80106d56:	5e                   	pop    %esi
80106d57:	5f                   	pop    %edi
80106d58:	5d                   	pop    %ebp
80106d59:	c3                   	ret    
80106d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106d60 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106d60:	55                   	push   %ebp
80106d61:	89 e5                	mov    %esp,%ebp
80106d63:	57                   	push   %edi
80106d64:	56                   	push   %esi
80106d65:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106d66:	89 d3                	mov    %edx,%ebx
80106d68:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106d6e:	83 ec 1c             	sub    $0x1c,%esp
80106d71:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106d74:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106d78:	8b 7d 08             	mov    0x8(%ebp),%edi
80106d7b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d80:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106d83:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d86:	29 df                	sub    %ebx,%edi
80106d88:	83 c8 01             	or     $0x1,%eax
80106d8b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106d8e:	eb 15                	jmp    80106da5 <mappages+0x45>
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106d90:	f6 00 01             	testb  $0x1,(%eax)
80106d93:	75 45                	jne    80106dda <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106d95:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106d98:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106d9b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106d9d:	74 31                	je     80106dd0 <mappages+0x70>
      break;
    a += PGSIZE;
80106d9f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106da5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106da8:	b9 01 00 00 00       	mov    $0x1,%ecx
80106dad:	89 da                	mov    %ebx,%edx
80106daf:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106db2:	e8 29 ff ff ff       	call   80106ce0 <walkpgdir>
80106db7:	85 c0                	test   %eax,%eax
80106db9:	75 d5                	jne    80106d90 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106dbb:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
80106dbe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106dc3:	5b                   	pop    %ebx
80106dc4:	5e                   	pop    %esi
80106dc5:	5f                   	pop    %edi
80106dc6:	5d                   	pop    %ebp
80106dc7:	c3                   	ret    
80106dc8:	90                   	nop
80106dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80106dd3:	31 c0                	xor    %eax,%eax
}
80106dd5:	5b                   	pop    %ebx
80106dd6:	5e                   	pop    %esi
80106dd7:	5f                   	pop    %edi
80106dd8:	5d                   	pop    %ebp
80106dd9:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
80106dda:	83 ec 0c             	sub    $0xc,%esp
80106ddd:	68 c8 7f 10 80       	push   $0x80107fc8
80106de2:	e8 89 95 ff ff       	call   80100370 <panic>
80106de7:	89 f6                	mov    %esi,%esi
80106de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106df0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106df0:	55                   	push   %ebp
80106df1:	89 e5                	mov    %esp,%ebp
80106df3:	57                   	push   %edi
80106df4:	56                   	push   %esi
80106df5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106df6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106dfc:	89 c7                	mov    %eax,%edi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106dfe:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106e04:	83 ec 1c             	sub    $0x1c,%esp
80106e07:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106e0a:	39 d3                	cmp    %edx,%ebx
80106e0c:	73 66                	jae    80106e74 <deallocuvm.part.0+0x84>
80106e0e:	89 d6                	mov    %edx,%esi
80106e10:	eb 3d                	jmp    80106e4f <deallocuvm.part.0+0x5f>
80106e12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106e18:	8b 10                	mov    (%eax),%edx
80106e1a:	f6 c2 01             	test   $0x1,%dl
80106e1d:	74 26                	je     80106e45 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106e1f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106e25:	74 58                	je     80106e7f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106e27:	83 ec 0c             	sub    $0xc,%esp
80106e2a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106e30:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106e33:	52                   	push   %edx
80106e34:	e8 f7 b6 ff ff       	call   80102530 <kfree>
      *pte = 0;
80106e39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e3c:	83 c4 10             	add    $0x10,%esp
80106e3f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106e45:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106e4b:	39 f3                	cmp    %esi,%ebx
80106e4d:	73 25                	jae    80106e74 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106e4f:	31 c9                	xor    %ecx,%ecx
80106e51:	89 da                	mov    %ebx,%edx
80106e53:	89 f8                	mov    %edi,%eax
80106e55:	e8 86 fe ff ff       	call   80106ce0 <walkpgdir>
    if(!pte)
80106e5a:	85 c0                	test   %eax,%eax
80106e5c:	75 ba                	jne    80106e18 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106e5e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106e64:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106e6a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106e70:	39 f3                	cmp    %esi,%ebx
80106e72:	72 db                	jb     80106e4f <deallocuvm.part.0+0x5f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106e74:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106e77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e7a:	5b                   	pop    %ebx
80106e7b:	5e                   	pop    %esi
80106e7c:	5f                   	pop    %edi
80106e7d:	5d                   	pop    %ebp
80106e7e:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
80106e7f:	83 ec 0c             	sub    $0xc,%esp
80106e82:	68 c6 78 10 80       	push   $0x801078c6
80106e87:	e8 e4 94 ff ff       	call   80100370 <panic>
80106e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106e90 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106e90:	55                   	push   %ebp
80106e91:	89 e5                	mov    %esp,%ebp
80106e93:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106e96:	e8 15 cb ff ff       	call   801039b0 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106e9b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106ea1:	31 c9                	xor    %ecx,%ecx
80106ea3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106ea8:	66 89 90 78 38 11 80 	mov    %dx,-0x7feec788(%eax)
80106eaf:	66 89 88 7a 38 11 80 	mov    %cx,-0x7feec786(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106eb6:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106ebb:	31 c9                	xor    %ecx,%ecx
80106ebd:	66 89 90 80 38 11 80 	mov    %dx,-0x7feec780(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106ec4:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106ec9:	66 89 88 82 38 11 80 	mov    %cx,-0x7feec77e(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106ed0:	31 c9                	xor    %ecx,%ecx
80106ed2:	66 89 90 88 38 11 80 	mov    %dx,-0x7feec778(%eax)
80106ed9:	66 89 88 8a 38 11 80 	mov    %cx,-0x7feec776(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106ee0:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106ee5:	31 c9                	xor    %ecx,%ecx
80106ee7:	66 89 90 90 38 11 80 	mov    %dx,-0x7feec770(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106eee:	c6 80 7c 38 11 80 00 	movb   $0x0,-0x7feec784(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106ef5:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106efa:	c6 80 7d 38 11 80 9a 	movb   $0x9a,-0x7feec783(%eax)
80106f01:	c6 80 7e 38 11 80 cf 	movb   $0xcf,-0x7feec782(%eax)
80106f08:	c6 80 7f 38 11 80 00 	movb   $0x0,-0x7feec781(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106f0f:	c6 80 84 38 11 80 00 	movb   $0x0,-0x7feec77c(%eax)
80106f16:	c6 80 85 38 11 80 92 	movb   $0x92,-0x7feec77b(%eax)
80106f1d:	c6 80 86 38 11 80 cf 	movb   $0xcf,-0x7feec77a(%eax)
80106f24:	c6 80 87 38 11 80 00 	movb   $0x0,-0x7feec779(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106f2b:	c6 80 8c 38 11 80 00 	movb   $0x0,-0x7feec774(%eax)
80106f32:	c6 80 8d 38 11 80 fa 	movb   $0xfa,-0x7feec773(%eax)
80106f39:	c6 80 8e 38 11 80 cf 	movb   $0xcf,-0x7feec772(%eax)
80106f40:	c6 80 8f 38 11 80 00 	movb   $0x0,-0x7feec771(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106f47:	66 89 88 92 38 11 80 	mov    %cx,-0x7feec76e(%eax)
80106f4e:	c6 80 94 38 11 80 00 	movb   $0x0,-0x7feec76c(%eax)
80106f55:	c6 80 95 38 11 80 f2 	movb   $0xf2,-0x7feec76b(%eax)
80106f5c:	c6 80 96 38 11 80 cf 	movb   $0xcf,-0x7feec76a(%eax)
80106f63:	c6 80 97 38 11 80 00 	movb   $0x0,-0x7feec769(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80106f6a:	05 70 38 11 80       	add    $0x80113870,%eax
80106f6f:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80106f73:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106f77:	c1 e8 10             	shr    $0x10,%eax
80106f7a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80106f7e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106f81:	0f 01 10             	lgdtl  (%eax)
}
80106f84:	c9                   	leave  
80106f85:	c3                   	ret    
80106f86:	8d 76 00             	lea    0x0(%esi),%esi
80106f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f90 <switchkvm>:
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106f90:	a1 44 66 11 80       	mov    0x80116644,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106f95:	55                   	push   %ebp
80106f96:	89 e5                	mov    %esp,%ebp
80106f98:	05 00 00 00 80       	add    $0x80000000,%eax
80106f9d:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
80106fa0:	5d                   	pop    %ebp
80106fa1:	c3                   	ret    
80106fa2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106fb0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106fb0:	55                   	push   %ebp
80106fb1:	89 e5                	mov    %esp,%ebp
80106fb3:	57                   	push   %edi
80106fb4:	56                   	push   %esi
80106fb5:	53                   	push   %ebx
80106fb6:	83 ec 1c             	sub    $0x1c,%esp
80106fb9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106fbc:	85 f6                	test   %esi,%esi
80106fbe:	0f 84 cd 00 00 00    	je     80107091 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80106fc4:	8b 46 08             	mov    0x8(%esi),%eax
80106fc7:	85 c0                	test   %eax,%eax
80106fc9:	0f 84 dc 00 00 00    	je     801070ab <switchuvm+0xfb>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80106fcf:	8b 7e 04             	mov    0x4(%esi),%edi
80106fd2:	85 ff                	test   %edi,%edi
80106fd4:	0f 84 c4 00 00 00    	je     8010709e <switchuvm+0xee>
    panic("switchuvm: no pgdir");

  pushcli();
80106fda:	e8 a1 d7 ff ff       	call   80104780 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106fdf:	e8 4c c9 ff ff       	call   80103930 <mycpu>
80106fe4:	89 c3                	mov    %eax,%ebx
80106fe6:	e8 45 c9 ff ff       	call   80103930 <mycpu>
80106feb:	89 c7                	mov    %eax,%edi
80106fed:	e8 3e c9 ff ff       	call   80103930 <mycpu>
80106ff2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106ff5:	83 c7 08             	add    $0x8,%edi
80106ff8:	e8 33 c9 ff ff       	call   80103930 <mycpu>
80106ffd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107000:	83 c0 08             	add    $0x8,%eax
80107003:	ba 67 00 00 00       	mov    $0x67,%edx
80107008:	c1 e8 18             	shr    $0x18,%eax
8010700b:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80107012:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107019:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80107020:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80107027:	83 c1 08             	add    $0x8,%ecx
8010702a:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80107030:	c1 e9 10             	shr    $0x10,%ecx
80107033:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107039:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
8010703e:	e8 ed c8 ff ff       	call   80103930 <mycpu>
80107043:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010704a:	e8 e1 c8 ff ff       	call   80103930 <mycpu>
8010704f:	b9 10 00 00 00       	mov    $0x10,%ecx
80107054:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107058:	e8 d3 c8 ff ff       	call   80103930 <mycpu>
8010705d:	8b 56 08             	mov    0x8(%esi),%edx
80107060:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80107066:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107069:	e8 c2 c8 ff ff       	call   80103930 <mycpu>
8010706e:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80107072:	b8 28 00 00 00       	mov    $0x28,%eax
80107077:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010707a:	8b 46 04             	mov    0x4(%esi),%eax
8010707d:	05 00 00 00 80       	add    $0x80000000,%eax
80107082:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
80107085:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107088:	5b                   	pop    %ebx
80107089:	5e                   	pop    %esi
8010708a:	5f                   	pop    %edi
8010708b:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
8010708c:	e9 2f d7 ff ff       	jmp    801047c0 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
80107091:	83 ec 0c             	sub    $0xc,%esp
80107094:	68 ce 7f 10 80       	push   $0x80107fce
80107099:	e8 d2 92 ff ff       	call   80100370 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
8010709e:	83 ec 0c             	sub    $0xc,%esp
801070a1:	68 f9 7f 10 80       	push   $0x80107ff9
801070a6:	e8 c5 92 ff ff       	call   80100370 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
801070ab:	83 ec 0c             	sub    $0xc,%esp
801070ae:	68 e4 7f 10 80       	push   $0x80107fe4
801070b3:	e8 b8 92 ff ff       	call   80100370 <panic>
801070b8:	90                   	nop
801070b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801070c0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801070c0:	55                   	push   %ebp
801070c1:	89 e5                	mov    %esp,%ebp
801070c3:	57                   	push   %edi
801070c4:	56                   	push   %esi
801070c5:	53                   	push   %ebx
801070c6:	83 ec 1c             	sub    $0x1c,%esp
801070c9:	8b 75 10             	mov    0x10(%ebp),%esi
801070cc:	8b 45 08             	mov    0x8(%ebp),%eax
801070cf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
801070d2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801070d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
801070db:	77 49                	ja     80107126 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
801070dd:	e8 fe b5 ff ff       	call   801026e0 <kalloc>
  memset(mem, 0, PGSIZE);
801070e2:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
801070e5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801070e7:	68 00 10 00 00       	push   $0x1000
801070ec:	6a 00                	push   $0x0
801070ee:	50                   	push   %eax
801070ef:	e8 6c d8 ff ff       	call   80104960 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801070f4:	58                   	pop    %eax
801070f5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801070fb:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107100:	5a                   	pop    %edx
80107101:	6a 06                	push   $0x6
80107103:	50                   	push   %eax
80107104:	31 d2                	xor    %edx,%edx
80107106:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107109:	e8 52 fc ff ff       	call   80106d60 <mappages>
  memmove(mem, init, sz);
8010710e:	89 75 10             	mov    %esi,0x10(%ebp)
80107111:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107114:	83 c4 10             	add    $0x10,%esp
80107117:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010711a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010711d:	5b                   	pop    %ebx
8010711e:	5e                   	pop    %esi
8010711f:	5f                   	pop    %edi
80107120:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80107121:	e9 ea d8 ff ff       	jmp    80104a10 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80107126:	83 ec 0c             	sub    $0xc,%esp
80107129:	68 0d 80 10 80       	push   $0x8010800d
8010712e:	e8 3d 92 ff ff       	call   80100370 <panic>
80107133:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107140 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107140:	55                   	push   %ebp
80107141:	89 e5                	mov    %esp,%ebp
80107143:	57                   	push   %edi
80107144:	56                   	push   %esi
80107145:	53                   	push   %ebx
80107146:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107149:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107150:	0f 85 91 00 00 00    	jne    801071e7 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107156:	8b 75 18             	mov    0x18(%ebp),%esi
80107159:	31 db                	xor    %ebx,%ebx
8010715b:	85 f6                	test   %esi,%esi
8010715d:	75 1a                	jne    80107179 <loaduvm+0x39>
8010715f:	eb 6f                	jmp    801071d0 <loaduvm+0x90>
80107161:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107168:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010716e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107174:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107177:	76 57                	jbe    801071d0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107179:	8b 55 0c             	mov    0xc(%ebp),%edx
8010717c:	8b 45 08             	mov    0x8(%ebp),%eax
8010717f:	31 c9                	xor    %ecx,%ecx
80107181:	01 da                	add    %ebx,%edx
80107183:	e8 58 fb ff ff       	call   80106ce0 <walkpgdir>
80107188:	85 c0                	test   %eax,%eax
8010718a:	74 4e                	je     801071da <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
8010718c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010718e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
80107191:	bf 00 10 00 00       	mov    $0x1000,%edi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80107196:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010719b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801071a1:	0f 46 fe             	cmovbe %esi,%edi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
801071a4:	01 d9                	add    %ebx,%ecx
801071a6:	05 00 00 00 80       	add    $0x80000000,%eax
801071ab:	57                   	push   %edi
801071ac:	51                   	push   %ecx
801071ad:	50                   	push   %eax
801071ae:	ff 75 10             	pushl  0x10(%ebp)
801071b1:	e8 ea a9 ff ff       	call   80101ba0 <readi>
801071b6:	83 c4 10             	add    $0x10,%esp
801071b9:	39 c7                	cmp    %eax,%edi
801071bb:	74 ab                	je     80107168 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
801071bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
801071c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
801071c5:	5b                   	pop    %ebx
801071c6:	5e                   	pop    %esi
801071c7:	5f                   	pop    %edi
801071c8:	5d                   	pop    %ebp
801071c9:	c3                   	ret    
801071ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801071d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
801071d3:	31 c0                	xor    %eax,%eax
}
801071d5:	5b                   	pop    %ebx
801071d6:	5e                   	pop    %esi
801071d7:	5f                   	pop    %edi
801071d8:	5d                   	pop    %ebp
801071d9:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
801071da:	83 ec 0c             	sub    $0xc,%esp
801071dd:	68 27 80 10 80       	push   $0x80108027
801071e2:	e8 89 91 ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
801071e7:	83 ec 0c             	sub    $0xc,%esp
801071ea:	68 c8 80 10 80       	push   $0x801080c8
801071ef:	e8 7c 91 ff ff       	call   80100370 <panic>
801071f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801071fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107200 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107200:	55                   	push   %ebp
80107201:	89 e5                	mov    %esp,%ebp
80107203:	57                   	push   %edi
80107204:	56                   	push   %esi
80107205:	53                   	push   %ebx
80107206:	83 ec 0c             	sub    $0xc,%esp
80107209:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010720c:	85 ff                	test   %edi,%edi
8010720e:	0f 88 ca 00 00 00    	js     801072de <allocuvm+0xde>
    return 0;
  if(newsz < oldsz)
80107214:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80107217:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
8010721a:	0f 82 82 00 00 00    	jb     801072a2 <allocuvm+0xa2>
    return oldsz;

  a = PGROUNDUP(oldsz);
80107220:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107226:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010722c:	39 df                	cmp    %ebx,%edi
8010722e:	77 43                	ja     80107273 <allocuvm+0x73>
80107230:	e9 bb 00 00 00       	jmp    801072f0 <allocuvm+0xf0>
80107235:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80107238:	83 ec 04             	sub    $0x4,%esp
8010723b:	68 00 10 00 00       	push   $0x1000
80107240:	6a 00                	push   $0x0
80107242:	50                   	push   %eax
80107243:	e8 18 d7 ff ff       	call   80104960 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107248:	58                   	pop    %eax
80107249:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010724f:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107254:	5a                   	pop    %edx
80107255:	6a 06                	push   $0x6
80107257:	50                   	push   %eax
80107258:	89 da                	mov    %ebx,%edx
8010725a:	8b 45 08             	mov    0x8(%ebp),%eax
8010725d:	e8 fe fa ff ff       	call   80106d60 <mappages>
80107262:	83 c4 10             	add    $0x10,%esp
80107265:	85 c0                	test   %eax,%eax
80107267:	78 47                	js     801072b0 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107269:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010726f:	39 df                	cmp    %ebx,%edi
80107271:	76 7d                	jbe    801072f0 <allocuvm+0xf0>
    mem = kalloc();
80107273:	e8 68 b4 ff ff       	call   801026e0 <kalloc>
    if(mem == 0){
80107278:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
8010727a:	89 c6                	mov    %eax,%esi
    if(mem == 0){
8010727c:	75 ba                	jne    80107238 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
8010727e:	83 ec 0c             	sub    $0xc,%esp
80107281:	68 45 80 10 80       	push   $0x80108045
80107286:	e8 d5 93 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010728b:	83 c4 10             	add    $0x10,%esp
8010728e:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107291:	76 4b                	jbe    801072de <allocuvm+0xde>
80107293:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107296:	8b 45 08             	mov    0x8(%ebp),%eax
80107299:	89 fa                	mov    %edi,%edx
8010729b:	e8 50 fb ff ff       	call   80106df0 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
801072a0:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
801072a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072a5:	5b                   	pop    %ebx
801072a6:	5e                   	pop    %esi
801072a7:	5f                   	pop    %edi
801072a8:	5d                   	pop    %ebp
801072a9:	c3                   	ret    
801072aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
801072b0:	83 ec 0c             	sub    $0xc,%esp
801072b3:	68 5d 80 10 80       	push   $0x8010805d
801072b8:	e8 a3 93 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801072bd:	83 c4 10             	add    $0x10,%esp
801072c0:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801072c3:	76 0d                	jbe    801072d2 <allocuvm+0xd2>
801072c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801072c8:	8b 45 08             	mov    0x8(%ebp),%eax
801072cb:	89 fa                	mov    %edi,%edx
801072cd:	e8 1e fb ff ff       	call   80106df0 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
801072d2:	83 ec 0c             	sub    $0xc,%esp
801072d5:	56                   	push   %esi
801072d6:	e8 55 b2 ff ff       	call   80102530 <kfree>
      return 0;
801072db:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
801072de:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
801072e1:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
801072e3:	5b                   	pop    %ebx
801072e4:	5e                   	pop    %esi
801072e5:	5f                   	pop    %edi
801072e6:	5d                   	pop    %ebp
801072e7:	c3                   	ret    
801072e8:	90                   	nop
801072e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801072f3:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
801072f5:	5b                   	pop    %ebx
801072f6:	5e                   	pop    %esi
801072f7:	5f                   	pop    %edi
801072f8:	5d                   	pop    %ebp
801072f9:	c3                   	ret    
801072fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107300 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107300:	55                   	push   %ebp
80107301:	89 e5                	mov    %esp,%ebp
80107303:	8b 55 0c             	mov    0xc(%ebp),%edx
80107306:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107309:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010730c:	39 d1                	cmp    %edx,%ecx
8010730e:	73 10                	jae    80107320 <deallocuvm+0x20>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107310:	5d                   	pop    %ebp
80107311:	e9 da fa ff ff       	jmp    80106df0 <deallocuvm.part.0>
80107316:	8d 76 00             	lea    0x0(%esi),%esi
80107319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107320:	89 d0                	mov    %edx,%eax
80107322:	5d                   	pop    %ebp
80107323:	c3                   	ret    
80107324:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010732a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107330 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107330:	55                   	push   %ebp
80107331:	89 e5                	mov    %esp,%ebp
80107333:	57                   	push   %edi
80107334:	56                   	push   %esi
80107335:	53                   	push   %ebx
80107336:	83 ec 0c             	sub    $0xc,%esp
80107339:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010733c:	85 f6                	test   %esi,%esi
8010733e:	74 59                	je     80107399 <freevm+0x69>
80107340:	31 c9                	xor    %ecx,%ecx
80107342:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107347:	89 f0                	mov    %esi,%eax
80107349:	e8 a2 fa ff ff       	call   80106df0 <deallocuvm.part.0>
8010734e:	89 f3                	mov    %esi,%ebx
80107350:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107356:	eb 0f                	jmp    80107367 <freevm+0x37>
80107358:	90                   	nop
80107359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107360:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107363:	39 fb                	cmp    %edi,%ebx
80107365:	74 23                	je     8010738a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107367:	8b 03                	mov    (%ebx),%eax
80107369:	a8 01                	test   $0x1,%al
8010736b:	74 f3                	je     80107360 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
8010736d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107372:	83 ec 0c             	sub    $0xc,%esp
80107375:	83 c3 04             	add    $0x4,%ebx
80107378:	05 00 00 00 80       	add    $0x80000000,%eax
8010737d:	50                   	push   %eax
8010737e:	e8 ad b1 ff ff       	call   80102530 <kfree>
80107383:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107386:	39 fb                	cmp    %edi,%ebx
80107388:	75 dd                	jne    80107367 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
8010738a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010738d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107390:	5b                   	pop    %ebx
80107391:	5e                   	pop    %esi
80107392:	5f                   	pop    %edi
80107393:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80107394:	e9 97 b1 ff ff       	jmp    80102530 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80107399:	83 ec 0c             	sub    $0xc,%esp
8010739c:	68 79 80 10 80       	push   $0x80108079
801073a1:	e8 ca 8f ff ff       	call   80100370 <panic>
801073a6:	8d 76 00             	lea    0x0(%esi),%esi
801073a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801073b0 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801073b0:	55                   	push   %ebp
801073b1:	89 e5                	mov    %esp,%ebp
801073b3:	56                   	push   %esi
801073b4:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801073b5:	e8 26 b3 ff ff       	call   801026e0 <kalloc>
801073ba:	85 c0                	test   %eax,%eax
801073bc:	74 6a                	je     80107428 <setupkvm+0x78>
    return 0;
  memset(pgdir, 0, PGSIZE);
801073be:	83 ec 04             	sub    $0x4,%esp
801073c1:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801073c3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
801073c8:	68 00 10 00 00       	push   $0x1000
801073cd:	6a 00                	push   $0x0
801073cf:	50                   	push   %eax
801073d0:	e8 8b d5 ff ff       	call   80104960 <memset>
801073d5:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801073d8:	8b 43 04             	mov    0x4(%ebx),%eax
801073db:	8b 4b 08             	mov    0x8(%ebx),%ecx
801073de:	83 ec 08             	sub    $0x8,%esp
801073e1:	8b 13                	mov    (%ebx),%edx
801073e3:	ff 73 0c             	pushl  0xc(%ebx)
801073e6:	50                   	push   %eax
801073e7:	29 c1                	sub    %eax,%ecx
801073e9:	89 f0                	mov    %esi,%eax
801073eb:	e8 70 f9 ff ff       	call   80106d60 <mappages>
801073f0:	83 c4 10             	add    $0x10,%esp
801073f3:	85 c0                	test   %eax,%eax
801073f5:	78 19                	js     80107410 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801073f7:	83 c3 10             	add    $0x10,%ebx
801073fa:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107400:	75 d6                	jne    801073d8 <setupkvm+0x28>
80107402:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80107404:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107407:	5b                   	pop    %ebx
80107408:	5e                   	pop    %esi
80107409:	5d                   	pop    %ebp
8010740a:	c3                   	ret    
8010740b:	90                   	nop
8010740c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80107410:	83 ec 0c             	sub    $0xc,%esp
80107413:	56                   	push   %esi
80107414:	e8 17 ff ff ff       	call   80107330 <freevm>
      return 0;
80107419:	83 c4 10             	add    $0x10,%esp
    }
  return pgdir;
}
8010741c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
8010741f:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
80107421:	5b                   	pop    %ebx
80107422:	5e                   	pop    %esi
80107423:	5d                   	pop    %ebp
80107424:	c3                   	ret    
80107425:	8d 76 00             	lea    0x0(%esi),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80107428:	31 c0                	xor    %eax,%eax
8010742a:	eb d8                	jmp    80107404 <setupkvm+0x54>
8010742c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107430 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107430:	55                   	push   %ebp
80107431:	89 e5                	mov    %esp,%ebp
80107433:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107436:	e8 75 ff ff ff       	call   801073b0 <setupkvm>
8010743b:	a3 44 66 11 80       	mov    %eax,0x80116644
80107440:	05 00 00 00 80       	add    $0x80000000,%eax
80107445:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
80107448:	c9                   	leave  
80107449:	c3                   	ret    
8010744a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107450 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107450:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107451:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107453:	89 e5                	mov    %esp,%ebp
80107455:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107458:	8b 55 0c             	mov    0xc(%ebp),%edx
8010745b:	8b 45 08             	mov    0x8(%ebp),%eax
8010745e:	e8 7d f8 ff ff       	call   80106ce0 <walkpgdir>
  if(pte == 0)
80107463:	85 c0                	test   %eax,%eax
80107465:	74 05                	je     8010746c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107467:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010746a:	c9                   	leave  
8010746b:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
8010746c:	83 ec 0c             	sub    $0xc,%esp
8010746f:	68 8a 80 10 80       	push   $0x8010808a
80107474:	e8 f7 8e ff ff       	call   80100370 <panic>
80107479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107480 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107480:	55                   	push   %ebp
80107481:	89 e5                	mov    %esp,%ebp
80107483:	57                   	push   %edi
80107484:	56                   	push   %esi
80107485:	53                   	push   %ebx
80107486:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107489:	e8 22 ff ff ff       	call   801073b0 <setupkvm>
8010748e:	85 c0                	test   %eax,%eax
80107490:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107493:	0f 84 c5 00 00 00    	je     8010755e <copyuvm+0xde>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107499:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010749c:	85 c9                	test   %ecx,%ecx
8010749e:	0f 84 9c 00 00 00    	je     80107540 <copyuvm+0xc0>
801074a4:	31 ff                	xor    %edi,%edi
801074a6:	eb 4a                	jmp    801074f2 <copyuvm+0x72>
801074a8:	90                   	nop
801074a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801074b0:	83 ec 04             	sub    $0x4,%esp
801074b3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
801074b9:	68 00 10 00 00       	push   $0x1000
801074be:	53                   	push   %ebx
801074bf:	50                   	push   %eax
801074c0:	e8 4b d5 ff ff       	call   80104a10 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801074c5:	58                   	pop    %eax
801074c6:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801074cc:	b9 00 10 00 00       	mov    $0x1000,%ecx
801074d1:	5a                   	pop    %edx
801074d2:	ff 75 e4             	pushl  -0x1c(%ebp)
801074d5:	50                   	push   %eax
801074d6:	89 fa                	mov    %edi,%edx
801074d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801074db:	e8 80 f8 ff ff       	call   80106d60 <mappages>
801074e0:	83 c4 10             	add    $0x10,%esp
801074e3:	85 c0                	test   %eax,%eax
801074e5:	78 69                	js     80107550 <copyuvm+0xd0>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801074e7:	81 c7 00 10 00 00    	add    $0x1000,%edi
801074ed:	39 7d 0c             	cmp    %edi,0xc(%ebp)
801074f0:	76 4e                	jbe    80107540 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801074f2:	8b 45 08             	mov    0x8(%ebp),%eax
801074f5:	31 c9                	xor    %ecx,%ecx
801074f7:	89 fa                	mov    %edi,%edx
801074f9:	e8 e2 f7 ff ff       	call   80106ce0 <walkpgdir>
801074fe:	85 c0                	test   %eax,%eax
80107500:	74 6d                	je     8010756f <copyuvm+0xef>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80107502:	8b 00                	mov    (%eax),%eax
80107504:	a8 01                	test   $0x1,%al
80107506:	74 5a                	je     80107562 <copyuvm+0xe2>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107508:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
8010750a:	25 ff 0f 00 00       	and    $0xfff,%eax
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
8010750f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107515:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107518:	e8 c3 b1 ff ff       	call   801026e0 <kalloc>
8010751d:	85 c0                	test   %eax,%eax
8010751f:	89 c6                	mov    %eax,%esi
80107521:	75 8d                	jne    801074b0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107523:	83 ec 0c             	sub    $0xc,%esp
80107526:	ff 75 e0             	pushl  -0x20(%ebp)
80107529:	e8 02 fe ff ff       	call   80107330 <freevm>
  return 0;
8010752e:	83 c4 10             	add    $0x10,%esp
80107531:	31 c0                	xor    %eax,%eax
}
80107533:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107536:	5b                   	pop    %ebx
80107537:	5e                   	pop    %esi
80107538:	5f                   	pop    %edi
80107539:	5d                   	pop    %ebp
8010753a:	c3                   	ret    
8010753b:	90                   	nop
8010753c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107540:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
80107543:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107546:	5b                   	pop    %ebx
80107547:	5e                   	pop    %esi
80107548:	5f                   	pop    %edi
80107549:	5d                   	pop    %ebp
8010754a:	c3                   	ret    
8010754b:	90                   	nop
8010754c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
      kfree(mem);
80107550:	83 ec 0c             	sub    $0xc,%esp
80107553:	56                   	push   %esi
80107554:	e8 d7 af ff ff       	call   80102530 <kfree>
      goto bad;
80107559:	83 c4 10             	add    $0x10,%esp
8010755c:	eb c5                	jmp    80107523 <copyuvm+0xa3>
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
8010755e:	31 c0                	xor    %eax,%eax
80107560:	eb d1                	jmp    80107533 <copyuvm+0xb3>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
80107562:	83 ec 0c             	sub    $0xc,%esp
80107565:	68 ae 80 10 80       	push   $0x801080ae
8010756a:	e8 01 8e ff ff       	call   80100370 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010756f:	83 ec 0c             	sub    $0xc,%esp
80107572:	68 94 80 10 80       	push   $0x80108094
80107577:	e8 f4 8d ff ff       	call   80100370 <panic>
8010757c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107580 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107580:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107581:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107583:	89 e5                	mov    %esp,%ebp
80107585:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107588:	8b 55 0c             	mov    0xc(%ebp),%edx
8010758b:	8b 45 08             	mov    0x8(%ebp),%eax
8010758e:	e8 4d f7 ff ff       	call   80106ce0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107593:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80107595:	89 c2                	mov    %eax,%edx
80107597:	83 e2 05             	and    $0x5,%edx
8010759a:	83 fa 05             	cmp    $0x5,%edx
8010759d:	75 11                	jne    801075b0 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
8010759f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
801075a4:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
801075a5:	05 00 00 00 80       	add    $0x80000000,%eax
}
801075aa:	c3                   	ret    
801075ab:	90                   	nop
801075ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
801075b0:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
801075b2:	c9                   	leave  
801075b3:	c3                   	ret    
801075b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801075ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801075c0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801075c0:	55                   	push   %ebp
801075c1:	89 e5                	mov    %esp,%ebp
801075c3:	57                   	push   %edi
801075c4:	56                   	push   %esi
801075c5:	53                   	push   %ebx
801075c6:	83 ec 1c             	sub    $0x1c,%esp
801075c9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801075cc:	8b 55 0c             	mov    0xc(%ebp),%edx
801075cf:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801075d2:	85 db                	test   %ebx,%ebx
801075d4:	75 40                	jne    80107616 <copyout+0x56>
801075d6:	eb 70                	jmp    80107648 <copyout+0x88>
801075d8:	90                   	nop
801075d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801075e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801075e3:	89 f1                	mov    %esi,%ecx
801075e5:	29 d1                	sub    %edx,%ecx
801075e7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801075ed:	39 d9                	cmp    %ebx,%ecx
801075ef:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801075f2:	29 f2                	sub    %esi,%edx
801075f4:	83 ec 04             	sub    $0x4,%esp
801075f7:	01 d0                	add    %edx,%eax
801075f9:	51                   	push   %ecx
801075fa:	57                   	push   %edi
801075fb:	50                   	push   %eax
801075fc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801075ff:	e8 0c d4 ff ff       	call   80104a10 <memmove>
    len -= n;
    buf += n;
80107604:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107607:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
8010760a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80107610:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107612:	29 cb                	sub    %ecx,%ebx
80107614:	74 32                	je     80107648 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107616:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107618:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
8010761b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010761e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107624:	56                   	push   %esi
80107625:	ff 75 08             	pushl  0x8(%ebp)
80107628:	e8 53 ff ff ff       	call   80107580 <uva2ka>
    if(pa0 == 0)
8010762d:	83 c4 10             	add    $0x10,%esp
80107630:	85 c0                	test   %eax,%eax
80107632:	75 ac                	jne    801075e0 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80107634:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80107637:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
8010763c:	5b                   	pop    %ebx
8010763d:	5e                   	pop    %esi
8010763e:	5f                   	pop    %edi
8010763f:	5d                   	pop    %ebp
80107640:	c3                   	ret    
80107641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107648:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
8010764b:	31 c0                	xor    %eax,%eax
}
8010764d:	5b                   	pop    %ebx
8010764e:	5e                   	pop    %esi
8010764f:	5f                   	pop    %edi
80107650:	5d                   	pop    %ebp
80107651:	c3                   	ret    
