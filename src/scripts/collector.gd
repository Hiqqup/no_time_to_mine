extends Node2D
class_name Collector
@export var _level_types: LevelTypes;
@onready var _sprite_2d: Sprite2D = $Visuals/Sprite2D
@onready var _forge: Forge = get_tree().get_first_node_in_group("forge");
var _time_counter:float = 0.0;

func _process(delta: float) -> void:
	_time_counter += delta;
	$Visuals.position.y = sin(_time_counter*4) * 2.0;

func _ready() -> void:
	_sprite_2d.texture = _level_types.tileset_map[_forge.selected_level];
