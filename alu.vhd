library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_SIGNED.all;
use IEEE.numeric_std.all;

entity alu is
    generic (constant N: natural := 16);
    port(a: in std_logic_vector(31 downto 0);  
        b: in std_logic_vector(31 downto 0);   
        control: in std_logic_vector(2 downto 0);  
        result: out std_logic_vector(31 downto 0);  
        zero: out std_logic;
    );            
end alu;

architecture beh_alu of alu is
begin
    process(control, a, b)
    begin
    	zero <= '0';
    	if(control = "000") then
            result <= a and b;
        elsif(control = "001") then
            result <= a or b;
        elsif(control = "010") then
            result <= a + b;
        elsif(control = "110") then
            result <= a - b;
        elsif(control = "111") then
            if(a < b) then
            	result <= x"00000001";
            else
            	result <= x"00000000";
            end if;
        elsif(control = "100")then
            result <= std_logic_vector(unsigned(a) sll N);
        else
            result <= x"00000000";
        end if;
        if(result = x"00000000") then
        	zero <= '1';
        end if;
    end process;
end beh_alu;
