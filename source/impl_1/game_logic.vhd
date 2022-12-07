library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity game_logic is
  port(
	  clk : in std_logic; 
	  tony_controller_buttons : in std_logic_vector(7 downto 0);
	  tony_x : out signed(10 downto 0); 
	  tony_y : out signed(10 downto 0)
      );
end game_logic;

architecture synth of game_logic is
	
	signal tony_col_l : std_logic;
	signal tony_col_r : std_logic;
	signal tony_col_t : std_logic;
	signal tony_col_b : std_logic;
	signal tony_y_plat : signed(10 downto 0);
	
	signal tony_x_gl : signed(10 downto 0);
	signal tony_y_gl : signed(10 downto 0);
	signal tony_yv_gl : signed(4 downto 0);
	
	component collisions is 
	port (
		--clk : in std_logic; 
		coll_left : out std_logic;
		coll_right : out std_logic;
		coll_top : out std_logic;
		coll_bottom : out std_logic;
		y_platform : out signed(10 downto 0);
		
		buttons : in std_logic_vector(7 downto 0);
		
		x : in signed(10 downto 0);
		y : in signed(10 downto 0);
		yv : in signed(4 downto 0)
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
		yv : out signed(4 downto 0)
	);
end component; 

	
begin

	col_map : collisions port map(
									--clk => clk,
									coll_left => tony_col_l, 
									coll_right => tony_col_r, 
									coll_top => tony_col_t, 
									coll_bottom => tony_col_b,
									y_platform => tony_y_plat,
									buttons => tony_controller_buttons,
									x => tony_x_gl,
									y => tony_y_gl,
									yv => tony_yv_gl
								);
	
	phys_map : physics port map(
									clk => clk,
									coll_left => tony_col_l, 
									coll_right => tony_col_r, 
									coll_top => tony_col_t, 
									coll_bottom => tony_col_b,
									y_platform => tony_y_plat,
									buttons => tony_controller_buttons,
									x => tony_x_gl,
									y => tony_y_gl,
									yv => tony_yv_gl
								);
	tony_x <= tony_x_gl;
	tony_y <= tony_y_gl;

end;


