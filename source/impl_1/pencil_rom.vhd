library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Pencil is 39x 14y

entity pencil_rom is
  port(
	  clk : in std_logic;
	  xadr: in unsigned(5 downto 0);
	  yadr : in unsigned(3 downto 0); 
	  rgb : out std_logic_vector(5 downto 0)
      );
end pencil_rom;

architecture synth of pencil_rom is
signal totaladr : std_logic_vector(9 downto 0);
begin
   process (clk) begin
	if rising_edge(clk) then
		case totaladr is
					when "0000000000" => rgb <= "110110";
					when "0000000001" => rgb <= "110110";
					when "0000000010" => rgb <= "110010";
					when "0000000011" => rgb <= "110010";
					when "0000000100" => rgb <= "110010";
					when "0000000101" => rgb <= "110010";
					when "0000000110" => rgb <= "110010";
					when "0000000111" => rgb <= "101010";
					when "0000001000" => rgb <= "101010";
					when "0000001001" => rgb <= "010101";
					when "0000001010" => rgb <= "010101";
					when "0000001011" => rgb <= "101010";
					when "0000001100" => rgb <= "101010";
					when "0000001101" => rgb <= "111000";
					when "0000001110" => rgb <= "111000";
					when "0000001111" => rgb <= "111000";
					when "0000010000" => rgb <= "111000";
					when "0000010001" => rgb <= "111000";
					when "0000010010" => rgb <= "111000";
					when "0000010011" => rgb <= "111000";
					when "0000010100" => rgb <= "111000";
					when "0000010101" => rgb <= "111000";
					when "0000010110" => rgb <= "111000";
					when "0000010111" => rgb <= "111000";
					when "0000011000" => rgb <= "111000";
					when "0000011001" => rgb <= "111000";
					when "0000011010" => rgb <= "111000";
					when "0000011011" => rgb <= "111000";
					when "0000011100" => rgb <= "111000";
					when "0000011101" => rgb <= "111000";
					when "0000011110" => rgb <= "111000";
					when "0000011111" => rgb <= "111000";
					when "0000100000" => rgb <= "111000";
					when "0000100001" => rgb <= "110110";
					when "0000100010" => rgb <= "110110";
					when "0000100011" => rgb <= "110110";
					when "0000100100" => rgb <= "110110";
					when "0000100101" => rgb <= "110110";
					when "0000100110" => rgb <= "110110";
					when "0001000000" => rgb <= "110110";
					when "0001000001" => rgb <= "110010";
					when "0001000010" => rgb <= "110010";
					when "0001000011" => rgb <= "110010";
					when "0001000100" => rgb <= "110010";
					when "0001000101" => rgb <= "110010";
					when "0001000110" => rgb <= "110010";
					when "0001000111" => rgb <= "101010";
					when "0001001000" => rgb <= "101010";
					when "0001001001" => rgb <= "010101";
					when "0001001010" => rgb <= "010101";
					when "0001001011" => rgb <= "101010";
					when "0001001100" => rgb <= "101010";
					when "0001001101" => rgb <= "111110";
					when "0001001110" => rgb <= "111110";
					when "0001001111" => rgb <= "111110";
					when "0001010000" => rgb <= "111110";
					when "0001010001" => rgb <= "111110";
					when "0001010010" => rgb <= "111110";
					when "0001010011" => rgb <= "111110";
					when "0001010100" => rgb <= "111110";
					when "0001010101" => rgb <= "111110";
					when "0001010110" => rgb <= "111110";
					when "0001010111" => rgb <= "111110";
					when "0001011000" => rgb <= "111110";
					when "0001011001" => rgb <= "111110";
					when "0001011010" => rgb <= "111110";
					when "0001011011" => rgb <= "111110";
					when "0001011100" => rgb <= "111110";
					when "0001011101" => rgb <= "111110";
					when "0001011110" => rgb <= "111110";
					when "0001011111" => rgb <= "111110";
					when "0001100000" => rgb <= "111110";
					when "0001100001" => rgb <= "111110";
					when "0001100010" => rgb <= "110110";
					when "0001100011" => rgb <= "110110";
					when "0001100100" => rgb <= "110110";
					when "0001100101" => rgb <= "110110";
					when "0001100110" => rgb <= "110110";
					when "0010000000" => rgb <= "110010";
					when "0010000001" => rgb <= "110010";
					when "0010000010" => rgb <= "110010";
					when "0010000011" => rgb <= "110010";
					when "0010000100" => rgb <= "110010";
					when "0010000101" => rgb <= "110010";
					when "0010000110" => rgb <= "110010";
					when "0010000111" => rgb <= "101010";
					when "0010001000" => rgb <= "101010";
					when "0010001001" => rgb <= "010101";
					when "0010001010" => rgb <= "010101";
					when "0010001011" => rgb <= "101010";
					when "0010001100" => rgb <= "101010";
					when "0010001101" => rgb <= "111110";
					when "0010001110" => rgb <= "111110";
					when "0010001111" => rgb <= "111110";
					when "0010010000" => rgb <= "111110";
					when "0010010001" => rgb <= "111110";
					when "0010010010" => rgb <= "111110";
					when "0010010011" => rgb <= "111110";
					when "0010010100" => rgb <= "111110";
					when "0010010101" => rgb <= "111110";
					when "0010010110" => rgb <= "111110";
					when "0010010111" => rgb <= "111110";
					when "0010011000" => rgb <= "111110";
					when "0010011001" => rgb <= "111110";
					when "0010011010" => rgb <= "111110";
					when "0010011011" => rgb <= "111110";
					when "0010011100" => rgb <= "111110";
					when "0010011101" => rgb <= "111110";
					when "0010011110" => rgb <= "111110";
					when "0010011111" => rgb <= "111110";
					when "0010100000" => rgb <= "111110";
					when "0010100001" => rgb <= "111110";
					when "0010100010" => rgb <= "111110";
					when "0010100011" => rgb <= "110110";
					when "0010100100" => rgb <= "110110";
					when "0010100101" => rgb <= "110110";
					when "0010100110" => rgb <= "110110";
					when "0011000000" => rgb <= "110010";
					when "0011000001" => rgb <= "110010";
					when "0011000010" => rgb <= "110010";
					when "0011000011" => rgb <= "110010";
					when "0011000100" => rgb <= "110010";
					when "0011000101" => rgb <= "110010";
					when "0011000110" => rgb <= "110010";
					when "0011000111" => rgb <= "101010";
					when "0011001000" => rgb <= "101010";
					when "0011001001" => rgb <= "010101";
					when "0011001010" => rgb <= "010101";
					when "0011001011" => rgb <= "101010";
					when "0011001100" => rgb <= "101010";
					when "0011001101" => rgb <= "111000";
					when "0011001110" => rgb <= "111000";
					when "0011001111" => rgb <= "111000";
					when "0011010000" => rgb <= "111000";
					when "0011010001" => rgb <= "111000";
					when "0011010010" => rgb <= "111000";
					when "0011010011" => rgb <= "111000";
					when "0011010100" => rgb <= "111000";
					when "0011010101" => rgb <= "111000";
					when "0011010110" => rgb <= "111000";
					when "0011010111" => rgb <= "111000";
					when "0011011000" => rgb <= "111000";
					when "0011011001" => rgb <= "111000";
					when "0011011010" => rgb <= "111000";
					when "0011011011" => rgb <= "111000";
					when "0011011100" => rgb <= "111000";
					when "0011011101" => rgb <= "111000";
					when "0011011110" => rgb <= "111000";
					when "0011011111" => rgb <= "111000";
					when "0011100000" => rgb <= "111000";
					when "0011100001" => rgb <= "111000";
					when "0011100010" => rgb <= "111110";
					when "0011100011" => rgb <= "110110";
					when "0011100100" => rgb <= "110110";
					when "0011100101" => rgb <= "110110";
					when "0011100110" => rgb <= "110110";
					when "0100000000" => rgb <= "110010";
					when "0100000001" => rgb <= "110010";
					when "0100000010" => rgb <= "110010";
					when "0100000011" => rgb <= "110010";
					when "0100000100" => rgb <= "110010";
					when "0100000101" => rgb <= "110010";
					when "0100000110" => rgb <= "110010";
					when "0100000111" => rgb <= "101010";
					when "0100001000" => rgb <= "101010";
					when "0100001001" => rgb <= "010101";
					when "0100001010" => rgb <= "010101";
					when "0100001011" => rgb <= "101010";
					when "0100001100" => rgb <= "101010";
					when "0100001101" => rgb <= "111110";
					when "0100001110" => rgb <= "111110";
					when "0100001111" => rgb <= "111110";
					when "0100010000" => rgb <= "111110";
					when "0100010001" => rgb <= "111110";
					when "0100010010" => rgb <= "111110";
					when "0100010011" => rgb <= "111110";
					when "0100010100" => rgb <= "111110";
					when "0100010101" => rgb <= "111110";
					when "0100010110" => rgb <= "111110";
					when "0100010111" => rgb <= "111110";
					when "0100011000" => rgb <= "111110";
					when "0100011001" => rgb <= "111110";
					when "0100011010" => rgb <= "111110";
					when "0100011011" => rgb <= "111110";
					when "0100011100" => rgb <= "111110";
					when "0100011101" => rgb <= "111110";
					when "0100011110" => rgb <= "111110";
					when "0100011111" => rgb <= "111110";
					when "0100100000" => rgb <= "111110";
					when "0100100001" => rgb <= "111110";
					when "0100100010" => rgb <= "111110";
					when "0100100011" => rgb <= "111110";
					when "0100100100" => rgb <= "000000";
					when "0100100101" => rgb <= "110110";
					when "0100100110" => rgb <= "110110";
					when "0101000000" => rgb <= "110010";
					when "0101000001" => rgb <= "110010";
					when "0101000010" => rgb <= "110010";
					when "0101000011" => rgb <= "110010";
					when "0101000100" => rgb <= "110010";
					when "0101000101" => rgb <= "110010";
					when "0101000110" => rgb <= "110010";
					when "0101000111" => rgb <= "101010";
					when "0101001000" => rgb <= "101010";
					when "0101001001" => rgb <= "010101";
					when "0101001010" => rgb <= "010101";
					when "0101001011" => rgb <= "101010";
					when "0101001100" => rgb <= "101010";
					when "0101001101" => rgb <= "111110";
					when "0101001110" => rgb <= "111110";
					when "0101001111" => rgb <= "111110";
					when "0101010000" => rgb <= "111110";
					when "0101010001" => rgb <= "111110";
					when "0101010010" => rgb <= "111110";
					when "0101010011" => rgb <= "111110";
					when "0101010100" => rgb <= "111110";
					when "0101010101" => rgb <= "111110";
					when "0101010110" => rgb <= "111110";
					when "0101010111" => rgb <= "111110";
					when "0101011000" => rgb <= "111110";
					when "0101011001" => rgb <= "111110";
					when "0101011010" => rgb <= "111110";
					when "0101011011" => rgb <= "111110";
					when "0101011100" => rgb <= "111110";
					when "0101011101" => rgb <= "111110";
					when "0101011110" => rgb <= "111110";
					when "0101011111" => rgb <= "111110";
					when "0101100000" => rgb <= "111110";
					when "0101100001" => rgb <= "111110";
					when "0101100010" => rgb <= "111110";
					when "0101100011" => rgb <= "111110";
					when "0101100100" => rgb <= "000000";
					when "0101100101" => rgb <= "000000";
					when "0101100110" => rgb <= "110110";
					when "0110000000" => rgb <= "110010";
					when "0110000001" => rgb <= "110010";
					when "0110000010" => rgb <= "110010";
					when "0110000011" => rgb <= "110010";
					when "0110000100" => rgb <= "110010";
					when "0110000101" => rgb <= "110010";
					when "0110000110" => rgb <= "110010";
					when "0110000111" => rgb <= "101010";
					when "0110001000" => rgb <= "101010";
					when "0110001001" => rgb <= "010101";
					when "0110001010" => rgb <= "010101";
					when "0110001011" => rgb <= "101010";
					when "0110001100" => rgb <= "101010";
					when "0110001101" => rgb <= "111000";
					when "0110001110" => rgb <= "111000";
					when "0110001111" => rgb <= "111000";
					when "0110010000" => rgb <= "111000";
					when "0110010001" => rgb <= "111000";
					when "0110010010" => rgb <= "111000";
					when "0110010011" => rgb <= "111000";
					when "0110010100" => rgb <= "111000";
					when "0110010101" => rgb <= "111000";
					when "0110010110" => rgb <= "111000";
					when "0110010111" => rgb <= "111000";
					when "0110011000" => rgb <= "111000";
					when "0110011001" => rgb <= "111000";
					when "0110011010" => rgb <= "111000";
					when "0110011011" => rgb <= "111000";
					when "0110011100" => rgb <= "111000";
					when "0110011101" => rgb <= "111000";
					when "0110011110" => rgb <= "111000";
					when "0110011111" => rgb <= "111000";
					when "0110100000" => rgb <= "111000";
					when "0110100001" => rgb <= "111000";
					when "0110100010" => rgb <= "111110";
					when "0110100011" => rgb <= "111110";
					when "0110100100" => rgb <= "000000";
					when "0110100101" => rgb <= "000000";
					when "0110100110" => rgb <= "000000";
					when "0111000000" => rgb <= "110010";
					when "0111000001" => rgb <= "110010";
					when "0111000010" => rgb <= "110010";
					when "0111000011" => rgb <= "110010";
					when "0111000100" => rgb <= "110010";
					when "0111000101" => rgb <= "110010";
					when "0111000110" => rgb <= "110010";
					when "0111000111" => rgb <= "101010";
					when "0111001000" => rgb <= "101010";
					when "0111001001" => rgb <= "010101";
					when "0111001010" => rgb <= "010101";
					when "0111001011" => rgb <= "101010";
					when "0111001100" => rgb <= "101010";
					when "0111001101" => rgb <= "111110";
					when "0111001110" => rgb <= "111110";
					when "0111001111" => rgb <= "111110";
					when "0111010000" => rgb <= "111110";
					when "0111010001" => rgb <= "111110";
					when "0111010010" => rgb <= "111110";
					when "0111010011" => rgb <= "111110";
					when "0111010100" => rgb <= "111110";
					when "0111010101" => rgb <= "111110";
					when "0111010110" => rgb <= "111110";
					when "0111010111" => rgb <= "111110";
					when "0111011000" => rgb <= "111110";
					when "0111011001" => rgb <= "111110";
					when "0111011010" => rgb <= "111110";
					when "0111011011" => rgb <= "111110";
					when "0111011100" => rgb <= "111110";
					when "0111011101" => rgb <= "111110";
					when "0111011110" => rgb <= "111110";
					when "0111011111" => rgb <= "111110";
					when "0111100000" => rgb <= "111110";
					when "0111100001" => rgb <= "111110";
					when "0111100010" => rgb <= "111110";
					when "0111100011" => rgb <= "111110";
					when "0111100100" => rgb <= "000000";
					when "0111100101" => rgb <= "000000";
					when "0111100110" => rgb <= "000000";
					when "1000000000" => rgb <= "110010";
					when "1000000001" => rgb <= "110010";
					when "1000000010" => rgb <= "110010";
					when "1000000011" => rgb <= "110010";
					when "1000000100" => rgb <= "110010";
					when "1000000101" => rgb <= "110010";
					when "1000000110" => rgb <= "110010";
					when "1000000111" => rgb <= "101010";
					when "1000001000" => rgb <= "101010";
					when "1000001001" => rgb <= "010101";
					when "1000001010" => rgb <= "010101";
					when "1000001011" => rgb <= "101010";
					when "1000001100" => rgb <= "101010";
					when "1000001101" => rgb <= "111110";
					when "1000001110" => rgb <= "111110";
					when "1000001111" => rgb <= "111110";
					when "1000010000" => rgb <= "111110";
					when "1000010001" => rgb <= "111110";
					when "1000010010" => rgb <= "111110";
					when "1000010011" => rgb <= "111110";
					when "1000010100" => rgb <= "111110";
					when "1000010101" => rgb <= "111110";
					when "1000010110" => rgb <= "111110";
					when "1000010111" => rgb <= "111110";
					when "1000011000" => rgb <= "111110";
					when "1000011001" => rgb <= "111110";
					when "1000011010" => rgb <= "111110";
					when "1000011011" => rgb <= "111110";
					when "1000011100" => rgb <= "111110";
					when "1000011101" => rgb <= "111110";
					when "1000011110" => rgb <= "111110";
					when "1000011111" => rgb <= "111110";
					when "1000100000" => rgb <= "111110";
					when "1000100001" => rgb <= "111110";
					when "1000100010" => rgb <= "111110";
					when "1000100011" => rgb <= "111110";
					when "1000100100" => rgb <= "000000";
					when "1000100101" => rgb <= "000000";
					when "1000100110" => rgb <= "110110";
					when "1001000000" => rgb <= "110010";
					when "1001000001" => rgb <= "110010";
					when "1001000010" => rgb <= "110010";
					when "1001000011" => rgb <= "110010";
					when "1001000100" => rgb <= "110010";
					when "1001000101" => rgb <= "110010";
					when "1001000110" => rgb <= "110010";
					when "1001000111" => rgb <= "101010";
					when "1001001000" => rgb <= "101010";
					when "1001001001" => rgb <= "010101";
					when "1001001010" => rgb <= "010101";
					when "1001001011" => rgb <= "101010";
					when "1001001100" => rgb <= "101010";
					when "1001001101" => rgb <= "111000";
					when "1001001110" => rgb <= "111000";
					when "1001001111" => rgb <= "111000";
					when "1001010000" => rgb <= "111000";
					when "1001010001" => rgb <= "111000";
					when "1001010010" => rgb <= "111000";
					when "1001010011" => rgb <= "111000";
					when "1001010100" => rgb <= "111000";
					when "1001010101" => rgb <= "111000";
					when "1001010110" => rgb <= "111000";
					when "1001010111" => rgb <= "111000";
					when "1001011000" => rgb <= "111000";
					when "1001011001" => rgb <= "111000";
					when "1001011010" => rgb <= "111000";
					when "1001011011" => rgb <= "111000";
					when "1001011100" => rgb <= "111000";
					when "1001011101" => rgb <= "111000";
					when "1001011110" => rgb <= "111000";
					when "1001011111" => rgb <= "111000";
					when "1001100000" => rgb <= "111000";
					when "1001100001" => rgb <= "111000";
					when "1001100010" => rgb <= "111110";
					when "1001100011" => rgb <= "111110";
					when "1001100100" => rgb <= "000000";
					when "1001100101" => rgb <= "110110";
					when "1001100110" => rgb <= "110110";
					when "1010000000" => rgb <= "110010";
					when "1010000001" => rgb <= "110010";
					when "1010000010" => rgb <= "110010";
					when "1010000011" => rgb <= "110010";
					when "1010000100" => rgb <= "110010";
					when "1010000101" => rgb <= "110010";
					when "1010000110" => rgb <= "110010";
					when "1010000111" => rgb <= "101010";
					when "1010001000" => rgb <= "101010";
					when "1010001001" => rgb <= "010101";
					when "1010001010" => rgb <= "010101";
					when "1010001011" => rgb <= "101010";
					when "1010001100" => rgb <= "101010";
					when "1010001101" => rgb <= "111110";
					when "1010001110" => rgb <= "111110";
					when "1010001111" => rgb <= "111110";
					when "1010010000" => rgb <= "111110";
					when "1010010001" => rgb <= "111110";
					when "1010010010" => rgb <= "111110";
					when "1010010011" => rgb <= "111110";
					when "1010010100" => rgb <= "111110";
					when "1010010101" => rgb <= "111110";
					when "1010010110" => rgb <= "111110";
					when "1010010111" => rgb <= "111110";
					when "1010011000" => rgb <= "111110";
					when "1010011001" => rgb <= "111110";
					when "1010011010" => rgb <= "111110";
					when "1010011011" => rgb <= "111110";
					when "1010011100" => rgb <= "111110";
					when "1010011101" => rgb <= "111110";
					when "1010011110" => rgb <= "111110";
					when "1010011111" => rgb <= "111110";
					when "1010100000" => rgb <= "111110";
					when "1010100001" => rgb <= "111110";
					when "1010100010" => rgb <= "111110";
					when "1010100011" => rgb <= "111110";
					when "1010100100" => rgb <= "110110";
					when "1010100101" => rgb <= "110110";
					when "1010100110" => rgb <= "110110";
					when "1011000000" => rgb <= "110010";
					when "1011000001" => rgb <= "110010";
					when "1011000010" => rgb <= "110010";
					when "1011000011" => rgb <= "110010";
					when "1011000100" => rgb <= "110010";
					when "1011000101" => rgb <= "110010";
					when "1011000110" => rgb <= "110010";
					when "1011000111" => rgb <= "101010";
					when "1011001000" => rgb <= "101010";
					when "1011001001" => rgb <= "010101";
					when "1011001010" => rgb <= "010101";
					when "1011001011" => rgb <= "101010";
					when "1011001100" => rgb <= "101010";
					when "1011001101" => rgb <= "111110";
					when "1011001110" => rgb <= "111110";
					when "1011001111" => rgb <= "111110";
					when "1011010000" => rgb <= "111110";
					when "1011010001" => rgb <= "111110";
					when "1011010010" => rgb <= "111110";
					when "1011010011" => rgb <= "111110";
					when "1011010100" => rgb <= "111110";
					when "1011010101" => rgb <= "111110";
					when "1011010110" => rgb <= "111110";
					when "1011010111" => rgb <= "111110";
					when "1011011000" => rgb <= "111110";
					when "1011011001" => rgb <= "111110";
					when "1011011010" => rgb <= "111110";
					when "1011011011" => rgb <= "111110";
					when "1011011100" => rgb <= "111110";
					when "1011011101" => rgb <= "111110";
					when "1011011110" => rgb <= "111110";
					when "1011011111" => rgb <= "111110";
					when "1011100000" => rgb <= "111110";
					when "1011100001" => rgb <= "111110";
					when "1011100010" => rgb <= "111110";
					when "1011100011" => rgb <= "110110";
					when "1011100100" => rgb <= "110110";
					when "1011100101" => rgb <= "110110";
					when "1011100110" => rgb <= "110110";
					when "1100000000" => rgb <= "110110";
					when "1100000001" => rgb <= "110010";
					when "1100000010" => rgb <= "110010";
					when "1100000011" => rgb <= "110010";
					when "1100000100" => rgb <= "110010";
					when "1100000101" => rgb <= "110010";
					when "1100000110" => rgb <= "110010";
					when "1100000111" => rgb <= "101010";
					when "1100001000" => rgb <= "101010";
					when "1100001001" => rgb <= "010101";
					when "1100001010" => rgb <= "010101";
					when "1100001011" => rgb <= "101010";
					when "1100001100" => rgb <= "101010";
					when "1100001101" => rgb <= "111000";
					when "1100001110" => rgb <= "111000";
					when "1100001111" => rgb <= "111000";
					when "1100010000" => rgb <= "111000";
					when "1100010001" => rgb <= "111000";
					when "1100010010" => rgb <= "111000";
					when "1100010011" => rgb <= "111000";
					when "1100010100" => rgb <= "111000";
					when "1100010101" => rgb <= "111000";
					when "1100010110" => rgb <= "111000";
					when "1100010111" => rgb <= "111000";
					when "1100011000" => rgb <= "111000";
					when "1100011001" => rgb <= "111000";
					when "1100011010" => rgb <= "111000";
					when "1100011011" => rgb <= "111000";
					when "1100011100" => rgb <= "111000";
					when "1100011101" => rgb <= "111000";
					when "1100011110" => rgb <= "111000";
					when "1100011111" => rgb <= "111000";
					when "1100100000" => rgb <= "111000";
					when "1100100001" => rgb <= "111000";
					when "1100100010" => rgb <= "110110";
					when "1100100011" => rgb <= "110110";
					when "1100100100" => rgb <= "110110";
					when "1100100101" => rgb <= "110110";
					when "1100100110" => rgb <= "110110";
					when "1101000000" => rgb <= "110110";
					when "1101000001" => rgb <= "110110";
					when "1101000010" => rgb <= "110010";
					when "1101000011" => rgb <= "110010";
					when "1101000100" => rgb <= "110010";
					when "1101000101" => rgb <= "110010";
					when "1101000110" => rgb <= "110010";
					when "1101000111" => rgb <= "101010";
					when "1101001000" => rgb <= "101010";
					when "1101001001" => rgb <= "010101";
					when "1101001010" => rgb <= "010101";
					when "1101001011" => rgb <= "101010";
					when "1101001100" => rgb <= "101010";
					when "1101001101" => rgb <= "111110";
					when "1101001110" => rgb <= "111110";
					when "1101001111" => rgb <= "111110";
					when "1101010000" => rgb <= "111110";
					when "1101010001" => rgb <= "111110";
					when "1101010010" => rgb <= "111110";
					when "1101010011" => rgb <= "111110";
					when "1101010100" => rgb <= "111110";
					when "1101010101" => rgb <= "111110";
					when "1101010110" => rgb <= "111110";
					when "1101010111" => rgb <= "111110";
					when "1101011000" => rgb <= "111110";
					when "1101011001" => rgb <= "111110";
					when "1101011010" => rgb <= "111110";
					when "1101011011" => rgb <= "111110";
					when "1101011100" => rgb <= "111110";
					when "1101011101" => rgb <= "111110";
					when "1101011110" => rgb <= "111110";
					when "1101011111" => rgb <= "111110";
					when "1101100000" => rgb <= "111110";
					when "1101100001" => rgb <= "110110";
					when "1101100010" => rgb <= "110110";
					when "1101100011" => rgb <= "110110";
					when "1101100100" => rgb <= "110110";
					when "1101100101" => rgb <= "110110";
					when "1101100110" => rgb <= "110110";
					when others => rgb <= "111111";
		end case;
	end if;
   end process;
   totaladr <= std_logic_vector(yadr) & std_logic_vector(xadr);
end;