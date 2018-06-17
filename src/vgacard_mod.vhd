library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-------------------------------------------------------------------------------

entity vgacard_mod is
	port
	(
		clk				: in std_logic;
		rst				: in std_logic;

		vga_g			: out std_logic;
		vga_hs			: out std_logic;
		vga_vs			: out std_logic;

		io_addr			: in std_logic_vector(2 downto 0);
		io_data_in		: in std_logic_vector(7 downto 0);
		io_data_out		: out std_logic_vector(7 downto 0);
		io_cs			: in std_logic;
		io_rd			: in std_logic;
		io_we			: in std_logic;

		vram_addr		: out std_logic_vector(14 downto 0);
		vram_data_in	: in std_logic_vector(7 downto 0);
		vram_data_out	: out std_logic_vector(7 downto 0);
		vram_cs			: out std_logic;
		vram_we			: out std_logic;
		vram_oe			: out std_logic
	);
end entity vgacard_mod;

-------------------------------------------------------------------------------

architecture Behavioral of vgacard_mod is


signal control_to_vram	: std_logic_vector(33 downto 0);
signal screen_to_vram	: std_logic_vector(33 downto 0);
signal control_to_screen: std_logic_vector(35 downto 0);


component control_unit is
	port
	(
		clk				: in std_logic;
		rst				: in std_logic;

		port_sel		: in std_logic_vector(2 downto 0);
		data_in			: in std_logic_vector(7 downto 0);
		data_out		: out std_logic_vector(7 downto 0);
		rd				: in std_logic;
		we				: in std_logic;
		cs				: in std_logic;

		vram_addr		: out std_logic_vector(14 downto 0);
		vram_data_in	: in std_logic_vector(7 downto 0);
		vram_data_out	: out std_logic_vector(7 downto 0);
		vram_write		: out std_logic;
		vram_read		: out std_logic;
		vram_done		: in std_logic;

		screen_en		: out std_logic;
		cursor			: out std_logic_vector(15 downto 0);
		blink			: out std_logic;
		scroll			: out std_logic;
		frame			: out std_logic;
		invert_en		: out std_logic;
		c_addr			: in std_logic_vector(14 downto 0)
	);
end component control_unit;

component screen_unit is
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
end component screen_unit;

component vram_unit is
	port
	(
		clk				: in std_logic;
		rst				: in std_logic;

		ctrl_addr		: in std_logic_vector(14 downto 0);
		ctrl_data_in	: in std_logic_vector(7 downto 0);
		ctrl_data_out	: out std_logic_vector(7 downto 0);
		ctrl_we			: in std_logic;
		ctrl_oe			: in std_logic;
		ctrl_done		: out std_logic;

		screen_addr		: in std_logic_vector(14 downto 0);
		screen_data_in	: in std_logic_vector(7 downto 0);
		screen_data_out	: out std_logic_vector(7 downto 0);
		screen_we		: in std_logic;
		screen_oe		: in std_logic;
		screen_done		: out std_logic;

		addr			: out std_logic_vector(14 downto 0);
		data_in			: in std_logic_vector(7 downto 0);
		data_out		: out std_logic_vector(7 downto 0);
		cs				: out std_logic;
		we				: out std_logic;
		oe				: out std_logic
	);
end component vram_unit;

begin -------------------------------------------------------------------------

ControlUnit : control_unit
port map
(
	clk => clk,
	rst => rst,
	port_sel => io_addr,
	data_in => io_data_in,
	data_out => io_data_out,
	rd => io_rd,
	we => io_we,
	cs => io_cs,
	vram_addr => control_to_vram(33 downto 19),
	vram_data_in => control_to_vram(18 downto 11),
	vram_data_out => control_to_vram(10 downto 3),
	vram_write => control_to_vram(2),
	vram_read => control_to_vram(1),
	vram_done => control_to_vram(0),
	screen_en => control_to_screen(34),
	cursor => control_to_screen(33 downto 18),
	blink => control_to_screen(17),
	scroll => control_to_screen(16),
	frame => control_to_screen(15),
	invert_en => control_to_screen(35),
	c_addr => control_to_screen(14 downto 0)
);

ScreenUnit : screen_unit
port map
(
	clk => clk,
	rst => rst,
	hblank => vga_hs,
	vblank => vga_vs,
	video => vga_g,
	enable => control_to_screen(34),
	cursor => control_to_screen(33 downto 18),
	blink => control_to_screen(17),
	scroll => control_to_screen(16),
	frame => control_to_screen(15),
	invert_en => control_to_screen(35),
	c_addr => control_to_screen(14 downto 0),
	addr => screen_to_vram(24 downto 10),
	data_in => screen_to_vram(9 downto 2),
	data_out => screen_to_vram(33 downto 26),
	do_read => screen_to_vram(1),
	do_write => screen_to_vram(25),
	done => screen_to_vram(0)
);

VRAMInterface : vram_unit
port map
(
	clk => clk,
	rst => rst,
	ctrl_addr => control_to_vram(33 downto 19),
	ctrl_data_in => control_to_vram(10 downto 3),
	ctrl_data_out => control_to_vram(18 downto 11),
	ctrl_we => control_to_vram(2),
	ctrl_oe => control_to_vram(1),
	ctrl_done => control_to_vram(0),
	screen_addr => screen_to_vram(24 downto 10),
	screen_data_in => screen_to_vram(33 downto 26),
	screen_data_out => screen_to_vram(9 downto 2),
	screen_we => screen_to_vram(25),
	screen_oe => screen_to_vram(1),
	screen_done => screen_to_vram(0),
	addr => vram_addr,
	data_in => vram_data_in,
	data_out => vram_data_out,
	cs => vram_cs,
	we => vram_we,
	oe => vram_oe
);

end Behavioral;
