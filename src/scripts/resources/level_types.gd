class_name LevelTypes
extends Resource
var i: Level;

@export var map: Dictionary[LevelTypes.types, Level];

enum types{
	TUTORIAL,
	FIRST,
	SECOND,
	THIRD,
}
