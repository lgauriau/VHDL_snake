library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

use work.VGA_PACKAGE.all;

entity dual_port_ram is

  port (
    clk_a      : in  std_logic;
    clk_b      : in  std_logic;
    we_a       : in  std_logic;
    addr_a     : in  std_logic_vector(RAM_ADDR_WIDTH-1 downto 0);
    addr_b     : in  std_logic_vector(RAM_ADDR_WIDTH-1 downto 0);
    data_in_a  : in  std_logic_vector(COLOR_SIZE-1 downto 0);
    data_out_a : out std_logic_vector(COLOR_SIZE-1 downto 0);
    data_out_b : out std_logic_vector(COLOR_SIZE-1 downto 0));

end entity dual_port_ram;

architecture behavior of dual_port_ram is

  type ram_type is array (NUMBER_PIXELS-1 downto 0) of std_logic_vector(COLOR_SIZE-1 downto 0);
  signal RAM : ram_type;

  signal addr_a_int, addr_b_int : integer;

  attribute ram_style        : string;
  attribute ram_style of RAM : signal is "block";

begin

  process(addr_a)
  begin
    if to_integer(unsigned(addr_a)) < NUMBER_PIXELS then
      addr_a_int <= to_integer(unsigned(addr_a));
    else
      addr_a_int <= 0;
    end if;
  end process;

  process(addr_b)
  begin
    if to_integer(unsigned(addr_b)) < NUMBER_PIXELS then
      addr_b_int <= to_integer(unsigned(addr_b));
    else
      addr_b_int <= 0;
    end if;
  end process;

  process(clk_a)
  begin
    if clk_a'event and clk_a = '1' then
      if we_a = '1' then
        RAM(to_integer(unsigned(addr_a))) <= data_in_a;
      end if;
      data_out_a <= RAM(to_integer(unsigned(addr_a)));
    end if;
  end process;
  process(clk_b)
  begin
    if clk_b'event and clk_b = '1' then
      data_out_b <= RAM(to_integer(unsigned(addr_b)));
    end if;
  end process;

end architecture behavior;
