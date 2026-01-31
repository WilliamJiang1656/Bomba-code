if (!flip) {
    var c = (suit_val == Suit.HEART || suit_val == Suit.DIAMOND) ? c_red : c_black;
    draw_text_color(x + 2, y - 2, global.val_to_string[val], c, c, c, c, 1);
}