if (pressed){
	image_blend = c_white;
	pressed = false;
	var _pass_packet = {
		header: "PASS",
	};
	send_data(_pass_packet);
}