library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity game_logic is
  port(
	  clk : in std_logic; 
	  controller_buttons : in std_logic_vector(7 downto 0);
	  x : out signed(10 downto 0); 
	  y : out signed(10 downto 0)
      );
end game_logic;

architecture synth of game_logic is
	signal first_time : std_logic;
	signal yVelocity  : signed(3 downto 0);
	signal gravity    : signed(1 downto 0);
begin
   process (clk) begin
	if rising_edge(clk) then
		if ((not first_time) or controller_buttons(4)) then
			x <= 11b"0";
			y <= 11b"0";
			first_time <= '1';
			gravity <= 2d"1";
			yVelocity <= 4d"0";
		else
		 	if (controller_buttons(1)) then
		 		if (x = 0) then
					x <= 11d"639";
				else
					x <= (x - 1);
				end if;
			elsif (controller_buttons(0)) then
				x <= (x + 1) mod 639;
			else
				-- do nothing
			end if;
			
			if (controller_buttons(2)) then
				y <= (y + 1) mod 479;
			elsif (controller_buttons(3)) then
				if (y = 0) then
					y <= 11d"479";
				else
					y <= (y - 1);
				end if;
			else
				-- do nothing
			end if;
			
			if (yVelocity = 4d"0") then
				if(controller_buttons(7)) then 
					yVelocity <= 4d"5";
				end if;
			else 
				yVelocity <= yVelocity - gravity;
			end if;
			
			y <= y - yVelocity;
		end if;
		
	end if;
   end process;
end;


