library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.RAM_definitions_PK.all;

entity pass_rom_tb is
end pass_rom_tb;

architecture tb of pass_rom_tb is
    constant C_CLK_PERIOD : time := 8 ns;
    
    -- Putanja do inicijalizacionog fajla, moze da bude puna putanja, a moze i samo ime fajla ako je fajl 
    -- na istoj lokaciji kao i source .vhd fajlovi
    constant C_INIT_FILE_NAME: string := "init.dat"; 
    
    constant C_RAM_WIDTH : integer := 12;            		    -- Specify RAM data width
    constant C_RAM_DEPTH : integer := 64; 				    -- Specify RAM depth (number of entries)
    
    -- probati i jedan i drugi, primetiti da sa HIGH_PERFORMANCE memorija kasni dodatno jedan takt na izlazu
    constant C_RAM_PERFORMANCE : string := "HIGH_PERFORMANCE";  -- Select "HIGH_PERFORMANCE" or "LOW_LATENCY"
    
    signal rd_addr  :  std_logic_vector((clogb2(C_RAM_DEPTH)-1) downto 0);     -- Read address bus, width determined from RAM_DEPTH
    signal clk      :  std_logic := '1';                   			  -- Clock
    signal rd_en    :  std_logic;                       			  -- RAM Enable, for additional power savings, disable port when not in use
    signal rst      :  std_logic := '0';                       	      -- Output reset (does not affect memory contents)
    signal regce    :  std_logic := '1';                       		  -- Output register enable
    signal dout     :  std_logic_vector(C_RAM_WIDTH-1 downto 0); 	  -- Output data 
begin
    DUT: entity work.pass_rom(pon)
        generic map (
            G_RAM_WIDTH       => C_RAM_WIDTH,      
            G_RAM_DEPTH       => C_RAM_DEPTH,     
            G_RAM_PERFORMANCE => C_RAM_PERFORMANCE,
            G_INIT_FILE       => C_INIT_FILE_NAME      
        )
        port map (
            addrb  => rd_addr,
            clka   => clk,
            enb    => rd_en,
            rstb   => rst,
            regceb => regce,
            doutb  => dout
        );

    clk <= not clk after C_CLK_PERIOD/2;
    
    READ_STIMULUS: process
    begin
        rd_addr <= (others => '0');
        rd_en <= '0';
        wait for C_CLK_PERIOD*2;
        rd_en <= '1';
        wait for C_CLK_PERIOD*2;
        rd_en <= '0';
        wait for C_CLK_PERIOD;
        rd_en <= '1';
        rd_addr <= std_logic_vector(to_unsigned(56, clogb2(C_RAM_DEPTH)));
		wait for C_CLK_PERIOD*2;
		rd_en <= '0';
        wait for C_CLK_PERIOD;
		rd_en <= '1';
        rd_addr <= std_logic_vector(to_unsigned(62, clogb2(C_RAM_DEPTH)));
        wait;
    end process READ_STIMULUS;
    
end tb;
