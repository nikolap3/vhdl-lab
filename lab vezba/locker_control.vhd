library IEEE;
use IEEE.std_logic_1164.all;

entity locker_control is
port(
	num_value : in std_logic_vector (0 to 3);
	num_valid : in std_logic;
	cmd_ok : in std_logic;
	cmd_cancel : in std_logic;
	clk : in std_logic;
	reset : in std_logic;
	lock : out std_logic :='0';
	error : out std_logic :='0'
);
end locker_control;

architecture rtl of locker_control is

	-- stanja
	--unlocked <- otključano stanje, takođe početno
	--Password_creation <- stanje kreiranje lozinke
	--locked <- zaključano stanje
	--Unlock_attempt <- stanje pokušaja, uspeh vodi u unlocked, neuspeh u locked
	type state_collection is (open_idle, lock_idle, define_pass, guess_pass, wrong_pass);
	
	type Password is array(0 to 2) of  std_logic_vector (0 to 3);
	
	signal crnt_state,nxt_state : state_collection;
	signal crnt_pass,crnt_guess : Password;
	constant maxcount : natural := 3;
	signal count : natural range 0 to maxcount :=0;

begin

	next_state_logic : process(clk,reset) is
		begin
			if(reset='1') then
				crnt_state<=open_idle;
			elsif (rising_edge(clk)) then
				crnt_state<=nxt_state;
			end if;
		end process;
		
	number_processing : process(num_valid) is
	begin
		if(num_valid='1') then
			if(crnt_state= define_pass) then
				crnt_pass(2)<=crnt_pass(1);
				crnt_pass(1)<=crnt_pass(0);
				crnt_pass(0)<=num_value;
				if(count<maxcount) then
					count<=count+1;
				end if;
			elsif(crnt_state=guess_pass or crnt_state=lock_idle) then
				crnt_guess(2)<=crnt_guess(1);
				crnt_guess(1)<=crnt_guess(0);
				crnt_guess(0)<=num_value;
				if(count<maxcount) then
					count<=count+1;
				end if;
			else
				count<=0;
			end if;
		else
			if(crnt_state=lock_idle) then
				count<=0;
			elsif(crnt_state=open_idle) then
				count<=0;
			end if;
		end if;
			
	end process;
	
	state_change_logic : process(crnt_state,num_valid,cmd_cancel,cmd_ok) is
		begin
			case crnt_state is
				when open_idle =>
					if(cmd_ok='1') then
						nxt_state<=define_pass;
					else
						nxt_state<=open_idle;
					end if;
				when define_pass =>
					if(cmd_cancel='1') then
						nxt_state<=open_idle;
					elsif(cmd_ok='1')then
						if(count=3) then
							nxt_state<=lock_idle;
						else
							nxt_state<=define_pass;
						end if;
					else
						nxt_state<=define_pass;
					end if;
				when lock_idle=>
					if(num_valid='1') then
						nxt_state<=guess_pass;
					else
						nxt_state<=lock_idle;
					end if;
				when guess_pass=>
					if(cmd_cancel='1') then
						nxt_state<=lock_idle;
					elsif(cmd_ok='1') then
						if(count=3) then
							if(crnt_pass=crnt_guess) then
								nxt_state<=open_idle;
							else
								nxt_state<=wrong_pass;
							end if;
						end if;
					else
						nxt_state<= guess_pass;
					end if;
				when wrong_pass =>
					nxt_state<=lock_idle;
				when others =>
					nxt_state<=open_idle;
			end case;
		end process;
	
	signal_result : process(reset,clk) is
	begin
		if(reset='1') then
			lock<='0';
			error<='0';
		elsif (rising_edge(clk)) then
			if (crnt_state=open_idle) then
				lock<='0';
			elsif (crnt_state=lock_idle) then
				lock<='1';
				error<='0';
			elsif (crnt_state=wrong_pass) then
				error<='1';
				lock<='1';
			end if;
		end if;
	end process;

end rtl;