library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity l_edge_col is
	port (
		clk : in std_logic; 
		
		player_width : in signed(5 downto 0);
		player_height : in signed(6 downto 0);
		
		plat_width : in signed(10 downto 0);
		plat_height : in signed(10 downto 0);
		corner_x : in signed(10 downto 0);
		corner_y : in signed(10 downto 0);
		player_x : in signed(10 downto 0); 
		player_y : in signed(10 downto 0);
		player_yv : in signed(10 downto 0); 
		
		buttons : in signed(7 downto 0);

		col_l : out std_logic
	);
end l_edge_col;