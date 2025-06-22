extends RigidBody2D
class_name Orb;

@export var _level_types: LevelTypes;
@onready var _sprite_2d: Sprite2D = $Visuals/Sprite2D
@onready var _forge: Forge = get_tree().get_first_node_in_group("forge");

const max_velocity = 200;
func _ready() -> void:
	_sprite_2d.texture = _level_types.tileset_map[_forge.selected_level]; 
	contact_monitor = true;
	max_contacts_reported = 5;

func _physics_process(delta: float) -> void:
	if linear_velocity.length() > max_velocity:
		linear_velocity = max_velocity* linear_velocity.normalized();
	pass;


func _on_body_entered(body: Node) -> void:
	if body is Player or body.get_parent() is Minion:
		#linear_velocity *= 3;
		linear_velocity = linear_velocity.normalized() * max_velocity;
		pass
