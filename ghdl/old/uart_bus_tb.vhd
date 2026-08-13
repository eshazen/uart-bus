
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity uart_bus_tb is
--  Port ( );
end uart_bus_tb;

architecture Behavioral of uart_bus_tb is

  signal clock   : std_logic;                      -- System clock.
  signal reset   : std_logic;                      -- Active high reset.

  signal ser_rx : std_logic;
  signal ser_tx : std_logic;
  signal led : std_logic_vector( 15 downto 0);

  -- simulation clock period
  constant clock_freq : integer := 50000000; --50MHz system clock
-- this doesn't work in ghdl
--  constant clock_period : time    := 1/clock_freq * 1 ns;
  constant clock_period : time    := 20 ns;
  signal stop_the_clock : boolean := false;
  -- serial clock divider for this simulation

  constant baud : integer := 115200;    -- target baud rate
  constant sclk_period : time := (clock_freq / baud) * clock_period; --bit period

begin

  uart_bus_1: entity work.uart_bus
    port map (
      led  => led,
      btnD => reset,
      RsRx => ser_rx,
      RsTx => ser_tx,
      clk  => clock);

--  g_stim : process
--  begin
--
--    ser_rx <= '1';
--    reset   <= '1', '0' after clock_period;
--
--    wait for 10 * clock_period;
--
--    wait;
--
--  end process;        

  g_clk : process
  begin
    while not stop_the_clock loop
      clock <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end Behavioral;
