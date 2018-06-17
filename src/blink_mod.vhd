library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-------------------------------------------------------------------------------

entity blink_mod is
	port
	(
		char_in		: in std_logic_vector(7 downto 0);
		char_out	: out std_logic_vector(7 downto 0);

		blink_en	: in std_logic;

		char_x		: in std_logic_vector(6 downto 0);
		char_y		: in std_logic_vector(5 downto 0);
		cursor_x	: in std_logic_vector(6 downto 0);
		cursor_y	: in std_logic_vector(5 downto 0)
	);
end entity blink_mod;

--------------------------------------------------------------------------------

architecture Behavioral of blink_mod is
begin

char_out(6 downto 0) <= char_in(6 downto 0);
char_out(7) <= not char_in(7) when blink_en = '1' and char_x = cursor_x and char_y = cursor_y else char_in(7);

end architecture Behavioral;

