#ifndef PIXEL_H
#define PIXEL_H

typedef struct Pixel{
    int r,g,b;
}Pixel;

void alterarPixel(Pixel *p, int r, int g, int b);

#endif