extends CharacterBody2D
class_name Minion

@export var _level_types: LevelTypes;
var _forge : Forge
@onready var _sprite_2d: Sprite2D = $Visuals/Sprite2D

func _physics_process(delta: float) -> void:
	_forge = get_tree().get_first_node_in_group("forge")
	_sprite_2d.texture = _level_types.tileset_map[_forge.selected_level]
	velocity.x = delta *1000;
	move_and_slide() 
