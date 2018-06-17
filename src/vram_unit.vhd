library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-------------------------------------------------------------------------------

entity vram_unit is
	port
	(
		clk				: in std_logic;
		rst				: in std_logic;

		ctrl_addr		: in std_logic_vector(14 downto 0);
		ctrl_data_in	: in std_logic_vector(7 downto 0);
		ctrl_data_out	: out std_logic_vector(7 downto 0);
		ctrl_we			: in std_logic;
		ctrl_oe			: in std_logic;
		ctrl_done		: out std_logic;

		screen_addr		: in std_logic_vector(14 downto 0);
		screen_data_in	: in std_logic_vector(7 downto 0);
		screen_data_out	: out std_logic_vector(7 downto 0);
		screen_we		: in std_logic;
		screen_oe		: in std_logic;
		screen_done		: out std_logic;

		addr			: out std_logic_vector(14 downto 0);
		data_in			: in std_logic_vector(7 downto 0);
		data_out		: out std_logic_vector(7 downto 0);
		cs				: out std_logic;
		we				: out std_logic;
		oe				: out std_logic
	);
end entity vram_unit;

--------------------------------------------------------------------------------

architecture Behavioral of vram_unit is

constant T : integer := 2;

type state_t is (READY, READING, WRITING, WAITING);
type selected_t is (NONE, CTRL, SCREEN);
type iostate_t is (IDLE, RUNNING);

signal state	: state_t := READY;
signal selected	: selected_t := NONE;
signal iostate	: iostate_t := IDLE;

signal addr_buf	: std_logic_vector(14 downto 0);
signal data_buf	: std_logic_vector(7 downto 0);

signal timer	: integer range 0 to T := 0;


begin --------------------------------------------------------------------------


iostate <= RUNNING when state = READING or state = WRITING else IDLE;
addr <= addr_buf when iostate = RUNNING else (others => '0');
data_out <= data_buf when state = WRITING else (others => '0');
ctrl_data_out <= data_buf when state = WAITING and selected = CTRL else (others => '0');
screen_data_out <= data_buf when state = WAITING and selected = SCREEN else (others => '0');
we <= '1' when state = WRITING else '0';
oe <= '1' when state = READING else '0';
cs <= '1' when iostate = RUNNING else '0';
ctrl_done <= '1' when state = WAITING and selected = CTRL else '0';
screen_done <= '1' when state = WAITING and selected = SCREEN else '0';

process (clk) is
begin
	if rising_edge(clk) then
		if rst = '1' then
			state <= READY;
			selected <= NONE;
			timer <= 0;
			addr_buf <= (others => '0');
			data_buf <= (others => '0');
		else
			case state is
				when READY =>
					if ctrl_we = '1' then
						state <= WRITING;
						selected <= CTRL;
						addr_buf <= ctrl_addr;
						data_buf <= ctrl_data_in;
					elsif ctrl_oe = '1' then
						state <= READING;
						selected <= CTRL;
						addr_buf <= ctrl_addr;
					elsif screen_we = '1' then
						state <= WRITING;
						selected <= SCREEN;
						addr_buf <= screen_addr;
						data_buf <= screen_data_in;
					elsif screen_oe = '1' then
						state <= READING;
						selected <= SCREEN;
						addr_buf <= screen_addr;
					end if;
				when READING =>
					if timer = 0 then
						state <= WAITING;
						data_buf <= data_in;
					end if;
				when WRITING =>
					if timer = 0 then
						state <= WAITING;
					end if;
				when WAITING =>
					case selected is
						when NONE =>
							state <= READY;
						when CTRL =>
							if ctrl_we = '0' and ctrl_oe = '0' then
								state <= READY;
							end if;
						when SCREEN =>
							if screen_we = '0' and screen_oe = '0' then
								state <= READY;
							end if;
					end case;
			end case;

			if iostate = RUNNING then
				timer <= timer - 1;
			else
				timer <= T;
			end if;
		end if;
	end if;
end process;

end architecture Behavioral;

