
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega8A
;Program type           : Application
;Clock frequency        : 12.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': No
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega8A
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _rx_wr_index=R5
	.DEF _rx_rd_index=R4
	.DEF _rx_counter=R7
	.DEF _gtc_state=R6
	.DEF _gtc_last_state=R9
	.DEF _checksum=R8
	.DEF _i=R10
	.DEF _i_msb=R11

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP _usart_rx_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x20003:
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x06
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x06
	.DW  _MIFARE_Key_A
	.DW  _0x20003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <string.h>
;#include "PN532_I2C.h"
;
;// Declare your global variables here
;
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE         (1<<RXC)
;#define FRAMING_ERROR       (1<<FE)
;#define PARITY_ERROR        (1<<UPE)
;#define DATA_OVERRUN        (1<<DOR)
;
;unsigned char GTC_Buffer[64];
;unsigned char GTC_Gate_ID[2] = {0x00, 0x00};
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 128
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE <= 256
;unsigned char rx_wr_index=0,rx_rd_index=0;
;#else
;unsigned int rx_wr_index=0,rx_rd_index=0;
;#endif
;
;#if RX_BUFFER_SIZE < 256
;unsigned char rx_counter=0;
;#else
;unsigned int rx_counter=0;
;#endif
;
;void clear_buffer(){
; 0000 0021 void clear_buffer(){

	.CSEG
_clear_buffer:
; .FSTART _clear_buffer
; 0000 0022   rx_wr_index=0;
	CLR  R5
; 0000 0023   rx_rd_index=0;
	CLR  R4
; 0000 0024   rx_counter=0;
	CLR  R7
; 0000 0025 }
	RET
; .FEND
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 002C {
_usart_rx_isr:
; .FSTART _usart_rx_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 002D char status,data;
; 0000 002E status=UCSRA;
	RCALL __SAVELOCR2
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 002F data=UDR;
	IN   R16,12
; 0000 0030 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x3
; 0000 0031    {
; 0000 0032    rx_buffer[rx_wr_index++]=data;
	MOV  R30,R5
	INC  R5
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 0033 #if RX_BUFFER_SIZE == 256
; 0000 0034    // special case for receiver buffer size=256
; 0000 0035    if (++rx_counter == 0) rx_buffer_overflow=1;
; 0000 0036 #else
; 0000 0037    if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDI  R30,LOW(128)
	CP   R30,R5
	BRNE _0x4
	CLR  R5
; 0000 0038    if (++rx_counter == RX_BUFFER_SIZE)
_0x4:
	INC  R7
	LDI  R30,LOW(128)
	CP   R30,R7
	BRNE _0x5
; 0000 0039       {
; 0000 003A       rx_counter=0;
	CLR  R7
; 0000 003B       rx_buffer_overflow=1;
	SET
	BLD  R2,0
; 0000 003C       }
; 0000 003D #endif
; 0000 003E    }
_0x5:
; 0000 003F }
_0x3:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 0046 {
_getchar:
; .FSTART _getchar
; 0000 0047 char data;
; 0000 0048 while (rx_counter==0);
	ST   -Y,R17
;	data -> R17
_0x6:
	TST  R7
	BREQ _0x6
; 0000 0049 data=rx_buffer[rx_rd_index++];
	MOV  R30,R4
	INC  R4
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	LD   R17,Z
; 0000 004A #if RX_BUFFER_SIZE != 256
; 0000 004B if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
	LDI  R30,LOW(128)
	CP   R30,R4
	BRNE _0x9
	CLR  R4
; 0000 004C #endif
; 0000 004D #asm("cli")
_0x9:
	cli
; 0000 004E --rx_counter;
	DEC  R7
; 0000 004F #asm("sei")
	sei
; 0000 0050 return data;
	MOV  R30,R17
	RJMP _0x2060004
; 0000 0051 }
; .FEND
;#pragma used-
;#endif
;
;#define GTC_ACK_TIMEOUT        1000
;#define GTC_STATE_WAIT_ENTRY   0
;#define GTC_STATE_WAIT_ACK     1
;#define GTC_STATE_WAIT_EXIT    2
;
;volatile int gtc_timeout=0;
;char gtc_state = GTC_STATE_WAIT_ENTRY, gtc_last_state = GTC_STATE_WAIT_ENTRY;
;
;void reset_gtc_timeout(){
; 0000 005D void reset_gtc_timeout(){
_reset_gtc_timeout:
; .FSTART _reset_gtc_timeout
; 0000 005E   gtc_timeout = GTC_ACK_TIMEOUT;
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	STS  _gtc_timeout,R30
	STS  _gtc_timeout+1,R31
; 0000 005F }
	RET
; .FEND
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0066 {
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
	ST   -Y,R0
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0067 // Reinitialize Timer1 value
; 0000 0068 TCNT1H=0xD1;
	RCALL SUBOPT_0x0
; 0000 0069 TCNT1L=0x20;
; 0000 006A // Place your code here
; 0000 006B if(gtc_timeout>0) --gtc_timeout;
	LDS  R26,_gtc_timeout
	LDS  R27,_gtc_timeout+1
	RCALL __CPW02
	BRGE _0xA
	LDI  R26,LOW(_gtc_timeout)
	LDI  R27,HIGH(_gtc_timeout)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 006C }
_0xA:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;// Global variables
;
;void main(void)
; 0000 0071 {
_main:
; .FSTART _main
; 0000 0072 // Declare your local variables here
; 0000 0073 int i, len;
; 0000 0074 unsigned char ch, checksum;
; 0000 0075 
; 0000 0076 // Input/Output Ports initialization
; 0000 0077 // Port B initialization
; 0000 0078 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0079 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
;	i -> R16,R17
;	len -> R18,R19
;	ch -> R21
;	checksum -> R20
	LDI  R30,LOW(0)
	OUT  0x17,R30
; 0000 007A // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 007B PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (1<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(2)
	OUT  0x18,R30
; 0000 007C 
; 0000 007D // Port C initialization
; 0000 007E // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 007F DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(0)
	OUT  0x14,R30
; 0000 0080 // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0081 PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 0082 
; 0000 0083 // Port D initialization
; 0000 0084 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=In Bit1=In Bit0=In
; 0000 0085 DDRD=(0<<DDD7) | (0<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(60)
	OUT  0x11,R30
; 0000 0086 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=1 Bit2=T Bit1=T Bit0=T
; 0000 0087 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (1<<PORTD3) | (1<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(12)
	OUT  0x12,R30
; 0000 0088 
; 0000 0089 // Timer/Counter 0 initialization
; 0000 008A // Clock source: System Clock
; 0000 008B // Clock value: Timer 0 Stopped
; 0000 008C TCCR0=(0<<CS02) | (0<<CS01) | (0<<CS00);
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 008D TCNT0=0x00;
	OUT  0x32,R30
; 0000 008E 
; 0000 008F // Timer/Counter 1 initialization
; 0000 0090 // Clock source: System Clock
; 0000 0091 // Clock value: 12000.000 kHz
; 0000 0092 // Mode: Normal top=0xFFFF
; 0000 0093 // OC1A output: Disconnected
; 0000 0094 // OC1B output: Disconnected
; 0000 0095 // Noise Canceler: Off
; 0000 0096 // Input Capture on Falling Edge
; 0000 0097 // Timer Period: 1 ms
; 0000 0098 // Timer1 Overflow Interrupt: On
; 0000 0099 // Input Capture Interrupt: Off
; 0000 009A // Compare A Match Interrupt: Off
; 0000 009B // Compare B Match Interrupt: Off
; 0000 009C TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 009D TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
	LDI  R30,LOW(1)
	OUT  0x2E,R30
; 0000 009E TCNT1H=0xD1;
	RCALL SUBOPT_0x0
; 0000 009F TCNT1L=0x20;
; 0000 00A0 ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 00A1 ICR1L=0x00;
	OUT  0x26,R30
; 0000 00A2 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00A3 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00A4 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00A5 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00A6 
; 0000 00A7 // Timer/Counter 2 initialization
; 0000 00A8 // Clock source: System Clock
; 0000 00A9 // Clock value: Timer2 Stopped
; 0000 00AA // Mode: Normal top=0xFF
; 0000 00AB // OC2 output: Disconnected
; 0000 00AC ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 00AD TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 00AE TCNT2=0x00;
	OUT  0x24,R30
; 0000 00AF OCR2=0x00;
	OUT  0x23,R30
; 0000 00B0 
; 0000 00B1 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00B2 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (0<<TOIE0);
	LDI  R30,LOW(4)
	OUT  0x39,R30
; 0000 00B3 
; 0000 00B4 // External Interrupt(s) initialization
; 0000 00B5 // INT0: Off
; 0000 00B6 // INT1: Off
; 0000 00B7 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 00B8 
; 0000 00B9 // USART initialization
; 0000 00BA // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 00BB // USART Receiver: On
; 0000 00BC // USART Transmitter: On
; 0000 00BD // USART Mode: Asynchronous
; 0000 00BE // USART Baud Rate: 9600
; 0000 00BF UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	OUT  0xB,R30
; 0000 00C0 UCSRB=(1<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0000 00C1 UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 00C2 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 00C3 UBRRL=0x4D;
	LDI  R30,LOW(77)
	OUT  0x9,R30
; 0000 00C4 
; 0000 00C5 // Analog Comparator initialization
; 0000 00C6 // Analog Comparator: Off
; 0000 00C7 // The Analog Comparator's positive input is
; 0000 00C8 // connected to the AIN0 pin
; 0000 00C9 // The Analog Comparator's negative input is
; 0000 00CA // connected to the AIN1 pin
; 0000 00CB ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00CC SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00CD 
; 0000 00CE // ADC initialization
; 0000 00CF // ADC disabled
; 0000 00D0 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 00D1 
; 0000 00D2 // SPI initialization
; 0000 00D3 // SPI disabled
; 0000 00D4 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 00D5 
; 0000 00D6 // TWI initialization
; 0000 00D7 // Mode: TWI Master
; 0000 00D8 // Bit Rate: 400 kHz
; 0000 00D9 //twi_master_init(400);
; 0000 00DA TWIInit();
	RCALL _TWIInit
; 0000 00DB 
; 0000 00DC // Global enable interrupts
; 0000 00DD #asm("sei")
	sei
; 0000 00DE 
; 0000 00DF #define LED_MERAH PORTC.3
; 0000 00E0 #define LED_KUNING PORTC.2
; 0000 00E1 #define LED_HIJAU PORTC.1
; 0000 00E2 DDRC.3=1;DDRC.2=1;DDRC.1=1;
	SBI  0x14,3
	SBI  0x14,2
	SBI  0x14,1
; 0000 00E3 LED_MERAH=0;LED_KUNING=1;LED_HIJAU=1;
	CBI  0x15,3
	SBI  0x15,2
	SBI  0x15,1
; 0000 00E4 
; 0000 00E5 delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 00E6 PN532_SAM_config();
	RCALL _PN532_SAM_config
; 0000 00E7 PN532_get_firmware();
	RCALL _PN532_get_firmware
; 0000 00E8 
; 0000 00E9 delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	RCALL _delay_ms
; 0000 00EA while(!PN532_read_uid());
_0x17:
	RCALL _PN532_read_uid
	CPI  R30,0
	BREQ _0x17
; 0000 00EB 
; 0000 00EC LED_MERAH=1;LED_KUNING=1;LED_HIJAU=0;
	SBI  0x15,3
	SBI  0x15,2
	CBI  0x15,1
; 0000 00ED while (1)
_0x20:
; 0000 00EE       {
; 0000 00EF         switch(gtc_state){
	MOV  R30,R6
; 0000 00F0             case GTC_STATE_WAIT_ENTRY:
	CPI  R30,0
	BREQ PC+2
	RJMP _0x26
; 0000 00F1                 LED_MERAH=1;LED_KUNING=1;LED_HIJAU=0;
	SBI  0x15,3
	SBI  0x15,2
	CBI  0x15,1
; 0000 00F2                 if(rx_counter!=0) ch = getchar();
	TST  R7
	BREQ _0x2D
	RCALL SUBOPT_0x1
; 0000 00F3                 gtc_last_state = GTC_STATE_WAIT_ENTRY;
_0x2D:
	CLR  R9
; 0000 00F4                 if(ch == 0x00){
	CPI  R21,0
	BREQ PC+2
	RJMP _0x2E
; 0000 00F5                   ch = getchar();
	RCALL SUBOPT_0x1
; 0000 00F6                   if(ch == 0xFF){
	CPI  R21,255
	BREQ PC+2
	RJMP _0x2F
; 0000 00F7                     checksum = 0;
	RCALL SUBOPT_0x2
; 0000 00F8                     len = getchar();
; 0000 00F9                     for(i = 0; i < len; ++i){
_0x31:
	__CPWRR 16,17,18,19
	BRGE _0x32
; 0000 00FA                       ch = getchar();
	RCALL SUBOPT_0x1
; 0000 00FB                       GTC_Buffer[i] = ch;
	RCALL SUBOPT_0x3
; 0000 00FC                       checksum += ch;
; 0000 00FD                     }
	RCALL SUBOPT_0x4
	RJMP _0x31
_0x32:
; 0000 00FE                     ch = getchar();
	RCALL SUBOPT_0x1
; 0000 00FF                     if((checksum+ch) != 0) break;
	MOV  R30,R21
	ADD  R30,R20
	BREQ _0x33
	RJMP _0x25
; 0000 0100                     if(GTC_Buffer[0] == 0xA1){
_0x33:
	RCALL SUBOPT_0x5
	BRNE _0x34
; 0000 0101                         if(GTC_Buffer[1] == 0x01){
	__GETB2MN _GTC_Buffer,1
	CPI  R26,LOW(0x1)
	BRNE _0x35
; 0000 0102                             GTC_Gate_ID[0] = GTC_Buffer[2];
	__GETB1MN _GTC_Buffer,2
	STS  _GTC_Gate_ID,R30
; 0000 0103                             GTC_Gate_ID[1] = GTC_Buffer[3];
	__GETB1MN _GTC_Buffer,3
	__PUTB1MN _GTC_Gate_ID,1
; 0000 0104                             checksum = 0;
	LDI  R20,LOW(0)
; 0000 0105                             putchar(0x00);
	LDI  R26,LOW(0)
	RCALL _putchar
; 0000 0106                             putchar(0xFF);
	LDI  R26,LOW(255)
	RCALL _putchar
; 0000 0107                             putchar(tag_uid.length+2);
	__GETB2MN _tag_uid,80
	SUBI R26,-LOW(2)
	RCALL _putchar
; 0000 0108                             putchar(0xA2);                 checksum += 0xA2;
	LDI  R26,LOW(162)
	RCALL _putchar
	SUBI R20,-LOW(162)
; 0000 0109                             putchar(tag_uid.length);       checksum += tag_uid.length;
	__GETB2MN _tag_uid,80
	RCALL _putchar
	__GETB1MN _tag_uid,80
	ADD  R20,R30
; 0000 010A                             for(i = 0; i<tag_uid.length; ++i)
	RCALL SUBOPT_0x6
_0x37:
	RCALL SUBOPT_0x7
	CP   R16,R30
	CPC  R17,R31
	BRGE _0x38
; 0000 010B                             {
; 0000 010C                               putchar(tag_uid.buffer[i]);  checksum += tag_uid.buffer[i];
	RCALL SUBOPT_0x8
	LD   R26,X
	RCALL _putchar
	RCALL SUBOPT_0x8
	LD   R30,X
	ADD  R20,R30
; 0000 010D                             }
	RCALL SUBOPT_0x4
	RJMP _0x37
_0x38:
; 0000 010E                             putchar((~checksum)+1);
	MOV  R30,R20
	NEG  R30
	MOV  R26,R30
	RCALL _putchar
; 0000 010F                             gtc_state = GTC_STATE_WAIT_ACK;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 0110                             reset_gtc_timeout();
	RCALL _reset_gtc_timeout
; 0000 0111                             clear_buffer();
	RCALL _clear_buffer
; 0000 0112                         }
; 0000 0113                     }
_0x35:
; 0000 0114                   }
_0x34:
; 0000 0115                 }
_0x2F:
; 0000 0116                 break;
_0x2E:
	RJMP _0x25
; 0000 0117             case GTC_STATE_WAIT_ACK:
_0x26:
	CPI  R30,LOW(0x1)
	BRNE _0x39
; 0000 0118                 LED_MERAH=1;LED_KUNING=0;LED_HIJAU=0;
	SBI  0x15,3
	CBI  0x15,2
	RCALL SUBOPT_0x9
; 0000 0119                 if(gtc_timeout == 0) {
	BRNE _0x40
; 0000 011A                   GTC_Gate_ID[0] = 0;
	RCALL SUBOPT_0xA
; 0000 011B                   GTC_Gate_ID[1] = 0;
; 0000 011C                   gtc_state = GTC_STATE_WAIT_ENTRY;
; 0000 011D                   gtc_last_state = GTC_STATE_WAIT_ACK;
	LDI  R30,LOW(1)
	MOV  R9,R30
; 0000 011E                   reset_gtc_timeout();
	RCALL _reset_gtc_timeout
; 0000 011F                   break;
	RJMP _0x25
; 0000 0120                 }
; 0000 0121                 if(rx_counter!=0) ch = getchar();
_0x40:
	TST  R7
	BREQ _0x41
	RCALL SUBOPT_0x1
; 0000 0122                 if(ch == 0x00){
_0x41:
	CPI  R21,0
	BRNE _0x42
; 0000 0123                   ch = getchar();
	RCALL SUBOPT_0x1
; 0000 0124                   if(ch == 0xFF){
	CPI  R21,255
	BRNE _0x43
; 0000 0125                     checksum = 0;
	RCALL SUBOPT_0x2
; 0000 0126                     len = getchar();
; 0000 0127                     for(i = 0; i < len; ++i){
_0x45:
	__CPWRR 16,17,18,19
	BRGE _0x46
; 0000 0128                       ch = getchar();
	RCALL SUBOPT_0x1
; 0000 0129                       GTC_Buffer[i] = ch;
	RCALL SUBOPT_0x3
; 0000 012A                       checksum += ch;
; 0000 012B                     }
	RCALL SUBOPT_0x4
	RJMP _0x45
_0x46:
; 0000 012C                     ch = getchar();
	RCALL SUBOPT_0x1
; 0000 012D                     if((checksum+ch) != 0) break;
	MOV  R30,R21
	ADD  R30,R20
	BREQ _0x47
	RJMP _0x25
; 0000 012E                     if(GTC_Buffer[0] == 0xA1){
_0x47:
	RCALL SUBOPT_0x5
	BRNE _0x48
; 0000 012F                         if(GTC_Buffer[1] == 0xFF){
	__GETB2MN _GTC_Buffer,1
	CPI  R26,LOW(0xFF)
	BRNE _0x49
; 0000 0130                             for(i = 0; i<GTC_Buffer[2]; ++i)
	RCALL SUBOPT_0x6
_0x4B:
	__GETB1MN _GTC_Buffer,2
	MOVW R26,R16
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x4C
; 0000 0131                             {
; 0000 0132                               if(GTC_Buffer[i+3] == tag_uid.buffer[i]) gtc_state = GTC_STATE_WAIT_EXIT;
	MOVW R30,R16
	__ADDW1MN _GTC_Buffer,3
	LD   R0,Z
	RCALL SUBOPT_0x8
	LD   R30,X
	CP   R30,R0
	BRNE _0x4D
	LDI  R30,LOW(2)
	MOV  R6,R30
; 0000 0133                               else {gtc_state = GTC_STATE_WAIT_ENTRY; break;}
	RJMP _0x4E
_0x4D:
	CLR  R6
	RJMP _0x4C
_0x4E:
; 0000 0134                             }
	RCALL SUBOPT_0x4
	RJMP _0x4B
_0x4C:
; 0000 0135                             reset_gtc_timeout();
	RCALL _reset_gtc_timeout
; 0000 0136                             clear_buffer();
	RCALL _clear_buffer
; 0000 0137                         }
; 0000 0138                     }
_0x49:
; 0000 0139                   }
_0x48:
; 0000 013A                 }
_0x43:
; 0000 013B                 break;
_0x42:
	RJMP _0x25
; 0000 013C             case GTC_STATE_WAIT_EXIT:
_0x39:
	CPI  R30,LOW(0x2)
	BRNE _0x25
; 0000 013D                 LED_MERAH=0;LED_KUNING=1;LED_HIJAU=0;
	CBI  0x15,3
	SBI  0x15,2
	RCALL SUBOPT_0x9
; 0000 013E                 if(gtc_timeout == 0) {
	BRNE _0x56
; 0000 013F                   GTC_Gate_ID[0] = 0;
	RCALL SUBOPT_0xA
; 0000 0140                   GTC_Gate_ID[1] = 0;
; 0000 0141                   gtc_state = GTC_STATE_WAIT_ENTRY;
; 0000 0142                   gtc_last_state = GTC_STATE_WAIT_EXIT;
	LDI  R30,LOW(2)
	MOV  R9,R30
; 0000 0143                   reset_gtc_timeout();
	RCALL _reset_gtc_timeout
; 0000 0144                   break;
	RJMP _0x25
; 0000 0145                 }
; 0000 0146                 if(rx_counter!=0) ch = getchar();
_0x56:
	TST  R7
	BREQ _0x57
	RCALL SUBOPT_0x1
; 0000 0147                 if(ch == 0x00){
_0x57:
	CPI  R21,0
	BRNE _0x58
; 0000 0148                   checksum = 0;
	LDI  R20,LOW(0)
; 0000 0149                   ch = getchar();
	RCALL SUBOPT_0x1
; 0000 014A                   if(ch == 0xFF){
	CPI  R21,255
	BRNE _0x59
; 0000 014B                     len = getchar();
	RCALL _getchar
	MOV  R18,R30
	CLR  R19
; 0000 014C                     for(i = 0; i < len; ++i){
	RCALL SUBOPT_0x6
_0x5B:
	__CPWRR 16,17,18,19
	BRGE _0x5C
; 0000 014D                       ch = getchar();
	RCALL SUBOPT_0x1
; 0000 014E                       GTC_Buffer[i] = ch;
	RCALL SUBOPT_0x3
; 0000 014F                       checksum += ch;
; 0000 0150                     }
	RCALL SUBOPT_0x4
	RJMP _0x5B
_0x5C:
; 0000 0151                     ch = getchar();
	RCALL SUBOPT_0x1
; 0000 0152                     if((checksum+ch) != 0) break;
	MOV  R30,R21
	ADD  R30,R20
	BRNE _0x25
; 0000 0153                     if(GTC_Buffer[0] == 0xA1){
	RCALL SUBOPT_0x5
	BRNE _0x5E
; 0000 0154                         if(GTC_Buffer[1] == 0x01){
	__GETB2MN _GTC_Buffer,1
	CPI  R26,LOW(0x1)
	BRNE _0x5F
; 0000 0155                           if(GTC_Gate_ID[0] == GTC_Buffer[2] && GTC_Gate_ID[1] == GTC_Buffer[3]){
	__GETB1MN _GTC_Buffer,2
	LDS  R26,_GTC_Gate_ID
	CP   R30,R26
	BRNE _0x61
	__GETB2MN _GTC_Gate_ID,1
	__GETB1MN _GTC_Buffer,3
	CP   R30,R26
	BREQ _0x62
_0x61:
	RJMP _0x60
_0x62:
; 0000 0156                             reset_gtc_timeout();
	RCALL _reset_gtc_timeout
; 0000 0157                             clear_buffer();
	RCALL _clear_buffer
; 0000 0158                           }
; 0000 0159                         }
_0x60:
; 0000 015A                     }
_0x5F:
; 0000 015B                   }
_0x5E:
; 0000 015C                 }
_0x59:
; 0000 015D                 break;
_0x58:
; 0000 015E         }
_0x25:
; 0000 015F       }
	RJMP _0x20
; 0000 0160 }
_0x63:
	RJMP _0x63
; .FEND
;#include "PN532_I2C.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <mega8.h>
;
;TWI_BUFFER_STRUCT twi_rx;
;TWI_BUFFER_STRUCT twi_tx;
;TWI_BUFFER_STRUCT PN532_msg;
;TWI_BUFFER_STRUCT tag_uid;
;TWI_BUFFER_STRUCT tag_data;
;
;unsigned char MIFARE_Key_A[] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};

	.DSEG
;unsigned char checksum;
;int i;
;
;void TWIInit(void)
; 0001 000F {

	.CSEG
_TWIInit:
; .FSTART _TWIInit
; 0001 0010     //set SCL to 400kHz
; 0001 0011     TWSR = 0x00;
	LDI  R30,LOW(0)
	OUT  0x1,R30
; 0001 0012     TWBR = 7;   //347,826
	LDI  R30,LOW(7)
	OUT  0x0,R30
; 0001 0013     //enable TWI
; 0001 0014     TWCR = (1<<TWEN);
	LDI  R30,LOW(4)
	OUT  0x36,R30
; 0001 0015 }
	RET
; .FEND
;
;void TWIStart(void)
; 0001 0018 {
_TWIStart:
; .FSTART _TWIStart
; 0001 0019     TWCR = (1<<TWINT)|(1<<TWSTA)|(1<<TWEN);
	LDI  R30,LOW(164)
	OUT  0x36,R30
; 0001 001A     while ((TWCR & (1<<TWINT)) == 0) ;
_0x20004:
	IN   R30,0x36
	SBRS R30,7
	RJMP _0x20004
; 0001 001B }
	RET
; .FEND
;
;void TWIStop(void)
; 0001 001E {
_TWIStop:
; .FSTART _TWIStop
; 0001 001F     //TWCR = (1<<TWINT)|(1<<TWSTO)|(1<<TWEN);
; 0001 0020 //    DDRC.4 = DDRC.5 = 0;
; 0001 0021 //    delay_ms(2);
; 0001 0022 //    DDRC.4=1;
; 0001 0023     DDRC.4=DDRC.5=1;
	SBI  0x14,5
	SBI  0x14,4
; 0001 0024     PORTC.4=0;PORTC.5=1;
	CBI  0x15,4
	SBI  0x15,5
; 0001 0025     delay_ms(1);
	RCALL SUBOPT_0xB
	RCALL _delay_ms
; 0001 0026     PORTC.4=1;
	SBI  0x15,4
; 0001 0027 }
	RET
; .FEND
;
;void TWIWrite(unsigned char u8data)
; 0001 002A {
_TWIWrite:
; .FSTART _TWIWrite
; 0001 002B     TWDR = u8data;
	ST   -Y,R26
;	u8data -> Y+0
	LD   R30,Y
	OUT  0x3,R30
; 0001 002C     TWCR = (1<<TWINT)|(1<<TWEN);
	LDI  R30,LOW(132)
	OUT  0x36,R30
; 0001 002D     while ((TWCR & (1<<TWINT)) == 0);
_0x20011:
	IN   R30,0x36
	SBRS R30,7
	RJMP _0x20011
; 0001 002E }
	RJMP _0x2060001
; .FEND
;
;//read byte with ACK (Set TWEA, clear TWEA to send NACK, indicating master receiver has read the last byte)
;unsigned char TWIRead(int ack)
; 0001 0032 {
_TWIRead:
; .FSTART _TWIRead
; 0001 0033     TWCR = (1<<TWINT)|(1<<TWEN)|(ack<<TWEA);
	RCALL SUBOPT_0xC
;	ack -> Y+0
	LD   R30,Y
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	LSL  R30
	ORI  R30,LOW(0x84)
	OUT  0x36,R30
; 0001 0034     while ((TWCR & (1<<TWINT)) == 0) ;
_0x20014:
	IN   R30,0x36
	SBRS R30,7
	RJMP _0x20014
; 0001 0035     return TWDR;
	IN   R30,0x3
	RJMP _0x2060006
; 0001 0036 }
; .FEND
;
;void PN532_cmd(TWI_BUFFER_STRUCT* msg)
; 0001 0039 {
_PN532_cmd:
; .FSTART _PN532_cmd
; 0001 003A   TWIStart();
	RCALL SUBOPT_0xC
;	*msg -> Y+0
	RCALL _TWIStart
; 0001 003B   TWIWrite(PN532_ADD);
	LDI  R26,LOW(72)
	RCALL _TWIWrite
; 0001 003C   for(i = 0; i < msg->length; ++i){
	RCALL SUBOPT_0xD
_0x20018:
	LD   R26,Y
	LDD  R27,Y+1
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0xF
	BRGE _0x20019
; 0001 003D     TWIWrite(msg->buffer[i]);
	MOVW R30,R10
	LD   R26,Y
	LDD  R27,Y+1
	RCALL SUBOPT_0x10
	LD   R26,X
	RCALL _TWIWrite
; 0001 003E   }
	RCALL SUBOPT_0x11
	RJMP _0x20018
_0x20019:
; 0001 003F   TWIStop();
	RCALL _TWIStop
; 0001 0040 }
_0x2060006:
	ADIW R28,2
	RET
; .FEND
;
;void PN532_build_msg(TWI_BUFFER_STRUCT* buffer, TWI_BUFFER_STRUCT* msg)
; 0001 0043 {
_PN532_build_msg:
; .FSTART _PN532_build_msg
; 0001 0044   int msg_length = 0;
; 0001 0045   checksum = 0xD4;
	RCALL SUBOPT_0xC
	RCALL __SAVELOCR2
;	*buffer -> Y+4
;	*msg -> Y+2
;	msg_length -> R16,R17
	RCALL SUBOPT_0x6
	LDI  R30,LOW(212)
	MOV  R8,R30
; 0001 0046 
; 0001 0047   buffer->buffer[PN532_START]=0x00;                     ++msg_length;
	RCALL SUBOPT_0x12
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x13
; 0001 0048   buffer->buffer[PN532_START+1]=0xFF;                   ++msg_length;
	RCALL SUBOPT_0x12
	ADIW R26,1
	LDI  R30,LOW(255)
	RCALL SUBOPT_0x13
; 0001 0049   buffer->buffer[PN532_LEN]=msg->length+1;               ++msg_length;
	RCALL SUBOPT_0x14
	__PUTB1SNS 4,2
	RCALL SUBOPT_0x4
; 0001 004A   buffer->buffer[PN532_LCS]=(~(msg->length+1))+1;        ++msg_length;
	RCALL SUBOPT_0x14
	NEG  R30
	__PUTB1SNS 4,3
	RCALL SUBOPT_0x4
; 0001 004B   buffer->buffer[PN532_TFI]=0xD4;                       ++msg_length;
	RCALL SUBOPT_0x12
	ADIW R26,4
	LDI  R30,LOW(212)
	RCALL SUBOPT_0x13
; 0001 004C   for(i = 0; i<msg->length; ++i){
	RCALL SUBOPT_0xD
_0x2001B:
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0xF
	BRGE _0x2001C
; 0001 004D     buffer->buffer[PN532_DATA+i]=msg->buffer[i];              ++msg_length;
	MOVW R30,R10
	ADIW R30,5
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x16
	MOVW R0,R30
	RCALL SUBOPT_0x17
	MOVW R26,R0
	RCALL SUBOPT_0x13
; 0001 004E     checksum += msg->buffer[i];
	RCALL SUBOPT_0x17
	ADD  R8,R30
; 0001 004F   }
	RCALL SUBOPT_0x11
	RJMP _0x2001B
_0x2001C:
; 0001 0050   buffer->buffer[PN532_DATA+i]= (~(checksum&0xFF))+1;   ++msg_length;
	MOVW R30,R10
	ADIW R30,5
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x10
	MOV  R30,R8
	NEG  R30
	RCALL SUBOPT_0x13
; 0001 0051   buffer->length = msg_length;
	MOVW R30,R16
	__PUTW1SN 4,80
; 0001 0052 }
	RCALL __LOADLOCR2
	ADIW R28,6
	RET
; .FEND
;
;bool PN532_read(TWI_BUFFER_STRUCT* dest)
; 0001 0055 {
_PN532_read:
; .FSTART _PN532_read
; 0001 0056   unsigned char data = 0x00;
; 0001 0057   unsigned char len = 0x00;
; 0001 0058   // check ready bit
; 0001 0059   while(1){
	RCALL SUBOPT_0xC
	RCALL __SAVELOCR2
;	*dest -> Y+2
;	data -> R17
;	len -> R16
	LDI  R17,0
	LDI  R16,0
_0x2001D:
; 0001 005A     TWIStart();
	RCALL SUBOPT_0x18
; 0001 005B     TWIWrite(PN532_ADD | 1);
; 0001 005C     if(TWSR == 0x48) continue;
	BREQ _0x2001D
; 0001 005D     data = TWIRead(1);
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0x19
; 0001 005E     if(data==0x00) TWIStop();
	CPI  R17,0
	BRNE _0x20021
	RCALL _TWIStop
; 0001 005F     else if(data==0x01) break;
	RJMP _0x20022
_0x20021:
	CPI  R17,1
	BREQ _0x2001F
; 0001 0060   }
_0x20022:
	RJMP _0x2001D
_0x2001F:
; 0001 0061   // get rid of preamble
; 0001 0062   TWIRead(1);
	RCALL SUBOPT_0xB
	RCALL _TWIRead
; 0001 0063   //check start of packet
; 0001 0064   if((data=TWIRead(1))!=0x00) {TWIStop(); return false;}
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0x19
	CPI  R30,0
	BREQ _0x20024
	RCALL SUBOPT_0x1A
	RJMP _0x2060005
; 0001 0065   dest->buffer[len++]=data;
_0x20024:
	RCALL SUBOPT_0x1B
; 0001 0066   if((data=TWIRead(1))!=0xFF) {TWIStop(); return false;}
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0x19
	CPI  R30,LOW(0xFF)
	BREQ _0x20025
	RCALL SUBOPT_0x1A
	RJMP _0x2060005
; 0001 0067   dest->buffer[len++]=data;
_0x20025:
	RCALL SUBOPT_0x1B
; 0001 0068 
; 0001 0069   //get length
; 0001 006A   dest->buffer[len++]=TWIRead(1);
	RCALL SUBOPT_0x1C
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0xB
	RCALL _TWIRead
	POP  R26
	POP  R27
	ST   X,R30
; 0001 006B   //get length checksum
; 0001 006C   dest->buffer[len++]=TWIRead(1);
	RCALL SUBOPT_0x1C
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0xB
	RCALL _TWIRead
	POP  R26
	POP  R27
	ST   X,R30
; 0001 006D   //get TFI (should be D5)
; 0001 006E   dest->buffer[len++]=TWIRead(1);
	RCALL SUBOPT_0x1C
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0xB
	RCALL _TWIRead
	POP  R26
	POP  R27
	ST   X,R30
; 0001 006F 
; 0001 0070   for(i =0; i < dest->buffer[PN532_LEN]-1; ++i)
	RCALL SUBOPT_0xD
_0x20027:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	LDD  R30,Z+2
	SUBI R30,LOW(1)
	MOVW R26,R10
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x20028
; 0001 0071   {
; 0001 0072     dest->buffer[len++] = TWIRead(1);
	RCALL SUBOPT_0x1C
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0xB
	RCALL _TWIRead
	POP  R26
	POP  R27
	ST   X,R30
; 0001 0073   }
	RCALL SUBOPT_0x11
	RJMP _0x20027
_0x20028:
; 0001 0074 
; 0001 0075   //skip data checksum
; 0001 0076   dest->buffer[len++]=TWIRead(0);
	RCALL SUBOPT_0x1C
	PUSH R31
	PUSH R30
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _TWIRead
	POP  R26
	POP  R27
	ST   X,R30
; 0001 0077 
; 0001 0078   //set buffer length
; 0001 0079   dest->length = len;
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0xE
	MOV  R30,R16
	RCALL SUBOPT_0x1D
; 0001 007A 
; 0001 007B   //close comm
; 0001 007C   TWIStop();
	RCALL _TWIStop
; 0001 007D 
; 0001 007E   //return true on success
; 0001 007F   return true;
	LDI  R30,LOW(1)
_0x2060005:
	RCALL __LOADLOCR2
	ADIW R28,4
	RET
; 0001 0080 }
; .FEND
;
;void PN532_get_msg(TWI_BUFFER_STRUCT* src, TWI_BUFFER_STRUCT* dest, unsigned char offset)
; 0001 0083 {
_PN532_get_msg:
; .FSTART _PN532_get_msg
; 0001 0084   // exclude TFI from src, thus -1
; 0001 0085   dest->length = src->buffer[PN532_LEN]-1-offset;
	ST   -Y,R26
;	*src -> Y+3
;	*dest -> Y+1
;	offset -> Y+0
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	SUBI R30,LOW(-80)
	SBCI R31,HIGH(-80)
	MOVW R0,R30
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	LDD  R30,Z+2
	SUBI R30,LOW(1)
	LD   R26,Y
	SUB  R30,R26
	MOVW R26,R0
	RCALL SUBOPT_0x1D
; 0001 0086   for(i=0; i < dest->length; ++i)
	RCALL SUBOPT_0xD
_0x2002A:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0xF
	BRGE _0x2002B
; 0001 0087   {
; 0001 0088     dest->buffer[i] = src->buffer[PN532_DATA+i+offset];
	MOVW R30,R10
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	RCALL SUBOPT_0x16
	MOVW R0,R30
	MOVW R26,R10
	ADIW R26,5
	LD   R30,Y
	LDI  R31,0
	RCALL SUBOPT_0x16
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	RCALL SUBOPT_0x10
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
; 0001 0089   }
	RCALL SUBOPT_0x11
	RJMP _0x2002A
_0x2002B:
; 0001 008A }
	ADIW R28,5
	RET
; .FEND
;
;bool PN532_wait_for_ack(){
; 0001 008C _Bool PN532_wait_for_ack(){
_PN532_wait_for_ack:
; .FSTART _PN532_wait_for_ack
; 0001 008D   unsigned char data = 0x00;
; 0001 008E   // check ready bit
; 0001 008F   while(1){
	ST   -Y,R17
;	data -> R17
	LDI  R17,0
_0x2002C:
; 0001 0090     TWIStart();
	RCALL SUBOPT_0x18
; 0001 0091     TWIWrite(PN532_ADD | 1);
; 0001 0092 
; 0001 0093     // if NACK received, repeat data request
; 0001 0094     if(TWSR == 0x48) continue;
	BREQ _0x2002C
; 0001 0095     //TWIStart();
; 0001 0096     data = TWIRead(1);
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0x19
; 0001 0097     if(data==0x00) TWIStop();
	CPI  R17,0
	BRNE _0x20030
	RCALL _TWIStop
; 0001 0098     else if(data==0x01) break;
	RJMP _0x20031
_0x20030:
	CPI  R17,1
	BREQ _0x2002E
; 0001 0099   }
_0x20031:
	RJMP _0x2002C
_0x2002E:
; 0001 009A   // get rid of preamble
; 0001 009B   TWIRead(1);
	RCALL SUBOPT_0xB
	RCALL _TWIRead
; 0001 009C   //check start of packet
; 0001 009D   if(TWIRead(1)!=0x00) {TWIStop(); return false;}
	RCALL SUBOPT_0xB
	RCALL _TWIRead
	CPI  R30,0
	BREQ _0x20033
	RCALL SUBOPT_0x1A
	RJMP _0x2060004
; 0001 009E   if(TWIRead(1)!=0xFF) {TWIStop(); return false;}
_0x20033:
	RCALL SUBOPT_0xB
	RCALL _TWIRead
	CPI  R30,LOW(0xFF)
	BREQ _0x20034
	RCALL SUBOPT_0x1A
	RJMP _0x2060004
; 0001 009F 
; 0001 00A0   //check ack
; 0001 00A1   if(TWIRead(1)!=0x00) {TWIStop(); return false;}
_0x20034:
	RCALL SUBOPT_0xB
	RCALL _TWIRead
	CPI  R30,0
	BREQ _0x20035
	RCALL SUBOPT_0x1A
	RJMP _0x2060004
; 0001 00A2   if(TWIRead(0)!=0xFF) {TWIStop(); return false;}
_0x20035:
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _TWIRead
	CPI  R30,LOW(0xFF)
	BREQ _0x20036
	RCALL SUBOPT_0x1A
	RJMP _0x2060004
; 0001 00A3   TWIStop();
_0x20036:
	RCALL _TWIStop
; 0001 00A4   return true;
	LDI  R30,LOW(1)
_0x2060004:
	LD   R17,Y+
	RET
; 0001 00A5 }
; .FEND
;
;void PN532_get_firmware()
; 0001 00A8 {
_PN532_get_firmware:
; .FSTART _PN532_get_firmware
; 0001 00A9   PN532_msg.buffer[0]=PN532_CMD_GETFIRMWARE;
	LDI  R30,LOW(2)
	STS  _PN532_msg,R30
; 0001 00AA   PN532_msg.length=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RCALL SUBOPT_0x1E
; 0001 00AB   PN532_build_msg(&twi_tx, &PN532_msg);
; 0001 00AC   PN532_cmd(&twi_tx);
; 0001 00AD   TWIInit();
	RCALL _TWIInit
; 0001 00AE   while(!PN532_wait_for_ack());
_0x20037:
	RCALL _PN532_wait_for_ack
	CPI  R30,0
	BREQ _0x20037
; 0001 00AF   PN532_read(&twi_rx);
	RCALL SUBOPT_0x1F
; 0001 00B0   PN532_get_msg(&twi_rx, &PN532_msg, 1);
	LDI  R26,LOW(1)
	RCALL _PN532_get_msg
; 0001 00B1 }
	RET
; .FEND
;
;bool PN532_SAM_config()
; 0001 00B4 {
_PN532_SAM_config:
; .FSTART _PN532_SAM_config
; 0001 00B5   PN532_msg.buffer[0] = PN532_CMD_SAMCONFIGURATION;
	LDI  R30,LOW(20)
	RCALL SUBOPT_0x20
; 0001 00B6   PN532_msg.buffer[1] = 0x01; // normal mode;
; 0001 00B7   PN532_msg.buffer[2] = 0x14; // timeout 50ms * 20 = 1 second
	LDI  R30,LOW(20)
	__PUTB1MN _PN532_msg,2
; 0001 00B8   PN532_msg.buffer[3] = 0x00; // not using IRQ pin!
	LDI  R30,LOW(0)
	__PUTB1MN _PN532_msg,3
; 0001 00B9   PN532_msg.length=4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RCALL SUBOPT_0x1E
; 0001 00BA   PN532_build_msg(&twi_tx, &PN532_msg);
; 0001 00BB   PN532_cmd(&twi_tx);
; 0001 00BC   while(!PN532_wait_for_ack());
_0x2003A:
	RCALL _PN532_wait_for_ack
	CPI  R30,0
	BREQ _0x2003A
; 0001 00BD   PN532_read(&twi_rx);
	RCALL SUBOPT_0x1F
; 0001 00BE   PN532_get_msg(&twi_rx, &PN532_msg, 0);
	RCALL SUBOPT_0x21
; 0001 00BF   if(PN532_msg.buffer[0]==0x15) return true;
	CPI  R26,LOW(0x15)
	BREQ _0x2060002
; 0001 00C0   else return false;
	RJMP _0x2060003
; 0001 00C1 }
; .FEND
;
;bool PN532_read_uid()
; 0001 00C4 {
_PN532_read_uid:
; .FSTART _PN532_read_uid
; 0001 00C5   PN532_msg.buffer[0] = PN532_CMD_INLISTPASSIVETARGET;
	LDI  R30,LOW(74)
	RCALL SUBOPT_0x20
; 0001 00C6   PN532_msg.buffer[1] = 1;  // max 1 cards at once
; 0001 00C7   PN532_msg.buffer[2] = PN532_MIFARE_ISO14443A; //baudrate
	LDI  R30,LOW(0)
	__PUTB1MN _PN532_msg,2
; 0001 00C8   PN532_msg.length=3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RCALL SUBOPT_0x1E
; 0001 00C9   PN532_build_msg(&twi_tx, &PN532_msg);
; 0001 00CA   PN532_cmd(&twi_tx);
; 0001 00CB   while(!PN532_wait_for_ack());
_0x2003F:
	RCALL _PN532_wait_for_ack
	CPI  R30,0
	BREQ _0x2003F
; 0001 00CC   PN532_read(&twi_rx);
	RCALL SUBOPT_0x1F
; 0001 00CD   PN532_get_msg(&twi_rx, &PN532_msg, 0);
	RCALL SUBOPT_0x21
; 0001 00CE   if(PN532_msg.buffer[0] != PN532_CMD_INLISTPASSIVETARGET+1 || PN532_msg.buffer[1] < 1) return false;
	CPI  R26,LOW(0x4B)
	BRNE _0x20043
	__GETB2MN _PN532_msg,1
	CPI  R26,LOW(0x1)
	BRSH _0x20042
_0x20043:
_0x2060003:
	LDI  R30,LOW(0)
	RET
; 0001 00CF   tag_uid.length = PN532_msg.buffer[6];
_0x20042:
	__POINTW2MN _tag_uid,80
	__GETB1MN _PN532_msg,6
	RCALL SUBOPT_0x1D
; 0001 00D0   for(i = 0; i<tag_uid.length; ++i)
	RCALL SUBOPT_0xD
_0x20046:
	RCALL SUBOPT_0x7
	CP   R10,R30
	CPC  R11,R31
	BRGE _0x20047
; 0001 00D1   {
; 0001 00D2     tag_uid.buffer[i] = PN532_msg.buffer[7+i];
	MOVW R26,R10
	SUBI R26,LOW(-_tag_uid)
	SBCI R27,HIGH(-_tag_uid)
	MOVW R30,R10
	__ADDW1MN _PN532_msg,7
	LD   R30,Z
	ST   X,R30
; 0001 00D3   }
	RCALL SUBOPT_0x11
	RJMP _0x20046
_0x20047:
; 0001 00D4   return true;
_0x2060002:
	LDI  R30,LOW(1)
	RET
; 0001 00D5 }
; .FEND
;
;bool PN532_auth_tag(unsigned char block_number, unsigned char key_select, unsigned char* key_buffer)
; 0001 00D8 {
; 0001 00D9   PN532_read_uid();
;	block_number -> Y+3
;	key_select -> Y+2
;	*key_buffer -> Y+0
; 0001 00DA   PN532_msg.buffer[0] = PN532_CMD_INDATAEXCHANGE;
; 0001 00DB   PN532_msg.buffer[1] = 1;                              /* Max card numbers */
; 0001 00DC   PN532_msg.buffer[2] = (key_select) ? MIFARE_CMD_AUTH_B : MIFARE_CMD_AUTH_A;
; 0001 00DD   PN532_msg.buffer[3] = block_number;                    /* Block Number (1K = 0..63, 4K = 0..255 */
; 0001 00DE   for (i = 0; i < 6; ++i)
; 0001 00DF   {
; 0001 00E0     PN532_msg.buffer[4+i] = key_buffer[i];                /* 6 byte auth key */
; 0001 00E1   }
; 0001 00E2   for (i = 0; i < tag_uid.length; ++i)
; 0001 00E3   {
; 0001 00E4     PN532_msg.buffer[10+i] = tag_uid.buffer[i];                /* 4 byte card ID */
; 0001 00E5   }
; 0001 00E6   PN532_msg.length = 10+tag_uid.length;
; 0001 00E7 
; 0001 00E8   PN532_build_msg(&twi_tx, &PN532_msg);
; 0001 00E9   PN532_cmd(&twi_tx);
; 0001 00EA   while(!PN532_wait_for_ack());
; 0001 00EB   PN532_read(&twi_rx);
; 0001 00EC   PN532_get_msg(&twi_rx, &PN532_msg, 1);
; 0001 00ED   if(PN532_msg.buffer[0] != 0x00) return false;
; 0001 00EE   return true;
; 0001 00EF }
;
;bool PN532_read_passive_tag(unsigned char block_number)
; 0001 00F2 {
; 0001 00F3   if(!PN532_auth_tag(block_number, 0, MIFARE_Key_A)) return false;
;	block_number -> Y+0
; 0001 00F4   PN532_msg.buffer[0] = PN532_CMD_INDATAEXCHANGE;
; 0001 00F5   PN532_msg.buffer[1] = 1;                              /* Max card numbers */
; 0001 00F6   PN532_msg.buffer[2] = MIFARE_CMD_READ;
; 0001 00F7   PN532_msg.buffer[3] = block_number;                    /* Block Number (1K = 0..63, 4K = 0..255 */
; 0001 00F8   PN532_msg.length = 4;
; 0001 00F9 
; 0001 00FA   PN532_build_msg(&twi_tx, &PN532_msg);
; 0001 00FB   PN532_cmd(&twi_tx);
; 0001 00FC   while(!PN532_wait_for_ack());
; 0001 00FD   PN532_read(&twi_rx);
; 0001 00FE   PN532_get_msg(&twi_rx, &PN532_msg, 1);
; 0001 00FF   if(PN532_msg.buffer[0] != 0x00) return false;
; 0001 0100   PN532_get_msg(&twi_rx, &tag_data, 2);
; 0001 0101   return true;
; 0001 0102 }
;
;bool PN532_write_passive_tag(unsigned char block_number, TWI_BUFFER_STRUCT* data)
; 0001 0105 {
; 0001 0106   if(!PN532_auth_tag(block_number, 0, MIFARE_Key_A)) return false;
;	block_number -> Y+2
;	*data -> Y+0
; 0001 0107   PN532_msg.buffer[0] = PN532_CMD_INDATAEXCHANGE;
; 0001 0108   PN532_msg.buffer[1] = 1;                              /* Max card numbers */
; 0001 0109   PN532_msg.buffer[2] = MIFARE_CMD_WRITE;
; 0001 010A   PN532_msg.buffer[3] = block_number;                    /* Block Number (1K = 0..63, 4K = 0..255 */
; 0001 010B   for (i = 0; i < data->length && i < 16; ++i)
; 0001 010C   {
; 0001 010D     PN532_msg.buffer[4+i] = data->buffer[i];                /* 16 byte data */
; 0001 010E   }
; 0001 010F   PN532_msg.length = 4+i;
; 0001 0110 
; 0001 0111   PN532_build_msg(&twi_tx, &PN532_msg);
; 0001 0112   PN532_cmd(&twi_tx);
; 0001 0113   while(!PN532_wait_for_ack());
; 0001 0114   PN532_read(&twi_rx);
; 0001 0115   PN532_get_msg(&twi_rx, &PN532_msg, 1);
; 0001 0116   if(PN532_msg.buffer[0] != 0x00) return false;
; 0001 0117   PN532_get_msg(&twi_rx, &tag_data, 2);
; 0001 0118   return true;
; 0001 0119 }

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_putchar:
; .FSTART _putchar
	ST   -Y,R26
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
_0x2060001:
	ADIW R28,1
	RET
; .FEND

	.CSEG

	.DSEG
_twi_rx:
	.BYTE 0x52
_twi_tx:
	.BYTE 0x52
_PN532_msg:
	.BYTE 0x52
_tag_uid:
	.BYTE 0x52
_tag_data:
	.BYTE 0x52
_GTC_Buffer:
	.BYTE 0x40
_GTC_Gate_ID:
	.BYTE 0x2
_rx_buffer:
	.BYTE 0x80
_gtc_timeout:
	.BYTE 0x2
_MIFARE_Key_A:
	.BYTE 0x6

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(209)
	OUT  0x2D,R30
	LDI  R30,LOW(32)
	OUT  0x2C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1:
	RCALL _getchar
	MOV  R21,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	LDI  R20,LOW(0)
	RCALL _getchar
	MOV  R18,R30
	CLR  R19
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3:
	MOVW R30,R16
	SUBI R30,LOW(-_GTC_Buffer)
	SBCI R31,HIGH(-_GTC_Buffer)
	ST   Z,R21
	ADD  R20,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4:
	__ADDWRN 16,17,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5:
	LDS  R26,_GTC_Buffer
	CPI  R26,LOW(0xA1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	__GETW1MN _tag_uid,80
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x8:
	LDI  R26,LOW(_tag_uid)
	LDI  R27,HIGH(_tag_uid)
	ADD  R26,R16
	ADC  R27,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	CBI  0x15,1
	LDS  R30,_gtc_timeout
	LDS  R31,_gtc_timeout+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(0)
	STS  _GTC_Gate_ID,R30
	__PUTB1MN _GTC_Gate_ID,1
	CLR  R6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xB:
	LDI  R26,LOW(1)
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xD:
	CLR  R10
	CLR  R11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	SUBI R26,LOW(-80)
	SBCI R27,HIGH(-80)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xF:
	RCALL __GETW1P
	CP   R10,R30
	CPC  R11,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x10:
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x11:
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x12:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x13:
	ST   X,R30
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x14:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RCALL SUBOPT_0xE
	LD   R30,X
	SUBI R30,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x15:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x16:
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	MOVW R30,R10
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x10
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x18:
	RCALL _TWIStart
	LDI  R26,LOW(73)
	RCALL _TWIWrite
	IN   R30,0x1
	CPI  R30,LOW(0x48)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	RCALL _TWIRead
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1A:
	RCALL _TWIStop
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1B:
	MOV  R30,R16
	SUBI R16,-1
	RCALL SUBOPT_0x15
	LDI  R31,0
	RCALL SUBOPT_0x16
	ST   Z,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x1C:
	MOV  R30,R16
	SUBI R16,-1
	RCALL SUBOPT_0x15
	LDI  R31,0
	RJMP SUBOPT_0x16

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1D:
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x1E:
	__PUTW1MN _PN532_msg,80
	LDI  R30,LOW(_twi_tx)
	LDI  R31,HIGH(_twi_tx)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_PN532_msg)
	LDI  R27,HIGH(_PN532_msg)
	RCALL _PN532_build_msg
	LDI  R26,LOW(_twi_tx)
	LDI  R27,HIGH(_twi_tx)
	RJMP _PN532_cmd

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x1F:
	LDI  R26,LOW(_twi_rx)
	LDI  R27,HIGH(_twi_rx)
	RCALL _PN532_read
	LDI  R30,LOW(_twi_rx)
	LDI  R31,HIGH(_twi_rx)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_PN532_msg)
	LDI  R31,HIGH(_PN532_msg)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x20:
	STS  _PN532_msg,R30
	LDI  R30,LOW(1)
	__PUTB1MN _PN532_msg,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	LDI  R26,LOW(0)
	RCALL _PN532_get_msg
	LDS  R26,_PN532_msg
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xBB8
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
