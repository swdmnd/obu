
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega8
;Program type           : Application
;Clock frequency        : 12.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega8
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
	.DEF _checksum=R6
	.DEF _i=R8
	.DEF _i_msb=R9
	.DEF __lcd_x=R11
	.DEF __lcd_y=R10
	.DEF __lcd_maxx=R13

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
	RJMP 0x00
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

_tbl10_G102:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G102:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0

_0xA:
	.DB  0x4D,0x2E,0x20,0x41,0x52,0x49,0x45,0x46
	.DB  0x20,0x46,0x2E,0x2E,0x2E,0x2E,0x2E,0x2E
_0x0:
	.DB  0x25,0x30,0x32,0x78,0x0
_0x20003:
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
_0x2020003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x04
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x06
	.DW  _MIFARE_Key_A
	.DW  _0x20003*2

	.DW  0x02
	.DW  __base_y_G101
	.DW  _0x2020003*2

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
;// Alphanumeric LCD functions
;#include <alcd.h>
;
;// Declare your global variables here
;
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE         (1<<RXC)
;#define FRAMING_ERROR       (1<<FE)
;#define PARITY_ERROR        (1<<UPE)
;#define DATA_OVERRUN        (1<<DOR)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 8
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
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 0026 {

	.CSEG
_usart_rx_isr:
; .FSTART _usart_rx_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0027 char status,data;
; 0000 0028 status=UCSRA;
	RCALL __SAVELOCR2
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0029 data=UDR;
	IN   R16,12
; 0000 002A if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x3
; 0000 002B    {
; 0000 002C    rx_buffer[rx_wr_index++]=data;
	MOV  R30,R5
	INC  R5
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 002D #if RX_BUFFER_SIZE == 256
; 0000 002E    // special case for receiver buffer size=256
; 0000 002F    if (++rx_counter == 0) rx_buffer_overflow=1;
; 0000 0030 #else
; 0000 0031    if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDI  R30,LOW(8)
	CP   R30,R5
	BRNE _0x4
	CLR  R5
; 0000 0032    if (++rx_counter == RX_BUFFER_SIZE)
_0x4:
	INC  R7
	LDI  R30,LOW(8)
	CP   R30,R7
	BRNE _0x5
; 0000 0033       {
; 0000 0034       rx_counter=0;
	CLR  R7
; 0000 0035       rx_buffer_overflow=1;
	SET
	BLD  R2,0
; 0000 0036       }
; 0000 0037 #endif
; 0000 0038    }
_0x5:
; 0000 0039 }
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
; 0000 0040 {
; 0000 0041 char data;
; 0000 0042 while (rx_counter==0);
;	data -> R17
; 0000 0043 data=rx_buffer[rx_rd_index++];
; 0000 0044 #if RX_BUFFER_SIZE != 256
; 0000 0045 if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
; 0000 0046 #endif
; 0000 0047 #asm("cli")
; 0000 0048 --rx_counter;
; 0000 0049 #asm("sei")
; 0000 004A return data;
; 0000 004B }
;#pragma used-
;#endif
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;// Global variables
;
;void main(void)
; 0000 0055 {
_main:
; .FSTART _main
; 0000 0056 // Declare your local variables here
; 0000 0057 int i;
; 0000 0058 unsigned char write_data[] = {'M', '.', ' ', 'A', 'R', 'I', 'E', 'F', ' ', 'F', '.', '.', '.', '.', '.', '.'};
; 0000 0059 
; 0000 005A // Input/Output Ports initialization
; 0000 005B // Port B initialization
; 0000 005C // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 005D DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	SBIW R28,16
	LDI  R24,16
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0xA*2)
	LDI  R31,HIGH(_0xA*2)
	RCALL __INITLOCB
;	i -> R16,R17
;	write_data -> Y+0
	LDI  R30,LOW(0)
	OUT  0x17,R30
; 0000 005E // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 005F PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (1<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(2)
	OUT  0x18,R30
; 0000 0060 
; 0000 0061 // Port C initialization
; 0000 0062 // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0063 DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(0)
	OUT  0x14,R30
