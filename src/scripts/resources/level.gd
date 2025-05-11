class_name Level;
extends Resource

enum levels{
	TUTORIAL,
	FIRST,
	SECOND,
}

@export var platform_radius: int;
@export var harvestables: Dictionary[HarvestableTypes.types, int];
