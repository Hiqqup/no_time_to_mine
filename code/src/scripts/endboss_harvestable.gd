extends HarvestableBase
class_name EndbossHarvestable
@onready var player_collider_shape: CollisionPolygon2D = $CollisionShapes/PlayerCollider/ColliderShape
@onready var well_content: ColorRect = $Visuals/WellContent
@onready var parent: EndbossScene = get_parent();
@export var _credit_scene: PackedScene;
const STARTING_HEALTH = 99999999.0
var broken: bool = false;
var spirit_particles : CPUParticles2D 
var old_player: Player
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
	if broken or not parent._mines.player._alive:
		return;
	if health < (STARTING_HEALTH -  5 * 5000):
		
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
			create_tween().tween_property(well_content,"modulate",Color(Color.WHITE,0.0),1.5)#.set_trans(Tween.TRANS_CIRC);
			)
		TimeoutCallback.timeout_callback(0.7 + 1.5, func():
			player_collider_shape.disabled = true
			player_canvas_layer.visible =false;

			old_player = parent._mines.player
			parent.invisible_player.global_position = old_player.global_position
			spirit_particles.reparent(parent.invisible_player)
			parent._mines.player = parent.invisible_player;
			create_tween().tween_property(parent.invisible_player, "modulate", Color.WHITE, 2);
			(well_content.material as ShaderMaterial).set_shader_parameter("colour_2", Color.WHITE);
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
		create_tween().tween_property(parent.invisible_player,"global_position", global_position - spirit_particles.position, 1)
		create_tween().tween_property(spirit_particles,"modulate",Color(Color.WHITE,0.0),1.5)#.set_trans(Tween.TRANS_CIRC);	
		TimeoutCallback.timeout_callback(1, func():
			create_tween().tween_property(well_content,"modulate",Color(Color.WHITE,1.0),1.5)#.set_trans(Tween.TRANS_CIRC);
			)
		TimeoutCallback.timeout_callback(3, func():
			#old_player.go_back_to_forge = true;
			#old_player._die();
			#roll credits here
			var screen_transition = get_tree().get_first_node_in_group("screen_transition")

			screen_transition.change_scene(func():
				var credits: CreditScene = _credit_scene.instantiate();
				credits.quit.connect(func():
					old_player.go_back_to_forge = true;
					old_player._die();
					)
				parent.get_parent().add_child(credits);
				parent.visible = false;
			)
			)
			
