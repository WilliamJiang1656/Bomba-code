if (room == rm_game) {
	
	var init = {
		hand: start_hand,
		bottom_cards: start_bottom_cards,
		flip_id: start_flip_id,
		flip_card: start_flip_card,
		table_combo: start_table_combo
	}
    cardhandler  = instance_create_layer(0, 0, "Instances", ob_cardhandler, init);
	namehandler  = instance_create_layer(0, 0, "Instances", ob_name);
	namehandler.is_turn[global.turn] = true;
	
	if (global.turn == global.player_id) {
		if (landlord_phase) toggle_button(global.turn, 2);
		else if (global.player_id == last_play_id) toggle_button(global.turn, 1);
		else toggle_button(global.turn, 0);
	}
	
	//rejoin initialization
	if (is_undefined(start_flip_card)) {	
		if (array_length(global.landlord_id) > 0){
			cardhandler.bottom_flip();
			namehandler.is_landlord[global.landlord_id[0]] = true;
			if (global.landlord_id[1] == global.player_id) namehandler.is_landlord[global.player_id] = true;
		}
		cardhandler.draw_cards(start_played_cards,false);
		namehandler.update_exit_order(exit_order);
	}

}
scr_resize_browser();