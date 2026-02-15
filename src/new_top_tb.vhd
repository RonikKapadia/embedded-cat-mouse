-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- packages
library work;
use work.game_package.all;

-- entity
entity new_top_tb is
end entity new_top_tb;

-- architecture
architecture new_top_tb of new_top_tb is

    -- clk
    signal clk : std_logic := '0';

    -- vga
    signal vga_r : std_logic_vector(4 downto 0) := "00000";
    signal vga_g : std_logic_vector(5 downto 0) := "000000";
    signal vga_b : std_logic_vector(4 downto 0) := "00000";
    signal vga_hs, vga_vs : std_logic := '0';
    
    -- joystick
    signal x_position : std_logic_vector(7 downto 0) := "10000000";
    signal y_position : std_logic_vector(7 downto 0) := "10000000";
    signal trigger_button : std_logic := '0';
    signal center_button : std_logic := '0';

begin

    -- top
    new_top_inst : entity work.new_top
    port map (
        clk => clk,
        x_position => x_position,
        y_position => y_position,
        trigger_button => trigger_button,
        center_button => center_button,
        vga_r => vga_r,
        vga_g => vga_g,
        vga_b => vga_b,
        vga_hs => vga_hs,
        vga_vs => vga_vs
    );

    -- clk
    process begin
        clk <= '0';
        wait for 4 ns;
        clk <= '1';
        wait for 4 ns;
    end process;

    -- main
    process begin

        -- wait on start screen
        wait for 1000 ns;

        -- try and move on start screen
        x_position <= "00000000";
        y_position <= "11111111";
        wait for 1000 ns;

        -- start game and see movment
        center_button <= '1';
        wait for 100 ns;
        center_button <= '0';
        wait for 1000 ns;

        -- pause game and see no movment
        x_position <= "11111111";
        y_position <= "00000000";
        trigger_button <= '1';
        wait for 100 ns;
        trigger_button <= '0';
        wait for 1000 ns;

        -- resume game and see movment
        center_button <= '1';
        wait for 100 ns;
        center_button <= '0';
        wait for 1000 ns;
    
        report "End of testbench" severity FAILURE;
    end process;
    
end architecture new_top_tb;
