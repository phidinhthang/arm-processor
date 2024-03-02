library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;
use ieee.numeric_std.all;

entity mux4_tb is
end mux4_tb;

architecture sim of mux4_tb is
	component mux4 generic (width: integer := 32);
		port (d0, d1, d2, d3: in std_logic_vector(width-1 downto 0);
				s: in std_logic_vector(1 downto 0);
				y: out std_logic_vector(width-1 downto 0));
	end component;
	signal clk: std_logic;
	signal d0, d1, d2, d3: std_logic_vector(3 downto 0);
	signal s: std_logic_vector(1 downto 0);
	signal y: std_logic_vector(3 downto 0);
	signal ytrue: std_logic_vector(3 downto 0);
begin
	dut: mux4 generic map (4)
			port map (d0, d1, d2, d3, s, y);

	process begin
		clk <= '1'; wait for 5 ns;
		clk <= '0'; wait for 5 ns;
	end process;
	
	process is
		file tv: text;
		variable L: line;
		variable tv_d0: std_logic_vector(3 downto 0);
		variable tv_d1: std_logic_vector(3 downto 0);
		variable tv_d2: std_logic_vector(3 downto 0);
		variable tv_d3: std_logic_vector(3 downto 0);
		variable tv_s: std_logic_vector(1 downto 0);
		variable tv_y: std_logic_vector(3 downto 0);
		variable dummy: character;
		variable errors: integer := 0;
		variable vectornum: integer := 0;
	begin
		file_open (tv, "C:/intelFPGA_lite/22.1std/applications/learn_vhdl/arm3/mux4_tb.txt", read_mode);
		readline (tv, L);
		wait for 10 ns;
		
		while not endfile (tv) loop
			wait until falling_edge (clk);
			
			readline (tv, L);
			read (L, tv_d0); read (L, dummy); d0 <= tv_d0 after 1 ns;
			read (L, tv_d1); read (L, dummy); d1 <= tv_d1 after 1 ns;
			read (L, tv_d2); read (L, dummy); d2 <= tv_d2 after 1 ns;
			read (L, tv_d3); read (L, dummy); d3 <= tv_d3 after 1 ns;
			read (L, tv_s); read (L, dummy); s <= tv_s after 1 ns;
			read (L, tv_y); ytrue <= tv_y after 1 ns;
			
			wait until rising_edge (clk);
			wait for 1 ns;
			
			if y /= ytrue then
				report "Error: y = " & integer'image(to_integer(unsigned(y))) &
							" ytrue = " & integer'image(to_integer(unsigned(ytrue)));
				errors := errors + 1;
			end if;
			
			vectornum := vectornum + 1;
		end loop;
		
		if errors = 0 then
			report "NO ERRORS -- " &
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