#include "types.h"//20193062
#include "stat.h" //20193062
#include "user.h" //20193062

int //20193062
main(int argc, char const *argv[])//20193062
{//20193062
    int pid = 0;//20193062
    int nice = 0; //20193062
  
    if(argc < 2)//20193062
    {//20193062
	printf(2, "Usage: pid\n");//20193062
	exit();//20193062
    }//20193062
    pid = atoi(argv[1]);//20193062
    nice = getnice(pid);//20193062
    if(nice == - 1)//20193062
    {//20193062
	printf(2, "invalid pid!\n");//20193062
	exit();//20193062
    }//20193062

    printf(1,"pid  : %d\tnice  : %d\n",pid,nice);//20193062
    exit();//20193062
}//20193062
