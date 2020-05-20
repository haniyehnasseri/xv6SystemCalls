#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"


int main(int argc,char* argv[]){
        if(strcmp(argv[1],"PATH")!=0){
	   printf(1,"command not found\n");
	   exit();
        }
	else{
	    set(argv[2]);
            exit();
	}
}
