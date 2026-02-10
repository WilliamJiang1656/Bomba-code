//initialize all global vars
global.player_id = undefined;
global.log = [];
global.player_name = "";
global.play_pressed = false;
global.take_pressed = false;
global.group_pressed = false;
global.ungroup_pressed = false;
start = false;
global.player_names = ["William","Tony","Phillip","Kai","Andrew"]
global.turn = undefined;
last_play_id = undefined;
exit_order = [];
global.landlord_id = [];
landlord_phase = false;
landlord_points = 0;
peasant_points = 0;

// 2. Create the socket
network_socket = network_create_socket(network_socket_wss);

// 3. Set a timeout (give it 5 seconds to try)
network_set_config(network_config_connect_timeout, 5000);

// 4. IMPORTANT: The domain MUST NOT have any slashes or protocols
var url = "previous-kinna-bombaboys-48c33a4c.koyeb.app"; 

// 5. Use the RAW async connect
// We use 443 because PieSocket proved that's where the WSS lives
connect_id = network_connect_raw_async(network_socket, url, 443);

play_button = noone;
pass_button = noone;
take_button = noone;

toggle_button = function(turn, set) { //pass & play, play, pass & take
    if (turn == global.player_id) {
        if (!instance_exists(play_button) && (set == 0 || set == 1)) {
            play_button = instance_create_layer(928, 416, "Instances", ob_play);
        }
        if (!instance_exists(pass_button) && (set == 0 || set == 2)) {
            pass_button = instance_create_layer(704, 416, "Instances", ob_pass);
        }
		if (!instance_exists(take_button) && (set == 2)) {
            take_button = instance_create_layer(928, 416, "Instances", ob_take);
        }
    } else {
		play_button = delete_button(play_button);
        pass_button = delete_button(pass_button);
        take_button = delete_button(take_button);
    }
}

delete_button = function(button_id) {
    if (instance_exists(button_id)) {
        instance_destroy(button_id);
    }
    return noone;
}

skip_exited = function(val) {
	//namehandler.is_turn[(val - global.player_id + 5) % 5] = false;
	namehandler.is_turn[val] = false;
	val = (val + 1) % 5;
	while (array_contains(exit_order, val)) {
        val = (val + 1) % 5;
    }
	//namehandler.is_turn[(val - global.player_id + 5) % 5] = true;
	namehandler.is_turn[val] = true;
	return val;
}

exception_unhandled_handler(function(ex) {
    // This code runs when the game crashes!
    var _crash_report = "--- GAME CRASHED ---\n";
    _crash_report += "Message: " + string(ex.message) + "\n";
    _crash_report += "Long Message: " + string(ex.longMessage) + "\n";
    _crash_report += "Script: " + string(ex.script) + "\n";
    _crash_report += "Stack Trace: " + string(ex.stacktrace) + "\n";

    // Show it on screen so the player can screenshot it
    show_message(_crash_report);

    // Optional: Return 1 to show the standard GM error, 
    // or return 0 to just let the game close quietly.
    return 1;
});