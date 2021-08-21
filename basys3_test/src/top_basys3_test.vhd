--
-- simple UART receiver example
--
--
-- receive ASCII escape sequence
--    ESC (0x1b) followed by 1-4 uppercase printable characters 0x40-0x5F
--    Output as 18 bits of binary data
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_basys3_test is

  port (
    led  : out std_logic_vector(15 downto 0);
    btnD : in  std_logic;
    RsRx : in  std_logic;
    RsTx : out std_logic;
    clk  : in  std_logic);

end entity top_basys3_test;


architecture arch of top_basys3_test is

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

  signal rst_n     : std_logic;
  signal ser_dat   : std_logic_vector(7 downto 0);
  signal ser_valid : std_logic;

  type param_array_t is array (3 downto 0) of std_logic_vector(5 downto 0);

  signal param_array : param_array_t;

  signal param_ptr : integer range 0 to 3 := 0;

  signal d_out : std_logic_vector(15 downto 0);
  signal k_out : std_logic_vector(1 downto 0);

  signal store : std_logic;

  signal send_data : std_logic_vector(7 downto 0);
  signal send_ena  : std_logic;

begin  -- architecture arch

  rst_n <= not btnD;                    -- reset on "down" button
--  RsTx  <= RsRx;                        -- direct echo

  uart_new_1 : entity work.uart_new
    port map (
      rst       => btnD,
      RsRx      => RsRx,
      ser_dat   => ser_dat,
      ser_valid => ser_valid,
      clk       => clk);

  UART_TX_1 : entity work.uart_tx
    generic map (
      g_CLKS_PER_BIT => (100000000/9600))
    port map (
      i_Clk       => clk,
      i_TX_DV     => send_ena,
      i_TX_Byte   => send_data,
      o_TX_Active => open,
      o_TX_Serial => RsTx,
      o_TX_Done   => open);

  process (clk, rst_n) is
  begin  -- process
    if rst_n = '0' then                 -- asynchronous reset (active low)

      param_ptr <= 0;
      store     <= '0';
      send_ena  <= '0';
      send_data <= (others => '0');

    elsif clk'event and clk = '1' then  -- rising clock edge

      store <= '0';
      send_ena <= '0';

      if store = '1' then
        led <= d_out;
      end if;

      if ser_valid = '1' then

        -- process incoming characters
        if ser_dat(6 downto 0) = "0011011" then  -- ESC starts a new sequence

          param_ptr <= 0;

        elsif ser_dat(6) = '1' then     -- printable character 40-7F

          send_data <= ser_dat;
          send_ena <= '1';

          param_array(param_ptr) <= ser_dat(5 downto 0);

          if param_ptr = 2 then
            store     <= '1';
            param_ptr <= 0;
          else
            param_ptr <= param_ptr + 1;
          end if;
        end if;

      end if;
    end if;
  end process;

  d_out <= param_array(2)(3 downto 0) & param_array(1) & param_array(0);
  k_out <= param_array(2)(5 downto 4);




end architecture arch;
