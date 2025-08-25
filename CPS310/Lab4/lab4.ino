// Lab 4
// Marwa Kousar 
// Student ID: 501159935
// This program uses inline AVR assembly to control a 7-segment display that's wired to Arduino pins D0 through D6. It lights up the correct segments to show the numbers 0 to 9, one at a time. The setup() function sets all the display pins as outputs, and the loop() cycles through each number. After every digit is shown, a clearnum subroutine turns off all the segments before the next number appears. Each number stays on for one second using the delay() function.

void setup() {
  // initialize 7-segment.

  asm("sbi 0x0A, 0"); // Set PD0 (D0, segment a) as output
  asm("sbi 0x0A, 1"); // Set PD1 (D1, segment b) as output
  asm("sbi 0x0A, 2"); // Set PD2 (D2, segment c) as output
  asm("sbi 0x0A, 3"); // Set PD3 (D3, segment d) as output
  asm("sbi 0x0A, 4"); // Set PD4 (D4, segment e) as output
  asm("sbi 0x0A, 5"); // Set PD5 (D5, segment f) as output
  asm("sbi 0x0A, 6"); // Set PD6 (D6, segment g) as output
  asm("rjmp start"); // Jump to the label 'start' at the top of loop()
}

// the loop function runs over and over again forever
void loop() {
  asm("start:"); // Label for looping back to the start
  // ONE
  asm("sbi 0x0B,1"); // Turn on segment b (PD1) for number 1
  asm("sbi 0x0B,2"); // Turn on segment c (PD2) for number 1
  delay(1000); // Wait 1 second
  asm("call clearnum"); // Call subroutine to clear the display

  // TWO
  asm("sbi 0x0B,0"); // Turn on segment a
  asm("sbi 0x0B,1"); // Turn on segment b
  asm("sbi 0x0B,4"); // Turn on segment e
  asm("sbi 0x0B,3"); // Turn on segment d
  asm("sbi 0x0B,6"); // Turn on segment g
  delay(1000); // Wait 1 second
  asm("call clearnum"); // Call subroutine to clear the display

  // THREE
  asm("sbi 0x0B,0"); // Turn on segment a
  asm("sbi 0x0B,1"); // Turn on segment b
  asm("sbi 0x0B,2"); // Turn on segment c
  asm("sbi 0x0B,3"); // Turn on segment d
  asm("sbi 0x0B,6"); // Turn on segment g
  delay(1000); // Wait 1 second
  asm("call clearnum"); // Call subroutine to clear the display
  
  // FOUR
  asm("sbi 0x0B,1"); // Turn on segment b
  asm("sbi 0x0B,2"); // Turn on segment c
  asm("sbi 0x0B,5"); // Turn on segment f
  asm("sbi 0x0B,6"); // Turn on segment g
  delay(1000); // Wait 1 second
  asm("call clearnum"); // Call subroutine to clear the display
  
  // FIVE
  asm("sbi 0x0B,0"); // Turn on segment a
  asm("sbi 0x0B,2"); // Turn on segment c
  asm("sbi 0x0B,3"); // Turn on segment d
  asm("sbi 0x0B,5"); // Turn on segment f
  asm("sbi 0x0B,6"); // Turn on segment g
  delay(1000); // Wait 1 second
  asm("call clearnum"); // Call subroutine to clear the display

  
  // SIX
  asm("sbi 0x0B,0"); // Turn on segment a
  asm("sbi 0x0B,2"); // Turn on segment c
  asm("sbi 0x0B,3"); // Turn on segment d
  asm("sbi 0x0B,4"); // Turn on segment e
  asm("sbi 0x0B,5"); // Turn on segment f
  asm("sbi 0x0B,6"); // Turn on segment g
  delay(1000); // Wait 1 second
  asm("call clearnum"); // Call subroutine to clear the display
  
  // SEVEN
  asm("sbi 0x0B,0"); // Turn on segment a
  asm("sbi 0x0B,1"); // Turn on segment b
  asm("sbi 0x0B,2"); // Turn on segment c
  delay(1000); // Wait 1 second
  asm("call clearnum"); // Call subroutine to clear the display
  
  // EIGHT
  asm("sbi 0x0B,0"); // Turn on segment a
  asm("sbi 0x0B,1"); // Turn on segment b
  asm("sbi 0x0B,2"); // Turn on segment c
  asm("sbi 0x0B,3"); // Turn on segment d
  asm("sbi 0x0B,4"); // Turn on segment e
  asm("sbi 0x0B,5"); // Turn on segment f
  asm("sbi 0x0B,6"); // Turn on segment g
  delay(1000); // Wait 1 second
  asm("call clearnum"); // Call subroutine to clear the display
  
  // NINE
  asm("sbi 0x0B,0"); // Turn on segment a
  asm("sbi 0x0B,1"); // Turn on segment b
  asm("sbi 0x0B,2"); // Turn on segment c
  asm("sbi 0x0B,3"); // Turn on segment d
  asm("sbi 0x0B,5"); // Turn on segment f
  asm("sbi 0x0B,6"); // Turn on segment g
  delay(1000); // Wait 1 second
  asm("call clearnum"); // Call subroutine to clear the display

  // ZERO
  asm("sbi 0x0B,0"); // Turn on segment a
  asm("sbi 0x0B,1"); // Turn on segment b
  asm("sbi 0x0B,2"); // Turn on segment c
  asm("sbi 0x0B,3"); // Turn on segment d
  asm("sbi 0x0B,4"); // Turn on segment e
  asm("sbi 0x0B,5"); // Turn on segment f
  delay(1000); // Wait 1 second
  asm("call clearnum"); // Call subroutine to clear the display
  
  asm("rjmp start");  // Jump back to start label to loop forever

  // clearing subroutine.
  asm("clearnum:"); // Label for subroutine
  asm("cbi 0x0B,0"); // Turn off segment a
  asm("cbi 0x0B,1"); // Turn off segment b
  asm("cbi 0x0B,2"); // Turn off segment c
  asm("cbi 0x0B,3"); // Turn off segment d
  asm("cbi 0x0B,4"); // Turn off segment e
  asm("cbi 0x0B,5"); // Turn off segment f
  asm("cbi 0x0B,6"); // Turn off segment g
  delay(1000); // Wait 1 second
  asm("ret"); // Return from subroutine
}