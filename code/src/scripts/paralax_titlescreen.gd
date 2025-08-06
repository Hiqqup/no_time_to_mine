extends Control
@onready var right_mountain: TextureRect = $RightMountain
@onready var left_mountain: TextureRect = $LeftMountain
@onready var player: TextureRect = $Player
@onready var player_starting_position: Vector2 = player.position;

var time_player: float;

var time_left: float;

var time_right: float;



func _process(delta: float) -> void:
	time_player += randf() * delta;
	time_left += randf() * delta;
	time_right += randf() * delta;
	player.position = Vector2(0, cos(time_player)) * 40 + player_starting_position;
	
	left_mountain.position = Vector2(0, cos(time_left)) * -80;
	
	right_mountain.position = Vector2(0, cos(time_right)) * -40;
