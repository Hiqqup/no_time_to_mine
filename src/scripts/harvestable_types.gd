class_name  HarvestableTypes
extends Node

@export var harvestable_bases: Dictionary[types, HarvestableBase]
enum types{
	BASE,
	ORANGE,
	BLACK,
}

func _ready() -> void:
	$Biome1.position.x = 5000.0;

func get_copy(type : types) ->HarvestableBase:
	var base = harvestable_bases[type].duplicate();
	base.visible = true;
	return base;
