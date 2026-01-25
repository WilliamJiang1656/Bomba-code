var top_instance = instance_position(mouse_x, mouse_y, object_index);

if (id != top_instance) exit;

if (alarm[0] > 0 && !bottom) {
	var factor = (hold_time - alarm[0])/hold_time/16;
	image_xscale = 1 + factor;
	image_yscale = 1 + factor;
		
	var width_diff = (sprite_width * factor) / 2;
    var height_diff = (sprite_height * factor) / 2;
        
    x = orig_x - width_diff;
    y = orig_y - height_diff;
}