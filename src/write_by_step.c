#include <fcntl.h>
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>


#define sector_size   512

int main(int argc, char *argv[])
{
    int fd;
    //char buffer[counter_limit];
    //const void* buffer;
    size_t bytes_write;
    size_t buff_size = atoi(argv[1]);
    size_t step      = atoi(argv[2]);
    size_t offset    = 0;
    size_t left_to_write;
    size_t size_file;

    if(argc < 3 || argc > 4) {
       printf("Usage: %s <buffer_size> <step> \n", argv[0]);
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

    /*ecriture dans fichier par pas step: */
     size_t position = 0;
     int flag = 1;
     while(flag){
       size_t written = write(fd, buffer, buff_size);
       position = lseek(fd, step, SEEK_CUR); // on se place à cette position : offset
       if(position >= size_file) break;
     }

    /* Fermeture du fichier : */
    free(buffer);
    close(fd);
    return 0;
}
