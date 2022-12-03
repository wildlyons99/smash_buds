library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pattern_gen is
  port(
	  clk : in std_logic;
	  clk60hz : in std_logic;
	  row : in unsigned(9 downto 0); -- 0-1023
	  col : in unsigned(9 downto 0); -- 0-1023
	  buttons : in std_logic_vector(7 downto 0);
	  valid : in std_logic;
	  rgb : out std_logic_vector(5 downto 0)
      );
end pattern_gen;

architecture synth of pattern_gen is
component game_logic is
	port(
	  clk : in std_logic; 
	  controller_buttons : in std_logic_vector(7 downto 0);
	  x : out unsigned(9 downto 0); 
	  y : out unsigned(9 downto 0)
      );
end component;
signal toout : std_logic_vector(5 downto 0);
signal onsquarex : std_logic;
signal onsquarey : std_logic;
signal x : unsigned(9 downto 0);
signal y : unsigned(9 downto 0);
begin
   game : game_logic port map(
							 clk => clk60hz,
							 controller_buttons => buttons,
							 x => x,
							 y => y
							 );
   --onsquarex <= '1' when (col >= x and col < x + 9) else '0';
   --onsquarey <= '1' when (row >= y and row < x + 9) else '0';
   toout <= "000000" when (col = x and row = y) else 
			"111111";
   rgb <= toout when valid else 6d"0";
end;


