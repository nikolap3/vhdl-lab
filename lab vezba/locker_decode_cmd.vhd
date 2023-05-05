library IEEE;
use IEEE.std_logic_1164.all;

entity locker_decode_cmd is
	port(
		signal_in : in std_logic;
		clk : in std_logic;
		reset : in std_logic;
		num_value : out std_logic_vector(0 to 3) :="0000";
		num_valid : out std_logic :='0';
		cmd_ok : out std_logic :='0';
		cmd_cancel : out std_logic :='0'
	);
end locker_decode_cmd;

architecture beh of locker_decode_cmd is

	-- stanja mašine
	-- idle <- čekanje impulsa 
	-- count <- brojanje trajanja impulsa
	-- output <- slanje informacije
	type state_collection is (idle,count,output);
	
	signal crnt_state,nxt_state : state_collection;
	
	constant max_count : natural := 13;
	
	signal crnt_count : natural range 0 to max_count;
	signal valued : std_logic_vector (0 to 3) :="0000";
	
begin

	state_change : process(reset,clk) is
	begin
		if(reset = '1') then
			crnt_state <= idle;
		elsif (rising_edge(clk)) then
			crnt_state <= nxt_state;
		end if;
	end process;
	
	counter_logic : process(reset, clk) is
	begin
		if(reset = '1') then
			crnt_count <= 0;
		elsif (rising_edge(clk)) then
			if(signal_in='1') then
				if(crnt_count<13) then
					crnt_count<= crnt_count +1;					
				end if;
			else
				crnt_count<=0;
			end if;
		end if;
	end process;

	value_change_logic : process (signal_in)
	begin
		if(falling_edge(signal_in)) then
			case crnt_count is
				when 1 => valued <="0001";
				when 2 => valued <="0010";
				when 3 => valued <="0011";
				when 4 => valued <="0100";
				when 5 => valued <="0101";
				when 6 => valued <="0110";
				when 7 => valued <="0111";
				when 8 => valued <="1000";
				when 9 => valued <="1001";
				when 10 => valued <="0000"; -- 10 mi je nula
				when 11 => valued <="1011";
				when 12 => valued <="1100";
				when 13 => valued <="1101";
				when others => valued <="0000";
			end case;
		end if;
	end process;

	state_change_logic : process(signal_in,crnt_state)
	begin
		case crnt_state is
				when idle =>
					if(signal_in = '1') then
						nxt_state<=count;
					else
						nxt_state<=idle;
					end if;
				when count=>
					if(signal_in = '0') then
						nxt_state<=output;
					else
						nxt_state<=count;
					end if;
				when output=>
					-- Ako upravo završili upis, onda ako je signal_in na 1, to znači da se sad zadaje sledeća komanda
					if(signal_in = '1') then
						nxt_state<=count;
					else
						nxt_state<=idle;
					end if;
				when others =>
					nxt_state<=idle;
		end case;
	end process;
	
	state_result : process(reset,clk) is
	begin
		if(reset='1') then
			num_value <= "0000";
			num_valid <= '0';
			cmd_cancel <= '0';
			cmd_ok <= '0';
		elsif(rising_edge(clk)) then
			--ideja za ubrzanje: na falling_edge signal_in raditi output
			if(signal_in='0' and crnt_state=count) then
					if(valued="1101") then
						num_value <= "0000";
						num_valid <= '0';
						cmd_cancel <= '0';
						cmd_ok <= '0';
					elsif (valued="1011") then
						num_value <= "0000";
						num_valid <= '0';
						cmd_cancel <= '0';
						cmd_ok <= '1';
					elsif (valued="1100") then
						num_value <= "0000";
						num_valid <= '0';
						cmd_cancel <= '1';
						cmd_ok <= '0';
					else
						num_value <= valued;
						num_valid <= '1';
						cmd_cancel <= '0';
						cmd_ok <= '0';
					end if;
			else
				num_value <= "0000";
				num_valid <= '0';
				cmd_cancel <= '0';
				cmd_ok <= '0';
			end if;
		end if;
	end process;
end beh;