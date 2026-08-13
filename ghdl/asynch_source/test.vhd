### `uart_tb_pkg.vhd`

```vhdl
library ieee;
use ieee.std_logic_1164.all;

package uart_tb_pkg is

    -- Transmit one UART byte.
    --
    -- tx        : UART output signal
    -- data      : byte to transmit, LSB first
    -- baud_rate : baud rate in bits/sec
    --
    -- Format: 8 data bits, no parity, 1 stop bit (8-N-1)

    procedure uart_send(
        signal   tx        : out std_logic;
        constant data      : in  std_logic_vector(7 downto 0);
        constant baud_rate : in  positive
    );

end package uart_tb_pkg;


package body uart_tb_pkg is

    procedure uart_send(
        signal   tx        : out std_logic;
        constant data      : in  std_logic_vector(7 downto 0);
        constant baud_rate : in  positive
    ) is

        constant BIT_TIME : time := 1 sec / baud_rate;

    begin

        -- Start bit
        tx <= '0';
        wait for BIT_TIME;

        -- Data bits, LSB first
        for i in 0 to 7 loop
            tx <= data(i);
            wait for BIT_TIME;
        end loop;

        -- Stop bit
        tx <= '1';
        wait for BIT_TIME;

    end procedure uart_send;

end package body uart_tb_pkg;
```

### Example testbench

```vhdl
library ieee;
use ieee.std_logic_1164.all;

use work.uart_tb_pkg.all;

entity tb is
end entity;

architecture sim of tb is

    signal uart_tx : std_logic := '1';

begin

    -- Device under test would be connected to uart_tx here.
    --
    -- dut : entity work.my_uart_receiver
    --     port map (
    --         rx => uart_tx,
    --         ...
    --     );

    stimulus : process
    begin

        -- Allow the UART line to settle in the idle state.
        wait for 10 us;

        -- Send several bytes at 115200 baud.
        uart_send(uart_tx, x"55", 115200);
        uart_send(uart_tx, x"AA", 115200);
        uart_send(uart_tx, x"12", 115200);
        uart_send(uart_tx, x"A7", 115200);

        -- Send ASCII "Hello"
        uart_send(uart_tx, x"48", 115200); -- H
        uart_send(uart_tx, x"65", 115200); -- e
        uart_send(uart_tx, x"6C", 115200); -- l
        uart_send(uart_tx, x"6C", 115200); -- l
        uart_send(uart_tx, x"6F", 115200); -- o

        -- End simulation
        wait;

    end process;

end architecture;
```

### Resulting waveform

For `uart_send(uart_tx, x"55", 115200)`, the waveform is:

```text
       idle       start          data bits (LSB first)       stop
        1            0          1 0 1 0 1 0 1 0                1
___________        __    __    __    __    __    __    _________
           |______|  |__|  |__|  |__|  |__|  |__|  |__|
              1 bit     8 data bits                         1 bit

                  <-------- 86.806 us -------->
                         10 bits @ 115200
```

Each call to `uart_send()` blocks until the entire byte has been transmitted, so you can write test sequences naturally:

```vhdl
uart_send(uart_tx, x"01", 115200);
wait for 100 us;
uart_send(uart_tx, x"02", 115200);
wait for 1 ms;
uart_send(uart_tx, x"03", 115200);
```

This version deliberately uses **8-N-1**. If you need it, the package can readily be extended to support **configurable data-bit count, parity, stop bits, and a procedure for transmitting arbitrary-length byte arrays or strings**.
