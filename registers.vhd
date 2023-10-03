----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.04.2014 17:33:03
-- Design Name: 
-- Module Name: Registers - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Registers is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           wr : in STD_LOGIC;
           reg1_dr : in STD_LOGIC_VECTOR (4 downto 0);
           reg2_dr : in STD_LOGIC_VECTOR (4 downto 0);
           reg_wr : in STD_LOGIC_VECTOR (4 downto 0);
           data_wr : in STD_LOGIC_VECTOR (31 downto 0);
           data1_rd : out STD_LOGIC_VECTOR (31 downto 0);
           data2_rd : out STD_LOGIC_VECTOR (31 downto 0));
end Registers;

architecture Behavioral of Registers is
    type ram_type is array (31 downto 0) of std_logic_vector (31 downto 0);
    signal regs : ram_type;
begin

    process (CLK, reset)
    begin
        if reset = '1' then
                regs <= (others=>x"00000000");
        elsif falling_edge(clk) then
            if (wr = '1') then
                regs(conv_integer(reg_wr)) <= data_wr;
            end if;
        end if;
    end process;
    
	data1_rd <= regs(conv_integer(reg1_dr)) when (reg1_dr /= "00000") else
				(others => '0');

	data2_rd <= regs(conv_integer(reg2_dr)) when (reg2_dr /= "00000") else
				(others => '0');				

end Behavioral;