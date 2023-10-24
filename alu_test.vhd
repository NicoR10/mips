library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_SIGNED.all;

entity tb_alu is
end tb_alu;

architecture behavior of tb_alu is

    component alu
    PORT(
        a: in std_logic_vector(31 downto 0);  
        b: in std_logic_vector(31 downto 0);   
        control: in std_logic_vector(2 downto 0);  
        result: out std_logic_vector(31 downto 0);  
        zero: out std_logic;
    );
    end component;
    
    SIGNAL A : std_logic_vector(31 DOWNTO 0);
    SIGNAL B : std_logic_vector(31 downto 0);
    SIGNAL op : std_logic_vector(2 downto 0) := "000";
    SIGNAL S : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL zero: std_logic;

BEGIN
    uut : alu
    PORT MAP(
        a => A, 
        b => B,
        control => op,
        result => S,
        zero => zero
    );
 
    tb : PROCESS
    BEGIN
        A <= x"00000002";
        B <= x"00000001";
        op <= "000";
        wait for 10 ns;
        op <= "001";
        wait for 10 ns;
        op <= "010";
        wait for 10 ns;
        op <= "110";
        wait for 10 ns;
        op <= "111";
        wait for 10 ns;
        op <= "100";
        wait for 10 ns;
        A <= x"000000d5";
        B <= x"00000002";
        wait;

    END PROCESS;

end behavior;  