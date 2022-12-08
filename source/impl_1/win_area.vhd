library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity win_area is 
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
		-- sunil_timer : out unsigned(8 downto 0)
	);
end win_area; 

architecture synth of win_area is

signal tony_in_box : std_logic;
signal sunil_in_box : std_logic;

signal not_first_time : std_logic := '0';
signal game_over : std_logic; 

begin
	process (clk) is 
	begin
		if rising_edge(clk) then
			if (not not_first_time or reset) then
				game_over <= '0';
				win_timer <= 10d"0";
				not_first_time <= '1';
			else 
				if (win_timer = 10d"300" or win_timer <= 0 - 300) then
					game_over <= '1';
				end if;
				
				if not game_over then
					if (tony_in_box and not sunil_in_box) then
						win_timer <= win_timer + 1;
					elsif (sunil_in_box and not tony_in_box) then
						win_timer <= win_timer - 1;
					elsif (not sunil_in_box and not tony_in_box) then 
						win_timer <= win_timer;
					else 
						win_timer <= win_timer;
					end if;
				end if;
				
			end if;
		end if;
	end process;


tony_in_box <= '1' when (tony_x >= win_box_x and tony_x <= win_box_x + win_box_width) and (tony_y >= win_box_y and tony_y <= win_box_y + win_box_height)
				   else '0';

sunil_in_box <= '1' when (sunil_x >= win_box_x and sunil_x <= win_box_x + win_box_width) and (sunil_y >= win_box_y and sunil_y <= win_box_y + win_box_height)
				   else '0';

end;


