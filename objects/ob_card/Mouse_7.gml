var top_instance = instance_position(mouse_x, mouse_y, object_index);

if (id != top_instance) exit;

if (alarm[0] > 0) {
	alarm[0] = -1;
	if (!placed) {
		var card_data = [val, suit_val, back_val];
		toggle_select();
		if (selected) array_push(cardhandler.hand_selected, card_data);
		else cardhandler.array_remove_value(cardhandler.hand_selected, card_data);
	}
	image_xscale = 1;
	image_yscale = 1;
	x = orig_x;
	y = orig_y;
}