library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity divider is
port(
	clk : in std_logic;
	reset : in std_logic;
	a: in std_logic_vector ( 0 to 15); -- brojilac
	b: in std_logic_vector (0 to 15); -- imenilac
	y: out std_logic_vector (0 to 15) := (others=>'0');
	y_rem: out std_logic_vector (0 to 15):= (others=>'0');
	y_valid : out std_logic :='0'
);
end divider;

architecture beh of divider is
	type state_collection is (idle, start, div);
	signal crnt_state,nxt_state : state_collection;
	
	constant max_cnt : natural :=15;
	signal shift_cnt : natural range 0 to max_cnt;
	
	signal a_reg : std_logic_vector(0 to 15):= (others=>'0');
	signal b_reg : std_logic_vector(0 to 15):= (others=>'0');
	signal temp_reg: std_logic_vector (0 to 31) := (others=>'0');
	signal rem_reg : std_logic_vector (0 to 15) := (others =>'0');
	signal res_reg : std_logic_vector (0 to 15) := (others =>'0');
	
begin

	state_change : process(reset,clk) is
		begin
			if(reset='1') then
				crnt_state<=idle;
			elsif(rising_edge(clk)) then
				crnt_state<=nxt_state;
			end if;
		end process;
	
	register_change_logic : process(reset,clk) is
		begin
			if(reset='1') then
				a_reg<=(others=>'0');
				b_reg<=(others=>'0');
			elsif(rising_edge(clk)) then
				if(crnt_state<=start) then
					a_reg<=a;
					b_reg<=b;
				end if;
			end if;
		end process;
	
	state_change_logic : process(a,b,shift_cnt,a_reg,b_reg,crnt_state) is
		begin
			case crnt_state is
				when idle =>
					if( (a = a_reg) and (b = b_reg)) then
						nxt_state<=idle;
					else
						nxt_state<=start;
					end if;
				when start=>
					nxt_state<=div;
				when div=>
					if(shift_cnt<max_cnt) then
						nxt_state<=div;
					else
						nxt_state<=idle;
					end if;
				when others=>
					nxt_state<=idle;
			end case;
		end process;
	
	counter_logic : process(reset,clk) is
		begin
			if(reset='1') then
				shift_cnt<=0;
			elsif(rising_edge(clk)) then
				if(crnt_state=div) then
					if(shift_cnt<max_cnt) then
						shift_cnt<=shift_cnt+1;
					end if;
				else
					shift_cnt<=0;
				end if;
			end if;
		end process;
	--
	--   1111 : 10 = (7 + rem 1 = 111 + 001)
	--	-10
	--	  11
	--   -10
	--	   11
	--	  -10
	--		1 
	--	opis procesa: brojilac idem bit po bit dodajem u registar, od kog pokušam da oduzmem i posle n bita ostatak je rem
	--
	
	division_logic : process(clk,reset) is
		begin
			if(reset='1') then
				temp_reg<=(others=>'0');
				res_reg<=(others=>'0');
				rem_reg<=(others=>'0');
			elsif(rising_edge(clk)) then
				if(crnt_state=start) then
					temp_reg(0 to 15)<=(others=>'0');
					temp_reg(16 to 31)<=a_reg;
					--res_reg<=(others=>'0');
					--rem_reg<=(others=>'0');
				elsif(crnt_state=div) then
					if(shift_cnt<=max_cnt) then
						if(unsigned(temp_reg(1 to 16))>=unsigned(b_reg)) then
							temp_reg<=std_logic_vector(unsigned(temp_reg(1 to 16))-unsigned(b_reg)) & temp_reg(17 to 31) & '1';
						else
							temp_reg<=temp_reg(1 to 31) & '0';
						end if;
					end if;
				end if;
			end if;
		end process;
	
	
	output_logic : process(reset,clk) is
		begin
			if(reset='1') then
				y<=(others=>'0');
				y_rem<=(others=>'0');
				y_valid<='0';
			elsif(rising_edge(clk)) then
				if(crnt_state=idle) then
					y<=temp_reg(16 to 31);
					y_rem<=temp_reg(0 to 15);
				end if;
				if( (a = a_reg) and (b = b_reg) and (crnt_state=idle)) then
						y_valid<='1';
					else
						y_valid<='0';
					end if;
			end if;
		end process;
end;