extends RigidBody2D
class_name Orb;

@export var _level_types: LevelTypes;
@export var _upgrade_stats: PlayerUpgradeStats;
@onready var _sprite_2d: Sprite2D = $Visuals/Sprite2D
@onready var _forge: Forge = get_tree().get_first_node_in_group("forge");


var max_velocity = 100;
var max_distance: float
func _ready() -> void:
	_sprite_2d.texture = _level_types.tileset_map[_forge.selected_level]; 
	linear_velocity = Vector2(1,-0.5);
	contact_monitor = true;
	max_contacts_reported = 1
	max_distance = _level_types.map[_forge.selected_level].platform_radius * 32 + 10;

func _physics_process(_delta: float) -> void:
	linear_velocity = max_velocity* linear_velocity.normalized();
	if global_position.length()> max_distance:
		global_position = Vector2.ZERO;



func _on_body_entered(body: Node) -> void:
	if max_velocity > 500:
		max_velocity += _upgrade_stats.orb_scaling;
	var base: HarvestableBase = (body.get_parent().get_parent() as HarvestableBase);
	
	if base :
		base.mine_visual_feedback();
		base.health-= _upgrade_stats.orb_damage;
		if(base.health <= 0):
			call_deferred("_destroy_base", base);


func _destroy_base(base: HarvestableBase):
	base.get_destroyed();