; 0000 0064 // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0065 PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 0066 
; 0000 0067 // Port D initialization
; 0000 0068 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=In Bit1=In Bit0=In
; 0000 0069 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (1<<DDD3) | (1<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(12)
	OUT  0x11,R30
; 0000 006A // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=1 Bit2=T Bit1=T Bit0=T
; 0000 006B PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (1<<PORTD3) | (1<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 006C 
; 0000 006D // Timer/Counter 0 initialization
; 0000 006E // Clock source: System Clock
; 0000 006F // Clock value: Timer 0 Stopped
; 0000 0070 TCCR0=(0<<CS02) | (0<<CS01) | (0<<CS00);
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 0071 TCNT0=0x00;
	OUT  0x32,R30
; 0000 0072 
; 0000 0073 // Timer/Counter 1 initialization
; 0000 0074 // Clock source: System Clock
; 0000 0075 // Clock value: Timer1 Stopped
; 0000 0076 // Mode: Normal top=0xFFFF
; 0000 0077 // OC1A output: Disconnected
; 0000 0078 // OC1B output: Disconnected
; 0000 0079 // Noise Canceler: Off
; 0000 007A // Input Capture on Falling Edge
; 0000 007B // Timer1 Overflow Interrupt: Off
; 0000 007C // Input Capture Interrupt: Off
; 0000 007D // Compare A Match Interrupt: Off
; 0000 007E // Compare B Match Interrupt: Off
; 0000 007F TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 0080 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 0081 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0082 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0083 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0084 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0085 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0086 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0087 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0088 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0089 
; 0000 008A // Timer/Counter 2 initialization
; 0000 008B // Clock source: System Clock
; 0000 008C // Clock value: Timer2 Stopped
; 0000 008D // Mode: Normal top=0xFF
; 0000 008E // OC2 output: Disconnected
; 0000 008F ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0090 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 0091 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0092 OCR2=0x00;
	OUT  0x23,R30
; 0000 0093 
; 0000 0094 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0095 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 0096 
; 0000 0097 // External Interrupt(s) initialization
; 0000 0098 // INT0: Off
; 0000 0099 // INT1: Off
; 0000 009A MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 009B 
; 0000 009C // USART initialization
; 0000 009D // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 009E // USART Receiver: On
; 0000 009F // USART Transmitter: On
; 0000 00A0 // USART Mode: Asynchronous
; 0000 00A1 // USART Baud Rate: 9600
; 0000 00A2 UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	OUT  0xB,R30
; 0000 00A3 UCSRB=(1<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0000 00A4 //UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
; 0000 00A5 UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 00A6 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 00A7 UBRRL=0x4D;
	LDI  R30,LOW(77)
	OUT  0x9,R30
; 0000 00A8 
; 0000 00A9 // Analog Comparator initialization
; 0000 00AA // Analog Comparator: Off
; 0000 00AB // The Analog Comparator's positive input is
; 0000 00AC // connected to the AIN0 pin
; 0000 00AD // The Analog Comparator's negative input is
; 0000 00AE // connected to the AIN1 pin
; 0000 00AF ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00B0 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00B1 
; 0000 00B2 // ADC initialization
; 0000 00B3 // ADC disabled
; 0000 00B4 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 00B5 
; 0000 00B6 // SPI initialization
; 0000 00B7 // SPI disabled
; 0000 00B8 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 00B9 
; 0000 00BA // TWI initialization
; 0000 00BB // Mode: TWI Master
; 0000 00BC // Bit Rate: 400 kHz
; 0000 00BD //twi_master_init(400);
; 0000 00BE TWIInit();
	RCALL _TWIInit
; 0000 00BF 
; 0000 00C0 // Alphanumeric LCD initialization
; 0000 00C1 // Connections are specified in the
; 0000 00C2 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 00C3 // RS - PORTD Bit 6
; 0000 00C4 // RD - PORTD Bit 5
; 0000 00C5 // EN - PORTD Bit 4
; 0000 00C6 // D4 - PORTC Bit 3
; 0000 00C7 // D5 - PORTC Bit 2
; 0000 00C8 // D6 - PORTC Bit 1
; 0000 00C9 // D7 - PORTC Bit 0
; 0000 00CA // Characters/line: 16
; 0000 00CB lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 00CC 
; 0000 00CD // Global enable interrupts
; 0000 00CE #asm("sei")
	sei
; 0000 00CF //printf("starting");
; 0000 00D0 delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 00D1 //PN532_begin();
; 0000 00D2 //putchar(255);
; 0000 00D3 PN532_SAM_config();
	RCALL _PN532_SAM_config
; 0000 00D4 PN532_get_firmware();
	RCALL _PN532_get_firmware
; 0000 00D5 //tag_data.length = 16;
; 0000 00D6 //memcpy(tag_data.buffer, write_data, 16);
; 0000 00D7 //PN532_write_passive_tag(5, &tag_data);
; 0000 00D8 
; 0000 00D9 while (1)
_0xB:
; 0000 00DA       {
; 0000 00DB       // Place your code here
; 0000 00DC //        PN532_read_passive_tag(4);
; 0000 00DD //        for(i = 0; i<tag_data.length; ++i)
; 0000 00DE //        {
; 0000 00DF //          putchar(tag_data.buffer[i]);
; 0000 00E0 //        }
; 0000 00E1         //PN532_read_uid();
; 0000 00E2         PN532_read_passive_tag(4);
	LDI  R26,LOW(4)
	RCALL _PN532_read_passive_tag
; 0000 00E3         for(i = 0; i<tag_uid.length; ++i)
	__GETWRN 16,17,0
_0xF:
	RCALL SUBOPT_0x0
	CP   R16,R30
	CPC  R17,R31
	BRGE _0x10
; 0000 00E4         {
; 0000 00E5           printf("%02x", tag_uid.buffer[i]);
	__POINTW1FN _0x0,0
	RCALL SUBOPT_0x1
	LDI  R26,LOW(_tag_uid)
	LDI  R27,HIGH(_tag_uid)
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _printf
	ADIW R28,6
; 0000 00E6         }
	RCALL SUBOPT_0x2
	RJMP _0xF
_0x10:
; 0000 00E7         delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
; 0000 00E8       }
	RJMP _0xB
; 0000 00E9 }
_0x11:
	RJMP _0x11
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
; 0001 000E {

	.CSEG
_TWIInit:
; .FSTART _TWIInit
; 0001 000F     //set SCL to 100kHz
; 0001 0010     TWSR = 0x00;
	LDI  R30,LOW(0)
	OUT  0x1,R30
; 0001 0011     TWBR = 7;   //347,826
	LDI  R30,LOW(7)
	OUT  0x0,R30
; 0001 0012     //enable TWI
; 0001 0013     TWCR = (1<<TWEN);
	LDI  R30,LOW(4)
	RJMP _0x2080005
; 0001 0014 }
; .FEND
;
;void TWIStart(void)
; 0001 0017 {
_TWIStart:
; .FSTART _TWIStart
; 0001 0018     TWCR = (1<<TWINT)|(1<<TWSTA)|(1<<TWEN);
	LDI  R30,LOW(164)
	OUT  0x36,R30
; 0001 0019     while ((TWCR & (1<<TWINT)) == 0);
_0x20004:
	IN   R30,0x36
	SBRS R30,7
	RJMP _0x20004
; 0001 001A }
	RET
; .FEND
;
;void TWIStop(void)
; 0001 001D {
_TWIStop:
; .FSTART _TWIStop
; 0001 001E     TWCR = (1<<TWINT)|(1<<TWSTO)|(1<<TWEN);
	LDI  R30,LOW(148)
_0x2080005:
	OUT  0x36,R30
; 0001 001F }
	RET
; .FEND
;
;void TWIWrite(unsigned char u8data)
; 0001 0022 {
_TWIWrite:
; .FSTART _TWIWrite
; 0001 0023     TWDR = u8data;
	ST   -Y,R26
;	u8data -> Y+0
	LD   R30,Y
	OUT  0x3,R30
; 0001 0024     TWCR = (1<<TWINT)|(1<<TWEN);
	LDI  R30,LOW(132)
	OUT  0x36,R30
; 0001 0025     while ((TWCR & (1<<TWINT)) == 0);
_0x20007:
	IN   R30,0x36
	SBRS R30,7
	RJMP _0x20007
; 0001 0026 }
	RJMP _0x2080001
; .FEND
;
;//read byte with ACK (Set TWEA, clear TWEA to send NACK, indicating master receiver has read the last byte)
;unsigned char TWIRead(int ack)
; 0001 002A {
_TWIRead:
; .FSTART _TWIRead
; 0001 002B     TWCR = (1<<TWINT)|(1<<TWEN)|(ack<<TWEA);
	RCALL SUBOPT_0x3
;	ack -> Y+0
	LD   R30,Y
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	LSL  R30
	ORI  R30,LOW(0x84)
	OUT  0x36,R30
; 0001 002C     while ((TWCR & (1<<TWINT)) == 0);
_0x2000A:
	IN   R30,0x36
	SBRS R30,7
	RJMP _0x2000A
; 0001 002D     return TWDR;
	IN   R30,0x3
	RJMP _0x2080004
; 0001 002E }
; .FEND
;
;void PN532_cmd(TWI_BUFFER_STRUCT* msg)
; 0001 0031 {
_PN532_cmd:
; .FSTART _PN532_cmd
; 0001 0032   TWIStart();
	RCALL SUBOPT_0x3
;	*msg -> Y+0
	RCALL _TWIStart
; 0001 0033   TWIWrite(PN532_ADD);
	LDI  R26,LOW(72)
	RCALL _TWIWrite
; 0001 0034   for(i = 0; i < msg->length; ++i){
	RCALL SUBOPT_0x4
_0x2000E:
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x7
	BRGE _0x2000F
; 0001 0035     TWIWrite(msg->buffer[i]);
	RCALL SUBOPT_0x8
	LD   R26,X
	RCALL _TWIWrite
; 0001 0036   }
	RCALL SUBOPT_0x9
	RJMP _0x2000E
_0x2000F:
; 0001 0037   TWIStop();
	RCALL _TWIStop
; 0001 0038 }
_0x2080004:
	ADIW R28,2
	RET
; .FEND
;
;void PN532_build_msg(TWI_BUFFER_STRUCT* buffer, TWI_BUFFER_STRUCT* msg)
; 0001 003B {
_PN532_build_msg:
; .FSTART _PN532_build_msg
; 0001 003C   int msg_length = 0;
; 0001 003D   checksum = 0xD4;
	RCALL SUBOPT_0x3
	RCALL __SAVELOCR2
;	*buffer -> Y+4
;	*msg -> Y+2
;	msg_length -> R16,R17
	__GETWRN 16,17,0
	LDI  R30,LOW(212)
	MOV  R6,R30
; 0001 003E 
; 0001 003F   buffer->buffer[PN532_START]=0x00;                     ++msg_length;
	RCALL SUBOPT_0xA
	LDI  R30,LOW(0)
	RCALL SUBOPT_0xB
; 0001 0040   buffer->buffer[PN532_START+1]=0xFF;                   ++msg_length;
	RCALL SUBOPT_0xA
	ADIW R26,1
	LDI  R30,LOW(255)
	RCALL SUBOPT_0xB
; 0001 0041   buffer->buffer[PN532_LEN]=msg->length+1;               ++msg_length;
	RCALL SUBOPT_0xC
	__PUTB1SNS 4,2
	RCALL SUBOPT_0x2
; 0001 0042   buffer->buffer[PN532_LCS]=(~(msg->length+1))+1;        ++msg_length;
	RCALL SUBOPT_0xC
	NEG  R30
	__PUTB1SNS 4,3
	RCALL SUBOPT_0x2
; 0001 0043   buffer->buffer[PN532_TFI]=0xD4;                       ++msg_length;
	RCALL SUBOPT_0xA
	ADIW R26,4
	LDI  R30,LOW(212)
	RCALL SUBOPT_0xB
; 0001 0044   for(i = 0; i<msg->length; ++i){
	RCALL SUBOPT_0x4
_0x20011:
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x7
	BRGE _0x20012
; 0001 0045     buffer->buffer[PN532_DATA+i]=msg->buffer[i];              ++msg_length;
	MOVW R30,R8
	ADIW R30,5
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xE
	MOVW R0,R30
	RCALL SUBOPT_0xF
	MOVW R26,R0
	RCALL SUBOPT_0xB
; 0001 0046     checksum += msg->buffer[i];
	RCALL SUBOPT_0xF
	ADD  R6,R30
; 0001 0047   }
	RCALL SUBOPT_0x9
	RJMP _0x20011
_0x20012:
; 0001 0048   buffer->buffer[PN532_DATA+i]= (~(checksum&0xFF))+1;   ++msg_length;
	MOVW R30,R8
	ADIW R30,5
	RCALL SUBOPT_0xA
	ADD  R26,R30
	ADC  R27,R31
	MOV  R30,R6
	NEG  R30
	RCALL SUBOPT_0xB
; 0001 0049   buffer->length = msg_length;
	MOVW R30,R16
	__PUTW1SN 4,80
; 0001 004A }
	RCALL __LOADLOCR2
	ADIW R28,6
	RET
; .FEND
;
;bool PN532_read(TWI_BUFFER_STRUCT* dest)
; 0001 004D {
_PN532_read:
; .FSTART _PN532_read
; 0001 004E   unsigned char data = 0x00;
; 0001 004F   unsigned char len = 0x00;
; 0001 0050   // check ready bit
; 0001 0051   while(1){
	RCALL SUBOPT_0x3
	RCALL __SAVELOCR2
;	*dest -> Y+2
;	data -> R17
;	len -> R16
	LDI  R17,0
	LDI  R16,0
_0x20013:
; 0001 0052     TWIStart();
	RCALL SUBOPT_0x10
; 0001 0053     TWIWrite(PN532_ADD | 1);
; 0001 0054     data = TWIRead(1);
; 0001 0055     if(data==0x00) TWIStop();
	BRNE _0x20016
	RCALL _TWIStop
; 0001 0056     else if(data==0x01) break;
	RJMP _0x20017
_0x20016:
	CPI  R17,1
	BREQ _0x20015
; 0001 0057   }
_0x20017:
	RJMP _0x20013
_0x20015:
; 0001 0058   // get rid of preamble
; 0001 0059   TWIRead(1);
	RCALL SUBOPT_0x11
; 0001 005A   //check start of packet
; 0001 005B   if((data=TWIRead(1))!=0x00) {TWIStop(); return false;}
	RCALL SUBOPT_0x11
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x20019
	RCALL _TWIStop
	LDI  R30,LOW(0)
	RCALL __LOADLOCR2
	RJMP _0x2080002
; 0001 005C   dest->buffer[len++]=data;
_0x20019:
	RCALL SUBOPT_0x12
; 0001 005D   if((data=TWIRead(1))!=0xFF) {TWIStop(); return false;}
	RCALL SUBOPT_0x11
	MOV  R17,R30
	CPI  R30,LOW(0xFF)
	BREQ _0x2001A
	RCALL SUBOPT_0x13
	RCALL __LOADLOCR2
	RJMP _0x2080002
; 0001 005E   dest->buffer[len++]=data;
_0x2001A:
	RCALL SUBOPT_0x12
; 0001 005F 
; 0001 0060   //get length
; 0001 0061   dest->buffer[len++]=TWIRead(1);
	RCALL SUBOPT_0x14
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x11
	POP  R26
	POP  R27
	ST   X,R30
; 0001 0062   //get length checksum
; 0001 0063   dest->buffer[len++]=TWIRead(1);
	RCALL SUBOPT_0x14
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x11
	POP  R26
	POP  R27
	ST   X,R30
; 0001 0064   //get TFI (should be D5)
; 0001 0065   dest->buffer[len++]=TWIRead(1);
	RCALL SUBOPT_0x14
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x11
	POP  R26
	POP  R27
	ST   X,R30
; 0001 0066 
; 0001 0067   for(i =0; i < dest->buffer[PN532_LEN]-1; ++i)
	RCALL SUBOPT_0x4
_0x2001C:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	LDD  R30,Z+2
	LDI  R31,0
	SBIW R30,1
	RCALL SUBOPT_0x15
	BRGE _0x2001D
; 0001 0068   {
; 0001 0069     dest->buffer[len++] = TWIRead(1);
	RCALL SUBOPT_0x14
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x11
	POP  R26
	POP  R27
	ST   X,R30
; 0001 006A   }
	RCALL SUBOPT_0x9
	RJMP _0x2001C
_0x2001D:
; 0001 006B 
; 0001 006C   //skip data checksum
; 0001 006D   dest->buffer[len++]=TWIRead(0);
	RCALL SUBOPT_0x14
	PUSH R31
	PUSH R30
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _TWIRead
	POP  R26
	POP  R27
	ST   X,R30
; 0001 006E 
; 0001 006F   //set buffer length
; 0001 0070   dest->length = len;
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x6
	MOV  R30,R16
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
; 0001 0071 
; 0001 0072   //close comm
; 0001 0073   TWIStop();
	RCALL _TWIStop
; 0001 0074 
; 0001 0075   //return true on success
; 0001 0076   return true;
	LDI  R30,LOW(1)
	RCALL __LOADLOCR2
	RJMP _0x2080002
; 0001 0077 }
; .FEND
;
;void PN532_get_msg(TWI_BUFFER_STRUCT* src, TWI_BUFFER_STRUCT* dest, unsigned char offset)
; 0001 007A {
_PN532_get_msg:
; .FSTART _PN532_get_msg
; 0001 007B   // exclude TFI from src, thus -1
; 0001 007C   dest->length = src->buffer[PN532_LEN]-1-offset;
	ST   -Y,R26
;	*src -> Y+3
;	*dest -> Y+1
;	offset -> Y+0
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	LDD  R30,Z+2
	LDI  R31,0
	SBIW R30,1
	MOVW R26,R30
	LD   R30,Y
	LDI  R31,0
	RCALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	__PUTW1SN 1,80
; 0001 007D   for(i=0; i < dest->length; ++i)
	RCALL SUBOPT_0x4
_0x2001F:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x7
	BRGE _0x20020
; 0001 007E   {
; 0001 007F     dest->buffer[i] = src->buffer[PN532_DATA+i+offset];
	MOVW R30,R8
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	RCALL SUBOPT_0xE
	MOVW R0,R30
	MOVW R26,R8
	ADIW R26,5
	LD   R30,Y
	LDI  R31,0
	RCALL SUBOPT_0xE
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	ADD  R26,R30
	ADC  R27,R31
	RCALL SUBOPT_0x16
; 0001 0080   }
	RCALL SUBOPT_0x9
	RJMP _0x2001F
_0x20020:
; 0001 0081 }
	ADIW R28,5
	RET
; .FEND
;
;bool PN532_wait_for_ack(){
; 0001 0083 _Bool PN532_wait_for_ack(){
_PN532_wait_for_ack:
; .FSTART _PN532_wait_for_ack
; 0001 0084   unsigned char data = 0x00;
; 0001 0085   // check ready bit
; 0001 0086   while(1){
	ST   -Y,R17
;	data -> R17
	LDI  R17,0
_0x20021:
; 0001 0087     TWIStart();
	RCALL SUBOPT_0x10
; 0001 0088     TWIWrite(PN532_ADD | 1);
; 0001 0089     //TWIStart();
; 0001 008A     data = TWIRead(1);
; 0001 008B     if(data==0x00) TWIStop();
	BRNE _0x20024
	RCALL _TWIStop
; 0001 008C     else if(data==0x01) break;
	RJMP _0x20025
_0x20024:
	CPI  R17,1
	BREQ _0x20023
; 0001 008D   }
_0x20025:
	RJMP _0x20021
_0x20023:
; 0001 008E   // get rid of preamble
; 0001 008F   TWIRead(1);
	RCALL SUBOPT_0x11
; 0001 0090   //check start of packet
; 0001 0091   if(TWIRead(1)!=0x00) {TWIStop(); return false;}
	RCALL SUBOPT_0x11
	CPI  R30,0
	BREQ _0x20027
	RCALL SUBOPT_0x13
	RJMP _0x2080003
; 0001 0092   if(TWIRead(1)!=0xFF) {TWIStop(); return false;}
_0x20027:
	RCALL SUBOPT_0x11
	CPI  R30,LOW(0xFF)
	BREQ _0x20028
	RCALL SUBOPT_0x13
	RJMP _0x2080003
; 0001 0093 
; 0001 0094   //check ack
; 0001 0095   if(TWIRead(1)!=0x00) {TWIStop(); return false;}
_0x20028:
	RCALL SUBOPT_0x11
	CPI  R30,0
	BREQ _0x20029
	RCALL SUBOPT_0x13
	RJMP _0x2080003
; 0001 0096   if(TWIRead(0)!=0xFF) {TWIStop(); return false;}
_0x20029:
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _TWIRead
	CPI  R30,LOW(0xFF)
	BREQ _0x2002A
	RCALL SUBOPT_0x13
	RJMP _0x2080003
; 0001 0097   TWIStop();
_0x2002A:
	RCALL _TWIStop
; 0001 0098   return true;
	LDI  R30,LOW(1)
_0x2080003:
	LD   R17,Y+
	RET
; 0001 0099 }
; .FEND
;
;void PN532_get_firmware()
; 0001 009C {
_PN532_get_firmware:
; .FSTART _PN532_get_firmware
; 0001 009D   PN532_msg.buffer[0]=PN532_CMD_GETFIRMWARE;
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x17
; 0001 009E   PN532_msg.length=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RCALL SUBOPT_0x18
; 0001 009F   PN532_build_msg(&twi_tx, &PN532_msg);
; 0001 00A0   PN532_cmd(&twi_tx);
; 0001 00A1   delay_ms(20);
; 0001 00A2   while(!PN532_wait_for_ack()) delay_ms(20);
_0x2002B:
	RCALL SUBOPT_0x19
	BRNE _0x2002D
	RCALL SUBOPT_0x1A
	RJMP _0x2002B
_0x2002D:
; 0001 00A3 delay_ms(20);
	RCALL SUBOPT_0x1A
; 0001 00A4   PN532_read(&twi_rx);
	RCALL SUBOPT_0x1B
; 0001 00A5   PN532_get_msg(&twi_rx, &PN532_msg, 1);
	RCALL SUBOPT_0x1C
; 0001 00A6 }
	RET
; .FEND
;
;bool PN532_SAM_config()
; 0001 00A9 {
_PN532_SAM_config:
; .FSTART _PN532_SAM_config
; 0001 00AA   PN532_msg.buffer[0] = PN532_CMD_SAMCONFIGURATION;
	LDI  R30,LOW(20)
	RCALL SUBOPT_0x1D
; 0001 00AB   PN532_msg.buffer[1] = 0x01; // normal mode;
; 0001 00AC   PN532_msg.buffer[2] = 0x14; // timeout 50ms * 20 = 1 second
	LDI  R30,LOW(20)
	RCALL SUBOPT_0x1E
; 0001 00AD   PN532_msg.buffer[3] = 0x00; // not using IRQ pin!
	LDI  R30,LOW(0)
	__PUTB1MN _PN532_msg,3
; 0001 00AE   PN532_msg.length=4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RCALL SUBOPT_0x18
; 0001 00AF   PN532_build_msg(&twi_tx, &PN532_msg);
; 0001 00B0   PN532_cmd(&twi_tx);
; 0001 00B1   delay_ms(20);
; 0001 00B2   while(!PN532_wait_for_ack()) delay_ms(20);
_0x2002E:
	RCALL SUBOPT_0x19
	BRNE _0x20030
	RCALL SUBOPT_0x1A
	RJMP _0x2002E
_0x20030:
; 0001 00B3 delay_ms(20);
	RCALL SUBOPT_0x1A
; 0001 00B4   PN532_read(&twi_rx);
	RCALL SUBOPT_0x1B
; 0001 00B5   PN532_get_msg(&twi_rx, &PN532_msg, 0);
	LDI  R26,LOW(0)
	RCALL _PN532_get_msg
; 0001 00B6   if(PN532_msg.buffer[0]==0x15) return true;
	LDS  R26,_PN532_msg
	CPI  R26,LOW(0x15)
	BRNE _0x20031
	LDI  R30,LOW(1)
	RET
; 0001 00B7   else return false;
_0x20031:
	LDI  R30,LOW(0)
	RET
; 0001 00B8 }
	RET
; .FEND
;
;void PN532_read_uid()
; 0001 00BB {
_PN532_read_uid:
; .FSTART _PN532_read_uid
; 0001 00BC   PN532_msg.buffer[0] = PN532_CMD_INLISTPASSIVETARGET;
	LDI  R30,LOW(74)
	RCALL SUBOPT_0x1D
; 0001 00BD   PN532_msg.buffer[1] = 1;  // max 1 cards at once
; 0001 00BE   PN532_msg.buffer[2] = PN532_MIFARE_ISO14443A; //baudrate
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x1E
; 0001 00BF   PN532_msg.length=3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RCALL SUBOPT_0x18
; 0001 00C0   PN532_build_msg(&twi_tx, &PN532_msg);
; 0001 00C1   PN532_cmd(&twi_tx);
; 0001 00C2   delay_ms(20);
; 0001 00C3   while(!PN532_wait_for_ack()) delay_ms(20);
_0x20033:
	RCALL SUBOPT_0x19
	BRNE _0x20035
	RCALL SUBOPT_0x1A
	RJMP _0x20033
_0x20035:
; 0001 00C4 delay_ms(20);
	RCALL SUBOPT_0x1A
; 0001 00C5   PN532_read(&twi_rx);
	RCALL SUBOPT_0x1B
; 0001 00C6   PN532_get_msg(&twi_rx, &PN532_msg, 1);
	RCALL SUBOPT_0x1C
; 0001 00C7   tag_uid.length = PN532_msg.buffer[5];
	__POINTW2MN _tag_uid,80
	__GETB1MN _PN532_msg,5
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
; 0001 00C8   for(i = 0; i<tag_uid.length; ++i)
	RCALL SUBOPT_0x4
_0x20037:
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x15
	BRGE _0x20038
; 0001 00C9   {
; 0001 00CA     tag_uid.buffer[i] = PN532_msg.buffer[6+i];
	MOVW R26,R8
	SUBI R26,LOW(-_tag_uid)
	SBCI R27,HIGH(-_tag_uid)
	MOVW R30,R8
	__ADDW1MN _PN532_msg,6
	LD   R30,Z
	ST   X,R30
; 0001 00CB   }
	RCALL SUBOPT_0x9
	RJMP _0x20037
_0x20038:
; 0001 00CC }
	RET
; .FEND
;
;bool PN532_auth_tag(unsigned char block_number, unsigned char key_select, unsigned char* key_buffer)
; 0001 00CF {
_PN532_auth_tag:
; .FSTART _PN532_auth_tag
; 0001 00D0   PN532_read_uid();
	RCALL SUBOPT_0x3
;	block_number -> Y+3
;	key_select -> Y+2
;	*key_buffer -> Y+0
	RCALL _PN532_read_uid
; 0001 00D1   PN532_msg.buffer[0] = PN532_CMD_INDATAEXCHANGE;
	LDI  R30,LOW(64)
	RCALL SUBOPT_0x1D
; 0001 00D2   PN532_msg.buffer[1] = 1;                              /* Max card numbers */
; 0001 00D3   PN532_msg.buffer[2] = (key_select) ? MIFARE_CMD_AUTH_B : MIFARE_CMD_AUTH_A;
	LDD  R30,Y+2
	CPI  R30,0
	BREQ _0x20039
	LDI  R30,LOW(97)
	RJMP _0x2003A
_0x20039:
	LDI  R30,LOW(96)
_0x2003A:
	RCALL SUBOPT_0x1E
; 0001 00D4   PN532_msg.buffer[3] = block_number;                    /* Block Number (1K = 0..63, 4K = 0..255 */
	LDD  R30,Y+3
	__PUTB1MN _PN532_msg,3
; 0001 00D5   for (i = 0; i < 6; ++i)
	RCALL SUBOPT_0x4
_0x2003D:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	RCALL SUBOPT_0x15
	BRGE _0x2003E
; 0001 00D6   {
; 0001 00D7     PN532_msg.buffer[4+i] = key_buffer[i];                /* 6 byte auth key */
	MOVW R30,R8
	__ADDW1MN _PN532_msg,4
	MOVW R0,R30
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x16
; 0001 00D8   }
	RCALL SUBOPT_0x9
	RJMP _0x2003D
_0x2003E:
; 0001 00D9   for (i = 0; i < tag_uid.length; ++i)
	RCALL SUBOPT_0x4
_0x20040:
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x15
	BRGE _0x20041
; 0001 00DA   {
; 0001 00DB     PN532_msg.buffer[10+i] = tag_uid.buffer[i];                /* 4 byte card ID */
	MOVW R30,R8
	__ADDW1MN _PN532_msg,10
	MOVW R0,R30
	LDI  R26,LOW(_tag_uid)
	LDI  R27,HIGH(_tag_uid)
	ADD  R26,R8
	ADC  R27,R9
	RCALL SUBOPT_0x16
; 0001 00DC   }
	RCALL SUBOPT_0x9
	RJMP _0x20040
_0x20041:
; 0001 00DD   PN532_msg.length = 10+tag_uid.length;
	RCALL SUBOPT_0x0
	ADIW R30,10
	RCALL SUBOPT_0x18
; 0001 00DE 
; 0001 00DF   PN532_build_msg(&twi_tx, &PN532_msg);
; 0001 00E0   PN532_cmd(&twi_tx);
; 0001 00E1   delay_ms(20);
; 0001 00E2   while(!PN532_wait_for_ack()) delay_ms(20);
_0x20042:
	RCALL SUBOPT_0x19
	BRNE _0x20044
	RCALL SUBOPT_0x1A
	RJMP _0x20042
_0x20044:
; 0001 00E3 delay_ms(20);
	RCALL SUBOPT_0x1A
; 0001 00E4   PN532_read(&twi_rx);
	RCALL SUBOPT_0x1B
; 0001 00E5   PN532_get_msg(&twi_rx, &PN532_msg, 1);
	RCALL SUBOPT_0x1C
; 0001 00E6   if(PN532_msg.buffer[0] != 0x00) return false;
	LDS  R30,_PN532_msg
	CPI  R30,0
	BREQ _0x20045
	LDI  R30,LOW(0)
	RJMP _0x2080002
; 0001 00E7   return true;
_0x20045:
	LDI  R30,LOW(1)
_0x2080002:
	ADIW R28,4
	RET
; 0001 00E8 }
; .FEND
;
;bool PN532_read_passive_tag(unsigned char block_number)
; 0001 00EB {
_PN532_read_passive_tag:
; .FSTART _PN532_read_passive_tag
; 0001 00EC   if(!PN532_auth_tag(block_number, 0, MIFARE_Key_A)) return false;
	ST   -Y,R26
;	block_number -> Y+0
	LD   R30,Y
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(_MIFARE_Key_A)
	LDI  R27,HIGH(_MIFARE_Key_A)
	RCALL _PN532_auth_tag
	CPI  R30,0
	BRNE _0x20046
	LDI  R30,LOW(0)
	RJMP _0x2080001
; 0001 00ED   PN532_msg.buffer[0] = PN532_CMD_INDATAEXCHANGE;
_0x20046:
	LDI  R30,LOW(64)
	RCALL SUBOPT_0x1D
; 0001 00EE   PN532_msg.buffer[1] = 1;                              /* Max card numbers */
; 0001 00EF   PN532_msg.buffer[2] = MIFARE_CMD_READ;
	LDI  R30,LOW(48)
	RCALL SUBOPT_0x1E
; 0001 00F0   PN532_msg.buffer[3] = block_number;                    /* Block Number (1K = 0..63, 4K = 0..255 */
	LD   R30,Y
	__PUTB1MN _PN532_msg,3
; 0001 00F1   PN532_msg.length = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RCALL SUBOPT_0x18
; 0001 00F2 
; 0001 00F3   PN532_build_msg(&twi_tx, &PN532_msg);
; 0001 00F4   PN532_cmd(&twi_tx);
; 0001 00F5   delay_ms(20);
; 0001 00F6   while(!PN532_wait_for_ack()) delay_ms(20);
_0x20047:
	RCALL SUBOPT_0x19
	BRNE _0x20049
	RCALL SUBOPT_0x1A
	RJMP _0x20047
_0x20049:
; 0001 00F7 delay_ms(20);
	RCALL SUBOPT_0x1A
; 0001 00F8   PN532_read(&twi_rx);
	RCALL SUBOPT_0x1B
; 0001 00F9   PN532_get_msg(&twi_rx, &PN532_msg, 1);
	RCALL SUBOPT_0x1C
; 0001 00FA   if(PN532_msg.buffer[0] != 0x00) return false;
	LDS  R30,_PN532_msg
	CPI  R30,0
	BREQ _0x2004A
	LDI  R30,LOW(0)
	RJMP _0x2080001
; 0001 00FB   PN532_get_msg(&twi_rx, &tag_data, 2);
_0x2004A:
	LDI  R30,LOW(_twi_rx)
	LDI  R31,HIGH(_twi_rx)
	RCALL SUBOPT_0x1
	LDI  R30,LOW(_tag_data)
	LDI  R31,HIGH(_tag_data)
	RCALL SUBOPT_0x1
	LDI  R26,LOW(2)
	RCALL _PN532_get_msg
; 0001 00FC   return true;
	LDI  R30,LOW(1)
	RJMP _0x2080001
; 0001 00FD }
; .FEND
;
;bool PN532_write_passive_tag(unsigned char block_number, TWI_BUFFER_STRUCT* data)
; 0001 0100 {
; 0001 0101   if(!PN532_auth_tag(block_number, 0, MIFARE_Key_A)) return false;
;	block_number -> Y+2
;	*data -> Y+0
; 0001 0102   PN532_msg.buffer[0] = PN532_CMD_INDATAEXCHANGE;
; 0001 0103   PN532_msg.buffer[1] = 1;                              /* Max card numbers */
; 0001 0104   PN532_msg.buffer[2] = MIFARE_CMD_WRITE;
; 0001 0105   PN532_msg.buffer[3] = block_number;                    /* Block Number (1K = 0..63, 4K = 0..255 */
; 0001 0106   for (i = 0; i < data->length && i < 16; ++i)
; 0001 0107   {
; 0001 0108     PN532_msg.buffer[4+i] = data->buffer[i];                /* 16 byte data */
; 0001 0109   }
; 0001 010A   PN532_msg.length = 4+i;
; 0001 010B 
; 0001 010C   PN532_build_msg(&twi_tx, &PN532_msg);
; 0001 010D   PN532_cmd(&twi_tx);
; 0001 010E   delay_ms(20);
; 0001 010F   while(!PN532_wait_for_ack()) delay_ms(20);
; 0001 0110 delay_ms(20);
; 0001 0111   PN532_read(&twi_rx);
; 0001 0112   PN532_get_msg(&twi_rx, &PN532_msg, 1);
; 0001 0113   if(PN532_msg.buffer[0] != 0x00) return false;
; 0001 0114   PN532_get_msg(&twi_rx, &tag_data, 2);
; 0001 0115   return true;
; 0001 0116 }

	.CSEG
_strlen:
; .FSTART _strlen
	RCALL SUBOPT_0x3
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	RCALL SUBOPT_0x3
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND
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

	.DSEG

	.CSEG
__lcd_write_nibble_G101:
; .FSTART __lcd_write_nibble_G101
	ST   -Y,R26
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2020004
	SBI  0x15,3
	RJMP _0x2020005
_0x2020004:
	CBI  0x15,3
_0x2020005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2020006
	SBI  0x15,2
	RJMP _0x2020007
_0x2020006:
	CBI  0x15,2
_0x2020007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2020008
	SBI  0x15,1
	RJMP _0x2020009
_0x2020008:
	CBI  0x15,1
_0x2020009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x202000A
	SBI  0x15,0
	RJMP _0x202000B
_0x202000A:
	CBI  0x15,0
_0x202000B:
	RCALL SUBOPT_0x1F
	SBI  0x12,4
	RCALL SUBOPT_0x1F
	CBI  0x12,4
	RCALL SUBOPT_0x1F
	RJMP _0x2080001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
	__DELAY_USB 200
	RJMP _0x2080001
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x20
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x20
	LDI  R30,LOW(0)
	MOV  R10,R30
	MOV  R11,R30
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	SBI  0x14,3
	SBI  0x14,2
	SBI  0x14,1
	SBI  0x14,0
	SBI  0x11,4
	SBI  0x11,6
	SBI  0x11,5
	CBI  0x12,4
	CBI  0x12,6
	CBI  0x12,5
	LDD  R13,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x21
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G101
	__DELAY_USW 300
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
	RJMP _0x2080001
; .FEND
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
_0x2080001:
	ADIW R28,1
	RET
; .FEND
_put_usart_G102:
; .FSTART _put_usart_G102
	RCALL SUBOPT_0x3
	LDD  R26,Y+2
	RCALL _putchar
	RCALL SUBOPT_0x5
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	ADIW R28,3
	RET
; .FEND
__print_G102:
; .FSTART __print_G102
	RCALL SUBOPT_0x3
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2040016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2040018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x204001C
	CPI  R18,37
	BRNE _0x204001D
	LDI  R17,LOW(1)
	RJMP _0x204001E
_0x204001D:
	RCALL SUBOPT_0x22
_0x204001E:
	RJMP _0x204001B
_0x204001C:
	CPI  R30,LOW(0x1)
	BRNE _0x204001F
	CPI  R18,37
	BRNE _0x2040020
	RCALL SUBOPT_0x22
	RJMP _0x20400CC
_0x2040020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2040021
	LDI  R16,LOW(1)
	RJMP _0x204001B
_0x2040021:
	CPI  R18,43
	BRNE _0x2040022
	LDI  R20,LOW(43)
	RJMP _0x204001B
_0x2040022:
	CPI  R18,32
	BRNE _0x2040023
	LDI  R20,LOW(32)
	RJMP _0x204001B
_0x2040023:
	RJMP _0x2040024
_0x204001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2040025
_0x2040024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2040026
	ORI  R16,LOW(128)
	RJMP _0x204001B
_0x2040026:
	RJMP _0x2040027
_0x2040025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x204001B
_0x2040027:
	CPI  R18,48
	BRLO _0x204002A
	CPI  R18,58
	BRLO _0x204002B
_0x204002A:
	RJMP _0x2040029
_0x204002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x204001B
_0x2040029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x204002F
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x23
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x25
	RJMP _0x2040030
_0x204002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2040032
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x27
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2040033
_0x2040032:
	CPI  R30,LOW(0x70)
	BRNE _0x2040035
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x27
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2040033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2040036
_0x2040035:
	CPI  R30,LOW(0x64)
	BREQ _0x2040039
	CPI  R30,LOW(0x69)
	BRNE _0x204003A
_0x2040039:
	ORI  R16,LOW(4)
	RJMP _0x204003B
_0x204003A:
	CPI  R30,LOW(0x75)
	BRNE _0x204003C
_0x204003B:
	LDI  R30,LOW(_tbl10_G102*2)
	LDI  R31,HIGH(_tbl10_G102*2)
	RCALL SUBOPT_0x28
	LDI  R17,LOW(5)
	RJMP _0x204003D
_0x204003C:
	CPI  R30,LOW(0x58)
	BRNE _0x204003F
	ORI  R16,LOW(8)
	RJMP _0x2040040
_0x204003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2040071
_0x2040040:
	LDI  R30,LOW(_tbl16_G102*2)
	LDI  R31,HIGH(_tbl16_G102*2)
	RCALL SUBOPT_0x28
	LDI  R17,LOW(4)
_0x204003D:
	SBRS R16,2
	RJMP _0x2040042
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x29
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2040043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2040043:
	CPI  R20,0
	BREQ _0x2040044
	SUBI R17,-LOW(1)
	RJMP _0x2040045
_0x2040044:
	ANDI R16,LOW(251)
_0x2040045:
	RJMP _0x2040046
_0x2040042:
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x29
_0x2040046:
_0x2040036:
	SBRC R16,0
	RJMP _0x2040047
_0x2040048:
	CP   R17,R21
	BRSH _0x204004A
	SBRS R16,7
	RJMP _0x204004B
	SBRS R16,2
	RJMP _0x204004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x204004D
_0x204004C:
	LDI  R18,LOW(48)
_0x204004D:
	RJMP _0x204004E
_0x204004B:
	LDI  R18,LOW(32)
_0x204004E:
	RCALL SUBOPT_0x22
	SUBI R21,LOW(1)
	RJMP _0x2040048
_0x204004A:
_0x2040047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x204004F
_0x2040050:
	CPI  R19,0
	BREQ _0x2040052
	SBRS R16,3
	RJMP _0x2040053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	RCALL SUBOPT_0x28
	RJMP _0x2040054
_0x2040053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2040054:
	RCALL SUBOPT_0x22
	CPI  R21,0
	BREQ _0x2040055
	SUBI R21,LOW(1)
_0x2040055:
	SUBI R19,LOW(1)
	RJMP _0x2040050
_0x2040052:
	RJMP _0x2040056
_0x204004F:
_0x2040058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	RCALL SUBOPT_0x28
_0x204005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x204005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x204005A
_0x204005C:
	CPI  R18,58
	BRLO _0x204005D
	SBRS R16,3
	RJMP _0x204005E
	SUBI R18,-LOW(7)
	RJMP _0x204005F
_0x204005E:
	SUBI R18,-LOW(39)
_0x204005F:
_0x204005D:
	SBRC R16,4
	RJMP _0x2040061
	CPI  R18,49
	BRSH _0x2040063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2040062
_0x2040063:
	RJMP _0x20400CD
_0x2040062:
	CP   R21,R19
	BRLO _0x2040067
	SBRS R16,0
	RJMP _0x2040068
_0x2040067:
	RJMP _0x2040066
_0x2040068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2040069
	LDI  R18,LOW(48)
_0x20400CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x204006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0x25
	CPI  R21,0
	BREQ _0x204006B
	SUBI R21,LOW(1)
_0x204006B:
_0x204006A:
_0x2040069:
_0x2040061:
	RCALL SUBOPT_0x22
	CPI  R21,0
	BREQ _0x204006C
	SUBI R21,LOW(1)
_0x204006C:
_0x2040066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2040059
	RJMP _0x2040058
_0x2040059:
_0x2040056:
	SBRS R16,0
	RJMP _0x204006D
_0x204006E:
	CPI  R21,0
	BREQ _0x2040070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x25
	RJMP _0x204006E
_0x2040070:
_0x204006D:
_0x2040071:
_0x2040030:
_0x20400CC:
	LDI  R17,LOW(0)
_0x204001B:
	RJMP _0x2040016
_0x2040018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL __GETW1P
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_printf:
; .FSTART _printf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR2
	MOVW R26,R28
	ADIW R26,4
	RCALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __ADDW2R15
	RCALL __GETW1P
	RCALL SUBOPT_0x1
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_usart_G102)
	LDI  R31,HIGH(_put_usart_G102)
	RCALL SUBOPT_0x1
	MOVW R26,R28
	ADIW R26,8
	RCALL __print_G102
	RCALL __LOADLOCR2
	ADIW R28,8
	POP  R15
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
_rx_buffer:
	.BYTE 0x8
_MIFARE_Key_A:
	.BYTE 0x6
__base_y_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x0:
	__GETW1MN _tag_uid,80
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x1:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2:
	__ADDWRN 16,17,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4:
	CLR  R8
	CLR  R9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LD   R26,Y
	LDD  R27,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	SUBI R26,LOW(-80)
	SBCI R27,HIGH(-80)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	RCALL __GETW1P
	CP   R8,R30
	CPC  R9,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	MOVW R30,R8
	RCALL SUBOPT_0x5
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x9:
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xA:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB:
	ST   X,R30
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xC:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RCALL SUBOPT_0x6
	LD   R30,X
	SUBI R30,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xD:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xE:
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xF:
	MOVW R30,R8
	RCALL SUBOPT_0xD
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x10:
	RCALL _TWIStart
	LDI  R26,LOW(73)
	RCALL _TWIWrite
	LDI  R26,LOW(1)
	LDI  R27,0
	RCALL _TWIRead
	MOV  R17,R30
	CPI  R17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x11:
	LDI  R26,LOW(1)
	LDI  R27,0
	RJMP _TWIRead

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	MOV  R30,R16
	SUBI R16,-1
	RCALL SUBOPT_0xD
	LDI  R31,0
	RCALL SUBOPT_0xE
	ST   Z,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x13:
	RCALL _TWIStop
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x14:
	MOV  R30,R16
	SUBI R16,-1
	RCALL SUBOPT_0xD
	LDI  R31,0
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	CP   R8,R30
	CPC  R9,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x16:
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x17:
	STS  _PN532_msg,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:58 WORDS
SUBOPT_0x18:
	__PUTW1MN _PN532_msg,80
	LDI  R30,LOW(_twi_tx)
	LDI  R31,HIGH(_twi_tx)
	RCALL SUBOPT_0x1
	LDI  R26,LOW(_PN532_msg)
	LDI  R27,HIGH(_PN532_msg)
	RCALL _PN532_build_msg
	LDI  R26,LOW(_twi_tx)
	LDI  R27,HIGH(_twi_tx)
	RCALL _PN532_cmd
	LDI  R26,LOW(20)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x19:
	RCALL _PN532_wait_for_ack
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x1A:
	LDI  R26,LOW(20)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x1B:
	LDI  R26,LOW(_twi_rx)
	LDI  R27,HIGH(_twi_rx)
	RCALL _PN532_read
	LDI  R30,LOW(_twi_rx)
	LDI  R31,HIGH(_twi_rx)
	RCALL SUBOPT_0x1
	LDI  R30,LOW(_PN532_msg)
	LDI  R31,HIGH(_PN532_msg)
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	LDI  R26,LOW(1)
	RJMP _PN532_get_msg

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1D:
	RCALL SUBOPT_0x17
	LDI  R30,LOW(1)
	__PUTB1MN _PN532_msg,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	__PUTB1MN _PN532_msg,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1F:
	__DELAY_USB 20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x21:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G101
	__DELAY_USW 300
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x22:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x23:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x24:
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x25:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	RCALL SUBOPT_0x23
	RJMP SUBOPT_0x24

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x27:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	RCALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x29:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	RCALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
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

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
