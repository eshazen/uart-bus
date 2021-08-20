#
# transmit 5-bit serial data

import serial
import time



def sendBin(ser,val):
    # pack 20 bits into escape sequence
    pkt = bytearray()           # create empty byte array
    pkt.append( 0x1b)           # start with ESC
    
    pkt.append( 0x40 + (val & 0x1f))
    pkt.append( 0x40 + ((val>>5) & 0x1f) )
    pkt.append( 0x40 + ((val>>10) & 0x1f) )
    pkt.append( 0x40 + ((val>>15) & 0x1f) )
    ser.write( pkt)
    


# connect to the Arduino via the serial port
# change the serial port name as required (to i.e. 'COM6' if on windows)
ser = serial.Serial( '/dev/ttyUSB0', 9600)

for i in range(15):
    b = 1<<i
    sendBin( ser, b)
    time.sleep( 0.1)

print( "Done")
