-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- package
package game_package is

    type color_type is record
        r : std_logic_vector(4 downto 0);
        g : std_logic_vector(5 downto 0);
        b : std_logic_vector(4 downto 0);
    end record color_type;

    type game_state is (start_game, running, pause_game);
    
    type world_type is record
        res_x : integer;
        res_y : integer;
        bnd_x : integer;
        bnd_y : integer;
        offset : integer; 
        border : integer;
        scale : integer;
        state : game_state;
        grid_spacing : integer;
        grid_thickness : integer;
        render_start : std_logic;
        render_pause : std_logic;
        score : integer;
    end record world_type;

    type blob_type is record
        x : integer;
        y : integer;
        size : integer;
        speed : integer;
        color : color_type;
        shadow_offset : integer;
        shadow_color : color_type;
    end record blob_type;

    type food_type is record
        x : integer;
        y : integer;
        size : integer;
        speed : integer;
        color : color_type;
        shadow_offset : integer;
        shadow_color : color_type;
    end record food_type;

    function my_max(a, b : integer) return integer;
    function my_min(a, b : integer) return integer;


end package;

package body game_package is
  function my_max(a, b : integer) return integer is
  begin
    if a > b then
      return a;
    else
      return b;
    end if;
  end function;

  function my_min(a, b : integer) return integer is
    begin
        if a < b then
            return a;
        else
            return b;
        end if;
    end function;
end package body;
