var top_instance = instance_position(mouse_x, mouse_y, object_index);

if (id != top_instance) exit;

if (!bottom) {
	alarm[0] = -1;
	toggle_flip();
	x = orig_x;
	y = orig_y;
}
