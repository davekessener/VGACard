library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-------------------------------------------------------------------------------

entity screen_unit is
	port
	(
		clk				: in std_logic;
		rst				: in std_logic;

		hblank			: out std_logic;
		vblank			: out std_logic;
		video			: out std_logic;

		enable			: in std_logic;

		cursor			: in std_logic_vector(15 downto 0);
		blink			: in std_logic;
		scroll			: in std_logic;
		frame			: in std_logic;
		invert_en		: in std_logic;

		c_addr			: out std_logic_vector(14 downto 0);

		addr			: out std_logic_vector(14 downto 0);
		data_in			: in std_logic_vector(7 downto 0);
		data_out		: out std_logic_vector(7 downto 0);
		do_read			: out std_logic;
		do_write		: out std_logic;
		done			: in std_logic
	);
end entity screen_unit;

-------------------------------------------------------------------------------

architecture Behavioral of screen_unit is

signal video_enable	: std_logic;
signal x_ctrl		: std_logic_vector(9 downto 0);
signal y_ctrl		: std_logic_vector(8 downto 0);

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

component screen_ctrl is
	port
	(
		clk			: in std_logic;
		rst			: in std_logic;
		
		x_ctrl		: in std_logic_vector(9 downto 0);
		y_ctrl		: in std_logic_vector(8 downto 0);
		v_en		: in std_logic;
		video		: out std_logic;

		cursor_x	: in std_logic_vector(6 downto 0);
		cursor_y	: in std_logic_vector(5 downto 0);
		c_addr		: out std_logic_vector(14 downto 0);
		
		blink		: in std_logic;
		scroll		: in std_logic;
		frame		: in std_logic;
		invert_en	: in std_logic;
		
		addr		: out std_logic_vector(14 downto 0);
		data_in		: in std_logic_vector(7 downto 0);
		data_out	: out std_logic_vector(7 downto 0);
		do_read		: out std_logic;
		do_write	: out std_logic;
		done		: in std_logic
	);
end component screen_ctrl;

begin --------------------------------------------------------------------------

VGASignalGenerator : sync_mod
port map
(
	clk => clk,
	rst => rst,
	en => enable,
	x_ctrl => x_ctrl,
	y_ctrl => y_ctrl,
	h_s => hblank,
	v_s => vblank,
	video_en => video_enable
);

ScreenController : screen_ctrl
port map
(
	clk => clk,
	rst => rst,
	x_ctrl => x_ctrl,
	y_ctrl => y_ctrl,
	v_en => video_enable,
	video => video,
	cursor_x => cursor(6 downto 0),
	cursor_y => cursor(13 downto 8),
	blink => blink,
	scroll => scroll,
	frame => frame,
	invert_en => invert_en,
	addr => addr,
	c_addr => c_addr,
	data_in => data_in,
	data_out => data_out,
	do_read => do_read,
	do_write => do_write,
	done => done
);

end architecture Behavioral;

