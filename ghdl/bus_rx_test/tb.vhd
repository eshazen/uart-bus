
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.uart_tb_pkg.all;

entity tb is

end entity tb;

architecture arch of tb is

  component uart_bus_rx is
    port (
      clk         : in  std_logic;
      rst         : in  std_logic;
      uart_ser_rx : in  std_logic;
      msg_valid   : out std_logic;
      msg_func    : out std_logic_vector(1 downto 0);
      msg_data    : out std_logic_vector(15 downto 0));
  end component uart_bus_rx;

  signal uart_ser_rx   : std_logic;
  signal gp_in, gp_out : std_logic_vector(1 downto 0);
  signal clk           : std_logic;
  signal rst           : std_logic;
  signal msg_valid     : std_logic;
  signal msg_data      : std_logic_vector(15 downto 0);
  signal msg_func      : std_logic_vector(1 downto 0);

  -- simulation clock period
--  constant clock_freq : integer := 96000000; -- 96MHz system clock
  constant clock_freq   : integer := 16000000;  -- 16MHz system clock
  constant clock_period : time    := 1 sec / clock_freq;

  -- baud rate should be 100k
  constant baud_rate : integer := 100000;
  constant bit_time  : time    := 1 ns / baud_rate;

begin  -- architecture arch

  uart_bus_1 : entity work.uart_bus_rx
    generic map (
      BAUD_16_DIV => 10)
    port map (
      clk         => clk,
      rst         => rst,
      uart_ser_rx => uart_ser_rx,
      msg_valid   => msg_valid,
      msg_func    => msg_func,
      msg_data    => msg_data);

  g_clk : process

  begin
    clk <= '1';
    wait for clock_period/2;
    clk <= '0';
    wait for clock_period/2;
  end process;

  stimulus : process
  begin

    uart_ser_rx <= '1';
    rst         <= '1';
    wait for 1 us;
    rst         <= '0';
    wait for 50 us;

    -- Send several bytes at baud_rate baud.
    uart_send(uart_ser_rx, x"99", baud_rate);
    wait for 50 us;
    uart_send(uart_ser_rx, x"24", baud_rate);
    wait for 50 us;
    uart_send(uart_ser_rx, x"00", baud_rate);
    wait for 50 us;
    uart_send(uart_ser_rx, x"01", baud_rate);
    wait for 50 us;
    uart_send(uart_ser_rx, x"02", baud_rate);
    wait for 50 us;
    wait for 50 us;
    uart_send(uart_ser_rx, x"24", baud_rate);
    wait for 50 us;
    uart_send(uart_ser_rx, x"AA", baud_rate);
    wait for 50 us;
    uart_send(uart_ser_rx, x"BB", baud_rate);
    wait for 50 us;
    uart_send(uart_ser_rx, x"CC", baud_rate);
    wait for 50 us;

    -- End simulation
    wait;

  end process;



end architecture arch;
