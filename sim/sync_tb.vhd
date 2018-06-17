library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-------------------------------------------------------------------------------

entity sync_tb is
end sync_tb;

-------------------------------------------------------------------------------

architecture Behavioral of sync_tb is

signal clk		: std_logic;
signal rst		: std_logic;
signal en		: std_logic;
signal x_ctrl	: std_logic_vector(9 downto 0);
signal y_ctrl	: std_logic_vector(8 downto 0);
signal h_s		: std_logic;
signal v_s		: std_logic;
signal video_en	: std_logic;

constant CLK_PERIOD : time := 20 ns;

component sync_mod is
	port
	(
		clk			: in std_logic;
		rst			: in std_logic;
		en			: in std_logic;
		x_ctrl		: out std_logic_vector(9 downto 0);
		y_ctrl		: out std_logic_vector(8 downto 0);
		h_s			: out std_logic;
		v_s			: out std_logic;
		video_en	: out std_logic
	);
end component sync_mod;

begin -------------------------------------------------------------------------

UUT : sync_mod
port map
(
	clk => clk,
	rst => rst,
	en => en,
	x_ctrl => x_ctrl,
	y_ctrl => y_ctrl,
	h_s => h_s,
	v_s => v_s,
	video_en => video_en
);

Clock : process is
begin
	clk <= '0';
	wait for CLK_PERIOD/2;
	clk <= '1';
	wait for CLK_PERIOD/2;
end process Clock;

Stimulation : process is
begin
	rst <= '1';
	en <= '1';
	
	wait for CLK_PERIOD*2;
	
	rst <= '0';
	
	wait for 100 ms;
end process Stimulation;

end Behavioral;
