library ieee;
use ieee.std_logic_1164.all;

entity decoder is
	port (Op: in std_logic_vector (1 downto 0);
			Funct: in std_logic_vector (5 downto 0);
			Rd: in std_logic_vector (3 downto 0);
			ALUControl: out std_logic_vector (1 downto 0);
			RegWrite: out std_logic;
			MemW: out std_logic;
			RegSrc: out std_logic;
			ImmSrc: out std_logic_vector (1 downto 0));
end decoder;

architecture behave of decoder is
begin
	RegWrite <= (not Op(1)) and ((not Op(0)) or Funct(0));
	MemW <= (not Op(1)) and Op(0) and (not Funct(0));
	ImmSrc <= Op;
	RegSrc <= (not Op(1)) and Op(0) and Funct(0);
	
	ALUControl(1) <= (not Funct(2)) and ((not (Funct(4) or Funct(3))) or (Funct(4) and Funct(3)))
							when Op = b"00" else b'0';
	ALUControl(0) <= ((not (Funct(4) or Funct(3))) and Funct(2)) or (Funct(4) and Funct(3) and (not Funct(2)))
							when Op = b"00" else b'0';
end;