LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY processor IS
	PORT (
		Clk : IN STD_LOGIC;
		Reset : IN STD_LOGIC;
		-- Instruction memory
		I_Addr : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		I_RdStb : OUT STD_LOGIC;
		I_WrStb : OUT STD_LOGIC;
		I_DataOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		I_DataIn : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		-- Data memory
		D_Addr : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		D_RdStb : OUT STD_LOGIC;
		D_WrStb : OUT STD_LOGIC;
		D_DataOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		D_DataIn : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END processor;

ARCHITECTURE processor_arq OF processor IS

	--DECLARACION DE COMPONENTES--

	COMPONENT registers
		PORT (
			clk : IN STD_LOGIC;
			reset : IN STD_LOGIC;
			wr : IN STD_LOGIC;
			reg1_dr : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			reg2_dr : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			reg_wr : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			data_wr : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			data1_rd : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			data2_rd : OUT STD_LOGIC_VECTOR (31 DOWNTO 0));

	END COMPONENT;

	COMPONENT alu
		PORT (
			a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			control : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			zero : OUT STD_LOGIC;
		);
	END COMPONENT;

	--DECLARACION DE SEÑALES--
	--ETAPA IF--
	--ETAPA ID--
	SIGNAL cuenta : STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
	SIGNAL reset : STD_LOGIC := '0';
	SIGNAL RegWrite : STD_LOGIC := '0';
	SIGNAL ID_Instruction : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL WB_reg_wr : STD_LOGIC := '0';
	SIGNAL WB_data_wr : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL ID_data1_rd : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL ID_data2_rd : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL ID_immediate : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL ID_control_WB : STD_LOGIC := '0';
	SIGNAL ID_control_M : STD_LOGIC := '0';
	SIGNAL ID_control_EX : STD_LOGIC := '0';

	--ETAPA EX--
	SIGNAL EX_data1_rd : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL EX_data2_rd : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL EX_immediate : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL EX_alu_mux_out : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL EX_alu_ctrl_out : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
	SIGNAL EX_alu_result : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL EX_alu_zero : STD_LOGIC := '0';
	SIGNAL EX_Instruction : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL EX_control_WB : STD_LOGIC := '0';
	SIGNAL EX_control_M : STD_LOGIC := '0';
	SIGNAL EX_control_EX : STD_LOGIC := '0';
	SIGNAL EX_alu_op : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
	SIGNAL EX_reg_dst : STD_LOGIC := '0';
	SIGNAL EX_regdst_mux_out : STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
	--ETAPA MEM--
	SIGNAL MEM_control_WB : STD_LOGIC := '0';
	SIGNAL MEM_control_M : STD_LOGIC := '0';

	--ETAPA WB-- 
	SIGNAL WB_control_WB : STD_LOGIC := '0';
	---------------------------------------------------------------------------------------------------------------
BEGIN
	---------------------------------------------------------------------------------------------------------------
	-- ETAPA IF
	---------------------------------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------------
	-- REGISTRO DE SEGMENTACION IF/ID
	--------------------------------------------------------------------------------------------------------------- 

	---------------------------------------------------------------------------------------------------------------
	-- ETAPA ID
	---------------------------------------------------------------------------------------------------------------
	-- Instanciacion del banco de registros
	Registers_inst : registers
	PORT MAP(
		clk => clk,
		reset => reset,
		wr => RegWrite, --control
		reg1_dr => ID_Instruction(25 DOWNTO 21), --rt
		reg2_dr => ID_Instruction(20 DOWNTO 16), --rs
		reg_wr => WB_reg_wr, --Escribir registro
		data_wr => WB_data_wr, --Escribir dato
		data1_rd => ID_data1_rd, --Dato leído 1
		data2_rd => ID_data2_rd); --Dato leído 2

	-- Extensión de signo
	PROCESS (ID_Instruction) :
	BEGIN
		IF (ID_Instruction(15) = 1) THEN
			ID_immediate <= '1111111111111111' & ID_Instruction(15 DOWNTO 0);
		ELSE
			ID_immediate <= '0000000000000000' & ID_Instruction(15 DOWNTO 0);
		END IF;
	END PROCESS;

	-- CONTROL UNIT
	PROCESS (ID_Instruction) :
	BEGIN
		--completar la próxima!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	END PROCESS;

	---------------------------------------------------------------------------------------------------------------
	-- REGISTRO DE SEGMENTACION ID/EX
	---------------------------------------------------------------------------------------------------------------
	ID_EX : PROCESS (clk)
	BEGIN

		EX_data1_rd <= ID_data1_rd;
		EX_data2_rd <= ID_data2_rd;
		EX_immediate <= ID_immediate;
		EX_Instruction <= ID_Instruction;
		EX_control_WB <= ID_control_WB;
		EX_control_M <= ID_control_M;
		EX_control_EX <= ID_control_EX;

	END PROCESS;

	---------------------------------------------------------------------------------------------------------------
	-- ETAPA EX
	---------------------------------------------------------------------------------------------------------------
	-- Instanciacion de la ALU
	Alu_inst : alu
	PORT MAP(
		a => EX_data1_rd,
		b => EX_alu_mux_out,
		control => EX_alu_ctrl_out,
		result => EX_alu_result,
		zero => EX_alu_zero,
	);

	-- MUX ALU
	PROCESS (ALU_src, EX_data2_rd, EX_immediate) :
	BEGIN

		IF (ALU_src = '0') THEN
			EX_alu_mux_out <= EX_data2_rd;
		ELSE
			EX_alu_mux_out <= EX_immediate;
		END IF;

	END PROCESS;

	-- MUX RegDst (para determinar el registro destino según el tipo de instrucción)
	PROCESS (EX_reg_dst) :
	BEGIN

		IF (EX_reg_dst = '0') THEN
			-- tipo r
			EX_regdst_mux_out <= EX_Instruction(20 DOWNTO 16);
		ELSIF (EX_reg_dst = '1') THEN
			EX_regdst_mux_out <= EX_Instruction(15 DOWNTO 11);
		ELSE
			EX_regdst_mux_out <= "00000";
		END IF;

	END PROCESS;

	-- ALU CONTROL UNIT
	PROCESS (EX_alu_op, EX_Instruction) :
	BEGIN
		IF (EX_alu_op = "10") THEN
			--provisorio, solo para tipo r
			IF (EX_Instruction(5 DOWNTO 0) = "100000") THEN
				EX_alu_ctrl_out <= "010";
			ELSIF (EX_Instruction(5 DOWNTO 0) = "100010") THEN
				EX_alu_ctrl_out <= "110";
			ELSIF (EX_Instruction(5 DOWNTO 0) = "100100") THEN
				EX_alu_ctrl_out <= "000";
			ELSIF (EX_Instruction(5 DOWNTO 0) = "100101") THEN
				EX_alu_ctrl_out <= "001";
			ELSIF (EX_Instruction(5 DOWNTO 0) = "101010") THEN
				EX_alu_ctrl_out <= "111";
			ELSE
				EX_alu_ctrl_out <= "000";
			END IF;
		ELSIF (EX_alu_op = "00") THEN
			--lw o sw
			EX_alu_ctrl_out <= "010";
		ELSIF (EX_alu_op = "01") THEN
			-- branch equal
			EX_alu_ctrl_out <= "110";
		ELSE
			EX_alu_ctrl_out <= "000"
			END IF;
		END PROCESS;

		---------------------------------------------------------------------------------------------------------------
		-- REGISTRO DE SEGMENTACION EX/MEM
		---------------------------------------------------------------------------------------------------------------
		EX_MEM : PROCESS (clk)
		BEGIN

			MEM_control_M <= EX_control_M;
			MEM_control_WB <= EX_control_WB;

		END PROCESS;

		---------------------------------------------------------------------------------------------------------------
		-- ETAPA MEM
		---------------------------------------------------------------------------------------------------------------

		---------------------------------------------------------------------------------------------------------------
		-- REGISTRO DE SEGMENTACION MEM/WB
		---------------------------------------------------------------------------------------------------------------
		MEM_WB : PROCESS (clk)
		BEGIN

			WB_control_WB <= MEM_control_WB;
		END PROCESS;

		---------------------------------------------------------------------------------------------------------------
		-- ETAPA WB
		---------------------------------------------------------------------------------------------------------------
	END processor_arq;