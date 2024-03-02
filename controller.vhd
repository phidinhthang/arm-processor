library ieee;
use ieee.std_logic_1164.all;

entity controller is
	port (clk, reset: in std_logic;
			Instr: in std_logic_vector (31 downto 12);
			ALUFlags: in std_logic_vector (3 downto 0);
			RegWrite: out std_logic;
			ALUControl: out std_logic_vector (1 downto 0);
			MemWrite: out std_logic;
			RegSrc: out std_logic;
			ImmSrc: out std_logic_vector (1 downto 0));
end controller;

architecture struct of controller is
	component decoder 
		port (Op: in std_logic_vector (1 downto 0);
				Funct: in std_logic_vector (5 downto 0);
				Rd: in std_logic_vector (3 downto 0);
				ALUControl: out std_logic_vector (1 downto 0);
				RegWrite: out std_logic;
				MemW: out std_logic;
				RegSrc: out std_logic;
				ImmSrc: out std_logic_vector (1 downto 0));
	end component;
	
	signal MemW: out std_logic;
begin
	i_decoder: decoder port map (Instr(27 downto 26),
											Instr(25 downto 20),
											Instr(15 downto 12),
											RegWrite, ALUControl, MemW, RegSrc, ImmSrc);
											
	MemWrite <= MemW;
end;