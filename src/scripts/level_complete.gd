extends CanvasLayer
signal finished
@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@export var _level_types: LevelTypes;
var _forge: Forge;
@onready var _visuals: Control = $Visuals
@onready var _level_texture: TextureRect = $Visuals/LevelTexture

func _ready() -> void:
	_forge = get_tree().get_first_node_in_group("forge");
	_level_texture.texture = _level_types.sprite_map[_forge.selected_level];
	_visuals.visible = false;
	if false:# to get rid of the warning
		finished.emit();

func display():
	
	_visuals.visible = true;
	_animation_player.play("level_complete");
	await _animation_player.animation_finished
	
	_visuals.visible = false;
	
