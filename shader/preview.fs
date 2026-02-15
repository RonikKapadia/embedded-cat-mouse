#iChannel0 "self"
#iChannel1 "file://font.png"

// Define the structs
struct Color {
    int r;
    int g;
    int b;
};

struct World {
    int res_x;
    int res_y;
    int bnd_x;
    int bnd_y;
    int offset;
    int border;
    int scale;
    int state;
    int grid_spacing;
    int grid_thickness;
};

struct Blob {
    int x;
    int y;
    int size;
    int speed;
    Color color;
};

struct Food {
    int x;
    int y;
    int size;
    int speed;
    Color color;
};

// text functions
vec3 text(int x, int y){
    return texelFetch(iChannel1, ivec2(x,7-y), 0).rgb;
}

vec3 char(int i, int x, int y){
    return text(i*8+x, y);
}

int draw_char(int pix_x, int pix_y, int i, int x, int y, int s){
    if (pix_x >= x && pix_y >= y && pix_x < x+8*s && pix_y < y+8*s){
        return int(char(i,(pix_x-x)/s, (pix_y-y)/s).r);
    }
    else{
        return 0;
    }
}

int draw_string(int pix_x, int pix_y, int string[20], int x, int y, int s){
    int i = (pix_x-x)/(8*s);
    if (i >= 0 && i < 20){
        if (draw_char(pix_x, pix_y, string[i]-33, x + i*8*s, y, s) == 1){
            return 0;
        }
    }
    return 1;
}

