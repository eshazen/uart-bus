library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity serialize_tb is
--  Port ( );
end serialize_tb;

architecture Behavioral of serialize_tb is

  signal clock   : std_logic;                      -- System clock.
  signal reset   : std_logic;                      -- Active high reset.
  signal divider : std_logic_vector(7 downto 0);   -- Clock Division Factor.
  signal data    : std_logic_vector(31 downto 0);  -- Parallel data.
  signal count   : std_logic_vector(4 downto 0);   -- Bit count 1-32.
  signal dir     : std_logic;                      -- Shift direction.
  signal start   : std_logic;                      -- Start serialization.
  signal busy    : std_logic;                      -- High when busy.
  signal sdata   : std_logic;                      -- Serial data out.
  signal sclk    : std_logic;

  -- simulation clock period
  constant clock_period : time    := 10 ns;
  signal stop_the_clock : boolean := false;
  -- serial clock divider for this simulation
  constant clock_div    : integer := 17;

  constant sclk_period : time := clock_period * clock_div;

begin

  DUT : entity work. serialize
    port map(
      clock   => clock,
      reset   => reset,
      divider => divider,
      data    => data,
      count   => count,
      dir     => dir,
      start   => start,
      busy    => busy,
      sdata   => sdata,
      sclk    => sclk);

  -- Initialisation

  g_stim : process
  begin

    start   <= '0';
    reset   <= '1', '0' after clock_period;
    count   <= "00100";
    --count   <= std_logic_vector(to_unsigned( 4, count'length));
    --data <= X"00000001";
    --data    <= "01101010101010101010101010101001";
    --data    <= "10011001010110010101100101010110";
    --data    <= "10001001101010111100110111101111";
    --data    <= X"BAF00AAA";
    data    <= X"0AAAAAAF";
    divider <= std_logic_vector(to_unsigned(clock_div, divider'length));

    dir     <= '0';                     -- increasing bit order

    wait for clock_period * 10;

    start <= '1', '0' after clock_period;
    -- wait for sclk_period * 14 - clock_period/4;

    -- start <= '1', '0' after clock_period;
    -- wait for sclk_period * 14 - clock_period/4;

    -- --dir <= '1';                         -- decreasing bit order

    -- start <= '1', '0' after clock_period;
    -- wait for sclk_period * 14 - clock_period/4;

    -- start <= '1', '0' after clock_period;
    -- wait for sclk_period * 14 - clock_period/4;

    -- start <= '1', '0' after clock_period;
    -- wait for sclk_period * 14 - clock_period/4;

    -- start <= '1', '0' after clock_period;
    -- wait for sclk_period * 14 - clock_period/4;

    -- start <= '1', '0' after clock_period;
    -- wait for sclk_period * 14 - clock_period/4;

    -- start <= '1', '0' after clock_period;
    -- wait for sclk_period * 14;

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

end Behavioral;
