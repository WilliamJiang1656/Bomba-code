// Inherit the parent event
event_inherited();
ready = false;

toggle_ready = function() {
	ready = !ready;
	if (ready) {
		sprite_index = sp_unready;
		var _ready_packet = {
			header: "READY",
			is_ready: true,
			sender: global.player_id
		};
		send_data(_ready_packet);
	
	} else {
		sprite_index = sp_ready;
		var _ready_packet = {
			header: "READY",
			is_ready: false,
			sender: global.player_id
		};
		send_data(_ready_packet);
	}
}
