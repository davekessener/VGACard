library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-------------------------------------------------------------------------------

entity ram_unit is
	port
	(
		clk		 : in std_logic;
		rst		 : in std_logic;
		
		addr_in	 : in std_logic_vector(14 downto 0);
		data_in	 : inout std_logic_vector(7 downto 0);
		we_in	 : in std_logic;
		oe_in	 : in std_logic;
		cs_in	 : in std_logic;
		
		addr_out : out std_logic_vector(14 downto 0);
		data_out : inout std_logic_vector(7 downto 0);
		we_out	 : out std_logic;
		oe_out	 : out std_logic;
		cs_out	 : out std_logic;
		
		done	 : out std_logic
	);
end entity ram_unit;

-------------------------------------------------------------------------------

architecture Behavioral of ram_unit is

type states is (READY, READING, WRITING, WAITING);

signal addr_buf : std_logic_vector(14 downto 0);
signal data_buf : std_logic_vector(7 downto 0);

signal timer	: integer range 0 to 4;
signal timer_nx	: integer range 0 to 4;

signal state	: states := READY;

begin -------------------------------------------------------------------------

addr_out <= addr_buf when state = READING or state = WRITING else (others => '0');
data_out <= data_buf when state = WRITING else (others => 'Z');
data_in	 <= data_buf when state = READING else (others => 'Z');
we_out	 <= '1' when state = WRITING else '0';
oe_out	 <= '1' when state = READING else '0';
cs_out	 <= '1' when state = READING or state = WRITING else '0';
done	 <= '1' when state = WAITING else '0';

process (clk) is
begin
	if rising_edge(clk) then
		if rst = '1' then
			state <= READY;
		else
			case state is
				when READY =>
					if cs_in = '1' then
						if we_in = '1' then
							state <= WRITING;
							data_buf <= data_in;
						elsif oe_in = '1' then
							state <= READING;
						end if;
						
						timer <= 4;
						addr_buf <= addr_in;
					end if;
				when READING =>
					if timer = 0 then
						data_buf <= data_out;
						state <= WAITING;
					end if;
					
					timer <= timer - 1;
				when WRITING =>
					if timer = 0 then
						state <= WAITING;
					end if;
					
					timer <= timer - 1;
				when WAITING =>
					if cs_in = '0' then
						state <= READY;
					end if;
			end case;
		end if;
	end if;
end process;

end Behavioral;

