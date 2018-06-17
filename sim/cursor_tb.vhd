library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-------------------------------------------------------------------------------

entity cursor_tb is
end cursor_tb;

-------------------------------------------------------------------------------

architecture Behavioral of cursor_tb is

component cursor_mod is
	port
	(
		clk				: in std_logic;
		rst				: in std_logic;
		
		cursor_out		: out std_logic_vector(15 downto 0);
		cursor_in		: in std_logic_vector(7 downto 0);
		
		write_x			: in std_logic;
		write_y			: in std_logic;
		
		advance			: in std_logic;
		newline			: in std_logic;
		force_scroll	: in std_logic;
		do_move			: in std_logic;
		move			: in std_logic_vector(1 downto 0);
		
		advX			: in std_logic;
		advY			: in std_logic;
		wrapX			: in std_logic;
		scroll_en		: in std_logic;
		cursor_en		: in std_logic;
		
		blink			: out std_logic;
		scroll			: out std_logic
	);
end component cursor_mod;

signal clk				: std_logic;
signal rst				: std_logic;
signal cursor_out		: std_logic_vector(15 downto 0);
signal cursor_in		: std_logic_vector(7 downto 0);
signal write_x			: std_logic;
signal write_y			: std_logic;
signal advance			: std_logic;
signal newline			: std_logic;
signal force_scroll		: std_logic;
signal do_move			: std_logic;
signal move				: std_logic_vector(1 downto 0);
signal advX				: std_logic;
signal advY				: std_logic;
signal wrapX			: std_logic;
signal scroll_en		: std_logic;
signal cursor_en		: std_logic;
signal blink			: std_logic;
signal scroll			: std_logic;

constant CLK_PERIOD		: time := 20 ns;

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
	
	cursor_in <= "00000000";
	write_x <= '0';
	write_y <= '0';
	
	advance <= '0';
	newline <= '0';
	force_scroll <= '0';
	do_move <= '0';
	move <= "00";
	
	advX <= '1';
	advY <= '1';
	wrapX <= '1';
	scroll_en <= '1';
	cursor_en <= '1';
	
	wait for CLK_PERIOD*2;
	
	rst <= '0';
	
	advance <= '1';
	
	wait for 5*CLK_PERIOD;
	
	advance <= '0';
	
	wait for 5*CLK_PERIOD;
	
	cursor_in <= "01001111"; -- 79
	write_x <= '1';
	
	wait for 5*CLK_PERIOD;
	
	write_x <= '0';
	
	wait for CLK_PERIOD;
	
	advance <= '1';
	
	wait for 5*CLK_PERIOD;
	
	advance <= '0';
	
	wait for CLK_PERIOD;
	
	write_x <= '1';
	
	wait for 5*CLK_PERIOD;
	
	write_x <= '0';
	
	wait for CLK_PERIOD;
	
	cursor_in <= "00111011"; -- 59
	write_y <= '1';
	
	wait for 5*CLK_PERIOD;
	
	write_y <= '0';
	
	wait for CLK_PERIOD;
	
	advance <= '1';
	
	wait for 5*CLK_PERIOD;
	
	advance <= '0';
	
	wait for CLK_PERIOD;
	
	force_scroll <= '1';
	
	wait for 5*CLK_PERIOD;
	
	force_scroll <= '0';
	
	wait for CLK_PERIOD;
	
	cursor_in <= "11111111"; -- >79
	write_x <= '1';
	
	wait for 5*CLK_PERIOD;
	
	write_x <= '0';
	
	wait for CLK_PERIOD;
	
	write_y <= '1';
	
	wait for 5*CLK_PERIOD;
	
	write_y <= '0';
	
	wait for CLK_PERIOD;
	
	wait for 100 ms;
end process StimProcess;

UUT : cursor_mod
port map
(
	clk => clk,
	rst => rst,
	cursor_out => cursor_out,
	cursor_in => cursor_in,
	write_x => write_x,
	write_y => write_y,
	advance => advance,
	newline => newline,
	force_scroll => force_scroll,
	do_move => do_move,
	move => move,
	advX => advX,
	advY => advY,
	wrapX => wrapX,
	scroll_en => scroll_en,
	cursor_en => cursor_en,
	blink => blink,
	scroll => scroll
);

end Behavioral;
