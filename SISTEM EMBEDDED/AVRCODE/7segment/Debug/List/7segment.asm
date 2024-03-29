
;CodeVisionAVR C Compiler V3.52 
;(C) Copyright 1998-2023 Pavel Haiduc, HP InfoTech S.R.L.
;http://www.hpinfotech.ro

;Build configuration    : Debug
;Chip type              : ATmega168P
;Program type           : Application
;Clock frequency        : 1,000000 MHz
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
;Enhanced function parameter passing: Mode 2
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega168P
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPMCSR=0x37
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

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

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x04FF
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.EQU __FLASH_PAGE_SIZE=0x40
	.EQU __EEPROM_PAGE_SIZE=0x04

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

	.MACRO __GETW1P
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
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

	.MACRO __GETD1P_INC
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	.ENDM

	.MACRO __GETD1P_DEC
	LD   R23,-X
	LD   R22,-X
	LD   R31,-X
	LD   R30,-X
	.ENDM

	.MACRO __PUTDP1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTDP1_DEC
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
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

	.MACRO __CPD10
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	.ENDM

	.MACRO __CPD20
	SBIW R26,0
	SBCI R24,0
	SBCI R25,0
	.ENDM

	.MACRO __ADDD12
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	.ENDM

	.MACRO __ADDD21
	ADD  R26,R30
	ADC  R27,R31
	ADC  R24,R22
	ADC  R25,R23
	.ENDM

	.MACRO __SUBD12
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	.ENDM

	.MACRO __SUBD21
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R25,R23
	.ENDM

	.MACRO __ANDD12
	AND  R30,R26
	AND  R31,R27
	AND  R22,R24
	AND  R23,R25
	.ENDM

	.MACRO __ORD12
	OR   R30,R26
	OR   R31,R27
	OR   R22,R24
	OR   R23,R25
	.ENDM

	.MACRO __XORD12
	EOR  R30,R26
	EOR  R31,R27
	EOR  R22,R24
	EOR  R23,R25
	.ENDM

	.MACRO __XORD21
	EOR  R26,R30
	EOR  R27,R31
	EOR  R24,R22
	EOR  R25,R23
	.ENDM

	.MACRO __COMD1
	COM  R30
	COM  R31
	COM  R22
	COM  R23
	.ENDM

	.MACRO __MULD2_2
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	.ENDM

	.MACRO __LSRD1
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	.ENDM

	.MACRO __LSLD1
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	.ENDM

	.MACRO __ASRB4
	ASR  R30
	ASR  R30
	ASR  R30
	ASR  R30
	.ENDM

	.MACRO __ASRW8
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
	.ENDM

	.MACRO __LSRD16
	MOV  R30,R22
	MOV  R31,R23
	LDI  R22,0
	LDI  R23,0
	.ENDM

	.MACRO __LSLD16
	MOV  R22,R30
	MOV  R23,R31
	LDI  R30,0
	LDI  R31,0
	.ENDM

	.MACRO __CWD1
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	.ENDM

	.MACRO __CWD2
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	.ENDM

	.MACRO __SETMSD1
	SER  R31
	SER  R22
	SER  R23
	.ENDM

	.MACRO __ADDW1R15
	CLR  R0
	ADD  R30,R15
	ADC  R31,R0
	.ENDM

	.MACRO __ADDW2R15
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	.ENDM

	.MACRO __EQB12
	CP   R30,R26
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __NEB12
	CP   R30,R26
	LDI  R30,1
	BRNE PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12
	CP   R30,R26
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12
	CP   R26,R30
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12
	CP   R26,R30
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12
	CP   R30,R26
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12U
	CP   R30,R26
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12U
	CP   R26,R30
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12U
	CP   R26,R30
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12U
	CP   R30,R26
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __CPW01
	CLR  R0
	CP   R0,R30
	CPC  R0,R31
	.ENDM

	.MACRO __CPW02
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	.ENDM

	.MACRO __CPD12
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	.ENDM

	.MACRO __CPD21
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	.ENDM

	.MACRO __BSTB1
	CLT
	TST  R30
	BREQ PC+2
	SET
	.ENDM

	.MACRO __LNEGB1
	TST  R30
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __LNEGW1
	OR   R30,R31
	LDI  R30,1
	BREQ PC+2
	LDI  R30,0
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

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
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
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
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
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
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
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
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
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
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
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
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
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
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
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
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
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
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
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
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
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
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
	CALL __GETW1Z
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETD1Z
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
	CALL __GETW2X
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETD2X
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
	.DEF _detik=R3
	.DEF _detik_msb=R4

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
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
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0x00

	.DSEG
	.ORG 0x200

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG
_num0:
; .FSTART _num0
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x2
	RJMP _0x2000002
; .FEND
_num1:
; .FSTART _num1
	RCALL SUBOPT_0x2
	SBI  0x5,1
	CBI  0x5,1
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x3
	SBI  0x5,1
	CBI  0x5,1
	RCALL SUBOPT_0x2
	SBI  0x5,1
	CBI  0x5,1
	CBI  0x5,0
	RJMP _0x2000002
; .FEND
_num2:
; .FSTART _num2
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x4
	SBI  0x5,1
	CBI  0x5,1
	SBI  0x5,0
	SBI  0x5,1
	CBI  0x5,1
	SBI  0x5,0
	RJMP _0x2000001
; .FEND
_num3:
; .FSTART _num3
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x0
	CBI  0x5,0
_0x2000001:
	SBI  0x5,1
	CBI  0x5,1
	RCALL SUBOPT_0x2
	SBI  0x5,1
	CBI  0x5,1
	RCALL SUBOPT_0x2
	SBI  0x5,1
	CBI  0x5,1
	RCALL SUBOPT_0x3
	SBI  0x5,1
	CBI  0x5,1
	RCALL SUBOPT_0x4
