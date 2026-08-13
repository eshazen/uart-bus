# uart-bus

This is a simple UART server for firmware control. Each
transaction consists of a query followed by a response.  The queries
and responses are always 4 bytes as described below. 

Query:  $ b0 b1 b2

This is a 4-character message which encodes 18 bits, 16 bits of data
and a 2 bit function code (only 1 bit currently used).  For a "write"
the data message is echoed as-is.  For a "read" the returned data is
taken from a 16-bit input port on the top level module.

Where:

```
$ - ASCII 0x24
b0,b1,b2 are ASCII 40-7f with bits 0-5 containing data
These 3 6-bit fields are concatenated to make an 18-bit word.
Bits 0-15 are data, 16,17 are control

 --------- b0 ---------  --------- b1 ---------  --------- b2 ---------
 7  6  5  4  3  2  1  0  7  6  5  4  3  2  1  0  7  6  5  4  3  2  1  0
 -  -  k1 k0 15 14 13 12 -  - 11 10  9  8  7  6  -  -  5  4  3  2  1  0

Control bits are decoded as follows:

k1 k0  function
 0  0  read 16-bit word
 0  1  write 16-bit word
 1  0  reserved
 1  1  reserved
```

## Development Notes

**2026-08-13**

Pretty much starting over.  Folder `ghdl/bus_echo_test` is the latest.

