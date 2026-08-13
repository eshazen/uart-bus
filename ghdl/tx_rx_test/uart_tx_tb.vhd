-- uart_tx_tb.vhd
-- testbench for UART Tx + Rx
--

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
  signal rx_valid : std_logic;
  signal rx_dat : std_logic_vector( 7 downto 0);
  

--   -- simulation clock period
  constant clock_freq : integer := 50000000; --50MHz system clock
  constant clock_period : time    := 1 sec / clock_freq;

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

  component uart_new is
    generic (
      g_BAUD_DIV : integer);
    port (
      rst       : in  std_logic;
      RsRx      : in  std_logic;
      ser_dat   : out std_logic_vector(7 downto 0);
      ser_valid : out std_logic;
      clk       : in  std_logic);
  end component uart_new;

begin  -- architecture arch

  uart_tx_2: entity work.uart_tx
    generic map (
      g_CLKS_PER_BIT => 16)  -- 16 to match oversampling in Rx
    port map (
      i_Clk       => clk,
      i_TX_DV     => ser_valid,
      i_TX_Byte   => ser_dat,
      o_TX_Active => tx_active,
      o_TX_Serial => tx_serial,
      o_TX_Done   => tx_done);


  uart_new_1: entity work.uart_new
    generic map (
      g_BAUD_DIV => 1)
    port map (
      rst       => rst,
      RsRx      => tx_serial,
      ser_dat   => rx_dat,
      ser_valid => rx_valid,
      clk       => clk);

  send : process

    begin

      rst <= '1';
      wait until falling_edge(clk);
      wait until falling_edge(clk);
      rst <= '0';
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
