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
	  tony_punching : in std_logic;
	  
	  -- Sunil
	  sunil_x : in signed(10 downto 0);
	  sunil_y : in signed(10 downto 0);
	  sunil_buttons : in std_logic_vector(7 downto 0);
	  sunil_punching : in std_logic;
	  
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

-- For ROMS
signal player_width : signed(5 downto 0);
signal player_height : signed(6 downto 0);
signal counter : unsigned(30 downto 0);


-- TONY ROM signals
signal tony_pixel : std_logic_vector(5 downto 0);
signal tony_pixel_pink : std_logic;
--
signal tony_color_idle : std_logic_vector(5 downto 0);
signal tony_color_run1 : std_logic_vector(5 downto 0);
signal tony_color_run2 : std_logic_vector(5 downto 0);
--
signal drawing_tony_x : std_logic;
signal drawing_tony_y : std_logic;
--
signal tony_diff_x_vector : std_logic_vector(10 downto 0);
signal tony_diff_y_vector : std_logic_vector(10 downto 0);
signal tony_diff_x : signed(10 downto 0);
signal tony_diff_y : signed(10 downto 0);
--
signal tony_left_pressed : std_logic;
signal tony_right_pressed : std_logic;


-- SUNIL ROM signals
signal sunil_pixel : std_logic_vector(5 downto 0);
signal sunil_pixel_pink : std_logic;
--
signal sunil_color_idle : std_logic_vector(5 downto 0);
signal sunil_color_run1 : std_logic_vector(5 downto 0);
signal sunil_color_run2 : std_logic_vector(5 downto 0);
--
signal drawing_sunil_x : std_logic;
signal drawing_sunil_y : std_logic;
--
signal sunil_diff_x_vector : std_logic_vector(10 downto 0);
signal sunil_diff_y_vector : std_logic_vector(10 downto 0);
signal sunil_diff_x : signed(10 downto 0);
signal sunil_diff_y : signed(10 downto 0);
--
signal sunil_left_pressed : std_logic;
signal sunil_right_pressed : std_logic;

signal row_vector : std_logic_vector(10 downto 0);
signal col_vector : std_logic_vector(10 downto 0);
signal row_vector_inverted : std_logic_vector(10 downto 0);
signal col_vector_inverted : std_logic_vector(10 downto 0);

signal background : std_logic_vector(5 downto 0); 


-- Punching signals
signal on_tony_hitbox : std_logic;
signal on_sunil_hitbox : std_logic;

signal on_tony_hitbox_x, on_tony_hitbox_y : std_logic;
signal on_sunil_hitbox_x, on_sunil_hitbox_y : std_logic;

signal tony_hitbox_x : signed(10 downto 0);
signal tony_hitbox_y : signed(10 downto 0);

signal sunil_hitbox_x : signed(10 downto 0);
signal sunil_hitbox_y : signed(10 downto 0);


-- Tony ROMs
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

-- Sunil ROMs
component sunil_idle_rom is
  port(
	  clk : in std_logic;
	  xadr: in unsigned(4 downto 0);
	  yadr : in unsigned(5 downto 0); -- 0-1023
	  rgb : out std_logic_vector(5 downto 0)
      );
end component;

component sunil_run_rom1 is
  port(
	  clk : in std_logic;
	  xadr: in unsigned(4 downto 0);
	  yadr : in unsigned(5 downto 0); -- 0-1023
	  rgb : out std_logic_vector(5 downto 0)
      );
end component;

component sunil_run_rom2 is
  port(
	  clk : in std_logic;
	  xadr: in unsigned(4 downto 0);
	  yadr : in unsigned(5 downto 0); -- 0-1023
	  rgb : out std_logic_vector(5 downto 0)
      );
end component;

-- Start screen ROM
component start_screen_rom is
  port(
	  clk : in std_logic;
	  xadr: in unsigned(6 downto 0);
	  yadr : in unsigned(5 downto 0); -- 0-1023
	  rgb : out std_logic_vector(5 downto 0)
      );
