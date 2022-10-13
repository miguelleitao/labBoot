/* ----------------------------------------------------------------------- *
 *   
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, Inc., 53 Temple Place Ste 330,
 *   Boston MA 02111-1307, USA; either version 2 of the License, or
 *   (at your option) any later version; incorporated herein by reference.
 *
 * ----------------------------------------------------------------------- */

/*
 * boot5.c
 *
 *   Executavel COM32 com libcom32
 */

#include <string.h>
#include <stdio.h>
//#include <console.h>

int main(void)
{
  char linha[2000];

  printf("Benvindo ao maravilhoso mundo da Arquitectura de Computadores!\n\n");

  for (;;) {
    printf("> ");
    fgets(linha, sizeof(linha), stdin);
    if ( !strncmp(linha, "exit", 4) )
      break;
    printf(": %s", linha);
  }
    
  return 0;
}
