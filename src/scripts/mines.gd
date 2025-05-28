extends Node2D
class_name Mines
	
@export var player: Player;
@export var harvestable_layer: Node;
@export var floor_layer: Node;

@export var levels: LevelTypes

var _forge: Forge

func _ready() -> void:
	var d : Dictionary[HarvestableTypes.types, int]
	_forge = get_tree().get_first_node_in_group("forge");
	var level: Level = levels.map[_forge.selected_level];
	floor_layer.setup(level.platform_radius);
	d=level.harvestables;
	harvestable_layer.generate_cells(d)


func _on_player_died() -> void:
	
	Camera.reset_zoom();
	queue_free();


func _on_harvestabels_layer_emptyed() -> void:
	_forge.increment_level();
	$TimeoutCallback.timeout_callback(0.5,  func():player._die_feedback())
