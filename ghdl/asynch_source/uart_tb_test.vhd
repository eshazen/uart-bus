library ieee;
use ieee.std_logic_1164.all;

use work.uart_tb_pkg.all;

entity uart_tb_test is
end entity;

architecture sim of uart_tb_test is

    signal uart_tx : std_logic := '1';
    constant baud_rate : integer := 115200;

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
        wait for 1 us;

        -- Send several bytes at baud_rate baud.
        uart_send(uart_tx, x"55", baud_rate);
        wait for 50 us;
        uart_send(uart_tx, x"AA", baud_rate);
        wait for 50 us;
        uart_send(uart_tx, x"c1", baud_rate);
        wait for 50 us;
        uart_send(uart_tx, x"83", baud_rate);
        wait for 50 us;
        -- End simulation
        wait;

    end process;

end architecture;
