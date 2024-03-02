library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regfile is generic (width: integer := 32);
	port (clk, we3: in std_logic;
			ra1, ra2, wa3: in std_logic_vector (3 downto 0);
			wd3: in std_logic_vector (width-1 downto 0);
			r15: in std_logic_vector (width-1 downto 0);
			rd1, rd2: out std_logic_vector (width-1 downto 0));
end regfile;

architecture synth of regfile is
	type ram_type is array (15 downto 0) of std_logic_vector (width-1 downto 0);
	signal ram_block: ram_type := (others => (others => '0'));
begin
	process (clk) begin
		if rising_edge (clk) then
			if we3 = '1' then
				ram_block(to_integer(unsigned(wa3))) <= wd3;
			end if;
		end if;
	end process;
	
	rd1 <= r15 when to_integer(unsigned(ra1)) = 15 else ram_block(to_integer(unsigned(ra1)));
	rd2 <= r15 when to_integer(unsigned(ra2)) = 15 else ram_block(to_integer(unsigned(ra2)));
end;