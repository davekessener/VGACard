library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-------------------------------------------------------------------------------

entity buf_mod is
	port
	(
		clk		 : in std_logic;
		rst		 : in std_logic;
		
		addr_in	 : in integer range 0 to 79;
		data_in	 : in std_logic_vector(7 downto 0);
		we		 : in std_logic;
		
		addr_out : in integer range 0 to 79;
		data_out : out std_logic_vector(7 downto 0)
	);
end entity buf_mod;

-------------------------------------------------------------------------------

architecture Behavioral of buf_mod is

type buf_t is array (0 to 79) of std_logic_vector(7 downto 0);

type state_t is (READY, WAITING);

signal state : state_t := READY;

signal s_buffer  : buf_t;

signal read_addr : integer range 0 to 79;

begin -------------------------------------------------------------------------

data_out <= s_buffer(read_addr);

process (clk) is
begin
	if rising_edge(clk) then
		if rst = '1' then
			state <= READY;
			s_buffer <= (others => (others => '1'));
			read_addr <= 0;
		else
			case state is
				when READY =>
					if we = '1' then
						state <= WAITING;
						s_buffer(addr_in) <= data_in;
					end if;
				when WAITING =>
					if we = '0' then
						state <= READY;
					end if;
			end case;
			
			read_addr <= addr_out;
		end if;
	end if;
end process;

end Behavioral;
