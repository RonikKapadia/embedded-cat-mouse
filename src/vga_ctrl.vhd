-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- entity
entity vga_ctrl is 
    port(
        clk, en : in std_logic;
        hcount, vcount : out integer;
        vid, hs, vs : out std_logic
    );
end vga_ctrl;

-- architecture
architecture vga_ctrl of vga_ctrl is
    -- intermediate signals
    signal hcount_reg, vcount_reg : integer := 0;

    -- horizontal
    constant ACTIVE_H : integer := 640;
    constant FRONT_H : integer := 16;
    constant SYNC_H : integer := 96;
    constant BACK_H : integer := 48;
    constant WHOLE_H : integer := ACTIVE_H + FRONT_H + SYNC_H + BACK_H;
    constant POL_H : std_logic := '0'; -- '0' is neg, '1' is pos

    -- vertical
    constant ACTIVE_V : integer := 480;
    constant FRONT_V : integer := 10;
    constant SYNC_V : integer := 2;
    constant BACK_V : integer := 33;
    constant WHOLE_V : integer := ACTIVE_V + FRONT_V + SYNC_V + BACK_V;
    constant POL_V : std_logic := '0'; -- '0' is neg, '1' is pos


begin

    hcount <= hcount_reg;
    vcount <= vcount_reg;

    process(clk)
    begin
        if rising_edge(clk) then
            if en = '1' then
                
                -- horizontal counter
                if (hcount_reg < WHOLE_H-1) then
                    hcount_reg <= hcount_reg + 1;
                else
                    hcount_reg <= 0;
                    
                    -- vertical counter
                    if (vcount_reg < WHOLE_V-1) then
                        vcount_reg <= vcount_reg + 1;
                    else
                        vcount_reg <= 0;
                    end if;

                end if;

            end if;
        end if;
    end process;
    
    
    process(hcount_reg, vcount_reg) 
    begin
        -- vid
        if (hcount_reg <= ACTIVE_H-1) and (vcount_reg <= ACTIVE_V-1) then 
            vid <= '1';
        else
            vid <= '0';
        end if;

        -- hs 
        if (hcount_reg >= ACTIVE_H + FRONT_H) and (hcount_reg <= ACTIVE_H + FRONT_H + SYNC_H - 1) then
            hs <= POL_H;
        else
            hs <= not POL_H;
        end if;

        -- vs
        if (vcount_reg >= ACTIVE_V + FRONT_V) and (vcount_reg <= ACTIVE_V + FRONT_V + SYNC_V - 1) then
            vs <= POL_V;
        else
            vs <= not POL_V;
        end if;
    end process;

end vga_ctrl;