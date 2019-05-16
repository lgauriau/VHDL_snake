library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.VGA_PACKAGE.all;

entity test_image_sender is
  
  port (
    rst       : in  std_logic;
    clk       : in  std_logic;
    new_pixel : out std_logic;
    pixel_out : out std_logic_vector(COLOR_SIZE-1 downto 0);
    pixel_row : out std_logic_vector(ROW_ADDR_WIDTH-1 downto 0);
    pixel_col : out std_logic_vector(COL_ADDR_WIDTH-1 downto 0));

end entity test_image_sender;

architecture behavior of test_image_sender is

  signal h_counter, v_counter : integer;
  signal counter, counter_reg : std_logic_vector(ROW_ADDR_WIDTH + COL_ADDR_WIDTH - 1 downto 0);
  
begin  -- architecture behavior
  
  process(clk, rst)
  begin
    if rst = '1' then
      new_pixel <= '0';
      h_counter <= 0;
      v_counter <= 0;
    elsif rising_edge(clk) then
      if h_counter < RESOLUTION_WIDTH - 1 then
        new_pixel <= '1';
        h_counter <= h_counter + 1;        
      else
        h_counter <= 0;
        if v_counter < RESOLUTION_HEIGHT - 1 then
          new_pixel <= '1';
          v_counter <= v_counter + 1;
        else
          v_counter <= 0;
          new_pixel <= '0';
        end if;
      end if;
    end if;
  end process;

  pixel_col <= std_logic_vector(to_unsigned(h_counter, COL_ADDR_WIDTH));
  pixel_row <= std_logic_vector(to_unsigned(v_counter, ROW_ADDR_WIDTH));
  
  process(h_counter, v_counter)
  begin
    if v_counter < RESOLUTION_HEIGHT/4 then
      if h_counter < RESOLUTION_WIDTH/4 then
        pixel_out <= "0000";
      elsif h_counter < 2*RESOLUTION_WIDTH/4 then
        pixel_out <= "0001";
      elsif h_counter < 3*RESOLUTION_WIDTH/4 then
        pixel_out <= "0010";
      else
        pixel_out <= "0011";
      end if;
    elsif v_counter < 2*RESOLUTION_HEIGHT/4 then
      if h_counter < RESOLUTION_WIDTH/4 then
        pixel_out <= "0100";
      elsif h_counter < 2*RESOLUTION_WIDTH/4 then
        pixel_out <= "0101";
      elsif h_counter < 3*RESOLUTION_WIDTH/4 then
        pixel_out <= "0110";
      else
        pixel_out <= "0111";
      end if;
    elsif v_counter < 3*RESOLUTION_HEIGHT/4 then
      if h_counter < RESOLUTION_WIDTH/4 then
        pixel_out <= "1000";
      elsif h_counter < 2*RESOLUTION_WIDTH/4 then
        pixel_out <= "1001";
      elsif h_counter < 3*RESOLUTION_WIDTH/4 then
        pixel_out <= "1010";
      else
        pixel_out <= "1011";
      end if;
    else
      if h_counter < RESOLUTION_WIDTH/4 then
        pixel_out <= "1100";
      elsif h_counter < 2*RESOLUTION_WIDTH/4 then
        pixel_out <= "1101";
      elsif h_counter < 3*RESOLUTION_WIDTH/4 then
        pixel_out <= "1110";
      else
        pixel_out <= "1111";
      end if;
    end if;
  end process;
  

end architecture behavior;
