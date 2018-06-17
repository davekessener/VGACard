library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-------------------------------------------------------------------------------

entity com_mod is
	port
	(
		clk			: in std_logic;
		rst			: in std_logic;
		
		line		: in integer range 0 to 59;
		
		scroll		: in std_logic;
		
		addr_ram	: out std_logic_vector(14 downto 0);
		addr_buf	: out integer range 0 to 79;
		read		: out std_logic;
		done		: in std_logic;
		
		start		: in std_logic
	);
end entity com_mod;

-------------------------------------------------------------------------------

architecture Behavioral of com_mod is

type state_t is (READY, READING, WAITING);

signal read_c	: integer range 0 to 79;
signal line_buf	: integer range 0 to 59;
signal addr_off	: integer range 0 to 60*80-1;
signal s_scroll	: std_logic;

signal state	: state_t := READY;

begin -------------------------------------------------------------------------

addr_ram <= std_logic_vector(to_unsigned(
				(line_buf * 80 + read_c + addr_off) mod (60 * 80),
				addr_ram'length
			))
			when state = READING or state = WAITING
			else (others => '0');
addr_buf <= read_c when state = READING or state = WAITING else 0;
read <= '1' when state = WAITING else '0';

process (clk) is
begin
	if rising_edge(clk) then
		if rst = '1' then
			state <= READY;
			read_c <= 0;
			line_buf <= 0;
			addr_off <= 0;
			s_scroll <= '0';
		else
			case state is
				when READY =>
					if start = '1' then
						state <= READING;
						read_c <= 0;
						if line = 59 then
							line_buf <= 0;
						else
							line_buf <= line + 1;
						end if;
					end if;
				when READING =>
					state <= WAITING;
				when WAITING =>
					if done = '1' then
						if read_c = 79 then
							state <= READY;
						else
							read_c <= read_c + 1;
							state <= READING;
						end if;
					end if;
			end case;
			
			if scroll = '1' and s_scroll = '0' then
				addr_off <= addr_off + 80;
			end if;
			
			s_scroll <= scroll;
		end if;
	end if;
end process;

end architecture Behavioral;
