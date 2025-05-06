extends TileMapLayer


@export var floor_layer: MineFloor;

const _OFFSETS = [
		Vector2i(1,1),
		Vector2i(-1,1),
		Vector2i(1,-1),
		Vector2i(-1,-1),
	];


var _harvestable_types;


func _ready() -> void:
	_harvestable_types = get_tree().get_first_node_in_group("harvestable_types");
	generate_cells({
		HarvestableTypes.types.ORANGE: 6,
		HarvestableTypes.types.BLACK: 4,
	});
	_convert_used_cells();

func generate_cells(amount: Dictionary[HarvestableTypes.types, int]):
	for type in amount.keys():
		for i in amount[type]:
			_generate_one_cell_of_type(type);
	pass;

func _generate_one_cell_of_type(type: HarvestableTypes.types):
	var base = _harvestable_types.get_copy(type);
	var pos =floor_layer.get_random_free_spot();
	floor_layer.used[pos] = true;
	base.get_node("GridVectorToPositionConverter").set_grid_vector(pos);
	add_child(base);


func _convert_used_cells():
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
		
