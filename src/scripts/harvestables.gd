extends TileMapLayer

func _ready() -> void:
	var used = get_used_cells();
	for spot in used:
		var scene: PackedScene = get_cell_tile_data(spot).get_custom_data("scene");
		if scene == null: 
			print("could not find scene");
			return;
		var node : HarvestableBase = scene.instantiate();
		node.get_node("GridVectorToPositionConverter").set_grid_vector(spot);
		add_child(node);
		erase_cell(spot);
		
