if (pressed) 
	if (!position_meeting(mouse_x, mouse_y, self)){
		pressed = false;
		image_blend = c_white;
	}
	
var base64_string = html_get_pending_pfp();

if (base64_string != "") {
	var _pfp_packet = {
		header: "PFP",
		pfp: base64_string
	};
	send_data(_pfp_packet);
}