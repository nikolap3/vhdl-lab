library IEEE;
use IEEE.std_logic_1164.all;

entity traffic_light is
port(
	--ULAZI
	clk : in std_logic;
	reset : in std_logic;
	--IZLAZI
	rc : out std_logic :='0';
	yc : out std_logic :='0';
	gc : out std_logic :='0';
	rp : out std_logic :='0';
	gp : out std_logic :='0'
);
end traffic_light;

architecture tr of traffic_light is
	-- stanja
	--redRed1 <- Crveno za sve, svi stoje
	--redGreen <- Crveno za vozila, zeleno za pešake
	--redRed2 <- Crveno za sve, svi stoje
	--redYellowRed <- Crveno i žuto za vozila, crveno za pešake
	--greenRed <- Crveno za pešake, zeleno za vozila
	--yellowRed <- Žuto za vozila, crveno za pešake
	type state_collection is (redRed1, redGreen, redRed2, redYellowRed, greenRed, yellowRed);
	
	signal crnt_state,nxt_state : state_collection;
	constant C_SECOND : natural := 8; -- staviti na frekvenciju: 8 za simulaciju, 125 10^6 za testiranje na hardveru
	constant maxcount : natural := 10 * C_SECOND; -- maksimalan broj sekundi koji će biti korišćen
	signal count : integer range 0 to maxcount :=0;
	signal waitLength : integer range 0 to maxcount :=(2 * C_SECOND);
	
begin
	
	next_state_logic : process(clk,reset) is
		begin
			if(reset='1') then
				crnt_state<=redRed1;
			elsif (rising_edge(clk)) then
				crnt_state<=nxt_state;
			end if;
		end process;
	
	counter_logic : process(reset,clk) is
		begin
			if(reset='1') then
				count<=0;
			elsif(rising_edge(clk)) then
				if(crnt_state=nxt_state) then
					if(count<waitLength) then
						count<=count+1;
					end if;
				else
					count<=0;
				end if;
			end if;
		end process;
	
	Wait_change_logic : process(nxt_state,reset,clk)
		begin
			if(reset='1') then
				waitLength<= 2 * C_SECOND;
			else
				case crnt_state is
					when redRed1 =>
							waitLength<=2 * C_SECOND;
					when redGreen =>
							waitLength<=7 * C_SECOND;
					when redRed2=>
							waitLength<=2 * C_SECOND;
					when redYellowRed=>
							waitLength<=1 * C_SECOND;
					when greenRed =>
							waitLength<=9 * C_SECOND;
					when yellowRed =>
							waitLength<=1 * C_SECOND;
					when others =>
						waitLength<=2 * C_SECOND;
				end case;
			end if;
		end process;
	
	state_change_logic : process(crnt_state,clk) is
		begin
			nxt_state<=crnt_state;
			case crnt_state is
				when redRed1 =>
					if(count=waitLength) then
						nxt_state<=redGreen;
					end if;
				when redGreen =>
					if(count=waitLength) then
						nxt_state<=redRed2;
					end if;
				when redRed2=>
					if(count=waitLength) then
						nxt_state<=redYellowRed;
					end if;
				when redYellowRed=>
					if(count=waitLength) then
						nxt_state<=greenRed;
					end if;
				when greenRed =>
					if(count=waitLength) then
						nxt_state<=yellowRed;
					end if;
				when yellowRed =>
					if(count=waitLength) then
						nxt_state<=redRed1;
					end if;
				when others =>
					nxt_state<=redRed1;
			end case;
		end process;
	
	signal_result : process(reset,clk) is
	begin
		if(reset='1') then
			rc<='1';
			yc<='0';
			gc<='0';
			rp<='1';
			gp<='0';
		elsif (rising_edge(clk)) then
			--Signali za vozila
			if (crnt_state=redRed1 or crnt_state=redGreen or crnt_state=redRed2) then
				rc<='1';
				yc<='0';
				gc<='0';
			elsif (crnt_state=redYellowRed) then
				rc<='1';
				yc<='1';
				gc<='0';
			elsif (crnt_state=yellowRed) then
				rc<='0';
				yc<='1';
				gc<='0';
			elsif (crnt_state=greenRed) then
				rc<='0';
				yc<='0';
				gc<='1';
			end if;
			--Signali za pešake
			if (crnt_state=redGreen) then --ako nije zeleno za pešake, onda je crveno
				rp<='0';
				gp<='1';
			else
				rp<='1';
				gp<='0';
			end if;
		end if;
	end process;
end tr;