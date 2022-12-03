library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pattern_gen is
  port(
	  clk : in std_logic;
	  row : in signed(10 downto 0); -- 0-1023
	  col : in signed(10 downto 0); -- 0-1023
	  x : in signed(10 downto 0);
	  y : in signed(10 downto 0);
	  valid : in std_logic;
	  rgb : out std_logic_vector(5 downto 0)
      );
end pattern_gen;

architecture synth of pattern_gen is

signal toout : std_logic_vector(5 downto 0);
signal onsquarex : std_logic;
signal onsquarey : std_logic;
signal fromrom : std_logic_vector(5 downto 0);
--signal diffcolx : std_logic_vector(9 downto 0);
--signal diffrowy : std_logic_vector(9 downto 0);
--signal romx : unsigned(1 downto 0);
--signal romy : unsigned(1 downto 0);
signal background : signed(6 downto 0); 

begin
   
   
   --if ((row >= 75) and (row <= 80)) then 
	--	background 
   
   
   onsquarex <= '1' when (col >= x and col <= x + 2) else '0';
   onsquarey <= '1' when (row >= y and row <= y + 2) else '0';
   toout <= "000000" when (onsquarex and onsquarey) else 
   		"111111";
   rgb <= toout when valid else 6d"0";
   --diffcolx <= std_logic_vector(col - x - 1);
   --diffrowy <= std_logic_vector(row - y);
   --romx <= unsigned(diffcolx(1 downto 0));
   --romy <= unsigned(diffrowy(1 downto 0));
end;


