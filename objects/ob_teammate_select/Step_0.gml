if (mouse_check_button_pressed(mb_left)) {
    back = instance_position(mouse_x, mouse_y, ob_ts_back);
	if (back != noone) {
		back_cards[0].image_blend = c_white;
		back_cards[1].image_blend = c_white;
		back.image_blend = c_gray;
		back_color = (back.sprite_index == sp_red);
		var amt = (back_color) ? array_length(red_back) : array_length(blue_back);
		var card_width = sprite_get_width(sp_red);
		var card_height = sprite_get_height(sp_red);
		var margin = (room_width-(amt*card_width)-(amt-1)*32)/2;
		var y_pos = room_height/2 + 16 - 150;
			
		for (var i = 0; i < array_length(suit_cards); ++i)
			instance_destroy(suit_cards[i]);
		suit_cards = [];
			
		if (back_color) 
			for (var i = 0; i < array_length(red_back); ++i) 
				array_push(suit_cards, instance_create_layer(margin + i*(card_width+32), y_pos, "Front", ob_ts_suit, {suit_val: red_back[i][1]}));
		else 
			for (var i = 0; i < array_length(blue_back); ++i) 
				array_push(suit_cards, instance_create_layer(margin + i*(card_width+32), y_pos, "Front", ob_ts_suit, {suit_val: blue_back[i][1]}));
	}
	
	suit = instance_position(mouse_x, mouse_y, ob_ts_suit);
	if (suit != noone) {
		var _teammate_packet = {
			header: "TEAMMATE",
			teammate: [Val.THREE, suit.suit_val, back_color]
		};
		send_data(_teammate_packet);
		
		for (var i = 0; i < array_length(suit_cards); ++i)
			instance_destroy(suit_cards[i]);
		for (var i = 0; i < array_length(back_cards); ++i)
			instance_destroy(back_cards[i]);
		instance_destroy();
			
	}
}
	