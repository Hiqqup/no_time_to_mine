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
var location: CameraLocation = CameraLocation.LOCKED_TITLE_SCREEN :
	set(value):
		location = value
		if value == CameraLocation.FORGE:
			global_position = Vector2.ZERO


func _ready() -> void:
	reset_zoom()

func convert_position(pos):
	var viewport_size = Vector2( get_viewport().size);
	return ((pos - global_position) *zoom +viewport_size/2);

func _zoom_out():
	if zoom.x > GlobalConstants.MIN_ZOOM:
		zoom -= Vector2.ONE * _SCROLL_FACTOR ;

func _zoom_in():
	zoom+= Vector2.ONE * _SCROLL_FACTOR;


func _unhandled_input(event: InputEvent) -> void:
	if location == CameraLocation.LOCKED_TITLE_SCREEN:
		return;
	if GlobalConstants.COMPILED() and event is InputEventMagnifyGesture:
		if event.factor > 1.0:
			_zoom_in();
		else:
			_zoom_out();
		return;
	if event is InputEventMouseButton:
		if (event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed):
			_zoom_out();
		if (event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed):
			_zoom_in()
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and not _dragging:
			_dragging = true;
			_dragging_start_position = event.position
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and _dragging:
			_dragging = false;
	
	
	


func _process(delta: float) -> void:
	if location == CameraLocation.LOCKED_TITLE_SCREEN:
		return;
	if location == CameraLocation.LOCKED_FORGE:
		global_position = Vector2.ZERO;
	if location == CameraLocation.FORGE:
		global_position += velocity;
		_handle_movement_input()
	if location == CameraLocation.MINES:
		var player_position =  get_tree().get_first_node_in_group("current_mines").player.global_position;
		var speed = 5
		global_position = global_position.lerp(player_position, delta*speed);


		
	if(_dragging and location == CameraLocation.FORGE):
		var mouse_position = get_viewport().get_mouse_position()
		position -=( mouse_position - _dragging_start_position)/zoom;
		_dragging_start_position = mouse_position;
	if(_shake_strength):
		_shake_strength = lerp(_shake_strength, 0.0, _SHAKE_FADE*delta);
		offset = Vector2(randf_range(-_shake_strength , _shake_strength),randf_range(-_shake_strength , _shake_strength))
	

func shake(strength: float):
	_shake_strength = strength;


func set_to_player_position():
	global_position =  get_tree().get_first_node_in_group("current_mines").player.global_position;


func reset_zoom():
	zoom = Vector2.ONE * 4;



func _handle_movement_input():
	var speed :=  Vector2.ONE * 20 / zoom; 
	var direction: Vector2 = Input.get_vector("player_move_left","player_move_right","player_move_up","player_move_down");
	velocity.x = move_toward(velocity.x, speed.x* direction.x, speed.x/10.0);
	velocity.y = move_toward(velocity.y, speed.y* direction.y, speed.y/10.0);
	
