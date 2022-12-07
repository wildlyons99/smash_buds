library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity game_logic is
  port(
	  clk : in std_logic; 
	  tony_controller_buttons : in std_logic_vector(7 downto 0);
	  tony_x : out signed(10 downto 0); 
	  tony_y : out signed(10 downto 0)
      );
end game_logic;

architecture synth of game_logic is
	
	component player is
	generic (
		reset_x : signed(10 downto 0) := 11d"0";
		reset_y : signed(10 downto 0) := 11d"0"
    );
	port(
	  clk : in std_logic; 
	  controller_buttons : in std_logic_vector(7 downto 0);
	  x : out signed(10 downto 0); 
	  y : out signed(10 downto 0)
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
		controller_buttons => tony_controller_buttons,
		x => tony_x,
		y => tony_y
	);

end;


