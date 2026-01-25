selected = false;
placed = false;
flip = false;
bottom = false
orig_x = x;
orig_y = y;
hold_time = 10;

draw_card = function(card) {
    val = card[0];
    suit_val = card[1];
	back_val = card[2];

    if (val == Val.BLACK_JOKER || val == Val.RED_JOKER) {
        suit = (val == Val.BLACK_JOKER) ? sp_bj : sp_rj;
    } else {
        if (suit_val == Suit.SPADE) suit = sp_spade;
		else if (suit_val == Suit.CLUB) suit = sp_club;
		else if (suit_val == Suit.HEART) suit = sp_heart;
		else suit = sp_diamond;
    }
	
	back   = back_val ? sp_red : sp_blue;
	sprite_index = suit;
};

toggle_select = function(){
	if (!bottom) {
		selected = !selected;
		if (selected) image_blend = c_gray;
		else image_blend = c_white;
	}
}

toggle_flip = function() {
	if (!bottom) {
		flip = !flip;
		sprite_index = flip ? back : suit;
		image_xscale = 1;
		image_yscale = 1;
	}
}
