if (!is_undefined(global.player_id)){
	if (keyboard_string == "") 
		global.player_name = global.player_names[global.player_id];
	else global.player_name = keyboard_string;
	var _join_packet = {
		header: "PLAYER_JOINED",
		name: global.player_name,
		sender: global.player_id
	};

	send_data(_join_packet);
}