library IEEE;
use IEEE.std_logic_1164.all;

entity locker_tb is
end locker_tb;

architecture RTL of locker_tb is

	signal signal_in : std_logic := '0';
	signal clk :  std_logic :='1';
	signal reset :  std_logic :='1';
	
	
	signal num_value :  std_logic_vector(0 to 3);
	signal num_valid :  std_logic;
	signal cmd_ok :  std_logic;
	signal cmd_cancel : std_logic;
	constant Tclk : time := 20 ns;
	
	signal lock : std_logic;
	signal error : std_logic;

begin

	clk_gen : clk<= not clk after Tclk/2;
	
	Dut1: entity work.locker_control port map(
													reset => reset,
													clk=> clk,
													lock=>lock,
													error=>error,
													num_value=>num_value,
													num_valid=>num_valid,
													cmd_cancel=>cmd_cancel,
													cmd_ok=>cmd_ok
												);
	Dut2: entity work.locker_decode_cmd port map(
													reset => reset,
													clk=> clk,
													signal_in=>signal_in,
													num_value=>num_value,
													num_valid=>num_valid,
													cmd_cancel=>cmd_cancel,
													cmd_ok=>cmd_ok
												);
	stimulus: process
	begin
		wait for 3* Tclk;
		reset<='0';
		wait for 2* Tclk;
		-- komanda ok
		signal_in<='1';
		wait for 11* Tclk;
		signal_in<='0';
		wait for 1* Tclk;
		-- cifra 5
		signal_in<='1';
		wait for 5* Tclk;
		signal_in<='0';
		wait for 2* Tclk;
		-- cifra 0
		signal_in<='1';
		wait for 10* Tclk;
		signal_in<='0';
		wait for 2* Tclk;
		-- cifra 2
		signal_in<='1';
		wait for 2* Tclk;
		signal_in<='0';
		wait for 2* Tclk;
		-- cifra 1
		signal_in<='1';
		wait for 1* Tclk;
		signal_in<='0';
		wait for 1* Tclk;
		-- komanda ok
		signal_in<='1';
		wait for 11* Tclk;
		signal_in<='0';
		wait for 1* Tclk;
		--lozinka je 021
		-- cifra 2
		signal_in<='1';
		wait for 2* Tclk;
		signal_in<='0';
		wait for 2* Tclk;
		
		-- komanda cancel
		signal_in<='1';
		wait for 12* Tclk;
		signal_in<='0';
		wait for 2* Tclk;
		-- komanda nepostojoća
		signal_in<='1';
		wait for 15* Tclk;
		signal_in<='0';
		wait for 2* Tclk;
		
		-- cifra 5
		signal_in<='1';
		wait for 5* Tclk;
		signal_in<='0';
		wait for 2* Tclk;
		-- cifra 0
		signal_in<='1';
		wait for 10* Tclk;
		signal_in<='0';
		wait for 2* Tclk;
		-- cifra 2
		signal_in<='1';
		wait for 2* Tclk;
		signal_in<='0';
		wait for 2* Tclk;
		-- komanda ok
		signal_in<='1';
		wait for 11* Tclk;
		signal_in<='0';
		wait for 20* Tclk;
		--insert error here
		
		
		-- cifra 0
		signal_in<='1';
		wait for 10* Tclk;
		signal_in<='0';
		wait for 2* Tclk;
		-- cifra 2
		signal_in<='1';
		wait for 2* Tclk;
		signal_in<='0';
		wait for 2* Tclk;
		-- cifra 1
		signal_in<='1';
		wait for 1* Tclk;
		signal_in<='0';
		wait for 1* Tclk;
		-- komanda ok
		signal_in<='1';
		wait for 11* Tclk;
		signal_in<='0';
		wait for 1* Tclk;
		wait;
	end process;
end RTL;