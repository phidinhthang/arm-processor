library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
use std.textio.all;

entity datamem_tb is
end datamem_tb;

architecture sim of datamem_tb is
	component datamem generic (addrlen: integer := 32;
									wordlen: integer := 32;
									numword: integer := 1);
				port (clk, reset: in std_logic;
						we: in std_logic;
						a: in std_logic_vector (addrlen-1 downto 0);
						wd: in std_logic_vector (wordlen-1 downto 0);
						rd: out std_logic_vector (wordlen-1 downto 0));
	end component;
	signal clk, reset: std_logic;
	signal we: std_logic;
	signal a: std_logic_vector (5 downto 0);
	signal wd: std_logic_vector (15 downto 0);
	signal rd: std_logic_vector (15 downto 0);
	signal rdtrue: std_logic_vector (15 downto 0);
begin
	dut: datamem generic map (6, 16, 8) 
		port map (clk, reset, we, a, wd, rd);
		
	process begin
		clk <= '1'; wait for 5 ns;
		clk <= '0'; wait for 5 ns;
	end process;
	
	process is
		file tv: text;
		variable L: line;
		variable tv_reset: std_logic;
		variable tv_we: std_logic;
		variable tv_a: std_logic_vector (5 downto 0);
		variable tv_wd: std_logic_vector (15 downto 0);
		variable tv_rd: std_logic_vector (15 downto 0);
		variable dummy: character;
		variable errors: integer := 0;
		variable vectornum: integer := 0;
	begin
		file_open (tv, "C:/intelFPGA_lite/22.1std/applications/learn_vhdl/arm3/datamem_tb.txt", read_mode);
		readline (tv, L);
		reset <= '1'; wait for 10 ns; reset <= '0';
		
		while not endfile (tv) loop
			wait until falling_edge (clk);
			readline (tv, L);
			read (L, tv_reset); read (L, dummy); reset <= tv_reset after 1 ns;
			read (L, tv_we); read (L, dummy); we <= tv_we after 1 ns;
			read (L, tv_a); read (L, dummy); a <= tv_a after 1 ns;
			read (L, tv_wd); read (L, dummy); wd <= tv_wd after 1 ns;
			read (L, tv_rd); rdtrue <= tv_rd after 1 ns;
			
			wait until rising_edge (clk);
			wait for 1 ns;
			
			if rd /= rdtrue then
				report "Error: rd = " & integer'image(to_integer(unsigned(rd))) &
							" rdtrue = " & integer'image(to_integer(unsigned(rdtrue)));
				errors := errors + 1;
			end if;
			vectornum := vectornum + 1;
		end loop;
		
		if errors = 0 then
			report "NO ERROR --- " &
						integer'image(vectornum) &
						" tests completed successfully."
						severity failure;
		else
			report integer'image(vectornum) &
					" tests completed, errors = " &
						integer'image(errors)
						severity failure;
		end if;
	end process;
end;