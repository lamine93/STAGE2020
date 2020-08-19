#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define counter_limit 1000000

int main()
{
    int fd;

    /*Données à écrire */
     //int buff = rand();
    char buff = 'A';
    /* Ouverture du fichier: */
    char filename[] = "file_ref.txt";
    fd = open(filename, O_CREAT|O_TRUNC|O_RDWR|O_SYNC) ;

    if (fd==-1)
    {
        printf("Ouverture du fichier impossible !\n");
        return -1;
    }
    /* Ecriture dans le fichier: */
    for(int i = 0; i<counter_limit; i++){
          write(fd, &buff, sizeof(buff));
    }
    /* Fermeture du fichier : */
    close(fd) ;
    return 0;
}
