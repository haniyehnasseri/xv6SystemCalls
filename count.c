#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"


int main(int argc,char* argv[]){
        int n,digits,ret;
	n=atoi(argv[1]);
        __asm__ ( "movl %%esi, %0;"
                  :"=r" (ret)
                  :
                  :"%esi"

         );
	__asm__ ( "movl %0, %%esi;"
                  :
                  :"r"(n)
                  :"%esi"

         );
	digits=count(n);
        __asm__ ( "movl %0, %%esi;"
                  :
                  :"r"(ret)
                  :"%esi"

         );
	
        printf(1,"digits:%d\n",digits);
        exit();
}
