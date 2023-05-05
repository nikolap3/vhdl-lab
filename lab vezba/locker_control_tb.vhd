library IEEE;
use IEEE.std_logic_1164.all;

entity locker_control_tb is
end locker_control_tb;

architecture rts of locker_control_tb is

	signal num_value : std_logic_vector (0 to 3) :="0000";
	signal num_valid : std_logic :='0';
	signal cmd_cancel : std_logic :='0';
	signal cmd_ok : std_logic :='0';
	signal reset : std_logic :='1';
	signal clk : std_logic :='1';
	signal Tclk : time := 20 ns;
	
	signal lock : std_logic;
	signal error : std_logic;

begin

	clk_gen : clk<= not clk after Tclk/2;
	
	dut: entity work.locker_control port map(
													reset => reset,
													clk=> clk,
													lock=>lock,
													error=>error,
													num_value=>num_value,
													num_valid=>num_valid,
													cmd_cancel=>cmd_cancel,
													cmd_ok=>cmd_ok
												);
												
	stimulus: process is
	begin
		wait for 3* Tclk;
		reset<='0';
		wait for 3* Tclk;
		reset<='1';
		wait for 3* Tclk;
		reset<='0';
		-- Zaključavanje
		wait for 2* Tclk;
		cmd_ok<='1';
		wait for 2* Tclk;
		cmd_ok<='0';
		wait for 2* Tclk;
		num_value<="1001";--9
		num_valid<='1';
		wait for 5*Tclk;
		num_valid<='0';
		wait for 5*Tclk;
		num_value<="0010";--2
		num_valid<='1';
		wait for 5*Tclk;
		num_valid<='0';
		wait for 5*Tclk;
		num_value<="0101";--5
		num_valid<='1';
		wait for 5*Tclk;
		num_valid<='0';
		wait for 5*Tclk;
		num_value<="0111";--7
		num_valid<='1';
		wait for 5*Tclk;
		num_valid<='0';
		wait for 5*Tclk;
		num_valid<='0';
		wait for 2* Tclk;
		cmd_ok<='1';
		wait for 2* Tclk;
		cmd_ok<='0';
		wait for 5 * Tclk;
		-- Neuspešan pokušaj
		num_value<="1001";
		num_valid<='1';
		wait for 5*Tclk;
		num_valid<='0';
		wait for 5*Tclk;
		num_value<="0010";
		num_valid<='1';
		wait for 5*Tclk;
		num_valid<='0';
		wait for 5*Tclk;
		num_value<="0101";
		num_valid<='1';
		wait for 5*Tclk;
		num_valid<='0';
		wait for 2* Tclk;
		cmd_ok<='1';
		wait for 3* Tclk;
		cmd_ok<='0';
		wait for 2* Tclk;
		--post error uspeh
		num_value<="0010";
		num_valid<='1';
		wait for 5*Tclk;
		num_valid<='0';
		wait for 5*Tclk;
		num_value<="0101";
		num_valid<='1';
		wait for 5*Tclk;
		num_valid<='0';
		wait for 5*Tclk;
		num_value<="0111";
		num_valid<='1';
		wait for 5*Tclk;
		num_valid<='0';
		wait for 2* Tclk;
		cmd_ok<='1';
		wait for 1* Tclk;
		cmd_ok<='0';
		wait for 10 * Tclk;
		wait for 30 * Tclk;
		wait;
	end process;

end rts;