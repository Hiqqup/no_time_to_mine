extends Control
class_name SkillTreeButtonBase;

@onready var  _connection_to_parent: Line2D =$ConnectionToParent ;
@export var sprite: Texture;
var _parent: SkillTreeButtonBase;
func _ready() -> void:
	if sprite:
		$WrapperButton/Visuals/Button.texture = sprite;
	_parent = get_parent() as SkillTreeButtonBase;
	if _parent :
		_connection_to_parent.add_point(global_position + size/2)
		_connection_to_parent.add_point(_parent.global_position + _parent.size/2);
