library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-------------------------------------------------------------------------------

entity debouncer is
	generic
	(
		M			: integer := 20
	);
	port
	(
		clk			: in std_logic;
		rst			: in std_logic;
		
		input		: in std_logic;
		output		: out std_logic
	);
end entity debouncer;

-------------------------------------------------------------------------------

architecture Behavioral of debouncer is

signal flipflops : std_logic_vector(1 downto 0);
signal counter_set : std_logic;
signal counter_out : std_logic_vector(M downto 0);

begin -------------------------------------------------------------------------


counter_set <= flipflops(1) xor flipflops(0);

process (clk) is
begin
	if rising_edge(clk) then
		if rst = '1' then
			flipflops <= "00";
			counter_out <= (others => '0');
			output <= '0';
		else
			flipflops(0) <= input;
			flipflops(1) <= flipflops(0);
			
			if counter_set = '1' then
				counter_out <= (others => '0');
			elsif counter_out(M) = '0' then
				counter_out <= counter_out + 1;
			else
				output <= flipflops(1);
			end if;
		end if;
	end if;
end process;

end architecture Behavioral;
