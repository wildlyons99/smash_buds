library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top is
  port(
	  ext12m : in std_logic;
	  HSYNC : out std_logic;
	  VSYNC : out std_logic;
	  RGB : out std_logic_vector(5 downto 0);
	  testPLLout : out std_logic
      );
end top;

architecture synth of top is
	component my_pll is
    port(
        ref_clk_i: in std_logic; -- Input clock
        rst_n_i: in std_logic; -- Reset active low (so normally keep high)
        outcore_o: out std_logic; -- Output to pins
        outglobal_o: out std_logic -- Output to fpga clock network
    );
	end component;
	component vga is
	    port(
		  clk : in std_logic;
		  HSYNC : out std_logic;
		  VSYNC : out std_logic;
		  row : out unsigned(9 downto 0); -- 0-1023
		  col : out unsigned(9 downto 0); -- 0-1023
		  valid : out std_logic
		  );
	end component;
	component pattern_gen is
    port(
		  clk : in std_logic;
		  row : in unsigned(9 downto 0); -- 0-1023
		  col : in unsigned(9 downto 0); -- 0-1023
		  valid : in std_logic;
		  rgb : out std_logic_vector(5 downto 0)
		  );
    end component;	
	signal internal25clk : std_logic;
	signal internalrow : unsigned(9 downto 0);
	signal internalcol : unsigned(9 downto 0);
	signal internalvalid : std_logic;
begin
   pll : my_pll port map(ext12m, '1', testPLLout, internal25clk);
   internalvga : vga port map(internal25clk, HSYNC, VSYNC, internalrow, internalcol, internalvalid);
   patternmaker : pattern_gen port map(internal25clk, internalrow, internalcol, internalvalid, RGB);
end;


