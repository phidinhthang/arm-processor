library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
use std.textio.all;

entity alu_tb is
end alu_tb;

architecture sim of alu_tb is
	component alu generic (width: integer := 32);
		port (a: in std_logic_vector (width-1 downto 0);
				b: in std_logic_vector (width-1 downto 0);
				control: in std_logic_vector(1 downto 0);
				result: out std_logic_vector(width-1 downto 0);
				flags: out std_logic_vector(3 downto 0)); -- zero, neg, carry, overflow
	end component;
	
	signal clk: std_logic;
	signal a, b, result: std_logic_vector (3 downto 0);
	signal control: std_logic_vector(1 downto 0);
	signal flags: std_logic_vector(3 downto 0);
	signal resulttrue: std_logic_vector (3 downto 0);
	signal flagstrue: std_logic_vector (3 downto 0);
begin
	dut: alu generic map (4)
			port map (a, b, control, result, flags);
			
	process begin
		clk <= '1'; wait for 5 ns;
		clk <= '0'; wait for 5 ns;
	end process;
	
	process is
		file tv: text;
		variable L: line;
		variable tv_a: std_logic_vector (3 downto 0);
		variable tv_b: std_logic_vector (3 downto 0);
		variable tv_control: std_logic_vector (1 downto 0);
		variable tv_result: std_logic_Vector (3 downto 0);
		variable tv_flags: std_logic_vector (3 downto 0);
		variable dummy: character;
		variable errors: integer := 0;
		variable vectornum: integer := 0;
	begin
		file_open (tv, "C:/intelFPGA_lite/22.1std/applications/learn_vhdl/arm3/alu_tb.txt", read_mode);
		readline (tv, L);
		wait for 10 ns;
		
		while not endfile (tv) loop
			wait until falling_edge (clk);
			
			readline (tv, L);
			read (L, tv_a); read (L, dummy); a <= tv_a after 1 ns;
			read (L, tv_b); read (L, dummy); b <= tv_b after 1 ns;
			read (L, tv_control); read (L, dummy); control <= tv_control after 1 ns;
			read (L, tv_result); read (L, dummy); resulttrue <= tv_result after 1 ns;
			read (L, tv_flags); read (L, dummy); flagstrue <= tv_flags after 1 ns;
			
			wait until rising_edge (clk);
			wait for 1 ns;
			
			if resulttrue /= result or flagstrue /= flags then
				report "Error: result = " & integer'image(to_integer(unsigned(result))) &
							" resulttrue = " & integer'image(to_integer(unsigned(resulttrue))) &
							" flags = " & integer'image(to_integer(unsigned(flags))) &
							" flagstrue = " & integer'image(to_integer(unsigned(flagstrue)));
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