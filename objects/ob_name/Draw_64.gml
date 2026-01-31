for(var i = 0; i < 5; ++i) {
    var loc = locations[i];
    var loc_pfp = locations_pfp[i];

    var box_col = is_turn[i] ? c_yellow : c_black;
    draw_sprite_ext(sp_white, 0, loc[0], loc[1], loc[2]-loc[0], loc[3]-loc[1], 0, box_col, 1);

    var txt_col = is_turn[i] ? c_black : c_white;
    draw_text_color(loc[0], loc[1], global.player_names[i], txt_col, txt_col, txt_col, txt_col, 1);
   
    var pfp_col = (is_landlord[i]) ? c_red : c_black;
    draw_sprite_ext(sp_white, 0, loc_pfp[0], loc_pfp[1], pfp_width, pfp_width, 0, pfp_col, 1);
	
	if (exit_order[i] > 0) {
		draw_sprite_ext(sp_white, 0, loc_pfp[0]-exit_size[i][0], loc_pfp[1], exit_size[i][0], exit_size[i][1], 0, c_black, 1);
		draw_text_color(loc_pfp[0]-exit_size[i][0], loc_pfp[1], exit_order[i], c_white, c_white, c_white, c_white, 1);
	}
}