hand_sorted = [];
hand_selected = [];
cards = [];
combo = [];
hold_time = 10;
card_width = sprite_get_width(sp_red);
card_height = sprite_get_height(sp_red);
bottom_cards_ob = [];
hand_groups = [];
played_cards = [];
card = noone;
orig_x = 0;
orig_y = 0;
card_info = {cardhandler: id};

//bottom card vars
scale = 0.75;
x1 = room_width - (card_width * scale * 3) - 16;
y1 = room_height - (card_height * scale) - 16;
x2 = room_width - x1;
y2 = room_height - y1;


draw_cards = function(arr, hand){
	var amt = array_length(arr);
	var margin = (room_width-(amt*card_width))/2;
	var y_pos = hand ? room_height-card_height-50 : room_height/3;
	for (var i = 0; i < amt; ++i) {
		if (hand) {
			var col_len = array_length(arr[i]); 
			for (var j = 0; j < col_len; ++j){
				var inst = instance_create_layer(margin+card_width*i, y_pos-30*j, "Instances", ob_card, card_info);
				inst.draw_card(arr[i][j]);
				array_push(cards, inst);
			}
		}
		else {
			var inst = instance_create_layer(margin+card_width*i, y_pos, "Instances", ob_card, card_info);
			inst.draw_card(arr[i]);
			inst.placed = true;
			array_push(played_cards, inst);
		}
	}
}

array_remove_value = function(arr, value) {
    var len = array_length(arr);
	for (var i = 0; i < len; ++i) {
	    var c = arr[i];
	    if (c[0] == value[0] && c[1] == value[1] && c[2] == value[2]) {
	        array_delete(arr, i, 1);
	        return true;
		}
	}
	return false;
}

hand_remove_selected = function() {
	for (var i = 0; i < array_length(hand_selected); ++i) {
        if (!array_remove_value(hand, hand_selected[i])) {
			for (var j =0; j < array_length(hand_groups); ++j) {
				var current_group = hand_groups[j];
				if (array_remove_value(current_group, hand_selected[i])) break;
			}
		}
    }
	hand_groups = array_filter(hand_groups, function(val) {return (array_length(val) != 0);});
}

cardarray_to_bucket = function(arr){
	var buckets = array_create(15); //2-A + 2 jokers
	for (var i = 0; i < 15; ++i) buckets[i] = [];

	// [3,4,5,6,7,8,9,T,J,Q, K, A, 2,BJ,RJ]
	// [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14]
	for (var i = 0; i < array_length(arr); ++i) {
	    var card = arr[i];
	    var val = card[0]; // enum Val
	    array_push(buckets[val], card);
	}
	return buckets;
}

sort_cards = function(arr, stack){
	var sorted = [];
	var buckets = cardarray_to_bucket(arr);

	for (var i = 0; i < 15; ++i) {
		if (array_length(buckets[i]) > 0)
			if (stack) 
				array_insert(sorted, 0, buckets[i]);
			else 
				for (var j = 0; j < array_length(buckets[i]); ++j)
					array_insert(sorted, 0, buckets[i][j]);
	}
	return sorted;
}

is_consecutive = function(arr) {
    var n = array_length(arr);
	var wrap = false;
	var consecutive = true;
	var curr = -1;
	var prev = -1;
	//assuming no wraping
	for (var i = 0; i < n; ++i){
		prev = curr;
		curr = arr[i];
		// joker check
		if (curr > Val.TWO) return false;
		if (curr == Val.TWO) {
			//assume wraping
			curr = -1;
			for (var j = 0; j < n; ++j){
				prev = curr;
				curr = arr[j];
				// joker check
				if (curr > Val.TWO) return false;
				if (curr != prev+1 && curr < Val.ACE) return false;
			}
			return true;
		}
		if (curr != prev+1 && i != 0) consecutive = false;
	}
	if (consecutive) return true;
	else return false;
}
	
find_consecutive_val = function(arr) {
	var val = -1;
	var high_ace = false;
	var prev = -1;
	var prev2 = -1;
	var ace = false
	for (var i = 0; i < array_length(arr); ++i){
		if (val < arr[i]) {
			prev2 = prev;
			prev = val;
			val = arr[i];
		}
		if (arr[i] == Val.ACE) ace = true;
		if (arr[i] == Val.ACE &&  prev == Val.KING) high_ace = true;
	}
	if (high_ace) val = Val.ACE
	if (val == Val.TWO) val = (ace) ? prev2 : prev;
	return val;
}

