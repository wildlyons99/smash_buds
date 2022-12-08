library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity collisions is 
	generic (
		player_width : signed(5 downto 0) := 6d"25";
		player_height : signed(6 downto 0) := 7d"63";
		relative_hitbox_x : signed(5 downto 0) := 6d"15";
		relative_hitbox_y : signed(6 downto 0) := 7d"25";
		hitbox_width : signed(10 downto 0) := 11d"50";
		hitbox_height : signed(10 downto 0) := 11d"20"
	);
	
	port (
		--clk : in std_logic; 
		--coll_left : out std_logic;
		--coll_right : out std_logic;
		coll_top : out std_logic;
		--coll_bottom : out std_logic;
		y_platform : out signed(10 downto 0);
		
		was_punched_from_left : out std_logic;
		was_punched_from_right : out std_logic;
		is_punching : in std_logic;
		punching_left : out std_logic;
		punching_right : out std_logic;
		
		buttons : in std_logic_vector(7 downto 0);
		
		x : in signed(10 downto 0);
		y : in signed(10 downto 0);
		yv : in signed(4 downto 0);
		
		other_player_x : in signed(10 downto 0);
	    other_player_y : in signed(10 downto 0);
	    other_player_punching_left : in std_logic;
		other_player_punching_right : in std_logic
		
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
		--clk : in std_logic; 
		
		player_x : in signed(10 downto 0); 
		player_y : in signed(10 downto 0);
		player_yv : in signed(4 downto 0); 
		buttons : in std_logic_vector(7 downto 0);
		
		--col_r : out std_logic;
		--col_l : out std_logic; 
		--col_b : out std_logic;
		col_t : out std_logic;
		y_pos_plat : out signed(10 downto 0)
	);
end component;

--signal plat1_col_r : std_logic;
--signal plat1_col_l : std_logic;
--signal plat1_col_b : std_logic;
signal plat1_col_t : std_logic;
signal plat1_y	   : signed(10 downto 0);

--signal plat2_col_r : std_logic;
--signal plat2_col_l : std_logic;
--signal plat2_col_b : std_logic;
signal plat2_col_t : std_logic;
signal plat2_y	   : signed(10 downto 0);

--signal plat3_col_r : std_logic;
--signal plat3_col_l : std_logic;
--signal plat3_col_b : std_logic;
signal plat3_col_t : std_logic;
signal plat3_y	   : signed(10 downto 0);

signal plat4_col_t : std_logic;
signal plat4_y : signed(10 downto 0);

signal hitbox_x : signed(10 downto 0);
signal hitbox_y : signed(10 downto 0);
signal in_hitbox : std_logic;
signal in_hitbox_x : std_logic;
signal in_hitbox_y : std_logic;

begin
	floor : platform generic map (
		plat_width => 11d"640", 
		plat_height => 11d"20",
		corner_x => 11d"0",
		corner_y => 11d"464"
	)
	port map(
		--clk => clk,
		player_x => x,
		player_y => y,
		player_yv => yv,
		buttons => buttons,
		--col_r => plat1_col_r,
		--col_l => plat1_col_l,
		--col_b => plat1_col_b,
		col_t => plat1_col_t,
		y_pos_plat => plat1_y
	); 
	
	
	left_platform : platform generic map (
		plat_width => 11d"148", 
		plat_height => 11d"8",
		corner_x => 11d"32",
		corner_y => 11d"384"
	)
	port map(
		--clk => clk,
		player_x => x,
		player_y => y,
		player_yv => yv,
		buttons => buttons,
		--col_r => plat2_col_r,
		--col_l => plat2_col_l,
		--col_b => plat2_col_b,
		col_t => plat2_col_t,
		y_pos_plat => plat2_y
	);
	
	
	right_platform : platform generic map (
		plat_width => 11d"148", 
		plat_height => 11d"8",
		corner_x => 11d"456",
		corner_y => 11d"384"
	)
	port map(
		--clk => clk,
		player_x => x,
		player_y => y,
		player_yv => yv,
		buttons => buttons,
		--col_r => plat3_col_r,
		--col_l => plat3_col_l,
		--col_b => plat3_col_b,
		col_t => plat3_col_t,
		y_pos_plat => plat3_y
	);
	
	top_platform : platform generic map (
		plat_width => 11d"220", 
		plat_height => 11d"8",
		corner_x => 11d"208",
		corner_y => 11d"296"
	)
	port map(
		--clk => clk,
		player_x => x,
		player_y => y,
		player_yv => yv,
		buttons => buttons,
		--col_r => plat3_col_r,
		--col_l => plat3_col_l,
		--col_b => plat3_col_b,
		col_t => plat4_col_t,
		y_pos_plat => plat4_y
	);
	
	punching_left <= '1' when is_punching and buttons(1) else '0';
	punching_right <= '1' when is_punching and buttons(0) else '0';
	
	hitbox_x <= other_player_x + relative_hitbox_x when (other_player_punching_right) else
				other_player_x + player_width - relative_hitbox_x - hitbox_width;
	hitbox_y <= other_player_y + relative_hitbox_y;
	
	
	in_hitbox_x <= '1' when (x + player_width >= hitbox_x) and (x <= hitbox_x + hitbox_width) else '0';
	in_hitbox_y <= '1' when (y + player_height >= hitbox_y) and (y <= hitbox_y + hitbox_height) else '0';
	
	in_hitbox <= '1' when (in_hitbox_x and in_hitbox_y) else '0';
	
	was_punched_from_left <= '1' when (other_player_punching_right and in_hitbox) else '0';
	was_punched_from_right <= '1' when (other_player_punching_left and in_hitbox) else '0';
	--was_punched_from_left <= '1' when (other_player_punching_right) else '0';
	--was_punched_from_right <= '1' when (other_player_punching_left) else '0';
	--collisions
	--coll_left <= '1' when plat1_col_l else '0';
	--coll_right <= '1' when plat1_col_r else '0';
	--coll_top <= '1' when plat1_col_t else '0';
	--coll_bottom <= '1' when plat1_col_b else '0';
	--coll_left <= plat1_col_l or plat2_col_l or plat3_col_l;
	--coll_right <= plat1_col_r or plat2_col_r or plat3_col_r;
	coll_top <= plat1_col_t or plat2_col_t or plat3_col_t or plat4_col_t;
	--coll_bottom <= plat1_col_b or plat2_col_b or plat3_col_b;
	y_platform <= plat1_y when plat1_col_t else
	              plat2_y when plat2_col_t else
				  plat3_y when plat3_col_t else
				  plat4_y when plat4_col_t else
				  y_platform;
	
end;
