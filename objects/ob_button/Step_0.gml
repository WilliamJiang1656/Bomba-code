if (pressed) 
	if (!position_meeting(mouse_x, mouse_y, self)){
		pressed = false;
		image_blend = c_white;
	}