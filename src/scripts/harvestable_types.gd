class_name  HarvestableTypes
extends Resource

@export var harvestable_bases: Dictionary[types, PackedScene]
enum types{
	BASE,
	ORANGE,
	BLACK,
}

func get_copy(type : types) ->HarvestableBase:
	var base = harvestable_bases[type].instantiate();
	return base;
