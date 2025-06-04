class_name LevelTypes
extends Resource
var i: Level;

@export var map: Dictionary[LevelTypes.types, Level];
@export var sprite_map: Dictionary[LevelTypes.types, Texture];

enum types{
	TUTORIAL,
	FIRST,
	SECOND,
	THIRD,
}
