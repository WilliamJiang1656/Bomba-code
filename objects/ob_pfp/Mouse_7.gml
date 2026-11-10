if (pressed){
	image_blend = c_white;
	pressed = false;
	if (variable_global_exists("pfp") && sprite_exists(global.pfp[global.player_id])) {
		sprite_delete(global.pfp[global.player_id]);
	}
	html_upload_profile_picture();
}