library IEEE;
use IEEE.std_logic_1164.all;

entity traffic_light_tb is
end traffic_light_tb;

architecture tr of traffic_light_tb is
	
	signal reset : std_logic :='1';
	signal clk : std_logic :='1';
	signal Tclk : time := 125 ns;
	
	signal rc,yc,gc,rp,gp : std_logic;
	
begin
	
	clk_gen : clk<= not clk after Tclk/2;
	
	DUT : entity work.traffic_light port map(
												reset=>reset,
												clk=>clk,
												rc=>rc,
												yc=>yc,
												gc=>gc,
												rp=>rp,
												gp=>gp
												);
	
	
	Stimulus : Process
	begin
		wait for 3*Tclk;
		reset<='0';
		wait for 25*Tclk;
		reset<='1';
		wait for 3*Tclk;
		reset<='0';
		wait;
	end Process;
	
end tr;