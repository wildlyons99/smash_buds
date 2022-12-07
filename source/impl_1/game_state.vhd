library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity game_state is
  port(
	  clk : in std_logic; 
	  
	  -- Player buttons for reset
	  --sunil_reset : in std_logic;
	  tony_reset : in std_logic;
	  
	  -- Player positions for determining win condition
	  tony_x : in signed(10 downto 0);
	  tony_y : in signed(10 downto 0);
	  -- sunil positions
	  
	  start_screen : out std_logic;
	  sunil_win : out std_logic;
	  tony_win : out std_logic
      );
end game_state;

architecture synth of game_state is
	signal not_first_time: std_logic := '0';
	signal reset : std_logic;
	
	-- FOR DEBUG
	signal tony_left_or_right_platform : std_logic;
	signal tony_adjacent_to_left_side : std_logic;
	signal player_width : signed(5 downto 0) := 6d"25";
	signal player_height : signed(6 downto 0) := 7d"63";
begin
	-- Name states
	reset <= tony_reset; -- or sunil_reset;
	
	-- Show start screen when ROM boots up, press start to get away from it
	process (clk) begin
		if rising_edge(clk) then
			if (not not_first_time) then -- First time
				start_screen <= '1';
				not_first_time <= '1';
				tony_win <= '0';
				sunil_win <= '0';
			else
				if (start_screen and reset and (not tony_win) and (not sunil_win)) then -- Get out of start screen by hitting reset
					start_screen <= '0';
					not_first_time <= '1'; -- Not the first time any more
				elsif ((tony_win or sunil_win) and reset) then -- Get out of win screen by hitting reset
					start_screen <= '1';
					not_first_time <= '0';
					tony_win <= '0';
					sunil_win <= '0';
				elsif (tony_left_or_right_platform and tony_adjacent_to_left_side) then -- DEBUGGING, TONY WINS IF HE TOUCHES RED SQUARE
					tony_win <= '1';
				end if;
			end if;
			
		end if;
	end process;
	-- FOR DEBUG
	player_height <= 7d"63";
	player_width <= 6d"25";
	tony_left_or_right_platform <= '1' when (((tony_y + player_height) >= 250) and tony_y <= (250 + 5)) else '0';
	tony_adjacent_to_left_side <= '1' when (tony_x + player_width + 1 = 250) else '0';
end;


