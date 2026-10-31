enum Val {
    THREE,
    FOUR,
    FIVE,
    SIX,
    SEVEN,
    EIGHT,
    NINE,
    TEN,
    JACK,
    QUEEN,
    KING,
    ACE,
    TWO,
    BLACK_JOKER,
    RED_JOKER
}

global.val_to_string = [
    "3", "4", "5", "6", "7", "8", "9", "10",
    "J", "Q", "K", "A", "2", "Joker", "Joker"
];

enum Suit {
	SPADE,
	CLUB,
	HEART,
	DIAMOND
}

global.suit_to_string = [
	"Spade", "Club", "Heart", "Diamond"
]

enum Combo {
    NO_COMBO,//0
    SINGLE,//1
    PAIR,//2
    TRIPLE,//3
    BOMB,//4
	QUAD,//5
	ROCKET,//6
	STRAIGHT,//7
	CONSECUTIVE_PAIR,//8
	FEIJI//9
}

global.combo_to_string = [
	"No combo", "single", "pair", "triple", "bomba", "quad", "rocket", "straight", "consecutive pair", "feiji"
]

enum Back {
	BLUE,
	RED
}

global.back_to_string = [
	"blue", "red"
]