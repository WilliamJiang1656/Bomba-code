draw_sprite_ext(sp_white, 0, x, box_y, box_w, box_h, 0, c_black, 0.5);

draw_text_color(x + 8, box_y + 4, "Enter Name: " + keyboard_string + "| id:" + string(global.player_id), c_white, c_white, c_white, c_white, 1);

draw_text_color(0, room_height - 50, "v." + GM_version, c_black, c_black, c_black, c_black, 1);