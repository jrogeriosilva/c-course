#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {

    char elm[21] = {'.'};
    int index;
    int nBombs = 0;

    scanf("%s", elm);
    scanf("%d", &index);

    if (elm[index] == 'x') {
        printf("bum! \n");
    } else {
        if (elm[index - 1] == 'x') {
            nBombs++;
        }

        if (elm[index + 1] == 'x') {
            nBombs++;
        }

        printf("%d",nBombs);
    }

    return 0;
}