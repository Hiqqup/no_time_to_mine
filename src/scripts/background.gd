extends ColorRect

@export var mode: Mode;
@export var _level_types: LevelTypes;

enum Mode{
	NORMAL,
	MINES,
}


var _previous_camera_position: Vector2;
var _forge: Forge

func _ready() -> void:
	_forge = get_tree().get_first_node_in_group("forge")
	if mode == Mode.NORMAL:
		return;
	var background_size = (
		 get_viewport().get_visible_rect().size / 
		(GlobalConstants.MIN_ZOOM - 0.5))
	size = background_size
	position = background_size / -2;
	_previous_camera_position = Camera.position;
	
	_set_colors();


func _set_colors():
	var shader_material: ShaderMaterial = material
	var color_2: Color = _level_types.color_map[_forge.selected_level][0];
	var color_3: Color = _level_types.color_map[_forge.selected_level][1];
	shader_material.set_shader_parameter("colour_2", color_2)
	shader_material.set_shader_parameter("colour_3", color_3)


func _process(_delta: float) -> void:
	if mode == Mode.NORMAL:
		return;
	var delta_camera_position = Camera.position - _previous_camera_position;
	_previous_camera_position = Camera.position;
	position -= delta_camera_position * 0.07; 
