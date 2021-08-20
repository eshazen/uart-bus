using SerialPorts

# s = SerialPort( "/dev/ttyUSB1", 9600, 8, "N", 2)
s = SerialPort( "/dev/ttyUSB2", 9600)

#      0      
t = [ "@@@", 
      "A@@", "B@@", "D@@", "H@@", "P@@", "`@@",
      "@A@", "@B@", "@D@", "@H@", "@P@", "@`@",
      "@@A", "@@B", "@@D", "@@H", "@@P", "@@`",
      "\177\177\177" ]

while true
    for v in t
        #    println(v)
        write(s,Char(0x1b))
        write(s,Char(v[1]))
        write(s,Char(v[2]))
        write(s,Char(v[3]))
        #    write(s,'@')
        #    readline()
        sleep(0.05)
    end
end
