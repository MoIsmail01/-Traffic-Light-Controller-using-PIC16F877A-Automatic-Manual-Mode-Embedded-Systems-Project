//  The States (4)
#define WEST_GREEN   0
#define WEST_YELLOW  1
#define SOUTH_GREEN  2
#define SOUTH_YELLOW 3

 //    The Time For each State
#define WEST_GREEN_T     21
#define WEST_YELLOW_T     4
#define WEST_RED_T       16
#define SOUTH_GREEN_T    13
#define SOUTH_YELLOW_T    4
#define SOUTH_RED_T      24

#define Mode PORTD.RB7

unsigned int overflow_counter = 0 , Remaind_time_W = WEST_GREEN_T , Remaind_time_S = SOUTH_RED_T ;

char second_passed , Manual = 0 , ChangeRequest = 0;

char State = WEST_GREEN , Enter_State = 1 ;

unsigned char West_Unit , West_Ten , South_Unit , South_Ten ;


void display_time (unsigned char West_Time , unsigned char South_Time ){
     West_Unit = West_Time % 10 ;
     West_Ten =  West_Time / 10 ;
     South_Unit = South_Time % 10 ;
     South_Ten =  South_Time / 10 ;

     PORTC = 0x05;
     PORTB = West_Unit | (South_Unit << 4);
     Delay_ms(7);
     PORTC = 0x0A;
     PORTB = West_Ten | (South_Ten << 4);
     Delay_ms(7);
}



// ISR Interrupt Service Routine
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
    GIE_bit = 1  ; second_passed = 1 ;
    OPTION_REG = 0x07; TMR0 = 12;
    TMR0IE_bit = 1 ;

    while(1){
      if(Mode == 0){
              Delay_ms(20) ;
              while(Mode == 0);
              Manual = !Manual ;
      }
      if(Manual){
          display_time(Remaind_time_W, Remaind_time_S);
          if(PORTD.RB6 == 0 ){
              Delay_ms(20) ;
              while (PORTD.RB6 == 0) ;
              if(State == WEST_GREEN){
                  State = WEST_YELLOW ;
              }
              else if(State == SOUTH_GREEN) {
                  State = SOUTH_YELLOW ;
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

                case WEST_GREEN: // West Green  South Red

                    if (Enter_State){
                        Remaind_time_W = WEST_GREEN_T ;
                        Remaind_time_S = SOUTH_RED_T  ;
                        Enter_State = 0 ;
                    }
//                    display_time(Remaind_time_W, Remaind_time_S);
                    PORTD = 0b00001100 ;
                    Remaind_time_W -- ;
                    Remaind_time_S -- ;

                    if(Remaind_time_W == 0){
                        State = WEST_YELLOW ;
                        Enter_State = 1 ;
                    }
                    break;

                case WEST_YELLOW: // West Yellow  South Red

                    if (Enter_State){
                        Remaind_time_W = WEST_YELLOW_T  ;
                        Remaind_time_S = SOUTH_YELLOW_T ;
                        Enter_State = 0 ;
                    }
//                    display_time(Remaind_time_W, Remaind_time_S);
                    PORTD = 0b00001010 ;
                    Remaind_time_W -- ;
                    Remaind_time_S -- ;

                    if(Remaind_time_W == 0){
                        State = SOUTH_GREEN ;
                        Enter_State = 1 ;
                    }
                    break;

                case SOUTH_GREEN: // West  Red  South Green

                    if (Enter_State){
                        Remaind_time_W = WEST_RED_T ;
                        Remaind_time_S = SOUTH_GREEN_T ;
                        Enter_State = 0 ;

                    }
//                    display_time(Remaind_time_W, Remaind_time_S);
                    PORTD = 0b00100001 ;
                    Remaind_time_W -- ;
                    Remaind_time_S -- ;

                    if(Remaind_time_S == 0){
                        State = SOUTH_YELLOW ;
                        Enter_State = 1 ;
                    }
                    break;

                case SOUTH_YELLOW: // West Red  South Yellow
                    if (Enter_State){
                        Remaind_time_W = WEST_YELLOW_T  ;
                        Remaind_time_S = SOUTH_YELLOW_T  ;
                        Enter_State = 0 ;
                    }
//                    display_time(Remaind_time_W, Remaind_time_S);
                    PORTD = 0b00010001 ;
                    Remaind_time_W -- ;
                    Remaind_time_S -- ;

                    if(Remaind_time_W == 0){
                        State = WEST_GREEN ;
                        Enter_State = 1 ;
                    }
                    break;
                    }
        }
      }
   }
}
























