class_name HarvestableBase
extends Node2D

signal harvested;

@export var health: float;
var drop_table: Dictionary[ItemTypes.types, float];

@export var _upgrade_stats: PlayerUpgradeStats;
@export var _drop_base_scene: PackedScene;
@onready var _hit_particles: CPUParticles2D = $Visuals/HitParticlesContainer/HitParticles
@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var _player: Player =  get_tree().get_first_node_in_group("current_mines").player;
@onready var selected_outline: Sprite2D = $Visuals/SelectedOutline
var sprite: Texture:
	set(value):
		var sprite2D:Sprite2D = $Visuals/Sprite2D
		sprite2D.texture = value;
		$Visuals/SelectedOutline.texture = VisualUtility.add_transparent_border(value)
		


var _destroyed: bool = false;

var player_in_range: bool = false;
var minions_in_range: Dictionary[Minion, bool];
var mines: Mines;
var _drop:ItemDropBase;

var mobile_hovering: bool = false;

func after_destroyed_animation():
	queue_free();	

func get_destroyed():
	_destroyed = true;
	((get_tree().get_first_node_in_group("shockwave") as ShockwaveEffect)
		.at(Camera.convert_position(global_position)));
	_spawn_drop(_drop_table_float_to_int(drop_table));
	harvested.emit();
	Camera.shake(6)
	$CollisionShapes.queue_free();
	_hit_particles.queue_free();
	_animation_player.play("destroyed");
	selected_outline.visible = false;;

func sprite_gone():
	if is_instance_valid(_drop):
		_drop.visible = true;

func mine_visual_feedback():
	if _hit_particles.emitting:
		$Visuals/HitParticlesContainer.add_child(_hit_particles.duplicate());
	_hit_particles.emitting = true;
	if _animation_player.is_playing():
		_animation_player.stop();
	_animation_player.play("damage")
	#temporary
	var tween =  get_tree().create_tween();
	var start_scale = Vector2.ONE;
	var middle_scale = Vector2.ONE * 0.7;
	(tween.tween_property($Visuals, "scale", middle_scale,0.1)
		.from(start_scale).set_trans(Tween.TRANS_BACK));
	(tween.tween_property($Visuals, "scale", start_scale,0.3)
		.from(middle_scale).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT));
	#temporary end


func _drop_table_float_to_int(dt: Dictionary[ItemTypes.types, float]):
	var item_drops : Dictionary[ItemTypes.types, int];
	for type in dt.keys():
		var i = dt[type];
		item_drops[type] = int(floor(i));
		if randf() <= (i - floor(i)):
			item_drops[type] += 1;
	return item_drops;


func _spawn_drop(item_drops: Dictionary[ItemTypes.types, int]):
	var drop: ItemDropBase= _drop_base_scene.instantiate();
	drop.item_drops = item_drops;
	drop.get_node("GridVectorToPositionConverter").set_grid_vector($GridVectorToPositionConverter.grid_vector)
	var drops = mines.get_node("YSorted/Drops")
	drops.add_child(drop)
	_drop = drop;
	drop.visible = false;
	mines.collector_spawner._set_untargeted_item(drop);

func _handle_clicked_on():
	
	if player_in_range :
		_player.currently_mining = self; 


func _ready() -> void:
	mines = get_tree().get_first_node_in_group("current_mines");
	_hit_particles.emitting  = false;
	_hit_particles.one_shot = true
	
	selected_outline.visible = false;
	# setup a colison body with the same shape as click detection for player
	# targeting ray to collide with
	var player_targeting_colision_body := StaticBody2D.new();
	player_targeting_colision_body.collision_layer = 2; # targeting colision layer
	player_targeting_colision_body.add_child($CollisionShapes/ClickDetection/ClickDetectionShape.duplicate());
	$CollisionShapes.add_child(player_targeting_colision_body)

	selected_outline.visibility_changed.connect(func():
		if _destroyed:
			selected_outline.visible = false;
		)



func _enter_tree() -> void:
	$CollisionShapes/MiningRange/MiningRangeShape.scale*= _upgrade_stats.mining_range


func _on_click_detection_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_handle_clicked_on();



func _on_mining_range_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_range =true;


func _on_mining_range_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_range = false;





func _on_minion_range_body_exited(body: Node2D) -> void:
	if body is Minion:
		minions_in_range.erase(body as Minion);


func _on_minion_range_body_entered(body: Node2D) -> void:
	if body is Minion:
		minions_in_range[body as Minion] = true;


func _on_click_detection_mouse_entered() -> void:
	if GlobalConstants.MOBILE():
		mobile_hovering = true;
		_player.mobile_targeting = self;


func _on_click_detection_mouse_exited() -> void:
	if GlobalConstants.MOBILE():
		mobile_hovering = false;
		_player.mobile_targeting = null;
