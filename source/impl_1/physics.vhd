library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity physics is 
	port (
		clk : in std_logic; 
		coll_left : in std_logic;
		coll_right : in std_logic;
		coll_top : in std_logic;
		coll_bottom : in std_logic;
		y_platform : in signed(10 downto 0);
		buttons : in std_logic_vector(7 downto 0);
		
		x : out signed(10 downto 0);
		y : out signed(10 downto 0);
		yv : out signed(3 downto 0)
	);
end physics; 

architecture synth of physics is 
	signal first_time : std_logic;
	signal yVelocity  : signed(3 downto 0);
	signal gravity    : signed(1 downto 0);
	

begin
	process (clk) begin
	if rising_edge(clk) then
		if ((not first_time) or buttons(4)) then
			x <= 11b"0";
			y <= 11b"0";
			first_time <= '1';
			gravity <= 2d"1";
			yVelocity <= 4d"0";
		else
		 	if (buttons(1)) then
		 		if (x = 0) then
					x <= 11d"639";
				else
					x <= (x - 1);
				end if;
			elsif (buttons(0)) then
				x <= (x + 1) mod 639;
			else
				-- do nothing
			end if;
			
			if (buttons(2)) then
				y <= (y + 1) mod 479;
			elsif (buttons(3)) then
				if (y = 0) then
					y <= 11d"479";
				else
					y <= (y - 1);
				end if;
			else
				y <= y - yVelocity;
			end if;
			
			if (yVelocity = 4d"0") then
				if(buttons(7)) then 
					yVelocity <= 4d"5";
				end if;
			else 
				yVelocity <= yVelocity - gravity;
			end if;
	
		end if;
		
	end if;
   end process;

end;