/*#define WEST_GREEN   0
#define WEST_YELLOW  1
#define SOUTH_GREEN  2
#define SOUTH_YELLOW 3

#define WEST_GREEN_T     20
#define WEST_YELLOW_T     3
#define WEST_RED_T       15
#define SOUTH_GREEN_T    12
#define SOUTH_YELLOW_T    3
#define SOUTH_RED_T      23

#define Mode     PORTD.RB7
#define NextBtn  PORTD.RB6


volatile unsigned int overflow_10ms = 0;
volatile char passed_10ms = 0;

unsigned int Remaind_time_W = WEST_GREEN_T, Remaind_time_S = SOUTH_RED_T;
char repet, Manual = 0;
char State = 0, Enter_State = 1;
unsigned char West_Unit, West_Ten, South_Unit, South_Ten;


void display_time(unsigned char West_Time, unsigned char South_Time){
     West_Unit  = West_Time % 10;
     West_Ten   = West_Time / 10;
     South_Unit = South_Time % 10;
     South_Ten  = South_Time / 10;

     for(repet = 0; repet < 10; repet++){
         PORTC = 0x05;
         PORTB = West_Unit | (South_Unit << 4);
         while(!passed_10ms);
         passed_10ms = 0;

         PORTC = 0x0A;
         PORTB = West_Ten | (South_Ten << 4);
         while(!passed_10ms);
         passed_10ms = 0;
     }
}


void load_state(char st){
    switch(st){
        case WEST_GREEN:
            Remaind_time_W = WEST_GREEN_T;
            Remaind_time_S = SOUTH_RED_T;
            PORTD = 0b00001100;
            break;

        case WEST_YELLOW:
            Remaind_time_W = WEST_YELLOW_T;
            Remaind_time_S = SOUTH_YELLOW_T;
            PORTD = 0b00001010;
            break;

        case SOUTH_GREEN:
            Remaind_time_W = WEST_RED_T;
            Remaind_time_S = SOUTH_GREEN_T;
            PORTD = 0b00100001;
            break;

        case SOUTH_YELLOW:
            Remaind_time_W = WEST_YELLOW_T;
            Remaind_time_S = SOUTH_YELLOW_T;
            PORTD = 0b00010001;
            break;
    }
}


// Interrupt Service Routine
void interrupt(){
    if(TMR0IF_bit){
        TMR0IF_bit = 0;
        TMR0 = 12;

        overflow_10ms++;
        if(overflow_10ms == 3){
            overflow_10ms = 0;
            passed_10ms = 1;
        }
    }
}


void main() {

    TRISB = 0x00; PORTB = 0x00;
    TRISC = 0x00; PORTC = 0x00;
    TRISD = 0xC0; PORTD = 0x00;

    OPTION_REG = 0x07;
    TMR0 = 12;
    TMR0IE_bit = 1;
    GIE_bit = 1;

    load_state(State);

    while(1){


        if(Mode == 0){
            Delay_ms(20);
            if(Mode == 0){
                while(Mode == 0);
                Manual = !Manual;
                Enter_State = 1;
            }
        }

        if(Manual){
            if(Enter_State){
                load_state(State);
                Enter_State = 0;
            }

            display_time(Remaind_time_W, Remaind_time_S);

            if(NextBtn == 0){
                Delay_ms(20);
                if(NextBtn == 0){
                    while(NextBtn == 0);
                if(State == WEST_GREEN) {
                    State = WEST_YELLOW ;
                }
                else if(PORTB.RB0 == 0 && State == SOUTH_GREEN) {
                    State = SOUTH_YELLOW ;
                }
                    Enter_State = 1;
                }
            }
        }
        else{

            if(Enter_State){
                load_state(State);
                Enter_State = 0;
            }

            display_time(Remaind_time_W, Remaind_time_S);
            Remaind_time_W--;
            Remaind_time_S--;

            switch(State){
                case WEST_GREEN:
                    if(Remaind_time_W == 0){ State = WEST_YELLOW;  Enter_State = 1; }
                    break;

                case WEST_YELLOW:
                    if(Remaind_time_W == 0){ State = SOUTH_GREEN;  Enter_State = 1; }
                    break;

                case SOUTH_GREEN:
                    if(Remaind_time_S == 0){ State = SOUTH_YELLOW; Enter_State = 1; }
                    break;

                case SOUTH_YELLOW:
                    if(Remaind_time_W == 0){ State = WEST_GREEN;   Enter_State = 1; }
                    break;
            }
        }
    }
}*/