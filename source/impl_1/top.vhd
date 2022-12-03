library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top is
  port(
	  ext12m : in std_logic;
	  HSYNC : out std_logic;
	  VSYNC : out std_logic;
	  up : out std_logic;
	  RGB : out std_logic_vector(5 downto 0);
	  testPLLout : out std_logic;
	
	  controller_in : in std_logic;
	  controller_latch : out std_logic;
	  controller_clock : out std_logic
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
		  clk60hz : in std_logic;
		  row : in signed(10 downto 0); -- 0-1023
		  col : in signed(10 downto 0); -- 0-1023
		  x : in signed(10 downto 0);
		  y : in signed(10 downto 0);
		  valid : in std_logic;
		  rgb : out std_logic_vector(5 downto 0)
		);
    end component;

	component game_logic is
	  port(
		  clk : in std_logic; 
		  controller_buttons : in std_logic_vector(7 downto 0);
		  x : out signed(10 downto 0); 
		  y : out signed(10 downto 0)
		  );
	end component;

	signal internal25clk : std_logic;
	signal internalrow : signed(10 downto 0);
	signal internalcol : signed(10 downto 0);
	signal internalvalid : std_logic;
	signal controller_buttons_signal : std_logic_vector(7 downto 0);
	signal internal60hzclk : std_logic;
	signal xpos : signed(10 downto 0);
	signal ypos : signed(10 downto 0);
begin
   controller1 : controller port map(
                                    latch => controller_latch,
									clock => controller_clock,
									data => controller_in,
									output => controller_buttons_signal
									);
   sixtyHZclock : pllclock_to_60_hz port map(internal25clk, internal60hzclk);
   pll : my_pll port map(ext12m, '1', testPLLout, internal25clk);
   internalvga : vga port map(internal25clk, HSYNC, VSYNC, internalrow, internalcol, internalvalid);
   patternmaker : pattern_gen port map (
									   clk => internal25clk,
									   clk60hz => internal60hzclk,
									   row => internalrow,
									   col => internalcol,
									   x => xpos,
									   y => ypos,
									   valid => internalvalid,
									   rgb => RGB
									   );


	game : game_logic port map(
							 clk => internal60hzclk,
							 controller_buttons => controller_buttons_signal,
							 x => xpos,
							 y => ypos
							 );
									   
	up <= controller_buttons_signal(3);
end;


