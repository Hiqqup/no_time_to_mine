extends Control
class_name SkillTreeButtonBase;

@onready var  _connection_to_parent: Line2D =$ConnectionToParent ;
@export var sprite: Texture;
func _ready() -> void:
	if sprite:
		$WrapperButton/Visuals/Button.texture = sprite;
	var parent = get_parent();
	if parent is SkillTreeButtonBase:
		_connection_to_parent.add_point(global_position + size/2)
		_connection_to_parent.add_point(parent.global_position + parent.size/2);
