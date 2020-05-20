
_getp:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "x86.h"
#define child_NUM 4

int
main(int argc, char *argv[])
{  
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 48             	sub    $0x48,%esp
  14:	8b 59 04             	mov    0x4(%ecx),%ebx

   int childrenn[child_NUM];
   int havechild = 0;
   int children[child_NUM][child_NUM];
   int i,j;
   int mainparent = getpid();
  17:	e8 96 04 00 00       	call   4b2 <getpid>
   int isfirstchild = 0;
   if(strcmp(argv[1],"1") == 0)
  1c:	83 ec 08             	sub    $0x8,%esp

   int childrenn[child_NUM];
   int havechild = 0;
   int children[child_NUM][child_NUM];
   int i,j;
   int mainparent = getpid();
  1f:	89 c6                	mov    %eax,%esi
   int isfirstchild = 0;
   if(strcmp(argv[1],"1") == 0)
  21:	68 d0 08 00 00       	push   $0x8d0
  26:	ff 73 04             	pushl  0x4(%ebx)
  29:	e8 f2 01 00 00       	call   220 <strcmp>
  2e:	83 c4 10             	add    $0x10,%esp
  31:	85 c0                	test   %eax,%eax
  33:	75 4c                	jne    81 <main+0x81>
  35:	8d 5d a8             	lea    -0x58(%ebp),%ebx
  38:	8d 7d b4             	lea    -0x4c(%ebp),%edi
   {
   childrenn[0] = fork();
  3b:	e8 ea 03 00 00       	call   42a <fork>
  40:	89 45 a8             	mov    %eax,-0x58(%ebp)
   for(i = 1; i < child_NUM;i++){
      if(childrenn[i-1] == 0){
  43:	8b 0b                	mov    (%ebx),%ecx
  45:	85 c9                	test   %ecx,%ecx
  47:	0f 84 72 01 00 00    	je     1bf <main+0x1bf>
         havechild = 0;
         exit();
      }
      else{
         havechild = 1;
         childrenn[i]=fork();
  4d:	e8 d8 03 00 00       	call   42a <fork>
  52:	83 c3 04             	add    $0x4,%ebx
  55:	89 03                	mov    %eax,(%ebx)
   int mainparent = getpid();
   int isfirstchild = 0;
   if(strcmp(argv[1],"1") == 0)
   {
   childrenn[0] = fork();
   for(i = 1; i < child_NUM;i++){
  57:	39 fb                	cmp    %edi,%ebx
  59:	75 e8                	jne    43 <main+0x43>
   }


   if(havechild == 1)
   {
     if(getpid() == mainparent){ 
  5b:	e8 52 04 00 00       	call   4b2 <getpid>
  60:	39 c6                	cmp    %eax,%esi
  62:	0f 84 18 01 00 00    	je     180 <main+0x180>
        printf(1,"getchildren syscall : %d\n",getchildren(mainparent));

     }
   }
   for(i = 0; i < child_NUM; i++)
      wait();
  68:	e8 cd 03 00 00       	call   43a <wait>
  6d:	e8 c8 03 00 00       	call   43a <wait>
  72:	e8 c3 03 00 00       	call   43a <wait>
  77:	e8 be 03 00 00       	call   43a <wait>

   exit();
  7c:	e8 b1 03 00 00       	call   432 <exit>


   }

//////////////////////////////////////////bonus////////////////////////////////////////////
   if(strcmp(argv[1],"2") == 0)
  81:	57                   	push   %edi
  82:	57                   	push   %edi
  83:	68 22 09 00 00       	push   $0x922
  88:	ff 73 04             	pushl  0x4(%ebx)
  8b:	e8 90 01 00 00       	call   220 <strcmp>
  90:	83 c4 10             	add    $0x10,%esp
  93:	85 c0                	test   %eax,%eax
  95:	75 50                	jne    e7 <main+0xe7>
  97:	8d 45 a8             	lea    -0x58(%ebp),%eax
  9a:	8d 55 e8             	lea    -0x18(%ebp),%edx
   {

   for(i = 0;i < child_NUM;i++)
       for(j=0;j < child_NUM;j++)
           children[i][j] = -1;
  9d:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
  a3:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
  aa:	83 c0 10             	add    $0x10,%eax
  ad:	c7 40 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%eax)

//////////////////////////////////////////bonus////////////////////////////////////////////
   if(strcmp(argv[1],"2") == 0)
   {

   for(i = 0;i < child_NUM;i++)
  b4:	39 c2                	cmp    %eax,%edx
  b6:	75 e5                	jne    9d <main+0x9d>
       for(j=0;j < child_NUM;j++)
           children[i][j] = -1;

   printf(1,"mainparent pid : %d\n",mainparent);
  b8:	51                   	push   %ecx
  b9:	56                   	push   %esi
  ba:	68 24 09 00 00       	push   $0x924
  bf:	6a 01                	push   $0x1
  c1:	e8 ea 04 00 00       	call   5b0 <printf>
   children[0][0] = fork();
  c6:	e8 5f 03 00 00       	call   42a <fork>


   if (children[0][0] == 0){
  cb:	83 c4 10             	add    $0x10,%esp
  ce:	85 c0                	test   %eax,%eax
  d0:	74 23                	je     f5 <main+0xf5>


  


   if ((children[0][1] == 0) || (children[0][2] == 0)){
  d2:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  d6:	74 0a                	je     e2 <main+0xe2>
  d8:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  dc:	0f 85 8f 00 00 00    	jne    171 <main+0x171>


   for(i = 0; i < 2; i++)
        wait();

   exit();
  e2:	e8 4b 03 00 00       	call   432 <exit>
   }
}
  e7:	8d 65 f0             	lea    -0x10(%ebp),%esp
  ea:	31 c0                	xor    %eax,%eax
  ec:	59                   	pop    %ecx
  ed:	5b                   	pop    %ebx
  ee:	5e                   	pop    %esi
  ef:	5f                   	pop    %edi
  f0:	5d                   	pop    %ebp
  f1:	8d 61 fc             	lea    -0x4(%ecx),%esp
  f4:	c3                   	ret    
   children[0][0] = fork();


   if (children[0][0] == 0){
        isfirstchild = 1;
   	children[0][1] = fork();
  f5:	e8 30 03 00 00       	call   42a <fork>
        if (children[0][1] != 0)
  fa:	85 c0                	test   %eax,%eax
   children[0][0] = fork();


   if (children[0][0] == 0){
        isfirstchild = 1;
   	children[0][1] = fork();
  fc:	89 c3                	mov    %eax,%ebx
        if (children[0][1] != 0)
  fe:	74 e2                	je     e2 <main+0xe2>
            children[0][2] = fork();
 100:	e8 25 03 00 00       	call   42a <fork>


  


   if ((children[0][1] == 0) || (children[0][2] == 0)){
 105:	85 c0                	test   %eax,%eax

   if (children[0][0] == 0){
        isfirstchild = 1;
   	children[0][1] = fork();
        if (children[0][1] != 0)
            children[0][2] = fork();
 107:	89 c7                	mov    %eax,%edi
 109:	89 45 b0             	mov    %eax,-0x50(%ebp)


  


   if ((children[0][1] == 0) || (children[0][2] == 0)){
 10c:	74 d4                	je     e2 <main+0xe2>
        exit();
   }


   if(isfirstchild){
        printf(1,"Father pid : %d\n",get_parent_id());
 10e:	e8 a7 03 00 00       	call   4ba <get_parent_id>
 113:	52                   	push   %edx
 114:	50                   	push   %eax
 115:	68 d2 08 00 00       	push   $0x8d2
 11a:	6a 01                	push   $0x1
 11c:	e8 8f 04 00 00       	call   5b0 <printf>
        printf(1,"First degree child : %d\n",getpid());
 121:	e8 8c 03 00 00       	call   4b2 <getpid>
 126:	83 c4 0c             	add    $0xc,%esp
 129:	50                   	push   %eax
 12a:	68 39 09 00 00       	push   $0x939
 12f:	6a 01                	push   $0x1
 131:	e8 7a 04 00 00       	call   5b0 <printf>
	printf(1,"Second degree child 1 : %d\n",children[0][1]);
 136:	83 c4 0c             	add    $0xc,%esp
 139:	53                   	push   %ebx
 13a:	68 52 09 00 00       	push   $0x952
 13f:	6a 01                	push   $0x1
 141:	e8 6a 04 00 00       	call   5b0 <printf>
	printf(1,"Second degree child 2 : %d\n",children[0][2]);
 146:	83 c4 0c             	add    $0xc,%esp
 149:	57                   	push   %edi
 14a:	68 6e 09 00 00       	push   $0x96e
 14f:	6a 01                	push   $0x1
 151:	e8 5a 04 00 00       	call   5b0 <printf>
        printf(1,"getchildren syscall : %d\n",getchildren(mainparent));
 156:	89 34 24             	mov    %esi,(%esp)
 159:	e8 64 03 00 00       	call   4c2 <getchildren>
 15e:	83 c4 0c             	add    $0xc,%esp
 161:	50                   	push   %eax
 162:	68 08 09 00 00       	push   $0x908
 167:	6a 01                	push   $0x1
 169:	e8 42 04 00 00       	call   5b0 <printf>
 16e:	83 c4 10             	add    $0x10,%esp
   }



   for(i = 0; i < 2; i++)
        wait();
 171:	e8 c4 02 00 00       	call   43a <wait>
 176:	e8 bf 02 00 00       	call   43a <wait>
 17b:	e9 62 ff ff ff       	jmp    e2 <main+0xe2>
 180:	31 db                	xor    %ebx,%ebx

   if(havechild == 1)
   {
     if(getpid() == mainparent){ 
        for(i = 0; i < child_NUM;i++){
            printf(1,"children array : %d\n",childrenn[i]);
 182:	50                   	push   %eax
 183:	ff 74 9d a8          	pushl  -0x58(%ebp,%ebx,4)


   if(havechild == 1)
   {
     if(getpid() == mainparent){ 
        for(i = 0; i < child_NUM;i++){
 187:	83 c3 01             	add    $0x1,%ebx
            printf(1,"children array : %d\n",childrenn[i]);
 18a:	68 f3 08 00 00       	push   $0x8f3
 18f:	6a 01                	push   $0x1
 191:	e8 1a 04 00 00       	call   5b0 <printf>


   if(havechild == 1)
   {
     if(getpid() == mainparent){ 
        for(i = 0; i < child_NUM;i++){
 196:	83 c4 10             	add    $0x10,%esp
 199:	83 fb 04             	cmp    $0x4,%ebx
 19c:	75 e4                	jne    182 <main+0x182>
            printf(1,"children array : %d\n",childrenn[i]);
        }
        printf(1,"getchildren syscall : %d\n",getchildren(mainparent));
 19e:	83 ec 0c             	sub    $0xc,%esp
 1a1:	56                   	push   %esi
 1a2:	e8 1b 03 00 00       	call   4c2 <getchildren>
 1a7:	83 c4 0c             	add    $0xc,%esp
 1aa:	50                   	push   %eax
 1ab:	68 08 09 00 00       	push   $0x908
 1b0:	6a 01                	push   $0x1
 1b2:	e8 f9 03 00 00       	call   5b0 <printf>
 1b7:	83 c4 10             	add    $0x10,%esp
 1ba:	e9 a9 fe ff ff       	jmp    68 <main+0x68>
   if(strcmp(argv[1],"1") == 0)
   {
   childrenn[0] = fork();
   for(i = 1; i < child_NUM;i++){
      if(childrenn[i-1] == 0){
         printf(1,"Father pid : %d\n",get_parent_id());
 1bf:	e8 f6 02 00 00       	call   4ba <get_parent_id>
 1c4:	52                   	push   %edx
 1c5:	50                   	push   %eax
 1c6:	68 d2 08 00 00       	push   $0x8d2
 1cb:	6a 01                	push   $0x1
 1cd:	e8 de 03 00 00       	call   5b0 <printf>
         printf(1,"Child pid : %d\n",getpid());
 1d2:	e8 db 02 00 00       	call   4b2 <getpid>
 1d7:	83 c4 0c             	add    $0xc,%esp
 1da:	50                   	push   %eax
 1db:	68 e3 08 00 00       	push   $0x8e3
 1e0:	6a 01                	push   $0x1
 1e2:	e8 c9 03 00 00       	call   5b0 <printf>
         havechild = 0;
         exit();
 1e7:	e8 46 02 00 00       	call   432 <exit>
 1ec:	66 90                	xchg   %ax,%ax
 1ee:	66 90                	xchg   %ax,%ax

000001f0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	53                   	push   %ebx
 1f4:	8b 45 08             	mov    0x8(%ebp),%eax
 1f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1fa:	89 c2                	mov    %eax,%edx
 1fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 200:	83 c1 01             	add    $0x1,%ecx
 203:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 207:	83 c2 01             	add    $0x1,%edx
 20a:	84 db                	test   %bl,%bl
 20c:	88 5a ff             	mov    %bl,-0x1(%edx)
 20f:	75 ef                	jne    200 <strcpy+0x10>
    ;
  return os;
}
 211:	5b                   	pop    %ebx
 212:	5d                   	pop    %ebp
 213:	c3                   	ret    
 214:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 21a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000220 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	56                   	push   %esi
 224:	53                   	push   %ebx
 225:	8b 55 08             	mov    0x8(%ebp),%edx
 228:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 22b:	0f b6 02             	movzbl (%edx),%eax
 22e:	0f b6 19             	movzbl (%ecx),%ebx
 231:	84 c0                	test   %al,%al
 233:	75 1e                	jne    253 <strcmp+0x33>
 235:	eb 29                	jmp    260 <strcmp+0x40>
 237:	89 f6                	mov    %esi,%esi
 239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 240:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 243:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 246:	8d 71 01             	lea    0x1(%ecx),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 249:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 24d:	84 c0                	test   %al,%al
 24f:	74 0f                	je     260 <strcmp+0x40>
 251:	89 f1                	mov    %esi,%ecx
 253:	38 d8                	cmp    %bl,%al
 255:	74 e9                	je     240 <strcmp+0x20>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 257:	29 d8                	sub    %ebx,%eax
}
 259:	5b                   	pop    %ebx
 25a:	5e                   	pop    %esi
 25b:	5d                   	pop    %ebp
 25c:	c3                   	ret    
 25d:	8d 76 00             	lea    0x0(%esi),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 260:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
 262:	29 d8                	sub    %ebx,%eax
}
 264:	5b                   	pop    %ebx
 265:	5e                   	pop    %esi
 266:	5d                   	pop    %ebp
 267:	c3                   	ret    
 268:	90                   	nop
 269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000270 <strlen>:

uint
strlen(const char *s)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 276:	80 39 00             	cmpb   $0x0,(%ecx)
 279:	74 12                	je     28d <strlen+0x1d>
 27b:	31 d2                	xor    %edx,%edx
 27d:	8d 76 00             	lea    0x0(%esi),%esi
 280:	83 c2 01             	add    $0x1,%edx
 283:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 287:	89 d0                	mov    %edx,%eax
 289:	75 f5                	jne    280 <strlen+0x10>
    ;
  return n;
}
 28b:	5d                   	pop    %ebp
 28c:	c3                   	ret    
uint
strlen(const char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 28d:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 28f:	5d                   	pop    %ebp
 290:	c3                   	ret    
 291:	eb 0d                	jmp    2a0 <memset>
 293:	90                   	nop
 294:	90                   	nop
 295:	90                   	nop
 296:	90                   	nop
 297:	90                   	nop
 298:	90                   	nop
 299:	90                   	nop
 29a:	90                   	nop
 29b:	90                   	nop
 29c:	90                   	nop
 29d:	90                   	nop
 29e:	90                   	nop
 29f:	90                   	nop

000002a0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	57                   	push   %edi
 2a4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 2a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 2aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ad:	89 d7                	mov    %edx,%edi
 2af:	fc                   	cld    
 2b0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 2b2:	89 d0                	mov    %edx,%eax
 2b4:	5f                   	pop    %edi
 2b5:	5d                   	pop    %ebp
 2b6:	c3                   	ret    
 2b7:	89 f6                	mov    %esi,%esi
 2b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002c0 <strchr>:

char*
strchr(const char *s, char c)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	53                   	push   %ebx
 2c4:	8b 45 08             	mov    0x8(%ebp),%eax
 2c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 2ca:	0f b6 10             	movzbl (%eax),%edx
 2cd:	84 d2                	test   %dl,%dl
 2cf:	74 1d                	je     2ee <strchr+0x2e>
    if(*s == c)
 2d1:	38 d3                	cmp    %dl,%bl
 2d3:	89 d9                	mov    %ebx,%ecx
 2d5:	75 0d                	jne    2e4 <strchr+0x24>
 2d7:	eb 17                	jmp    2f0 <strchr+0x30>
 2d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2e0:	38 ca                	cmp    %cl,%dl
 2e2:	74 0c                	je     2f0 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2e4:	83 c0 01             	add    $0x1,%eax
 2e7:	0f b6 10             	movzbl (%eax),%edx
 2ea:	84 d2                	test   %dl,%dl
 2ec:	75 f2                	jne    2e0 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 2ee:	31 c0                	xor    %eax,%eax
}
 2f0:	5b                   	pop    %ebx
 2f1:	5d                   	pop    %ebp
 2f2:	c3                   	ret    
 2f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000300 <gets>:

char*
gets(char *buf, int max)
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	57                   	push   %edi
 304:	56                   	push   %esi
 305:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 306:	31 f6                	xor    %esi,%esi
    cc = read(0, &c, 1);
 308:	8d 7d e7             	lea    -0x19(%ebp),%edi
  return 0;
}

char*
gets(char *buf, int max)
{
 30b:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 30e:	eb 29                	jmp    339 <gets+0x39>
    cc = read(0, &c, 1);
 310:	83 ec 04             	sub    $0x4,%esp
 313:	6a 01                	push   $0x1
 315:	57                   	push   %edi
 316:	6a 00                	push   $0x0
 318:	e8 2d 01 00 00       	call   44a <read>
    if(cc < 1)
 31d:	83 c4 10             	add    $0x10,%esp
 320:	85 c0                	test   %eax,%eax
 322:	7e 1d                	jle    341 <gets+0x41>
      break;
    buf[i++] = c;
 324:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 328:	8b 55 08             	mov    0x8(%ebp),%edx
 32b:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 32d:	3c 0a                	cmp    $0xa,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 32f:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 333:	74 1b                	je     350 <gets+0x50>
 335:	3c 0d                	cmp    $0xd,%al
 337:	74 17                	je     350 <gets+0x50>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 339:	8d 5e 01             	lea    0x1(%esi),%ebx
 33c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 33f:	7c cf                	jl     310 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 341:	8b 45 08             	mov    0x8(%ebp),%eax
 344:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 348:	8d 65 f4             	lea    -0xc(%ebp),%esp
 34b:	5b                   	pop    %ebx
 34c:	5e                   	pop    %esi
 34d:	5f                   	pop    %edi
 34e:	5d                   	pop    %ebp
 34f:	c3                   	ret    
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 350:	8b 45 08             	mov    0x8(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 353:	89 de                	mov    %ebx,%esi
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 355:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 359:	8d 65 f4             	lea    -0xc(%ebp),%esp
 35c:	5b                   	pop    %ebx
 35d:	5e                   	pop    %esi
 35e:	5f                   	pop    %edi
 35f:	5d                   	pop    %ebp
 360:	c3                   	ret    
 361:	eb 0d                	jmp    370 <stat>
 363:	90                   	nop
 364:	90                   	nop
 365:	90                   	nop
 366:	90                   	nop
 367:	90                   	nop
 368:	90                   	nop
 369:	90                   	nop
 36a:	90                   	nop
 36b:	90                   	nop
 36c:	90                   	nop
 36d:	90                   	nop
 36e:	90                   	nop
 36f:	90                   	nop

00000370 <stat>:

int
stat(const char *n, struct stat *st)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	56                   	push   %esi
 374:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 375:	83 ec 08             	sub    $0x8,%esp
 378:	6a 00                	push   $0x0
 37a:	ff 75 08             	pushl  0x8(%ebp)
 37d:	e8 f0 00 00 00       	call   472 <open>
  if(fd < 0)
 382:	83 c4 10             	add    $0x10,%esp
 385:	85 c0                	test   %eax,%eax
 387:	78 27                	js     3b0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 389:	83 ec 08             	sub    $0x8,%esp
 38c:	ff 75 0c             	pushl  0xc(%ebp)
 38f:	89 c3                	mov    %eax,%ebx
 391:	50                   	push   %eax
 392:	e8 f3 00 00 00       	call   48a <fstat>
 397:	89 c6                	mov    %eax,%esi
  close(fd);
 399:	89 1c 24             	mov    %ebx,(%esp)
 39c:	e8 b9 00 00 00       	call   45a <close>
  return r;
 3a1:	83 c4 10             	add    $0x10,%esp
 3a4:	89 f0                	mov    %esi,%eax
}
 3a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3a9:	5b                   	pop    %ebx
 3aa:	5e                   	pop    %esi
 3ab:	5d                   	pop    %ebp
 3ac:	c3                   	ret    
 3ad:	8d 76 00             	lea    0x0(%esi),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 3b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3b5:	eb ef                	jmp    3a6 <stat+0x36>
 3b7:	89 f6                	mov    %esi,%esi
 3b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003c0 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	53                   	push   %ebx
 3c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3c7:	0f be 11             	movsbl (%ecx),%edx
 3ca:	8d 42 d0             	lea    -0x30(%edx),%eax
 3cd:	3c 09                	cmp    $0x9,%al
 3cf:	b8 00 00 00 00       	mov    $0x0,%eax
 3d4:	77 1f                	ja     3f5 <atoi+0x35>
 3d6:	8d 76 00             	lea    0x0(%esi),%esi
 3d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 3e0:	8d 04 80             	lea    (%eax,%eax,4),%eax
 3e3:	83 c1 01             	add    $0x1,%ecx
 3e6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3ea:	0f be 11             	movsbl (%ecx),%edx
 3ed:	8d 5a d0             	lea    -0x30(%edx),%ebx
 3f0:	80 fb 09             	cmp    $0x9,%bl
 3f3:	76 eb                	jbe    3e0 <atoi+0x20>
    n = n*10 + *s++ - '0';
  return n;
}
 3f5:	5b                   	pop    %ebx
 3f6:	5d                   	pop    %ebp
 3f7:	c3                   	ret    
 3f8:	90                   	nop
 3f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000400 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	56                   	push   %esi
 404:	53                   	push   %ebx
 405:	8b 5d 10             	mov    0x10(%ebp),%ebx
 408:	8b 45 08             	mov    0x8(%ebp),%eax
 40b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 40e:	85 db                	test   %ebx,%ebx
 410:	7e 14                	jle    426 <memmove+0x26>
 412:	31 d2                	xor    %edx,%edx
 414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 418:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 41c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 41f:	83 c2 01             	add    $0x1,%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 422:	39 da                	cmp    %ebx,%edx
 424:	75 f2                	jne    418 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 426:	5b                   	pop    %ebx
 427:	5e                   	pop    %esi
 428:	5d                   	pop    %ebp
 429:	c3                   	ret    

0000042a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 42a:	b8 01 00 00 00       	mov    $0x1,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <exit>:
SYSCALL(exit)
 432:	b8 02 00 00 00       	mov    $0x2,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <wait>:
SYSCALL(wait)
 43a:	b8 03 00 00 00       	mov    $0x3,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    

00000442 <pipe>:
SYSCALL(pipe)
 442:	b8 04 00 00 00       	mov    $0x4,%eax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret    

0000044a <read>:
SYSCALL(read)
 44a:	b8 05 00 00 00       	mov    $0x5,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    

00000452 <write>:
SYSCALL(write)
 452:	b8 10 00 00 00       	mov    $0x10,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret    

0000045a <close>:
SYSCALL(close)
 45a:	b8 15 00 00 00       	mov    $0x15,%eax
 45f:	cd 40                	int    $0x40
 461:	c3                   	ret    

00000462 <kill>:
SYSCALL(kill)
 462:	b8 06 00 00 00       	mov    $0x6,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret    

0000046a <exec>:
SYSCALL(exec)
 46a:	b8 07 00 00 00       	mov    $0x7,%eax
 46f:	cd 40                	int    $0x40
 471:	c3                   	ret    

00000472 <open>:
SYSCALL(open)
 472:	b8 0f 00 00 00       	mov    $0xf,%eax
 477:	cd 40                	int    $0x40
 479:	c3                   	ret    

0000047a <mknod>:
SYSCALL(mknod)
 47a:	b8 11 00 00 00       	mov    $0x11,%eax
 47f:	cd 40                	int    $0x40
 481:	c3                   	ret    

00000482 <unlink>:
SYSCALL(unlink)
 482:	b8 12 00 00 00       	mov    $0x12,%eax
 487:	cd 40                	int    $0x40
 489:	c3                   	ret    

0000048a <fstat>:
SYSCALL(fstat)
 48a:	b8 08 00 00 00       	mov    $0x8,%eax
 48f:	cd 40                	int    $0x40
 491:	c3                   	ret    

00000492 <link>:
SYSCALL(link)
 492:	b8 13 00 00 00       	mov    $0x13,%eax
 497:	cd 40                	int    $0x40
 499:	c3                   	ret    

0000049a <mkdir>:
SYSCALL(mkdir)
 49a:	b8 14 00 00 00       	mov    $0x14,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <chdir>:
SYSCALL(chdir)
 4a2:	b8 09 00 00 00       	mov    $0x9,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <dup>:
SYSCALL(dup)
 4aa:	b8 0a 00 00 00       	mov    $0xa,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    

000004b2 <getpid>:
SYSCALL(getpid)
 4b2:	b8 0b 00 00 00       	mov    $0xb,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	ret    

000004ba <get_parent_id>:
SYSCALL(get_parent_id)
 4ba:	b8 16 00 00 00       	mov    $0x16,%eax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	ret    

000004c2 <getchildren>:
SYSCALL(getchildren)
 4c2:	b8 17 00 00 00       	mov    $0x17,%eax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	ret    

000004ca <sbrk>:
SYSCALL(sbrk)
 4ca:	b8 0c 00 00 00       	mov    $0xc,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    

000004d2 <sleep>:
SYSCALL(sleep)
 4d2:	b8 0d 00 00 00       	mov    $0xd,%eax
 4d7:	cd 40                	int    $0x40
 4d9:	c3                   	ret    

000004da <uptime>:
SYSCALL(uptime)
 4da:	b8 0e 00 00 00       	mov    $0xe,%eax
 4df:	cd 40                	int    $0x40
 4e1:	c3                   	ret    

000004e2 <set>:
SYSCALL(set)
 4e2:	b8 18 00 00 00       	mov    $0x18,%eax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	ret    

000004ea <count>:
SYSCALL(count)
 4ea:	b8 19 00 00 00       	mov    $0x19,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    

000004f2 <sleepp>:
SYSCALL(sleepp)
 4f2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	ret    

000004fa <cmos>:
SYSCALL(cmos)
 4fa:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4ff:	cd 40                	int    $0x40
 501:	c3                   	ret    
 502:	66 90                	xchg   %ax,%ax
 504:	66 90                	xchg   %ax,%ax
 506:	66 90                	xchg   %ax,%ax
 508:	66 90                	xchg   %ax,%ax
 50a:	66 90                	xchg   %ax,%ax
 50c:	66 90                	xchg   %ax,%ax
 50e:	66 90                	xchg   %ax,%ax

00000510 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 510:	55                   	push   %ebp
 511:	89 e5                	mov    %esp,%ebp
 513:	57                   	push   %edi
 514:	56                   	push   %esi
 515:	53                   	push   %ebx
 516:	89 c6                	mov    %eax,%esi
 518:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 51b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 51e:	85 db                	test   %ebx,%ebx
 520:	74 7e                	je     5a0 <printint+0x90>
 522:	89 d0                	mov    %edx,%eax
 524:	c1 e8 1f             	shr    $0x1f,%eax
 527:	84 c0                	test   %al,%al
 529:	74 75                	je     5a0 <printint+0x90>
    neg = 1;
    x = -xx;
 52b:	89 d0                	mov    %edx,%eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 52d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    x = -xx;
 534:	f7 d8                	neg    %eax
 536:	89 75 c0             	mov    %esi,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 539:	31 ff                	xor    %edi,%edi
 53b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 53e:	89 ce                	mov    %ecx,%esi
 540:	eb 08                	jmp    54a <printint+0x3a>
 542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 548:	89 cf                	mov    %ecx,%edi
 54a:	31 d2                	xor    %edx,%edx
 54c:	8d 4f 01             	lea    0x1(%edi),%ecx
 54f:	f7 f6                	div    %esi
 551:	0f b6 92 94 09 00 00 	movzbl 0x994(%edx),%edx
  }while((x /= base) != 0);
 558:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 55a:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 55d:	75 e9                	jne    548 <printint+0x38>
  if(neg)
 55f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 562:	8b 75 c0             	mov    -0x40(%ebp),%esi
 565:	85 c0                	test   %eax,%eax
 567:	74 08                	je     571 <printint+0x61>
    buf[i++] = '-';
 569:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 56e:	8d 4f 02             	lea    0x2(%edi),%ecx
 571:	8d 7c 0d d7          	lea    -0x29(%ebp,%ecx,1),%edi
 575:	8d 76 00             	lea    0x0(%esi),%esi
 578:	0f b6 07             	movzbl (%edi),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 57b:	83 ec 04             	sub    $0x4,%esp
 57e:	83 ef 01             	sub    $0x1,%edi
 581:	6a 01                	push   $0x1
 583:	53                   	push   %ebx
 584:	56                   	push   %esi
 585:	88 45 d7             	mov    %al,-0x29(%ebp)
 588:	e8 c5 fe ff ff       	call   452 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 58d:	83 c4 10             	add    $0x10,%esp
 590:	39 df                	cmp    %ebx,%edi
 592:	75 e4                	jne    578 <printint+0x68>
    putc(fd, buf[i]);
}
 594:	8d 65 f4             	lea    -0xc(%ebp),%esp
 597:	5b                   	pop    %ebx
 598:	5e                   	pop    %esi
 599:	5f                   	pop    %edi
 59a:	5d                   	pop    %ebp
 59b:	c3                   	ret    
 59c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5a0:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5a2:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 5a9:	eb 8b                	jmp    536 <printint+0x26>
 5ab:	90                   	nop
 5ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000005b0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5b0:	55                   	push   %ebp
 5b1:	89 e5                	mov    %esp,%ebp
 5b3:	57                   	push   %edi
 5b4:	56                   	push   %esi
 5b5:	53                   	push   %ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5b6:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5b9:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5bc:	8b 75 0c             	mov    0xc(%ebp),%esi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5bf:	8b 7d 08             	mov    0x8(%ebp),%edi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5c2:	89 45 d0             	mov    %eax,-0x30(%ebp)
 5c5:	0f b6 1e             	movzbl (%esi),%ebx
 5c8:	83 c6 01             	add    $0x1,%esi
 5cb:	84 db                	test   %bl,%bl
 5cd:	0f 84 b0 00 00 00    	je     683 <printf+0xd3>
 5d3:	31 d2                	xor    %edx,%edx
 5d5:	eb 39                	jmp    610 <printf+0x60>
 5d7:	89 f6                	mov    %esi,%esi
 5d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 5e0:	83 f8 25             	cmp    $0x25,%eax
 5e3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        state = '%';
 5e6:	ba 25 00 00 00       	mov    $0x25,%edx
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 5eb:	74 18                	je     605 <printf+0x55>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5ed:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 5f0:	83 ec 04             	sub    $0x4,%esp
 5f3:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 5f6:	6a 01                	push   $0x1
 5f8:	50                   	push   %eax
 5f9:	57                   	push   %edi
 5fa:	e8 53 fe ff ff       	call   452 <write>
 5ff:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 602:	83 c4 10             	add    $0x10,%esp
 605:	83 c6 01             	add    $0x1,%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 608:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 60c:	84 db                	test   %bl,%bl
 60e:	74 73                	je     683 <printf+0xd3>
    c = fmt[i] & 0xff;
    if(state == 0){
 610:	85 d2                	test   %edx,%edx
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 612:	0f be cb             	movsbl %bl,%ecx
 615:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 618:	74 c6                	je     5e0 <printf+0x30>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 61a:	83 fa 25             	cmp    $0x25,%edx
 61d:	75 e6                	jne    605 <printf+0x55>
      if(c == 'd'){
 61f:	83 f8 64             	cmp    $0x64,%eax
 622:	0f 84 f8 00 00 00    	je     720 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 628:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 62e:	83 f9 70             	cmp    $0x70,%ecx
 631:	74 5d                	je     690 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 633:	83 f8 73             	cmp    $0x73,%eax
 636:	0f 84 84 00 00 00    	je     6c0 <printf+0x110>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 63c:	83 f8 63             	cmp    $0x63,%eax
 63f:	0f 84 ea 00 00 00    	je     72f <printf+0x17f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 645:	83 f8 25             	cmp    $0x25,%eax
 648:	0f 84 c2 00 00 00    	je     710 <printf+0x160>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 64e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 651:	83 ec 04             	sub    $0x4,%esp
 654:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 658:	6a 01                	push   $0x1
 65a:	50                   	push   %eax
 65b:	57                   	push   %edi
 65c:	e8 f1 fd ff ff       	call   452 <write>
 661:	83 c4 0c             	add    $0xc,%esp
 664:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 667:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 66a:	6a 01                	push   $0x1
 66c:	50                   	push   %eax
 66d:	57                   	push   %edi
 66e:	83 c6 01             	add    $0x1,%esi
 671:	e8 dc fd ff ff       	call   452 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 676:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 67a:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 67d:	31 d2                	xor    %edx,%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 67f:	84 db                	test   %bl,%bl
 681:	75 8d                	jne    610 <printf+0x60>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 683:	8d 65 f4             	lea    -0xc(%ebp),%esp
 686:	5b                   	pop    %ebx
 687:	5e                   	pop    %esi
 688:	5f                   	pop    %edi
 689:	5d                   	pop    %ebp
 68a:	c3                   	ret    
 68b:	90                   	nop
 68c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 690:	83 ec 0c             	sub    $0xc,%esp
 693:	b9 10 00 00 00       	mov    $0x10,%ecx
 698:	6a 00                	push   $0x0
 69a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 69d:	89 f8                	mov    %edi,%eax
 69f:	8b 13                	mov    (%ebx),%edx
 6a1:	e8 6a fe ff ff       	call   510 <printint>
        ap++;
 6a6:	89 d8                	mov    %ebx,%eax
 6a8:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6ab:	31 d2                	xor    %edx,%edx
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
 6ad:	83 c0 04             	add    $0x4,%eax
 6b0:	89 45 d0             	mov    %eax,-0x30(%ebp)
 6b3:	e9 4d ff ff ff       	jmp    605 <printf+0x55>
 6b8:	90                   	nop
 6b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 6c0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 6c3:	8b 18                	mov    (%eax),%ebx
        ap++;
 6c5:	83 c0 04             	add    $0x4,%eax
 6c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
          s = "(null)";
 6cb:	b8 8a 09 00 00       	mov    $0x98a,%eax
 6d0:	85 db                	test   %ebx,%ebx
 6d2:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
 6d5:	0f b6 03             	movzbl (%ebx),%eax
 6d8:	84 c0                	test   %al,%al
 6da:	74 23                	je     6ff <printf+0x14f>
 6dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6e0:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6e3:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 6e6:	83 ec 04             	sub    $0x4,%esp
 6e9:	6a 01                	push   $0x1
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 6eb:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6ee:	50                   	push   %eax
 6ef:	57                   	push   %edi
 6f0:	e8 5d fd ff ff       	call   452 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6f5:	0f b6 03             	movzbl (%ebx),%eax
 6f8:	83 c4 10             	add    $0x10,%esp
 6fb:	84 c0                	test   %al,%al
 6fd:	75 e1                	jne    6e0 <printf+0x130>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6ff:	31 d2                	xor    %edx,%edx
 701:	e9 ff fe ff ff       	jmp    605 <printf+0x55>
 706:	8d 76 00             	lea    0x0(%esi),%esi
 709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 710:	83 ec 04             	sub    $0x4,%esp
 713:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 716:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 719:	6a 01                	push   $0x1
 71b:	e9 4c ff ff ff       	jmp    66c <printf+0xbc>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 720:	83 ec 0c             	sub    $0xc,%esp
 723:	b9 0a 00 00 00       	mov    $0xa,%ecx
 728:	6a 01                	push   $0x1
 72a:	e9 6b ff ff ff       	jmp    69a <printf+0xea>
 72f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 732:	83 ec 04             	sub    $0x4,%esp
 735:	8b 03                	mov    (%ebx),%eax
 737:	6a 01                	push   $0x1
 739:	88 45 e4             	mov    %al,-0x1c(%ebp)
 73c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 73f:	50                   	push   %eax
 740:	57                   	push   %edi
 741:	e8 0c fd ff ff       	call   452 <write>
 746:	e9 5b ff ff ff       	jmp    6a6 <printf+0xf6>
 74b:	66 90                	xchg   %ax,%ax
 74d:	66 90                	xchg   %ax,%ax
 74f:	90                   	nop

00000750 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 750:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 751:	a1 50 0c 00 00       	mov    0xc50,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 756:	89 e5                	mov    %esp,%ebp
 758:	57                   	push   %edi
 759:	56                   	push   %esi
 75a:	53                   	push   %ebx
 75b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 75e:	8b 10                	mov    (%eax),%edx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 760:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 763:	39 c8                	cmp    %ecx,%eax
 765:	73 19                	jae    780 <free+0x30>
 767:	89 f6                	mov    %esi,%esi
 769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 770:	39 d1                	cmp    %edx,%ecx
 772:	72 1c                	jb     790 <free+0x40>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 774:	39 d0                	cmp    %edx,%eax
 776:	73 18                	jae    790 <free+0x40>
static Header base;
static Header *freep;

void
free(void *ap)
{
 778:	89 d0                	mov    %edx,%eax
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 77a:	39 c8                	cmp    %ecx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 77c:	8b 10                	mov    (%eax),%edx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 77e:	72 f0                	jb     770 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 780:	39 d0                	cmp    %edx,%eax
 782:	72 f4                	jb     778 <free+0x28>
 784:	39 d1                	cmp    %edx,%ecx
 786:	73 f0                	jae    778 <free+0x28>
 788:	90                   	nop
 789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
  if(bp + bp->s.size == p->s.ptr){
 790:	8b 73 fc             	mov    -0x4(%ebx),%esi
 793:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 796:	39 d7                	cmp    %edx,%edi
 798:	74 19                	je     7b3 <free+0x63>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 79a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 79d:	8b 50 04             	mov    0x4(%eax),%edx
 7a0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7a3:	39 f1                	cmp    %esi,%ecx
 7a5:	74 23                	je     7ca <free+0x7a>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 7a7:	89 08                	mov    %ecx,(%eax)
  freep = p;
 7a9:	a3 50 0c 00 00       	mov    %eax,0xc50
}
 7ae:	5b                   	pop    %ebx
 7af:	5e                   	pop    %esi
 7b0:	5f                   	pop    %edi
 7b1:	5d                   	pop    %ebp
 7b2:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7b3:	03 72 04             	add    0x4(%edx),%esi
 7b6:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 7b9:	8b 10                	mov    (%eax),%edx
 7bb:	8b 12                	mov    (%edx),%edx
 7bd:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7c0:	8b 50 04             	mov    0x4(%eax),%edx
 7c3:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7c6:	39 f1                	cmp    %esi,%ecx
 7c8:	75 dd                	jne    7a7 <free+0x57>
    p->s.size += bp->s.size;
 7ca:	03 53 fc             	add    -0x4(%ebx),%edx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 7cd:	a3 50 0c 00 00       	mov    %eax,0xc50
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7d2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7d5:	8b 53 f8             	mov    -0x8(%ebx),%edx
 7d8:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 7da:	5b                   	pop    %ebx
 7db:	5e                   	pop    %esi
 7dc:	5f                   	pop    %edi
 7dd:	5d                   	pop    %ebp
 7de:	c3                   	ret    
 7df:	90                   	nop

000007e0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7e0:	55                   	push   %ebp
 7e1:	89 e5                	mov    %esp,%ebp
 7e3:	57                   	push   %edi
 7e4:	56                   	push   %esi
 7e5:	53                   	push   %ebx
 7e6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7e9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 7ec:	8b 15 50 0c 00 00    	mov    0xc50,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7f2:	8d 78 07             	lea    0x7(%eax),%edi
 7f5:	c1 ef 03             	shr    $0x3,%edi
 7f8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 7fb:	85 d2                	test   %edx,%edx
 7fd:	0f 84 a3 00 00 00    	je     8a6 <malloc+0xc6>
 803:	8b 02                	mov    (%edx),%eax
 805:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 808:	39 cf                	cmp    %ecx,%edi
 80a:	76 74                	jbe    880 <malloc+0xa0>
 80c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 812:	be 00 10 00 00       	mov    $0x1000,%esi
 817:	8d 1c fd 00 00 00 00 	lea    0x0(,%edi,8),%ebx
 81e:	0f 43 f7             	cmovae %edi,%esi
 821:	ba 00 80 00 00       	mov    $0x8000,%edx
 826:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
 82c:	0f 46 da             	cmovbe %edx,%ebx
 82f:	eb 10                	jmp    841 <malloc+0x61>
 831:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 838:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 83a:	8b 48 04             	mov    0x4(%eax),%ecx
 83d:	39 cf                	cmp    %ecx,%edi
 83f:	76 3f                	jbe    880 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 841:	39 05 50 0c 00 00    	cmp    %eax,0xc50
 847:	89 c2                	mov    %eax,%edx
 849:	75 ed                	jne    838 <malloc+0x58>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 84b:	83 ec 0c             	sub    $0xc,%esp
 84e:	53                   	push   %ebx
 84f:	e8 76 fc ff ff       	call   4ca <sbrk>
  if(p == (char*)-1)
 854:	83 c4 10             	add    $0x10,%esp
 857:	83 f8 ff             	cmp    $0xffffffff,%eax
 85a:	74 1c                	je     878 <malloc+0x98>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 85c:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 85f:	83 ec 0c             	sub    $0xc,%esp
 862:	83 c0 08             	add    $0x8,%eax
 865:	50                   	push   %eax
 866:	e8 e5 fe ff ff       	call   750 <free>
  return freep;
 86b:	8b 15 50 0c 00 00    	mov    0xc50,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 871:	83 c4 10             	add    $0x10,%esp
 874:	85 d2                	test   %edx,%edx
 876:	75 c0                	jne    838 <malloc+0x58>
        return 0;
 878:	31 c0                	xor    %eax,%eax
 87a:	eb 1c                	jmp    898 <malloc+0xb8>
 87c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 880:	39 cf                	cmp    %ecx,%edi
 882:	74 1c                	je     8a0 <malloc+0xc0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 884:	29 f9                	sub    %edi,%ecx
 886:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 889:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 88c:	89 78 04             	mov    %edi,0x4(%eax)
      }
      freep = prevp;
 88f:	89 15 50 0c 00 00    	mov    %edx,0xc50
      return (void*)(p + 1);
 895:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 898:	8d 65 f4             	lea    -0xc(%ebp),%esp
 89b:	5b                   	pop    %ebx
 89c:	5e                   	pop    %esi
 89d:	5f                   	pop    %edi
 89e:	5d                   	pop    %ebp
 89f:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 8a0:	8b 08                	mov    (%eax),%ecx
 8a2:	89 0a                	mov    %ecx,(%edx)
 8a4:	eb e9                	jmp    88f <malloc+0xaf>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 8a6:	c7 05 50 0c 00 00 54 	movl   $0xc54,0xc50
 8ad:	0c 00 00 
 8b0:	c7 05 54 0c 00 00 54 	movl   $0xc54,0xc54
 8b7:	0c 00 00 
    base.s.size = 0;
 8ba:	b8 54 0c 00 00       	mov    $0xc54,%eax
 8bf:	c7 05 58 0c 00 00 00 	movl   $0x0,0xc58
 8c6:	00 00 00 
 8c9:	e9 3e ff ff ff       	jmp    80c <malloc+0x2c>
