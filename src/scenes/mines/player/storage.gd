extends Node

var contents: Dictionary[ItemTypes.types, int]

func _ready() -> void:
	for i in ItemTypes.types.size():
		contents[i] = 0;
