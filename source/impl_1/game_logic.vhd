library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity game_logic is
  port(
	  clk : in std_logic; 
	  controller_buttons : in std_logic_vector(7 downto 0);
	  x : out unsigned(9 downto 0); 
	  y : out unsigned(9 downto 0)
      );
end game_logic;

architecture synth of game_logic is
	signal first_time : std_logic;
begin
   process (clk) begin
	if rising_edge(clk) then
		if ((not first_time) or controller_buttons(4)) then
			x <= 10b"0";
			y <= 10b"0";
			first_time <= '1';
		else
			if (controller_buttons(1)) then
				if (x = 0) then
					x <= 10d"639";
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
					y <= 10d"479";
				else
					y <= (y - 1);
				end if;
			else
				-- do nothing
			end if;
			
		end if;
	end if;
   end process;
end;


