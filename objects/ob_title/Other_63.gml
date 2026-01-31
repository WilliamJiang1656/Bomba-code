if (!is_undefined(global.player_id)){
	var _id = ds_map_find_value(async_load, "id");

	if (_id == msg_id) {
	    if (ds_map_find_value(async_load, "status")) {
	        var result = ds_map_find_value(async_load, "result");
        
	        // Use the default name if they left it blank
	        if (result == "") {
	            global.player_name = global.player_names[global.player_id];
	        } else {
	            global.player_name = result;
	        }

	        var _join_packet = {
	            header: "PLAYER_JOINED",
	            name: global.player_name, 
	            sender: global.player_id
	        };

	        send_data(_join_packet);
	    }
	}
}