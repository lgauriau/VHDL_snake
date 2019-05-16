library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

use work.VGA_PACKAGE.all;

entity vga_controller_ram is

  port (
    rst              : in  std_logic;
    clk              : in  std_logic;
    clk_pxl          : in  std_logic;
    enable_new_pixel : in  std_logic;
    pixel_in         : in  std_logic_vector(COLOR_SIZE-1 downto 0);
    pixel_row        : in  std_logic_vector(ROW_ADDR_WIDTH-1 downto 0);
    pixel_col        : in  std_logic_vector(COL_ADDR_WIDTH-1 downto 0);
    red_out          : out std_logic_vector(3 downto 0);
    green_out        : out std_logic_vector(3 downto 0);
    blue_out         : out std_logic_vector(3 downto 0);
    hsync            : out std_logic;
    vsync            : out std_logic);

end entity vga_controller_ram;

architecture behavior of vga_controller_ram is

  -- -- Video RAM
  component dual_port_ram is
    port (
      clk_a      : in  std_logic;
      clk_b      : in  std_logic;
      we_a       : in  std_logic;
      addr_a     : in  std_logic_vector(RAM_ADDR_WIDTH-1 downto 0);
      addr_b     : in  std_logic_vector(RAM_ADDR_WIDTH-1 downto 0);
      data_in_a  : in  std_logic_vector(COLOR_SIZE-1 downto 0);
      data_out_a : out std_logic_vector(COLOR_SIZE-1 downto 0);
      data_out_b : out std_logic_vector(COLOR_SIZE-1 downto 0));
  end component dual_port_ram;

  --Video RAM address signals
  signal addr_in, addr_out : std_logic_vector(RAM_ADDR_WIDTH-1 downto 0);
  signal data_out_ram      : std_logic_vector(COLOR_SIZE-1 downto 0);

  -- Pixel signals
  signal pixel_in_reg : std_logic_vector(COLOR_SIZE-1 downto 0);
  signal true_rgb     : std_logic_vector(11 downto 0);

  -- Sync signals
  signal v_counter, h_counter : integer;
  signal hsync_int, vsync_int : std_logic := '0';


begin  -- architecture behavior

  -- Color outputs
  red_out   <= true_rgb(11 downto 8);
  green_out <= true_rgb(7 downto 4);
  blue_out  <= true_rgb(3 downto 0);

  -- Color transcoding
  process(data_out_ram)
  begin
    case data_out_ram is
      when "0000" =>
        true_rgb <= COLOR_0;
      when "0001" =>
        true_rgb <= COLOR_1;
      when "0010" =>
        true_rgb <= COLOR_2;
      when "0011" =>
        true_rgb <= COLOR_3;
      when "0100" =>
        true_rgb <= COLOR_4;
      when "0101" =>
        true_rgb <= COLOR_5;
      when "0110" =>
        true_rgb <= COLOR_6;
      when "0111" =>
        true_rgb <= COLOR_7;
      when "1000" =>
        true_rgb <= COLOR_8;
      when "1001" =>
        true_rgb <= COLOR_9;
      when "1010" =>
        true_rgb <= COLOR_10;
      when "1011" =>
        true_rgb <= COLOR_11;
      when "1100" =>
        true_rgb <= COLOR_12;
      when "1101" =>
        true_rgb <= COLOR_13;
      when "1110" =>
        true_rgb <= COLOR_14;
      when "1111" =>
        true_rgb <= COLOR_15;
      when others =>
        true_rgb <= COLOR_0;
    end case;
  end process;

  -- Video ram
  video_ram : dual_port_ram
    port map (
      clk_a      => clk,
      clk_b      => clk_pxl,
      we_a       => enable_new_pixel,
      addr_a     => addr_in,
      addr_b     => addr_out,
      data_in_a  => pixel_in_reg,
      data_out_a => open,
      data_out_b => data_out_ram);

  -- New pixel address
  process(clk)
  begin
    if rising_edge(clk) then
      addr_in      <= std_logic_vector(to_unsigned((RESOLUTION_WIDTH*to_integer(unsigned(pixel_row)) + to_integer(unsigned(pixel_col))), RAM_ADDR_WIDTH));
      pixel_in_reg <= pixel_in;
    end if;

  end process;


  -- Counters
  process(rst, clk_pxl)
  begin
    if rst = '1' then
      h_counter <= 0;
      v_counter <= 0;
    elsif rising_edge(clk_pxl) then
      if (h_counter + 1 < (RESOLUTION_WIDTH + H_PW + H_FP + H_BP)) then
        h_counter <= h_counter + 1;
      else
        h_counter <= 0;
        if (v_counter + 1 < (RESOLUTION_HEIGHT + V_PW + V_FP + V_BP)) then
          v_counter <= v_counter + 1;
        else
          v_counter <= 0;
        end if;
      end if;
    end if;
  end process;

  -- Pixel out address
  process(h_counter, v_counter)
  begin
    if (h_counter < RESOLUTION_WIDTH) and (v_counter < RESOLUTION_HEIGHT) then
      addr_out <= std_logic_vector(to_unsigned(RESOLUTION_WIDTH * v_counter + h_counter, RAM_ADDR_WIDTH));
    else
      addr_out <= (others => '0');
    end if;
  end process;

  -- HSync
  process(clk_pxl)
  begin
    if rising_edge(clk_pxl) then
      if (h_counter < (RESOLUTION_WIDTH + H_PW + H_FP - 1)) and (h_counter >= (RESOLUTION_WIDTH + H_FP - 1)) then
        hsync_int <= H_POLARITY;
      else
        hsync_int <= not H_POLARITY;
      end if;
    end if;
  end process;

  -- VSync
  process(clk_pxl)
  begin
    if rising_edge(clk_pxl) then
      if (v_counter < (RESOLUTION_HEIGHT + V_PW + V_FP - 1)) and (v_counter >= (RESOLUTION_HEIGHT + V_FP - 1)) then
        vsync_int <= V_POLARITY;
      else
        vsync_int <= not V_POLARITY;
      end if;
    end if;
  end process;

  process(clk_pxl)
  begin
    if rising_edge(clk_pxl) then
      vsync <= vsync_int;
      hsync <= hsync_int;
    end if;
  end process;

end architecture behavior;
