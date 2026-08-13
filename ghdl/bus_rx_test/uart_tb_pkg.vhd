

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
