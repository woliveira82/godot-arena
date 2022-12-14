extends Control


onready var empty_hearts = $EmptyHeart
onready var full_hearts = $FullHeart


var hearts setget set_hearts
var max_hearts setget set_max_hearts


func set_hearts(value: int):
	hearts = clamp(value, 0, max_hearts)
	full_hearts.rect_size.x = hearts * 8


func set_max_hearts(value: int):
	max_hearts = max(value, 1)
	hearts = max_hearts
	empty_hearts.rect_size.x = max_hearts * 8
