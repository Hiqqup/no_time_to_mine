extends HarvestableBase
class_name EndbossHarvestable
@onready var parent: EndbossScene = get_parent();
const STARTING_HEALTH = 99999999.0
func _ready():
	$GridVectorToPositionConverter.set_grid_vector(Vector2.ZERO)
	selected_outline.texture = VisualUtility.add_transparent_border(selected_outline.texture)
	health = STARTING_HEALTH

func mine_visual_feedback():
	if health < (STARTING_HEALTH -  2 * 5000):
		
		parent._mines.player.go_back_to_forge = false;
		parent._mines.player._die_feedback();
		
		selected_outline.visible = false;
		
		for i in parent._mines.get_node("YSorted/MinionSpawner").get_children():
			var minion: Minion = i as Minion
			if minion:
					minion.following = null
		for i in parent._mines.get_node("YSorted/OrbSpawner").get_children():
			var orb: Orb = i as Orb
			if orb:
				create_tween().tween_property(orb,"max_velocity", 0, 0.5);
		
		return;
		
	super();
	
	pass
