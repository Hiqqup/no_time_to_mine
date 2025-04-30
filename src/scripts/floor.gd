extends TileMapLayer

const _INVISIBLE_COLLIDER_ATLAS_COORIDNATES = Vector2i(7,0);


func _ready() -> void:
	_place_boundries();

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
				