end component;

begin
   -- Naming Signals
   tony_left_pressed <= tony_buttons(1);
   tony_right_pressed <= tony_buttons(0);
   sunil_left_pressed <= sunil_buttons(1);
   sunil_right_pressed <= sunil_buttons(0);
   
   -- Tony ROMs
   tony_idle_map : tony_idle_rom port map(
									 clk => clk,
									 xadr => unsigned(tony_diff_x_vector(4 downto 0)),
									 yadr => unsigned(tony_diff_y_vector(5 downto 0)),
									 rgb => tony_color_idle
							  		 );
	
	tony_run_map1 : tony_run_rom1 port map(
									 clk => clk,
									 xadr => unsigned(tony_diff_x_vector(4 downto 0)),
									 yadr => unsigned(tony_diff_y_vector(5 downto 0)),
									 rgb => tony_color_run1
							  		 );
	
	tony_run_map2 : tony_run_rom2 port map(
									 clk => clk,
									 xadr => unsigned(tony_diff_x_vector(4 downto 0)),
									 yadr => unsigned(tony_diff_y_vector(5 downto 0)),
									 rgb => tony_color_run2
							  		 );
   
   -- Sunil ROMs
   sunil_idle_map : sunil_idle_rom port map(
											 clk => clk,
											 xadr => unsigned(sunil_diff_x_vector(4 downto 0)),
											 yadr => unsigned(sunil_diff_y_vector(5 downto 0)),
											 rgb => sunil_color_idle
										   );
										   
	sunil_run_map1 : sunil_run_rom1 port map(
									 clk => clk,
									 xadr => unsigned(sunil_diff_x_vector(4 downto 0)),
									 yadr => unsigned(sunil_diff_y_vector(5 downto 0)),
									 rgb => sunil_color_run1
							  		 );
	
	sunil_run_map2 : sunil_run_rom2 port map(
									 clk => clk,
									 xadr => unsigned(sunil_diff_x_vector(4 downto 0)),
									 yadr => unsigned(sunil_diff_y_vector(5 downto 0)),
									 rgb => sunil_color_run2
							  		 );
   
   
   process (clk) is
   begin
		if rising_edge(clk)then
			counter <= counter + 1;
		end if;
   
   end process;
  
   -- Drawing Players
   player_width <= 6d"25";
   player_height <= 7d"63";
   
   -- Drawing Tony Logic
   drawing_tony_x <= '1' when (col >= tony_x and col <= tony_x + player_width) else '0';
   drawing_tony_y <= '1' when (row >= tony_y and row <= tony_y + player_height) else '0';
   
   tony_diff_x <= col - tony_x + 1;
   tony_diff_y <= row - tony_y;
   
   tony_diff_x_vector <= std_logic_vector(unsigned(tony_diff_x)) when tony_buttons(0) else
					std_logic_vector(unsigned(player_width) - unsigned(tony_diff_x));
   tony_diff_y_vector <= std_logic_vector(unsigned(tony_diff_y));
   
   tony_pixel <= tony_color_run1 when (not counter(21)) and (tony_buttons(0) or tony_buttons(1)) else
			 tony_color_run2 when (counter(21)) and (tony_buttons(1) or tony_buttons(0)) else
			 tony_color_idle when (not tony_buttons(0) and not tony_buttons(1));
   
   tony_pixel_pink <= '1' when (tony_pixel = "110110") else '0';
   
   -- Drawing Sunil Logic
   drawing_sunil_x <= '1' when (col >= sunil_x and col <= sunil_x + player_width) else '0';
   drawing_sunil_y <= '1' when (row >= sunil_y and row <= sunil_y + player_height) else '0';
   
   sunil_diff_x <= col - sunil_x + 1;
   sunil_diff_y <= row - sunil_y;
   
   sunil_diff_x_vector <= std_logic_vector(unsigned(sunil_diff_x)) when sunil_buttons(0) else
					std_logic_vector(unsigned(player_width) - unsigned(sunil_diff_x));
   sunil_diff_y_vector <= std_logic_vector(unsigned(sunil_diff_y));
   
   sunil_pixel <= sunil_color_run1 when (not counter(21)) and (sunil_buttons(0) or sunil_buttons(1)) else
			 sunil_color_run2 when (counter(21)) and (sunil_buttons(1) or sunil_buttons(0)) else
			 sunil_color_idle when (not sunil_buttons(0) and not sunil_buttons(1));
			 
   sunil_pixel_pink <= '1' when (sunil_pixel = "110110") else '0';
   
   -- Drawing hitboxes 
   tony_hitbox_x <= tony_x + 15 when (tony_right_pressed) else
                    tony_x + player_width - 15 - 35;
   tony_hitbox_y <= tony_y + 20;
   
   on_tony_hitbox_x <= '1' when ((col >= tony_hitbox_x) and (col <= tony_hitbox_x + 35)) else '0';
   on_tony_hitbox_y <= '1' when ((row >= tony_hitbox_y) and (row <= tony_hitbox_y + 20)) else '0';
   
   sunil_hitbox_x <= sunil_x + 15 when (sunil_right_pressed) else
                    sunil_x + player_width - 15 - 35;
   sunil_hitbox_y <= sunil_y + 20;
   
   on_sunil_hitbox_x <= '1' when ((col >= sunil_hitbox_x) and (col <= sunil_hitbox_x + 35)) else '0';
   on_sunil_hitbox_y <= '1' when ((row >= sunil_hitbox_y) and (row <= sunil_hitbox_y + 20)) else '0';
   
   on_tony_hitbox <= '1' when (on_tony_hitbox_x and on_tony_hitbox_y) else '0';
   on_sunil_hitbox <= '1' when (on_sunil_hitbox_x and on_sunil_hitbox_y) else '0';
   
   
   
   -- Drawing Background
								-- X     								--    Y
	background <= "001100" when ((col >= 11d"330" and col <= 11d"630") and (row > 11d"370" and row <= 11d"378")) or -- Bototm right platform
								((col >= 11d"0" and col <= 11d"200") and (row > 11d"290" and row <= 11d"298")) or -- Top left platform
								(row > 464) else -- Floor 
								"110000" when ((col >= 11d"250" and col <= 11d"300") and (row > 11d"250" and row <= 11d"255")) else -- Win square for debugging
								"111111";
	
	
	-- Drawing Level
	level_pixels <= "000011" when ((on_tony_hitbox and tony_punching and (tony_right_pressed or tony_left_pressed)) or (on_sunil_hitbox and sunil_punching and (sunil_right_pressed or sunil_left_pressed))) else
				    tony_pixel when (drawing_tony_x and drawing_tony_y and (not tony_pixel_pink)) else
					sunil_pixel when (drawing_sunil_x and drawing_sunil_y and (not sunil_pixel_pink)) else
		            background;
   
   
   -- Start Screen
   -- Start Screen ROM
   row_vector <= std_logic_vector(row);
   row_vector_inverted <= not row_vector;
   col_vector <= std_logic_vector(col + 1);
   col_vector_inverted <= not col_vector;
   
   start_screen_map : start_screen_rom port map(
											   clk => clk,
											   xadr => unsigned(col_vector(9 downto 3)), -- col / 8,
											   yadr => unsigned(row_vector(8 downto 3)), --row / 8,
											   rgb => start_pixels
											   );
   
   tony_win_pixels <= "001100";
   sunil_win_pixels <= "110011";
   
   
   -- What to output
   toout <= start_pixels when (start_screen) else
			tony_win_pixels when (tony_win) else
		    sunil_win_pixels when (sunil_win) else
			level_pixels;
   
   
   -- Final Output only when valid
   rgb <= toout when valid else 6d"0";
end;


