#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#define O_CREATE  0x200
#define O_WRONLY  0x001
#define O_RDONLY  0x000
#include "x86.h"
#define child_NUM 4

int
main(int argc, char *argv[])
{  

   int childrenn[child_NUM];
   int havechild = 0;
   int children[child_NUM][child_NUM];
   int i,j;
   int mainparent = getpid();
   int isfirstchild = 0;
   if(strcmp(argv[1],"1") == 0)
   {
   childrenn[0] = fork();
   for(i = 1; i < child_NUM;i++){
      if(childrenn[i-1] == 0){
         printf(1,"Father pid : %d\n",get_parent_id());
         printf(1,"Child pid : %d\n",getpid());
         havechild = 0;
         exit();
      }
      else{
         havechild = 1;
         childrenn[i]=fork();
      }

   }


   if(havechild == 1)
   {
     if(getpid() == mainparent){ 
        for(i = 0; i < child_NUM;i++){
            printf(1,"children array : %d\n",childrenn[i]);
        }
        printf(1,"getchildren syscall : %d\n",getchildren(mainparent));

     }
   }
   for(i = 0; i < child_NUM; i++)
      wait();

   exit();


   }

//////////////////////////////////////////bonus////////////////////////////////////////////
   if(strcmp(argv[1],"2") == 0)
   {

   for(i = 0;i < child_NUM;i++)
       for(j=0;j < child_NUM;j++)
           children[i][j] = -1;

   printf(1,"mainparent pid : %d\n",mainparent);
   children[0][0] = fork();


   if (children[0][0] == 0){
        isfirstchild = 1;
   	children[0][1] = fork();
        if (children[0][1] != 0)
            children[0][2] = fork();
   }


  


   if ((children[0][1] == 0) || (children[0][2] == 0)){
        isfirstchild = 0;
        exit();
   }


   if(isfirstchild){
        printf(1,"Father pid : %d\n",get_parent_id());
        printf(1,"First degree child : %d\n",getpid());
	printf(1,"Second degree child 1 : %d\n",children[0][1]);
	printf(1,"Second degree child 2 : %d\n",children[0][2]);
        printf(1,"getchildren syscall : %d\n",getchildren(mainparent));
   }



   for(i = 0; i < 2; i++)
        wait();

   exit();
   }
}


