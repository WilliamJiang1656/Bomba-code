var _type = async_load[? "type"];


if (_type == network_type_data) {
    // 1. Get the buffer from the event
    var _buf = async_load[? "buffer"];
    
    // 2. Read the string out of the buffer
    var _json = buffer_read(_buf, buffer_string);
    
    // 3. Convert JSON string back into a GameMaker Struct
    var _data = json_parse(_json);
    
    // 4. Act on the data
    if (_data.header == "PLAY_CARDS") { //combo[combo,rank, length, throwaways]
        array_push(global.log, global.player_names[_data.sender] + " played " + global.combo_to_string[_data.combo[0]]);
		
		for (var i = 0; i < array_length(cardhandler.played_cards); ++i){
			instance_destroy(cardhandler.played_cards[i]);
		}
		cardhandler.played_cards = [];
		cardhandler.draw_cards(_data.cards,false);
		
		last_play_id = _data.sender;
		
		cardhandler.table_combo = _data.combo;
		
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
		
		
    }
	else if (_data.header == "PASS") {
		global.turn = skip_exited(global.turn);
		array_push(global.log,global.player_names[_data.sender] + " passes");
		
		if (global.turn == last_play_id) {
			for (var i = 0; i < array_length(cardhandler.played_cards); ++i){
				instance_destroy(cardhandler.played_cards[i]);
			}
			cardhandler.played_cards = [];
			cardhandler.table_combo = [Combo.NO_COMBO, Val.THREE, 0, 0];
			toggle_button(global.turn, 1);
			array_push(global.log,global.player_names[last_play_id] + " won the round and starts");
		} else if (landlord_phase) toggle_button(global.turn, 2)
		else toggle_button(global.turn, 0);
	}
	else if (_data.header == "WELCOME") {
        global.player_id = _data.assigned_id;
		start = _data.start;
    }
	else if (_data.header == "LOG") {
		array_push(global.log, global.player_names[_data.sender] + ": " + _data.message);
	}
	else if (_data.header == "PLAYER_JOINED") {
	    //write new player name
	    global.player_names[_data.sender] = _data.name;
	    array_push(global.log, _data.name + " joined the game!");
		
		if (global.player_id == _data.sender) {
			if (start) room_goto(rm_game);
			else room_goto(rm_lobby);
		}

	   // send name back
	    var _reply_packet = {
	        header: "NAME_UPDATE",
	        name: global.player_name
	    };
	    send_data(_reply_packet);
	}

	else if (_data.header == "NAME_UPDATE") {
	    global.player_names[_data.sender] = _data.name;
	}
	else if (_data.header == "READY") {
		if (_data.is_ready)
			array_push(global.log, global.player_names[_data.sender] + " is ready!");
		else 
			array_push(global.log, global.player_names[_data.sender] + " unreadied");
	}
	else if (_data.header == "LANDLORD") {
		array_push(global.landlord_id, _data.sender);
		array_push(global.log, global.player_names[global.landlord_id[0]] + " is the landlord");
		toggle_button(-1,-1);
		cardhandler.bottom_flip();
		namehandler.is_landlord[_data.sender] = true;
	}
	else if (_data.header == "TEAMMATE") {
		array_push(global.log, "3 " + global.suit_to_string[_data.teammate[1]] + " with "
		+ global.back_to_string[_data.teammate[2]] + " back is the teammate");
		toggle_button(global.turn,1);
	}
	else if (_data.header == "FOUND_TEAMMATE") {
		array_push(global.landlord_id, _data.sender);
		if (_data.sender == global.player_id) namehandler.is_landlord[global.player_id] = true;
		landlord_phase = false;
	}
	else if (_data.header == "START_GAME") {
		room_goto(rm_game);
		start_flip_card = _data.flip_card;
		start_flip_id = _data.flip_id;
		start_bottom_cards = _data.bottom_cards;
		start_hand = _data.hand;
		start_played_cards = [];
		start_table_combo = [Combo.NO_COMBO, Val.THREE, 0, 0];
		global.turn = start_flip_id
		array_push(global.log, global.player_names[start_flip_id] + " got the flipped card " 
		+ global.val_to_string[start_flip_card[0]] + " " + global.suit_to_string[start_flip_card[1]] 
		+ " with " + global.back_to_string[start_flip_card[2]] + " back");

		landlord_phase = true;
		
		last_play_id = undefined;
		exit_order = [];
		global.landlord_id = [];
		landlord_points = 0;
		peasant_points = 0;
	}
	else if (_data.header == "EXIT") {
		array_push(exit_order, _data.sender);
		
		last_play_id = skip_exited(last_play_id);
		namehandler.update_exit_order(exit_order)
		
		if (array_contains(global.landlord_id, _data.sender))
			landlord_points += (5-array_length(exit_order));
		else peasant_points += (5-array_length(exit_order));
		
		array_push(global.log, global.player_names[_data.sender] + " exited");
		if (landlord_points >= 5 || peasant_points >= 6){
			if (landlord_points >= 5) {
				array_push(global.log, "Landlords win");
				room_goto(rm_lobby);
			}
			else if (peasant_points >= 6) {
				array_push(global.log, "Peasants win");
				room_goto(rm_lobby);
			}
		
			var _lobby_packet = {
		        header: "LOBBY",
		    };
		    send_data(_lobby_packet);
		}
	}
	else if (_data.header == "REJOIN") {	
		start_flip_card = undefined;
		start_flip_id = undefined;
		
		start_bottom_cards = _data.bottom_cards;
		start_hand = _data.hand;
		start_played_cards = _data.played_cards;
		start_table_combo = _data.combo;
		
		global.landlord_id = _data.landlord;
		exit_order = _data.exit_order;
		
		// single nums
		global.turn = _data.turn;
		last_play_id = _data.last_play_id;
		landlord_points = _data.landlord_points;
		peasant_points = _data.peasant_points;
		
		landlord_phase = _data.landlord_phase;	
	}
}