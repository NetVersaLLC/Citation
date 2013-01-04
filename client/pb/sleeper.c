#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>

void catchTerm(sig) {
  fprintf(stderr, "Sleeper dying...\n");
}

void printNotice() {
  fprintf(stderr, "Sleeper exiting...\n");
}

int main(int argc, char **argv) {
  atexit(printNotice);
  signal(SIGTERM, catchTerm);

  fprintf(stderr, "Starting sleeper process!\n");
  sleep(100);
  fprintf(stderr, "Sleeping completed!\n");
  return 0;
}
