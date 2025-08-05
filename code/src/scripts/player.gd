class_name Player
extends CharacterBody2D

signal died;

@export var _upgrade_stats: PlayerUpgradeStats
@export var _level_types: LevelTypes;
@onready var reset_button: Button = $CameraIndependet/ResetButton

@onready var _walking_particles: CPUParticles2D = $Visuals/WalkingParticles
@export var lifetime_bar: TextureProgressBar
@onready var _eyes: Sprite2D = $Visuals/Eyes
@onready var _particles: Node2D = $Visuals/Particles
@onready var _visuals: Node2D = $Visuals

var mobile_targeting: HarvestableBase = null:
	set(value):
		if mobile_targeting: 
			mobile_targeting.selected_outline.visible = false;
		if value:
			value.selected_outline.visible = true;
		mobile_targeting = value;
var mobile_targeting_position: Vector2 = Vector2.ZERO;

var previously_targeting: HarvestableBase = null;

var currently_mining: HarvestableBase = null;

var followed_by: Minion = null;

var _alive: bool = true;

var _walking_time: float  = 0.0;
var _mine_cooldown: float = 0;
var _lifetime:= 0.0;

var do_lifetime_calculation: bool = true;

var _forge:Forge;

var go_back_to_forge: bool = true;

func _ready() -> void:
	lifetime_bar.max_value = _upgrade_stats.max_life_time;
	_forge = get_tree().get_first_node_in_group("forge");
	_walking_particles.modulate = _level_types.color_map[_forge.selected_level][2];
	_particles.modulate = _level_types.color_map[_forge.selected_level][0];
	_eyes.texture = _level_types.tileset_map[_forge.selected_level]
	
	if GlobalConstants.MOBILE():
		reset_button.scale *= GlobalConstants.SCALE_BUTTONS_MOBILE;


func _physics_process(delta: float) -> void:
	_handle_walking_rotation(delta);
	if not _alive:
		return; 
	_mine_cooldown -= delta;
	if do_lifetime_calculation:
		_lifetime+= delta;
		lifetime_bar.value = _lifetime;
	
	_handle_movement_input()
	_try_mine();
	_handle_targeting();
	if _lifetime >= _upgrade_stats.max_life_time:
		_die_feedback()
	move_and_slide();



func _handle_walking_rotation(delta: float):
	if not _walking_particles.emitting:
		_walking_time = 0;
		_visuals.rotation = lerp(rotation, 0.0, delta * 10);
	else:
		_walking_time += delta;
		_visuals.rotation = sin(_walking_time * 10)/12;

func _tween_music_down():
	var tween: Tween = create_tween();
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property(
		(AudioServer.get_bus_effect(AudioServer.get_bus_index("Music"), 0) as AudioEffectLowPassFilter),
		"cutoff_hz",
		GlobalConstants.LOW_PASS_FILTER_HZ,
		0.7
		)
	

func _die():
	if not go_back_to_forge:
		return;
	_tween_music_down()
	get_tree().get_first_node_in_group("screen_transition").change_scene(
	func():
		var forge_storage = _forge.get_node("Storage");
		var player_storage = $Storage;
		for i in player_storage.contents.size():
			forge_storage.contents[i] += player_storage.contents[i];
		_forge.switch_from_mines();
		_forge.update_all_upgrades();
		_alive = false;
		died.emit();
	)


func _handle_movement_input():
	var direction: Vector2 = Input.get_vector("player_move_left","player_move_right","player_move_up","player_move_down");
	
	if GlobalConstants.MOBILE() and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		
		direction = global_position.direction_to(get_global_mouse_position());
		if mobile_targeting and mobile_targeting.player_in_range:
			currently_mining = mobile_targeting;
			direction = Vector2.ZERO;
			pass
	
	if direction == Vector2.ZERO:
		_walking_particles.emitting = false;
		$Visuals/Sprite.animation = "standing";
	else:
		_walking_particles.emitting = true;
		$Visuals/Sprite.animation = "walking";
	velocity.x = move_toward(velocity.x, _upgrade_stats.movement_speed* direction.x, _upgrade_stats.movement_speed/10);
	velocity.y = move_toward(velocity.y, _upgrade_stats.movement_speed* direction.y, _upgrade_stats.movement_speed/10);
	


func _try_mine() -> void:
	if _mine_cooldown > 0:
		return;
	if currently_mining == null:
		return;
	if not currently_mining.player_in_range:
		currently_mining = null;
		return;
	currently_mining.health -= _upgrade_stats.mining_damage;
	currently_mining.mine_visual_feedback();
	_mine_cooldown = _upgrade_stats.mining_cooldown_duration;
	if(currently_mining.health <= 0):
		currently_mining.get_destroyed();
		currently_mining = null;
	else:
		if followed_by:
			followed_by.set_mining(currently_mining);
	mine_visual_feedback()


func mine_visual_feedback():
		#temporary
	var tween =  get_tree().create_tween();
	var start_scale = Vector2.ONE;
	var middle_scale = Vector2.ONE * 0.7;
	(tween.tween_property($Visuals, "scale", middle_scale,0.1)
		.from(start_scale).set_trans(Tween.TRANS_BACK));
	(tween.tween_property($Visuals, "scale", start_scale,0.3)
		.from(middle_scale).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT));


func _die_feedback():
	if not _alive:
		return;
	Camera.shake(40.0)
	_walking_particles.emitting = false;
	$AnimationPlayer.play("die");
	_alive = false;


func _on_button_pressed() -> void:
	_die_feedback()
	#temporary end

func _handle_targeting():
	var targeting:RayCast2D = $Targeting
	var mouse_position = get_local_mouse_position() 
	
	if GlobalConstants.MOBILE():
		targeting.visible=false;
		return;
	
	var collider_parent: HarvestableBase;
	if (targeting.is_colliding() 
		and targeting.get_collider()):
		collider_parent = (targeting.get_collider().get_parent().get_parent() as HarvestableBase);
	var targeting_line: Line2D = $Targeting/Line2D;
	
	if collider_parent and collider_parent.player_in_range:
		targeting_line.default_color = Color("#ababab");
	else:
		targeting_line.default_color = Color("#393939");
	if previously_targeting:
		previously_targeting.selected_outline.visible = false;
		previously_targeting = null
	if collider_parent:
		# scale by projection on targeting line
		var ray_cast_vector:Vector2 =targeting.get_collision_point() - targeting.global_position #collider_parent.global_position-targeting.global_position
		var phi = ray_cast_vector.angle() - (targeting.rotation + PI/2);
		targeting_line.points[1].y = cos(phi)* ray_cast_vector.length() + 4.0;
		collider_parent.selected_outline.visible = true;
		previously_targeting = collider_parent;
	else:
		targeting_line.points[1].y = 50;
		
	var angle = (mouse_position - targeting.position).angle()
	targeting.rotation = angle - PI/ 2;
	if (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
		and collider_parent and collider_parent.player_in_range):
		currently_mining = collider_parent;
