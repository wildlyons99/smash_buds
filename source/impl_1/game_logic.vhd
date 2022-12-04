library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity game_logic is
  port(
	  clk : in std_logic; 
	  controller_buttons : in std_logic_vector(7 downto 0);
	  x : out signed(10 downto 0); 
	  y : out signed(10 downto 0)
      );
end game_logic;

architecture synth of game_logic is
	
	signal col_l : std_logic;
	signal col_r : std_logic;
	signal col_t : std_logic;
	signal col_b : std_logic;
	signal y_plat : signed(10 downto 0);
	
	signal x_gl : signed(10 downto 0);
	signal y_gl : signed(10 downto 0);
	signal yv_gl : signed(3 downto 0);
	
	component collisions is 
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
end component; 

component physics is 
	port (
		clk : in std_logic; 
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
end component; 

	
begin

	col_map : collisions port map(
									clk => clk,
									coll_left => col_l, 
									coll_right => col_r, 
									coll_top => col_t, 
									coll_bottom => col_b,
									y_platform => y_plat,
									buttons => controller_buttons,
									x => x_gl,
									y => y_gl,
									yv => yv_gl
								);
	
	phys_map : physics port map(
									clk => clk,
									coll_left => col_l, 
									coll_right => col_r, 
									coll_top => col_t, 
									coll_bottom => col_b,
									y_platform => y_plat,
									buttons => controller_buttons,
									x => x_gl,
									y => y_gl,
									yv => yv_gl
								);
	x <= x_gl;
	y <= y_gl;

end;


