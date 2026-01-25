var _log_packet = {
    header: "LOG",
	message: keyboard_string
};
send_data(_log_packet);
keyboard_string = "";