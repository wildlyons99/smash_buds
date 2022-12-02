library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity vga is
  port(
	  clk : in std_logic;
	  HSYNC : out std_logic;
	  VSYNC : out std_logic;
	  row : out unsigned(9 downto 0); -- 0-1023
	  col : out unsigned(9 downto 0); -- 0-1023
	  valid : out std_logic
      );
end vga;

architecture synth of vga is

begin
   process (clk) begin
	if rising_edge(clk) then
		-- Row logic, counts 0-799 (800 total rows), then resets & increments col
		if (col = 10d"799") then
			col <= 10d"0";
			row <= row + 1;
		else
			col <= col + 1;
		end if;
		-- Col logic, counts 0-524 (525 total cols), then resets
		if (row = 10d"524") then
			row <= 10d"0";
		end if;
	end if;
   end process;
   -- HORIZONTAL: Visible from 0-639 pixels. Front porch 640-655 pixels. HSYNC 656-751 pixels. Back porch 752-799
   -- HSYNC is low during the sync time, otherwise high
   HSYNC <= '0' when ((col >=656) and (col <=751)) else '1';
   -- VERTICAL: Visible during 0-479 rows. Then front porch 480-489 rows. Then VSYNC 490-491 rows. Then back porch 492-524 rows.
   -- VSYNC is low during sync time
   VSYNC <= '0' when ((row >=490) and (row <= 491)) else '1';
   valid <= '1' when ((col <= 639) and (row <= 479)) else '0';
end;


