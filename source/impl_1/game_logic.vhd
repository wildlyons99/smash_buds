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
	
	signal col_l : std_logic;
	signal col_r : std_logic;
	signal col_t : std_logic;
	signal col_b : std_logic;
	signal y_plat : signed(10 downto 0);
	
	signal x_gl : signed(10 downto 0);
	signal y_gl : signed(10 downto 0);
	signal yv_gl : signed(3 downto 0);
	
	component collisions is 
	port (
		coll_left : out std_logic;
		coll_right : out std_logic;
		coll_top : out std_logic;
		coll_bottom : out std_logic;
		y_platform : out signed(10 downto 0);
		
		buttons : in std_logic_vector(7 downto 0);
		
		x : in signed(10 downto 0);
		y : in signed(10 downto 0);
		yv : in signed(3 downto 0)
	);
end component; 

component physics is 
	port (
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
end component; 

	
begin

	col_map : collisions port map(
									coll_left => col_l, 
									coll_right => col_r, 
									coll_top => col_t, 
									coll_bottom => col_b,
									y_platform => y_plat,
									buttons => controller_buttons,
									x => x_gl,
									y => y_gl,
									yv => yv_gl
								);
	
	phys_map : physics port map(
									coll_left => col_l, 
									coll_right => col_r, 
									coll_top => col_t, 
									coll_bottom => col_b,
									y_platform => y_plat,
									buttons => controller_buttons,
									x => x_gl,
									y => y_gl,
									yv => yv_gl
								);
	
	


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
				y <= y - yVelocity;
			end if;
			
			if (yVelocity = 4d"0") then
				if(controller_buttons(7)) then 
					yVelocity <= 4d"5";
				end if;
			else 
				yVelocity <= yVelocity - gravity;
			end if;
			
			
		end if;
		
	end if;
   end process;
end;


