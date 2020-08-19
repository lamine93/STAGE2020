#include<stdio.h>
#include<stdlib.h>
#include <fcntl.h>
#include <string.h>
#include <unistd.h>


#define sector_size   512

int main(int argc, char *argv[])
{
    int fd;
    size_t bytes_read;
    size_t offset    = 0;
    size_t buff_size = atoi(argv[1]);

    /* Ouverture du fichier: */
    char filename[] = "file_ref.txt";
    fd = open(filename, O_RDWR|O_RSYNC) ;

    if(argc < 2 || argc > 3) {
       printf("Usage: %s <buffer_size>  \n", argv[0]);
       exit(1);
    }

    char* buffer = NULL;
    if ((buffer = (char*)malloc(buff_size)) == NULL) perror("[malloc]") ;

    if (fd==-1)
    {
        printf("Ouverture du fichier impossible !\n");
        return -1;
    }

    lseek(fd, offset, SEEK_SET); // on se place à cette position
    /*Lecture du fichier: */
    do{
      bytes_read = read(fd, buffer, buff_size);
    }
    while(bytes_read >0);

    /* Fermeture du fichier : */
    free(buffer);
    close(fd);
    return 0;
}
