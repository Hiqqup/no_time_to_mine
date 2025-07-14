extends Node

@export var recolor_scene: PackedScene;
@export var schemes: Array[RecolorMap];
var index: int = 0;
var recolorer;

func _ready() -> void:
	_spawn_recolorer();


func _spawn_recolorer():
	recolorer = recolor_scene.instantiate()
	recolorer.recolor_map = schemes[index];
	add_child(recolorer)
	recolorer.recolored.connect(func():

		recolorer.queue_free();
		if index < schemes.size() -1:
			index += 1;
			_spawn_recolorer()
		);
