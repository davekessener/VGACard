library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-------------------------------------------------------------------------------

entity clear_mod is
	port
	(
		clk				: in std_logic;
		rst				: in std_logic;
		
		screen_en		: out std_logic;
		acknowledge		: out std_logic;
		
		vram_addr		: out std_logic_vector(14 downto 0);
		vram_do			: out std_logic;
		vram_done		: in std_logic;
		
		frame			: in std_logic
	);
end entity clear_mod;

-------------------------------------------------------------------------------

architecture Behavioral of clear_mod is

constant ROWS : integer := 60;
constant COLS : integer := 80;
constant CHARS : integer := COLS*ROWS;

type state_t is (INITIALIZING, READY, RUNNING);

signal state : state_t := INITIALIZING;

signal count : integer range 0 to CHARS-1;

signal frame_off : integer range 0 to 1;

signal s_frame : std_logic;
signal s_vram_do : std_logic;

begin -------------------------------------------------------------------------

screen_en <= '0' when state = INITIALIZING else '1';
acknowledge <= '1' when state = RUNNING else '0';

vram_addr <= (others => '0') when state = READY 
	else std_logic_vector(to_unsigned(frame_off * CHARS + count, vram_addr'length));
vram_do <= '0' when state = READY else s_vram_do;

process (clk) is
begin
	if rising_edge(clk) then
		if rst = '1' then
			state <= INITIALIZING;
			frame_off <= 0;
			count <= 0;
			s_frame <= '0';
			s_vram_do <= '0';
		else
			s_vram_do <= not vram_done;
			
			case state is
				when INITIALIZING =>
					if vram_done = '1' then
						if count = CHARS-1 then
							if frame_off = 0 then
								frame_off <= 1;
							else
								state <= READY;
							end if;
						end if;

						if count < CHARS-1 then
							count <= count + 1;
						else
							count <= 0;
						end if;
					end if;
				when RUNNING =>
					if vram_done = '1' then
						if count = CHARS-1 then
							state <= READY;
						end if;
						
						if count < CHARS-1 then
							count <= count + 1;
						else
							count <= 0;
						end if;
					end if;
				when READY =>
					if s_frame /= frame then
						state <= RUNNING;
						count <= 0;
						
						if frame = '0' then
							frame_off <= 1;
						else
							frame_off <= 0;
						end if;
					end if;
			end case;
			
			s_frame <= frame;
		end if;
	end if;
end process;

end Behavioral;
