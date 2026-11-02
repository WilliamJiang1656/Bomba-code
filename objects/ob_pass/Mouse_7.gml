if (pressed){
	image_blend = c_white;
	pressed = false;
	var _pass_packet = {
		header: "PASS",
	};
	send_data(_pass_packet);
	
	// play sound
	audio_play_sound(so_pass,100,0,0.5);
	
	// fix double click
	instance_destroy()
}