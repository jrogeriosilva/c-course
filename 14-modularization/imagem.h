#ifndef IMAGEM_H
#define IMAGEM_H
#include <stdlib.h>

#include "pixel.h"
enum FMT_IMG {P1, P2, P3, P4, P5, P6};

typedef struct Imagem {
    Pixel **matriz;
    int w, h;
    int fmt;
}Imagem;

Imagem criarImagem(int fmt, int width, int height);
Imagem carregarImagem(char *filename);
Imagem clonarImagem(Imagem img);
void liberarMemoria(Imagem img);
void salvarImagem(Imagem img, char *filename);
void preencherImagem(Imagem img, int r, int g, int b);
void alterarBrilho(Imagem img, int delta);
Imagem borrarImagem(Imagem img, int a);

#endif
