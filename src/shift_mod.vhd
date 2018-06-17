library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--------------------------------------------------------------------------------

entity shift_mod is
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
end entity shift_mod;

--------------------------------------------------------------------------------

architecture Behavioral of shift_mod is

type state_t is (READY, RUNNING);

signal state	: state_t := READY;

signal clock	: std_logic;
signal reset	: std_logic;
signal value	: std_logic_vector(13 downto 0);
signal tmp		: std_logic_vector(13 downto 0);

signal counter	: integer range 0 to 49; -- 50 * 25ns = 1us = Z80 clock cycle

signal in_buf	: std_logic_vector(3 downto 0);
signal out_buf	: std_logic_vector(3 downto 0);

signal s_data_in: std_logic;
signal s_ext_clk: std_logic;
signal s_we		: std_logic;
signal s_exec	: std_logic;
signal s_exec_q : std_logic;

component shift_reg is
	generic
	(
		WIDTH	: integer
	);
	port
	(
		clk		: in std_logic;
		arst	: in std_logic;
		
		d_in	: in std_logic;
		d_out	: out std_logic_vector(WIDTH-1 downto 0)
	);
end component shift_reg;

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


begin --------------------------------------------------------------------------


clock <= s_ext_clk and s_we when state = READY else '0';
value <= tmp when state = RUNNING else (others => '0');
io_addr <= value(13 downto 11);
io_data <= value(10 downto 3);
io_cs_n <= not value(2);
io_rd_n <= not value(1);
io_we_n <= not value(0);


in_buf <= data_in & ext_clk & we & exec;
s_data_in <= out_buf(3);
s_ext_clk <= out_buf(2);
s_we <= out_buf(1);
s_exec <= out_buf(0);


GenDebounce :
for I in in_buf'range generate
	Debounce : debouncer
	generic map
	(
		M => 3
	)
	port map
	(
		clk => clk,
		rst => rst,
		input => in_buf(I),
		output => out_buf(I)
	);
end generate GenDebounce;


IORegister : shift_reg
generic map
(
	WIDTH => 14
)
port map
(
	clk => clock,
	arst => reset,
	d_in => s_data_in,
	d_out => tmp
);


process (clk) is
begin
	if rising_edge(clk) then
		if rst = '1' then
			state <= READY;
			counter <= 0;
		else
			case state is
				when READY =>
					if s_exec = '1' and s_exec_q = '0' then
						state <= RUNNING;
						counter <= 49;
					end if;
				when RUNNING =>
					if counter = 0 then
						state <= READY;
					else
						counter <= counter - 1;
					end if;
			end case;
		end if;
		
		reset <= rst;
		s_exec_q <= s_exec;
	end if;
end process;

end architecture Behavioral;

