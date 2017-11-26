#include "PN532_I2C.h"
#include <mega8.h>

TWI_BUFFER_STRUCT twi_rx;
TWI_BUFFER_STRUCT twi_tx;
TWI_BUFFER_STRUCT PN532_msg;
TWI_BUFFER_STRUCT tag_uid;
TWI_BUFFER_STRUCT tag_data;

unsigned char MIFARE_Key_A[] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
unsigned char checksum;
int i;

void TWIInit(void)
{
    //set SCL to 400kHz        
    TWSR = 0x00;
    TWBR = 7;   //347,826
    //enable TWI
    TWCR = (1<<TWEN);
}

void TWIStart(void)
{
    TWCR = (1<<TWINT)|(1<<TWSTA)|(1<<TWEN);
    while ((TWCR & (1<<TWINT)) == 0) ;   
}

void TWIStop(void)
{
    //TWCR = (1<<TWINT)|(1<<TWSTO)|(1<<TWEN);
//    DDRC.4 = DDRC.5 = 0;  
//    delay_ms(2);
//    DDRC.4=1;
    DDRC.4=DDRC.5=1;
    PORTC.4=0;PORTC.5=1;
    delay_ms(1);
    PORTC.4=1;                     
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
    while ((TWCR & (1<<TWINT)) == 0) ;   
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
    if(TWSR == 0x48) continue;
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
    
    // if NACK received, repeat data request
    if(TWSR == 0x48) continue;
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
  TWIInit();
  while(!PN532_wait_for_ack());
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
  while(!PN532_wait_for_ack()); 
  PN532_read(&twi_rx);
  PN532_get_msg(&twi_rx, &PN532_msg, 0); 
  if(PN532_msg.buffer[0]==0x15) return true;
  else return false;   
}

bool PN532_read_uid()
{  
  PN532_msg.buffer[0] = PN532_CMD_INLISTPASSIVETARGET;  
  PN532_msg.buffer[1] = 1;  // max 1 cards at once
  PN532_msg.buffer[2] = PN532_MIFARE_ISO14443A; //baudrate
  PN532_msg.length=3;
  PN532_build_msg(&twi_tx, &PN532_msg);
  PN532_cmd(&twi_tx); 
  while(!PN532_wait_for_ack()); 
  PN532_read(&twi_rx);
  PN532_get_msg(&twi_rx, &PN532_msg, 0);  
  if(PN532_msg.buffer[0] != PN532_CMD_INLISTPASSIVETARGET+1 || PN532_msg.buffer[1] < 1) return false;
  tag_uid.length = PN532_msg.buffer[6];
  for(i = 0; i<tag_uid.length; ++i)
  {
    tag_uid.buffer[i] = PN532_msg.buffer[7+i];
  }
  return true;
}

bool PN532_auth_tag(unsigned char block_number, unsigned char key_select, unsigned char* key_buffer)
{
  PN532_read_uid();
  PN532_msg.buffer[0] = PN532_CMD_INDATAEXCHANGE;
  PN532_msg.buffer[1] = 1;                              /* Max card numbers */
  PN532_msg.buffer[2] = (key_select) ? MIFARE_CMD_AUTH_B : MIFARE_CMD_AUTH_A;
  PN532_msg.buffer[3] = block_number;                    /* Block Number (1K = 0..63, 4K = 0..255 */
  for (i = 0; i < 6; ++i)
  {
    PN532_msg.buffer[4+i] = key_buffer[i];                /* 6 byte auth key */
  }
  for (i = 0; i < tag_uid.length; ++i)
  {
    PN532_msg.buffer[10+i] = tag_uid.buffer[i];                /* 4 byte card ID */
  } 
  PN532_msg.length = 10+tag_uid.length; 
  
  PN532_build_msg(&twi_tx, &PN532_msg);
  PN532_cmd(&twi_tx); 
  while(!PN532_wait_for_ack()); 
  PN532_read(&twi_rx);
  PN532_get_msg(&twi_rx, &PN532_msg, 1); 
  if(PN532_msg.buffer[0] != 0x00) return false;
  return true;
}

bool PN532_read_passive_tag(unsigned char block_number)
{
  if(!PN532_auth_tag(block_number, 0, MIFARE_Key_A)) return false;
  PN532_msg.buffer[0] = PN532_CMD_INDATAEXCHANGE;
  PN532_msg.buffer[1] = 1;                              /* Max card numbers */
  PN532_msg.buffer[2] = MIFARE_CMD_READ;
  PN532_msg.buffer[3] = block_number;                    /* Block Number (1K = 0..63, 4K = 0..255 */
  PN532_msg.length = 4;    
  
  PN532_build_msg(&twi_tx, &PN532_msg);
  PN532_cmd(&twi_tx); 
  while(!PN532_wait_for_ack()); 
  PN532_read(&twi_rx);
  PN532_get_msg(&twi_rx, &PN532_msg, 1); 
  if(PN532_msg.buffer[0] != 0x00) return false;
  PN532_get_msg(&twi_rx, &tag_data, 2);  
  return true;
}

bool PN532_write_passive_tag(unsigned char block_number, TWI_BUFFER_STRUCT* data)
{
  if(!PN532_auth_tag(block_number, 0, MIFARE_Key_A)) return false;
  PN532_msg.buffer[0] = PN532_CMD_INDATAEXCHANGE;
  PN532_msg.buffer[1] = 1;                              /* Max card numbers */
  PN532_msg.buffer[2] = MIFARE_CMD_WRITE;
  PN532_msg.buffer[3] = block_number;                    /* Block Number (1K = 0..63, 4K = 0..255 */
  for (i = 0; i < data->length && i < 16; ++i)
  {
    PN532_msg.buffer[4+i] = data->buffer[i];                /* 16 byte data */
  }
  PN532_msg.length = 4+i;    
  
  PN532_build_msg(&twi_tx, &PN532_msg);
  PN532_cmd(&twi_tx); 
  while(!PN532_wait_for_ack()); 
  PN532_read(&twi_rx);
  PN532_get_msg(&twi_rx, &PN532_msg, 1); 
  if(PN532_msg.buffer[0] != 0x00) return false;
  PN532_get_msg(&twi_rx, &tag_data, 2);  
  return true;
}