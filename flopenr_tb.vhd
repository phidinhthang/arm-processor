library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
use std.textio.all;

entity flopenr_tb is
end flopenr_tb;

architecture sim of flopenr_tb is
	component flopenr generic (width: integer);
		port (clk, reset, en: in std_logic;
				d: in std_logic_vector(width-1 downto 0);
				q: out std_logic_vector(width-1 downto 0));
	end component;
	signal clk, reset, en: std_logic;
	signal d, q: std_logic_vector(3 downto 0);
	signal q_expected: std_logic_vector(3 downto 0);
begin
	dut: flopenr generic map (4)
		port map (clk, reset, en, d, q);
		
	process begin
		clk <= '1'; wait for 5 ns;
		clk <= '0'; wait for 5 ns;
	end process;
	
	process is
		file tv: text;
		variable L: line;
		variable vector_in: std_logic_vector(5 downto 0);
		variable dummy: character;
		variable vector_out: std_logic_vector(3 downto 0);
		variable vectornum: integer := 0;
		variable errors: integer := 0;
	begin
		file_open (tv, "C:/intelFPGA_lite/22.1std/applications/learn_vhdl/arm3/flopenr_tb.txt", read_mode);
		wait for 10 ns;
		
		while not endfile (tv) loop
			wait until falling_edge (clk);
			
			readline (tv, L);
			read (L, vector_in);
			read (L, dummy);
			read (L, vector_out);
			reset <= vector_in(5) after 1 ns;
			en <= vector_in(4) after 1 ns;
			d <= vector_in(3 downto 0) after 1 ns;
			q_expected <= vector_out after 1 ns;
			
			wait until rising_edge (clk);
			wait for 1 ns;
			if q /= q_expected then
				report "Error: q = " & integer'image(to_integer(unsigned(q))) &
							" q_expected = " & integer'image(to_integer(unsigned(q_expected)));
				errors := errors + 1;
			end if;
			
			vectornum := vectornum + 1;
		end loop;
		
		if (errors = 0) then
			report "NO ERRORS -- " &
						integer'image(vectornum) &
						" tests completed successfully."
						severity failure;
		else
			report integer'image(vectornum) &
						" tests completed, errors =" &
						integer'image(errors)
						severity failure;
		end if;

	end process;
end;