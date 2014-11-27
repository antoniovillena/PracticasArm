#include <termios.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/ioctl.h>

#define SOH 0x01
#define EOT 0x04
#define ACK 0x06
#define NAK 0x15

int main(int argc, char* argv[]){
  FILE *fi;
  int i, fd;
  unsigned char sum, j, recb, block= 1;
  unsigned char buf[128];
  struct termios attr;

  if( argc != 2 )
    printf( "sendx v0.99 by Antonio Villena, 27 Nov 2014\n\n"
            "  sendx <input_file>\n\n"
            "  <input_file>   Bare Metal input binary file\n\n"),
    exit(0);
  fi= fopen(argv[1], "r");
  if( !fi )
    printf("Couldn't open file %s\n", argv[1]),
    exit(1);
  fd= open("/dev/ttyUSB0", O_RDWR | O_NOCTTY | O_NDELAY);
  if( fd == -1 )
    printf("Couldn't open serial device /dev/ttyUSB0\n"),
    exit(1);
  tcgetattr(fd, &attr);
  cfsetispeed(&attr, B115200);    // Set input and output speed to 115200 baud
  cfsetospeed(&attr, B115200);
  attr.c_cflag&= ~PARENB;         // Set data bits, parity and stop bit to 8N1
  attr.c_cflag&= ~CSTOPB;
  attr.c_cflag&= ~CSIZE;
  attr.c_cflag|= CS8;
  attr.c_cflag&= ~CRTSCTS;        // Turn off flow control
  attr.c_iflag&= ~(IXON | IXOFF | IXANY);
  attr.c_lflag&= ~(ICANON | ECHO | ECHOE | ISIG);
  tcsetattr(fd, TCSANOW, &attr);          // Apply attributes to the serial port device
  ioctl(fd, TIOCMGET, &i);                // read status signal
  i|= TIOCM_DTR;                          // DTR=1 (press reset)
  ioctl(fd, TIOCMSET, &i);                // write status
  usleep( 200*1000 );                     // wait 200ms
  i&= ~TIOCM_DTR;                         // DTR=0 (release reset)
  ioctl(fd, TIOCMSET, &i);                // write status
  tcflush(fd, TCIOFLUSH);
  fcntl(fd, F_SETFL, 0);
  read(fd, &recb, 1);
  printf("Initializing file transfer...\n");
  while ( fread(&buf, 1, 128, fi)>0 ){
    j= SOH;
    write(fd, &j, 1);
    j= block;
    write(fd, &j, 1);
    j= 255-block++;
    write(fd, &j, 1);
    if( write(fd, buf, 128) !=128 )
      printf("Error writing to serial port\n"),
      exit(-1);
    for ( j= i = 0; i < 128; i++ )
      j+= buf[i];
    write(fd, &j, 1);
    if( read(fd, &recb, 1)==1 && recb == ACK )
      printf("."),
      fflush(stdout);
    else
      printf("Received NAK, expected ACK\n"),
      exit(-1);
  }
  j= EOT;
  write(fd, &j, 1);
  if( read(fd, &recb, 1)!=1 || recb != ACK )
    printf("No ACK for EOT message\n"),
    exit(-1);
  printf("\nFile transfer successfully.\n");
  fclose(fi);
  close(fd);
}
