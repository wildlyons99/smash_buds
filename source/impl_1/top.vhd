library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top is
  port(
	  -- For VGA Output
	  ext12m : in std_logic;
	  HSYNC : out std_logic;
	  VSYNC : out std_logic;
	  RGB : out std_logic_vector(5 downto 0);
	  
	  -- Tony Player
	  tony_controller_in : in std_logic;
	  tony_controller_latch : out std_logic;
	  tony_controller_clock : out std_logic;
	  
	  -- Sunil Player
	  sunil_controller_in : in std_logic;
	  sunil_controller_latch : out std_logic;
	  sunil_controller_clock : out std_logic
	  
      );
end top;

architecture synth of top is
	component my_pll is
    port(
        ref_clk_i: in std_logic; -- Input clock
        rst_n_i: in std_logic; -- Reset active low (so normally keep high)
        outcore_o: out std_logic; -- Output to pins
        outglobal_o: out std_logic -- Output to fpga clock network
    );
	end component;
	component controller is
	port(
		input_clk : in std_logic;
		latch : out std_logic;
		clock : out std_logic;
		data : in std_logic;
		output : out std_logic_vector(7 downto 0)
	);
	end component;
	component pllclock_to_60_hz is
	port(
	  clk_in : in std_logic;
	  clk_out : out std_logic
      );
	end component;
	component vga is
	    port(
		  clk : in std_logic;
		  HSYNC : out std_logic;
		  VSYNC : out std_logic;
		  row : out signed(10 downto 0); -- 0-1023
		  col : out signed(10 downto 0); -- 0-1023
		  valid : out std_logic
		  );
	end component;
	component pattern_gen is
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
	end component;

	component game_logic is
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
		  sunil_punching : out std_logic
	  
		  );
	end component;
	
	component game_state is
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
	  
	  reset_players : out std_logic
      );
	end component;
	
	
	-- Signals
	-- Clock
	signal internal25clk : std_logic;
	signal internal60hzclk : std_logic;
	
	-- VGA
	signal internalrow : signed(10 downto 0);
	signal internalcol : signed(10 downto 0);
	signal internalvalid : std_logic;
	
	-- Controllers
	signal tony_controller_buttons_signal : std_logic_vector(7 downto 0);
	signal sunil_controller_buttons_signal : std_logic_vector(7 downto 0);

	
	-- Game State
	signal tony_xpos : signed(10 downto 0);
	signal tony_ypos : signed(10 downto 0);
	signal tony_punching : std_logic;
	signal sunil_xpos : signed(10 downto 0);
	signal sunil_ypos : signed(10 downto 0);
	signal sunil_punching : std_logic;
	signal start_screen, sunil_win, tony_win : std_logic;
	signal reset_players : std_logic;
	
	-- Synchronize outputs
	signal colors_from_pattern_gen : std_logic_vector(5 downto 0);
	signal hsync_from_vga, vsync_from_vga : std_logic;
begin
   -- Clocks
   --sixtyHZclock : pllclock_to_60_hz port map(internal25clk, internal60hzclk);
   internal60hzclk <= '1' when (internalrow = 482) else '0';
   
   pll : my_pll port map(
					     ref_clk_i => ext12m,
						 rst_n_i => '1',
						 outglobal_o => internal25clk
						 );
   
   -- Video Output
   internalvga : vga port map(internal25clk, hsync_from_vga, vsync_from_vga, internalrow, internalcol, internalvalid);
   patternmaker : pattern_gen port map (
									   clk => internal25clk,
									   row => internalrow,
									   col => internalcol,
									   tony_x => tony_xpos,
									   tony_y => tony_ypos,
									   tony_punching => tony_punching,
									   sunil_x => sunil_xpos,
									   sunil_y => sunil_ypos,
									   sunil_punching => sunil_punching,
									   valid => internalvalid,
									   tony_buttons => tony_controller_buttons_signal,
									   sunil_buttons => sunil_controller_buttons_signal,
									   rgb => colors_from_pattern_gen,
									   start_screen => start_screen,
									   sunil_win => sunil_win,
									   tony_win => tony_win
									   );

	-- Game logic
	game : game_logic port map(
							 clk => internal60hzclk,
							 reset_players => reset_players,
							 tony_controller_buttons => tony_controller_buttons_signal,
							 tony_x => tony_xpos,
							 tony_y => tony_ypos,
							 tony_punching => tony_punching,
							 sunil_controller_buttons => sunil_controller_buttons_signal,
							 sunil_x => sunil_xpos,
							 sunil_y => sunil_ypos,
							 sunil_punching => sunil_punching
							 );
	meta_state : game_state port map (
								     clk => internal60hzclk,
									 sunil_reset => sunil_controller_buttons_signal(4),
									 tony_reset => tony_controller_buttons_signal(4),
									  
									 tony_x => tony_xpos,
									 tony_y => tony_ypos,
									 sunil_x => sunil_xpos,
									 sunil_y => sunil_ypos,
									  
									 start_screen => start_screen,
									 sunil_win => sunil_win,
									 tony_win => tony_win,
									 
									 reset_players => reset_players
									 
									 );
	
	
	-- Controller Inputs
	tony_controller : controller port map(
                                    input_clk => internal25clk,
									latch => tony_controller_latch,
									clock => tony_controller_clock,
									data => tony_controller_in,
									output => tony_controller_buttons_signal
									);
									
	sunil_controller : controller port map(
                                    input_clk => internal25clk,
									latch => sunil_controller_latch,
									clock => sunil_controller_clock,
									data => sunil_controller_in,
									output => sunil_controller_buttons_signal
									);
	
	-- Buffer outputs 1 pixel to avoid sampling pixels between clock cycles
	process (internal25clk) begin
		if rising_edge(internal25clk) then
			RGB <= colors_from_pattern_gen;
			HSYNC <= hsync_from_vga;
			VSYNC <= vsync_from_vga;
		end if;
	end process;
end;


