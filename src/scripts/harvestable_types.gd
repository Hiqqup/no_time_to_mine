class_name  HarvestableTypes
extends Resource

@export var map: Dictionary[types, PackedScene]
enum types{
	BASE,
	ORANGE,
	BLACK,
}

func get_copy(type : types) ->HarvestableBase:
	var base = map[type].instantiate();
	return base;
