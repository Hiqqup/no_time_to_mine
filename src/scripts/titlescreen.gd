extends Control

@onready var _options: TitleScreenOptions = $CanvasLayer/Options
@onready var _titlescreen_container: VBoxContainer = $CanvasLayer/Titlescreen

@export var _game_scene: PackedScene


func _ready():
	_titlescreen_container.pivot_offset = _titlescreen_container.size/2

func _play_music(game_scene):
	TimeoutCallback.timeout_callback(0.2, func():
		game_scene.music.playing = GlobalConstants.MUSIC or GlobalConstants.COMPILED()
		);
	

func _reset_game_save_state():
	var game_scene = _game_scene.instantiate();
	var forge: Forge = game_scene.get_node("Forge");
	var new_save_state =SaveState.new(); 
	if GlobalConstants.COMPILED():
		DirAccess.remove_absolute(GlobalConstants.USER_PATH);
		pass
	new_save_state.take_over_path(forge._save_state.resource_path);
	forge._save_state = new_save_state;
	forge.save_game();
	get_parent().add_child(game_scene );
	return game_scene;


func _on_new_game_pressed() -> void:
	Camera.options = _options.get_option_dict()
	(get_tree().get_first_node_in_group("screen_transition")
	.change_scene(func():
		_reset_game_save_state();
		#_play_music(game_scene);
		queue_free();
		
		))



func _on_continue_pressed() -> void:
	Camera.options = _options.get_option_dict()
	(get_tree().get_first_node_in_group("screen_transition")
	.change_scene(func():
		var game_scene = _game_scene.instantiate();
		var forge: Forge = game_scene.get_node("Forge");
		if not forge._save_state.tutorial_completed:
			game_scene = _reset_game_save_state();
		else:
			get_parent().add_child(game_scene );
			_play_music(game_scene);
		queue_free();
		))
@onready var titlescreen: VBoxContainer = $CanvasLayer/Titlescreen
@onready var options: Control = $CanvasLayer/Options

func toggle_settings():
	titlescreen.visible = not titlescreen.visible
	options.visible = not options.visible
	

func _on_options_pressed() -> void:
	toggle_settings();
