library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-------------------------------------------------------------------------------

entity sync_mod is
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
end entity sync_mod;

-------------------------------------------------------------------------------

architecture Behavioral of sync_mod is

constant HR		: integer := 640;
constant HFP	: integer := 16;
constant HBP	: integer := 48;
constant HRet	: integer := 96;

constant VR		: integer := 480;
constant VFP	: integer := 10;
constant VBP	: integer := 33;
constant VRet	: integer := 2;


signal counter_h, counter_h_next : integer range 0 to 799;
signal counter_v, counter_v_next : integer range 0 to 524;

signal counter_mod2, counter_mod2_next : std_logic := '0';

signal h_end, v_end : std_logic := '0';

signal hs_buffer, hs_buffer_next : std_logic := '0';
signal vs_buffer, vs_buffer_next : std_logic := '0';

signal x_counter, x_counter_next : integer range 0 to 900;
signal y_counter, y_counter_next : integer range 0 to 511;

signal video : std_logic;

begin -------------------------------------------------------------------------

video <= '1' 
	when (counter_v >= VBP)     and 
		 (counter_v < VBP + VR) and 
		 (counter_h >= HBP)     and 
		 (counter_h < HBP + HR)
	else '0';

counter_mod2_next <= not counter_mod2;

h_end <= '1' when counter_h = 799 else '0';
v_end <= '1' when counter_v = 524 else '0';

hs_buffer_next <= '1' when counter_h < 704 else '0';
vs_buffer_next <= '1' when counter_v < 523 else '0';

y_ctrl   <= conv_std_logic_vector(y_counter, 9);
x_ctrl   <= conv_std_logic_vector(x_counter, 10);
h_s      <= hs_buffer;
v_s      <= vs_buffer;
video_en <= video;

process (clk,rst) is
begin
	if rst = '1' then
		counter_h <= 0;
		counter_v <= 0;
		hs_buffer <= '0';
		vs_buffer <= '0';
		counter_mod2 <= '0';
	elsif rising_edge(clk) then
		if en = '1' then
			counter_h <= counter_h_next;
			counter_v <= counter_v_next;
			x_counter <= x_counter_next;
			y_counter <= y_counter_next;
			hs_buffer <= hs_buffer_next;
			vs_buffer <= vs_buffer_next;
			counter_mod2 <= counter_mod2_next;
		end if;
	end if;
end process;

process (counter_h, counter_mod2, h_end) is
begin
	counter_h_next <= counter_h;
	
	if counter_mod2 = '1' then
		if h_end = '1' then
			counter_h_next <= 0;
		else
			counter_h_next <= counter_h + 1;
		end if;
	end if;
end process;

process (counter_v, counter_mod2, h_end, v_end) is
begin
	counter_v_next <= counter_v;
	
	if counter_mod2 = '1' and h_end = '1' then
		if v_end = '1' then
			counter_v_next <= 0;
		else
			counter_v_next <= counter_v + 1;
		end if;
	end if;
end process;

process (x_counter, counter_mod2, h_end, video) is
begin
	x_counter_next <= x_counter;
	
	if video = '1' then
		if counter_mod2 = '1' then
			if x_counter = 639 then
				x_counter_next <= 0;
			else
				x_counter_next <= x_counter + 1;
			end if;
		end if;
	else
		x_counter_next <= 0;
	end if;
end process;

process (y_counter, counter_mod2, h_end, counter_v) is
begin
	y_counter_next <= y_counter;
	
	if counter_mod2 = '1' and h_end = '1' then
		if counter_v > 32 and counter_v < 512 then
			y_counter_next <= y_counter + 1;
		else
			y_counter_next <= 0;
		end if;
	end if;
end process;

end Behavioral;
