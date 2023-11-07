library IEEE;
use IEEE.std_logic_1164.all;

entity kombinacija is
port(
	odaberi : in std_logic;
	nazad : in std_logic;
	napred : in std_logic;
	clk : in std_logic;
	reset : in std_logic;
	cifra : out std_logic_vector (0 to 2) := "000"; --cifra koja je trenutno izabrana
	otvori : out std_logic :='0';
	greska : out std_logic :='0'
);
end kombinacija;
--kombinacija se sastoji od 4 OKTALNE cifre
--nakon reset -> sve cifre = 0 i lock i error
--signali napred i nazad i odaberi traju jedan takt
--napred = +1, nazad =-1
--max 7, min 0
--odaberi prelazi na sledeću cifru
--nakon četvrtog odaberi se upoređuju kombinacije ( if equal otvori, else greska =1)
--potrebno da nakon upoređivanja 2s diode svetle
--takt je 125MHz
--za vežbu potrebno definisati konstantu od 12 bita

architecture rts of kombinacija is

	--Definisana stanja:
	--define_pass -> u toku kucanje kombinacinaije
	--check_pass -> u toku provera
	--guess_pass -> uneta i skladištena su jednake
	--wrong_pass -> uneta i skladištena su različite
	type state_collection is (define_pass,check_pass, guess_pass, wrong_pass);
	
	type Password is array(0 to 3) of  std_logic_vector (0 to 2);
	
	signal crnt_state,nxt_state : state_collection;
	constant crnt_pass : Password := ("101","010","011","000");--5230
	signal crnt_guess : Password;
	
	constant C_SECOND : natural := 8; -- staviti na frekvenciju: 8 za simulaciju, 125 10^6 za testiranje na hardveru
	constant maxcount : natural := 10 * C_SECOND; -- maksimalan broj sekundi koji će biti korišćen
	signal time_count : integer range 1 to maxcount :=1;
	signal digit_count : integer range 0 to 3 := 0;
	signal digit : integer range 0 to 7:=0;
	signal waitLength : integer range 0 to maxcount :=(2 * C_SECOND);
	
	signal tcifra : std_logic_vector(0 to 2):="000";

begin
	
	confirm_digit_logic : process(clk,reset,odaberi) is
		begin
			if(reset='1') then
				digit_count <= 0;
				crnt_guess(0)<="000";
				crnt_guess(1)<="000";
				crnt_guess(2)<="000";
				crnt_guess(3)<="000";
			elsif (rising_edge(clk)) then
				if(odaberi = '1') then
					crnt_guess(digit_count)<=tcifra;
					if(digit_count<3) then
						digit_count<=digit_count+1;
					else
						digit_count<=0;
					end if;
				end if;
			end if;
		end process;
	
	digit_change_logic : process(clk,reset,napred, nazad) is
		begin
			if(reset='1') then
				digit <= 0;
			elsif (rising_edge(clk)) then
				if(napred = '1') then
					if(digit<7) then
						digit<=digit+1;
					else
						digit<=0;
					end if;
				elsif (nazad = '1') then
					if(digit>0) then
						digit<=digit-1;
					else
						digit<=7;
					end if;
				end if;
			end if;
		end process;
	
	digit_show_logic : process(clk,reset,digit) is
		begin
			if(reset='1') then
				tcifra<="000";
				cifra<="000";
			elsif (rising_edge(clk)) then
				if(digit = 1) then
					cifra<="001";
					tcifra<="001";
				elsif (digit =2) then
					cifra<="010";
					tcifra<="010";
				elsif (digit =3) then
					cifra<="011";
					tcifra<="011";
				elsif (digit =4) then
					cifra<="100";
					tcifra<="100";
				elsif (digit =5) then
					cifra<="101";
					tcifra<="101";
				elsif (digit =6) then
					cifra<="110";
					tcifra<="110";
				elsif (digit =7) then
					cifra<="111";
					tcifra<="111";
				else
					cifra<="000";
					tcifra<="000";
				end if;
			end if;
		end process;
	
	next_state_logic : process(clk,reset) is
		begin
			if(reset='1') then
				crnt_state<=define_pass;
			elsif (rising_edge(clk)) then
				crnt_state<=nxt_state;
			end if;
		end process;
	
	counter_logic : process(reset,clk) is
		begin
			if(reset='1') then
				time_count<=1;
			elsif(rising_edge(clk)) then
				if(crnt_state=nxt_state) then
					if(time_count<waitLength) then
						time_count<=time_count+1;
					end if;
				else
					time_count<=1;
				end if;
			end if;
		end process;
	
	state_change_logic : process(crnt_state,clk,odaberi,digit_count,time_count) is
		begin
			nxt_state<=crnt_state;
			case crnt_state is
				when define_pass =>
					if(digit_count=3) then
						if(odaberi='1') then
							nxt_state<=check_pass;
						end if;
					end if;
				when check_pass =>
						if(crnt_guess=crnt_pass) then
							nxt_state<=guess_pass;
						else
							nxt_state<=wrong_pass;
						end if;
				when guess_pass =>
					if(time_count=waitLength) then
						nxt_state<=define_pass;
					end if;
				when wrong_pass=>
					if(time_count=waitLength) then
						nxt_state<=define_pass;
					end if;
				when others =>
					nxt_state<=define_pass;
			end case;
		end process;
	
	signal_result : process(reset,clk) is
		begin
			if(reset='1') then
				otvori<='0';
				greska<='0';
			elsif (rising_edge(clk)) then
				if (crnt_state=guess_pass) then
					otvori<='1';
					greska<='0';
				elsif (crnt_state=wrong_pass) then
					otvori<='0';
					greska<='1';
				else
					otvori<='0';
					greska<='0';
				end if;
			end if;
		end process;
end rts;