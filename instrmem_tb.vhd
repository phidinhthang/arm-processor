library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
use std.textio.all;

library work;
use work.util.all;

entity instrmem_tb is
end instrmem_tb;

architecture sim of instrmem_tb is
	component instrmem generic (addrlen: integer := 32;
										wordlen: integer := 32;
										numword: integer := 1);
			port (data: in imemtype (0 to numword-1) (wordlen-1 downto 0);
					addr: in std_logic_vector (addrlen-1 downto 0);
					instr: out std_logic_vector (wordlen-1 downto 0));
	end component;
	signal clk: std_logic;
	signal addr: std_logic_vector (2 downto 0);
	signal instr: std_logic_vector (15 downto 0);
	signal instrtrue: std_logic_vector (15 downto 0);
	signal imemdata: imemtype (0 to 7) (15 downto 0) := (
		x"8000", x"8014", x"C350", x"C3B4",
		x"C3BF", x"d903", x"8235", x"8000");
begin
	dut: instrmem generic map (3, 16, 8)
		port map (imemdata, addr, instr);
		
	process begin
		clk <= '1'; wait for 5 ns;
		clk <= '0'; wait for 5 ns;
	end process;
	
	process is
		file tv: text;
		variable L: line;
		variable tv_addr: std_logic_vector (5 downto 0);
		variable tv_instr: std_logic_vector (15 downto 0);
		variable dummy: character;
		variable vectornum: integer := 0;
		variable errors: integer := 0;
	begin
		file_open (tv, "C:/intelFPGA_lite/22.1std/applications/learn_vhdl/arm3/instrmem_tv.txt", read_mode);
		readline (tv, L);
		wait for 10 ns;
		
		while not endfile (tv) loop
			wait until falling_edge (clk);
			
			readline (tv, L);
			read (L, tv_addr); read (L, dummy); addr <= tv_addr(4 downto 2) after 1 ns;
			read (L, tv_instr); instrtrue <= tv_instr after 1 ns;
			
			wait until rising_edge (clk);
			wait for 1 ns;
			
			if instr /= instrtrue then
				report "Error: instr = " & integer'image(to_integer(unsigned(instr))) &
							" instrtrue = " & integer'image(to_integer(unsigned(instrtrue)));
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