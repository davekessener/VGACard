library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-------------------------------------------------------------------------------

entity ram_clearer is
	port
	(
		clk			: in std_logic;
		rst			: in std_logic;
		
		en			: in std_logic;
		
		addr		: out std_logic_vector(14 downto 0);
		data		: out std_logic_vector(7 downto 0);
		do			: out std_logic;
		done		: in std_logic
	);
end entity ram_clearer;

-------------------------------------------------------------------------------

architecture Behavioral of ram_clearer is

type state_t is (READY, WRITING, WAITING);

signal state : state_t := READY;

signal c_buf : std_logic_vector(addr'range);

signal counter : integer range 0 to 4799;

begin -------------------------------------------------------------------------

c_buf <= std_logic_vector(to_unsigned(counter, addr'length));
addr <= c_buf;
data <= c_buf(7 downto 0);
do <= '1' when state = WRITING else '0';

process (clk) is
begin
	if rising_edge(clk) then
		if rst = '1' then
			counter <= 0;
			state <= READY;
		else
			case state is
				when READY =>
					if en = '1' then
						state <= WRITING;
					end if;
				when WRITING =>
					if done = '1' then
						state <= WAITING;
					end if;
				when WAITING =>
					if en = '0' then
						state <= READY;
						
						if counter = 4799 then
							counter <= 0;
						else
							counter <= counter + 1;
						end if;
					end if;
			end case;
		end if;
	end if;
end process;

end architecture Behavioral;
