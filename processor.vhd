--señales de 1 bit no aceptan (OTHERS => '0')

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
		D_DataIn : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
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
	SIGNAL IF_pc : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL IF_pc_4 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');

	--ETAPA ID--
	SIGNAL aux_control : STD_LOGIC_VECTOR(9 DOWNTO 0) := (OTHERS => '0');
	SIGNAL cuenta : STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
	SIGNAL ID_reg1_dr : STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
	SIGNAL ID_reg2_dr : STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
	-- SIGNAL reset : STD_LOGIC := '0';
	SIGNAL RegWrite : STD_LOGIC := '0';
	SIGNAL ID_Instruction : STD_LOGIC_VECTOR(31 DOWNTO 0); --:= (OTHERS => '0');
	SIGNAL ID_data1_rd : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL ID_data2_rd : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL ID_immediate : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL ID_control_WB : STD_LOGIC := '0';
	SIGNAL ID_pc_4 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	-- Control etapa EX
	SIGNAL ID_control_alu_op : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
	SIGNAL ID_control_alu_src : STD_LOGIC := '0';
	SIGNAL ID_control_reg_dst : STD_LOGIC := '0';
	-- Control etapa MEM
	SIGNAL ID_control_branch : STD_LOGIC := '0';
	SIGNAL ID_control_mem_read : STD_LOGIC := '0';
	SIGNAL ID_control_mem_write : STD_LOGIC := '0';
	-- Control etapa WB
	SIGNAL ID_control_reg_write : STD_LOGIC := '0';
	SIGNAL ID_control_mem_to_reg : STD_LOGIC := '0';

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
	SIGNAL EX_regdst_mux_out : STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
	SIGNAL EX_pc_4 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL EX_sum_out : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	-- Control etapa EX
	SIGNAL EX_control_alu_op : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
	SIGNAL EX_control_reg_dst : STD_LOGIC := '0';
	SIGNAL EX_control_alu_src : STD_LOGIC := '0';
	-- Control etapa MEM
	SIGNAL EX_control_branch : STD_LOGIC := '0';
	SIGNAL EX_control_mem_read : STD_LOGIC := '0';
	SIGNAL EX_control_mem_write : STD_LOGIC := '0';
	-- Control etapa WB
	SIGNAL EX_control_reg_write : STD_LOGIC := '0';
	SIGNAL EX_control_mem_to_reg : STD_LOGIC := '0';

	--ETAPA MEM--
	SIGNAL MEM_pc_src : STD_LOGIC := '0';
	SIGNAL MEM_sum_out : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL MEM_control_branch : STD_LOGIC := '0';
	SIGNAL MEM_regdst_mux_out : STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
	SIGNAL MEM_alu_zero : STD_LOGIC := '0';
	-- SIGNAL MEM_control_mem_read : STD_LOGIC := '0';
	-- SIGNAL MEM_control_mem_write : STD_LOGIC := '0';
	-- Control etapa WB
	SIGNAL MEM_control_reg_write : STD_LOGIC := '0';
	SIGNAL MEM_control_mem_to_reg : STD_LOGIC := '0';

	--ETAPA WB-- 
	SIGNAL WB_control_mem_to_reg : STD_LOGIC := '0';
	SIGNAL WB_D_DataIn : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL WB_reg_wr : STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
	SIGNAL WB_data_wr : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL WB_D_Addr : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	---------------------------------------------------------------------------------------------------------------
