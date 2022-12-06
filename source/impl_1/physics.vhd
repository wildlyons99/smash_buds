library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity physics is
      generic (
			 --TODO: generalize terminal velocities
			 gravity    : signed(2 downto 0) := 3d"1";
			 friction   : signed(2 downto 0) := 3d"1";
			 accel      : signed(2 downto 0) := 3d"1"
	  );
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
      signal yVelocity  : signed(4 downto 0);
      signal xVelocity  : signed(3 downto 0);
      signal reset        : std_logic;
      signal left_pressed : std_logic;
      signal right_pressed : std_logic;
      signal jump_pressed : std_logic;
      --signal physClk  : unsigned() -- hypothetically slow down accelerations?
	 signal at_maxspd_left : std_logic;
	 signal at_maxspd_right : std_logic;

begin
      reset <= buttons(4);
      right_pressed <= buttons(0);
      left_pressed <= buttons(1);
      jump_pressed <= buttons(7);

	 at_maxspd_left <= '0' when (xVelocity > 4b"1010") else '1';
	 at_maxspd_right <= '0' when (xVelocity < 4d"6") else '1';
	 
      process (clk) begin
      if rising_edge(clk) then
            if ((not first_time) or reset) then
                  x <= 11d"200";
                  y <= 11d"200";
                  first_time <= '1';   
                  yVelocity <= 5d"0";
                  xVelocity <= 4d"0";
            else

                  --horizontal movement
                  if (left_pressed and not coll_right and not at_maxspd_left) then
                        xVelocity <= xVelocity - accel;
                  elsif (right_pressed and not coll_left and not at_maxspd_right) then
                        xVelocity <= xVelocity + accel;
                  elsif (xVelocity /= 0) then
                        xVelocity <= xVelocity + friction when xVelocity(xVelocity'left) else
                                           xVelocity - friction;
                  end if;
                  x <= (x + xVelocity) mod 639;
                  
                  --vertical movement
                  if (coll_top and not jump_pressed) then
                        yVelocity <= 5d"0";
                        y <= y_platform;
                  else
                        if(coll_top and jump_pressed) then
                              yVelocity <= 5b"10110";                      
                        elsif (coll_bottom) then
                              yVelocity <= -1 * yVelocity; 
                        elsif (yVelocity < 5d"8") then
                              yVelocity <= yVelocity + gravity;
                        end if;
                        y <= (y + yVelocity) mod 479;
                  end if;
            end if;
      end if;
   end process;

end;