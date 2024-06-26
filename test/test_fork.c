#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

int main() {
    printf("000000000\n");
    int pid = fork();
    printf("111111111\n");
    if (pid > 0) {
        // Parent process
        printf("parent: child=%d\n", pid);
        // pid = wait((int *) 0);
        printf("child %d is done\n", pid);
    } else if (pid == 0) {
        // Child process
        printf("child: exiting\n");
        // exit(0);
    } else {
        // Fork error
        printf("fork error\n");
        return 1; // Return non-zero to indicate failure
    }

    printf("--------------\n");
    return 0; // Return 0 to indicate success
}
