-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-------------------------------------------------------------------------------

entity mojo_tb is
end mojo_tb;

-------------------------------------------------------------------------------

architecture Behavioral of mojo_tb is

signal clk				: std_logic;
signal rst_n			: std_logic;
signal led				: std_logic_vector(7 downto 0);
signal vga_g			: std_logic;
signal vga_hs			: std_logic;
signal vga_vs			: std_logic;
signal ram_addr			: std_logic_vector(14 downto 0);
signal ram_data			: std_logic_vector(7 downto 0);
signal ram_cs_n			: std_logic;
signal ram_we_n			: std_logic;
signal ram_oe_n			: std_logic;
signal shift_data_in	: std_logic;
signal shift_exec		: std_logic;
signal shift_write		: std_logic;
signal shift_clock		: std_logic;

signal counter			: integer range 0 to 25599;

component mojo_top is
	generic
	(
		VERSION_MAJOR	: integer;
		VERSION_MINOR	: integer
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
end component mojo_top;

constant CLK_PERIOD : time := 20 ns;

begin -------------------------------------------------------------------------

--ram_data <= std_logic_vector(to_unsigned(counter / 100, ram_data'length));

Clock : process is
begin
	clk <= '0';
	wait for CLK_PERIOD/2;
	clk <= '1';
	wait for CLK_PERIOD/2;
end process Clock;

process (clk) is
begin
	if rising_edge(clk) then
		if rst_n = '0' then
			counter <= 0;
		else
			counter <= counter + 1;
		end if;
	end if;
end process;

Stimulus : process is
begin
	rst_n <= '0';
	shift_data_in <= '0';
	shift_exec <= '0';
	shift_write <= '0';
	
	wait for CLK_PERIOD*2;
	
	rst_n <= '1';
	
	wait for 100 ms;
end process Stimulus;

ShiftClock : process is
begin
	shift_clock <= '0';
	wait for CLK_PERIOD*2;
	shift_clock <= '1';
	wait for CLK_PERIOD*2;
end process ShiftClock;

UUT : mojo_top
generic map
(
	VERSION_MAJOR => 2,
	VERSION_MINOR => 1
)
port map
(
	clk => clk,
	rst_n => rst_n,
	led => led,
	vga_g => vga_g,
	vga_hs => vga_hs,
	vga_vs => vga_vs,
	vram_addr => ram_addr,
	vram_data => ram_data,
	vram_cs_n => ram_cs_n,
	vram_we_n => ram_we_n,
	vram_oe_n => ram_oe_n,
	shift_data_in => shift_data_in,
	shift_exec => shift_exec,
	shift_write => shift_write,
	shift_clock => shift_clock
);

end Behavioral;
