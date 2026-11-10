if (base64_string == undefined) {
	show_debug_message("There was no pfp so I the pfp loader died. :(")
    instance_destroy();
	exit;
}
if (base64_string != "") {
    if (sprite_exists(temp_raw_spr)) sprite_delete(temp_raw_spr);
    temp_raw_spr = sprite_add(base64_string, 1, false, false, 0, 0);
	base64_string = "";
}

if (sprite_exists(temp_raw_spr)) {
    var spr_w = sprite_get_width(temp_raw_spr);
    var spr_h = sprite_get_height(temp_raw_spr);
    if (spr_w > 0 && spr_h > 0) {
        var src_size = min(spr_w, spr_h);
        var src_x = (spr_w > spr_h) ? (spr_w - spr_h) / 2 : 0;
        var src_y = (spr_h > spr_w) ? (spr_h - spr_w) / 2 : 0;
        
        var surf = surface_create(size, size);
        surface_set_target(surf);
        draw_clear_alpha(c_black, 0);
        
        draw_sprite_part_ext(temp_raw_spr, 0, src_x, src_y, src_size, src_size, 0, 0, size / src_size, size / src_size, c_white, 1);
        
        surface_reset_target();
        
        if (sprite_exists(global.pfp[player])) sprite_delete(global.pfp[player]);
        global.pfp[player] = sprite_create_from_surface(surf, 0, 0, size, size, false, false, 0, 0);
        
        surface_free(surf);
        sprite_delete(temp_raw_spr);
        temp_raw_spr = noone;
		instance_destroy()
    }
	
}