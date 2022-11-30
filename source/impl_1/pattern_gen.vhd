library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pattern_gen is
  port(
	  clk : in std_logic; 
	  row : in unsigned(9 downto 0); -- 0-1023
	  col : in unsigned(9 downto 0); -- 0-1023
	  valid : in std_logic;
	  rgb : out std_logic_vector(5 downto 0)
      );
end pattern_gen;

architecture synth of pattern_gen is
component lfsr is
  port(
	  clk : in std_logic;
	  row : in unsigned(9 downto 0); -- 0-1023
	  col : in unsigned(9 downto 0); -- 0-1023
	  rgb : out std_logic_vector(5 downto 0)
      );
end component;

signal toout : std_logic_vector(5 downto 0);

begin
   toout <= "000000" when row > 400 else "111111";
   rgb <= toout when valid else 6d"0";
end;


