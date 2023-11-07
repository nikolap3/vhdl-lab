library IEEE;
use IEEE.std_logic_1164.all;

entity kombinacija_tb is
end kombinacija_tb;

architecture tr of kombinacija_tb is
	
	signal reset : std_logic :='1';
	signal clk : std_logic :='1';
	signal odaberi : std_logic :='0';
	signal nazad : std_logic :='0';
	signal napred : std_logic :='0';
	signal Tclk : time := 125 ns;
	
	signal otvori,greska : std_logic;
	signal cifra : std_logic_vector (0 to 2);
	
begin

	clk_gen : clk<= not clk after Tclk/2;
	
	DUT : entity work.kombinacija port map(
												reset=>reset,
												clk=>clk,
												odaberi=>odaberi,
												nazad=>nazad,
												napred=>napred,
												otvori=>otvori,
												greska=>greska,
												cifra=>cifra
												);
	
	Stimulus : Process
		begin
			wait for 3*Tclk;
			reset<='0';
			wait for Tclk;
			
			
			odaberi <= '1'; --izabrana 0
			wait for Tclk;
			odaberi <= '0';
			wait for Tclk;
			
			
			napred <= '1'; --na 1
			wait for Tclk;
			napred <= '0';
			wait for Tclk;
			napred <= '1'; -- na 2
			wait for Tclk;
			napred <= '0';
			wait for Tclk;
			napred <= '1'; -- na 3
			wait for Tclk;
			napred <= '0';
			wait for Tclk;
			napred <= '1'; -- na 4
			wait for Tclk;
			napred <= '0';
			wait for Tclk;
			napred <= '1'; -- na 5
			wait for Tclk;
			napred <= '0';
			wait for Tclk;
			
			odaberi <= '1'; --izabrana 5
			wait for Tclk;
			odaberi <= '0';
			wait for Tclk;
			
			nazad <= '1'; --na 4
			wait for Tclk;
			nazad <= '0';
			wait for Tclk;
			nazad <= '1'; -- na 3
			wait for Tclk;
			nazad <= '0';
			wait for Tclk;
			nazad <= '1'; -- na 2
			wait for Tclk;
			nazad <= '0';
			wait for Tclk;
			
			odaberi <= '1'; --izabrana 2
			wait for Tclk;
			odaberi <= '0';
			wait for Tclk;
			
			napred <= '1'; --na 3
			wait for Tclk;
			napred <= '0';
			wait for Tclk;
			
			odaberi <= '1'; --izabrana 3 (0523 (netačno))
			wait for Tclk;
			odaberi <= '0';
			wait for Tclk;
			
			wait for 8 * 2 * Tclk;
			
			napred <= '1'; --na 4
			wait for Tclk;
			napred <= '0';
			wait for Tclk;
			napred <= '1'; -- na 5
			wait for Tclk;
			napred <= '0';
			wait for Tclk;
			napred <= '1'; -- na 6
			wait for Tclk;
			napred <= '0';
			wait for Tclk;
			
			odaberi <= '1'; --izabrana 6 
			wait for Tclk;
			odaberi <= '0';
			wait for Tclk;
			
			wait for 2*Tclk;
			reset<='1';
			wait for Tclk;
			reset<='0'; -- sve cifre =0
			wait for Tclk;
			
			
			
			
			napred <= '1'; --na 1
			wait for Tclk;
			napred <= '0';
			wait for Tclk;
			napred <= '1'; -- na 2
			wait for Tclk;
			napred <= '0';
			wait for Tclk;
			napred <= '1'; -- na 3
			wait for Tclk;
			napred <= '0';
			wait for Tclk;
			napred <= '1'; -- na 4
			wait for Tclk;
			napred <= '0';
			wait for Tclk;
			napred <= '1'; -- na 5
			wait for Tclk;
			napred <= '0';
			wait for Tclk;
			
			odaberi <= '1'; --izabrana 5
			wait for Tclk;
			odaberi <= '0';
			wait for Tclk;
			
			nazad <= '1'; --na 4
			wait for Tclk;
			nazad <= '0';
			wait for Tclk;
			nazad <= '1'; -- na 3
			wait for Tclk;
			nazad <= '0';
			wait for Tclk;
			nazad <= '1'; -- na 2
			wait for Tclk;
			nazad <= '0';
			wait for Tclk;
			
			odaberi <= '1'; --izabrana 2
			wait for Tclk;
			odaberi <= '0';
			wait for Tclk;
			
			napred <= '1'; --na 3
			wait for Tclk;
			napred <= '0';
			wait for Tclk;
			
			odaberi <= '1'; --izabrana 3 (0523 (netačno))
			wait for Tclk;
			odaberi <= '0';
			wait for Tclk;
			
			
			nazad <= '1'; -- na 2
			wait for Tclk;
			nazad <= '0';
			wait for Tclk;
			nazad <= '1'; -- na 1
			wait for Tclk;
			nazad <= '0';
			wait for Tclk;
			nazad <= '1'; -- na 0
			wait for Tclk;
			nazad <= '0';
			wait for Tclk;
			odaberi <= '1'; --izabrana 0 (5230 (tačno))
			wait for Tclk;
			odaberi <= '0';
			wait for Tclk;
			
			wait for 8 * 2 * Tclk;
			
			
			wait;
		end Process;
	
end tr;