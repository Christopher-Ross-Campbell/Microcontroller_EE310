;-----------------------------
; Title: 
;-----------------------------
; Purpose: 
; Dependencies: 
; Compiler: 
; Author: Chris Campbell 
; OUTPUTS: 
; INPUTS: 
; Versions:
; 	V1.0: today?s date - First version 
;  	V1.2: date - Changes something?.
;-----------------------------


;---------------------
; Initialization
;---------------------
#include "./AssemblyConfig.inc"
#include <xc.inc>

;----------------
; PROGRAM INPUTS
;----------------
	    refTempInput	EQU 17		
	    measuredTempInput 	EQU -19


;----------------
; REGISTERS
;----------------
	    refTempREG 		EQU 0x20
	    measuredTempREG	EQU 0x21 
	    contReg		EQU 0x22

	    refTempDEC0		EQU 0x60
	    refTempDEC1		EQU 0x61
	    refTempDEC2		EQU 0x62
	
	    measuredTempDEC0	EQU 0x70
	    measuredTempDEC1	EQU 0x71
	    measuredTempDEC2	EQU 0x72

;----------------
; PROGRAM OUTPUTS
;----------------
	    HEATER     		EQU 0b00000100
	    COOLER  		EQU 0b00000010
	    NOTHING		EQU 0b00000000
  
;---------------------
; Main Program
;---------------------
	PSECT absdata,abs,ovrld        ; Do not change
	    ORG 0x20
	
	    CLRF	refTempREG 
	    CLRF	measuredTempREG
	    MOVLW	0x00
	    MOVWF	STATUS
	    MOVLW	refTempInput
	    MOVWF	refTempREG
	    MOVLW	measuredTempInput
	    MOVWF	measuredTempREG
	    ADDLW	0x00	
	    BN		NEGATIVE0
	    GOTO	POSITIVE

NEGATIVE0:  MOVLW	measuredTempInput
	    MOVWF	measuredTempREG
	    COMF	measuredTempREG,0
	    INCF	WREG
	    
LOOP_N1:    ADDLW	0b11110110
	    BN		EXIT_N1
	    INCF	measuredTempDEC1
	    GOTO	LOOP_N1
	
EXIT_N1:    ADDLW	10
	    MOVWF	measuredTempDEC0
	    
	    MOVLW	0x00
	    
	    MOVLW	refTempInput
LOOP_N2:    ADDLW	0b11110110
	    BN		EXIT_N2
	    INCF	refTempDEC1
	    GOTO	LOOP_N2
	
EXIT_N2:    ADDLW	10
	    MOVWF	refTempDEC0
	    GOTO	HEAT   
	    
POSITIVE:   MOVLW	refTempInput
LOOP1:	    ADDLW	0b11110110
	    BN		EXIT1
	    INCF	refTempDEC1
	    GOTO	LOOP1
	
EXIT1:	    ADDLW	10
	    MOVWF	refTempDEC0
	
	    MOVLW	0x00
	
	    MOVLW	measuredTempInput
LOOP2:	    ADDLW	0b11110110
	    BN		EXIT2
	    INCF	measuredTempDEC1
	    GOTO	LOOP2
	
EXIT2:	    ADDLW	10
	    MOVWF	measuredTempDEC0
	
	    MOVLW	0x00
	    MOVWF	TRISD
	    MOVWF	STATUS
	    MOVLW	refTempInput
	    MOVWF	refTempREG
	    MOVLW	measuredTempInput
	    MOVWF	measuredTempREG
	    SUBWF	refTempREG,0
	    BTFSC	STATUS,2
	    GOTO	EQUAL
	    BTFSC	STATUS,4
	    GOTO	AC
	    BTFSS	STATUS,4
	    GOTO	HEAT
	
EQUAL:	    MOVLW	0x00
	    MOVWF	contReg
	    MOVLW	NOTHING
	    MOVWF	PORTD
	    GOTO	FINISH
	
AC:	    MOVLW	0x02
	    MOVWF	contReg
	    MOVLW	COOLER
	    MOVWF	PORTD
	    GOTO	FINISH
	
HEAT:	    MOVLW	0x01
	    MOVWF	contReg
	    MOVLW	HEATER
	    MOVWF	PORTD
	    GOTO	FINISH
	    
FINISH:	
	    END

	

	