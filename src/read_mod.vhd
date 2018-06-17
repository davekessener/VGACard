library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-------------------------------------------------------------------------------

entity read_mod is
	port
	(
		clk			: in std_logic;
		rst			: in std_logic;
		
		line		: in integer range 0 to 59;
		
		scroll		: in std_logic;
		frame		: in std_logic;

		c_x			: in std_logic_vector(6 downto 0);
		c_y			: in std_logic_vector(5 downto 0);
		c_addr		: out std_logic_vector(14 downto 0);
		
		line_addr	: out integer range 0 to 9599;
		erase_line	: out std_logic;
		
		addr_ram	: out std_logic_vector(14 downto 0);
		addr_buf	: out integer range 0 to 79;
		do_read		: out std_logic;
		done		: in std_logic;
		
		start		: in std_logic
	);
end entity read_mod;

-------------------------------------------------------------------------------

architecture Behavioral of read_mod is

type state_t is (READY, READING, WAITING);

constant COLS	: integer := 80;
constant ROWS	: integer := 60;
constant CHARS	: integer := COLS*ROWS;

signal read_c	: integer range 0 to COLS-1;
signal line_buf	: integer range 0 to ROWS-1;
signal addr_off	: integer range 0 to ROWS-1;
signal s_scroll	: std_logic;
signal page_off	: integer range 0 to 1;
signal c_row	: integer range 0 to ROWS-1;
signal c_col	: integer range 0 to COLS-1;

signal state	: state_t := READY;

begin -------------------------------------------------------------------------

addr_ram <= std_logic_vector(to_unsigned(
				(((line_buf + addr_off) * COLS + read_c) mod CHARS) + page_off * CHARS,
				addr_ram'length
			))
			when state = READING or state = WAITING
			else (others => '0');
addr_buf <= read_c when state = READING or state = WAITING else 0;
do_read <= '1' when state = WAITING else '0';

page_off <= 0 when frame = '0' else 1;

c_col <= to_integer(unsigned(c_x));
c_row <= to_integer(unsigned(c_y));
c_addr <= std_logic_vector(to_unsigned((((c_row + addr_off) * COLS + c_col) mod CHARS) + page_off * CHARS, c_addr'length));

process (clk) is
begin
	if rising_edge(clk) then
		if rst = '1' then
			state <= READY;
			read_c <= 0;
			line_buf <= 0;
			addr_off <= 0;
			s_scroll <= '0';
			erase_line <= '0';
			line_addr <= 0;
		else
			erase_line <= '0';
			
			case state is
				when READY =>
					if start = '1' then
						state <= READING;
						read_c <= 0;
						line_buf <= (line + 1) mod ROWS;
					end if;
				when READING =>
					state <= WAITING;
				when WAITING =>
					if done = '1' then
						if read_c = COLS-1 then
							state <= READY;
						else
							read_c <= (read_c + 1) mod COLS;
							state <= READING;
						end if;
					end if;
			end case;
			
			if scroll = '1' and s_scroll = '0' then
				addr_off <= (addr_off + 1) mod ROWS;
				line_addr <= (addr_off * COLS + page_off * CHARS) mod 9600;
				erase_line <= '1';
			end if;
			
			s_scroll <= scroll;
		end if;
	end if;
end process;

end architecture Behavioral;

