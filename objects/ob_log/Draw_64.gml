if (open){
	draw_sprite_ext(sp_white, 0, 0, 0, w, h, 0, c_black, 0.5);
	for (var i = 0; i < array_length(global.log); ++i) {
	    draw_text(10, 10+25*i, global.log[i]);
	}
	draw_text(10, 10+25*length, keyboard_string + "|");
}