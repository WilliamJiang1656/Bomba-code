keyboard_string = "";
length = floor((room_height/1.5)/ 25);

//draw vars
w = 500;
h = 25 * (length + 2);

if (room = rm_lobby) {
	open = true;
	image_yscale = -1;
	image_alpha = .5;
} else open = false;

toggle_open = function() {
	open = !open;
		if (open) {
			image_yscale = -1;
			keyboard_string = "";
			image_alpha = .5;
		} else {
			image_yscale = 1;
			image_alpha = 1;
		}
}