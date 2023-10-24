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
    signal r: std_logic_vector(31 downto 0) := (others => '0');
begin
    process(control, a, b, r)
    begin
    	zero <= '0';
    	if(control = "000") then
            r <= a and b;
        elsif(control = "001") then
            r <= a or b;
        elsif(control = "010") then
            r <= a + b;
        elsif(control = "110") then
            r <= a - b;
        elsif(control = "111") then
            if(a < b) then
            	r <= x"00000001";
            else
            	r <= x"00000000";
            end if;
        elsif(control = "100")then
            r <= std_logic_vector(signed(b) sll N);
        else
        	r <= x"00000000";
        end if;
        if(r = x"00000000") then
        	zero <= '1';
        end if;
        result <= r;
    end process;    
end beh_alu;
