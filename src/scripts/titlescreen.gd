extends Control


@export var _game_scene: PackedScene

func _play_music(_game_scene):
	TimeoutCallback.timeout_callback(0.2, func(): _game_scene.music.playing = true);
	

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
	(get_tree().get_first_node_in_group("screen_transition")
	.change_scene(func():
		var game_scene =_reset_game_save_state();
		_play_music(game_scene);
		queue_free();
		
		))



func _on_continue_pressed() -> void:
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
