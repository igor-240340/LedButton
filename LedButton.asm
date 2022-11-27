.include "m328def.inc"

.def tmp = r16
.def ledArray = r20

.equ START_PIN = 0                      ; Start button pin
.equ STOP_PIN = 1

.org 0x0
            rjmp Init

Init:       ldi ledArray, 0b11111110
            sec
            set
            ser tmp
            out DDRB, tmp               ; PORTB out
            out PORTB, tmp
            clr tmp
            out DDRD, tmp               ; PORTD in
            ldi tmp, 0b00000011
            out PORTD, tmp              ; Pull-up

WaitStart:  sbic PIND, START_PIN
            rjmp WaitStart

Loop:       out PORTB, ledArray
            ldi r19, 100                ; 1

Dec0:       ldi r17, 246                ; 1 + (r19 - 1)
Dec1:       ldi r18, 26                 ; [1 + (r17 - 1)] * r19
Dec2:       dec r18                     ; r18 * r17 * r19
            brne Dec2                   ; (r18 * 2 - 1) * r17 * r19
            dec r17                     ; r17 * r19
            brne Dec1                   ; (r17 * 2 - 1) * r19
            dec r19                     ; r19
            brne Dec0                   ; r19 * 2 - 1

            sbic PIND, STOP_PIN
            rjmp M
            rjmp WaitStart

M:          ser tmp
            out PORTB, tmp
            brts LeftShift
            sbrs ledArray, 0
            set
            ror ledArray
            rjmp Loop

LeftShift:  sbrs ledArray, 7
            clt
            rol ledArray
            rjmp Loop
