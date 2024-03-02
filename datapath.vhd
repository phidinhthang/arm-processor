library ieee;
use ieee.std_logic_1164.all;

entity datapath is
	port (clk, reset: in std_logic;
			Instr: in std_logic_vector(31 downto 0);
			PC: out std_logic_vector(31 downto 0);
			ALUResult: out std_logic_vector(31 downto 0);
			WriteData: out std_logic_vector(31 downto 0);
			ReadData: in std_logic_vector(31 downto 0);
			RegWrite: in std_logic;
			ALUControl: in std_logic_vector(1 downto 0);
			RegSrc: in std_logic_vector(1 downto 0);
			ImmSrc: in std_logic_vector(1 downto 0);
			ALUFLags: out std_logic_vector(3 downto 0));
end datapath;

architecture behave of datapath is
	component regfile generic (width: integer := 32);
		port (clk, we3: in std_logic;
				ra1, ra2, wa3: in std_logic_vector (3 downto 0);
				wd3: in std_logic_vector (width-1 downto 0);
				r15: in std_logic_vector (width-1 downto 0);
				rd1, rd2: out std_logic_vector (width-1 downto 0));
	end component;
	component alu generic (width: integer := 32);
		port (a: in std_logic_vector (width-1 downto 0);
				b: in std_logic_vector (width-1 downto 0);
				control: in std_logic_vector (1 downto 0);
				result: out std_logic_vector (width-1 downto 0);
				flags: out std_logic_vector (3 downto 0));
	end component;
	component adder generic (width: integer := 32);
		port (a, b: in std_logic_vector (width-1 downto 0);
				cin: in std_logic;
				y: out std_logic_vector (width-1 downto 0);
				cout: out std_logic);
	end component;
	component flopenr generic (width: integer := 4);
		port (clk, reset, en: in std_logic;
				d: in std_logic_vector(width-1 downto 0);
				q: out std_logic_vector(width-1 downto 0));
	end component;
	component mux2 generic (width: integer := 32);
		port (d0, d1: in std_logic_vector(width-1 downto 0);
				s: in std_logic;
				y: out std_logic_vector(width-1 downto 0));
	end component;
	component extend is
		port (ImmSrc: in std_logic_vector (1 downto 0);
				Imm: in std_logic_vector (23 downto 0);
				ExtImm: out std_logic_vector (31 downto 0));	
	end component;
	
	signal PCNext: std_logic_vector (31 downto 0);
	signal ra1, ra2, wa3: std_logic_vector (31 downto 0);
	signal wd3, r15: std_logic_vector (31 downto 0);
	signal rd1, rd2: std_logic_vector (31 downto 0);
	signal SrcA, SrcB: std_logic_vector (31 downto 0);
	signal ExtImm: std_logic_vector (31 downto 0);
	signal Imm: std_logic_vector (23 downto 0);
	signal Result: std_logic_vector (31 downto 0);
begin
	i_regfile: regfile generic map (32)
		port map (clk, RegWrite, ra1, ra2, wa3,
						wd3, r15, rd1, rd2);
	i_alu: alu generic map (32)
		port map (SrcA, SrcB, ALUControl,
						ALUResult, ALUFlags);
	pcplus4: adder generic map (32)
		port map (PC, 32d"4", b'0', PCNext);
	pcplus4plus4: adder generic map (32)
		port map (PCNext, 32d"4", b'0', r15);
	pcreg: flopenr generic map (32)
		port map (clk, reset, b'1', PCNext, PC);
	i_extend: extend port map (ImmSrc, Imm, ExtImm);
	regmux: mux2 generic map (32)
		port map (ALUResult, ReadData, RegSrc, Result);
		
	-- LDR
	Imm <= Instr(23 downto 0);
	ra1 <= Instr(19 downto 16);
	wa3 <= Instr(15 downto 12);
	wd3 <= Result;
	SrcA <= rd1;
	SrcB <= ExtImm;
	-- STR
	ra2 <= Instr(15 downto 12);
	WriteData <= rd2;
end;