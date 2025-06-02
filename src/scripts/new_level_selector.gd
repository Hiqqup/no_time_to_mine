extends CanvasLayer


@onready var _level_list: HBoxContainer  =$ScrollContainer/LevelList;
@onready var _level_connection: Line2D  =$ScrollContainer/LevelConnection;

func _ready() -> void:
	var levels = _level_list.get_children();
	if levels.is_empty():
		return;
	var from:Control = levels[0]
	var to:Control = levels[levels.size()- 1]
	await get_tree().process_frame
	_level_connection.add_point(from.global_position + from.size/2)
	_level_connection.add_point(to.global_position + to.size/2);
