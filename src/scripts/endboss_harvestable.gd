extends HarvestableBase
class_name EndbossHarvestable
@onready var background: ColorRect = $Visuals/Background
@onready var player_collider_shape: CollisionPolygon2D = $CollisionShapes/PlayerCollider/ColliderShape
@onready var parent: EndbossScene = get_parent();
const STARTING_HEALTH = 99999999.0
var broken: bool = false;
var spirit_particles : CPUParticles2D 
func _ready():
	$GridVectorToPositionConverter.set_grid_vector(Vector2.ZERO)
	selected_outline.texture = VisualUtility.add_transparent_border(selected_outline.texture)
	health = STARTING_HEALTH
	spirit_particles= parent._mines.player.get_node("Visuals/Particles/SpiritParticles")

func get_destroyed():
	return;
func _fade_out(node):
	create_tween().tween_property(node, "modulate", Color(Color.WHITE, 0 ),1);


func mine_visual_feedback():
	if broken:
		return;
	if health < (STARTING_HEALTH -  2 * 5000):
		
		parent._mines.player.go_back_to_forge = false;
		parent._mines.player._die_feedback();
		
		
		selected_outline.visible = false;
		selected_outline.visibility_changed.connect(func():
			selected_outline.visible= false;)
		var player_canvas_layer = parent._mines.player.get_node("CameraIndependet");
		for i in player_canvas_layer.get_children():
			if i is CanvasItem:
				_fade_out(i)
		TimeoutCallback.timeout_callback(0.7,func():
			create_tween().tween_property(background,"modulate",Color(Color.WHITE,0.0),1.5)#.set_trans(Tween.TRANS_CIRC);
			)
		TimeoutCallback.timeout_callback(0.7 + 1.5, func():
			player_collider_shape.disabled = true
			player_canvas_layer.visible =false;

			parent.invisible_player.global_position = spirit_particles.global_position
			spirit_particles.reparent(parent.invisible_player)
			)
		
		for i in parent._mines.get_node("YSorted/MinionSpawner").get_children():
			var minion: Minion = i as Minion
			if minion:
				minion.following = null
		for i in parent._mines.get_node("YSorted/OrbSpawner").get_children():
			var orb: Orb = i as Orb
			if orb:
				create_tween().tween_property(orb,"max_velocity", 0, 0.5);
		broken = true;
		return;
		
	super();
	
	pass


func _on_spirit_detector_body_entered(body: Node2D) -> void:
	
	if body == parent.invisible_player:
		parent.invisible_player._alive = false;
		create_tween().tween_property(spirit_particles,"global_position", global_position, 1)
		create_tween().tween_property(spirit_particles,"modulate",Color(Color.WHITE,0.0),1.5)#.set_trans(Tween.TRANS_CIRC);	
		TimeoutCallback.timeout_callback(1, func():
			create_tween().tween_property(background,"modulate",Color(Color.WHITE,1.0),1.5)#.set_trans(Tween.TRANS_CIRC);
			)
		TimeoutCallback.timeout_callback(3, func():
			parent._mines.player.go_back_to_forge = true;
			parent._mines.player._die();
			#roll credits here
			)
