library ieee;
use ieee.std_logic_1164.all;

entity extend is
	port (ImmSrc: in std_logic_vector (1 downto 0);
			Imm: in std_logic_vector (23 downto 0);
			ExtImm: out std_logic_vector (31 downto 0));	
end extend;

architecture synth of extend is
begin
	process begin
		case? ImmSrc is
			when b"00" => ExtImm <= (31 downto 8 => '0') & Imm(7 downto 0);
			when b"01" => ExtImm <= (31 downto 12 => '0') & Imm(11 downto 0);
			when b"1-" => ExtImm <= (31 downto 24 => Imm(23)) & Imm(23 downto 0);
		end case?;
	end process;
end;