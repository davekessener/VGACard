library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-------------------------------------------------------------------------------

entity status_mod is
	port
	(
		clk				: in std_logic;
		rst				: in std_logic;
		
		screen_en		: out std_logic;
		
		addr			: in std_logic_vector(2 downto 0);
		data_in			: in std_logic_vector(7 downto 0);
		data_out		: out std_logic_vector(7 downto 0);
		cs				: in std_logic;
		rd				: in std_logic;
		we				: in std_logic;
		clear_ack		: in std_logic;
		
		cursor_in		: in std_logic_vector(15 downto 0);
		cursor_out		: out std_logic_vector(7 downto 0);
		cursor_advance	: out std_logic;
		cursor_act		: out std_logic;
		cursor_nl		: out std_logic;
		cursor_force	: out std_logic;
		cursor_move		: out std_logic_vector(1 downto 0);
		vram_data		: in std_logic_vector(7 downto 0);
		
		advX			: out std_logic;
		advY			: out std_logic;
		wrapX			: out std_logic;
		scroll_en		: out std_logic;
		invert_en		: out std_logic;
		cursor_en		: out std_logic;
		
		frame			: out std_logic;
		set_cursor_x	: out std_logic;
		set_cursor_y	: out std_logic;
		
		vram_write		: out std_logic;
		vram_read		: out std_logic
	);
end entity status_mod;

-------------------------------------------------------------------------------

architecture Behavioral of status_mod is

signal status_bus		: std_logic_vector(6 downto 0);

signal s_frame			: std_logic;
signal s_clear_queue	: std_logic;
signal s_write_lock		: std_logic;

begin -------------------------------------------------------------------------

cursor_en <= status_bus(0);
advX <= status_bus(1);
wrapX <= status_bus(2);
advY <= status_bus(3);
scroll_en <= status_bus(4);
invert_en <= status_bus(5);
screen_en <= status_bus(6);

frame <= s_frame;

process (clk) is
begin
	if rising_edge(clk) then
		cursor_out <= (others => '0');
		set_cursor_x <= '0';
		set_cursor_y <= '0';
		vram_write <= '0';
		vram_read <= '0';
		cursor_move <= "00";
		cursor_act <= '0';
		cursor_nl <= '0';
		cursor_force <= '0';
		cursor_advance <= '0';
	
		if rst = '1' then
			status_bus <= (others => '0'); --"1011111";
			s_frame <= '0';
			data_out <= (others => '0');
			s_clear_queue <= '0';
			s_write_lock <= '0';
		else
			if s_clear_queue = '1' and clear_ack = '0' then
				s_frame <= not s_frame;
				s_clear_queue <= '0';
			end if;
			
			if cs = '1' then
				if rd = '1' then
					case addr is
						when "000" =>
							vram_read <= '1';
							data_out <= vram_data;
						when "001" =>
							data_out <= cursor_in(15 downto 8);
						when "010" =>
							data_out <= cursor_in(7 downto 0);
						when "011" =>
							data_out <= "0" & status_bus;
						when others =>
					end case;
				elsif we = '1' and s_write_lock = '0' then
					case addr is
						when "000" =>
							case data_in is
								when "00001000" =>
									cursor_move <= "00";
									cursor_act <= '1';
								when "00001101" =>
									cursor_nl <= '1';
								when "00010001" =>
									cursor_move <= "00";
									cursor_act <= '1';
								when "00010010" =>
									cursor_move <= "01";
									cursor_act <= '1';
								when "00010011" =>
									cursor_move <= "10";
									cursor_act <= '1';
								when "00010100" =>
									cursor_move <= "11";
									cursor_act <= '1';
								when others =>
									vram_write <= '1';
									cursor_advance <= '1';
							end case;
						when "001" =>
							cursor_out <= data_in;
							set_cursor_x <= '1';
						when "010" =>
							cursor_out <= data_in;
							set_cursor_y <= '1';
						when "011" =>
							if data_in(7) = '1' then
								case data_in(6 downto 0) is
									when "0000000" =>
										if clear_ack = '0' then
											s_frame <= not s_frame;
										else
											s_clear_queue <= '1';
										end if;
									when "0000001" =>
										cursor_force <= '1';
									when others =>
								end case;
							else
								status_bus <= data_in(6 downto 0);
							end if;
						when others =>
					end case;
				end if;
			end if;
			
			s_write_lock <= we;
		end if;
	end if;
end process;

end Behavioral;
