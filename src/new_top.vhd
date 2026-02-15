-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- packages
library work;
use work.game_package.all;

-- entity
entity new_top is
    port(
        -- clk
        clk : in std_logic;

        -- joystick
        x_position : in std_logic_vector(7 downto 0);
        y_position : in std_logic_vector(7 downto 0);
        trigger_button : in std_logic;
        center_button : in std_logic;

        -- vga
        vga_r : out std_logic_vector(4 downto 0);
        vga_g : out std_logic_vector(5 downto 0);
        vga_b : out std_logic_vector(4 downto 0);
        vga_hs, vga_vs : out std_logic
    );
end entity new_top;

-- architecture
architecture new_top of new_top is

    -- clocks
    signal clk_div_cpu, clk_div_vga : std_logic;

    -- vga
    signal vid, hs, vs : std_logic;
    signal hcount, vcount : integer;

    -- objects
    signal world_sig : world_type;
    signal blob_sig : blob_type;
    signal food_sig : food_type;

begin

    -- clock_div_cpu
    clock_div_cpu_inst : entity work.clock_div_cpu
    port map (
        clk => clk,
        div => clk_div_cpu
    );
        
    -- clock_div_vga
    clock_div_vga_inst : entity work.clock_div_vga
    port map (
        clk => clk,
        div => clk_div_vga
    );

    -- vga_ctrl
    vga_ctrl_inst : entity work.vga_ctrl
    port map (
        clk => clk,
        en => clk_div_vga,
        hcount => hcount,
        vcount => vcount,
        vid => vid,
        hs => hs,
        vs => vs
    );

    -- render
    render_inst : entity work.render
    port map (
        clk => clk,
        en => clk_div_vga,
        vid => vid,
        hs => hs,
        vs => vs,
        pix_x => hcount,
        pix_y => vcount,
        world => world_sig,
        blob => blob_sig,
        food => food_sig,
        vga_r => vga_r,
        vga_g => vga_g,
        vga_b => vga_b,
        vga_hs => vga_hs,
        vga_vs => vga_vs
    );
    
    -- game_logic
    game_logic_inst : entity work.game_logic
    port map (
        clk => clk,
        en => clk_div_cpu,
        x_position => x_position,
        y_position => y_position,
        trigger_button => trigger_button,
        center_button => center_button,
        world => world_sig,
        blob => blob_sig,
        food => food_sig
    );

end architecture new_top;
