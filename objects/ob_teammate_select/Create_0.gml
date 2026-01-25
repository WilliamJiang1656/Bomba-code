red_back = [];
blue_back = [];
back_cards = [];
suit_cards = [];

//draw vars
// 1. Calculate the dimensions
x1 = room_width / 2 - 200;
y1 = room_height / 2 - 300;
x2 = room_width / 2 + 200 - x1;
y2 = room_height / 2 - y1;

for (var i = 0; i < array_length(three_cards); ++i) {
    var card = three_cards[i];
    
    if (card[2] == Back.RED) array_push(red_back, card);
    else array_push(blue_back, card);
}



var amt = (array_length(red_back) > 0) + (array_length(blue_back) > 0);
var card_width = sprite_get_width(sp_red);
var card_height = sprite_get_height(sp_red);
var margin = (room_width-(amt*card_width)-(amt-1)*32)/2;
var y_pos = room_height/2 - card_height-16 - 150;

var count = 0;
if (array_length(blue_back) > 0) {
	array_push(back_cards, instance_create_layer(margin, y_pos, "Front", ob_ts_back, {sprite_index: sp_blue}));
	count = 1;
}
if (array_length(red_back) > 0) {
	array_push(back_cards, instance_create_layer(margin + count*(card_width+32), y_pos, "Front", ob_ts_back, {sprite_index: sp_red}));
	++count;
}