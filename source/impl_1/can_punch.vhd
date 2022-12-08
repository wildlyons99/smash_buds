library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity can_punch is
  port(
	  clk : in std_logic;
	  punch_button : in std_logic;
	  moving_left, moving_right : in std_logic;
	  is_punching : out std_logic
      );
end can_punch;

architecture synth of can_punch is
	signal punch_cooldown_frame_count : unsigned(5 downto 0);
begin
	process (clk) begin
		if rising_edge(clk) then
			if (punch_cooldown_frame_count = 0) then
				if (punch_button and (moving_left or moving_right)) then
					is_punching <= '1';
					punch_cooldown_frame_count <= 6d"40";
				end if;
			else 
				is_punching <= '0';
				punch_cooldown_frame_count <= punch_cooldown_frame_count - 1;
			end if;
		end if;
	end process;
	--is_punching <= punch_button;
end;


