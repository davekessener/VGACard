library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-------------------------------------------------------------------------------

entity vgacard_tb is
end vgacard_tb;

-------------------------------------------------------------------------------

architecture Behavioral of vgacard_tb is

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

signal clk				: std_logic;
signal rst				: std_logic;
signal vga_g			: std_logic;
signal vga_hs			: std_logic;
signal vga_vs			: std_logic;
signal io_addr			: std_logic_vector(2 downto 0);
signal io_data_in		: std_logic_vector(7 downto 0);
signal io_data_out		: std_logic_vector(7 downto 0);
signal io_cs			: std_logic;
signal io_rd			: std_logic;
signal io_we			: std_logic;
signal vram_addr		: std_logic_vector(14 downto 0);
signal vram_data_in		: std_logic_vector(7 downto 0);
signal vram_data_out	: std_logic_vector(7 downto 0);
signal vram_cs			: std_logic;
signal vram_we			: std_logic;
signal vram_oe			: std_logic;

constant CLK_PERIOD		: time := 20 ns;

begin -------------------------------------------------------------------------

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
	
	io_addr <= "000";
	io_data_in <= "00000000";
	io_cs <= '0';
	io_rd <= '0';
	io_we <= '0';
	
	wait for 2*CLK_PERIOD;
	
	rst <= '0';
	
	wait for 2 ms;
	
	io_addr <= "011"; -- control port
	io_data_in <= "01011111"; -- enable everything but inverted screen
	io_we <= '1'; -- set flags;
	io_cs <= '1'; -- run
	
	wait for 1 us; -- Z80 clock period
	
	io_we <= '0';
	io_cs <= '0';
	
	wait for 5*CLK_PERIOD;
	
	io_rd <= '1'; -- read back status
	io_cs <= '1';
	
	wait for 1 us;
	
	io_rd <= '0';
	io_cs <= '0';
	
	wait for 5*CLK_PERIOD;
	
	io_addr <= "000"; -- data port
	io_data_in <= "10101001";
	io_we <= '1';
	io_cs <= '1';
	
	wait for 1 us;
	
	io_we <= '0';
	io_cs <= '0';
	
	wait for 5*CLK_PERIOD;

	io_addr <= "000"; -- data port
	io_data_in <= "11000110";
	io_we <= '1';
	io_cs <= '1';
	
	wait for 1 us;
	
	io_we <= '0';
	io_cs <= '0';
	
	wait for 5*CLK_PERIOD;

	io_addr <= "000"; -- data port
	io_data_in <= "00000001";
	io_we <= '1';
	io_cs <= '1';
	
	wait for 1 us;
	
	io_we <= '0';
	io_cs <= '0';
	
	wait for 5*CLK_PERIOD;

	io_addr <= "000"; -- data port
	io_data_in <= "00000010";
	io_we <= '1';
	io_cs <= '1';
	
	wait for 1 us;
	
	io_we <= '0';
	io_cs <= '0';
	
	wait for 5*CLK_PERIOD;
	
	wait for 100 ms;
end process Stimulation;

process (vram_addr) is
begin
	vram_data_in <= vram_addr(7 downto 0);
end process;

UUT : vgacard_mod
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

end Behavioral;
