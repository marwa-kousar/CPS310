// Lab 6
// Marwa Kousar

#include "pitches.h" // Includes note-frequency definitions (NOTE_C3 = 131 Hz, etc.)
#define BUZZER_CLOCK 16000000/8 // Define the buzzer timer clock frequency (16 MHz / 8 due to prescaler)

void initTimer(void) 
{
  TCCR1A = (1 << COM1A1) | (1 << WGM11);   // Set Timer1 to use non-inverting PWM on OC1A (Pin 9), and enable part of Fast PWM mode
  TCCR1B = (1 << WGM13)  | (1 << WGM12)  | (1 << CS11); // Complete Fast PWM mode (TOP = ICR1) and set clock prescaler to divide by 8
}

void tone(uint16_t freq) 
{
  asm("sbi 0x04, 1");  // Set bit 1 of DDRB (0x04) to make Pin 9 an output (PB1 = OC1A)
  ICR1 = BUZZER_CLOCK/freq; // Set TOP value for Timer1 to get desired frequency
  OCR1A = ICR1*3/4; // Set duty cycle to 75% for consistent sound volume
}

void mute(void) 
{
  asm(" cbi 0x04, 1 "); // Clear bit 1 of DDRB to make Pin 9 an input (turn off PWM pin)
  asm(" cbi 0x05, 1 "); // Clear bit 1 of PORTB to ensure pin is low (no signal to buzzer)
}


void setup() 
{ 
  initTimer(); // Configure Timer1 for PWM output
}

void loop() 
{
  // Define the sequence of notes (frequencies) for the melody
  uint16_t melody[] = { 
    NOTE_G3, NOTE_E3, NOTE_C3, 
    NOTE_G2, NOTE_G3, NOTE_E3, NOTE_C3, 
    NOTE_E3, 0, NOTE_C3, 0,
    NOTE_E3, 0,
    NOTE_D3, NOTE_C3, NOTE_C3, NOTE_D3, NOTE_C3, NOTE_A2, NOTE_C3, 0,
    NOTE_A2, NOTE_C3, NOTE_C3, NOTE_C3, NOTE_E3, NOTE_F3, NOTE_G3, 0
    };
    // Corresponding durations: 4 = quarter note, 8 = eighth note, 2 = half note, etc.
  uint8_t noteDurations[] = { 
    2, 4, 4, 
    4, 4, 4, 4, 
    4, 4, 4, 4,  
    2, 4,
    4, 4, 8, 8, 4, 4, 4, 2,
    4, 4, 8, 8, 4, 4, 4, 2,
    };

  // Loop through each note in the melody
  for (int noteID = 0; noteID < 29; noteID++) 
  {
    int freq = melody[noteID]; // Get the current note's frequency
    if (freq == 0) mute(); // If frequency is 0, treat it as a rest (no tone)
    else tone(freq); // Otherwise, play the tone at the given frequency
    uint16_t noteDuration = 1000/noteDurations[noteID]; // Calculate duration in milliseconds (1000ms for whole note / 4 = 250ms)
    delay(noteDuration); // Keep the tone playing for that duration
    mute(); // Stop the tone after note duration
    uint16_t muteDuration = noteDuration * 3/10; // Short pause between notes (30% of the note duration)
    delay(muteDuration);  // Delay during the silent gap between notes
  }
  delay(500); // Wait 0.5 seconds before repeating the melody
}
