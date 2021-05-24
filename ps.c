#include "types.h"//20193062
#include "stat.h" //20193062
#include "user.h" //20193062

int //20193062
main(int argc, char const *argv[])//20193062
{//20193062
	int pid = 0;//20193062

	if(argc < 1)//20193062
	{//20193062
		printf(2, "Usage: pid\n");//20193062
		exit();//20193062
	}//20193062
	if(argv[1][0] == '-') //20193062
	{ //20193062
		printf(2, "Wrong Input\n"); //20193062
	} //20193062
	else //20193062
	{ //20193062
		pid = atoi(argv[1]); //20193062
		ps(pid);//20193062
	} //20193062
	exit();//20193062
}//20193062

