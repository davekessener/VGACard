library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-------------------------------------------------------------------------------

entity cursor_mod is
	port
	(
		clk				: in std_logic;
		rst				: in std_logic;
		
		cursor_out		: out std_logic_vector(15 downto 0);
		cursor_in		: in std_logic_vector(7 downto 0);
		
		write_x			: in std_logic;
		write_y			: in std_logic;
		
		advance			: in std_logic;
		newline			: in std_logic;
		force_scroll	: in std_logic;
		do_move			: in std_logic;
		move			: in std_logic_vector(1 downto 0);
		
		advX			: in std_logic;
		advY			: in std_logic;
		wrapX			: in std_logic;
		scroll_en		: in std_logic;
		cursor_en		: in std_logic;
		
		blink			: out std_logic;
		scroll			: out std_logic
	);
end entity cursor_mod;

-------------------------------------------------------------------------------

architecture Behavioral of cursor_mod is

constant ROWS : integer := 60;
constant COLS : integer := 80;
constant TPMS : integer := 50000; -- 50,000 * 20ns = 1ms
constant T : integer := 1000*TPMS;

signal cursor_x : integer range 0 to COLS-1;
signal cursor_y : integer range 0 to ROWS-1;
signal timer : integer range 0 to T-1;

signal s_advance : std_logic;
signal s_force_scroll : std_logic;
signal s_newline : std_logic;
signal s_act : std_logic;

begin -------------------------------------------------------------------------

cursor_out <= std_logic_vector(to_unsigned(cursor_y, 8)) & std_logic_vector(to_unsigned(cursor_x, 8));
blink <= '1' when cursor_en = '1' and timer >= T/2 else '0';

process (clk) is
	variable tmp : integer;
begin
	if rising_edge(clk) then
		if rst = '1' then
			cursor_x <= 0;
			cursor_y <= 0;
			timer <= 0;
			scroll <= '0';
			s_advance <= '0';
			s_force_scroll <= '0';
			s_newline <= '0';
			s_act <= '0';
		else
			scroll <= '0';
			
			if write_x = '1' then
				tmp := to_integer(unsigned(cursor_in));
				if tmp < COLS then
					cursor_x <= tmp;
				else
					cursor_x <= COLS-1;
				end if;
			elsif write_y = '1' then
				tmp := to_integer(unsigned(cursor_in));
				if tmp < ROWS then
					cursor_y <= tmp;
				else
					cursor_y <= ROWS-1;
				end if;
			elsif do_move = '1' and s_act = '0' then
				case move is
					when "00" =>
						if cursor_x > 0 then
							cursor_x <= cursor_x - 1;
						end if;
					when "01" =>
						if cursor_x < COLS-1 then
							cursor_x <= cursor_x + 1;
						end if;
					when "10" =>
						if cursor_y > 0 then
							cursor_y <= cursor_y - 1;
						end if;
					when "11" =>
						if cursor_y < ROWS-1 then
							cursor_y <= cursor_y + 1;
						end if;
					when others =>
				end case;
			elsif advance = '1' and s_advance = '0' then
				if advX = '1' then
					if cursor_x = COLS-1 then
						if wrapX = '1' then
							cursor_x <= 0;
						end if;
						
						if advY = '1' then
							if cursor_y = ROWS-1 then
								if scroll_en = '1' then
									scroll <= '1';
								end if;
							else
								cursor_y <= cursor_y + 1;
							end if;
						end if;
					else
						cursor_x <= cursor_x + 1;
					end if;
				end if;
			elsif newline = '1' and s_newline = '0' then
				cursor_x <= 0;
				
				if cursor_y = ROWS-1 then
					if scroll_en = '1' then
						scroll <= '1';
					end if;
				else
					cursor_y <= cursor_y + 1;
				end if;
			elsif force_scroll = '1' and s_force_scroll = '0' then
				if cursor_y > 0 then
					cursor_y <= cursor_y - 1;
				end if;
				
				scroll <= '1';
			end if;
		
			s_advance <= advance;
			s_act <= do_move;
			s_force_scroll <= force_scroll;
			s_newline <= newline;
			
			if timer < T-1 then
				timer <= timer + 1;
			else
				timer <= 0;
			end if;
		end if;
	end if;
end process;

end Behavioral;
