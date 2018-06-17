library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-------------------------------------------------------------------------------

entity screen_ctrl is
	port
	(
		clk			: in std_logic;
		rst			: in std_logic;
		
		x_ctrl		: in std_logic_vector(9 downto 0);
		y_ctrl		: in std_logic_vector(8 downto 0);
		v_en		: in std_logic;
		video		: out std_logic;
		
		scroll		: in std_logic;
		
		addr		: out std_logic_vector(14 downto 0);
		data		: in std_logic_vector(7 downto 0);
		read		: out std_logic;
		done		: in std_logic
	);
end entity screen_ctrl;

-------------------------------------------------------------------------------

architecture Behavioral of screen_ctrl is

signal disp_addr	 : integer range 0 to 79;
signal buf_addr		 : integer range 0 to 79;
signal line_buf		 : integer range 0 to 59;
signal cur_char		 : std_logic_vector(7 downto 0);
signal v_signal		 : std_logic;
signal start_loading : std_logic;

component swap_buf is
	port
	(
		clk		 : in std_logic;
		rst		 : in std_logic;
		
		addr_in	 : in integer range 0 to 79;
		data_in	 : in std_logic_vector(7 downto 0);
		we		 : in std_logic;
		
		addr_out : in integer range 0 to 79;
		data_out : out std_logic_vector(7 downto 0);
		
		switch	 : in std_logic
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

component com_mod is
	port
	(
		clk			: in std_logic;
		rst			: in std_logic;
		
		line		: in integer range 0 to 59;
		
		scroll		: in std_logic;
		
		addr_ram	: out std_logic_vector(14 downto 0);
		addr_buf	: out integer range 0 to 79;
		read		: out std_logic;
		done		: in std_logic;
		
		start		: in std_logic
	);
end component com_mod;

begin -------------------------------------------------------------------------

video <= v_signal when v_en = '1' else '0';
disp_addr <= to_integer(unsigned(x_ctrl(9 downto 3)));
line_buf <= to_integer(unsigned(y_ctrl(8 downto 3)));
start_loading <= '1' when unsigned(y_ctrl(2 downto 0) & x_ctrl(9 downto 0)) = 0 and v_en = '1' else '0';

Charset : charset_mod
port map
(
	char_sel => cur_char(6 downto 0),
	invert => cur_char(7),
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
	data_in => data,
	we => done,
	addr_out => disp_addr,
	data_out => cur_char,
	switch => y_ctrl(3)
);

RAMConnection : com_mod
port map
(
	clk => clk,
	rst => rst,
	line => line_buf,
	scroll => scroll,
	addr_ram => addr,
	addr_buf => buf_addr,
	read => read,
	done => done,
	start => start_loading
);

end Behavioral;
