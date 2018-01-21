# rotary-encoder-gray-code

## Challenge 2. Rotary Encoder: Gray Code.
You have been provided with a mechanical rotary encoder that places its 4-bit Gray Code on four pins (8-4-2-1) each routed through a fifth common pin (C). In this challenge you are to develop AVR Assembly code that will read and display the four bit output of the encoder on your Double Dabble prototype. Note: You MUST use the Convert>Display blocks that we developed in class together last Thursday. This Challenge requires that you add an Input block to complete the trio.

## Task.
Wire the output of your encoder into the Arduino digital pins 1-4 (avoiding pin 0 as it complicates matters) such that encoder weights 8-4-2-1 map to the Ardiuino's digital pins 4-3-2-1 (PORTD). Since there is only a single common pin on the encoder, pull down or pull up resistors (your choice) ARE required so the output doesn't float.
Create an ATMEL Studio 7 Project entitled GrayCodeChallenge and the GrayCodeChallenge.asm source file that reads the encoder's output, sends it through your DoubleDabble algorithm, and continously displays the output on your seven-segment display.

Rather than try to implement a Gray Code to Binary Conversion algorithm, for the purpose of this single period challenge, you are encouraged to place the binary equivalents of the Gray Codes in a table (array) at the start of your code (much the same as we did for the Hex Animation Project practice exercise) and simply look up the equivalent binary value before sending it through to the rest of your Double Dabble algorithm. (If you are sufficiently motivated in the days ahead, take on the additional challenges of Binary↔Gray Code conversions)