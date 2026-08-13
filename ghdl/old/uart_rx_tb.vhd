

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity uart_rx_tb is
  
end entity uart_rx_tb;

architecture arch of uart_rx_tb is

  signal rst : std_logic;
  signal RsRx : std_logic;
  signal ser_dat : std_logic_vector( 7 downto 0);
  signal ser_valid : std_logic;
  signal clock : std_logic;

  -- simulation clock period
  constant clock_freq : integer := 50000000; --50MHz system clock
  constant clock_period : time    := 1/clock_freq * 1 ns;
  signal stop_the_clock : boolean := false;
  -- serial clock divider for this simulation


  constant baud : integer := 115200;    -- target baud rate
  constant sclk_period : time := (clock_freq / baud) * clock_period; --bit period
  constant g_CLKS_PER_BIT : integer := 50000000/baud;

  component UART_RX is
    generic (
      g_CLKS_PER_BIT : integer);
    port (
      i_Clk       : in  std_logic;
      i_RX_Serial : in  std_logic;
      o_RX_DV     : out std_logic;
      o_RX_Byte   : out std_logic_vector(7 downto 0));
  end component UART_RX;

begin  -- architecture arch

  UART_RX_1: entity work.UART_RX
    generic map (
      g_CLKS_PER_BIT => g_CLKS_PER_BIT)
    port map (
      i_Clk       => clock,
      i_RX_Serial => RsRx,
      o_RX_DV     => ser_valid,
      o_RX_Byte   => ser_dat);

  g_stim : process
  begin

    rst <= '0';
    RsRx <= '1';
    clock <= '0';

    wait;

  end process;

  g_clk : process
  begin
    while not stop_the_clock loop
      clock <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;


end architecture arch;