BEGIN
	---------------------------------------------------------------------------------------------------------------
	-- ETAPA IF
	---------------------------------------------------------------------------------------------------------------
	-- Contador de programa
	PROCESS (Clk, reset)
	BEGIN
		IF reset = '1' THEN
			IF_pc <= (OTHERS => '0');
		ELSIF rising_edge(Clk) THEN
			IF_pc <= IF_pc + 4;
		END IF;
	END PROCESS;

	IF_pc_4 <= IF_pc + 4;
	I_RdStb <= '1';
	I_WrStb <= '0';
	I_DataOut <= (OTHERS => '0');

	-- Mux IF
	PROCESS (MEM_pc_src, IF_pc, MEM_sum_out)
	BEGIN
		IF (MEM_pc_src = '0') THEN
			I_Addr <= IF_pc;
		ELSE
			I_Addr <= MEM_sum_out;
		END IF;
	END PROCESS;
	---------------------------------------------------------------------------------------------------------------
	-- REGISTRO DE SEGMENTACION IF/ID
	--------------------------------------------------------------------------------------------------------------- 
	IF_ID : PROCESS (Clk)
	BEGIN
		IF reset = '1' THEN
			ID_pc_4 <= (OTHERS => '0');
		ELSIF rising_edge(Clk) THEN
			ID_pc_4 <= IF_pc_4;
			ID_Instruction <= I_DataIn;
		END IF;
	END PROCESS;
	---------------------------------------------------------------------------------------------------------------
	-- ETAPA ID
	---------------------------------------------------------------------------------------------------------------
	-- Instanciacion del banco de registros
	Registers_inst : registers
	PORT MAP(
		clk => Clk,
		reset => reset,
		wr => RegWrite, --control
		reg1_dr => ID_reg1_dr, --rt
		reg2_dr => ID_reg2_dr, --rs
		reg_wr => WB_reg_wr, --Escribir registro
		data_wr => WB_data_wr, --Escribir dato
		data1_rd => ID_data1_rd, --Dato leído 1
		data2_rd => ID_data2_rd); --Dato leído 2

	ID_reg1_dr <= ID_Instruction(25 DOWNTO 21);
	ID_reg2_dr <= ID_Instruction(20 DOWNTO 16);

	-- Extensión de signo
	PROCESS (ID_Instruction)
	BEGIN
		IF (ID_Instruction(15) = '1') THEN
			ID_immediate <= "1111111111111111" & ID_Instruction(15 DOWNTO 0);
		ELSE
			ID_immediate <= "0000000000000000" & ID_Instruction(15 DOWNTO 0);
		END IF;
	END PROCESS;

	-- CONTROL UNIT
	PROCESS (ID_Instruction)
	BEGIN
		IF (ID_Instruction(31 DOWNTO 26) = "000000") THEN -- Tipo R
			aux_control <= "1010000011";
		ELSIF (ID_Instruction(31 DOWNTO 26) = "100011") THEN -- LW
			aux_control <= "0000101010";
		ELSIF (ID_Instruction(31 DOWNTO 26) = "101011") THEN -- SW
			aux_control <= "0000100101";
		ELSIF (ID_Instruction(31 DOWNTO 26) = "000100") THEN -- BEQ
			aux_control <= "0001010001";
		ELSIF (ID_Instruction(31 DOWNTO 26) = "001111") THEN -- LUI
			-- Señales de control de LUI
			aux_control <= "0100100011";
		ELSIF (ID_Instruction(31 DOWNTO 26) = "001000") THEN -- ADDI
			-- Señales de control de ADDI
			aux_control <= "0101100011";
		ELSIF (ID_Instruction(31 DOWNTO 26) = "001100") THEN -- ANDI
			-- Señales de control de ANDI
			aux_control <= "0110100011";
		ELSIF (ID_Instruction(31 DOWNTO 26) = "001101") THEN -- ORI
			-- Señales de control de ORI
			aux_control <= "0111100011";
		ELSE
			aux_control <= "0000000000";
		END IF;
	END PROCESS;

	PROCESS (aux_control)
	BEGIN
		-- Control etapa EX
		ID_control_reg_dst <= aux_control(9);
		ID_control_alu_op <= aux_control(8 DOWNTO 6);
		ID_control_alu_src <= aux_control(5);
		-- Control etapa MEM
		ID_control_branch <= aux_control(4);
		ID_control_mem_read <= aux_control(3);
		ID_control_mem_write <= aux_control(2);
		-- Control etapa WB
		ID_control_reg_write <= aux_control(1);
		ID_control_mem_to_reg <= aux_control(0);

	END PROCESS;
	---------------------------------------------------------------------------------------------------------------
	-- REGISTRO DE SEGMENTACION ID/EX
	---------------------------------------------------------------------------------------------------------------
	ID_EX : PROCESS (Clk, reset)
	BEGIN
		IF reset = '1' THEN
			EX_pc_4 <= (OTHERS => '0');
			EX_data1_rd <= (OTHERS => '0');
			EX_data2_rd <= (OTHERS => '0');
			EX_immediate <= (OTHERS => '0');
			EX_Instruction <= (OTHERS => '0');
			EX_control_WB <= '0';
			-- Control etapa EX
			EX_control_alu_src <= '0';
			EX_control_alu_op <= (OTHERS => '0');
			EX_control_reg_dst <= '0';
			-- Control etapa MEM
			EX_control_branch <= '0';
			EX_control_mem_read <= '0';
			EX_control_mem_write <= '0';
			-- Control etapa WB
			EX_control_reg_write <= '0';
			EX_control_mem_to_reg <= '0';
		ELSIF rising_edge(Clk) THEN
			EX_pc_4 <= ID_pc_4;
			EX_data1_rd <= ID_data1_rd;
			EX_data2_rd <= ID_data2_rd;
			EX_immediate <= ID_immediate;
			EX_Instruction <= ID_Instruction;
			EX_control_WB <= ID_control_WB;
			-- Control etapa EX
			EX_control_alu_src <= ID_control_alu_src;
			EX_control_alu_op <= ID_control_alu_op;
			EX_control_reg_dst <= ID_control_reg_dst;
			-- Control etapa MEM
			EX_control_branch <= ID_control_branch;
			EX_control_mem_read <= ID_control_mem_read;
			EX_control_mem_write <= ID_control_mem_write;
			-- Control etapa WB
			EX_control_reg_write <= ID_control_reg_write;
			EX_control_mem_to_reg <= ID_control_mem_to_reg;
		END IF;

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
		zero => EX_alu_zero
	);

	-- MUX ALU
	PROCESS (EX_control_alu_src, EX_data2_rd, EX_immediate)
	BEGIN
		IF (EX_control_alu_src = '0') THEN
			EX_alu_mux_out <= EX_data2_rd;
		ELSE
			EX_alu_mux_out <= EX_immediate;
		END IF;
	END PROCESS;

	-- MUX RegDst (para determinar el registro destino según el tipo de instrucción)
	PROCESS (EX_control_reg_dst, EX_Instruction)
	BEGIN
		IF (EX_control_reg_dst = '0') THEN
			-- tipo r
			EX_regdst_mux_out <= EX_Instruction(20 DOWNTO 16);
		ELSIF (EX_control_reg_dst = '1') THEN
			EX_regdst_mux_out <= EX_Instruction(15 DOWNTO 11);
		ELSE
			EX_regdst_mux_out <= "00000";
		END IF;
	END PROCESS;

	-- ALU CONTROL UNIT
	PROCESS (EX_control_alu_op, EX_Instruction)
	BEGIN
		IF (EX_control_alu_op = "010") THEN
			IF (EX_Instruction(5 DOWNTO 0) = "100000") THEN
				EX_alu_ctrl_out <= "010"; --ADD
			ELSIF (EX_Instruction(5 DOWNTO 0) = "100010") THEN
				EX_alu_ctrl_out <= "110"; --SUB
			ELSIF (EX_Instruction(5 DOWNTO 0) = "100100") THEN
				EX_alu_ctrl_out <= "000"; --AND
			ELSIF (EX_Instruction(5 DOWNTO 0) = "100101") THEN
				EX_alu_ctrl_out <= "001"; --OR
			ELSIF (EX_Instruction(5 DOWNTO 0) = "101010") THEN
				EX_alu_ctrl_out <= "111"; --SLT
			ELSE
				EX_alu_ctrl_out <= "000";
			END IF;
		ELSIF (EX_control_alu_op = "000") THEN
			--lw o sw
			EX_alu_ctrl_out <= "010";
		ELSIF (EX_control_alu_op = "001") THEN
			-- branch equal
			EX_alu_ctrl_out <= "110";
		ELSIF (EX_control_alu_op = "100") THEN
			-- LUI
			EX_alu_ctrl_out <= "100";
		ELSIF (EX_control_alu_op = "101") THEN
			-- ADDI
			EX_alu_ctrl_out <= "010";
		ELSIF (EX_control_alu_op = "110") THEN
			-- ANDI
			EX_alu_ctrl_out <= "000";
		ELSIF (EX_control_alu_op = "111") THEN
			-- ORI
			EX_alu_ctrl_out <= "001";
		ELSE
			EX_alu_ctrl_out <= "000";
		END IF;
	END PROCESS;

	PROCESS (EX_pc_4, EX_immediate)
	BEGIN
		EX_sum_out <= EX_pc_4 + (EX_immediate SLL 2);
	END PROCESS;

	---------------------------------------------------------------------------------------------------------------
	-- REGISTRO DE SEGMENTACION EX/MEM
	---------------------------------------------------------------------------------------------------------------
	EX_MEM : PROCESS (Clk, reset)
	BEGIN
		IF reset = '1' THEN
			MEM_sum_out <= (OTHERS => '0');
			D_Addr <= (OTHERS => '0');
			D_DataOut <= (OTHERS => '0');
			MEM_alu_zero <= '0';
			-- Control etapa MEM
			MEM_control_branch <= '0';
			D_RdStb <= '0';
			D_WrStb <= '0';
			-- Control etapa WB
			MEM_control_reg_write <= '0';
			MEM_control_mem_to_reg <= '0';

			MEM_regdst_mux_out <= (OTHERS => '0');
		ELSIF rising_edge(Clk) THEN
			MEM_sum_out <= EX_sum_out;
			D_Addr <= EX_alu_result;
			D_DataOut <= EX_data2_rd;
			-- Control etapa MEM
			MEM_control_branch <= EX_control_branch;
			D_RdStb <= EX_control_mem_read;
			D_WrStb <= EX_control_mem_write;
			MEM_alu_zero <= EX_alu_zero;
			-- Control etapa WB
			MEM_control_reg_write <= EX_control_reg_write;
			MEM_control_mem_to_reg <= EX_control_mem_to_reg;

			MEM_regdst_mux_out <= EX_regdst_mux_out;
		END IF;

	END PROCESS;

	---------------------------------------------------------------------------------------------------------------
	-- ETAPA MEM
	---------------------------------------------------------------------------------------------------------------
	MEM_pc_src <= MEM_alu_zero AND MEM_control_branch; -- AND BRANCH

	---------------------------------------------------------------------------------------------------------------
	-- REGISTRO DE SEGMENTACION MEM/WB
	---------------------------------------------------------------------------------------------------------------
	MEM_WB : PROCESS (Clk, reset)
	BEGIN
		IF reset = '1' THEN
			WB_control_mem_to_reg <= '0';
			RegWrite <= '0'; --Control
			WB_D_DataIn <= (OTHERS => '0');
			WB_D_Addr <= (OTHERS => '0');
			WB_reg_wr <= (OTHERS => '0'); --Escribir registro
		ELSIF rising_edge(Clk) THEN
			WB_control_mem_to_reg <= MEM_control_mem_to_reg;
			RegWrite <= MEM_control_reg_write; --Control
			WB_D_DataIn <= D_DataIn;
			WB_D_Addr <= D_Addr;
			WB_reg_wr <= MEM_regdst_mux_out; --Escribir registro
		END IF;
	END PROCESS;

	---------------------------------------------------------------------------------------------------------------
	-- ETAPA WB
	---------------------------------------------------------------------------------------------------------------
	-- MUX WB
	PROCESS (WB_control_mem_to_reg, WB_D_DataIn, WB_D_Addr)
	BEGIN
		IF (WB_control_mem_to_reg = '0') THEN
			WB_data_wr <= WB_D_DataIn;
		ELSIF (WB_control_mem_to_reg = '1') THEN
			WB_data_wr <= WB_D_Addr;
		ELSE
			WB_data_wr <= (OTHERS => '0');
		END IF;
	END PROCESS;

END processor_arq;