// Initialize the structs
void main() {

    // set the scale
    int scale = 100;

    // Initialize the world struct
    World world = World(
        640,
        480,
        -1,
        -1,
        20*scale,
        4*scale,
        1*scale,
        -1,
        20*scale,
        2*scale
    );

    // Initialize the blob struct
    Blob blob = Blob(
        460*scale,
        100*scale,
        40*scale,
        5,
        Color(15, 63, 24)
    );

    // Initialize the food struct
    Food food = Food(
        250*scale,
        370*scale,
        20*scale,
        4,
        Color(24, 8, 4)
    );

    int grid_spacing = 20;
    int grid_thickness = 2;

    int aspect_h = 1;
    int aspect_v = 1;

    int pix_x = int(gl_FragCoord.x) * aspect_h / aspect_v - int(iResolution.x/2.0) + world.res_x/2;
    int pix_y = world.res_y-int(gl_FragCoord.y) + int(iResolution.y/2.0) - world.res_y/2;

    world.bnd_x = (world.res_x * world.scale) - 2 * world.offset;
    world.bnd_y = (world.res_y * world.scale) - 2 * world.offset;

    int wor_x = (pix_x * world.scale) - world.offset;
    int wor_y = (pix_y * world.scale) - world.offset;

    // blob.x = int(iMouse.x) * world.scale - world.offset;
    // blob.y = int(iMouse.y) * world.scale - world.offset;

    blob.x += int(sin(iTime)*float(world.scale)*20.0);
    blob.y += int(cos(iTime)*float(world.scale)*20.0);

    // clk and rand variables
    int clk = int(iTime*100.0);
    int rand = int(iTime*125000000.0);

    // food.y += int(sin(iTime)*float(world.scale)*100.0);
    food.x += int(-sin(iTime)*float(world.scale)*100.0);

    // string 
    int hello_world_text[20] = int[](72, 101, 108, 108, 111, 32, 87, 111, 114, 108, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    int joystick_to_play_text[20] = int[](74, 111, 121, 115, 116, 105, 99, 107, 32, 84, 111, 32, 80, 108, 97, 121, 32, 32, 32, 32);
    int start_game_text[20] = int[](83, 116, 97, 114, 116, 32, 71, 97, 109, 101, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32);
    int game_paused_text[20] = int[](71, 97, 109, 101, 32, 80, 97, 117, 115, 101, 100, 32, 32, 32, 32, 32, 32, 32, 32, 32);
    int joystick_to_continue_text[20] = int[](74, 111, 121, 115, 116, 105, 99, 107, 32, 84, 111, 32, 67, 111, 110, 116, 105, 110, 117, 101);
    int score_text[20] = int[](83, 99, 111, 114, 101, 58, 32, 52, 50, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32);
    int dont_eat_text[20] = int[](68, 111, 110, 39, 116, 32, 101, 97, 116, 32, 109, 101, 33, 32, 32, 32, 32, 32, 32, 32);
    int im_hungy_text[20] = int[](73, 39, 109, 32, 72, 117, 110, 103, 114, 121, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32);

    // render backround
    vec3 color = vec3(1.0, 1.0, 1.0);

    // render grid
    if (((wor_x % world.grid_spacing) < world.grid_thickness) && ((wor_y % world.grid_spacing) < world.grid_thickness)) {
        color = vec3(0.5, 0.5, 0.5);    // set color to grey
    }

    // render food shadow
    int food_shadow_offest = 5*scale;
    if ((wor_x - food_shadow_offest > food.x - food.size) && (wor_x - food_shadow_offest < food.x + food.size) && (wor_y - food_shadow_offest > food.y - food.size) && (wor_y - food_shadow_offest < food.y + food.size)) {
        color = color * vec3(0.4, 0.3, 0.3);    // set color to food color
    }

    // render food
    if ((wor_x > food.x - food.size) && (wor_x < food.x + food.size) && (wor_y > food.y - food.size) && (wor_y < food.y + food.size)) {
        color = vec3(1.0, 0.5, 0.5);    // set color to food color
    }

    // render blob shadow
    int blob_shadow_offset = 10*scale;
    if ((wor_x - blob_shadow_offset > blob.x - blob.size) && (wor_x - blob_shadow_offset < blob.x + blob.size) && (wor_y - blob_shadow_offset > blob.y - blob.size) && (wor_y - blob_shadow_offset < blob.y + blob.size)) {
        color = color * vec3(0.2, 0.2, 0.4);    // set color to blob color
    }

    // render blob
    if ((wor_x > blob.x - blob.size) && (wor_x < blob.x + blob.size) && (wor_y > blob.y - blob.size) && (wor_y < blob.y + blob.size)) {
        color = vec3(0.5, 0.5, 1.0);    // set color to blob color
    }

    // dont eat me
    color = color * float(draw_string(wor_x, wor_y, dont_eat_text, food.x-50*food.size/11, food.y-10*food.size/4, 2*world.scale));

    // I'm hungry
    color = color * float(draw_string(wor_x, wor_y, im_hungy_text, blob.x-23*blob.size/11, blob.y-5*blob.size/3, 2*world.scale));

    // score
    int score = int(iTime);

    score_text[6] = score/100 % 10 + 48;
    score_text[7] = score/10 % 10 + 48;
    score_text[8] = score/1 % 10 + 48;

    color = color * float(draw_string(pix_x, pix_y, score_text, 35, 35, 2));

    // start game
    if (clk % 150 > 25){
        color = color * float(draw_string(pix_x, pix_y, start_game_text, 120, 210, 5));
        color = color * float(draw_string(pix_x, pix_y, joystick_to_play_text, 190, 265, 2));
    }

    // // game paused
    // if (clk % 150 > 25){
    //     color = color * float(draw_string(pix_x, pix_y, game_paused_text, 100, 210, 5));
    //     color = color * float(draw_string(pix_x, pix_y, joystick_to_continue_text, 165, 265, 2));
    // }

    // render offset
    if ((wor_x <= 0) || (wor_x >= world.bnd_x) || (wor_y <= 0) || (wor_y >= world.bnd_y)) {
        color = vec3(0.0, 0.0, 0.0);    // set color to black
    }

    // render border
    if ((wor_x < 0 - world.border) || (wor_x > (world.bnd_x + world.border)) || (wor_y < 0 - world.border) || (wor_y > (world.bnd_y + world.border))) {
        color = vec3(1.0, 1.0, 1.0);    // set color to black
    }

    // offscreen
    if ((pix_x < 0) || (pix_x > world.res_x) || (pix_y < 0) || (pix_y > world.res_y)){
        color = vec3(0.0, 0.0, 0.0);    // set color to black
    }


    gl_FragColor = vec4(color, 1.0);

}
