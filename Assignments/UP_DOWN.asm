;-----------------------------
; Title: Seven Segment UP/DOWN Counter
;-----------------------------
; Purpose: Design a Seven-Segment Counter to count up/down 0 to F (in Hex)
; Dependencies: AssemblyConfig.inc
; Compiler: MPLABX v6.20
; Author: Chris Campbell 
; OUTPUTS: PORDD
; INPUTS: PORTA
; Versions:
; 	V1.0: 03/27/2024 - First Draft Minimal Comments
;  	V1.2: 
;-----------------------------


;---------------------
; Initialization
;---------------------
#include "./AssemblyConfig.inc"
#include <xc.inc>

;----------------
; PROGRAM INPUTS
;----------------
	   
	Inner_loop   EQU 255 // in decimal
	Outer_loop   EQU 255
	Outmost_loop EQU 3
	

;----------------
; REGISTERS
;----------------
	
	REG20 EQU 0x20   
	REG21 EQU 0x21
	REG22 EQU 0x22
	
   
	CNTR EQU 0x11
	

;----------------
; PROGRAM OUTPUTS
;----------------
	    
  
;---------------------
; Main Program
;---------------------
	PSECT absdata,abs,ovrld		    ;Do not change
	
	ORG 0x20	;Start Program at 0x20
		
_initialization: 
	RCALL _setupPortA
	RCALL _setupPortD

	MOVLW 0x3F
	MOVWF 0x00
	MOVLW 0x06
	MOVWF 0x01
	MOVLW 0x5B
	MOVWF 0x02
	MOVLW 0x4F
	MOVWF 0x03
	MOVLW 0x66
	MOVWF 0x04
	MOVLW 0x6D
	MOVWF 0x05
	MOVLW 0x7D
	MOVWF 0x06
	MOVLW 0x07
	MOVWF 0x07
	MOVLW 0x7F
	MOVWF 0x08
	MOVLW 0x67
	MOVWF 0x09
	MOVLW 0x77
	MOVWF 0x0A
	MOVLW 0x7C
	MOVWF 0x0B
	MOVLW 0x39
	MOVWF 0x0C
	MOVLW 0x5E
	MOVWF 0x0D
	MOVLW 0x79
	MOVWF 0x0E
	MOVLW 0x71
	MOVWF 0x0F
	
	MOVLW 0x00
	MOVWF CNTR

RESET_0:
	LFSR  0,0x00
	MOVFF INDF0,PORTD
	MOVLW 0x00
	MOVWF CNTR
	CALL loopDelay
	
	
MAIN_LOOP:
	MOVLW 0x00
	MOVWF STATUS
	
	MOVFF PORTA,WREG
	XORLW 0x01
	BZ    COUNT_UP
	MOVFF PORTA,WREG
	XORLW 0x02
	BZ    COUNT_DOWN
	MOVFF PORTA,WREG
	XORLW 0x03
	BZ    RESET_0
	GOTO  MAIN_LOOP
	NOP
COUNT_UP:
	MOVFF POSTINC0,PORTD
	CALL loopDelay
	MOVLW 0x00
	MOVWF STATUS
	INCF CNTR
	MOVLW 0x10
	XORWF CNTR,0
	BTFSC STATUS,2
	RCALL INC_RESET
	GOTO MAIN_LOOP

COUNT_DOWN:
	MOVLW 0x00
	MOVWF STATUS
	DECF CNTR,1
	BTFSC STATUS,4
	RCALL DEC_RESET
	DECF FSR0
	MOVFF INDF0,PORTD
	CALL loopDelay 
	GOTO MAIN_LOOP


	
DEC_RESET:
	LFSR 0,0x10
	MOVLW 0x0F
	MOVWF CNTR
	RETURN
INC_RESET:
	LFSR 0,0x00
	MOVLW 0x00
	MOVWF CNTR
	RETURN
	
;-----The Delay Subroutine    
loopDelay: 
    MOVLW       Inner_loop
    MOVWF       REG20
    MOVLW       Outer_loop
    MOVWF       REG21
    MOVLW       Outmost_loop ; outmost loop
    MOVWF       REG22
_loop1:
    DECF        REG20,1
    BNZ         _loop1
    MOVLW       Inner_loop ; Re-initialize the inner loop for when the outer loop decrements.
    MOVWF       REG20
    DECF        REG21,1 // outer loop
    BNZ        _loop1
    
    MOVLW       Inner_loop ; Re-initialize the inner loop for when the outer loop decrements.
    MOVWF       REG20
    MOVLW       Outer_loop ; Re-initialize the inner loop for when the outer loop decrements.
    MOVWF       REG21
    DECF        REG22,1 // outer loop
    BNZ        _loop1
    RETURN
    
_setupPortA:
    BANKSEL	PORTA ;
    CLRF	PORTA ;Init PORTA
    BANKSEL	LATA ;Data Latch
    CLRF	LATA ;
    BANKSEL	ANSELA ;
    CLRF	ANSELA ;digital I/O
    BANKSEL	TRISA ;
    MOVLW	0b11111111 ;Set RA[7:0] as inputs
    MOVWF	TRISA 
    RETURN
 
_setupPortD:
    BANKSEL	PORTD ;
    CLRF	PORTD ;Init PORTD
    BANKSEL	LATD ;Data Latch
    CLRF	LATD ;
    BANKSEL	ANSELD ;
    CLRF	ANSELD ;digital I/O
    BANKSEL	TRISD ;
    MOVLW	0b00000000 ;Set RD[7:0] as outputs
    MOVWF	TRISD 
    RETURN    