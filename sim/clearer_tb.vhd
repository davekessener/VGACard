library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-------------------------------------------------------------------------------

entity clearer_tb is
end clearer_tb;

-------------------------------------------------------------------------------

architecture Behavioral of clearer_tb is

component clear_mod is
	port
	(
		clk				: in std_logic;
		rst				: in std_logic;
		
		screen_en		: out std_logic;
		
		vram_addr		: out std_logic_vector(14 downto 0);
		vram_do			: out std_logic;
		vram_done		: in std_logic;
		
		frame			: in std_logic
	);
end component clear_mod;

signal clk	: std_logic;
signal rst	: std_logic;
signal screen_en	: std_logic;
signal vram_addr	: std_logic_vector(14 downto 0);
signal vram_do		: std_logic;
signal vram_done	: std_logic;
signal frame		: std_logic;

constant CLK_PERIOD : time := 20 ns;

signal counter : integer range 0 to 4 := 4;
signal done_buf : std_logic;

begin -------------------------------------------------------------------------

ClockProcess : process is
begin
	clk <= '0';
	wait for CLK_PERIOD/2;
	clk <= '1';
	wait for CLK_PERIOD/2;
end process ClockProcess;

StimProcess : process is
begin
	rst <= '1';
	frame <= '0';
	
	wait for CLK_PERIOD*2;
	
	rst <= '0';
	
	wait for 5 ms;
	
	frame <= '1';
	
	wait for 100 ms;
end process StimProcess;

vram_done <= done_buf and vram_do;

process (clk) is
begin
	if rising_edge(clk) then
		if vram_do = '1' then
			if counter > 0 then
				counter <= counter - 1;
			else
				done_buf <= '1';
			end if;
		else
			counter <= 4;
			done_buf <= '0';
		end if;
	end if;
end process;

UUT : clear_mod
port map
(
	clk => clk,
	rst => rst,
	screen_en => screen_en,
	vram_addr => vram_addr,
	vram_do => vram_do,
	vram_done => vram_done,
	frame => frame
);

end Behavioral;
