extends Node2D
class_name Mines
	
@export var player: Player;
@export var harvestable_layer: Node;
@export var floor_layer: Node;

@export var levels: LevelTypes
@onready var collector_spawner: CollectorSpawner = $YSorted/CollectorSpawner

var _forge: Forge

func _ready() -> void:
	var d : Dictionary[HarvestableTypes.types, int]
	_forge = get_tree().get_first_node_in_group("forge");
	var level: Level = levels.map[_forge.selected_level];
	floor_layer.setup(level.platform_radius);
	d=level.harvestables;
	harvestable_layer.generate_cells(d)
	floor_layer.generate_navigation_layer();


func _on_player_died() -> void:
	
	Camera.reset_zoom();
	queue_free();


func _on_harvestabels_layer_emptyed() -> void:
	_forge.increment_level();
	player.do_lifetime_calculation =false;
	$LevelComplete.display();
	$LevelComplete.finished.connect( func():player._die_feedback());
