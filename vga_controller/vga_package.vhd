library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package VGA_PACKAGE is

  -- Screen resolution
  constant RESOLUTION_WIDTH  : integer := 800;
  constant RESOLUTION_HEIGHT : integer := 600;

  -- VGA horizontal sync constants
  constant H_PW : integer := 128;        -- horizontal pulse width
  constant H_FP : integer := 40;        -- horizontal front porch
  constant H_BP : integer := 88;        -- horizontal back porch
  constant H_POLARITY : std_logic := '1';
  
  -- VGA vertical sync constants (in number of lines)
  constant V_PW : integer := 4;         -- vertical pulse width
  constant V_FP : integer := 1;        -- vertical front porch
  constant V_BP : integer := 23;        -- vertical back porch
  constant V_POLARITY : std_logic := '1';

  -- Number of bits required for color coding
  constant COLOR_SIZE        : integer := 4;
  
  -- Display Predefined colors (number = 2^color_size)
  constant COLOR_0  : std_logic_vector(11 downto 0) := X"000";
  constant COLOR_1  : std_logic_vector(11 downto 0) := X"004";
  constant COLOR_2  : std_logic_vector(11 downto 0) := X"008";
  constant COLOR_3  : std_logic_vector(11 downto 0) := X"00C";
  constant COLOR_4  : std_logic_vector(11 downto 0) := X"040";
  constant COLOR_5  : std_logic_vector(11 downto 0) := X"080";
  constant COLOR_6  : std_logic_vector(11 downto 0) := X"0C0";
  constant COLOR_7  : std_logic_vector(11 downto 0) := X"400";
  constant COLOR_8  : std_logic_vector(11 downto 0) := X"800";
  constant COLOR_9  : std_logic_vector(11 downto 0) := X"C00";
  constant COLOR_10 : std_logic_vector(11 downto 0) := X"088";
  constant COLOR_11 : std_logic_vector(11 downto 0) := X"880";
  constant COLOR_12 : std_logic_vector(11 downto 0) := X"808";
  constant COLOR_13 : std_logic_vector(11 downto 0) := X"444";
  constant COLOR_14 : std_logic_vector(11 downto 0) := X"888";
  constant COLOR_15 : std_logic_vector(11 downto 0) := X"CCC";
  
  constant NUMBER_PIXELS : integer := RESOLUTION_WIDTH*RESOLUTION_HEIGHT;

  constant COL_ADDR_WIDTH : integer := integer(ceil(log2(real(RESOLUTION_WIDTH))));
  constant ROW_ADDR_WIDTH : integer := integer(ceil(log2(real(RESOLUTION_HEIGHT))));
  constant RAM_ADDR_WIDTH : integer := integer(ceil(log2(real(NUMBER_PIXELS))));
  
end package VGA_PACKAGE;
