library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_UNSIGNED.all;

entity tb_alu is
end tb_alu;

architecture behavior of tb_alu is

    component alu
    PORT(
        A: in std_logic_vector(15 downto 0);
        B: in std_logic_vector(15 downto 0);   
        op: in std_logic_vector(2 downto 0);  
        S: out std_logic_vector(15 downto 0); 
        Carryout : out std_logic;
    );
    end component;
    
    SIGNAL A : std_logic_vector(15 DOWNTO 0);
    SIGNAL B : std_logic_vector(15 downto 0);
    SIGNAL op : std_logic_vector(2 downto 0) := "000";
    SIGNAL S : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN
    uut : alu
    PORT MAP(
        A => A,
        B => B,
        op => op,
        S => S
    );

    tb : PROCESS
    BEGIN
        A <= x"0001";
        B <= x"000A";
        op <= "000";
        wait for 10 ns;
        op <= "001";
        wait for 10 ns;
        op <= "010";
        wait for 10 ns;
        op <= "011";
        wait for 10 ns;
        op <= "100";
        wait for 10 ns;
        op <= "101";
        wait for 10 ns;
        op <= "110";
        wait for 10 ns;
        op <= "111";
        wait for 10 ns;
        A <= x"00d5";
        B <= x"0002";
        wait;

    END PROCESS;

end behavior;  