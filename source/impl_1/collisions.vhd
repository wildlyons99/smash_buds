library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity collisions is 
	generic (
		player_width : signed(5 downto 0) := 6d"25";
		player_height : signed(6 downto 0) := 7d"63"
	);
	
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

architecture synth of collisions is
component platform is
	generic (
		player_width : signed(5 downto 0) := 6d"25";
		player_height : signed(6 downto 0) := 7d"63";
		plat_width : signed(10 downto 0) := 11d"50";
		plat_height : signed(10 downto 0) := 11d"10";
		corner_x : signed(10 downto 0) := 11d"0";
		corner_y : signed(10 downto 0) := 11d"0"
	);
	port (
		clk : in std_logic; 
		
		player_x : in signed(10 downto 0); 
		player_y : in signed(10 downto 0);
		player_yv : in signed(3 downto 0); 
		buttons : in std_logic_vector(7 downto 0);
		
		col_r : out std_logic;
		col_l : out std_logic; 
		col_b : out std_logic;
		col_t : out std_logic;
		y_pos_plat : out signed(10 downto 0)
	);
end component;

signal plat1_col_r : std_logic;
signal plat1_col_l : std_logic;
signal plat1_col_b : std_logic;
signal plat1_col_t : std_logic;
signal plat1_y	   : signed(10 downto 0);

	
begin
	floor : platform generic map (
		plat_width => 11d"640", 
		plat_height => 11d"2",
		corner_x => 11d"0",
		corner_y => 11d"438"
	)
	port map(
		clk => clk,
		player_x => x,
		player_y => y,
		player_yv => yv,
		buttons => buttons,
		col_r => plat1_col_r,
		col_l => plat1_col_l,
		col_b => plat1_col_b,
		col_t => plat1_col_t,
		y_pos_plat => plat1_y
	);
	
	--collisions TODO: or statements, logic vectors!
	coll_left <= '1' when plat1_col_l;
	coll_right <= '1' when plat1_col_r;
	coll_top <= '1' when plat1_col_t;
	coll_bottom <= '1' when plat1_col_b;
	y_platform <= plat1_y; 
	
end;
