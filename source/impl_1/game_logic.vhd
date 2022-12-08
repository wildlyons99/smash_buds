library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity game_logic is
  port(
	  clk : in std_logic; 
	  
	  reset_players : in std_logic;
	  
	  -- Tony
	  tony_controller_buttons : in std_logic_vector(7 downto 0);
	  tony_x : out signed(10 downto 0); 
	  tony_y : out signed(10 downto 0);
	  tony_punching : out std_logic;
	  
	  -- Sunil
	  sunil_controller_buttons : in std_logic_vector(7 downto 0);
	  sunil_x : out signed(10 downto 0); 
	  sunil_y : out signed(10 downto 0);
	  sunil_punching : out std_logic;
	  
	  sunil_in_hitbox : out std_logic;
	  tony_in_hitbox : out std_logic

      );
end game_logic;

architecture synth of game_logic is
	
	signal sunil_punching_left : std_logic;
	signal sunil_punching_right : std_logic;
	signal tony_punching_left : std_logic;
	signal tony_punching_right : std_logic;

	component player is
	generic (
		reset_x : signed(10 downto 0) := 11d"0";
		reset_y : signed(10 downto 0) := 11d"0"
    );
	port(
	  clk : in std_logic; 
	  reset_players : in std_logic;
	  controller_buttons : in std_logic_vector(7 downto 0);
	  
	  other_player_x : in signed(10 downto 0);
	  other_player_y : in signed(10 downto 0);
	  other_player_punching_left : in std_logic;
	  other_player_punching_right : in std_logic;
	  
	  x : out signed(10 downto 0); 
	  y : out signed(10 downto 0);
	  is_punching_left : out std_logic;
	  is_punching_right : out std_logic;
	  is_punching : out std_logic;
	  
	  in_hitbox : out std_logic

	  );
	end component;

begin


	tony : player 
	generic map (
		reset_x => 11d"200",
		reset_y => 11d"200"
	)
	port map (
		clk => clk,
		reset_players => reset_players,
		controller_buttons => tony_controller_buttons,
		
		other_player_x => sunil_x,
	    other_player_y => sunil_y,
	    other_player_punching_left => sunil_punching_left,
		other_player_punching_right => sunil_punching_right,
		
		x => tony_x,
		y => tony_y,
		is_punching_left => tony_punching_left,
		is_punching_right => tony_punching_right,
		is_punching => tony_punching,
		
		in_hitbox => tony_in_hitbox
	);
	
	sunil : player
	generic map (
		reset_x => 11d"400",
		reset_y => 11d"100"
	)
	port map (
		clk => clk,
		controller_buttons => sunil_controller_buttons,
		reset_players => reset_players,
		
		other_player_x => tony_x,
		other_player_y => tony_y,
		other_player_punching_left => tony_punching_left,
		other_player_punching_right => tony_punching_right,
		
		x => sunil_x,
		y => sunil_y,
		is_punching_left => sunil_punching_left,
		is_punching_right => sunil_punching_right,
		is_punching => sunil_punching,
		
		in_hitbox => sunil_in_hitbox
	);

end;


