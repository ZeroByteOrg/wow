#include <cbm.h>
#include <stdio.h>
#include <stdint.h>
#include "pcmplayer.h"

#define AUDIOFILE "wow.bin"
#define LFN 2
#define SA LFN
#define DEVICE 8

extern void __fastcall__ vsync();
int16_t __fastcall__ macptr(uint8_t num_bytes, void* buffer);

char* head;
char* tail;
char* stopper;
char bank;


#define FILL                    \
while (size > 0) {              \
  if (size >= 512)              \
    tmp = macptr(0,head);       \
  else if (size >= 256)         \
    tmp = macptr(255,head);     \
  else                          \
    tmp = macptr(size,head);    \
  if (tmp == -1) break;         \
  head += tmp;                  \
  size -= tmp;                  \
}                               \
// if EOF then size=0
// else:

char mem_fill() {

  static unsigned int size;
  static int tmp;

  RAM_BANK = bank;

  if (head >= tail) {
    size = 0xc000 - (unsigned int)head;
    FILL;
    head = (char*)0xa000;
    --RAM_BANK; // macptr will have incremented the bank
  }
  if (size > 0) return 1; // we hit an error or EOF. Either way, we're done.
  size = (unsigned int)(tail - head);
  FILL;
  return (size > 0);
}

char loader_init() {
  cbm_k_setnam(AUDIOFILE);
  cbm_k_setlfs(LFN,DEVICE,SA);
  cbm_k_open();
  cbm_k_chkin(LFN);
  // open the streaming audio file and leave it open
  head=(char*)0xa000;
  tail=(char*)0xa000;
  return 1;
}

void main() {
  cbm_k_bsout(CH_FONT_UPPER);
  pcm_init();
  loader_init();
  if (mem_fill()) {stopper = head;}
  pcm_start_streaming(1);
}
