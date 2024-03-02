library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.util.all;

entity datamem is generic (addrlen: integer := 32;
									wordlen: integer := 32;
									numword: integer := 1);
		port (clk, reset: in std_logic;
				we: in std_logic;
				a: in std_logic_vector (addrlen-1 downto 0);
				wd: in std_logic_vector (wordlen-1 downto 0);
				rd: out std_logic_vector (wordlen-1 downto 0));
end datamem;

architecture synth of datamem is
	signal data: dmemtype (0 to numword-1) (wordlen-1 downto 0) := (others => (others => '0'));
begin
	process (clk, reset) begin
		if reset then
			data <= (others => (others => '0'));
		elsif rising_edge (clk) then
			if we then
				data(to_integer(unsigned(a))) <= wd;
			end if;
		end if;
	end process;
	
	rd <= data(to_integer(unsigned(a)));
end;