if (variable_global_exists("pfp") && sprite_exists(global.pfp[global.player_id])) {
    draw_sprite_stretched(global.pfp[global.player_id], 0, box_x, box_y, display_size, display_size);
}