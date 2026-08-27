
_display_time:

;MyProject.c,26 :: 		void display_time (unsigned char West_Time , unsigned char South_Time ){
;MyProject.c,27 :: 		West_Unit = West_Time % 10 ;
	MOVLW      10
	MOVWF      R4+0
	MOVF       FARG_display_time_West_Time+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      FLOC__display_time+1
	MOVF       FLOC__display_time+1, 0
	MOVWF      _West_Unit+0
;MyProject.c,28 :: 		West_Ten =  West_Time / 10 ;
	MOVLW      10
	MOVWF      R4+0
	MOVF       FARG_display_time_West_Time+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R0+0, 0
	MOVWF      _West_Ten+0
;MyProject.c,29 :: 		South_Unit = South_Time % 10 ;
	MOVLW      10
	MOVWF      R4+0
	MOVF       FARG_display_time_South_Time+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      FLOC__display_time+0
	MOVF       FLOC__display_time+0, 0
	MOVWF      _South_Unit+0
;MyProject.c,30 :: 		South_Ten =  South_Time / 10 ;
	MOVLW      10
	MOVWF      R4+0
	MOVF       FARG_display_time_South_Time+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R0+0, 0
	MOVWF      _South_Ten+0
;MyProject.c,32 :: 		PORTC = 0x05;
	MOVLW      5
	MOVWF      PORTC+0
;MyProject.c,33 :: 		PORTB = West_Unit | (South_Unit << 4);
	MOVF       FLOC__display_time+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	IORWF      FLOC__display_time+1, 0
	MOVWF      PORTB+0
;MyProject.c,34 :: 		Delay_ms(7);
	MOVLW      19
	MOVWF      R12+0
	MOVLW      45
	MOVWF      R13+0
L_display_time0:
	DECFSZ     R13+0, 1
	GOTO       L_display_time0
	DECFSZ     R12+0, 1
	GOTO       L_display_time0
;MyProject.c,35 :: 		PORTC = 0x0A;
	MOVLW      10
	MOVWF      PORTC+0
;MyProject.c,36 :: 		PORTB = West_Ten | (South_Ten << 4);
	MOVF       _South_Ten+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	IORWF      _West_Ten+0, 0
	MOVWF      PORTB+0
;MyProject.c,37 :: 		Delay_ms(7);
	MOVLW      19
	MOVWF      R12+0
	MOVLW      45
	MOVWF      R13+0
L_display_time1:
	DECFSZ     R13+0, 1
	GOTO       L_display_time1
	DECFSZ     R12+0, 1
	GOTO       L_display_time1
;MyProject.c,38 :: 		}
L_end_display_time:
	RETURN
