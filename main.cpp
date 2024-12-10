#include <iostream>
#include <sys/wait.h>
#include "funcA.h"

void sigchldHandler(int s)
{
	printf("Caught signal SIGCHLD\n");
	pid_t pid;
	int status;
	while ((pid = waitpid(-1,&status,WNOHANG)) > 0)
	{
		if (WIFEXITED(status)) printf("\nChild process terminated");
	}
}

void sigintHandler(int s)
{
	printf("Caught signal %d. Starting graceful exit procedure\n",s);
	pid_t pid;
	int status;
	while ((pid = waitpid(-1,&status,0)) > 0)
	{
		if (WIFEXITED(status)) printf("\nChild process terminated");
	}
	
	if (pid == -1) printf("\nAll child processes terminated");
	exit(EXIT_SUCCESS);
}

int main() {
    signal(SIGCHLD, sigchldHandler);
    signal(SIGINT, sigintHandler);

    FuncA func;
    double x = 0.5;
    int n = 3;
    
    double result = func.compute(x, n);
    
    std::cout << "The result of th(" << x << ") calculated using the first " << n << " terms is: " << result << std::endl;
    return 0;
}
