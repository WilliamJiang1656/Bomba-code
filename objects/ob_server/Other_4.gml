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
	namehandler.is_turn[(global.turn - global.player_id + 5) % 5] = true;
	toggle_button(global.turn, 2);
	
	//rejoin initialization
	if (is_undefined(start_flip_card)) {
		cardhandler.bottom_flip();
		namehandler.is_landlord[(global.landlord_id[0] - global.player_id + 5) % 5] = true;
		if (global.landlord_id[1] == global.player_id) namehandler.is_teammate[0] = true;
		cardhandler.draw_cards(start_played_cards,false);
	}

}
scr_resize_browser();