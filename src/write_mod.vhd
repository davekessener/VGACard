library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-------------------------------------------------------------------------------

entity write_mod is
	port
	(
		clk			: in std_logic;
		rst			: in std_logic;
		
		start_addr	: in integer range 0 to 9599;
		run			: in std_logic;
		
		addr		: out std_logic_vector(14 downto 0);
		do			: out std_logic;
		done		: in std_logic
	);
end entity write_mod;

-------------------------------------------------------------------------------

architecture Behavioral of write_mod is

type state_t is (READY, WRITING);

signal state		: state_t := READY;

signal line_buf		: integer range 0 to 9599;
signal counter		: integer range 0 to 79;

begin -------------------------------------------------------------------------

do <= not done when state = WRITING else '0';
addr <= std_logic_vector(to_unsigned(line_buf + counter, addr'length))
			when state = WRITING else (others => '0');

process (clk) is
begin
	if rising_edge(clk) then
		if rst = '1' then
			state <= READY;
			counter <= 0;
			line_buf <= 0;
		else
			case state is
				when READY =>
					if run = '1' then
						state <= WRITING;
						line_buf <= start_addr;
						counter <= 0;
					end if;
				when WRITING =>
					if done = '1' then
						if counter = 79 then
							state <= READY;
						else
							counter <= counter + 1;
						end if;
					end if;
			end case;
		end if;
	end if;
end process;

end Behavioral;
