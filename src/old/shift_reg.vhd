library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-------------------------------------------------------------------------------

entity shift_reg is
	generic
	(
		WIDTH	: integer := 8
	);
	port
	(
		clk		: in std_logic;
		arst	: in std_logic;
		
		d_in	: in std_logic;
		d_out	: out std_logic_vector(WIDTH-1 downto 0)
	);
end shift_reg;

-------------------------------------------------------------------------------

architecture Behavioral of shift_reg is

signal data : std_logic_vector (WIDTH-1 downto 0);

begin -------------------------------------------------------------------------

d_out <= data;

process (clk,arst) is
begin
	if arst = '1' then
		data <= (others => '0');
	elsif rising_edge(clk) then
		data <= data(WIDTH-2 downto 0) & d_in;
	end if;
end process;

end Behavioral;
