// Lab 5
// Marwa Kousar
// Student ID:
/*
Overview:
This program uses the Arduino’s ADC (Analog-to-Digital Converter) and digital I/O 
to interface with a joystick and control five LEDs based on the joystick’s position 
and button press. The joystick’s analog X and Y axis values, read from pins A0 and A1, 
are converted into 8-bit digital values ranging from 0 to 255 using the ADC. These values 
indicate the position of the joystick along each axis and are processed using AVR inline 
assembly to determine directional movement. Depending on the direction (up, down, left, or right), 
a corresponding green LED connected to PORTD is lit. Additionally, pressing the joystick button 
activates a red LED. All digital I/O logic is implemented in assembly, while analog reading 
and serial debugging are handled in C. The program runs in an infinite loop, constantly 
reading input and updating outputs in real time.
*/


void analog_init() // Initializes the analog-to-digital converter (ADC) settings
{
  ADCSRA |= (1 << ADEN);  // enable ADC
  ADMUX  |= (1 << REFS0); // Vref AVcc page 255
  ADMUX  |= (1 << ADLAR); // Left justified output for 8bit mode
  ADCSRA |= (1 << ADSC);  // start conversion 1st time will take 25 cycles
}

uint8_t analog8(uint8_t channel) // Reads an 8-bit analog value from the specified channel (e.g., A0 or A1)
{
  ADMUX  &= 0xF0;     //Clearing the last 4 bits of ADMUX
  ADMUX  |= channel;  //Selecting channel (0 = A0, 1 = A1, etc.)
  ADCSRA |= (1 << ADSC); // Start ADC conversion
  while ( ADCSRA & ( 1 << ADSC ) ); // Wait until conversion finishes
  return ADCH;  // Return high byte (8-bit value between 0–255)
}

void setup() {
    Serial.begin(9600); // Start serial communication with 9600 baud rate
    analog_init(); // Initialize analog converter

    // Set PD2–PD6 as outputs for LEDs
    asm("sbi 0x0A, 2"); // Set bit 2 in PORTD for PD2 output
    asm("sbi 0x0A, 3"); // Set bit 3 in PORTD for PD3 output
    asm("sbi 0x0A, 4"); // Set bit 4 in PORTD for PD4 output
    asm("sbi 0x0A, 5"); // Set bit 5 in PORTD for PD5 output
    asm("sbi 0x0A, 6"); // Set bit 6 in PORTD for PD6 output RED LED for button press
    
    // Configure PD7 as input with pull-up resistor (SW pin of joystick)
    asm("cbi 0x0A, 7"); // Clear bit 7 in PORTD for PD7 input
    asm("sbi 0x0B, 7"); // Set pullup resistor for pin 7 in PORTD

}