; end of _display_time

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;MyProject.c,43 :: 		void interrupt(){
;MyProject.c,44 :: 		if(TMR0IF_bit){
	BTFSS      TMR0IF_bit+0, BitPos(TMR0IF_bit+0)
	GOTO       L_interrupt2
;MyProject.c,45 :: 		TMR0IF_bit = 0 ;
	BCF        TMR0IF_bit+0, BitPos(TMR0IF_bit+0)
;MyProject.c,46 :: 		overflow_counter ++ ;
	INCF       _overflow_counter+0, 1
	BTFSC      STATUS+0, 2
	INCF       _overflow_counter+1, 1
;MyProject.c,47 :: 		TMR0 = 12 ;
	MOVLW      12
	MOVWF      TMR0+0
;MyProject.c,48 :: 		if (overflow_counter ==32){
	MOVLW      0
	XORWF      _overflow_counter+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt37
	MOVLW      32
	XORWF      _overflow_counter+0, 0
L__interrupt37:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt3
;MyProject.c,49 :: 		overflow_counter = 0 ;
	CLRF       _overflow_counter+0
	CLRF       _overflow_counter+1
;MyProject.c,50 :: 		second_passed = 1;
	MOVLW      1
	MOVWF      _second_passed+0
;MyProject.c,51 :: 		}
L_interrupt3:
;MyProject.c,52 :: 		}
L_interrupt2:
;MyProject.c,53 :: 		}
L_end_interrupt:
L__interrupt36:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;MyProject.c,56 :: 		void main() {
;MyProject.c,58 :: 		TRISB = 0x00 ; PORTB = 0x00 ;
	CLRF       TRISB+0
	CLRF       PORTB+0
;MyProject.c,59 :: 		TRISC = 0x00 ; PORTC = 0x00 ;
	CLRF       TRISC+0
	CLRF       PORTC+0
;MyProject.c,60 :: 		TRISD = 0xC0 ; PORTD = 0x00 ;
	MOVLW      192
	MOVWF      TRISD+0
	CLRF       PORTD+0
;MyProject.c,61 :: 		GIE_bit = 1  ; second_passed = 1 ;
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
	MOVLW      1
	MOVWF      _second_passed+0
;MyProject.c,62 :: 		OPTION_REG = 0x07; TMR0 = 12;
	MOVLW      7
	MOVWF      OPTION_REG+0
	MOVLW      12
	MOVWF      TMR0+0
;MyProject.c,63 :: 		TMR0IE_bit = 1 ;
	BSF        TMR0IE_bit+0, BitPos(TMR0IE_bit+0)
;MyProject.c,65 :: 		while(1){
L_main4:
;MyProject.c,66 :: 		if(Mode == 0){
	BTFSC      PORTD+0, 7
	GOTO       L_main6
;MyProject.c,67 :: 		Delay_ms(20) ;
	MOVLW      52
	MOVWF      R12+0
	MOVLW      241
	MOVWF      R13+0
L_main7:
	DECFSZ     R13+0, 1
	GOTO       L_main7
	DECFSZ     R12+0, 1
	GOTO       L_main7
	NOP
	NOP
;MyProject.c,68 :: 		while(Mode == 0);
L_main8:
	BTFSC      PORTD+0, 7
	GOTO       L_main9
	GOTO       L_main8
L_main9:
;MyProject.c,69 :: 		Manual = !Manual ;
	MOVF       _Manual+0, 0
	MOVLW      1
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      _Manual+0
;MyProject.c,70 :: 		}
L_main6:
;MyProject.c,71 :: 		if(Manual){
	MOVF       _Manual+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main10
;MyProject.c,72 :: 		display_time(Remaind_time_W, Remaind_time_S);
	MOVF       _Remaind_time_W+0, 0
	MOVWF      FARG_display_time_West_Time+0
	MOVF       _Remaind_time_S+0, 0
	MOVWF      FARG_display_time_South_Time+0
	CALL       _display_time+0
;MyProject.c,73 :: 		if(PORTD.RB6 == 0 ){
	BTFSC      PORTD+0, 6
	GOTO       L_main11
;MyProject.c,74 :: 		Delay_ms(20) ;
	MOVLW      52
	MOVWF      R12+0
	MOVLW      241
	MOVWF      R13+0
L_main12:
	DECFSZ     R13+0, 1
	GOTO       L_main12
	DECFSZ     R12+0, 1
	GOTO       L_main12
	NOP
	NOP
;MyProject.c,75 :: 		while (PORTD.RB6 == 0) ;
L_main13:
	BTFSC      PORTD+0, 6
	GOTO       L_main14
	GOTO       L_main13
L_main14:
;MyProject.c,76 :: 		if(State == WEST_GREEN){
	MOVF       _State+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main15
;MyProject.c,77 :: 		State = WEST_YELLOW ;
	MOVLW      1
	MOVWF      _State+0
;MyProject.c,78 :: 		}
	GOTO       L_main16
L_main15:
;MyProject.c,79 :: 		else if(State == SOUTH_GREEN) {
	MOVF       _State+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_main17
;MyProject.c,80 :: 		State = SOUTH_YELLOW ;
	MOVLW      3
	MOVWF      _State+0
;MyProject.c,81 :: 		}
L_main17:
L_main16:
;MyProject.c,82 :: 		Manual = 0 ;
	CLRF       _Manual+0
;MyProject.c,83 :: 		second_passed = 0 ;
	CLRF       _second_passed+0
;MyProject.c,84 :: 		Enter_State = 1;
	MOVLW      1
	MOVWF      _Enter_State+0
;MyProject.c,85 :: 		}
L_main11:
;MyProject.c,86 :: 		}
	GOTO       L_main18
L_main10:
;MyProject.c,88 :: 		display_time(Remaind_time_W, Remaind_time_S);
	MOVF       _Remaind_time_W+0, 0
	MOVWF      FARG_display_time_West_Time+0
	MOVF       _Remaind_time_S+0, 0
	MOVWF      FARG_display_time_South_Time+0
	CALL       _display_time+0
;MyProject.c,89 :: 		if(second_passed){
	MOVF       _second_passed+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main19
;MyProject.c,90 :: 		second_passed = 0 ;
	CLRF       _second_passed+0
;MyProject.c,92 :: 		switch(State){
	GOTO       L_main20
;MyProject.c,94 :: 		case WEST_GREEN: // West Green  South Red
L_main22:
;MyProject.c,96 :: 		if (Enter_State){
	MOVF       _Enter_State+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main23
;MyProject.c,97 :: 		Remaind_time_W = WEST_GREEN_T ;
	MOVLW      21
	MOVWF      _Remaind_time_W+0
	MOVLW      0
	MOVWF      _Remaind_time_W+1
;MyProject.c,98 :: 		Remaind_time_S = SOUTH_RED_T  ;
	MOVLW      24
	MOVWF      _Remaind_time_S+0
	MOVLW      0
	MOVWF      _Remaind_time_S+1
;MyProject.c,99 :: 		Enter_State = 0 ;
	CLRF       _Enter_State+0
;MyProject.c,100 :: 		}
L_main23:
;MyProject.c,102 :: 		PORTD = 0b00001100 ;
	MOVLW      12
	MOVWF      PORTD+0
;MyProject.c,103 :: 		Remaind_time_W -- ;
	MOVLW      1
	SUBWF      _Remaind_time_W+0, 1
	BTFSS      STATUS+0, 0
	DECF       _Remaind_time_W+1, 1
;MyProject.c,104 :: 		Remaind_time_S -- ;
	MOVLW      1
	SUBWF      _Remaind_time_S+0, 1
	BTFSS      STATUS+0, 0
	DECF       _Remaind_time_S+1, 1
;MyProject.c,106 :: 		if(Remaind_time_W == 0){
	MOVLW      0
	XORWF      _Remaind_time_W+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main39
	MOVLW      0
	XORWF      _Remaind_time_W+0, 0
L__main39:
	BTFSS      STATUS+0, 2
	GOTO       L_main24
;MyProject.c,107 :: 		State = WEST_YELLOW ;
	MOVLW      1
	MOVWF      _State+0
;MyProject.c,108 :: 		Enter_State = 1 ;
	MOVLW      1
	MOVWF      _Enter_State+0
;MyProject.c,109 :: 		}
L_main24:
;MyProject.c,110 :: 		break;
	GOTO       L_main21
;MyProject.c,112 :: 		case WEST_YELLOW: // West Yellow  South Red
L_main25:
;MyProject.c,114 :: 		if (Enter_State){
	MOVF       _Enter_State+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main26
;MyProject.c,115 :: 		Remaind_time_W = WEST_YELLOW_T  ;
	MOVLW      4
	MOVWF      _Remaind_time_W+0
	MOVLW      0
	MOVWF      _Remaind_time_W+1
;MyProject.c,116 :: 		Remaind_time_S = SOUTH_YELLOW_T ;
	MOVLW      4
	MOVWF      _Remaind_time_S+0
	MOVLW      0
	MOVWF      _Remaind_time_S+1
;MyProject.c,117 :: 		Enter_State = 0 ;
	CLRF       _Enter_State+0
;MyProject.c,118 :: 		}
L_main26:
;MyProject.c,120 :: 		PORTD = 0b00001010 ;
	MOVLW      10
	MOVWF      PORTD+0
;MyProject.c,121 :: 		Remaind_time_W -- ;
	MOVLW      1
	SUBWF      _Remaind_time_W+0, 1
	BTFSS      STATUS+0, 0
	DECF       _Remaind_time_W+1, 1
;MyProject.c,122 :: 		Remaind_time_S -- ;
	MOVLW      1
	SUBWF      _Remaind_time_S+0, 1
	BTFSS      STATUS+0, 0
	DECF       _Remaind_time_S+1, 1
;MyProject.c,124 :: 		if(Remaind_time_W == 0){
	MOVLW      0
	XORWF      _Remaind_time_W+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main40
	MOVLW      0
	XORWF      _Remaind_time_W+0, 0
L__main40:
	BTFSS      STATUS+0, 2
	GOTO       L_main27
;MyProject.c,125 :: 		State = SOUTH_GREEN ;
	MOVLW      2
	MOVWF      _State+0
;MyProject.c,126 :: 		Enter_State = 1 ;
	MOVLW      1
	MOVWF      _Enter_State+0
;MyProject.c,127 :: 		}
L_main27:
;MyProject.c,128 :: 		break;
	GOTO       L_main21
;MyProject.c,130 :: 		case SOUTH_GREEN: // West  Red  South Green
L_main28:
;MyProject.c,132 :: 		if (Enter_State){
	MOVF       _Enter_State+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main29
;MyProject.c,133 :: 		Remaind_time_W = WEST_RED_T ;
	MOVLW      16
	MOVWF      _Remaind_time_W+0
	MOVLW      0
	MOVWF      _Remaind_time_W+1
;MyProject.c,134 :: 		Remaind_time_S = SOUTH_GREEN_T ;
	MOVLW      13
	MOVWF      _Remaind_time_S+0
	MOVLW      0
	MOVWF      _Remaind_time_S+1
;MyProject.c,135 :: 		Enter_State = 0 ;
	CLRF       _Enter_State+0
;MyProject.c,137 :: 		}
L_main29:
;MyProject.c,139 :: 		PORTD = 0b00100001 ;
	MOVLW      33
	MOVWF      PORTD+0
;MyProject.c,140 :: 		Remaind_time_W -- ;
	MOVLW      1
	SUBWF      _Remaind_time_W+0, 1
	BTFSS      STATUS+0, 0
	DECF       _Remaind_time_W+1, 1
;MyProject.c,141 :: 		Remaind_time_S -- ;
	MOVLW      1
	SUBWF      _Remaind_time_S+0, 1
	BTFSS      STATUS+0, 0
	DECF       _Remaind_time_S+1, 1
;MyProject.c,143 :: 		if(Remaind_time_S == 0){
	MOVLW      0
	XORWF      _Remaind_time_S+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main41
	MOVLW      0
	XORWF      _Remaind_time_S+0, 0
L__main41:
	BTFSS      STATUS+0, 2
	GOTO       L_main30
;MyProject.c,144 :: 		State = SOUTH_YELLOW ;
	MOVLW      3
	MOVWF      _State+0
;MyProject.c,145 :: 		Enter_State = 1 ;
	MOVLW      1
	MOVWF      _Enter_State+0
;MyProject.c,146 :: 		}
L_main30:
;MyProject.c,147 :: 		break;
	GOTO       L_main21
;MyProject.c,149 :: 		case SOUTH_YELLOW: // West Red  South Yellow
L_main31:
;MyProject.c,150 :: 		if (Enter_State){
	MOVF       _Enter_State+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main32
;MyProject.c,151 :: 		Remaind_time_W = WEST_YELLOW_T  ;
	MOVLW      4
	MOVWF      _Remaind_time_W+0
	MOVLW      0
	MOVWF      _Remaind_time_W+1
;MyProject.c,152 :: 		Remaind_time_S = SOUTH_YELLOW_T  ;
	MOVLW      4
	MOVWF      _Remaind_time_S+0
	MOVLW      0
	MOVWF      _Remaind_time_S+1
;MyProject.c,153 :: 		Enter_State = 0 ;
	CLRF       _Enter_State+0
;MyProject.c,154 :: 		}
L_main32:
;MyProject.c,156 :: 		PORTD = 0b00010001 ;
	MOVLW      17
	MOVWF      PORTD+0
;MyProject.c,157 :: 		Remaind_time_W -- ;
	MOVLW      1
	SUBWF      _Remaind_time_W+0, 1
	BTFSS      STATUS+0, 0
	DECF       _Remaind_time_W+1, 1
;MyProject.c,158 :: 		Remaind_time_S -- ;
	MOVLW      1
	SUBWF      _Remaind_time_S+0, 1
	BTFSS      STATUS+0, 0
	DECF       _Remaind_time_S+1, 1
;MyProject.c,160 :: 		if(Remaind_time_W == 0){
	MOVLW      0
	XORWF      _Remaind_time_W+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main42
	MOVLW      0
	XORWF      _Remaind_time_W+0, 0
L__main42:
	BTFSS      STATUS+0, 2
	GOTO       L_main33
;MyProject.c,161 :: 		State = WEST_GREEN ;
	CLRF       _State+0
;MyProject.c,162 :: 		Enter_State = 1 ;
	MOVLW      1
	MOVWF      _Enter_State+0
;MyProject.c,163 :: 		}
L_main33:
;MyProject.c,164 :: 		break;
	GOTO       L_main21
;MyProject.c,165 :: 		}
L_main20:
	MOVF       _State+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_main22
	MOVF       _State+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_main25
	MOVF       _State+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_main28
	MOVF       _State+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_main31
L_main21:
;MyProject.c,166 :: 		}
L_main19:
;MyProject.c,167 :: 		}
L_main18:
;MyProject.c,168 :: 		}
	GOTO       L_main4
;MyProject.c,169 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
