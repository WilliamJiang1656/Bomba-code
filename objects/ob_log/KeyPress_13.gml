if string_length(keyboard_string) > 0 {
	var _log_packet = {
	    header: "LOG",
		message: keyboard_string
	};
	send_data(_log_packet);
	keyboard_string = "";
}