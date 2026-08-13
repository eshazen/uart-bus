

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity uart_tx_tb is
  
end entity uart_tx_tb;

architecture arch of uart_tx_tb is

  signal rst : std_logic;
  signal ser_dat : std_logic_vector( 7 downto 0);
  signal clk : std_logic;
  signal ser_valid : std_logic;
  signal clock : std_logic;
  signal tx_active, tx_serial, tx_done : std_logic;

--   -- simulation clock period
  constant clock_freq : integer := 50000000; --50MHz system clock
  constant clock_period : time    := 1 sec / clock_freq;
  signal stop_the_clock : boolean := false;
--   -- serial clock divider for this simulation
-- 
--   constant baud : integer := 115200;    -- target baud rate
  -- constant sclk_period : time := (clock_freq / baud) * clock_period; --bit period

  component uart_tx is
    generic (
      g_CLKS_PER_BIT : integer);
    port (
      i_Clk       : in  std_logic;
      i_TX_DV     : in  std_logic;
      i_TX_Byte   : in  std_logic_vector(7 downto 0);
      o_TX_Active : out std_logic;
      o_TX_Serial : out std_logic;
      o_TX_Done   : out std_logic);
  end component uart_tx;

begin  -- architecture arch

  uart_tx_2: entity work.uart_tx
    generic map (
      g_CLKS_PER_BIT => 16)
    port map (
      i_Clk       => clk,
      i_TX_DV     => ser_valid,
      i_TX_Byte   => ser_dat,
      o_TX_Active => tx_active,
      o_TX_Serial => tx_serial,
      o_TX_Done   => tx_done);

  send : process

    begin

      wait until falling_edge(clk);

      ser_dat <= X"55";
      ser_valid <= '0';

      wait until falling_edge(clk);
      ser_valid <= '1';
      wait until falling_edge(clk);
      ser_valid <= '0';
      
      wait for clock_period * 200;
      
      ser_dat <= X"80";
      wait until falling_edge(clk);
      wait until falling_edge(clk);
      ser_valid <= '1';
      wait until falling_edge(clk);
      ser_valid <= '0';
      
      wait for clock_period * 200;

      ser_dat <= X"01";
      wait until falling_edge(clk);
      wait until falling_edge(clk);
      ser_valid <= '1';
      wait until falling_edge(clk);
      ser_valid <= '0';
      
      wait for clock_period * 200;


    end process;      

  g_clk : process

  begin
    clk <= '1';
    wait for clock_period/2;
    clk <= '0';
    wait for clock_period/2;
  end process;


end architecture arch;
