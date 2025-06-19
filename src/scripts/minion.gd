extends CharacterBody2D
class_name Minion

@export var _level_types: LevelTypes;
var _player: Player;
var _forge : Forge
var speed: float = 50;
@onready var _sprite_2d: Sprite2D = $Visuals/Sprite2D
@onready var _navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D


func _physics_process(delta: float) -> void:
	_forge = get_tree().get_first_node_in_group("forge")
	_sprite_2d.texture = _level_types.tileset_map[_forge.selected_level]
	#velocity.x = delta *1000;
	var dir:= Vector2.ZERO;
	if position.distance_to(_navigation_agent_2d.target_position)>4.0:
		dir = to_local(_navigation_agent_2d.get_next_path_position()).normalized()
	velocity = dir* speed;
	print(velocity)
	move_and_slide() 


func _on_navigation_update_timer_timeout() -> void:
	_navigation_agent_2d.target_position  = _player.global_position