void loop() 
{

  asm(" start: "); // Start of loop label for rjmp
  // Read joystick's X and Y positions from A0 and A1
  int x_axis = analog8(0);       // Read from A0 (X axis)
  asm(" lds r16, 0x79 ");        // Load 8-bit X value into r16
  int y_axis = analog8(1);       // Read from A1 (Y axis)
  asm(" lds r17, 0x79 ");        // Load 8-bit Y value into r17
  
  // Click button logic here. Should the button LED be on or off?
  asm(" in r18, 0x09 "); // Load PIND into r18
  asm(" andi r18, 0x80 "); // Bit-mask the 7th bit
  asm(" cpi r18, 0x80 "); // Compare with 0x80
  asm(" brne click_on "); // If not zero, branch to click_on

  asm(" cbi 0x0B, 6 "); // Turn off Click LED RED LED (PD6)
  asm(" rjmp click_handled "); //Skip next section
  
  asm(" click_on: ");
  asm(" sbi 0x0B, 6 "); // Turn on LED RED LED (PD6) if button IS pressed

  asm(" click_handled: "); // Label used to jump to after handling the joystick button logic




  // Y Axis handlling
  asm(" cpi r17, 82 ");   //Compare Y axis to 82 (center)
  asm(" breq Y_Not_Moving "); //If equal, don't turn on any Y-direction LED

  asm(" cpi r17, 82");   // ; Compare again
  asm(" brlo Y_Moving_Up "); // If less than 82, joystick is UP

  asm(" cpi r17, 83");   // Compare again
  asm(" brge Y_Moving_Down "); // If greater than or equal to 83, joystick is DOWN
  
  asm(" Y_Moving_Up: "); // joystick up
  asm(" sbi 0x0B, 3 "); // Turn ON UP LED (PD3)
  asm(" cbi 0x0B, 5 "); // Turn OFF DOWN LED (PD5)
  asm(" rjmp y_axis_handled ");  // Jump to end of Y-axis logic after handling UP or DOWN movement

  asm(" Y_Not_Moving: "); // Label for when there is no vertical movement (joystick is centered on Y-axis)
  asm(" cbi 0x0B, 3 "); // Turn OFF UP LED
  asm(" cbi 0x0B, 5 "); // Turn OFF DOWN LED
  asm(" rjmp y_axis_handled "); // Jump to end of Y-axis logic after handling UP or DOWN movement


  asm(" Y_Moving_Down: "); // joystick down
  asm(" cbi 0x0B, 3 "); // Turn OFF UP LED
  asm(" sbi 0x0B, 5 "); // Turn ON DOWN LED
  asm(" rjmp y_axis_handled "); // Jump to end of Y-axis logic after handling UP or DOWN movement
   
 
  asm(" y_axis_handled: "); // Label for handling upward movement on the Y-axis (joystick pushed up)




  //X Axis handling
  asm(" cpi r16, 81 ");  // Compare X axis to 81 (center)
  asm(" breq X_Not_Moving "); // If equal, no X movement

  asm(" cpi r16, 81");  // Compare again
  asm(" brlo X_Moving_Left "); // If less than 81, joystick is LEFT

  asm(" cpi r16, 84");  // Compare again
  asm(" brge X_Moving_Right "); // If greater than or equal to 84, joystick is RIGHT

  asm(" rjmp x_axis_handled "); // Skip to the end if none match
  
  asm(" X_Moving_Left: ");  // Label for handling left movement on the X-axis (joystick pushed left)
  asm(" sbi 0x0B, 2 "); // Turn ON LEFT LED (PD2)
  asm(" cbi 0x0B, 4 "); // Turn OFF RIGHT LED (PD4)
  asm(" rjmp x_axis_handled "); // Jump to the end of X-axis logic to skip remaining checks

  asm(" X_Not_Moving: "); // x not moving
  asm(" cbi 0x0B, 2 "); // Turn OFF LEFT LED
  asm(" cbi 0x0B, 4 "); // Turn OFF RIGHT LED
  asm(" rjmp x_axis_handled "); // Jump to the end of X-axis logic to skip remaining checks


  asm(" X_Moving_Right: "); // joystick right
  asm(" cbi 0x0B, 2 "); // Turn OFF LEFT LED
  asm(" sbi 0x0B, 4 "); // Turn ON RIGHT LED
  asm(" rjmp x_axis_handled "); // Jump to the end of X-axis logic to skip remaining checks
    
  asm(" x_axis_handled: "); // marking the end of X-axis logic — used after handling LEFT/RIGHT/NONE

  
  // You can use this serial code for handy debugging.
    // It will let you observe the values coming out of your ADC.
  Serial.print("< "); // Prints the opening bracket for joystick X, Y values in serial monitor (for debugging)
  Serial.print(x_axis); // Print X value
  Serial.print(", "); // Prints the comma for joystick X, Y values in serial monitor (for debugging)
  Serial.print(y_axis); // Print Y value
  Serial.println(" >"); // Prints the closing bracket for joystick X, Y values in serial monitor (for debugging)
  delay(2); // Small delay to slow things down
  asm(" end: ");
  asm(" rjmp start "); // Loop back to the top
}
   
