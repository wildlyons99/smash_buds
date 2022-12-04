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
--signal onsquarex : std_logic;
--signal onsquarey : std_logic;

-- TONY ROM signals
signal tony_color : std_logic_vector(5 downto 0);
signal drawing_tony_x : std_logic;
signal drawing_tony_y : std_logic;
signal diff_x_vector : std_logic_vector(10 downto 0);
signal diff_y_vector : std_logic_vector(10 downto 0);
signal diff_x : signed(10 downto 0);
signal diff_y : signed(10 downto 0);
signal tony_width : signed(5 downto 0);
signal tony_height : signed(6 downto 0);

signal background : signed(6 downto 0); 

component tony_idle_rom is
  port(
	  clk : in std_logic;
	  xadr: in unsigned(4 downto 0);
	  yadr : in unsigned(5 downto 0); -- 0-1023
	  rgb : out std_logic_vector(5 downto 0)
      );
end component;

begin
   tony_map : tony_idle_rom port map(
									 clk => clk,
									 xadr => unsigned(diff_x_vector(4 downto 0)),
									 yadr => unsigned(diff_y_vector(5 downto 0)),
									 rgb => tony_color
							  		 );
   
   tony_width <= 6d"25";
   tony_height <= 7d"63";
   
   drawing_tony_x <= '1' when (col >= x and col <= x + tony_width) else '0';
   drawing_tony_y <= '1' when (row >= y and row <= y + tony_height) else '0';
   
   diff_x <= col - x;
   diff_y <= row - y;
   
   diff_x_vector <= std_logic_vector(unsigned(diff_x));
   diff_y_vector <= std_logic_vector(unsigned(diff_y));
   
 
   toout <= tony_color when (drawing_tony_x and drawing_tony_y) else 
   		"111111";
   rgb <= toout when valid else 6d"0";
  
end;


