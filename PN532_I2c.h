#ifndef __PN532_I2C__
#define __PN532_I2C__

#include <mega8.h>
#include <delay.h>
#include <stdbool.h>

#define PN532_ADD (0x48)
#define TWI_BUFFER_SIZE 80
#define TWI_MSG_BUFFER_SIZE 80

#define PN532_PREAMBLE 0x00
#define PN532_POSTAMBLE 0x00

#define PN532_START 0x00
#define PN532_LEN 0x02
#define PN532_LCS 0x03
#define PN532_TFI 0x04
#define PN532_DATA 0x05

typedef struct{
  unsigned char buffer[TWI_BUFFER_SIZE];
  int length;
} TWI_BUFFER_STRUCT;

extern TWI_BUFFER_STRUCT twi_rx;
extern TWI_BUFFER_STRUCT twi_tx;
extern TWI_BUFFER_STRUCT PN532_msg;

void TWIInit(void);
void TWIStart(void);
//send stop signal
void TWIStop(void);
void TWIWrite(unsigned char u8data);
//read byte with ACK (Set TWEA, clear TWEA to send NACK, indicating master receiver has read the last byte)
unsigned char TWIRead(int ack);

void PN532_cmd(TWI_BUFFER_STRUCT*);
void PN532_build_msg(TWI_BUFFER_STRUCT*, TWI_BUFFER_STRUCT*);
bool PN532_read(TWI_BUFFER_STRUCT*);
void PN532_get_msg(TWI_BUFFER_STRUCT*, TWI_BUFFER_STRUCT*);
bool PN532_wait_for_ack();
void PN532_get_firmware();

#endif