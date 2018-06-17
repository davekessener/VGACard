library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-------------------------------------------------------------------------------

entity swap_buf is
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
end entity swap_buf;

-------------------------------------------------------------------------------

architecture Behavioral of swap_buf is

signal data_0	: std_logic_vector(7 downto 0);
signal data_1	: std_logic_vector(7 downto 0);

signal we_hi	: std_logic;
signal we_lo	: std_logic;

signal buf_sel	: std_logic;

component buf_mod is
	port
	(
		clk		 : in std_logic;
		rst		 : in std_logic;
		
		addr_in	 : in integer range 0 to 79;
		data_in	 : in std_logic_vector(7 downto 0);
		we		 : in std_logic;
		
		addr_out : in integer range 0 to 79;
		data_out : out std_logic_vector(7 downto 0)
	);
end component buf_mod;

begin -------------------------------------------------------------------------

data_out <= data_0 when buf_sel = '1' else data_1;
we_hi <= we and not switch;
we_lo <= we and switch;

BufferHigh : buf_mod
port map
(
	clk => clk,
	rst => rst,
	addr_in => addr_in,
	data_in => data_in,
	we => we_hi,
	addr_out => addr_out,
	data_out => data_0
);

BufferLow : buf_mod
port map
(
	clk => clk,
	rst => rst,
	addr_in => addr_in,
	data_in => data_in,
	we => we_lo,
	addr_out => addr_out,
	data_out => data_1
);

process (clk) is
begin
	if rising_edge(clk) then
		buf_sel <= switch;
	end if;
end process;

end Behavioral;
