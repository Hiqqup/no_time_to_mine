extends CharacterBody2D
class_name Collector
@export var _level_types: LevelTypes;
@onready var _sprite_2d: Sprite2D = $Visuals/Sprite2D
@onready var _forge: Forge = get_tree().get_first_node_in_group("forge");
var _time_counter:float = 0.0;
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@export var _upgrade_stats: PlayerUpgradeStats;

var targeting: ItemDropBase;
var player: Player;
var spawner: CollectorSpawner
var speed: float =50;
func scale_speed():
	speed += _upgrade_stats.collector_scaling

func _process(delta: float) -> void:
	_time_counter += delta;
	$Visuals.position.y = sin(_time_counter*4) * 2.0;
	if targeting:
		var dir =  targeting.global_position -collision_shape_2d.global_position;
		if dir.length() > speed *delta:
			position += dir.normalized() * speed  * delta
		else:
			position += dir;
		


func _ready() -> void:
	_sprite_2d.texture = _level_types.tileset_map[_forge.selected_level];
