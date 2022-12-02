library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pattern_gen is
  port(
	  clk : in std_logic; 
	  row : in unsigned(9 downto 0); -- 0-1023
	  col : in unsigned(9 downto 0); -- 0-1023
	  x : in unsigned(9 downto 0); 
	  y : in unsigned(9 downto 0);
	  valid : in std_logic;
	  rgb : out std_logic_vector(5 downto 0)
      );
end pattern_gen;

architecture synth of pattern_gen is
signal toout : std_logic_vector(5 downto 0);
signal onsquarex : std_logic;
signal onsquarey : std_logic;
begin
   onsquarex <= '1' when (col > x and col < x + 9) else '0';
   onsquarey <= '1' when (row > y and row < x + 9) else '0';
   toout <= "111111" when (onsquarex and onsquarey) else 
			"000000";
   rgb <= toout when valid else 6d"0";
end;


