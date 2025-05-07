extends Node

var contents: Dictionary[ItemTypes.types, int]

func _ready() -> void:
	for i in ItemTypes.types.size():
		contents[i] = 0;

func is_empty()->bool:
	var ret: bool = true;
	for i in ItemTypes.types.size():
		if contents[i] != 0:
			ret = false;
	return ret;
