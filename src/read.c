#include<stdio.h>
#include<stdlib.h>
#include <fcntl.h>
#include <string.h>
#include <unistd.h>




int main()
{
    int fd;
    char buffer;
    size_t bytes_read;

    /* Ouverture du fichier: */

    fd = open("file.txt", O_RDWR|O_RSYNC) ;

    if (fd==-1)
    {
        printf("Ouverture du fichier impossible !\n");
        return -1;
    }
    /*Lecture du fichier: */
    do{
       bytes_read = read(fd, &buffer, sizeof(buffer));
    }
    while(bytes_read > 0);

    /* Fermeture du fichier : */
    close(fd);
    return 0;
}
