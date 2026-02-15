-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- packages
library work;
use work.game_package.all;

-- entity
entity top_tb is
end entity top_tb;

-- architecture
architecture top_tb of top_tb is

    -- clk
    signal clk : std_logic := '0';

    -- vga
    signal vga_r : std_logic_vector(4 downto 0) := "00000";
    signal vga_g : std_logic_vector(5 downto 0) := "000000";
    signal vga_b : std_logic_vector(4 downto 0) := "00000";
    signal vga_hs, vga_vs : std_logic := '0';
    
    -- joystick
    signal miso : std_logic;
    signal mosi : std_logic;
    signal sclk : std_logic;
    signal cs_n : std_logic;

begin

    -- top
    top_inst : entity work.top
    port map (
        clk => clk,
        vga_r => vga_r,
        vga_g => vga_g,
        vga_b => vga_b,
        vga_hs => vga_hs,
        vga_vs => vga_vs,
        miso => miso,
        mosi => mosi,
        sclk => sclk,
        cs_n => cs_n
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

        wait for 100000 ns;
    
        report "End of testbench" severity FAILURE;
    end process;
    

end architecture top_tb;
