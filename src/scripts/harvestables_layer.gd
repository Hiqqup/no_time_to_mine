extends TileMapLayer


signal emptyed;

@export var floor_layer: MineFloor;
@export var _harvestable_types: HarvestableTypes;

var _harvestables: Array[HarvestableBase];

var cells_to_generate: Dictionary[HarvestableTypes.types, int]:
	set(val):
		cells_to_generate = val;
		generate_cells(cells_to_generate);


const _OFFSETS = [
		Vector2i(1,1),
		Vector2i(-1,1),
		Vector2i(1,-1),
		Vector2i(-1,-1),
	];




func _ready() -> void:
	pass;

func generate_cells(amount: Dictionary[HarvestableTypes.types, int]):
	for type in amount.keys():
		for i in amount[type]:
			_generate_one_cell_of_type(type);
	pass;

func _generate_one_cell_of_type(type: HarvestableTypes.types):
	var base: HarvestableBase = _harvestable_types.get_copy(type);
	var pos =floor_layer.get_random_free_spot();
	floor_layer.used[pos] = true;
	_harvestables.push_back(base)
	base.harvested.connect(func(): _remove_from_harvestables_check_empty(base));
	base.get_node("GridVectorToPositionConverter").set_grid_vector(pos);
	add_child(base);


func _remove_from_harvestables_check_empty(base: HarvestableBase):
	var pos = base.get_node("GridVectorToPositionConverter").grid_vector;
	floor_layer.set_navigation_cell(pos);
	_harvestables.erase(base);
	if _harvestables.is_empty():
		emptyed.emit();




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
