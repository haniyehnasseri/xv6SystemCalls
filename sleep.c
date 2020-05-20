#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "date.h"
#include "x86.h"

int
main(int argc, char *argv[])
{
	if( argc == 2){
  
 
  int pid;
  pid=fork();
  if(pid==0){
  	

  }
  else{
       
  	wait();
  	
  	cmos();
  	sleepp(atoi(argv[1]));
  	cmos();
  }
  
exit();
}
return 0;
}
