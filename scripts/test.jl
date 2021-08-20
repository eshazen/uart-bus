using SerialPorts

# s = SerialPort( "/dev/ttyUSB1", 9600, 8, "N", 2)
s = SerialPort( "/dev/ttyUSB1", 9600)

for i in 1:20
    println(i)
    write(s,Char(0x1b))
    sleep(0.1)
    write(s,Char(0x40+i))
    sleep(0.5)
end
