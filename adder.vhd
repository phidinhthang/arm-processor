library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity adder is generic (width: integer := 32);
	port (a, b: in std_logic_vector(width-1 downto 0);
			cin: in std_logic;
			y: out std_logic_vector(width-1 downto 0);
			cout: out std_logic);
end adder;

architecture synth of adder is
	signal s: std_logic_vector(width downto 0);
begin	
	s <= ('0' & a) + ('0' & b) + cin;
	cout <= s(width);
	y <= s(width-1 downto 0);
end;