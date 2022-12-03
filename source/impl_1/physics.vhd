library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity physics is 
	port (
		coll_left : in std_logic;
		coll_right : in std_logic;
		coll_top : in std_logic;
		coll_bottom : in std_logic;
		y_platform : in signed(10 downto 0);
		buttons : in std_logic_vector(7 downto 0);
		
		x : out signed(10 downto 0);
		y : out signed(10 downto 0);
		yv : out signed(3 downto 0)
	);
end physics; 

