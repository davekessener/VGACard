library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;

-------------------------------------------------------------------------------

entity mojo_top is
	generic
	(
		VERSION_MAJOR	: integer := 2;
		VERSION_MINOR	: integer := 0
	);
	port
	(
		clk				: in std_logic;
		rst_n			: in std_logic;
		
		led				: out std_logic_vector(7 downto 0);
		
		vga_g			: out std_logic;
		vga_hs			: out std_logic;
		vga_vs			: out std_logic;

		io_addr			: in std_logic(2 downto 0);
		io_data			: inout std_logic_vector(7 downto 0);
		io_cs_n			: in std_logic;
		io_rd_n			: in std_logic;
		io_we_n			: in std_logic;
		
		vram_addr		: out std_logic_vector(14 downto 0);
		vram_data		: inout std_logic_vector(7 downto 0);
		vram_cs_n		: out std_logic;
		vram_we_n		: out std_logic;
		vram_oe_n		: out std_logic;
		
		shift_data_in	: in std_logic;
		shift_write		: in std_logic;
		shift_out		: in std_logic;
		shift_clk		: in std_logic
	);
end entity mojo_top;

-------------------------------------------------------------------------------

architecture Behavioral of mojo_top is


signal rst			: std_logic;


signal sync_en		: std_logic;
signal video_en		: std_logic;
signal hblank		: std_logic;
signal vblank		: std_logic;
signal pixel_x		: std_logic_vector(9 downto 0);
signal pixel_y		: std_logic_vector(8 downto 0);
signal pixel		: std_logic;


signal screen_raddr	: std_logic_vector(14 downto 0);
signal screen_waddr	: std_logic_vector(14 downto 0);
signal screen_data	: std_logic_vector(7 downto 0);
signal screen_read	: std_logic;
signal screen_done	: std_logic;


signal vram_we		: std_logic;
signal vram_oe		: std_logic;
signal vram_cs		: std_logic;

signal vram_select	: std_logic;

signal vram_data_oe	: std_logic;
signal vram_data_in	: std_logic_vector(7 downto 0);
signal vram_data_out: std_logic_vector(7 downto 0);


signal io_cs		: std_logic;
signal io_rd		: std_logic;
signal io_we		: std_logic;
signal io_data_oe	: std_logic;
signal io_data_in	: std_logic_vector(7 downto 0);
signal io_data_out	: std_logic_vector(7 downto 0);

signal clear_active	: std_logic;
signal clear_addr	: std_logic_vector(14 downto 0);
signal clear_do		: std_logic;
signal clear_done	: std_logic;


signal shift_data	: std_logic_vector(10 downto 0);
signal shift_oe		: std_logic;

signal shift_din	: std_logic;
signal shift_clock	: std_logic;
signal shift_we		: std_logic;

signal shift_input_buf	: std_logic_vector(3 downto 0);
signal shift_output_buf	: std_logic_vector(3 downto 0);


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
		blink		: in std_logic;
		scroll		: in std_logic;
		select		: in std_logic;
		
		raddr		: out std_logic_vector(14 downto 0);
		waddr		: out std_logic_vector(14 downto 0);
		data		: in std_logic_vector(7 downto 0);
		read		: out std_logic;
		done		: in std_logic
	);
end component screen_ctrl;

component vram_mod is
	port
	(
		clk			: in std_logic;
		rst			: in std_logic;
		
	--	io
		addr_0		: in std_logic_vector(14 downto 0);
		data_0_in	: in std_logic_vector(7 downto 0);
		data_0_out	: out std_logic_vector(7 downto 0);
		we_0		: in std_logic;
		re_0		: in std_logic;
		done_0		: out std_logic;
		
	--	screen
		addr_1		: in std_logic_vector(14 downto 0);
		data_1_in	: in std_logic_vector(7 downto 0);
		data_1_out	: out std_logic_vector(7 downto 0);
		we_1		: in std_logic;
		re_1		: in std_logic;
		done_1		: out std_logic;

	--	clearer
		addr_2		: in std_logic_vector(14 downto 0);
		data_2_in	: in std_logic_vector(7 downto 0);
		data_2_out	: out std_logic_vector(7 downto 0);
		we_2		: in std_logic;
		re_2		: in std_logic;
		done_2		: out std_logic;
		
		addr		: out std_logic_vector(14 downto 0);
		data_in		: in std_logic_vector(7 downto 0);
		data_out	: out std_logic_vector(7 downto 0);
		we			: out std_logic;
		oe			: out std_logic;
		cs			: out std_logic
	);
end component vram_mod;

component shift_mod is
	port
	(
		clk			: in std_logic;
		rst			: in std_logic;
		
		data_in		: in std_logic;
		shift_clk	: in std_logic;
		w_en		: in std_logic;
		
		data		: out std_logic_vector(10 downto 0)
	);
end component shift_mod;

component debouncer is
	generic
	(
		M			: integer
	);
	port
	(
		clk			: in std_logic;
		rst			: in std_logic;
		
		input		: in std_logic;
		output		: out std_logic
	);
end component;

component ctrl_mod is
	port
	(
		clk			: in std_logic;
		rst			: in std_logic;
		
		io_port		: in std_logic_vector(2 downto 0);
		io_data_in	: in std_logic_vector(7 downto 0);
		io_rd		: in std_logic;
		io_we		: in std_logic;
		io_sel		: out std_logic_vector(1 downto 0);
		io_oe		: out std_logic;
		
		f_advance	: out std_logic;
		f_wrapx		: out std_logic;
		f_advy		: out std_logic;
		f_scroll	: out std_logic;
		f_cursor	: out std_logic;
		
		do_cls		: out std_logic;
		do_scroll	: out std_logic;
		done		: in std_logic
	);
