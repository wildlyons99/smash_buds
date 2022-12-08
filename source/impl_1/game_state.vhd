library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity game_state is
  port(
	  clk : in std_logic; 
	  
	  -- Player buttons for reset
	  sunil_reset : in std_logic;
	  tony_reset : in std_logic;
	  
	  -- Player positions for determining win condition
	  tony_x : in signed(10 downto 0);
	  tony_y : in signed(10 downto 0);
	  sunil_x : in signed(10 downto 0);
	  sunil_y : in signed(10 downto 0);
	  
	  start_screen : out std_logic;
	  sunil_win : out std_logic;
	  tony_win : out std_logic;
	  
	  reset_players : out std_logic;
	  
	  win_timer : out signed(9 downto 0)
      );
end game_state;

architecture synth of game_state is
	component win_area is 
	generic (
		win_box_x : signed(10 downto 0) := 11d"0";
		win_box_y : signed(10 downto 0) := 11d"0";
		
		win_box_height : signed(10 downto 0);
		win_box_width : signed(10 downto 0)
	);
	port(
		clk : in std_logic; 
		tony_x : in signed(10 downto 0);
		tony_y : in signed(10 downto 0);
		sunil_x : in signed(10 downto 0);
	    sunil_y : in signed(10 downto 0);
		reset : in std_logic;

		
		win_timer : out signed(9 downto 0)
	);
end component; 
	
	signal not_first_time: std_logic := '0';
	signal reset : std_logic;
	signal prev_reset : std_logic;
	signal reset_and_not_prev_reset : std_logic;
	
	-- FOR DEBUG
	signal tony_left_or_right_platform : std_logic;
	signal tony_adjacent_to_left_side : std_logic;
	signal player_width : signed(5 downto 0) := 6d"25";
	signal player_height : signed(6 downto 0) := 7d"63";
	
	
begin
	-- Show start screen when ROM boots up, press start to get away from it
	process (clk) begin
		if rising_edge(clk) then
			reset <= tony_reset or sunil_reset;
			prev_reset <= reset;
			if (not not_first_time) then -- First time
				start_screen <= '1';
				not_first_time <= '1';
				tony_win <= '0';
				sunil_win <= '0';
				reset_players <= '1';
			else
				if (start_screen and reset_and_not_prev_reset and (not tony_win) and (not sunil_win)) then -- Get out of start screen by hitting reset
					start_screen <= '0';
					not_first_time <= '1'; -- Not the first time any more
					reset_players <= '0';
				elsif ((tony_win or sunil_win) and reset_and_not_prev_reset) then -- Get out of win screen (to start screen) by hitting reset
					start_screen <= '1';
					not_first_time <= '0';
					tony_win <= '0';
					sunil_win <= '0';
					reset_players <= '1';
				elsif (win_timer = 10d"300") then 
					tony_win <= '1';
				elsif (win_timer = 0 - 300) then
					sunil_win <= '1';
				end if;
			end if;
			
		end if;
	end process;
	-- FOR DEBUG
	player_height <= 7d"63";
	player_width <= 6d"25";
	tony_left_or_right_platform <= '1' when (((tony_y + player_height) >= 250) and tony_y <= (250 + 5)) else '0';
	tony_adjacent_to_left_side <= '1' when (tony_x + player_width + 1 = 250) else '0';
	reset_and_not_prev_reset <= '1' when (reset and not prev_reset) else '0';
	
	
	
	-- win_area port map
	win_area_map : win_area generic map(
		win_box_x => 11d"208",
		win_box_y => 11d"0",
		
		win_box_height => 11d"250",
		win_box_width => 11d"220"
	)
	port map (
		clk => clk,
		tony_x => tony_x,
		tony_y => tony_y,
		sunil_x => sunil_x,
	    sunil_y => sunil_y,
		reset => reset_players,
		win_timer => win_timer
	);

end;




