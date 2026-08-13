

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity uart_new_tb is
  
end entity uart_new_tb;



architecture arch of uart_new_tb is

  signal rst : std_logic;
  signal RsRx : std_logic;
  signal ser_dat : std_logic_vector( 7 downto 0);
  signal clk : std_logic;
  signal ser_valid : std_logic;
  signal clock : std_logic;

  -- simulation clock period
  constant clock_freq : integer := 50000000; --50MHz system clock
  constant clock_period : time    := 1/clock_freq * 1 ns;
  signal stop_the_clock : boolean := false;
  -- serial clock divider for this simulation

  constant baud : integer := 115200;    -- target baud rate
  constant sclk_period : time := (clock_freq / baud) * clock_period; --bit period

  component uart_new is
    generic (
      SYSTEM_CLK_HZ : integer;
      OVER_SAMPLE   : integer;
      BAUD_RATE     : integer);
    port (
      rst       : in  std_logic;
      RsRx      : in  std_logic;
      ser_dat   : out std_logic_vector(7 downto 0);
      ser_valid : out std_logic;
      clk       : in  std_logic);
  end component uart_new;

begin  -- architecture arch

  uart_new_1: entity work.uart_new
    generic map (
      SYSTEM_CLK_HZ => clock_freq,
      BAUD_RATE     => baud)
    port map (
      rst       => rst,
      RsRx      => RsRx,
      ser_dat   => ser_dat,
      ser_valid => ser_valid,
      clk       => clk);

  g_clk : process
  begin
    while not stop_the_clock loop
      clock <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;


end architecture arch;
