//initialize all global vars
global.player_id = 0;
global.log = [];
global.player_name = "";
global.play_pressed = false;
global.take_pressed = false;
global.group_pressed = false;
global.ungroup_pressed = false;
global.start = false;
global.player_names = ["William","Tony","Phillip","Kai","Andrew"]
global.turn = 0;
global.last_play_id = -1;
global.exit_order = [];
global.landlord_id = [];
global.pfp = [noone, noone, noone, noone, noone];
global.landlord_phase = false;
global.landlord_points = 0;
global.peasant_points = 0;

//start game varibles
global.start_played_cards = [];
global.start_flip_card = undefined;
global.start_flip_id = undefined;
global.start_bottom_cards = undefined;
global.start_hand = undefined;
global.start_table_combo = [0,0,0,0];
global.teammate_card = [];

// network setup
network_socket = network_create_socket(network_socket_wss);
network_set_config(network_config_connect_timeout, 5000);
var url = "previous-kinna-bombaboys-48c33a4c.koyeb.app"; 
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
		
		// play sound
		audio_play_sound(so_turn,100,0,1)
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
	while (array_contains(global.exit_order, val)) {
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

net_handlers = {
	"PLAY_CARDS": function(_data) { //combo[combo, rank, length, throwaways]
		var card_nums = "";
		for (var i = 0; i < array_length(_data.cards); ++i) {
			card_nums += global.val_to_string[_data.cards[i][0]];
		}
		
        array_push(global.log, global.player_names[_data.sender] + " played " + global.combo_to_string[_data.combo[0]] + ": " + card_nums);
		
		for (var i = 0; i < array_length(cardhandler.played_cards); ++i){
			instance_destroy(cardhandler.played_cards[i]);
		}
		cardhandler.played_cards = [];
		cardhandler.draw_cards(_data.cards,false);
		
		global.last_play_id = _data.sender;
		
		cardhandler.table_combo = _data.combo;
		
		//uno
		if (_data.cards_amt == 1)
			array_push(global.log, global.player_names[_data.sender] + " is uno");
		
		// exiting
		if (array_length(cardhandler.hand) + array_length(cardhandler.hand_groups)== 0 && _data.sender == global.player_id) {
			var _exit_packet = {
		        header: "EXIT",
		    };
		    send_data(_exit_packet);
		}
		// code for next person's turn
		global.turn = skip_exited(global.turn);
		toggle_button(global.turn, 0);
		
		// play sounds
		if (_data.combo[0] == Combo.BOMB || _data.combo[0] == Combo.ROCKET){
			audio_play_sound(so_bomb,100,0,1);
		}
	},
	
	"PASS": function(_data) {
		global.turn = skip_exited(global.turn);
		array_push(global.log,global.player_names[_data.sender] + " passes");
		
		if (global.turn == global.last_play_id) {
			for (var i = 0; i < array_length(cardhandler.played_cards); ++i){
				instance_destroy(cardhandler.played_cards[i]);
			}
			cardhandler.played_cards = [];
			cardhandler.table_combo = [Combo.NO_COMBO, Val.THREE, 0, 0];
			toggle_button(global.turn, 1);
			array_push(global.log,global.player_names[global.last_play_id] + " won the round and starts");
		} else if (global.landlord_phase) toggle_button(global.turn, 2);
		else toggle_button(global.turn, 0);
	},
	
	"WELCOME": function(_data) {
		show_debug_message(_data.pfp)
		//pfp loader
		for (var i = 0; i<5; ++i){
			pfp_info = {player: i, base64_string: _data.pfp[i]};
			instance_create_layer(0,0,"Instances", ob_pfp_loader, pfp_info);
		}
		
        global.player_id = _data.assigned_id;
		global.start = _data.start;
    },
	
	"LOG": function(_data) {
		array_push(global.log, global.player_names[_data.sender] + ": " + _data.message);
	},
	
	"PLAYER_JOINED": function(_data) {
	    //write new player name
	    global.player_names[_data.sender] = _data.name;
	    array_push(global.log, _data.name + " joined the game!");
		
		if (global.player_id == _data.sender) {
			if (global.start) room_goto(rm_game);
			else room_goto(rm_lobby);
		}

	   // send name back
	    var _reply_packet = {
	        header: "NAME_UPDATE",
	        name: global.player_name
	    };
	    send_data(_reply_packet);
	},

	"NAME_UPDATE": function(_data) {
	    global.player_names[_data.sender] = _data.name;
		//if object_exists(namehandler) namehandler.update_names();
	},
	
	"READY": function(_data) {
		if (_data.is_ready)
			array_push(global.log, global.player_names[_data.sender] + " is ready!");
		else 
			array_push(global.log, global.player_names[_data.sender] + " unreadied");
	},
	
	"PFP": function(_data) {
		pfp_info = {player: _data.sender, base64_string: _data.pfp};
		instance_create_layer(0,0,"Instances", ob_pfp_loader, pfp_info);
	},
	
	"LANDLORD": function(_data) {
		array_push(global.landlord_id, _data.sender);
		array_push(global.log, global.player_names[global.landlord_id[0]] + " is the landlord");
		toggle_button(-1,-1);
		cardhandler.bottom_flip();
		namehandler.is_landlord[_data.sender] = true;
	},
	
	"TEAMMATE": function(_data) {
		array_push(global.log, "3 " + global.suit_to_string[_data.teammate[1]] + " with "
		+ global.back_to_string[_data.teammate[2]] + " back is the teammate");
		toggle_button(global.turn,1);
		cardhandler.draw_teammate(_data.teammate);
		
	},
	
	"FOUND_TEAMMATE": function(_data) {
		array_push(global.landlord_id, _data.sender);
		if (_data.sender == global.player_id) namehandler.is_landlord[global.player_id] = true;
		global.landlord_phase = false;
	},
	
	"START_GAME": function(_data) {
		room_goto(rm_game);
		global.start_flip_card = _data.flip_card;
		global.start_flip_id = _data.flip_id;
		global.start_bottom_cards = _data.bottom_cards;
		global.start_hand = _data.hand;
		global.start_played_cards = [];
		global.start_table_combo = [Combo.NO_COMBO, Val.THREE, 0, 0];
		global.turn = global.start_flip_id;
		array_push(global.log, global.player_names[global.start_flip_id] + " got the flipped card " 
		+ global.val_to_string[global.start_flip_card[0]] + " " + global.suit_to_string[global.start_flip_card[1]] 
		+ " with " + global.back_to_string[global.start_flip_card[2]] + " back");

		global.landlord_phase = true;
		
		global.last_play_id = undefined;
		global.exit_order = [];
		global.landlord_id = [];
		global.landlord_points = 0;
		global.peasant_points = 0;
	},
	
	"EXIT": function(_data) {
		array_push(global.exit_order, _data.sender);
		
		global.last_play_id = skip_exited(global.last_play_id);
		namehandler.update_exit_order(global.exit_order);
		
		if (array_contains(global.landlord_id, _data.sender))
			global.landlord_points += (5-array_length(global.exit_order));
		else global.peasant_points += (5-array_length(global.exit_order));
		
		array_push(global.log, global.player_names[_data.sender] + " exited");
		if (global.landlord_points >= 5 || global.peasant_points >= 6){
			var win = false
			if (global.landlord_points >= 5) {
				array_push(global.log, "Landlords win");
				if (array_contains(global.landlord_id,global.player_id)) win = true;
				room_goto(rm_lobby);
				
			}
			else if (global.peasant_points >= 6) {
				array_push(global.log, "Peasants win");
				if (!array_contains(global.landlord_id,global.player_id)) win = true;
				room_goto(rm_lobby);
			}
			
			// play sound
			if (win) audio_play_sound(so_victory,100,0,1);
			else audio_play_sound(so_lose,100,0,1);
		
			var _lobby_packet = {
		        header: "LOBBY",
		    };
		    send_data(_lobby_packet);
		}
	},
	
	"REJOIN": function(_data) {	
		global.start_flip_card = undefined;
		global.start_flip_id = undefined;
		
		global.start_bottom_cards = _data.bottom_cards;
		global.start_hand = _data.hand;
		global.start_played_cards = _data.played_cards;
		global.start_table_combo = _data.combo;
		
		global.landlord_id = _data.landlord;
		global.exit_order = _data.exit_order;
		global.teammate_card = _data.teammate_card;
		
		// single nums
		global.turn = _data.turn;
		global.last_play_id = _data.last_play_id;
		global.landlord_points = _data.landlord_points;
		global.peasant_points = _data.peasant_points;
		
		global.landlord_phase = _data.landlord_phase;	
	}
}
	