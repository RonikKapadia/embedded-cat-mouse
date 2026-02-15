-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- packages
library work;
use work.game_package.all;

-- entity
entity game_logic is
    port(
        -- clk
        clk, en : in std_logic;

        -- joystick
        x_position : in std_logic_vector(7 downto 0);
        y_position : in std_logic_vector(7 downto 0);
        trigger_button : in std_logic;
        center_button : in std_logic;

        -- objects
        world : out world_type;
        blob : out blob_type;
        food : out food_type
    );
end game_logic;

-- architecture
architecture game_logic of game_logic is

    constant scale : integer := 1;

    -- world
    signal world_data : world_type := (
        res_x => 640,
        res_y => 480,
        bnd_x => -1,
        bnd_y => -1,
        offset => 20*scale,
        border => 4*scale,
        scale => 1*scale,
        state => start_game,
        grid_spacing => 20*scale,
        grid_thickness => 2*scale,
        render_start => '0',
        render_pause => '0',
        score => 0
    );

    -- blob
    signal blob_data : blob_type := (
        x => 460*scale,
        y => 100*scale,
        size => 40*scale,
        speed => 1,
        color => (
            r => "10000",
            g => "100000",
            b => "11111"
        ),
        shadow_offset => 10*scale,
        shadow_color => (
            r => "01000",
            g => "010000",
            b => "01000"
        )
    );

    -- food
    signal food_data : food_type := (
        x => 130*scale,
        y => 370*scale,
        size => 5*scale,
        speed => 1,
        color => (
            r => "11111",
            g => "100000",
            b => "10000"
        ),
        shadow_offset => 5*scale,
        shadow_color => (
            r => "01000",
            g => "010000",
            b => "01000"
        )
    );

    -- random number
    signal rand : integer := 0;

    -- count
    signal count : integer := 0;

begin

    world <= world_data;
    blob <= blob_data;
    food <= food_data;

    world_data.bnd_x <= (world_data.res_x * world_data.scale) - (2 * world_data.offset);
    world_data.bnd_y <= (world_data.res_y * world_data.scale) - (2 * world_data.offset);

    process(clk)
        variable blob_next_x : integer;
        variable blob_next_y : integer;
    begin
        if rising_edge(clk) then 

            rand <= rand + 1;

            if en = '1' then 

                count <= count + 1;

                case world_data.state is
                    
                    -- start_game
                    when start_game => 
                        -- blinking screen
                        if (count mod 150 > 25) then
                            world.render_start <= '1';
                        else
                            world.render_start <= '0';
                        end if;

                        -- start game
                        if center_button = '1' then
                            world_data.state <= running;
                        end if;
                    
                    -- running
                    when running => 
                        -- pause game
                        if trigger_button = '1' then
                            world_data.state <= pause_game;
                        end if;

                        -- update x position
                        -- blob_next_x := (world_data.bnd_x/2) + ((to_integer(unsigned(x_position)) - 128) * world_data.bnd_y / 128);
                        blob_next_x := (blob_data.x + ((to_integer(unsigned(x_position))-128) * blob_data.speed));

                        if (blob_next_x-blob_data.size < 0) then 
                            blob_data.x <= 0 + blob_data.size;
                        elsif (blob_next_x+blob_data.size > world_data.bnd_x) then 
                            blob_data.x <= world_data.bnd_x - blob_data.size;
                        else
                            blob_data.x <= blob_next_x;
                        end if;

                        -- update y position
                        -- blob_next_y := (world_data.bnd_y/2) + ((to_integer(unsigned(y_position)) - 128) * world_data.bnd_y / 128);
                        blob_next_y := (blob_data.y + ((to_integer(unsigned(y_position))-128) * blob_data.speed));
         
                        if (blob_next_y-blob_data.size < 0) then 
                            blob_data.y <= 0 + blob_data.size;
                        elsif (blob_next_y+blob_data.size > world_data.bnd_y) then 
                            blob_data.y <= world_data.bnd_y - blob_data.size;
                        else
                            blob_data.y <= blob_next_y;
                        end if;
                        

                        -- eat food
                        if  ((blob_data.x + blob_data.size) >= (food_data.x + food_data.size)) and
                            ((blob_data.x - blob_data.size) <= (food_data.x - food_data.size)) and
                            ((blob_data.y + blob_data.size) >= (food_data.y + food_data.size)) and
                            ((blob_data.y - blob_data.size) <= (food_data.y - food_data.size)) then 
                            
                            food_data.x <= (rand mod (world_data.bnd_x-(2*food_data.size))) + food_data.size;
                            food_data.y <= (rand mod (world_data.bnd_y-(2*food_data.size))) + food_data.size;

                            world_data.score <= world_data.score + 1;
                        end if;

                        -- if food out of bounds remake location
                        if  (food_data.x-food_data.size < 0) or
                            (food_data.x+food_data.size > world_data.bnd_x) or
                            (food_data.y-food_data.size < 0) or
                            (food_data.y+food_data.size > world_data.bnd_y) then
                            food_data.x <= (rand mod (world_data.bnd_x-(2*food_data.size))) + food_data.size;
                            food_data.y <= (rand mod (world_data.bnd_y-(2*food_data.size))) + food_data.size;
                        end if;


                    -- pause_game
                    when pause_game =>
                        -- blinking screen
                        if (count mod 150 > 25) then
                            world.render_pause <= '1';
                        else
                            world.render_pause <= '0';
                        end if;

                        -- resume game
                        if center_button = '1' then
                            world_data.state <= running;
                        end if;
                        
                end case;
            end if;
        end if;
    end process;

end game_logic;