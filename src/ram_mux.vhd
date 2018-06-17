library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-------------------------------------------------------------------------------

entity ram_mux is
	port
	(
		clk				: in std_logic;
		rst				: in std_logic;
		
		addr_0			: in std_logic_vector(14 downto 0);
		data_in_0		: in std_logic_vector(7 downto 0);
		data_out_0		: out std_logic_vector(7 downto 0);
		read_0			: in std_logic;
		write_0			: in std_logic;
		done_0			: out std_logic;
		
		addr_1			: in std_logic_vector(14 downto 0);
		data_in_1		: in std_logic_vector(7 downto 0);
		data_out_1		: out std_logic_vector(7 downto 0);
		read_1			: in std_logic;
		write_1			: in std_logic;
		done_1			: out std_logic;
		
		addr			: out std_logic_vector(14 downto 0);
		data_in			: in std_logic_vector(7 downto 0);
		data_out		: out std_logic_vector(7 downto 0);
		do_read			: out std_logic;
		do_write		: out std_logic;
		done			: in std_logic
	);
end entity ram_mux;

-------------------------------------------------------------------------------

architecture Behavioral of ram_mux is

type state_t is (READY, IO_0, IO_1);

signal state : state_t := READY;

begin -------------------------------------------------------------------------

data_out_0 <= data_in when state = IO_0 else (others => '0');
data_out_1 <= data_in when state = IO_1 else (others => '0');

done_0 <= done when state = IO_0 else '0';
done_1 <= done when state = IO_1 else '0';

process (clk) is
begin
	if rising_edge(clk) then
		if rst = '1' then
			state <= READY;
			addr <= (others => '0');
			data_out <= (others => '0');
			do_read <= '0';
			do_write <= '0';
		else
			case state is
				when READY =>
					if read_0 = '1' or write_0 = '1' then
						state <= IO_0;
						addr <= addr_0;
						data_out <= data_in_0;
						do_read <= read_0;
						do_write <= write_0;
					elsif read_1 = '1' or write_1 = '1' then
						state <= IO_1;
						addr <= addr_1;
						data_out <= data_in_1;
						do_read <= read_1;
						do_write <= write_1;
					end if;
				when IO_0 =>
					if done = '1' then
						state <= READY;
						addr <= (others => '0');
						data_out <= (others => '0');
						do_read <= '0';
						do_write <= '0';
					end if;
				when IO_1 =>
					if done = '1' then
						state <= READY;
						addr <= (others => '0');
						data_out <= (others => '0');
						do_read <= '0';
						do_write <= '0';
					end if;
			end case;
		end if;
	end if;
end process;

end Behavioral;
