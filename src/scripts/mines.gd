extends Node2D
class_name Mines
	
@export var player: Player;
@export var harvestable_layer: Node;
@export var floor: Node;

@export var levels: LevelTypes


func _ready() -> void:
	var d : Dictionary[HarvestableTypes.types, int]
	var forge = get_tree().get_first_node_in_group("forge");
	var level: Level = levels.map[forge.selected_level];
	floor.setup(level.platform_radius);
	d=level.harvestables;
	harvestable_layer.generate_cells(d)
	

func _on_player_died() -> void:
	queue_free();
