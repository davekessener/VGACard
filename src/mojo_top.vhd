library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-------------------------------------------------------------------------------

entity mojo_top is
	generic
	(
		VERSION_MAJOR	: integer := 2;
		VERSION_MINOR	: integer := 1
	);
	port
	(
		clk				: in std_logic;
		rst_n			: in std_logic;

		led				: out std_logic_vector(7 downto 0);

		vga_g			: out std_logic;
		vga_hs			: out std_logic;
		vga_vs			: out std_logic;

--		io_addr			: in std_logic_vector(2 downto 0);
--		io_data			: inout std_logic_vector(7 downto 0);
--		io_cs_n			: in std_logic;
--		io_rd_n			: in std_logic;
--		io_we_n			: in std_logic;

		vram_addr		: out std_logic_vector(14 downto 0);
		vram_data		: inout std_logic_vector(7 downto 0);
		vram_cs_n		: out std_logic;
		vram_we_n		: out std_logic;
		vram_oe_n		: out std_logic;
		
		shift_clock		: in std_logic;
		shift_data_in	: in std_logic;
		shift_write		: in std_logic;
		shift_exec		: in std_logic
	);
end entity mojo_top;

-------------------------------------------------------------------------------

architecture Behavioral of mojo_top is


signal rst				: std_logic;


signal io_cs			: std_logic;
signal io_rd			: std_logic;
signal io_we			: std_logic;

signal io_data_in		: std_logic_vector(7 downto 0);
signal io_data_out		: std_logic_vector(7 downto 0);


signal vram_cs			: std_logic;
signal vram_we			: std_logic;
signal vram_oe			: std_logic;

signal vram_data_in		: std_logic_vector(7 downto 0);
signal vram_data_out	: std_logic_vector(7 downto 0);


-- tmp
signal io_addr			: std_logic_vector(2 downto 0);
signal io_data			: std_logic_vector(7 downto 0);
signal io_cs_n			: std_logic;
signal io_rd_n			: std_logic;
signal io_we_n			: std_logic;

component vgacard_mod is
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
end component vgacard_mod;

component shift_mod is
	port
	(
		clk				: in std_logic;
		rst				: in std_logic;

		data_in			: in std_logic;
		ext_clk			: in std_logic;
		we				: in std_logic;
		exec			: in std_logic;

		io_addr			: out std_logic_vector(2 downto 0);
		io_data			: out std_logic_vector(7 downto 0);
		io_cs_n			: out std_logic;
		io_rd_n			: out std_logic;
		io_we_n			: out std_logic
	);
end component shift_mod;

begin -------------------------------------------------------------------------

rst <= not rst_n;

led <=   std_logic_vector(to_unsigned(VERSION_MAJOR, led'length / 2))
	   & std_logic_vector(to_unsigned(VERSION_MINOR, (led'length+1) / 2));

io_cs <= not io_cs_n;
io_rd <= not io_rd_n;
io_we <= not io_we_n;
io_data_in <= io_data;

vram_cs_n <= not vram_cs;
vram_we_n <= not vram_we;
vram_oe_n <= not vram_oe;
vram_data_in <= vram_data;

--IOBusDriver : process (io_rd, io_data_out)
--begin
--	if io_rd = '1' then
--		io_data <= io_data_out;
--	else
--		io_data <= (others => 'Z');
--	end if;
--end process IOBufDriver;

VRAMBusDriver : process (vram_we, vram_data_out)
begin
	if vram_we = '1' then
		vram_data <= vram_data_out;
	else
		vram_data <= (others => 'Z');
	end if;
end process VRAMBusDriver;


ShiftReader : shift_mod
port map
(
	clk => clk,
	rst => rst,
	data_in => shift_data_in,
	ext_clk => shift_clock,
	we => shift_write,
	exec => shift_exec,
	io_addr => io_addr,
	io_data => io_data,
	io_cs_n => io_cs_n,
	io_rd_n => io_rd_n,
	io_we_n => io_we_n
);

VGACard : vgacard_mod
port map
(
	clk => clk,
	rst => rst,
	vga_g => vga_g,
	vga_hs => vga_hs,
	vga_vs => vga_vs,
	io_addr => io_addr,
	io_data_in => io_data_in,
	io_data_out => io_data_out,
	io_cs => io_cs,
	io_rd => io_rd,
	io_we => io_we,
	vram_addr => vram_addr,
	vram_data_in => vram_data_in,
	vram_data_out => vram_data_out,
	vram_cs => vram_cs,
	vram_we => vram_we,
	vram_oe => vram_oe
);

end architecture Behavioral;
