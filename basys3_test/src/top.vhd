--
-- simple UART receiver example
--
--
-- receive ASCII escape sequence
--    ESC (0x1b) followed by 1-4 uppercase printable characters 0x40-0x5F
--    Output as 24 bits of binary data
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity top is

  port (
    led  : out std_logic_vector(15 downto 0);
    btnD : in  std_logic;
    RsRx : in  std_logic;
    RsTx : out std_logic;
    clk  : in  std_logic);

end entity top;


architecture arch of top is

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

  signal rst_n : std_logic;
  signal ser_dat : std_logic_vector(7 downto 0);
  signal ser_valid : std_logic;

  type param_array_t is array (3 downto 0) of std_logic_vector(4 downto 0);

  signal param_array : param_array_t;

  signal param_ptr : integer range 0 to 3 := 0;


begin  -- architecture arch

  rst_n <= not btnD;                    -- reset on "down" button
  RsTx <= RsRx;

  uart_new_1: entity work.uart_new
    port map (
      rst       => btnD,
      RsRx      => RsRx,
      ser_dat   => ser_dat,
      ser_valid => ser_valid,
      clk       => clk);

  process (clk, rst_n) is
  begin  -- process
    if rst_n = '0' then                 -- asynchronous reset (active low)

      param_ptr <= 0;

    elsif clk'event and clk = '1' then  -- rising clock edge
      if ser_valid = '1' then

--        led(6 downto 0) <= ser_dat(6 downto 0);

        -- process incoming characters
        if ser_dat(6 downto 0) = x"1b" then -- ESC starts a new sequence

          param_ptr <= 0;

        elsif ser_dat(6 downto 5) = "10" then -- printable character 40-5F

          param_array( param_ptr) <= ser_dat(4 downto 0);
          param_ptr <= param_ptr + 1;

--          led(13 downto 7) <= ser_dat(6 downto 0);

        end if;

      end if;
    end if;
  end process;

  led(4 downto 0) <= param_array(0);
  led(9 downto 5) <= param_array(1);
  led(14 downto 10) <= param_array(2);

end architecture arch;
