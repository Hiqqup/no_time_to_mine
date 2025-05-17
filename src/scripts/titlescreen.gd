extends Control


@export var _game_scene: PackedScene

func _ready():
	$Camera.queue_free();
	pass


func _reset_game_save_state():
	var game_scene = _game_scene.instantiate();
	var forge: Forge = game_scene.get_node("Forge");
	var new_save_state =SaveState.new(); 
	new_save_state.take_over_path(forge._save_state.resource_path);
	forge._save_state = new_save_state;
	forge.save_game();
	get_parent().add_child(game_scene );


func _on_new_game_pressed() -> void:
	_reset_game_save_state();
	queue_free();


func _on_continue_pressed() -> void:
	get_parent().add_child(_game_scene.instantiate() );
	queue_free();
