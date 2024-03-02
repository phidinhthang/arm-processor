library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;

entity regfile_tb is
end regfile_tb;

architecture sim of regfile_tb is
	component regfile generic (width: integer := 32);
		port (clk, we3: in std_logic;
				ra1, ra2, wa3: in std_logic_vector (3 downto 0);
				wd3: in std_logic_vector (width-1 downto 0);
				r15: in std_logic_vector (width-1 downto 0);
				rd1, rd2: out std_logic_vector (width-1 downto 0));
	end component;
	signal clk, we3: std_logic;
	signal ra1, ra2, wa3: std_logic_vector (3 downto 0);
	signal wd3: std_logic_vector (3 downto 0);
	signal r15: std_logic_vector (3 downto 0);
	signal rd1, rd2: std_logic_vector (3 downto 0);
	signal rd1true: std_logic_vector(3 downto 0);
	signal rd2true: std_logic_vector(3 downto 0);
begin
	dut: regfile generic map (4)
		port map (clk, we3, ra1, ra2, wa3,
						wd3, r15, rd1, rd2);
						
	process begin
		clk <= '1'; wait for 5 ns;
		clk <= '0'; wait for 5 ns;
	end process;
	
	process is
		file tv: text;
		variable L: line;
		variable tv_we3: std_logic;
		variable tv_ra1: std_logic_vector(3 downto 0);
		variable tv_ra2: std_logic_vector(3 downto 0);
		variable tv_wa3: std_logic_vector(3 downto 0);
		variable tv_wd3: std_logic_vector(3 downto 0);
		variable tv_r15: std_logic_vector(3 downto 0);
		variable dummy: character;
		variable tv_rd1: std_logic_vector(3 downto 0);
		variable tv_rd2: std_logic_vector(3 downto 0);
		variable vectornum: integer := 0;
		variable errors :integer := 0;
	begin
		file_open (tv, "C:/intelFPGA_lite/22.1std/applications/learn_vhdl/arm3/regfile_tb.txt", read_mode);
		readline (tv, L); -- ignore first line
		wait for 10 ns;
		
		while not endfile (tv) loop
			wait until falling_edge (clk);
			
			readline (tv, L);
			read (L, tv_we3); read (L, dummy); we3 <= tv_we3 after 1 ns;
			read (L, tv_ra1); read (L, dummy); ra1 <= tv_ra1 after 1 ns;
			read (L, tv_ra2); read (L, dummy); ra2 <= tv_ra2 after 1 ns;
			read (L, tv_wa3); read (L, dummy); wa3 <= tv_wa3 after 1 ns;
			read (L, tv_wd3); read (L, dummy); wd3 <= tv_wd3 after 1 ns;
			read (L, tv_r15); read (L, dummy); r15 <= tv_r15 after 1 ns;
			read (L, tv_rd1); read (L, dummy); rd1true <= tv_rd1 after 1 ns;
			read (L, tv_rd2); read (L, dummy); rd2true <= tv_rd2 after 1 ns;
			
			wait until rising_edge (clk);
			wait for 1 ns;
			
			if rd1 /= tv_rd1 or rd2 /= tv_rd2 then
				report "Error: rd1 = " & integer'image(to_integer(unsigned(rd1))) &
							" tv_rd1 = " & integer'image(to_integer(unsigned(tv_rd1))) &
							" rd2 = " & integer'image(to_integer(unsigned(rd2))) &
							" tv_rd2 = " & integer'image(to_integer(unsigned(tv_rd2)));
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
						" tests completed, errors = " &
						integer'image(errors)
						severity failure;
		end if;
	end process;
end;