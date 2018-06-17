library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--------------------------------------------------------------------------------

entity screen_ctrl is
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
end entity screen_ctrl;

--------------------------------------------------------------------------------

architecture Behavioral of screen_ctrl is

signal disp_addr	: integer range 0 to 79;
signal buf_addr		: integer range 0 to 79;
signal line_buf		: integer range 0 to 79;
signal cur_char		: std_logic_vector(7 downto 0);
signal cursor_blink	: std_logic;
signal v_signal		: std_logic;
signal start_loading: std_logic;
signal inverted		: std_logic;

signal erase_line_addr : integer range 0 to 9599;
signal erase_line_en: std_logic;

signal read_addr	: std_logic_vector(14 downto 0);
signal read_data	: std_logic_vector(7 downto 0);
signal read_do		: std_logic;
signal read_done	: std_logic;

signal write_addr	: std_logic_vector(14 downto 0);
signal write_do		: std_logic;
signal write_done	: std_logic;

component swap_buf is
	port
	(
		clk		 	: in std_logic;
		rst		 	: in std_logic;
		
		addr_in	 	: in integer range 0 to 79;
		data_in	 	: in std_logic_vector(7 downto 0);
		we		 	: in std_logic;
		
		addr_out 	: in integer range 0 to 79;
		data_out 	: out std_logic_vector(7 downto 0);
		
		switch	 	: in std_logic
	);
end component swap_buf;

component charset_mod is
	port
	(
		char_sel	: in std_logic_vector(6 downto 0);
		invert		: in std_logic;
		
		px_x		: in std_logic_vector(2 downto 0);
		px_y		: in std_logic_vector(2 downto 0);
		
		pixel		: out std_logic
	);
end component charset_mod;

component read_mod is
	port
	(
		clk			: in std_logic;
		rst			: in std_logic;
		
		line		: in integer range 0 to 59;
		
		scroll		: in std_logic;
		frame		: in std_logic;

		c_x			: in std_logic_vector(6 downto 0);
		c_y			: in std_logic_vector(5 downto 0);
		c_addr		: out std_logic_vector(14 downto 0);
		
		line_addr	: out integer range 0 to 9599;
		erase_line	: out std_logic;
		
		addr_ram	: out std_logic_vector(14 downto 0);
		addr_buf	: out integer range 0 to 79;
		do_read		: out std_logic;
		done		: in std_logic;
		
		start		: in std_logic
	);
end component read_mod;

component write_mod is
	port
	(
		clk			: in std_logic;
		rst			: in std_logic;
		
		start_addr	: in integer range 0 to 9599;
		run			: in std_logic;
		
		addr		: out std_logic_vector(14 downto 0);
		do			: out std_logic;
		done		: in std_logic
	);
end component write_mod;

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

begin --------------------------------------------------------------------------

video <= v_signal when v_en = '1' else '0';
disp_addr <= to_integer(unsigned(x_ctrl(9 downto 3)));
line_buf <= to_integer(unsigned(y_ctrl(8 downto 3)));
start_loading <= '1' when unsigned(y_ctrl(2 downto 0) & x_ctrl(9 downto 0)) = 0 and v_en = '1' else '0';
cursor_blink <= not cur_char(7) when blink = '1' and x_ctrl(9 downto 3) = cursor_x and y_ctrl(8 downto 3) = cursor_y else cur_char(7);
inverted <= cursor_blink xor invert_en;

Charset : charset_mod
port map
(
	char_sel => cur_char(6 downto 0),
	invert => inverted,
	px_x => x_ctrl(2 downto 0),
	px_y => y_ctrl(2 downto 0),
	pixel => v_signal
);

LineBuffer : swap_buf
port map
(
	clk => clk,
	rst => rst,
	addr_in => buf_addr,
	data_in => data_in,
	we => done,
	addr_out => disp_addr,
	data_out => cur_char,
	switch => y_ctrl(3)
);

VRAMRead : read_mod
port map
(
	clk => clk,
	rst => rst,
	line => line_buf,
	scroll => scroll,
	frame => frame,
	c_x => cursor_x,
	c_y => cursor_y,
	c_addr => c_addr,
	line_addr => erase_line_addr,
	erase_line => erase_line_en,
	addr_ram => read_addr,
	addr_buf => buf_addr,
	do_read => read_do,
	done => read_done,
	start => start_loading
);

VRAMWrite : write_mod
port map
(
	clk => clk,
	rst => rst,
	start_addr => erase_line_addr,
	run => erase_line_en,
	addr => write_addr,
	do => write_do,
	done => write_done
);

VRAMMux : ram_mux
port map
(
	clk => clk,
	rst => rst,
	addr_0 => write_addr,
	data_in_0 => "00000000",
	data_out_0 => open,
	read_0 => '0',
	write_0 => write_do,
	done_0 => write_done,
	addr_1 => read_addr,
	data_in_1 => (others => '0'),
	data_out_1 => read_data,
	read_1 => read_do,
	write_1 => '0',
	done_1 => read_done,
	addr => addr,
	data_in => data_in,
	data_out => data_out,
	do_read => do_read,
	do_write => do_write,
	done => done
);

end architecture Behavioral;

