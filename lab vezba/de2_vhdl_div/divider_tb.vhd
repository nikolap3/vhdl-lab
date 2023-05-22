library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity divider_tb is
end;

architecture bench of divider_tb is

  signal clk: std_logic:='1';
  signal reset: std_logic := '0';
  signal a: std_logic_vector(0 to 15);
  signal b: std_logic_vector(0 to 15);
  signal y: std_logic_vector(0 to 15);
  signal y_rem: std_logic_vector(0 to 15);
  signal y_valid: std_logic := '0';

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

	uut: entity work.divider port map (clk => clk, reset => reset, a => a, b => b, y => y, y_rem => y_rem, y_valid => y_valid );

	stimulus: process
	begin
	reset<='1';
	a <= "0000000000000000";
	b <= "0000000000000000";
	wait for 2*clock_period;
	reset<='0';
	wait for 2*clock_period;
	-- Put test bench stimulus code here
	
	a <= "0000000000001011";
	b <= "0000000000000011";
	wait for 30*clock_period;
	
	a <= "1000100010001000";
	b <= "1011000110000011";
	wait for 30*clock_period;
		
	a <= "1000000000001000";
	b <= "0001011110000011";
	wait for 30*clock_period;
	
	a <= "0000000010001000";
	b <= "1011010110000011";
	wait for 30*clock_period;
		
	a <= "1110000000001000";
	b <= "0001011110000011";
	wait for 30*clock_period;
	
	a <= "0000000000001000"; 	-- 8
	b <= "0000000000000011";						-- 3
	wait for 30*clock_period;
	
	a <= "0000000000000011";	-- 3
	b <= "0000000000000010";						-- 2
	wait for 30*clock_period;
	
	a <= "0000000000000110";	-- 6
	b <= "0000000000000010";						-- 2
	wait for 30*clock_period;
	
	a <= "0000000000000111";	-- 7
	b <= "0000000000000011";						-- 3
	wait for 30*clock_period;
	
	a <= "0000000000000111";	-- 8
	b <= "0000000000000001";						-- 1
	wait for 30*clock_period;
	
	a <= "0000000000000110";	-- 6
	b <= "0000000000000011";						-- 3
	wait for 30*clock_period;
	
	a <= "0000000000000010";	-- 2
	b <= "0000000000000001";						-- 1
	wait for 30*clock_period;
	wait;
	
  end process;

  clocking: clk<= not clk after clock_period/2;

end;