LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_SIGNED.ALL;
USE IEEE.numeric_std.ALL;

ENTITY alu IS
    GENERIC (CONSTANT N : NATURAL := 16);
    PORT (
        a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        control : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        zero : OUT STD_LOGIC;
    );
END alu;

ARCHITECTURE beh_alu OF alu IS
    SIGNAL r : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
BEGIN
    PROCESS (control, a, b, r)
    BEGIN
        zero <= '0';
        IF (control = "000") THEN
            r <= a AND b;
            -- zero <= '1' when (a AND b) = x"00000000";
        ELSIF (control = "001") THEN
            r <= a OR b;
        ELSIF (control = "010") THEN
            r <= a + b;
        ELSIF (control = "110") THEN
            r <= a - b;
            -- zero <= '1' when (a = b) = x"00000000";
        ELSIF (control = "111") THEN
            IF (a < b) THEN
                r <= x"00000001";
            ELSE
                r <= x"00000000";
            END IF;
        ELSIF (control = "100") THEN
            r <= STD_LOGIC_VECTOR(signed(b) SLL N);
        ELSE
            r <= x"00000000";
        END IF;
        IF (r = x"00000000") THEN
            zero <= '1';
        END IF;
        result <= r;
    END PROCESS;

END beh_alu;