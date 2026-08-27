#line 1 "D:/Electroncis/2nd Year/Trannig Project/Embedded System/Digital Traffic Light/With Multiplixer/MyProject.c"
#line 17 "D:/Electroncis/2nd Year/Trannig Project/Embedded System/Digital Traffic Light/With Multiplixer/MyProject.c"
unsigned int overflow_counter = 0 , Remaind_time_W =  21  , Remaind_time_S =  24  ;

char second_passed , Manual = 0 , ChangeRequest = 0;

char State =  0  , Enter_State = 1 ;

unsigned char West_Unit , West_Ten , South_Unit , South_Ten ;


void display_time (unsigned char West_Time , unsigned char South_Time ){
 West_Unit = West_Time % 10 ;
 West_Ten = West_Time / 10 ;
 South_Unit = South_Time % 10 ;
 South_Ten = South_Time / 10 ;

 PORTC = 0x05;
 PORTB = West_Unit | (South_Unit << 4);
 Delay_ms(7);
 PORTC = 0x0A;
 PORTB = West_Ten | (South_Ten << 4);
 Delay_ms(7);
}




void interrupt(){
 if(TMR0IF_bit){
 TMR0IF_bit = 0 ;
 overflow_counter ++ ;
 TMR0 = 12 ;
 if (overflow_counter ==32){
 overflow_counter = 0 ;
 second_passed = 1;
 }
 }
}


void main() {

 TRISB = 0x00 ; PORTB = 0x00 ;
 TRISC = 0x00 ; PORTC = 0x00 ;
 TRISD = 0xC0 ; PORTD = 0x00 ;
 GIE_bit = 1 ; second_passed = 1 ;
 OPTION_REG = 0x07; TMR0 = 12;
 TMR0IE_bit = 1 ;

 while(1){
 if( PORTD.RB7  == 0){
 Delay_ms(20) ;
 while( PORTD.RB7  == 0);
 Manual = !Manual ;
 }
 if(Manual){
 display_time(Remaind_time_W, Remaind_time_S);
 if(PORTD.RB6 == 0 ){
 Delay_ms(20) ;
 while (PORTD.RB6 == 0) ;
 if(State ==  0 ){
 State =  1  ;
 }
 else if(State ==  2 ) {
 State =  3  ;
 }
 Manual = 0 ;
 second_passed = 0 ;
 Enter_State = 1;
 }
 }
 else{
 display_time(Remaind_time_W, Remaind_time_S);
 if(second_passed){
 second_passed = 0 ;

 switch(State){

 case  0 :

 if (Enter_State){
 Remaind_time_W =  21  ;
 Remaind_time_S =  24  ;
 Enter_State = 0 ;
 }

 PORTD = 0b00001100 ;
 Remaind_time_W -- ;
 Remaind_time_S -- ;

 if(Remaind_time_W == 0){
 State =  1  ;
 Enter_State = 1 ;
 }
 break;

 case  1 :

 if (Enter_State){
 Remaind_time_W =  4  ;
 Remaind_time_S =  4  ;
 Enter_State = 0 ;
 }

 PORTD = 0b00001010 ;
 Remaind_time_W -- ;
 Remaind_time_S -- ;

 if(Remaind_time_W == 0){
 State =  2  ;
 Enter_State = 1 ;
 }
 break;

 case  2 :

 if (Enter_State){
 Remaind_time_W =  16  ;
 Remaind_time_S =  13  ;
 Enter_State = 0 ;

 }

 PORTD = 0b00100001 ;
 Remaind_time_W -- ;
 Remaind_time_S -- ;

 if(Remaind_time_S == 0){
 State =  3  ;
 Enter_State = 1 ;
 }
 break;

 case  3 :
 if (Enter_State){
 Remaind_time_W =  4  ;
 Remaind_time_S =  4  ;
 Enter_State = 0 ;
 }

 PORTD = 0b00010001 ;
 Remaind_time_W -- ;
 Remaind_time_S -- ;

 if(Remaind_time_W == 0){
 State =  0  ;
 Enter_State = 1 ;
 }
 break;
 }
 }
 }
 }
}
