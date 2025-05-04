extends TileMapLayer

const _INVISIBLE_COLLIDER_ATLAS_COORIDNATES := Vector2i(7,0);
const _WHITE_FLOOR_ATLAS_COORIDNATES:= Vector2i(3,0);


var platform_radius: int;

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
	_place_boundries();


func _ready() -> void:
	setup(8);
	pass

func _place_boundries()->void:
	var offsets = [
		Vector2i(0,1),
		Vector2i(0,-1),
		Vector2i(1,0),
		Vector2i(-1,0),
	];
	var used = get_used_cells();
	for spot in used:
		for offset in offsets:
			var current_spot = spot+offset;
			if get_cell_source_id(current_spot) == -1:
				set_cell(current_spot,0,_INVISIBLE_COLLIDER_ATLAS_COORIDNATES);
				
