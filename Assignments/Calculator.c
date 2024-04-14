/*
 * ---------------------
 * Title: Simple Calculator
 * ---------------------
 * Program Details: Perform +,-,*,/ on 2 Digit Positive Numbers
 *                  No Float for Division
 *                  Negatives Shown in 2's Complement
 *  
 * Inputs: RB4-RB7
 * Outputs: RB0-RB3, PORTD
 * Setup: C- Simulator
 * Date: 04/13/2024
 * File Dependencies / Libraries: It is required to include the 
 *                                Configuration Header File 
 * Compiler: xc8, 2.4
 * Author: Chris Campbell
 * Versions:    V1.0: Original
 *              V1.1: 
*/

#include <xc.h> // must have this
#include "C:\Users\HomePC\MPLABXProjects\Calculator.X\Main_Header.h"


#define _XTAL_FREQ 4000000                 // Fosc  frequency for _delay()  library

// Define pins
#define RA			RB0
#define RB			RB1
#define RC			RB2
#define RD			RB3
#define C1			RB4
#define C2			RB5
#define C3			RB6
#define C4			RB7

// Function declarations

void InitKeypad(void);
int GetKey(void);
int ReadSwitches(void);
int GetFirstNumber(void);
int GetSecondNumber(void);
int GetOperator(void);


// Function name: InitKeypad
void InitKeypad(void)
{
    TRISA = 0;
    LATA = 0;
    PORTA =0;
    ANSELA = 0;
    
    TRISB = 0xF0; //Set RB4-RB7 as Inputs
    LATB = 0;
    PORTB = 0;
    ANSELB = 0;
    
    TRISD = 0;
    LATD = 0;
    PORTD =0;
    ANSELD = 0;
    
}

int GetFirstNumber(void)
{
    int temp1 = GetKey();
    
    if (temp1 <= 9){
        int temp2 = GetKey();
         if (temp2 <= 9){
            int temp3 = temp1*10 + temp2;
            return temp3;
        }
    }
}

int GetSecondNumber(void)
{
    int temp1 = GetKey();
    
    if (temp1 <= 9){
        int temp2 = GetKey();
        if (temp2 <= 9){
            int temp3 = temp1*10 + temp2;
            return temp3;
        }
    }  
}

int GetOperator(void)
{
    int op = GetKey();
    return op;
    
}

// Function name: READ_SWITCHES
// Scan all the keypad keys to detect any pressed key.
int ReadSwitches(void)	
{	
	RA = 0; RB = 1; RC = 1; RD = 1; 	//Test Row A

	if (C1==0){
		__delay_ms(250); 
		while (C1==0); 
			int temp = 1; 
			return temp; 
	}
	
	if (C2 == 0){ 
		__delay_ms(250); 
		while (C2==0); 
			int temp = 2;
			return temp; 
	}
	
	if (C3 == 0){
		__delay_ms(250); 
		while (C3==0); 
			int temp = 3;
			return temp; 
	}
	
	if (C4 == 0){ 
		__delay_ms(250); 
		while (C4==0); 
			int temp = 10; //Addition
			return temp;
	}

	RA = 1; RB = 0; RC = 1; RD = 1; 	//Test Row B

	if (C1==0){
		__delay_ms(250); 
		while (C1==0); 
			int temp = 4; 
			return temp; 
	}
	
	if (C2 == 0){ 
		__delay_ms(250); 
		while (C2==0); 
			int temp = 5;
			return temp; 
	}
	
	if (C3 == 0){
		__delay_ms(250); 
		while (C3==0); 
			int temp = 6;
			return temp; 
	}
	
	if (C4 == 0){ 
		__delay_ms(250); 
		while (C4==0); 
			int temp = 11; //Subtraction
			return temp;
	}
	
	RA = 1; RB = 1; RC = 0; RD = 1; 	//Test Row C

	if (C1 == 0){
		__delay_ms(250); 
		while (C1==0); 
			int temp = 7; 
			return temp; 
	}
	
	if (C2 == 0){ 
		__delay_ms(250); 
		while (C2==0); 
			int temp = 8;
			return temp; 
	}
	
	if (C3 == 0){
		__delay_ms(250); 
		while (C3==0); 
			int temp = 9;
			return temp; 
	}
	
	if (C4 == 0){ 
		__delay_ms(250); 
		while (C4==0); 
			int temp = 12; //Multiplication
			return temp;
	}
	
	RA = 1; RB = 1; RC = 1; RD = 0; 	//Test Row D

	if (C1==0){
		__delay_ms(250); 
		while (C1==0); 
			int temp = 13; //Reset
			return temp; 
	}
	
	if (C2 == 0){ 
		__delay_ms(250); 
		while (C2==0); 
			int temp = 0;
			return temp; 
	}
	
	if (C3 == 0){
		__delay_ms(250); 
		while (C3==0); 
			int temp = 14; //Equals
			return temp; 
	}
	
	if (C4 == 0){ 
		__delay_ms(250); 
		while (C4==0); 
			int temp = 15; //Division
			return temp;
	}

	int temp = 16;
	return temp;           	// No Key Pressed
}

// Function name: GetKey
// Read pressed key value from keypad and return its value
int GetKey(void)           	 // Get key from user
{
	int key = 16;              // Assume no key pressed

	while(key==16)              // Wait until a key is pressed
		key = ReadSwitches();   // Scan the keys again and again

	return key;                  //when key pressed then return its value
}

int GetResult(int Operation_REG, int X_Input_REG, int Y_Input_REG){
    switch(Operation_REG){
        int Display_Result_REG = 0;
        case 10:
            Display_Result_REG = (X_Input_REG + Y_Input_REG);
            PORTD = Display_Result_REG;
            PORTA = 0;
            break;
        case 11:
            Display_Result_REG = (X_Input_REG - Y_Input_REG);
            if (Display_Result_REG < 0){
                Display_Result_REG = ~Display_Result_REG+1;
                PORTD = Display_Result_REG;
                PORTA = 4;
                break;
            }
            else{
                PORTD = Display_Result_REG;
                PORTA = 0;
            break; 
            }
        case 12:
            Display_Result_REG = (X_Input_REG * Y_Input_REG); 
            PORTD = Display_Result_REG;
            PORTA = 0;
            break;
        case 15:
            Display_Result_REG = (X_Input_REG / Y_Input_REG);
            PORTD = Display_Result_REG;
            PORTA = 0;
            break;
    }
}

int main()
{
	InitKeypad();
 
	while(1)
	{
            int X_Input_REG = GetFirstNumber();
            PORTD = X_Input_REG;
            PORTA = 1;
            int Operation_REG = GetOperator();
            PORTD = Operation_REG;
            int Y_Input_REG = GetSecondNumber();
            PORTD = Y_Input_REG;
            PORTA = 2;

            if (GetKey() == 14){
               GetResult(Operation_REG, X_Input_REG, Y_Input_REG);      
            }
            while(GetKey() != 13){
                __delay_ms(250);
            }
            PORTD = 0;
            PORTA = 0;
    }
}
