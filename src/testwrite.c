#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/stat.h>



int main(int argc, char *argv[])
{
    int fd;

    size_t bytes_write;
    size_t offset    = 0;
    size_t buff_size = atoi(argv[1]);
    int counter_limit = atoi(argv[2]);
    size_t left_to_write;
    size_t size_file;

    if(argc < 3 || argc > 4) {
       printf("Usage: %s <buffer_size> <number of random write>  \n", argv[0]);
       exit(1);
    }

    /* Ouverture du fichier: */

    char filename[] = "file_ref.txt";
    fd = open(filename,  O_CREAT|O_RDWR|O_SYNC) ;
    if (fd==-1)
    {
        printf("Ouverture du fichier impossible !\n");
        return -1;
    }

   /*allocate memory*/
    /*void* buffer = NULL;
    if(posix_memalign(&buffer, sector_size, buff_size))*/
    char* buffer = NULL;
    if ((buffer = (char*)malloc(buff_size)) == NULL) perror("[malloc]") ;
    for (size_t i = 0; i < buff_size; i++) {
        buffer[i]='C';
    }

    /*recuperer la taille du fichier*/
    struct stat st;
    stat(filename, &st);
    size_file = st.st_size;
    left_to_write = size_file;

    lseek(fd, offset, SEEK_SET); // on se place à cette position
    while(left_to_write > 0)
    {
      size_t written = write(fd, buffer, buff_size);
      left_to_write -= written;
      //printf("%ld\n", left_to_write);
    }
    /* Fermeture du fichier : */
    free(buffer);
    close(fd);
    return 0;
}
