library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pattern_gen is
  port(
	  clk : in std_logic;
	  row : in signed(10 downto 0); -- 0-1023
	  col : in signed(10 downto 0); -- 0-1023
      valid : in std_logic;
	  
	  -- Tony
	  tony_x : in signed(10 downto 0);
	  tony_y : in signed(10 downto 0);
	  tony_buttons : in std_logic_vector(7 downto 0);
	  
	  -- Sunil
	  sunil_x : in signed(10 downto 0);
	  sunil_y : in signed(10 downto 0);
	  sunil_buttons : in std_logic_vector(7 downto 0);
	  
	  -- Which game state we're in
	  start_screen, tony_win, sunil_win : std_logic;
	  
	  -- Output
	  rgb : out std_logic_vector(5 downto 0)
      );
end pattern_gen;

architecture synth of pattern_gen is

-- Color to output
signal toout : std_logic_vector(5 downto 0);

-- Game over vs. level vs. winning screen
signal level_pixels : std_logic_vector(5 downto 0);
signal start_pixels: std_logic_vector(5 downto 0);
signal tony_win_pixels: std_logic_vector(5 downto 0);
signal sunil_win_pixels: std_logic_vector(5 downto 0);
--signal onsquarex : std_logic;
--signal onsquarey : std_logic;

-- TONY ROM signals
signal tony_color_idle : std_logic_vector(5 downto 0);
signal tony_color_run1 : std_logic_vector(5 downto 0);
signal tony_color_run2 : std_logic_vector(5 downto 0);
signal drawing_tony_x : std_logic;
signal drawing_tony_y : std_logic;
signal tony_diff_x_vector : std_logic_vector(10 downto 0);
signal tony_diff_y_vector : std_logic_vector(10 downto 0);
signal tony_diff_x : signed(10 downto 0);
signal tony_diff_y : signed(10 downto 0);
signal tony_width : signed(5 downto 0);
signal tony_height : signed(6 downto 0);

signal background : std_logic_vector(5 downto 0); 

component tony_idle_rom is
  port(
	  clk : in std_logic;
	  xadr: in unsigned(4 downto 0);
	  yadr : in unsigned(5 downto 0); -- 0-1023
	  rgb : out std_logic_vector(5 downto 0)
      );
end component;

component tony_run_rom1 is
  port(
	  clk : in std_logic;
	  xadr: in unsigned(4 downto 0);
	  yadr : in unsigned(5 downto 0); -- 0-1023
	  rgb : out std_logic_vector(5 downto 0)
      );
end component;

component tony_run_rom2 is
  port(
	  clk : in std_logic;
	  xadr: in unsigned(4 downto 0);
	  yadr : in unsigned(5 downto 0); -- 0-1023
	  rgb : out std_logic_vector(5 downto 0)
      );
end component;

signal counter : unsigned(30 downto 0);
signal tony_left_pressed : std_logic;
signal tony_right_pressed : std_logic; 

signal tony_is_pink_idle : std_logic;
signal tony_is_pink_run1 : std_logic;
signal tony_is_pink_run2 : std_logic;

begin
   tony_map : tony_idle_rom port map(
									 clk => clk,
									 xadr => unsigned(tony_diff_x_vector(4 downto 0)) - 1,
									 yadr => unsigned(tony_diff_y_vector(5 downto 0)),
									 rgb => tony_color_idle
							  		 );
	
	tony_run_map1 : tony_run_rom1 port map(
									 clk => clk,
									 xadr => unsigned(tony_diff_x_vector(4 downto 0)) - 1,
									 yadr => unsigned(tony_diff_y_vector(5 downto 0)),
									 rgb => tony_color_run1
							  		 );
	
	tony_run_map2 : tony_run_rom2 port map(
									 clk => clk,
									 xadr => unsigned(tony_diff_x_vector(4 downto 0)) - 1,
									 yadr => unsigned(tony_diff_y_vector(5 downto 0)),
									 rgb => tony_color_run2
							  		 );
   
   process (clk) is
   begin
		if rising_edge(clk)then
			counter <= counter + 1;
		end if;
   
   end process;
  
   tony_width <= 6d"25";
   tony_height <= 7d"63";
   
   drawing_tony_x <= '1' when (col >= tony_x and col <= tony_x + tony_width) else '0';
   drawing_tony_y <= '1' when (row >= tony_y and row <= tony_y + tony_height) else '0';
   
   tony_diff_x <= col - tony_x;
   tony_diff_y <= row - tony_y;
   
   tony_diff_x_vector <= std_logic_vector(unsigned(tony_diff_x)) when tony_buttons(0) else
					std_logic_vector(unsigned(tony_width) - unsigned(tony_diff_x));
   tony_diff_y_vector <= std_logic_vector(unsigned(tony_diff_y));
   
								-- X     								--    Y
	background <= "001100" when ((col >= 11d"330" and col <= 11d"630") and (row > 11d"370" and row <= 11d"378")) or
								((col >= 11d"0" and col <= 11d"200") and (row > 11d"290" and row <= 11d"298")) or
								(row > 460) -- Floor
						        else "111111";
						   
	tony_is_pink_idle <= '1' when (tony_color_idle = "110110") else '0';
	tony_is_pink_run1 <= '1' when (tony_color_run1 = "110110") else '0';
	tony_is_pink_run2 <= '1' when (tony_color_run2 = "110110") else '0';
	
	level_pixels <= tony_color_run1 when (not counter(21)) and (drawing_tony_x and drawing_tony_y) and (not tony_is_pink_run1) and (tony_buttons(0) or tony_buttons(1)) else
			 tony_color_run2 when (counter(21)) and (drawing_tony_x and drawing_tony_y) and (not tony_is_pink_run2) and (tony_buttons(1) or tony_buttons(0)) else
			 tony_color_idle when (drawing_tony_x and drawing_tony_y) and (not tony_is_pink_idle) and (not tony_buttons(0) and not tony_buttons(1)) else
		     background;
   
   toout <= start_pixels when (start_screen) else
			tony_win_pixels when (tony_win) else
		    sunil_win_pixels when (sunil_win) else
			level_pixels;
   
   rgb <= toout when valid else 6d"0";
end;


