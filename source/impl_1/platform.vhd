library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity platform is
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
end platform;

architecture synth of platform is 
	-- Vertical checks
	signal above_or_below_platform : std_logic;
	-- Top Check	
	signal above_platform : std_logic;
	signal passing_through_platform_top : std_logic;
	
	-- Bottom Check
	signal passing_through_platform_bottom : std_logic;
	signal below_platform : std_logic;
	
	--  Horizontal Checks
	signal left_or_right_platform : std_logic;
	-- Left Check
	signal adjacent_to_left_side: std_logic;
	-- Right Check
	signal adjacent_to_right_side: std_logic;
	
begin
		-- Vertical checks (top and bottom)
		-- Top Check
		above_or_below_platform <= '1' when (((player_x + player_width) >= corner_x) and player_x <= (corner_x + plat_width)) else '0';
		above_platform <= '1' when (player_y + player_height <= corner_y) else '0';
		passing_through_platform_top <= '1' when (player_y + player_height + player_yv >= corner_y) else '0';
		col_t <= '1' when (above_or_below_platform and passing_through_platform_top and above_platform) else '0';
		
		-- Bottom Check
		passing_through_platform_bottom <= '1' when (player_y + player_yv < corner_y + plat_height) else '0';
		below_platform <= '1' when (player_y > corner_y + plat_height) else '0';
		col_b <= '1' when (above_or_below_platform and passing_through_platform_bottom and below_platform) else '0';
		
		--Horizontal Checks
		-- Left Check
		adjacent_to_left_side <= '1' when (player_x + player_width + 1 = corner_x) else '0';
		col_l <= '1' when (left_or_right_platform and adjacent_to_left_side and buttons(0)) else '0';
		-- Right Check
		adjacent_to_right_side <= '1' when (player_x + 1 = corner_x + plat_width) else '0';
		col_r <= '1' when (left_or_right_platform and adjacent_to_right_side and buttons(1)) else '0';
		
		-- Where to set height when colliding vertically
		y_pos_plat <= corner_y + plat_height when (col_b) else corner_y; 
end;