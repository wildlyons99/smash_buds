library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity collisions is 
	port (
		clk : in std_logic; 
		coll_left : out std_logic;
		coll_right : out std_logic;
		coll_top : out std_logic;
		coll_bottom : out std_logic;
		y_platform : out signed(10 downto 0);
		
		buttons : in std_logic_vector(7 downto 0);
		
		x : in signed(10 downto 0);
		y : in signed(10 downto 0);
		yv : in signed(3 downto 0)
	);
end collisions; 
