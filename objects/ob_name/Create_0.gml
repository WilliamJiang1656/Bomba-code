//self, right, top right, top left, leftt
names = [];
is_turn = [0,0,0,0,0];
is_landlord = [0,0,0,0,0];
exit_order = [0,0,0,0,0];
exit_size = [[0,0],[0,0],[0,0],[0,0],[0,0]]

var num_id = global.player_id;
for (var i = 0; i < 5; ++i) {
	array_push(names,global.player_names[num_id]);
	num_id = (num_id + 1) % 5;
}
pfp_width = 128;

locations = [
	[32, 736, 32+string_width(names[0]), 736+string_height(names[0])],
	[1344-string_width(names[1]), 448, 1344, 448+string_height(names[1])],
	[960, 0, 960+string_width(names[2]), 0+string_height(names[2])],
	[320, 0, 320+string_width(names[3]), 0+string_height(names[3])],
	[32, 448, 32+string_width(names[4]), 448+string_height(names[4])]
];

locations_pfp = [
	[32, 608],
	[1216, 320],
	[832, 0],
	[192, 0],
	[32, 320]
];

repeat(global.player_id) {
    var last_val = locations[4];
    array_delete(locations, 4, 1);
    array_insert(locations, 0, last_val);

    last_val = locations_pfp[4];
    array_delete(locations_pfp, 4, 1);
    
    array_insert(locations_pfp, 0, last_val);
}

update_exit_order = function(arr) {
	for (var i = 0; i < array_length(arr); ++i) {
		if (exit_order[arr[i]] > 0) continue;
		exit_order[arr[i]] = i+1;
		exit_size[arr[i]][0] = string_width(string(i+1));
		exit_size[arr[i]][1] = string_height(string(i+1));
	}
}