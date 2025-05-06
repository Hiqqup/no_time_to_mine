class_name MineFloor
extends TileMapLayer

const _INVISIBLE_COLLIDER_ATLAS_COORIDNATES := Vector2i(7,0);
const _WHITE_FLOOR_ATLAS_COORIDNATES:= Vector2i(3,0);


var platform_radius: int;
var used: Dictionary[Vector2i, bool]

func setup(radius: int):
	var offsets = [
		Vector2i(1,1),
		Vector2i(-1,1),
		Vector2i(1,-1),
		Vector2i(-1,-1),
	];
	platform_radius = radius
	for i in radius:
		for j in radius:
			for offset in offsets:
				set_cell(Vector2i(i,j) * offset, 0, _WHITE_FLOOR_ATLAS_COORIDNATES)
				used[Vector2i(i,j) * offset] = false
	used[Vector2i.ZERO ] =true; # the player is there
	_place_boundries();


func get_random_free_spot():
	var random_pos = used.keys()[randi_range(0, used.size()-1)]
	if used[random_pos] :
		return get_random_free_spot();
	return random_pos;


func _ready() -> void:
	setup(5);
	pass

func _place_boundries()->void:
	var offsets = [
		Vector2i(0,1),
		Vector2i(0,-1),
		Vector2i(1,0),
		Vector2i(-1,0),
	];
	var _used = get_used_cells();
	for spot in _used:
		for offset in offsets:
			var current_spot = spot+offset;
			if get_cell_source_id(current_spot) == -1:
				set_cell(current_spot,0,_INVISIBLE_COLLIDER_ATLAS_COORIDNATES);
				
