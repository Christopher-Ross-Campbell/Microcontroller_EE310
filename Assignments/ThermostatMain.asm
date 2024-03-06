;-----------------------------
; Title: Thermostat
;-----------------------------
; Purpose: Activate Heating/Cooling/Nothing based on measured temp and ref temp
; Dependencies: AssemblyConfig.inc
; Compiler: MPLABX v6.20
; Author: Chris Campbell 
; OUTPUTS: PORTD
; INPUTS: Static Set Registers
; Versions:
; 	V1.0: 03/05/2024 - First version 
;  	V1.2: 03/06/2024 - Added Additional Comments
;-----------------------------


;---------------------
; Initialization
;---------------------
#include "./AssemblyConfig.inc"
#include <xc.inc>

;----------------
; PROGRAM INPUTS
;----------------
	    refTempInput	EQU 15		
	    measuredTempInput 	EQU 0


;----------------
; REGISTERS
;----------------
	    refTempREG 		EQU 0x20
	    measuredTempREG	EQU 0x21 
	    contReg		EQU 0x22

	    refTempDEC0		EQU 0x62
	    refTempDEC1		EQU 0x61
	    refTempDEC2		EQU 0x60
	
	    measuredTempDEC0	EQU 0x72
	    measuredTempDEC1	EQU 0x71
	    measuredTempDEC2	EQU 0x70

;----------------
; PROGRAM OUTPUTS
;----------------
	    HEATER     		EQU 0b00000010
	    COOLER  		EQU 0b00000100
	    NOTHING		EQU 0b00000000
  
;---------------------
; Main Program
;---------------------
	PSECT absdata,abs,ovrld		    ;Do not change
	    ORG 0x20			    ;Start Program at 0x20
	
	    CLRF	refTempREG	    ;Clear input registers
	    CLRF	measuredTempREG
	    MOVLW	0x00
	    MOVWF	STATUS		    ;Clear STATUS register
	    MOVLW	refTempInput
	    MOVWF	refTempREG
	    MOVLW	measuredTempInput
	    MOVWF	measuredTempREG
	    ADDLW	0x00		    ;Set STATUS N bit if measuredTemp is NEG
	    BN		NEGATIVE0	    ;Branch to negative section 
	    GOTO	POSITIVE	    ;Otherwise jump to positive section

NEGATIVE0:  MOVLW	measuredTempInput   ;Negative Path
	    MOVWF	measuredTempREG
	    COMF	measuredTempREG,0   ;2's Complement of neg. measuredTemp
	    INCF	WREG
	    
LOOP_N1:    ADDLW	0b11110110	    ;Add -10 at start of loop
	    BN		EXIT_N1		    ;Exit loop when N bit is set
	    INCF	measuredTempDEC1    ;Increment tens place for each loop
	    GOTO	LOOP_N1		    ;Loop if not negative 
	
EXIT_N1:    ADDLW	10		    ;Add 10 to restore ones place velue
	    MOVWF	measuredTempDEC0    ;Store ones place value
	    
	    MOVLW	0x00		    ;Clear WREG
	    
	    MOVLW	refTempInput	    ;Move refTemp to WREG
LOOP_N2:    ADDLW	0b11110110	    ;Add -10 at start of loop
	    BN		EXIT_N2		    ;Exit loop when N bit is set
	    INCF	refTempDEC1	    ;Incriment tens place for each loop
	    GOTO	LOOP_N2		    ;Loop if not negative
	
EXIT_N2:    ADDLW	10		    ;Add 10 to restore ones place value
	    MOVWF	refTempDEC0	    ;Store ones place value
	    GOTO	HEAT		    ;GOTO HEAT as negative measured always 
					    ;< refTemp
	    
POSITIVE:   MOVLW	refTempInput	    ;Positive path
LOOP1:	    ADDLW	0b11110110	    ;No 2's Complement needed
	    BN		EXIT1		    ;Decimal register process is same as negative
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
	    MOVWF	TRISD		    ;Set TRISD to output
	    MOVWF	STATUS		    ;Clear STATUS
	    MOVLW	refTempInput
	    MOVWF	refTempREG
	    MOVLW	measuredTempInput
	    MOVWF	measuredTempREG
	    SUBWF	refTempREG,0	    ;Subtract measuredTemp from refTemp
	    BTFSC	STATUS,2	    ;Check zero bit
	    GOTO	EQUAL		    ;GOTO EQUAL if zero bit is set
	    BTFSC	STATUS,4	    ;Check negative bit, skip if clear
	    GOTO	AC		    ;GOTO AC if negative is set
					    ;Otherwise GOTO HEAT
	    
HEAT:	    MOVLW	0x01		    ;HEAT BLOCK
	    MOVWF	contReg		    ;Set contReg to 0x01
	    MOVLW	HEATER
	    MOVWF	PORTD		    ;Turn on PORTD1
	    GOTO	FINISH	    
	    	    
EQUAL:	    MOVLW	0x00		    ;EQUAL BLOCK
	    MOVWF	contReg		    ;Set contReg to 0x00
	    MOVLW	NOTHING		    
	    MOVWF	PORTD		    ;Turn off all PORTD
	    GOTO	FINISH
	
AC:	    MOVLW	0x02		    ;AC BLOCK
	    MOVWF	contReg		    ;Set contReg to 0x02
	    MOVLW	COOLER	    
	    MOVWF	PORTD		    ;Turn on PORTD2
	    GOTO	FINISH
	    
FINISH:	
	    SLEEP
	    END

	

	