end component ctrl_mod;

component cursor_mod is
	port
	(
		clk			: in std_logic;
		rst			: in std_logic;
		
		cursor_x	: out std_logic_vector(6 downto 0);
		cursor_y	: out std_logic_vector(5 downto 0);
		
		advance		: in std_logic;
		
		ctrl		: in std_logic_vector(1 downto 0);
		move		: in std_logic;
		
		do_scroll	: out std_logic;
		do_blink	: out std_logic;
		
		reset		: in std_logic;
		we_1		: in std_logic;
		we_2		: in std_logic;
		value		: in std_logic_vector(7 downto 0);
		
		en_blink	: in std_logic;
		en_wrapx	: in std_logic;
		en_advy		: in std_logic;
		en_scroll	: in std_logic
	);
end component cursor_mod;

component io_demux is
	port
	(
		clk			: in std_logic;
		rst			: in std_logic;
		
		in_cursor_x	: in std_logic_vector(6 downto 0);
		in_cursor_y	: in std_logic_vector(5 downto 0);
		in_vram		: in std_logic_vector(7 downto 0);
		in_status	: in std_logic_vector(4 downto 0);
		
		output		: out std_logic_vector(7 downto 0);
		
		sel			: in std_logic_vector(1 downto 0)
	);
end component io_demux;

component ram_clearer is
	port
	(
		clk			: in std_logic;
		rst			: in std_logic;
		
		switch		: in std_logic;
		active		: out std_logic;
		
		addr		: out std_logic_vector(14 downto 0);
		do			: out std_logic;
		done		: in std_logic
	);
end component ram_clearer;

begin -------------------------------------------------------------------------

rst <= not rst_n;
sync_en <= '1';

led <=   std_logic_vector(to_unsigned(VERSION_MAJOR, led'length / 2))
	   & std_logic_vector(to_unsigned(VERSION_MINOR, (led'length+1) / 2));

vga_hs <= hblank;
vga_vs <= vblank;
vga_g <= pixel;

io_cs <= shift_data(10); -- not io_cs_n;
io_rd <= shift_data(9); -- not io_rd_n;
io_we <= shift_data(8); -- not io_we_n;
io_data_in <= shift_data(7 downto 0); -- io_data;

vram_we_n <= not vram_we;
vram_oe_n <= not vram_oe;
vram_cs_n <= not vram_cs;

vram_data_in <= vram_data;
vram_data_oe <= vram_we;

shift_input_buf <=   shift_data_in
				   & shift_out
				   & shift_write
				   & shift_clk;
shift_din   <= shift_output_buf(3);
shift_oe    <= shift_output_buf(2);
shift_we    <= shift_output_buf(1);
shift_clock <= shift_output_buf(0);


VRAMBusDriver : process (vram_data_oe, vram_data_out) is
begin
	if vram_data_oe = '1' then
		vram_data <= vram_data_out;
	else
		vram_data <= (others => 'Z');
	end if;
end process VRAMBusDriver;

IOBusDriver : process (io_data_oe, io_data_out) is
begin
	if io_data_oe = '1' then
		io_data <= io_data_out;
	else
		io_data <= (others => 'Z');
	end if;
end process IOBusDriver;


GenDebounce :
for I in shift_input_buf'range generate
	Debounce : debouncer
	generic map
	(
		M => 2
	)
	port map
	(
		clk => clk,
		rst => rst,
		input => shift_input_buf(I),
		output => shift_output_buf(I)
	);
end generate GenDebounce;


RAMClearer : ram_clearer
port map
(
	clk => clk,
	rst => rst,
	switch => vram_select,
	active => clear_active,
	addr => clear_addr,
	do => clear_do,
	done => clear_done
);

ShiftRegister : shift_mod
port map
(
	clk => clk,
	rst => rst,
	data_in => shift_din,
	shift_clk => shift_clock,
	w_en => shift_we,
	data => shift_data
);

SyncUnit : sync_mod
port map
(
	clk => clk,
	rst => rst,
	en => sync_en,
	x_ctrl => pixel_x,
	y_ctrl => pixel_y,
	h_s => hblank,
	v_s => vblank,
	video_en => video_en
);

ScreenInst : screen_ctrl
port map
(
	clk => clk,
	rst => rst,
	x_ctrl => pixel_x,
	y_ctrl => pixel_y,
	v_en => video_en,
	video => pixel,
	raddr => rscreen_addr,
	waddr => wscreen_addr,
	data => screen_data,
	read => screen_read,
	done => screen_done
);

VRAMInterface : vram_mod
port map
(
	clk => clk,
	rst => rst,
	addr_0 => io_vram_addr,
	data_0_in => io_data_in,
	data_0_out => io_vram_data,
	we_0 => io_vram_write,
	re_0 => io_vram_read,
	done_0 => io_vram_done,
	addr_1 => screen_raddr,
	data_1_in => "00000000",
	data_1_out => screen_data,
	we_1 => '0',
	re_1 => screen_read,
	done_1 => screen_done,
	addr_2 => clearer_addr,
	data_2_in => "00000000",
	data_2_out => open,
	we_2 => clearer_do,
	re_2 => '0',
	done_2 => clearer_done,
	addr => vram_addr,
	data_out => vram_data_out,
	data_in => vram_data_in,
	we => vram_we,
	oe => vram_oe,
	cs => vram_cs
);

end Behavioral;

-------------------------------------------------------------------------------
