library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity physics is
      generic (
			 --TODO: generalize terminal velocities
			 gravity    : signed(2 downto 0) := 3d"1";
			 friction   : signed(2 downto 0) := 3d"1";
			 accel      : signed(2 downto 0) := 3d"1";
			 reset_x : signed(10 downto 0) := 11d"0";
			 reset_y : signed(10 downto 0) := 11d"0"
	  );
	  port (
            clk : in std_logic;
			
			reset_players : in std_logic;
			
            --coll_left : in std_logic;
            --coll_right : in std_logic;
            coll_top : in std_logic;
            --coll_bottom : in std_logic;
			
			was_punched_from_left : in std_logic;
			was_punched_from_right : in std_logic;
			
            y_platform : in signed(10 downto 0);
            buttons : in std_logic_vector(7 downto 0);
            
            x : out signed(10 downto 0);
            y : out signed(10 downto 0);
            yv : out signed(4 downto 0)
      );
end physics;

architecture synth of physics is
      signal yVelocity  : signed(4 downto 0);
      signal xVelocity  : signed(5 downto 0);
      signal reset        : std_logic;
      signal left_pressed : std_logic;
      signal right_pressed : std_logic;
      signal jump_pressed : std_logic;
	  signal down_pressed : std_logic;
      --signal physClk  : unsigned() -- hypothetically slow down accelerations?
	 signal at_maxspd_left : std_logic;
	 signal at_maxspd_right : std_logic;
	 signal falling : std_logic;

begin
      reset <= buttons(4);
      right_pressed <= buttons(0);
      left_pressed <= buttons(1);
      jump_pressed <= buttons(7);
	  down_pressed <= buttons(2);

	 at_maxspd_left <= '0' when (xVelocity > 6b"111100") else '1';
	 at_maxspd_right <= '0' when (xVelocity < 6d"4") else '1';
	 falling <= '1' when yVelocity >= 0 else '0';
	 
      process (clk) begin
      if rising_edge(clk) then
            if (reset_players) then
                  x <= reset_x;
                  y <= reset_y;
                  yVelocity <= 5d"0";
                  xVelocity <= 6d"0";
            else
				  --Punch
				  if (was_punched_from_left) then
					xVelocity <= 6d"16";
				  elsif (was_punched_from_right) then
					xVelocity <= 6b"110000";
                  --horizontal movement
                  elsif (left_pressed and not at_maxspd_left) then
                        xVelocity <= xVelocity - accel;
                  elsif (right_pressed and not at_maxspd_right) then
                        xVelocity <= xVelocity + accel;
                  elsif (xVelocity /= 0) then
                        xVelocity <= xVelocity + friction when xVelocity(xVelocity'left) else
                                           xVelocity - friction;							
                  end if;
                  x <= (x + xVelocity) mod 639;
                  
                  --vertical movement
				  if(was_punched_from_right or was_punched_from_left) then
						yVelocity <= 5b"10111";
						y <= y - 2;
                  elsif (coll_top) then
					if(jump_pressed and falling) then
						yVelocity <= 5b"10010";	
						y <= y_platform - 2;
					else
                        if (falling and not down_pressed) then
							yVelocity <= 5d"0";
							y <= y_platform;
						elsif (down_pressed and falling) then
							if (y < 360) then
								y <= y_platform + 10;
							else y <= y_platform;
							end if;
						else
							yVelocity <= yVelocity + gravity;
							y <= (y + yVelocity) mod 479;
						end if; 
					end if;
                  else
					  if (yVelocity < 5d"9") then
							yVelocity <= yVelocity + gravity;
					  end if;				  
                  y <= (y + yVelocity) mod 479;
                  end if;
            end if;
		end if;
   end process;
	yv <= yVelocity;
end;