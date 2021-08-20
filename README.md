# uart-bus

This is a simple UART interface for firmware control.

Protocol:

ESC b0 b1 b2

Where:

```
ESC - ASCII escape (0x1b)
b0,b1,b2 are ASCII 40-7f with bits 0-5 containing data
These 3 6-bit fields are concatenated to make an 18-bit word.
Bits 0-15 are data, 16,17 are control

 --------- b2 ---------  --------- b1 ---------  --------- b0 ---------  
 7  6  5  4  3  2  1  0  7  6  5  4  3  2  1  0  7  6  5  4  3  2  1  0  
 -  -  k1 k0 15 14 13 12 -  - 11 10  9  8  7  6  -  -  5  4  3  2  1  0

Control bits are decoded as follows:

k1 k0  function
 0  0  read from address specified in bits 0-15
 0  1  write to address specified in bits 0-15
 1  0  
 1  1
 