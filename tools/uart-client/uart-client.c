#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#include "sio_cmd.h"
#include "parse.h"

// #define DEBUG

//
// send and receive a 3-byte packet
//
int uart_packet( int fd, int tx_func, uint16_t tx_dat, uint16_t *rx_dat) {
  uint8_t tx_pkt[3], rx_pkt[3], ch;

  send( fd, '$');
  tx_pkt[0] = 0x40 | ((tx_func & 3) << 4) | ((tx_dat >> 12) & 0xf);
  tx_pkt[1] = 0x40 | ((tx_dat >> 6) & 0x3f);
  tx_pkt[2] = 0x40 | (tx_dat & 0x3f);

  for( int i=0; i<3; i++) {
#ifdef DEBUG
    printf("Send %d '%c'\n", i, tx_pkt[i]);
#endif    
    send( fd, tx_pkt[i]);
  }

  while( receive( fd) != '$')
    ;

  for( int i=0; i<3; i++) {
    rx_pkt[i] = receive( fd);
#ifdef DEBUG
    printf("Recv: %d '%c'\n", i, rx_pkt[i]);
#endif
  }

  if( (rx_pkt[0] & 0xc0) != 0x40 ||
      (rx_pkt[1] & 0xc0) != 0x40 ||
      (rx_pkt[2] & 0xc0) != 0x40)
    return -1;

  *rx_dat = ((rx_pkt[0] & 0xf) << 12) |
    ((rx_pkt[1] & 0x3f) << 6) |
    (rx_pkt[2] & 0x3f);

  return 0;
}

#define MAXARG 4

int main( int argc, char *argv[]) {
  char *port;
  int fd;
  char buff[80];
  int func;
  uint16_t i_tx, i_rx;

  char *cargv[MAXARG];
  int iargv[MAXARG];

  if( argc < 1)
    port = "/dev/ttyUSB0";
  else
    port = argv[1];
    
  if( (fd = sio_open( "/dev/ttyUSB0", 115200)) < 0) {
    printf("Open failed for port %s\n", port);
    exit(1);
  }

  while(1) {
    fgets( buff, sizeof(buff), stdin);
    int n = parse( buff, cargv, iargv, MAXARG);
    int rc = uart_packet( fd, iargv[0], iargv[1], &i_rx);
    if( rc) {
      printf("packet error\n");
      exit(0);
    }
    printf("Send: 0x%x  Receive: 0x%x\n", iargv[1], i_rx);
  }
}