find_combo = function() { //[combo, highest val, length, throwaway]
	//selected nothing
	if (!array_length(hand_selected)) return [Combo.NO_COMBO, Val.THREE, 0, 0];
	
    var buckets = cardarray_to_bucket(hand_selected);
    var used_bins = [];
    var bucket_lengths = [];
	
	// Cache bucket lengths & find used bins 
	for (var i = 0; i < array_length(buckets); ++i) { 
		var len = array_length(buckets[i]); 
		bucket_lengths[i] = len; 
		if (len > 0) array_push(used_bins, i);  
	}

	// array of singles, pairs, triples, bombs
	var single = [];
	var triple = [];
	var pair = [];
	var bomb = [];
	for (var i = 0; i < array_length(used_bins); ++i){
		var len = bucket_lengths[used_bins[i]];
		if (len == 1) array_push(single, used_bins[i]);	
		else if (len == 2) array_push(pair, used_bins[i]);	
		else if (len == 3) array_push(triple, used_bins[i]);
		else array_push(bomb, used_bins[i]);
	}
	
	var single_len = array_length(single);
	var pair_len = array_length(pair);
	var triple_len = array_length(triple);
	var bomb_len = array_length(bomb);
	
	
	var val = buckets[used_bins[0]][0][0]; // enum Val
	//single
	if (single_len == 1 && pair_len == 0 && triple_len == 0 && bomb_len == 0){
		return [Combo.SINGLE, val, 1, 0];
	}
	//pair
	else if (pair_len == 1 && single_len == 0 && triple_len == 0 && bomb_len == 0){
		return [Combo.PAIR, val, 1, 0];
	}
	//triple
	else if (triple_len == 1 && bomb_len == 0){
		val = triple[0];
		//no throwaway
		if (single_len == 0 && pair_len == 0)
			return [Combo.TRIPLE, val, 1, 0];
		// single throw
		else if (single_len == 1 && pair_len == 0)
			return [Combo.TRIPLE, val, 1, 1];
		// pair throw
		else if (single_len == 0 && pair_len == 1)
			return [Combo.TRIPLE, val, 1, 2];
		else return [Combo.NO_COMBO, Val.THREE, 0, 0];
	}
	// bomb/quad
	else if (bomb_len == 1 && triple_len == 0){
		val = bomb[0];
		//bomb
		if (single_len == 0 && pair_len == 0)
			return [Combo.BOMB, val, bucket_lengths[val], 0];
		// single throw
		else if ((single_len + pair_len * 2) == 2)
			return [Combo.QUAD, val, bucket_lengths[val], 1];
		// pair throw
		else if (single_len == 0 && pair_len == 2)
			return [Combo.QUAD, val, bucket_lengths[val], 2];
		else return [Combo.NO_COMBO, Val.THREE, 0, 0];
	}
	
	//rocket
	else if (single_len == 2 && pair_len == 0 && triple_len == 0 && bomb_len == 0 && 
			bucket_lengths[Val.BLACK_JOKER] == 1 && bucket_lengths[Val.RED_JOKER] == 1){
		return [Combo.ROCKET, Val.RED_JOKER, 1, 0];
	}
	
	//straight
	else if (single_len >= 5 && pair_len == 0 && triple_len == 0 && bomb_len == 0 && is_consecutive(single)){
		return [Combo.STRAIGHT, find_consecutive_val(single), single_len, 0];
	}

	// feiji
	else if (triple_len >= 2 && bomb_len == 0 && is_consecutive(triple)) {
		// no throwaway
		if (single_len == 0 && pair_len == 0)
			return [Combo.FEIJI, find_consecutive_val(triple), triple_len, 0];
		// single throw
		else if ((single_len + pair_len * 2) == triple_len)
			return [Combo.FEIJI, find_consecutive_val(triple), triple_len, 1];
		// pair throw
		else if (single_len == 0 && pair_len == triple_len)
			return [Combo.FEIJI, find_consecutive_val(triple), triple_len, 2];
		else return [Combo.NO_COMBO, Val.THREE, 0, 0];
	}
	
	//consecutive pair
	else if (pair_len >=3 && single_len == 0 && triple_len == 0 && bomb_len == 0 && is_consecutive(pair)){
		return [Combo.CONSECUTIVE_PAIR, find_consecutive_val(pair), pair_len, 0];
	}
	//no combo
    return [Combo.NO_COMBO, Val.THREE, 0, 0];
}
	
bottom_flip = function() {
	for (var i = 0; i < 3; ++i) {
		bottom_cards_ob[i].flip = false;
		bottom_cards_ob[i].sprite_index = bottom_cards_ob[i].suit;
	}
}

refresh_hand_display = function() {
	for (var i = 0; i < array_length(cards); ++i){
			instance_destroy(cards[i]);
	}
		
	cards = [];
	hand_sorted = sort_cards(hand,true);
	
	for (var i = 0; i < array_length(hand_groups); ++i) {
        array_insert(hand_sorted, 0, hand_groups[i]);
    }
	
	hand_selected = [];
	draw_cards(hand_sorted,true);
}

refresh_hand_display();

if (global.player_id == flip_id){
	var index = 0;
	for (var i = 0; i < array_length(hand_sorted); ++i) {
		for (var j = 0; j < array_length(hand_sorted[i]); ++j) {
			if (array_equals(hand_sorted[i][j], flip_card)) {
				cards[index].flip = true;
				cards[index].sprite_index =  cards[index].back;
			}
			++index;
		}
	}
}

// draw bottom

var x_pos = room_width-(3*card_width*scale)-8
var y_pos = room_height-card_height*scale-8
for (var i = 0; i < 3; ++i) {
	var inst = instance_create_layer(x_pos+card_width*i*scale, y_pos, "Front", ob_card, card_info);
	inst.draw_card(bottom_cards[i]);
	inst.toggle_flip();
	inst.bottom = true;
	inst.image_xscale = scale;
	inst.image_yscale = scale;
	array_push(bottom_cards_ob, inst);
}





