library ieee;
use ieee.std_logic_1164.all;
use work.uart_tb_pkg.all;

entity tb is

end entity tb;

architecture arch of tb is

  component uart_bus is
    generic (
      BAUD_16_DIV : integer);
    port (
      clk          : in  std_logic;
      rst          : in  std_logic;
      uart_ser_tx  : out std_logic;
      uart_ser_rx  : in  std_logic;
      msg_rx_data  : out std_logic_vector(15 downto 0);
      msg_rx_func  : out std_logic_vector(1 downto 0);
      msg_rx_valid : out std_logic;
      msg_tx_data  : in  std_logic_vector(15 downto 0));
  end component uart_bus;

  -- simulation clock period
  constant clock_freq : integer := 96000000; -- 96MHz system clock
  --constant clock_freq   : integer := 16000000;  -- 16MHz system clock
  constant clock_period : time    := 1 sec / clock_freq;

  -- baud rate should be 100k
  -- constant baud_rate : integer := 100000;
  constant baud_rate : integer := 115200;

  signal clk          : std_logic;
  signal rst          : std_logic;
  signal uart_ser_tx  : std_logic;
  signal uart_ser_rx  : std_logic;
  signal msg_rx_data  : std_logic_vector(15 downto 0);
  signal msg_rx_func  : std_logic_vector(1 downto 0);
  signal msg_rx_valid : std_logic;
  signal msg_tx_data  : std_logic_vector(15 downto 0) := X"00FF";
  signal msg_tx_func  : std_logic_vector(1 downto 0);

begin  -- architecture arch

  g_clk : process

  begin
    clk <= '1';
    wait for clock_period/2;
    clk <= '0';
    wait for clock_period/2;
  end process;

  stimulus : process
  begin

    rst         <= '1';
    uart_ser_rx <= '1';

    wait for 1 us;
    rst <= '0';
    wait for 50 us;


--    uart_send(uart_ser_rx, x"99", baud_rate);
--    wait for 50 us;

--    -- Send several bytes at baud_rate baud.
--    uart_send(uart_ser_rx, x"99", baud_rate);
--    wait for 50 us;
--    uart_send(uart_ser_rx, x"24", baud_rate);
--    wait for 50 us;
--    uart_send(uart_ser_rx, x"00", baud_rate);
--    wait for 50 us;
--    uart_send(uart_ser_rx, x"00", baud_rate);
--    wait for 50 us;
--    uart_send(uart_ser_rx, x"00", baud_rate);
--    wait for 150 us;

    msg_send(uart_ser_rx, X"1234", "01", baud_rate);

    wait for 150 us;

    msg_send(uart_ser_rx, X"dead", "00", baud_rate);

--    wait for 50 us;
--    uart_send(uart_ser_rx, x"24", baud_rate);
--    wait for 50 us;
--    uart_send(uart_ser_rx, x"AA", baud_rate);
--    wait for 50 us;
--    uart_send(uart_ser_rx, x"BB", baud_rate);
--    wait for 50 us;
--    uart_send(uart_ser_rx, x"CC", baud_rate);

    -- End simulation
    wait;

  end process;

  uart_bus_1 : entity work.uart_bus
    generic map (
      BAUD_16_DIV => 52)
    port map (
      clk          => clk,
      rst          => rst,
      uart_ser_tx  => uart_ser_tx,
      uart_ser_rx  => uart_ser_rx,
      msg_rx_data  => msg_rx_data,
      msg_rx_func  => msg_rx_func,
      msg_rx_valid => msg_rx_valid,
      msg_tx_data  => msg_tx_data);

end architecture arch;
