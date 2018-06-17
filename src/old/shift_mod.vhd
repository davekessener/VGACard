library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-------------------------------------------------------------------------------

entity shift_mod is
	port
	(
		clk			: in std_logic;
		rst			: in std_logic;
		
		addr_in		: in std_logic;
		data_in		: in std_logic;
		shift_clk	: in std_logic;
		w_en		: in std_logic;
		o_en		: in std_logic;
		
		addr		: out std_logic_vector(14 downto 0);
		data		: out std_logic_vector(7 downto 0);
		do			: out std_logic;
		done		: in std_logic
	);
end shift_mod;

-------------------------------------------------------------------------------

architecture Behavioral of shift_mod is

type states is (READING, WRITING, WAITING);

signal clk_buf	: std_logic;
signal addr_buf : std_logic_vector(14 downto 0);
signal data_buf : std_logic_vector(7 downto 0);

signal state : states := READING;

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

begin -------------------------------------------------------------------------

--addr	<= addr_buf when state = WRITING else (others => '0');
--data	<= data_buf when state = WRITING else (others => '0');
do		<= '1' when state = WRITING else '0';

clk_buf	<= shift_clk and w_en when state = READING else '0';

AddressRegister : shift_reg
generic map
(
	WIDTH => 15
)
port map
(
	clk => clk_buf,
	arst => rst,
	d_in => addr_in,
	d_out => addr_buf
);

DataRegister : shift_reg
generic map
(
	WIDTH => 8
)
port map
(
	clk => clk_buf,
	arst => rst,
	d_in => data_in,
	d_out => data_buf
);

process (clk) is
begin
	if rising_edge(clk) then
		if rst = '1' then
			state <= READING;
			addr <= (others => '0');
			data <= (others => '0');
		else
			case state is
				when READING =>
					if o_en = '1' then
						state <= WRITING;
						addr <= addr_buf;
						data <= data_buf;
					end if;
				when WRITING =>
					if done = '1' then
						state <= WAITING;
					end if;
				when WAITING =>
					if o_en = '0' then
						state <= READING;
					end if;
			end case;
		end if;
	end if;
end process;

end Behavioral;
