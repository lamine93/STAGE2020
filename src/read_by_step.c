#define _GNU_SOURCE
#include<stdio.h>
#include<stdlib.h>
#include <fcntl.h>
#include <string.h>
#include <unistd.h>
#include <sys/stat.h>



#define sector_size   512

int main(int argc, char *argv[])
{
    int fd;
    //char buffer[counter_limit];
    size_t bytes_read;
    size_t buff_size = atoi(argv[1]);
    size_t step      = atoi(argv[2]);
    size_t offset    = 0;
    size_t left_to_read;
    size_t size_file;

    if(argc < 3 || argc > 4) {
       printf("Usage: %s <buffer_size> <step> \n", argv[0]);
       exit(1);
    }

    /*allocate memory*/
    char* buffer = NULL;
    if ((buffer = (char*)malloc(buff_size)) == NULL) perror("[malloc]");
    /*if(posix_memalign((void*)&buffer, sector_size, buff_size))
    {
        perror("posix_memalign failed");
    }*/
    /* Ouverture du fichier: */
    char filename[] = "file_ref.txt";
    fd = open(filename, O_RDWR|O_RSYNC) ;

    if (fd==-1)
    {
        printf("Ouverture du fichier impossible !\n");
        return -1;
    }

    /*recuperer la taille du fichier*/
    struct stat st;
    stat(filename, &st);
    size_file = st.st_size;
    left_to_read = size_file;

    size_t position = 0;
    int flag = 1;
    /*Lecture du fichier: */
    while(flag){
       bytes_read = read(fd, buffer, buff_size);
       position = lseek(fd, step, SEEK_CUR); // on se place à cette position
       if(position >= size_file) break;
     }

    /* Fermeture du fichier : */
    free(buffer);
    close(fd);
    return 0;
}
