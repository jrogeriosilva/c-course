#include "imagem.h"
#include <stdio.h>
#include <malloc.h>


Imagem criarImagem(int fmt, int width, int height){
    Imagem img;
    img.w = width;
    img.h = height;
    img.fmt = fmt;

    img.matriz = malloc(height*sizeof (Pixel *));
    for(int i = 0; i < height; i++){
        img.matriz[i]= malloc(width*sizeof (Pixel));
    }
    return img;
}

Imagem carregarImagem(char *filename){
    Imagem img;
    char fmt[3];
    int intensidadeMax;

    FILE *arq = fopen(filename, "r");
    fscanf(arq, "%s", fmt);
    if(fmt[1] == '3') {
        fscanf(arq, "%d %d", &img.w, &img.h);
        fscanf(arq, "%d", &intensidadeMax);
        img = criarImagem(fmt[1] - '1', img.w, img.h);
        for (int i = 0; i < img.h; ++i) {
            for (int j = 0; j < img.w; ++j) {
                fscanf(arq, "%d", &img.matriz[i][j].r);
                fscanf(arq, "%d", &img.matriz[i][j].g);
                fscanf(arq, "%d", &img.matriz[i][j].b);
            }
        }
        fclose(arq);
        return img;
    }


}
Imagem clonarImagem(Imagem img){
    Imagem cloneImg = criarImagem(img.fmt, img.w, img.h);
    for (int i = 0; i < img.h; ++i) {
        for (int j = 0; j < img.w; ++j) {
            cloneImg.matriz[i][j] = img.matriz[i][j];
        }
    }
    return cloneImg;
}

void liberarMemoria(Imagem img){
    for (int i = 0; i < img.h; ++i) {
        free(img.matriz[i]);
    }
    free(img.matriz);
}
void salvarImagem(Imagem img, char *filename){
    FILE *arq = fopen(filename, "w");
    fprintf(arq, "P%d\n", img.fmt + 1);
    fprintf(arq, "%d %d\n", img.w, img.h);
    fprintf(arq, "255\n");
    for (int i = 0; i < img.h; ++i) {
        for (int j = 0; j < img.w; ++j) {
            fprintf(arq, "%d\n", img.matriz[i][j].r);
            fprintf(arq, "%d\n", img.matriz[i][j].g);
            fprintf(arq, "%d\n", img.matriz[i][j].b);
        }
    }


}
void preencherImagem(Imagem img, int r, int g, int b){
    for (int i = 0; i < img.h; ++i) {
        for (int j = 0; j < img.w; ++j) {
            alterarPixel(&img.matriz[i][j], r, g, b);
        }
    }
}
void alterarBrilho(Imagem img, int delta){
    for (int i = 0; i <img.h; ++i) {
        for (int j = 0; j < img.w; ++j) {
            alterarPixel(&img.matriz[i][j],
                         img.matriz[i][j].r+delta,
                         img.matriz[i][j].g+delta,
                         img.matriz[i][j].b+delta);
        }
    }
};
Imagem borrarImagem(Imagem img, int a);