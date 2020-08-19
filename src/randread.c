#include<stdio.h>
#include<stdlib.h>
#include<fcntl.h>
#include<string.h>
#include<unistd.h>
#include<sys/stat.h>
#include<time.h>


#define sector_size   512


/*fonction pour un nombre aléatoire uniformement distribué*/
int RandomUniform(int N){

    int top = ((((RAND_MAX - N) + 1) / N) * N - 1) + N;
    int r;
    do {
      r = rand();
    } while (r > top);
    return (r % N);
}

int main(int argc, char *argv[])
{
    int fd;
    //char buffer;
    size_t bytes_read;
    size_t buff_size  = atoi(argv[1]);
    int counter_limit = atoi(argv[2]);
    int size_file;
    int offset;

    if(argc < 3 || argc > 4) {
       printf("Usage: %s <buffer_size> <number of random read> \n", argv[0]);
       exit(1);
    }


    /* Ouverture du fichier: */
    char filename[] = "file_ref.txt";
    fd = open(filename, O_RDWR|O_RSYNC);

    char* buffer = NULL;
    if ((buffer = (char*)malloc(buff_size)) == NULL) perror("[malloc]") ;

    if (fd==-1)
    {
        printf("Ouverture du fichier impossible !\n");
        return -1;
    }
    /*recuperer la taille du fichier*/
    struct stat st;
    stat(filename, &st);
    size_file = st.st_size;
    /*Lecture du fichier: */

    srand ((unsigned int)time(NULL));
    for(int i = 0; i<=counter_limit; i++){
        offset = RandomUniform(size_file - buff_size); // position du donnée à lire
        lseek(fd,offset,SEEK_SET); // on se place à cette position
        read(fd, buffer, buff_size);
    }

    /* Fermeture du fichier : */
    free(buffer);
    close(fd);
    return 0;
}
