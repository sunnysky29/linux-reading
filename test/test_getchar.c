/*

用于文件复制，

dsfd
dsfd
gfygthhttg
gfygthhttg
*/


#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main() {
    
    int c;

    c = getchar();
    while (c != EOF)
    {
        /* code */
        putchar(c);
        c= getchar();
    }
    

    return 0;
}
