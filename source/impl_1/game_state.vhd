library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity game_state is
  port(
	  clk : in std_logic; 
	  
	  -- Player buttons for reset
	  --sunil_reset : in std_logic;
	  tony_reset : in std_logic;
	  
	  start_screen : out std_logic;
	  sunil_win : out std_logic;
	  tony_win : out std_logic
      );
end game_state;

architecture synth of game_state is
	signal not_first_time: std_logic := '0';
	signal reset : std_logic;
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
				if (reset and (not tony_win) and (not sunil_win)) then
					start_screen <= '0';
					not_first_time <= '1'; -- Not the first time any more
				elsif ((tony_win or sunil_win) and reset) then
					start_screen <= '1';
					not_first_time <= '0';
					tony_win <= '0';
					sunil_win <= '0';
				end if;
			end if;
			
		end if;
	end process;

end;


