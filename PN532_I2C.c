#include "PN532_I2C.h"

TWI_BUFFER_STRUCT twi_rx;
TWI_BUFFER_STRUCT twi_tx;
TWI_BUFFER_STRUCT PN532_msg;
unsigned char checksum;
int i;

void TWIInit(void)
{
    //set SCL to 100kHz
    TWSR = 0x00;
    TWBR = 7;   //347,826
    //enable TWI
    TWCR = (1<<TWEN);
}

void TWIStart(void)
{
    TWCR = (1<<TWINT)|(1<<TWSTA)|(1<<TWEN);
    while ((TWCR & (1<<TWINT)) == 0);   
}
//send stop signal
void TWIStop(void)
{
    TWCR = (1<<TWINT)|(1<<TWSTO)|(1<<TWEN);
}

void TWIWrite(unsigned char u8data)
{
    TWDR = u8data;
    TWCR = (1<<TWINT)|(1<<TWEN);
    while ((TWCR & (1<<TWINT)) == 0); 
}

//read byte with ACK (Set TWEA, clear TWEA to send NACK, indicating master receiver has read the last byte)
unsigned char TWIRead(int ack)
{
    TWCR = (1<<TWINT)|(1<<TWEN)|(ack<<TWEA);
    while ((TWCR & (1<<TWINT)) == 0);   
    return TWDR;
}

void PN532_cmd(TWI_BUFFER_STRUCT* msg)
{
  TWIStart();
  TWIWrite(PN532_ADD);
  for(i = 0; i < msg->length; ++i){
    TWIWrite(msg->buffer[i]);
  }     
  TWIStop();  
}

void PN532_build_msg(TWI_BUFFER_STRUCT* buffer, TWI_BUFFER_STRUCT* msg)
{
  int msg_length = 0;
  checksum = 0xD4;

  buffer->buffer[PN532_START]=0x00;                     ++msg_length;
  buffer->buffer[PN532_START+1]=0xFF;                   ++msg_length;
  buffer->buffer[PN532_LEN]=msg->length+1;               ++msg_length;
  buffer->buffer[PN532_LCS]=(~(msg->length+1))+1;        ++msg_length;  
  buffer->buffer[PN532_TFI]=0xD4;                       ++msg_length;
  for(i = 0; i<msg->length; ++i){
    buffer->buffer[PN532_DATA+i]=msg->buffer[i];              ++msg_length;
    checksum += msg->buffer[i];
  }
  buffer->buffer[PN532_DATA+i]= (~(checksum&0xFF))+1;   ++msg_length;
  buffer->length = msg_length;
}

bool PN532_read(TWI_BUFFER_STRUCT* dest)
{ 
  unsigned char data = 0x00;
  unsigned char len = 0x00;       
  // check ready bit
  while(1){
    TWIStart();
    TWIWrite(PN532_ADD | 1); 
    data = TWIRead(1);
    if(data==0x00) TWIStop();
    else if(data==0x01) break;
  }    
  // get rid of preamble
  TWIRead(1);            
  //check start of packet
  if((data=TWIRead(1))!=0x00) {TWIStop(); return false;}
  dest->buffer[len++]=data;
  if((data=TWIRead(1))!=0xFF) {TWIStop(); return false;}
  dest->buffer[len++]=data;
  
  //get length
  dest->buffer[len++]=TWIRead(1);
  //get length checksum
  dest->buffer[len++]=TWIRead(1);
  //get TFI (should be D5)
  dest->buffer[len++]=TWIRead(1);
  
  for(i =0; i < dest->buffer[PN532_LEN]-1; ++i)
  {
    dest->buffer[len++] = TWIRead(1);
  }
  
  //skip data checksum
  dest->buffer[len++]=TWIRead(0);
  
  //set buffer length
  dest->length = len;
  
  //close comm
  TWIStop();
  
  //return true on success
  return true;
}

void PN532_get_msg(TWI_BUFFER_STRUCT* src, TWI_BUFFER_STRUCT* dest, unsigned char offset)
{ 
  // exclude TFI from src, thus -1
  dest->length = src->buffer[PN532_LEN]-1-offset;
  for(i=0; i < dest->length; ++i)
  {
    dest->buffer[i] = src->buffer[PN532_DATA+i+offset];
  }
}

bool PN532_wait_for_ack(){
  unsigned char data = 0x00;       
  // check ready bit
  while(1){
    TWIStart();
    TWIWrite(PN532_ADD | 1); 
    //TWIStart();
    data = TWIRead(1);
    if(data==0x00) TWIStop();
    else if(data==0x01) break;
  }    
  // get rid of preamble
  TWIRead(1);
  //check start of packet
  if(TWIRead(1)!=0x00) {TWIStop(); return false;}
  if(TWIRead(1)!=0xFF) {TWIStop(); return false;}
  
  //check ack
  if(TWIRead(1)!=0x00) {TWIStop(); return false;}
  if(TWIRead(0)!=0xFF) {TWIStop(); return false;}
  TWIStop();
  return true;
}

void PN532_get_firmware()
{  
  PN532_msg.buffer[0]=PN532_CMD_GETFIRMWARE; 
  PN532_msg.length=1;
  PN532_build_msg(&twi_tx, &PN532_msg);
  PN532_cmd(&twi_tx); 
  delay_ms(20);
  while(!PN532_wait_for_ack()) delay_ms(20); 
  delay_ms(20);        
  PN532_read(&twi_rx);
  PN532_get_msg(&twi_rx, &PN532_msg, 1);
}

bool PN532_SAM_config()
{  
  PN532_msg.buffer[0] = PN532_CMD_SAMCONFIGURATION;  
  PN532_msg.buffer[1] = 0x01; // normal mode;
  PN532_msg.buffer[2] = 0x14; // timeout 50ms * 20 = 1 second
  PN532_msg.buffer[3] = 0x00; // not using IRQ pin!
  PN532_msg.length=4;
  PN532_build_msg(&twi_tx, &PN532_msg);
  PN532_cmd(&twi_tx); 
  delay_ms(20);
  while(!PN532_wait_for_ack()) delay_ms(20); 
  delay_ms(20);        
  PN532_read(&twi_rx);
  PN532_get_msg(&twi_rx, &PN532_msg, 0); 
  if(PN532_msg.buffer[0]==0x15) return true;
  else return false;   
}

void PN532_read_passive_tag()
{  
  PN532_msg.buffer[0] = PN532_CMD_INLISTPASSIVETARGET;  
  PN532_msg.buffer[1] = 1;  // max 1 cards at once
  PN532_msg.buffer[2] = PN532_MIFARE_ISO14443A; //baudrate
  PN532_msg.length=3;
  PN532_build_msg(&twi_tx, &PN532_msg);
  PN532_cmd(&twi_tx); 
  delay_ms(20);
  while(!PN532_wait_for_ack()) delay_ms(20); 
  delay_ms(20);        
  PN532_read(&twi_rx);
  PN532_get_msg(&twi_rx, &PN532_msg, 1);
  /* ISO14443A card response should be in the following format:

    byte            Description
    -------------   ------------------------------------------
    b0..6           Frame header and preamble
    b7              Tags Found
    b8              Tag Number (only one used in this example)
    b9..10          SENS_RES
    b11             SEL_RES
    b12             NFCID Length
    b13..NFCIDLen   NFCID                                      */    
}