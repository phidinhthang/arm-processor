library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;


entity alu is generic (width: integer := 32);
	port (a: in std_logic_vector (width-1 downto 0);
			b: in std_logic_vector (width-1 downto 0);
			control: in std_logic_vector(1 downto 0);
			result: out std_logic_vector(width-1 downto 0);
			flags: out std_logic_vector(3 downto 0)); -- zero, neg, carry, overflow
end alu;

architecture synth of alu is
	signal sum: std_logic_vector(width-1 downto 0);
	signal invb: std_logic_vector(width-1 downto 0);
	signal y: std_logic_vector(width downto 0);
	signal zero, neg, carry, overflow: std_logic;
	signal cout: std_logic;
begin
	invb <= not b when control(0) = '1' else b;
	y <= ('0' & a) + ('0' & invb) + control(0);
	cout <= y(width);
	sum <= y(width-1 downto 0);
	
	process (all) begin
		case control is
			when "10" => result <= a and b;
			when "11" => result <= a or b;
			when others => result <= sum;
		end case;
	end process;
	
	neg <= result(width-1);
	zero <= '1' when unsigned(result) = 0 else '0';
	carry <= (not control(1)) and cout;
	overflow <= (not control(1)) and 
					(not (a(width-1) xor b(width-1) xor control(0))) and
					(a(width-1) xor result(width-1));
	flags <= zero & neg & carry & overflow;
end;