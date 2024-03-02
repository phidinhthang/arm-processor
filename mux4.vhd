library ieee;
use ieee.std_logic_1164.all;

entity mux4 is generic (width: integer := 32);
	port (d0, d1, d2, d3: in std_logic_vector(width-1 downto 0);
			s: in std_logic_vector(1 downto 0);
			y: out std_logic_vector(width-1 downto 0));
end mux4;

architecture synth of mux4 is
begin
	process (all) begin
		case s is
			when "00" => y <= d0;
			when "01" => y <= d1;
			when "10" => y <= d2;
			when others => y <= d3;
		end case;
	end process;
end;