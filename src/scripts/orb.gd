extends CharacterBody2D
class_name Orb;

@export var _level_types: LevelTypes;
@onready var _sprite_2d: Sprite2D = $Visuals/Sprite2D
@onready var _forge: Forge = get_tree().get_first_node_in_group("forge");

func _ready() -> void:
	_sprite_2d.texture = _level_types.tileset_map[_forge.selected_level]; 


func _physics_process(delta: float) -> void:
	pass;
