if (variable_global_exists("pfp") && sprite_exists(global.pfp[global.player_id])) {
    draw_sprite(global.pfp[index % 5], 0,x,y);
}