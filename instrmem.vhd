library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.util.all;

entity instrmem is generic (addrlen: integer := 32;
										wordlen: integer := 32;
										numword: integer := 1);
	port (data: in imemtype (0 to numword-1) (wordlen-1 downto 0);
			addr: in std_logic_vector (addrlen-1 downto 0);
			instr: out std_logic_vector (wordlen-1 downto 0));
end instrmem;

architecture synth of instrmem is
begin
	instr <= data(to_integer(unsigned(addr)));
end;