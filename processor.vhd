library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity processor is
port(
	Clk         : in  std_logic;
	Reset       : in  std_logic;
	-- Instruction memory
	I_Addr      : out std_logic_vector(31 downto 0);
	I_RdStb     : out std_logic;
	I_WrStb     : out std_logic;
	I_DataOut   : out std_logic_vector(31 downto 0);
	I_DataIn    : in  std_logic_vector(31 downto 0);
	-- Data memory
	D_Addr      : out std_logic_vector(31 downto 0);
	D_RdStb     : out std_logic;
	D_WrStb     : out std_logic;
	D_DataOut   : out std_logic_vector(31 downto 0);
	D_DataIn    : in  std_logic_vector(31 downto 0)
);
end processor;

architecture processor_arq of processor is 

--DECLARACION DE COMPONENTES--

component registers 
    port  (clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           wr : in STD_LOGIC;
           reg1_dr : in STD_LOGIC_VECTOR (4 downto 0);
           reg2_dr : in STD_LOGIC_VECTOR (4 downto 0);
           reg_wr : in STD_LOGIC_VECTOR (4 downto 0);
           data_wr : in STD_LOGIC_VECTOR (31 downto 0);
           data1_rd : out STD_LOGIC_VECTOR (31 downto 0);
           data2_rd : out STD_LOGIC_VECTOR (31 downto 0));
           
end component;

--DECLARACION DE SE�ALES--
    --ETAPA IF--


    --ETAPA ID--
	signal cuenta: STD_LOGIC_VECTOR(6 downto 0) := (others => '0');
	signal reset: STD_LOGIC := '0';
	signal RegWrite: STD_LOGIC := '0'; 
	signal ID_Instruction: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
	signal WB_reg_wr: STD_LOGIC := '0';
	signal WB_data_wr:  STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
	signal ID_data1_rd:  STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
	signal ID_data2_rd:  STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

    --ETAPA EX--

    --ETAPA MEM--
     
    --ETAPA WB--    
        
begin 	
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
Registers_inst:  registers 
	Port map (
			clk => clk, 
			reset => reset, 
			wr => RegWrite, --control
			reg1_dr => ID_Instruction(25 downto 21), --rt
			reg2_dr => ID_Instruction( 20 downto 16), --rs
			reg_wr => WB_reg_wr, --Escribir registro
			data_wr => WB_data_wr , --Escribir dato
			data1_rd => ID_data1_rd ,--Dato leído 1
			data2_rd => ID_data2_rd ); --Dato leído 2

 
 

---------------------------------------------------------------------------------------------------------------
-- REGISTRO DE SEGMENTACION ID/EX
---------------------------------------------------------------------------------------------------------------
ID_EX: process(clk)
begin

	end process;
 
---------------------------------------------------------------------------------------------------------------
-- ETAPA EX
---------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------
-- REGISTRO DE SEGMENTACION EX/MEM
---------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------
-- ETAPA MEM
---------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------
-- REGISTRO DE SEGMENTACION MEM/WB
---------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------
-- ETAPA WB
---------------------------------------------------------------------------------------------------------------


end processor_arq;