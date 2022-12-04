library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pllclock_to_60_hz is
  port(
	  clk_in : in std_logic;
	  clk_out : out std_logic
      );
end pllclock_to_60_hz;

architecture synth of pllclock_to_60_hz is
	signal clock_count : unsigned(18 downto 0);
	signal first_time : std_logic;
begin
	process (clk_in) begin
		if rising_edge(clk_in) then
			if (first_time) then
				clock_count <= 19b"0";
			else
				if (clock_count = 385000) then
					clock_count <= 19b"0";
				else
					clock_count <= clock_count + 1;
				end if;
			end if;
		end if;
	end process;
	clk_out <= '1' when (clock_count = 385000) else '0';
end;