extends ColorRect

@export var mode: Mode;

enum Mode{
	NORMAL,
	MINES,
}


var _previous_camera_position: Vector2;


func _ready() -> void:
	if mode == Mode.NORMAL:
		return;
	var background_size = (
		 get_viewport().get_visible_rect().size / 
		(GlobalConstants.MIN_ZOOM - 0.5))
	size = background_size
	position = background_size / -2;
	_previous_camera_position = Camera.position;


func _process(_delta: float) -> void:
	if mode == Mode.NORMAL:
		return;
	var delta_camera_position = Camera.position - _previous_camera_position;
	_previous_camera_position = Camera.position;
	position -= delta_camera_position * 0.07; 
