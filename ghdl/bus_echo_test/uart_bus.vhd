library ieee;
use ieee.std_logic_1164.all;

entity uart_bus is

  generic (
    BAUD_16_DIV : integer := 52);       -- 52 for 115200 baud with 96MHz clock

  port (
    clk          : in  std_logic;                      -- 96MHz system clock
    rst          : in  std_logic;                      -- active high reset (optional)
    uart_ser_tx  : out std_logic;                      -- UART output
    uart_ser_rx  : in  std_logic;                      -- UART input
    --
    msg_rx_data  : out std_logic_vector(15 downto 0);  -- received data
    msg_rx_func  : out std_logic_vector(1 downto 0);   -- received function code
    msg_rx_valid : out std_logic;                      -- received data valid
    --
    msg_tx_data  : in  std_logic_vector(15 downto 0)  -- data to transmit
    );

end entity uart_bus;

architecture arch of uart_bus is

  component uart_bus_tx is
    generic (
      BAUD_16_DIV : integer);
    port (
      clk         : in  std_logic;
      rst         : in  std_logic;
      uart_ser_tx : out std_logic;
      msg_valid   : in  std_logic;
      msg_done    : out std_logic;
      msg_func    : in  std_logic_vector(1 downto 0);
      msg_data    : in  std_logic_vector(15 downto 0));
  end component uart_bus_tx;

  component uart_bus_rx is
    generic (
      BAUD_16_DIV : integer);
    port (
      clk         : in  std_logic;
      rst         : in  std_logic;
      uart_ser_rx : in  std_logic;
      msg_valid   : out std_logic;
      msg_func    : out std_logic_vector(1 downto 0);
      msg_data    : out std_logic_vector(15 downto 0));
  end component uart_bus_rx;

  signal rx_valid : std_logic;
  signal msg_done : std_logic;

  signal func, rx_func : std_logic_vector(1 downto 0);
  signal data, rx_data : std_logic_vector(15 downto 0);

  signal reply : std_logic;

begin  -- architecture arch

  msg_rx_valid <= rx_valid;

  proc: process (clk, rst) is
  begin  -- process proc
    if clk'event and clk = '1' then  -- rising clock edge

      reply <= '0';

      if rx_valid = '1' then
        func <= rx_func;
        data <= rx_data;
        msg_rx_func <= rx_func;
        msg_rx_data <= rx_data;
        reply <= '1';
      end if;
  
    end if;
  end process proc;

  uart_bus_rx_1 : entity work.uart_bus_rx
    generic map (
      BAUD_16_DIV => BAUD_16_DIV)
    port map (
      clk         => clk,
      rst         => rst,
      uart_ser_rx => uart_ser_rx,
      msg_valid   => rx_valid,
      msg_func    => rx_func,
      msg_data    => rx_data);

  uart_bus_tx_1 : entity work.uart_bus_tx
    generic map (
      BAUD_16_DIV => BAUD_16_DIV)
    port map (
      clk         => clk,
      rst         => rst,
      uart_ser_tx => uart_ser_tx,
      msg_valid   => rx_valid,
      msg_done    => msg_done,
      msg_func    => func,
      msg_data    => data);

end architecture arch;
