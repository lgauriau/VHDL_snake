library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.VGA_PACKAGE.all;

entity test_top is
  
  port (
    rst       : in  std_logic;
    clk       : in  std_logic;
    red_out   : out std_logic_vector(3 downto 0);
    green_out : out std_logic_vector(3 downto 0);
    blue_out  : out std_logic_vector(3 downto 0);
    hsync     : out std_logic;
    vsync     : out std_logic);

end entity test_top;

architecture structure of test_top is

  signal clk_work : std_logic;
  signal clk_pxl : std_logic;
  
  component clk_wiz_0
    port (
      CLK_IN1  : in     std_logic;
      CLK_OUT1 : out    std_logic;
      CLK_OUT2 : out    std_logic;
      CLK_OUT3 : out    std_logic
      );
  end component;
  
  component test_image_sender is
    port (
      rst       : in  std_logic;
      clk       : in  std_logic;
      new_pixel : out std_logic;
      pixel_out : out std_logic_vector(COLOR_SIZE-1 downto 0);
      pixel_row : out std_logic_vector(ROW_ADDR_WIDTH-1 downto 0);
      pixel_col : out std_logic_vector(COL_ADDR_WIDTH-1 downto 0));
  end component test_image_sender;

  component vga_controller_ram is
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
  end component vga_controller_ram;

  signal new_pixel : std_logic;
  signal pixel_in : std_logic_vector(COLOR_SIZE-1 downto 0);
  signal pixel_row : std_logic_vector(ROW_ADDR_WIDTH-1 downto 0);
  signal pixel_col : std_logic_vector(COL_ADDR_WIDTH-1 downto 0);
  
begin  -- architecture structure

    CLK_DIV : clk_wiz_0
    port map (
        CLK_IN1 => clk,

        CLK_OUT1 => clk_work,
        CLK_OUT2 => clk_pxl,
        CLK_OUT3 => open
    );
    
  
  test_image_sender_1: test_image_sender
    port map (
      rst       => rst,
      clk       => clk_work,
      new_pixel => new_pixel,
      pixel_out => pixel_in,
      pixel_row => pixel_row,
      pixel_col => pixel_col);

    vga_controller_ram_1 : vga_controller_ram
      port map (
        rst              => rst,
        clk              => clk_work,
        clk_pxl          => clk_pxl,
        enable_new_pixel => new_pixel,
        pixel_in         => pixel_in,
        pixel_row        => pixel_row,
        pixel_col        => pixel_col,
        red_out          => red_out,
        green_out        => green_out,
        blue_out         => blue_out,
        hsync            => hsync,
        vsync            => vsync);

end architecture structure;
