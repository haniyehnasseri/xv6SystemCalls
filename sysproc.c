#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_get_parent_id(void)
{
  return myproc()->parent->pid;
}

int
sys_getchildren(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return getchildren(pid);
}


int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

int
sys_sleepp(void)
{
  struct rtcdate r1;
struct rtcdate r2;
  int n=10;
  argint(0 , &n);
  
  uint ticks0;
  cmostime(&r1);
  cprintf("start second:%d\n" , r1.second);
  cprintf("start mintute:%d\n" , r1.minute);
 
  acquire(&tickslock);
  ticks0 = ticks;
 
  
  while(ticks - ticks0 < 100*n){
 
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    release(&tickslock);
    acquire(&tickslock);
  }
  release(&tickslock);
  cmostime(&r2);
  cprintf("end second:%d\n" , r2.second);
  cprintf("end mintute:%d\n" , r2.minute);
  if( r2.second >= r1.second){
   cprintf("ekhtelaf daqiqe:%d sanie:%d\n" , r2.minute - r1.minute , r2.second - r1.second);
 }
  else{
   cprintf("ekhtelaf daqiqe:%d sanie:%d\n" , r2.minute - r1.minute -1 ,60 + ( r2.second - r1.second));
 }
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
void
sys_cmos(void)
{
  struct rtcdate r;
  cmostime(&r);
  cprintf("second:%d\n" , r.second);
  cprintf("mintute:%d\n" , r.minute);
}


int
sys_set(void)
{       
        argstr(0,&spath);
	return set(spath);
}

int sys_count(void)
{
	int num,m;
	num=myproc()->tf->esi;
	m=count(num);
	return m;

}