_0x2000002:
	SBI  0x5,1
	CBI  0x5,1
	RET
; .FEND
;void conf1()
; 0000 0088 {
_conf1:
; .FSTART _conf1
; 0000 0089 num3();
	RCALL _num3
; 0000 008A num2();
	RCALL _num2
; 0000 008B num1();
	RCALL _num1
; 0000 008C num0();
	RCALL _num0
; 0000 008D num1();
	RCALL _num1
; 0000 008E num2();
	RCALL _num2
; 0000 008F PORTB.2 = 1;
	SBI  0x5,2
; 0000 0090 PORTB.2 = 0;
	CBI  0x5,2
; 0000 0091 }
	RET
; .FEND
;void main(void)
; 0000 0094 {
_main:
; .FSTART _main
; 0000 0095 // Declare your local variables here
; 0000 0096 
; 0000 0097 // Crystal Oscillator division factor: 1
; 0000 0098 #pragma optsize-
; 0000 0099 CLKPR=(1<<CLKPCE);
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 009A CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 009B #ifdef _OPTIMIZE_SIZE_
; 0000 009C #pragma optsize+
; 0000 009D #endif
; 0000 009E 
; 0000 009F // Input/Output Ports initialization
; 0000 00A0 // Port B initialization
; 0000 00A1 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=Out Bit1=Out Bit0=Out
; 0000 00A2 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(7)
	OUT  0x4,R30
; 0000 00A3 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=1 Bit1=1 Bit0=1
; 0000 00A4 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (1<<PORTB2) | (1<<PORTB1) | (1<<PORTB0);
	OUT  0x5,R30
; 0000 00A5 
; 0000 00A6 // Port C initialization
; 0000 00A7 // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00A8 DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(0)
	OUT  0x7,R30
; 0000 00A9 // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00AA PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x8,R30
; 0000 00AB 
; 0000 00AC // Port D initialization
; 0000 00AD // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00AE DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0xA,R30
; 0000 00AF // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00B0 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0xB,R30
; 0000 00B1 
; 0000 00B2 // Timer/Counter 0 initialization
; 0000 00B3 // Clock source: System Clock
; 0000 00B4 // Clock value: Timer 0 Stopped
; 0000 00B5 // Mode: Normal top=0xFF
; 0000 00B6 // OC0A output: Disconnected
; 0000 00B7 // OC0B output: Disconnected
; 0000 00B8 TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
	OUT  0x24,R30
; 0000 00B9 TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x25,R30
; 0000 00BA TCNT0=0x00;
	OUT  0x26,R30
; 0000 00BB OCR0A=0x00;
	OUT  0x27,R30
; 0000 00BC OCR0B=0x00;
	OUT  0x28,R30
; 0000 00BD 
; 0000 00BE // Timer/Counter 1 initialization
; 0000 00BF // Clock source: System Clock
; 0000 00C0 // Clock value: Timer1 Stopped
; 0000 00C1 // Mode: Normal top=0xFFFF
; 0000 00C2 // OC1A output: Disconnected
; 0000 00C3 // OC1B output: Disconnected
; 0000 00C4 // Noise Canceler: Off
; 0000 00C5 // Input Capture on Falling Edge
; 0000 00C6 // Timer1 Overflow Interrupt: Off
; 0000 00C7 // Input Capture Interrupt: Off
; 0000 00C8 // Compare A Match Interrupt: Off
; 0000 00C9 // Compare B Match Interrupt: Off
; 0000 00CA TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	STS  128,R30
; 0000 00CB TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	STS  129,R30
; 0000 00CC TCNT1H=0x00;
	STS  133,R30
; 0000 00CD TCNT1L=0x00;
	STS  132,R30
; 0000 00CE ICR1H=0x00;
	STS  135,R30
; 0000 00CF ICR1L=0x00;
	STS  134,R30
; 0000 00D0 OCR1AH=0x00;
	STS  137,R30
; 0000 00D1 OCR1AL=0x00;
	STS  136,R30
; 0000 00D2 OCR1BH=0x00;
	STS  139,R30
; 0000 00D3 OCR1BL=0x00;
	STS  138,R30
; 0000 00D4 
; 0000 00D5 // Timer/Counter 2 initialization
; 0000 00D6 // Clock source: System Clock
; 0000 00D7 // Clock value: Timer2 Stopped
; 0000 00D8 // Mode: Normal top=0xFF
; 0000 00D9 // OC2A output: Disconnected
; 0000 00DA // OC2B output: Disconnected
; 0000 00DB ASSR=(0<<EXCLK) | (0<<AS2);
	STS  182,R30
; 0000 00DC TCCR2A=(0<<COM2A1) | (0<<COM2A0) | (0<<COM2B1) | (0<<COM2B0) | (0<<WGM21) | (0<<WGM20);
	STS  176,R30
; 0000 00DD TCCR2B=(0<<WGM22) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	STS  177,R30
; 0000 00DE TCNT2=0x00;
	STS  178,R30
; 0000 00DF OCR2A=0x00;
	STS  179,R30
; 0000 00E0 OCR2B=0x00;
	STS  180,R30
; 0000 00E1 
; 0000 00E2 // Timer/Counter 0 Interrupt(s) initialization
; 0000 00E3 TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (0<<TOIE0);
	STS  110,R30
; 0000 00E4 
; 0000 00E5 // Timer/Counter 1 Interrupt(s) initialization
; 0000 00E6 TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (0<<TOIE1);
	STS  111,R30
; 0000 00E7 
; 0000 00E8 // Timer/Counter 2 Interrupt(s) initialization
; 0000 00E9 TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (0<<TOIE2);
	STS  112,R30
; 0000 00EA 
; 0000 00EB // External Interrupt(s) initialization
; 0000 00EC // INT0: Off
; 0000 00ED // INT1: Off
; 0000 00EE // Interrupt on any change on pins PCINT0-7: Off
; 0000 00EF // Interrupt on any change on pins PCINT8-14: Off
; 0000 00F0 // Interrupt on any change on pins PCINT16-23: Off
; 0000 00F1 EICRA=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	STS  105,R30
; 0000 00F2 EIMSK=(0<<INT1) | (0<<INT0);
	OUT  0x1D,R30
; 0000 00F3 PCICR=(0<<PCIE2) | (0<<PCIE1) | (0<<PCIE0);
	STS  104,R30
; 0000 00F4 
; 0000 00F5 // USART initialization
; 0000 00F6 // USART disabled
; 0000 00F7 UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (0<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	STS  193,R30
; 0000 00F8 
; 0000 00F9 // Analog Comparator initialization
; 0000 00FA // Analog Comparator: Off
; 0000 00FB // The Analog Comparator's positive input is
; 0000 00FC // connected to the AIN0 pin
; 0000 00FD // The Analog Comparator's negative input is
; 0000 00FE // connected to the AIN1 pin
; 0000 00FF ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 0100 ADCSRB=(0<<ACME);
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 0101 // Digital input buffer on AIN0: On
; 0000 0102 // Digital input buffer on AIN1: On
; 0000 0103 DIDR1=(0<<AIN0D) | (0<<AIN1D);
	STS  127,R30
; 0000 0104 
; 0000 0105 // ADC initialization
; 0000 0106 // ADC disabled
; 0000 0107 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	STS  122,R30
; 0000 0108 
; 0000 0109 // SPI initialization
; 0000 010A // SPI disabled
; 0000 010B SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0x2C,R30
; 0000 010C 
; 0000 010D // TWI initialization
; 0000 010E // TWI disabled
; 0000 010F TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	STS  188,R30
; 0000 0110 
; 0000 0111 
; 0000 0112 while (1)
_0x187:
; 0000 0113 {
; 0000 0114 
; 0000 0115 //PORTB.2 = 1;
; 0000 0116 //PORTB.2 = 0;
; 0000 0117 //delay_ms(1);
; 0000 0118 //detik = 2;
; 0000 0119 //PORTB.2 = 1;
; 0000 011A //PORTB.2 = 0;
; 0000 011B //delay_ms(100);
; 0000 011C conf1();
	RCALL _conf1
; 0000 011D //detik = 1;
; 0000 011E //delay_ms(10);
; 0000 011F //detik = 2;
; 0000 0120 //delay_ms(10);
; 0000 0121 /*
; 0000 0122 for (s = 1; s < 7; ++s)
; 0000 0123 
; 0000 0124 {
; 0000 0125 detik = s;
; 0000 0126 delay_ms(10);
; 0000 0127 detik = 10;
; 0000 0128 delay_ms(1);
; 0000 0129 s++;
; 0000 012A }
; 0000 012B */
; 0000 012C 
; 0000 012D //return 0;
; 0000 012E 
; 0000 012F // Place your code here
; 0000 0130 switch (detik)
	__GETW1R 3,4
; 0000 0131 {
; 0000 0132 case 1: num1(); break;
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x18D
	RCALL _num1
	RJMP _0x18C
; 0000 0133 case 2: num2(); break;
_0x18D:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x18C
	RCALL _num2
; 0000 0134 /*
; 0000 0135 case 1:  //angka 1
; 0000 0136 PORTB.0 = 0;  //segA1
; 0000 0137 PORTB.1 = 1;
; 0000 0138 PORTB.1 = 0;
; 0000 0139 PORTB.0 = 0;  //segA2
; 0000 013A PORTB.1 = 1;
; 0000 013B PORTB.1 = 0;
; 0000 013C PORTB.0 = 1;  //segB
; 0000 013D PORTB.1 = 1;
; 0000 013E PORTB.1 = 0;
; 0000 013F PORTB.0 = 1;  //segC
; 0000 0140 PORTB.1 = 1;
; 0000 0141 PORTB.1 = 0;
; 0000 0142 PORTB.0 = 0;  //segD2
; 0000 0143 PORTB.1 = 1;
; 0000 0144 PORTB.1 = 0;
; 0000 0145 PORTB.0 = 0;  //segD1
; 0000 0146 PORTB.1 = 1;
; 0000 0147 PORTB.1 = 0;
; 0000 0148 PORTB.0 = 0;  //segE
; 0000 0149 PORTB.1 = 1;
; 0000 014A PORTB.1 = 0;
; 0000 014B PORTB.0 = 0;  //segF
; 0000 014C PORTB.1 = 1;
; 0000 014D PORTB.1 = 0;
; 0000 014E PORTB.0 = 0;  //segH
; 0000 014F PORTB.1 = 1;
; 0000 0150 PORTB.1 = 0;
; 0000 0151 PORTB.0 = 0;  //segJ
; 0000 0152 PORTB.1 = 1;
; 0000 0153 PORTB.1 = 0;
; 0000 0154 PORTB.0 = 1;  //segK
; 0000 0155 PORTB.1 = 1;
; 0000 0156 PORTB.1 = 0;
; 0000 0157 PORTB.0 = 0;  //segG2
; 0000 0158 PORTB.1 = 1;
; 0000 0159 PORTB.1 = 0;
; 0000 015A PORTB.0 = 0;  //segL
; 0000 015B PORTB.1 = 1;
; 0000 015C PORTB.1 = 0;
; 0000 015D PORTB.0 = 0;  //segM
; 0000 015E PORTB.1 = 1;
; 0000 015F PORTB.1 = 0;
; 0000 0160 PORTB.0 = 0;  //segN
; 0000 0161 PORTB.1 = 1;
; 0000 0162 PORTB.1 = 0;
; 0000 0163 PORTB.0 = 0;  //segG1
; 0000 0164 PORTB.1 = 1;
; 0000 0165 PORTB.1 = 0;
; 0000 0166 break;
; 0000 0167 
; 0000 0168 
; 0000 0169 case 2:
; 0000 016A PORTB.0 = 1;  //segA1
; 0000 016B PORTB.1 = 1;
; 0000 016C PORTB.1 = 0;
; 0000 016D PORTB.0 = 1;  //segA2
; 0000 016E PORTB.1 = 1;
; 0000 016F PORTB.1 = 0;
; 0000 0170 PORTB.0 = 1;  //segB
; 0000 0171 PORTB.1 = 1;
; 0000 0172 PORTB.1 = 0;
; 0000 0173 PORTB.0 = 0;  //segC
; 0000 0174 PORTB.1 = 1;
; 0000 0175 PORTB.1 = 0;
; 0000 0176 PORTB.0 = 1;  //segD2
; 0000 0177 PORTB.1 = 1;
; 0000 0178 PORTB.1 = 0;
; 0000 0179 PORTB.0 = 1;  //segD1
; 0000 017A PORTB.1 = 1;
; 0000 017B PORTB.1 = 0;
; 0000 017C PORTB.0 = 1;  //segE
; 0000 017D PORTB.1 = 1;
; 0000 017E PORTB.1 = 0;
; 0000 017F PORTB.0 = 0;  //segF
; 0000 0180 PORTB.1 = 1;
; 0000 0181 PORTB.1 = 0;
; 0000 0182 PORTB.0 = 0;  //segH
; 0000 0183 PORTB.1 = 1;
; 0000 0184 PORTB.1 = 0;
; 0000 0185 PORTB.0 = 0;  //segJ
; 0000 0186 PORTB.1 = 1;
; 0000 0187 PORTB.1 = 0;
; 0000 0188 PORTB.0 = 0;  //segK
; 0000 0189 PORTB.1 = 1;
; 0000 018A PORTB.1 = 0;
; 0000 018B PORTB.0 = 1;  //segG2
; 0000 018C PORTB.1 = 1;
; 0000 018D PORTB.1 = 0;
; 0000 018E PORTB.0 = 0;  //segL
; 0000 018F PORTB.1 = 1;
; 0000 0190 PORTB.1 = 0;
; 0000 0191 PORTB.0 = 0;  //segM
; 0000 0192 PORTB.1 = 1;
; 0000 0193 PORTB.1 = 0;
; 0000 0194 PORTB.0 = 0;  //segN
; 0000 0195 PORTB.1 = 1;
; 0000 0196 PORTB.1 = 0;
; 0000 0197 PORTB.0 = 1;  //segG1
; 0000 0198 PORTB.1 = 1;
; 0000 0199 PORTB.1 = 0;
; 0000 019A break;
; 0000 019B 
; 0000 019C case 3:
; 0000 019D PORTB.0 = 1;  //segA1
; 0000 019E PORTB.1 = 1;
; 0000 019F PORTB.1 = 0;
; 0000 01A0 PORTB.0 = 1;  //segA2
; 0000 01A1 PORTB.1 = 1;
; 0000 01A2 PORTB.1 = 0;
; 0000 01A3 PORTB.0 = 1;  //segB
; 0000 01A4 PORTB.1 = 1;
; 0000 01A5 PORTB.1 = 0;
; 0000 01A6 PORTB.0 = 1;  //segC
; 0000 01A7 PORTB.1 = 1;
; 0000 01A8 PORTB.1 = 0;
; 0000 01A9 PORTB.0 = 1;  //segD2
; 0000 01AA PORTB.1 = 1;
; 0000 01AB PORTB.1 = 0;
; 0000 01AC PORTB.0 = 1;  //segD1
; 0000 01AD PORTB.1 = 1;
; 0000 01AE PORTB.1 = 0;
; 0000 01AF PORTB.0 = 0;  //segE
; 0000 01B0 PORTB.1 = 1;
; 0000 01B1 PORTB.1 = 0;
; 0000 01B2 PORTB.0 = 0;  //segF
; 0000 01B3 PORTB.1 = 1;
; 0000 01B4 PORTB.1 = 0;
; 0000 01B5 PORTB.0 = 0;  //segH
; 0000 01B6 PORTB.1 = 1;
; 0000 01B7 PORTB.1 = 0;
; 0000 01B8 PORTB.0 = 0;  //segJ
; 0000 01B9 PORTB.1 = 1;
; 0000 01BA PORTB.1 = 0;
; 0000 01BB PORTB.0 = 0;  //segK
; 0000 01BC PORTB.1 = 1;
; 0000 01BD PORTB.1 = 0;
; 0000 01BE PORTB.0 = 1;  //segG2
; 0000 01BF PORTB.1 = 1;
; 0000 01C0 PORTB.1 = 0;
; 0000 01C1 PORTB.0 = 0;  //segL
; 0000 01C2 PORTB.1 = 1;
; 0000 01C3 PORTB.1 = 0;
; 0000 01C4 PORTB.0 = 0;  //segM
; 0000 01C5 PORTB.1 = 1;
; 0000 01C6 PORTB.1 = 0;
; 0000 01C7 PORTB.0 = 0;  //segN
; 0000 01C8 PORTB.1 = 1;
; 0000 01C9 PORTB.1 = 0;
; 0000 01CA PORTB.0 = 1;  //segG1
; 0000 01CB PORTB.1 = 1;
; 0000 01CC PORTB.1 = 0;
; 0000 01CD break;
; 0000 01CE 
; 0000 01CF case 4:
; 0000 01D0 PORTB.0 = 0;  //segA1
; 0000 01D1 PORTB.1 = 1;
; 0000 01D2 PORTB.1 = 0;
; 0000 01D3 PORTB.0 = 0;  //segA2
; 0000 01D4 PORTB.1 = 1;
; 0000 01D5 PORTB.1 = 0;
; 0000 01D6 PORTB.0 = 1;  //segB
; 0000 01D7 PORTB.1 = 1;
; 0000 01D8 PORTB.1 = 0;
; 0000 01D9 PORTB.0 = 1;  //segC
; 0000 01DA PORTB.1 = 1;
; 0000 01DB PORTB.1 = 0;
; 0000 01DC PORTB.0 = 0;  //segD2
; 0000 01DD PORTB.1 = 1;
; 0000 01DE PORTB.1 = 0;
; 0000 01DF PORTB.0 = 0;  //segD1
; 0000 01E0 PORTB.1 = 1;
; 0000 01E1 PORTB.1 = 0;
; 0000 01E2 PORTB.0 = 0;  //segE
; 0000 01E3 PORTB.1 = 1;
; 0000 01E4 PORTB.1 = 0;
; 0000 01E5 PORTB.0 = 1;  //segF
; 0000 01E6 PORTB.1 = 1;
; 0000 01E7 PORTB.1 = 0;
; 0000 01E8 PORTB.0 = 0;  //segH
; 0000 01E9 PORTB.1 = 1;
; 0000 01EA PORTB.1 = 0;
; 0000 01EB PORTB.0 = 0;  //segJ
; 0000 01EC PORTB.1 = 1;
; 0000 01ED PORTB.1 = 0;
; 0000 01EE PORTB.0 = 0;  //segK
; 0000 01EF PORTB.1 = 1;
; 0000 01F0 PORTB.1 = 0;
; 0000 01F1 PORTB.0 = 1;  //segG2
; 0000 01F2 PORTB.1 = 1;
; 0000 01F3 PORTB.1 = 0;
; 0000 01F4 PORTB.0 = 0;  //segL
; 0000 01F5 PORTB.1 = 1;
; 0000 01F6 PORTB.1 = 0;
; 0000 01F7 PORTB.0 = 0;  //segM
; 0000 01F8 PORTB.1 = 1;
; 0000 01F9 PORTB.1 = 0;
; 0000 01FA PORTB.0 = 0;  //segN
; 0000 01FB PORTB.1 = 1;
; 0000 01FC PORTB.1 = 0;
; 0000 01FD PORTB.0 = 1;  //segG1
; 0000 01FE PORTB.1 = 1;
; 0000 01FF PORTB.1 = 0;
; 0000 0200 break;
; 0000 0201 
; 0000 0202 case 5:
; 0000 0203 PORTB.0 = 1;  //segA1
; 0000 0204 PORTB.1 = 1;
; 0000 0205 PORTB.1 = 0;
; 0000 0206 PORTB.0 = 1;  //segA2
; 0000 0207 PORTB.1 = 1;
; 0000 0208 PORTB.1 = 0;
; 0000 0209 PORTB.0 = 0;  //segB
; 0000 020A PORTB.1 = 1;
; 0000 020B PORTB.1 = 0;
; 0000 020C PORTB.0 = 0;  //segC
; 0000 020D PORTB.1 = 1;
; 0000 020E PORTB.1 = 0;
; 0000 020F PORTB.0 = 1;  //segD2
; 0000 0210 PORTB.1 = 1;
; 0000 0211 PORTB.1 = 0;
; 0000 0212 PORTB.0 = 1;  //segD1
; 0000 0213 PORTB.1 = 1;
; 0000 0214 PORTB.1 = 0;
; 0000 0215 PORTB.0 = 0;  //segE
; 0000 0216 PORTB.1 = 1;
; 0000 0217 PORTB.1 = 0;
; 0000 0218 PORTB.0 = 1;  //segF
; 0000 0219 PORTB.1 = 1;
; 0000 021A PORTB.1 = 0;
; 0000 021B PORTB.0 = 0;  //segH
; 0000 021C PORTB.1 = 1;
; 0000 021D PORTB.1 = 0;
; 0000 021E PORTB.0 = 0;  //segJ
; 0000 021F PORTB.1 = 1;
; 0000 0220 PORTB.1 = 0;
; 0000 0221 PORTB.0 = 0;  //segK
; 0000 0222 PORTB.1 = 1;
; 0000 0223 PORTB.1 = 0;
; 0000 0224 PORTB.0 = 0;  //segG2
; 0000 0225 PORTB.1 = 1;
; 0000 0226 PORTB.1 = 0;
; 0000 0227 PORTB.0 = 1;  //segL
; 0000 0228 PORTB.1 = 1;
; 0000 0229 PORTB.1 = 0;
; 0000 022A PORTB.0 = 0;  //segM
; 0000 022B PORTB.1 = 1;
; 0000 022C PORTB.1 = 0;
; 0000 022D PORTB.0 = 0;  //segN
; 0000 022E PORTB.1 = 1;
; 0000 022F PORTB.1 = 0;
; 0000 0230 PORTB.0 = 1;  //segG1
; 0000 0231 PORTB.1 = 1;
; 0000 0232 PORTB.1 = 0;
; 0000 0233 break;
; 0000 0234 
; 0000 0235 case 6:
; 0000 0236 PORTB.0 = 1;  //segA1
; 0000 0237 PORTB.1 = 1;
; 0000 0238 PORTB.1 = 0;
; 0000 0239 PORTB.0 = 1;  //segA2
; 0000 023A PORTB.1 = 1;
; 0000 023B PORTB.1 = 0;
; 0000 023C PORTB.0 = 0;  //segB
; 0000 023D PORTB.1 = 1;
; 0000 023E PORTB.1 = 0;
; 0000 023F PORTB.0 = 1;  //segC
; 0000 0240 PORTB.1 = 1;
; 0000 0241 PORTB.1 = 0;
; 0000 0242 PORTB.0 = 1;  //segD2
; 0000 0243 PORTB.1 = 1;
; 0000 0244 PORTB.1 = 0;
; 0000 0245 PORTB.0 = 1;  //segD1
; 0000 0246 PORTB.1 = 1;
; 0000 0247 PORTB.1 = 0;
; 0000 0248 PORTB.0 = 1;  //segE
; 0000 0249 PORTB.1 = 1;
; 0000 024A PORTB.1 = 0;
; 0000 024B PORTB.0 = 1;  //segF
; 0000 024C PORTB.1 = 1;
; 0000 024D PORTB.1 = 0;
; 0000 024E PORTB.0 = 0;  //segH
; 0000 024F PORTB.1 = 1;
; 0000 0250 PORTB.1 = 0;
; 0000 0251 PORTB.0 = 0;  //segJ
; 0000 0252 PORTB.1 = 1;
; 0000 0253 PORTB.1 = 0;
; 0000 0254 PORTB.0 = 0;  //segK
; 0000 0255 PORTB.1 = 1;
; 0000 0256 PORTB.1 = 0;
; 0000 0257 PORTB.0 = 1;  //segG2
; 0000 0258 PORTB.1 = 1;
; 0000 0259 PORTB.1 = 0;
; 0000 025A PORTB.0 = 0;  //segL
; 0000 025B PORTB.1 = 1;
; 0000 025C PORTB.1 = 0;
; 0000 025D PORTB.0 = 0;  //segM
; 0000 025E PORTB.1 = 1;
; 0000 025F PORTB.1 = 0;
; 0000 0260 PORTB.0 = 0;  //segN
; 0000 0261 PORTB.1 = 1;
; 0000 0262 PORTB.1 = 0;
; 0000 0263 PORTB.0 = 1;  //segG1
; 0000 0264 PORTB.1 = 1;
; 0000 0265 PORTB.1 = 0;
; 0000 0266 break;
; 0000 0267 
; 0000 0268 case 7:
; 0000 0269 PORTB.0 = 1;  //segA1
; 0000 026A PORTB.1 = 1;
; 0000 026B PORTB.1 = 0;
; 0000 026C PORTB.0 = 1;  //segA2
; 0000 026D PORTB.1 = 1;
; 0000 026E PORTB.1 = 0;
; 0000 026F PORTB.0 = 1;  //segB
; 0000 0270 PORTB.1 = 1;
; 0000 0271 PORTB.1 = 0;
; 0000 0272 PORTB.0 = 1;  //segC
; 0000 0273 PORTB.1 = 1;
; 0000 0274 PORTB.1 = 0;
; 0000 0275 PORTB.0 = 0;  //segD2
; 0000 0276 PORTB.1 = 1;
; 0000 0277 PORTB.1 = 0;
; 0000 0278 PORTB.0 = 0;  //segD1
; 0000 0279 PORTB.1 = 1;
; 0000 027A PORTB.1 = 0;
; 0000 027B PORTB.0 = 0;  //segE
; 0000 027C PORTB.1 = 1;
; 0000 027D PORTB.1 = 0;
; 0000 027E PORTB.0 = 0;  //segF
; 0000 027F PORTB.1 = 1;
; 0000 0280 PORTB.1 = 0;
; 0000 0281 PORTB.0 = 0;  //segH
; 0000 0282 PORTB.1 = 1;
; 0000 0283 PORTB.1 = 0;
; 0000 0284 PORTB.0 = 0;  //segJ
; 0000 0285 PORTB.1 = 1;
; 0000 0286 PORTB.1 = 0;
; 0000 0287 PORTB.0 = 0;  //segK
; 0000 0288 PORTB.1 = 1;
; 0000 0289 PORTB.1 = 0;
; 0000 028A PORTB.0 = 0;  //segG2
; 0000 028B PORTB.1 = 1;
; 0000 028C PORTB.1 = 0;
; 0000 028D PORTB.0 = 0;  //segL
; 0000 028E PORTB.1 = 1;
; 0000 028F PORTB.1 = 0;
; 0000 0290 PORTB.0 = 0;  //segM
; 0000 0291 PORTB.1 = 1;
; 0000 0292 PORTB.1 = 0;
; 0000 0293 PORTB.0 = 0;  //segN
; 0000 0294 PORTB.1 = 1;
; 0000 0295 PORTB.1 = 0;
; 0000 0296 PORTB.0 = 0;  //segG1
; 0000 0297 PORTB.1 = 1;
; 0000 0298 PORTB.1 = 0;
; 0000 0299 break;
; 0000 029A 
; 0000 029B case 8:
; 0000 029C PORTB.0 = 1;  //segA1
; 0000 029D PORTB.1 = 1;
; 0000 029E PORTB.1 = 0;
; 0000 029F PORTB.0 = 1;  //segA2
; 0000 02A0 PORTB.1 = 1;
; 0000 02A1 PORTB.1 = 0;
; 0000 02A2 PORTB.0 = 1;  //segB
; 0000 02A3 PORTB.1 = 1;
; 0000 02A4 PORTB.1 = 0;
; 0000 02A5 PORTB.0 = 1;  //segC
; 0000 02A6 PORTB.1 = 1;
; 0000 02A7 PORTB.1 = 0;
; 0000 02A8 PORTB.0 = 1;  //segD2
; 0000 02A9 PORTB.1 = 1;
; 0000 02AA PORTB.1 = 0;
; 0000 02AB PORTB.0 = 1;  //segD1
; 0000 02AC PORTB.1 = 1;
; 0000 02AD PORTB.1 = 0;
; 0000 02AE PORTB.0 = 1;  //segE
; 0000 02AF PORTB.1 = 1;
; 0000 02B0 PORTB.1 = 0;
; 0000 02B1 PORTB.0 = 1;  //segF
; 0000 02B2 PORTB.1 = 1;
; 0000 02B3 PORTB.1 = 0;
; 0000 02B4 PORTB.0 = 0;  //segH
; 0000 02B5 PORTB.1 = 1;
; 0000 02B6 PORTB.1 = 0;
; 0000 02B7 PORTB.0 = 0;  //segJ
; 0000 02B8 PORTB.1 = 1;
; 0000 02B9 PORTB.1 = 0;
; 0000 02BA PORTB.0 = 0;  //segK
; 0000 02BB PORTB.1 = 1;
; 0000 02BC PORTB.1 = 0;
; 0000 02BD PORTB.0 = 1;  //segG2
; 0000 02BE PORTB.1 = 1;
; 0000 02BF PORTB.1 = 0;
; 0000 02C0 PORTB.0 = 0;  //segL
; 0000 02C1 PORTB.1 = 1;
; 0000 02C2 PORTB.1 = 0;
; 0000 02C3 PORTB.0 = 0;  //segM
; 0000 02C4 PORTB.1 = 1;
; 0000 02C5 PORTB.1 = 0;
; 0000 02C6 PORTB.0 = 0;  //segN
; 0000 02C7 PORTB.1 = 1;
; 0000 02C8 PORTB.1 = 0;
; 0000 02C9 PORTB.0 = 1;  //segG1
; 0000 02CA PORTB.1 = 1;
; 0000 02CB PORTB.1 = 0;
; 0000 02CC break;
; 0000 02CD 
; 0000 02CE case 9:
; 0000 02CF PORTB.0 = 1;  //segA1
; 0000 02D0 PORTB.1 = 1;
; 0000 02D1 PORTB.1 = 0;
; 0000 02D2 PORTB.0 = 1;  //segA2
; 0000 02D3 PORTB.1 = 1;
; 0000 02D4 PORTB.1 = 0;
; 0000 02D5 PORTB.0 = 1;  //segB
; 0000 02D6 PORTB.1 = 1;
; 0000 02D7 PORTB.1 = 0;
; 0000 02D8 PORTB.0 = 1;  //segC
; 0000 02D9 PORTB.1 = 1;
; 0000 02DA PORTB.1 = 0;
; 0000 02DB PORTB.0 = 1;  //segD2
; 0000 02DC PORTB.1 = 1;
; 0000 02DD PORTB.1 = 0;
; 0000 02DE PORTB.0 = 1;  //segD1
; 0000 02DF PORTB.1 = 1;
; 0000 02E0 PORTB.1 = 0;
; 0000 02E1 PORTB.0 = 0;  //segE
; 0000 02E2 PORTB.1 = 1;
; 0000 02E3 PORTB.1 = 0;
; 0000 02E4 PORTB.0 = 1;  //segF
; 0000 02E5 PORTB.1 = 1;
; 0000 02E6 PORTB.1 = 0;
; 0000 02E7 PORTB.0 = 0;  //segH
; 0000 02E8 PORTB.1 = 1;
; 0000 02E9 PORTB.1 = 0;
; 0000 02EA PORTB.0 = 0;  //segJ
; 0000 02EB PORTB.1 = 1;
; 0000 02EC PORTB.1 = 0;
; 0000 02ED PORTB.0 = 0;  //segK
; 0000 02EE PORTB.1 = 1;
; 0000 02EF PORTB.1 = 0;
; 0000 02F0 PORTB.0 = 1;  //segG2
; 0000 02F1 PORTB.1 = 1;
; 0000 02F2 PORTB.1 = 0;
; 0000 02F3 PORTB.0 = 0;  //segL
; 0000 02F4 PORTB.1 = 1;
; 0000 02F5 PORTB.1 = 0;
; 0000 02F6 PORTB.0 = 0;  //segM
; 0000 02F7 PORTB.1 = 1;
; 0000 02F8 PORTB.1 = 0;
; 0000 02F9 PORTB.0 = 0;  //segN
; 0000 02FA PORTB.1 = 1;
; 0000 02FB PORTB.1 = 0;
; 0000 02FC PORTB.0 = 1;  //segG1
; 0000 02FD PORTB.1 = 1;
; 0000 02FE PORTB.1 = 0;
; 0000 02FF break;
; 0000 0300 
; 0000 0301 case 0:
; 0000 0302 PORTB.0 = 1;  //segA1
; 0000 0303 PORTB.1 = 1;
; 0000 0304 PORTB.1 = 0;
; 0000 0305 PORTB.0 = 1;  //segA2
; 0000 0306 PORTB.1 = 1;
; 0000 0307 PORTB.1 = 0;
; 0000 0308 PORTB.0 = 1;  //segB
; 0000 0309 PORTB.1 = 1;
; 0000 030A PORTB.1 = 0;
; 0000 030B PORTB.0 = 1;  //segC
; 0000 030C PORTB.1 = 1;
; 0000 030D PORTB.1 = 0;
; 0000 030E PORTB.0 = 1;  //segD2
; 0000 030F PORTB.1 = 1;
; 0000 0310 PORTB.1 = 0;
; 0000 0311 PORTB.0 = 1;  //segD1
; 0000 0312 PORTB.1 = 1;
; 0000 0313 PORTB.1 = 0;
; 0000 0314 PORTB.0 = 1;  //segE
; 0000 0315 PORTB.1 = 1;
; 0000 0316 PORTB.1 = 0;
; 0000 0317 PORTB.0 = 1;  //segF
; 0000 0318 PORTB.1 = 1;
; 0000 0319 PORTB.1 = 0;
; 0000 031A PORTB.0 = 0;  //segH
; 0000 031B PORTB.1 = 1;
; 0000 031C PORTB.1 = 0;
; 0000 031D PORTB.0 = 0;  //segJ
; 0000 031E PORTB.1 = 1;
; 0000 031F PORTB.1 = 0;
; 0000 0320 PORTB.0 = 0;  //segK
; 0000 0321 PORTB.1 = 1;
; 0000 0322 PORTB.1 = 0;
; 0000 0323 PORTB.0 = 0;  //segG2
; 0000 0324 PORTB.1 = 1;
; 0000 0325 PORTB.1 = 0;
; 0000 0326 PORTB.0 = 0;  //segL
; 0000 0327 PORTB.1 = 1;
; 0000 0328 PORTB.1 = 0;
; 0000 0329 PORTB.0 = 0;  //segM
; 0000 032A PORTB.1 = 1;
; 0000 032B PORTB.1 = 0;
; 0000 032C PORTB.0 = 0;  //segN
; 0000 032D PORTB.1 = 1;
; 0000 032E PORTB.1 = 0;
; 0000 032F PORTB.0 = 0;  //segG1
; 0000 0330 PORTB.1 = 1;
; 0000 0331 PORTB.1 = 0;
; 0000 0332 break;
; 0000 0333 
; 0000 0334 case 10:      //mengosongkan
; 0000 0335 PORTB.0 = 0;  //segA1
; 0000 0336 PORTB.1 = 1;
; 0000 0337 PORTB.1 = 0;
; 0000 0338 PORTB.0 = 0;  //segA2
; 0000 0339 PORTB.1 = 1;
; 0000 033A PORTB.1 = 0;
; 0000 033B PORTB.0 = 0;  //segB
; 0000 033C PORTB.1 = 1;
; 0000 033D PORTB.1 = 0;
; 0000 033E PORTB.0 = 0;  //segC
; 0000 033F PORTB.1 = 1;
; 0000 0340 PORTB.1 = 0;
; 0000 0341 PORTB.0 = 0;  //segD2
; 0000 0342 PORTB.1 = 1;
; 0000 0343 PORTB.1 = 0;
; 0000 0344 PORTB.0 = 0;  //segD1
; 0000 0345 PORTB.1 = 1;
; 0000 0346 PORTB.1 = 0;
; 0000 0347 PORTB.0 = 0;  //segE
; 0000 0348 PORTB.1 = 1;
; 0000 0349 PORTB.1 = 0;
; 0000 034A PORTB.0 = 0;  //segF
; 0000 034B PORTB.1 = 1;
; 0000 034C PORTB.1 = 0;
; 0000 034D PORTB.0 = 0;  //segH
; 0000 034E PORTB.1 = 1;
; 0000 034F PORTB.1 = 0;
; 0000 0350 PORTB.0 = 0;  //segJ
; 0000 0351 PORTB.1 = 1;
; 0000 0352 PORTB.1 = 0;
; 0000 0353 PORTB.0 = 0;  //segK
; 0000 0354 PORTB.1 = 1;
; 0000 0355 PORTB.1 = 0;
; 0000 0356 PORTB.0 = 0;  //segG2
; 0000 0357 PORTB.1 = 1;
; 0000 0358 PORTB.1 = 0;
; 0000 0359 PORTB.0 = 0;  //segL
; 0000 035A PORTB.1 = 1;
; 0000 035B PORTB.1 = 0;
; 0000 035C PORTB.0 = 0;  //segM
; 0000 035D PORTB.1 = 1;
; 0000 035E PORTB.1 = 0;
; 0000 035F PORTB.0 = 0;  //segN
; 0000 0360 PORTB.1 = 1;
; 0000 0361 PORTB.1 = 0;
; 0000 0362 PORTB.0 = 0;  //segG1
; 0000 0363 PORTB.1 = 1;
; 0000 0364 PORTB.1 = 0;
; 0000 0365 break;
; 0000 0366 */
; 0000 0367 }
_0x18C:
; 0000 0368 
; 0000 0369 
; 0000 036A 
; 0000 036B }
	RJMP _0x187
; 0000 036C }
_0x18F:
	RJMP _0x18F
; .FEND

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x0:
	SBI  0x5,0
	SBI  0x5,1
	CBI  0x5,1
	SBI  0x5,0
	SBI  0x5,1
	CBI  0x5,1
	SBI  0x5,0
	SBI  0x5,1
	CBI  0x5,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1:
	SBI  0x5,0
	SBI  0x5,1
	CBI  0x5,1
	SBI  0x5,0
	SBI  0x5,1
	CBI  0x5,1
	CBI  0x5,0
	SBI  0x5,1
	CBI  0x5,1
	CBI  0x5,0
	SBI  0x5,1
	CBI  0x5,1
	CBI  0x5,0
	SBI  0x5,1
	CBI  0x5,1
	CBI  0x5,0
	SBI  0x5,1
	CBI  0x5,1
	CBI  0x5,0
	SBI  0x5,1
	CBI  0x5,1
	CBI  0x5,0
	SBI  0x5,1
	CBI  0x5,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x2:
	CBI  0x5,0
	SBI  0x5,1
	CBI  0x5,1
	CBI  0x5,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	SBI  0x5,0
	SBI  0x5,1
	CBI  0x5,1
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	CBI  0x5,0
	SBI  0x5,1
	CBI  0x5,1
	SBI  0x5,0
	RET

;RUNTIME LIBRARY

	.CSEG
;END OF CODE MARKER
__END_OF_CODE:
