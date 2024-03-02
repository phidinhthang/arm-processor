library ieee;
use ieee.std_logic_1164.all;

entity flopenr is generic (width: integer := 4);
	port (clk, reset, en: in std_logic;
			d: in std_logic_vector(width-1 downto 0);
			q: out std_logic_vector(width-1 downto 0));
end flopenr;

architecture synth of flopenr is
begin
	process (clk, reset) begin
		if reset then
			q <= (others => '0');
		elsif rising_edge (clk) then
			if en then
				q <= d;
			end if;
		end if;
	end process;
end;