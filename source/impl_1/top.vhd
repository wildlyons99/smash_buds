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
	  tony_controller_clock : out std_logic
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
	  
	  -- Sunil
	  sunil_x : in signed(10 downto 0);
	  sunil_y : in signed(10 downto 0);
	  sunil_buttons : in std_logic_vector(7 downto 0);
	  
	  -- Which game state we're in
	  start_screen, tony_win, sunil_win : std_logic;
	  
	  -- Output
	  rgb : out std_logic_vector(5 downto 0)
      );
	end component;

	component game_logic is
	  port(
		  clk : in std_logic; 
		  tony_controller_buttons : in std_logic_vector(7 downto 0);
		  tony_x : out signed(10 downto 0); 
		  tony_y : out signed(10 downto 0)
		  );
	end component;

	signal internal25clk : std_logic;
	signal internalrow : signed(10 downto 0);
	signal internalcol : signed(10 downto 0);
	signal internalvalid : std_logic;
	signal tony_controller_buttons_signal : std_logic_vector(7 downto 0);
	signal internal60hzclk : std_logic;
	signal tony_xpos : signed(10 downto 0);
	signal tony_ypos : signed(10 downto 0);
	-- Synchronize outputs
	signal colors_from_pattern_gen : std_logic_vector(5 downto 0);
	signal hsync_from_vga, vsync_from_vga : std_logic;
begin
   controller1 : controller port map(
                                    input_clk => internal25clk,
									latch => tony_controller_latch,
									clock => tony_controller_clock,
									data => tony_controller_in,
									output => tony_controller_buttons_signal
									);
   sixtyHZclock : pllclock_to_60_hz port map(internal25clk, internal60hzclk);
   
   pll : my_pll port map(
					     ref_clk_i => ext12m,
						 rst_n_i => '1',
						 outglobal_o => internal25clk
						 );
   internalvga : vga port map(internal25clk, hsync_from_vga, vsync_from_vga, internalrow, internalcol, internalvalid);
   patternmaker : pattern_gen port map (
									   clk => internal25clk,
									   row => internalrow,
									   col => internalcol,
									   tony_x => tony_xpos,
									   tony_y => tony_ypos,
									   valid => internalvalid,
									   tony_buttons => tony_controller_buttons_signal,
									   rgb => colors_from_pattern_gen
									   );


	game : game_logic port map(
							 clk => internal60hzclk,
							 tony_controller_buttons => tony_controller_buttons_signal,
							 tony_x => tony_xpos,
							 tony_y => tony_ypos
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


