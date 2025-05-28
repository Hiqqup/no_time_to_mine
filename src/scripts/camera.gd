extends Camera2D


const _SCROLL_FACTOR = 0.1;
const _SHAKE_FADE: float = 10.0;

var _dragging: bool = false;
var _dragging_start_position: Vector2;
var _shake_strength: float = 0.0;

var velocity:= Vector2.ZERO;

enum CameraLocation{
	MINES,
	FORGE,
	LOCKED_FORGE,
	LOCKED_TITLE_SCREEN,
}
var location: CameraLocation = CameraLocation.LOCKED_TITLE_SCREEN;


func _ready() -> void:
	reset_zoom()


func _handle_zoom():
	if zoom.x > GlobalConstants.MIN_ZOOM:
		zoom -= Vector2.ONE * _SCROLL_FACTOR ;


func _unhandled_input(event: InputEvent) -> void:
	if location == CameraLocation.LOCKED_TITLE_SCREEN:
		return;
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			_handle_zoom();
			
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			zoom+= Vector2.ONE * _SCROLL_FACTOR;
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and not _dragging:
			_dragging = true;
			_dragging_start_position = event.position
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and _dragging:
			_dragging = false;


func _process(delta: float) -> void:
	if location == CameraLocation.LOCKED_TITLE_SCREEN:
		return;
	global_position += velocity;
	if location == CameraLocation.LOCKED_FORGE:
		global_position = Vector2.ZERO;
	if location == CameraLocation.FORGE:
		_handle_movement_input()
	if location == CameraLocation.MINES:
		var player_position =  get_tree().get_first_node_in_group("current_mines").player.global_position;
		var speed = 10
		global_position.y = lerp(global_position.y, player_position.y, delta*speed)
		global_position.x = lerp(global_position.x, player_position.x, delta*speed)
	if(_dragging and location == CameraLocation.FORGE):
		var mouse_position = get_viewport().get_mouse_position()
		position -=( mouse_position - _dragging_start_position)/zoom;
		_dragging_start_position = mouse_position;
	if(_shake_strength):
		_shake_strength = lerp(_shake_strength, 0.0, _SHAKE_FADE*delta);
		offset = Vector2(randf_range(-_shake_strength , _shake_strength),randf_range(-_shake_strength , _shake_strength))
	

func shake(strength: float):
	_shake_strength = strength;


func reset_zoom():
	zoom = Vector2.ONE * 4;



func _handle_movement_input():
	var speed :=  Vector2.ONE * 20 / zoom; 
	var direction: Vector2 = Input.get_vector("player_move_left","player_move_right","player_move_up","player_move_down");
	velocity.x = move_toward(velocity.x, speed.x* direction.x, speed.x/10.0);
	velocity.y = move_toward(velocity.y, speed.y* direction.y, speed.y/10.0);
	
