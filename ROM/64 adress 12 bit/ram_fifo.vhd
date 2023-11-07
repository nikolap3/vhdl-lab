library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.RAM_definitions_PK.all;

entity ram_fifo is
    generic (
        G_DATAWIDTH : natural := 16;
        G_FIFODEPTH : natural := 1024
    );
    port (
        clk : in std_logic;
        reset : in std_logic;
        fifo_wr : in std_logic;
        din : in std_logic_vector(G_DATAWIDTH-1 downto 0);
        fifo_rd : in std_logic;
        dout : out std_logic_vector(G_DATAWIDTH-1 downto 0)
    );
end ram_fifo;

architecture Behavioral of ram_fifo is
    signal addr_wr : std_logic_vector(clogb2(G_FIFODEPTH)-1 downto 0);
    signal addr_rd : std_logic_vector(clogb2(G_FIFODEPTH)-1 downto 0);
begin
    RAM: entity work.simple_dual_port_ram(Behavioral)
        generic map(
            G_RAM_WIDTH => G_DATAWIDTH,
            G_RAM_DEPTH => G_FIFODEPTH,
            G_RAM_PERFORMANCE => "LOW_LATENCY"
        )
        port map (
            addra => addr_wr,
            addrb => addr_rd,
            dina  => din,
            clka  => clk,
            wea   => fifo_wr,
            enb   => fifo_rd,
            rstb  => reset,
            regceb=> '0',
            doutb => dout
        );
    
    ADDR_GEN: process (clk) is
    begin
        if rising_edge(clk) then
            if reset = '1' then
                addr_wr <= (others => '0');
                addr_rd <= (others => '0');
            else
                if fifo_wr = '1' then
                    if unsigned(addr_wr) = G_FIFODEPTH - 1 then
                        addr_wr <= (others => '0');
                    else
                        addr_wr <= std_logic_vector(unsigned(addr_wr) + 1);
                    end if;
                end if;
                if fifo_rd = '1' then
                    if unsigned(addr_rd) = G_FIFODEPTH - 1 then
                        addr_rd <= (others => '0');
                    else
                        addr_rd <= std_logic_vector(unsigned(addr_rd) + 1);
                    end if;
                end if;
            end if;            
        end if;    
    end process ADDR_GEN;

end Behavioral;
