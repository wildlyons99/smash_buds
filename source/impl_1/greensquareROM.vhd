library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity greensquareROM is
  port(
	  clk : in std_logic; 
	  x : in unsigned(1 downto 0);
	  y : in unsigned(1 downto 0);
	  rgb : out std_logic_vector(5 downto 0)
      );
end greensquareROM;

architecture synth of greensquareROM is

signal addr : std_logic_vector(3 downto 0);

begin

	addr <= std_logic_vector(y) & std_logic_vector(x);

	process(clk)
		begin
			if rising_edge(clk) then
				case addr is
					when "0000" => rgb <= "111111";
					when "0001" => rgb <= "001100";
					when "0010" => rgb <= "111111";
					when "0100" => rgb <= "001100";
					when "0101" => rgb <= "001100";
					when "0110" => rgb <= "001100";
					when "1000" => rgb <= "111111";
					when "1001" => rgb <= "001100";
					when "1010" => rgb <= "111111";
					when others => rgb <= "111111";
				end case;
			end if;
		end process;
end;


