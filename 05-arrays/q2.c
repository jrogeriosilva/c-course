#include <stdio.h>

int main() {
    int m, n;
    int collection[1000];
    int fig;

    scanf("%d %d", &m, &n);

    // Inicializa Colecao Completa
    for (int i = 0; i < m; i++) {
        collection[i] = i + 1;
    }

    
    for (int i = 0; i < n; i++){
        scanf("%d",&fig);
        for (int j = 0; j < m; j++){
            if (fig == collection[j]){
               collection[j] = 0; 
            }
        }
    }


    for (int i = 0; i < m; i++){
        if(collection[i]) {
            printf("%d ", collection[i]);
        }
            
    }
    
    return 0;
}
