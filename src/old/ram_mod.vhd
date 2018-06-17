library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-------------------------------------------------------------------------------

entity ram_mod is
	port
	(
		clk			: in std_logic;
		rst			: in std_logic;
		
		addr_0		: in std_logic_vector(14 downto 0);
		data_0_in	: in std_logic_vector(7 downto 0);
		data_0_out	: out std_logic_vector(7 downto 0);
		we_0		: in std_logic;
		re_0		: in std_logic;
		done_0		: out std_logic;
		
		addr_1		: in std_logic_vector(14 downto 0);
		data_1_out	: out std_logic_vector(7 downto 0);
		re_1		: in std_logic;
		done_1		: out std_logic;
		
		addr		: out std_logic_vector(14 downto 0);
		data_in		: in std_logic_vector(7 downto 0);
		data_out	: out std_logic_vector(7 downto 0);
		we			: out std_logic;
		oe			: out std_logic;
		cs			: out std_logic
	);
end entity ram_mod;

-------------------------------------------------------------------------------

architecture Behavioral of ram_mod is

type state_t is (READY, READ0, WRITE0, READ1, WAITING0, WAITING1);
type iostate_t is (IDLE, RUNNING);

signal s_addr	: std_logic_vector(14 downto 0);
signal s_data	: std_logic_vector(7 downto 0);

signal state	: state_t := READY;
signal iostate	: iostate_t := IDLE;

signal timer	: integer range 0 to 4 := 0;

begin -------------------------------------------------------------------------

addr <= s_addr when iostate = RUNNING else (others => '0');
data_out <= s_data when state = WRITE0 else (others => '0');
data_0_out <= s_data when state = WAITING0 else (others => '0');
data_1_out <= s_data when state = WAITING1 else (others => '0');
we <= '1' when state = WRITE0 else '0';
oe <= '1' when state = READ0 or state = READ1 else '0';
cs <= '1' when iostate = RUNNING else '0';
done_0 <= '1' when state = WAITING0 else '0';
done_1 <= '1' when state = WAITING1 else '0';

process (clk) is
begin
	if rising_edge(clk) then
		if rst = '1' then
			state <= READY;
			iostate <= IDLE;
			s_addr <= (others => '0');
			s_data <= (others => '0');
			timer <= 0;
		else
			case state is
				when READY =>
					if we_0 = '1' then
						state <= WRITE0;
						timer <= 4;
						s_addr <= addr_0;
						s_data <= data_0_in;
						iostate <= RUNNING;
					elsif re_0 = '1' then
						state <= READ0;
						timer <= 4;
						s_addr <= addr_0;
						iostate <= RUNNING;
					elsif re_1 = '1' then
						state <= READ1;
						timer <= 4;
						s_addr <= addr_1;
						iostate <= RUNNING;
					end if;
				when READ0 =>
					if timer = 0 then
						state <= WAITING0;
						s_data <= data_in;
						iostate <= IDLE;
					end if;
				when WRITE0 =>
					if timer = 0 then
						state <= WAITING0;
						iostate <= IDLE;
					end if;
				when READ1 =>
					if timer = 0 then
						state <= WAITING1;
						s_data <= data_in;
						iostate <= IDLE;
					end if;
				when WAITING0 =>
					if re_0 = '0' and we_0 = '0' then
						state <= READY;
					end if;
				when WAITING1 =>
					if re_1 = '0' then
						state <= READY;
					end if;
			end case;
			
			if iostate = RUNNING and timer > 0 then
				timer <= timer - 1;
			end if;
		end if;
	end if;
end process;

end Behavioral;
