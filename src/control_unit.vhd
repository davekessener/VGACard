library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-------------------------------------------------------------------------------

entity control_unit is
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
end entity control_unit;

-------------------------------------------------------------------------------

architecture Behavioral of control_unit is

component status_mod is
	port
	(
		clk				: in std_logic;
		rst				: in std_logic;
		
		screen_en		: out std_logic;
		
		addr			: in std_logic_vector(2 downto 0);
		data_in			: in std_logic_vector(7 downto 0);
		data_out		: out std_logic_vector(7 downto 0);
		cs				: in std_logic;
		rd				: in std_logic;
		we				: in std_logic;
		clear_ack		: in std_logic;
		
		cursor_in		: in std_logic_vector(15 downto 0);
		cursor_out		: out std_logic_vector(7 downto 0);
		cursor_advance	: out std_logic;
		cursor_act		: out std_logic;
		cursor_nl		: out std_logic;
		cursor_force	: out std_logic;
		cursor_move		: out std_logic_vector(1 downto 0);
		vram_data		: in std_logic_vector(7 downto 0);
		
		advX			: out std_logic;
		advY			: out std_logic;
		wrapX			: out std_logic;
		scroll_en		: out std_logic;
		invert_en		: out std_logic;
		cursor_en		: out std_logic;
		
		frame			: out std_logic;
		set_cursor_x	: out std_logic;
		set_cursor_y	: out std_logic;
		
		vram_write		: out std_logic;
		vram_read		: out std_logic
	);
end component status_mod;

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

component clear_mod is
	port
	(
		clk				: in std_logic;
		rst				: in std_logic;
		
		screen_en		: out std_logic;
		acknowledge		: out std_logic;
		
		vram_addr		: out std_logic_vector(14 downto 0);
		vram_do			: out std_logic;
		vram_done		: in std_logic;
		
		frame			: in std_logic
	);
end component clear_mod;

component ram_mux is
	port
	(
		clk				: in std_logic;
		rst				: in std_logic;
		
		addr_0			: in std_logic_vector(14 downto 0);
		data_in_0		: in std_logic_vector(7 downto 0);
		data_out_0		: out std_logic_vector(7 downto 0);
		read_0			: in std_logic;
		write_0			: in std_logic;
		done_0			: out std_logic;
		
		addr_1			: in std_logic_vector(14 downto 0);
		data_in_1		: in std_logic_vector(7 downto 0);
		data_out_1		: out std_logic_vector(7 downto 0);
		read_1			: in std_logic;
		write_1			: in std_logic;
		done_1			: out std_logic;
		
		addr			: out std_logic_vector(14 downto 0);
		data_in			: in std_logic_vector(7 downto 0);
		data_out		: out std_logic_vector(7 downto 0);
		do_read			: out std_logic;
		do_write		: out std_logic;
		done			: in std_logic
	);
end component ram_mux;

signal status_screen_en	: std_logic;
signal status_cursor_adv: std_logic;
signal status_cursor_mov: std_logic_vector(1 downto 0);
signal status_cursor_act: std_logic;
signal status_cursor_frc: std_logic;
signal status_cursor_nl : std_logic;
signal status_vram_write: std_logic;
signal status_vram_read	: std_logic;
signal status_clear_ack	: std_logic;

signal clear_screen_en	: std_logic;
signal clear_vram_addr	: std_logic_vector(14 downto 0);
signal clear_vram_do	: std_logic;
signal clear_vram_done	: std_logic;

signal cursor_buf		: std_logic_vector(15 downto 0);
signal cursor_set		: std_logic_vector(7 downto 0);

signal s_advX			: std_logic;
signal s_advY			: std_logic;
signal s_wrapX			: std_logic;
signal s_scroll_en		: std_logic;
signal s_cursor_en		: std_logic;
signal s_frame			: std_logic;
signal s_clear			: std_logic;
signal s_cursor_setX	: std_logic;
signal s_cursor_setY	: std_logic;

signal mux_data			: std_logic_vector(7 downto 0);

begin -------------------------------------------------------------------------

cursor <= cursor_buf;
screen_en <= status_screen_en and clear_screen_en;
frame <= s_frame;

Status : status_mod
port map
(
	clk => clk,
	rst => rst,
	screen_en => status_screen_en,
	addr => port_sel,
	data_in => data_in,
	data_out => data_out,
	cs => cs,
	rd => rd,
	we => we,
	clear_ack => status_clear_ack,
	cursor_in => cursor_buf,
	cursor_out => cursor_set,
	cursor_advance => status_cursor_adv,
	cursor_move => status_cursor_mov,
	cursor_act => status_cursor_act,
	cursor_nl => status_cursor_nl,
	cursor_force => status_cursor_frc,
	vram_data => mux_data,
	advX => s_advX,
	advY => s_advY,
	wrapX => s_wrapX,
	scroll_en => s_scroll_en,
	invert_en => invert_en,
	cursor_en => s_cursor_en,
	frame => s_frame,
	set_cursor_x => s_cursor_setX,
	set_cursor_y => s_cursor_setY,
	vram_write => status_vram_write,
	vram_read => status_vram_read
);

CursorReg : cursor_mod
port map
(
	clk => clk,
	rst => rst,
	cursor_out => cursor_buf,
	cursor_in => cursor_set,
	write_x => s_cursor_setX,
	write_y => s_cursor_setY,
	advance => status_cursor_adv,
	newline => status_cursor_nl,
	force_scroll => status_cursor_frc,
	do_move => status_cursor_act,
	move => status_cursor_mov,
	advX => s_advX,
	advY => s_advY,
	wrapX => s_wrapX,
	scroll_en => s_scroll_en,
	cursor_en => s_cursor_en,
	blink => blink,
	scroll => scroll
);

VRAMClearer : clear_mod
port map
(
	clk => clk,
	rst => rst,
	screen_en => clear_screen_en,
	acknowledge => status_clear_ack,
	vram_addr => clear_vram_addr,
	vram_do => clear_vram_do,
	vram_done => clear_vram_done,
	frame => s_frame
);

VRAMMux : ram_mux
port map
(
	clk => clk,
	rst => rst,
	addr_0 => c_addr,
	data_in_0 => data_in,
	data_out_0 => mux_data,
	read_0 => status_vram_read,
	write_0 => status_vram_write,
	done_0 => open,
	addr_1 => clear_vram_addr,
	data_in_1 => (others => '0'),
	data_out_1 => open,
	read_1 => '0',
	write_1 => clear_vram_do,
	done_1 => clear_vram_done,
	addr => vram_addr,
	data_in => vram_data_in,
	data_out => vram_data_out,
	do_read => vram_read,
	do_write => vram_write,
	done => vram_done
);

end Behavioral;
