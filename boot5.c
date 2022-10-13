/*
 * boot5.c
 *
 *   COM32 exec file using libcom32
 */

#include <string.h>
#include <stdio.h>
//#include <console.h>

int main(void)
{
  char line[2000];

  printf("Wellcome to Boot5 Lab Demo!\n\n");

  for (;;) {
    printf("> ");
    fgets(line, sizeof(line), stdin);
    if ( !strncmp(line, "exit", 4) )
      break;
    printf(": %s", line);
  }
  printf("Exiting...\n");    
  return 0;
}
