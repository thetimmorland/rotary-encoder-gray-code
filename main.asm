;
; DoubleDabblePOV.asm
;
; Created: 2018-01-09 8:41:58 AM
; Author : Tim
;

; PORTC: display driver control
; PORTB: pov transitor control
; PORTD: rotary encoder input

.def input = r16
.def bcdLow = r17
.def bcdHigh = r18
.def counter = r19

.org 0x0000
rjmp reset ; jump over lookup table

; lookup table for graycode to binary convertion
; take graycode input and treat it as binary
; use binary as index to look up conversion
.org 0x0002
greyTable:
	.db 0b0000, 0b0001, 0b0011, 0b010
	.db 0b0111, 0b0110, 0b0100, 0b0101
	.db 0b1111, 0b1110, 0b1100, 0b1101
	.db 0b1000, 0b1001, 0b1011, 0b1010

reset:
	; set 4 LSB of PORTD to output
	ldi r16, 0xF
	out DDRC, r16

	; set 3 LSB of PORTB to output
	ldi r16, 0x7
	out DDRB, r16

	; enable pullup on PORTD[4:1]
	ldi r16, 0xF << 1
	out PORTD, r16

convertGrey:
	in ZL, PIND ; read rotary switch into ZL
	com ZL ; complement because pullups are used on input
	
	; remove data from floating pins
	lsr ZL
	andi ZL, 0xF

	; add offset for greyTable to Z
	ldi ZH, HIGH (greyTable << 1)
	adiw Z, LOW (greyTable << 1)

	lpm input, Z ; fetch converted reading

; convert reading to BCD
doubleDabble:
	ldi counter, 8

	clr bcdLow
	clr bcdHigh

nextBit:	
	lsl input
	rol bcdLow
	rol bcdHigh

	dec counter
	breq display

	swap bcdLow
	cpi bcdLow, 0x50
	swap bcdLow
	brlo testTens

	subi bcdLow, -0x3

testTens:
	cpi bcdLow, 0x50
	brlo nextBit

	subi bcdLow, -0x30
	rjmp nextBit

; POV on three seven-segments, driven by 4511 IC
display:
	; display ones digit
	out PORTC, bcdLow
	sbi PORTB, 0
	rcall delayms
	cbi PORTB, 0

	; display tens digit
	swap bcdLow
	out PORTC, bcdLow
	swap bcdLow
	sbi PORTB, 1
	rcall delayms
	cbi PORTB, 1

	; display hundreds digit
	out PORTC, bcdHigh
	sbi PORTB, 2
	rcall delayms
	cbi PORTB, 2

	; re-read encoder
	rjmp convertGray

; Generated by delay loop calculator
; at http://www.bretmulvey.com/avrdelay.html
;
; Delay 8 000 cycles
; 1ms at 8.0 MHz

delayms:
    ldi  r19, 11
    ldi  r20, 99
L1: dec  r20
    brne L1
    dec  r19
    brne L1
    ret