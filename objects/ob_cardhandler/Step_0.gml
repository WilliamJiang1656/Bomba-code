if (global.play_pressed) {
	global.play_pressed = false;
	if (array_length(hand_selected) == 0) return;
	//[combo, highest val, length, throwaway]
	combo = find_combo();
	
	var is_start_play   = (table_combo[0] == Combo.NO_COMBO && combo[0] != Combo.NO_COMBO);
	var is_higher_value = (table_combo[0] == combo[0] && table_combo[1] < combo[1] && table_combo[2] == combo[2] && table_combo[3] == combo[3]);
	
	var table_has_bomb  = (table_combo[0] == Combo.BOMB || table_combo[0] == Combo.ROCKET);
	var play_is_bomb    = (combo[0] == Combo.BOMB || combo[0] == Combo.ROCKET);
	
	//bomb
	var bomb_over_normal = (!table_has_bomb && play_is_bomb);
	var rocket_over_bomb = (table_combo[0] == Combo.BOMB && combo[0] == Combo.ROCKET && combo[2] == 4);
	var big_bomb_over_rocket = (table_combo[0] == Combo.ROCKET && combo[0] == Combo.BOMB && combo[2] >= 5);
	var bigger_bomb_over_bomb = (combo[0] == Combo.BOMB && table_combo[0] == Combo.BOMB && combo[2] > table_combo[2]);


	if (is_start_play || is_higher_value || bomb_over_normal || rocket_over_bomb || big_bomb_over_rocket || bigger_bomb_over_bomb) {
		hand_selected = sort_cards(hand_selected, false);
		var _card_packet = {
			header: "PLAY_CARDS",
			cards: hand_selected,
			combo: combo
		};
		send_data(_card_packet);
		
		hand_remove_selected();
		refresh_hand_display();
	}

}
	
else if (global.take_pressed) {
	global.take_pressed = false;
	
	var _landlord_packet = {
			header: "LANDLORD",
	};
	send_data(_landlord_packet);
	
	
	for (var i = 0; i < 3; ++i) {
		array_push(hand, bottom_cards[i]);
	}
	
	refresh_hand_display();
	
	three_cards_owned = array_last(hand_sorted);
	
	three_cards = [];
	for (var i = 0; i < 4; ++i) { // Suits
	    for (var j = 0; j < 2; ++j) { // Backs
	        var three_card = [Val.THREE, i, j];
	        var is_owned = false;
        
	        for (var k = 0; k < array_length(three_cards_owned); ++k)
	            if (array_equals(three_card, three_cards_owned[k])) {
	                is_owned = true;
	                break;
	            }
        
	        if (!is_owned)
	            array_push(three_cards, three_card);
	    }
	}
	
	instance_create_layer(0,0,"Instances", ob_teammate_select, {three_cards: three_cards})
}
else if (global.group_pressed) {
	global.group_pressed = false;
	if (array_length(hand_selected) == 0) return;

    hand_remove_selected();
	array_push(hand_groups, sort_cards(hand_selected, false));
	refresh_hand_display();
}

 else if (global.ungroup_pressed) {
    global.ungroup_pressed = false;
    if (array_length(hand_selected) == 0) return;

	for (var i = 0; i < array_length(hand_selected); ++i) {
		for (var j =0; j < array_length(hand_groups); ++j) {
			if (array_length(hand_groups[j]) == 0) continue;
			
			var current_group = hand_groups[j];
			var found = false;
			for (var k = 0; k < array_length(current_group); ++k) {
				if (string(current_group[k]) == string(hand_selected[i])) {
					hand = array_concat(hand, current_group);
					hand_groups[j] = [];
					found = true;
                    break;
                }
            }
			if (found) break;
		}
	}
	hand_groups = array_filter(hand_groups, function(val) {return (array_length(val) != 0);});
	refresh_hand_display();
	
} 