class_name Player
extends CharacterBody2D

signal died;

@export var _upgrade_stats: PlayerUpgradeStats
@export var _level_types: LevelTypes;

@onready var _walking_particles: CPUParticles2D = $Visuals/WalkingParticles
@export var lifetime_bar: TextureProgressBar
@onready var _eyes: Sprite2D = $Visuals/Eyes
@onready var _particles: Node2D = $Visuals/Particles


var currently_mining: HarvestableBase = null;


var _alive: bool = true;

var _mine_cooldown: float = 0;
var _lifetime:= 0.0;

var do_lifetime_calculation: bool = true;

var _forge:Forge;

func _ready() -> void:
	lifetime_bar.max_value = _upgrade_stats.max_life_time;
	_forge = get_tree().get_first_node_in_group("forge");
	_walking_particles.modulate = _level_types.color_map[_forge.selected_level][2];
	_particles.modulate = _level_types.color_map[_forge.selected_level][0];
	_eyes.texture = _level_types.tileset_map[_forge.selected_level]


func _physics_process(delta: float) -> void:
	if not _alive:
		return; 
	_mine_cooldown -= delta;
	if do_lifetime_calculation:
		_lifetime+= delta;
		lifetime_bar.value = _lifetime;
	if _lifetime >= _upgrade_stats.max_life_time:
		_die_feedback()
	_try_mine();
	_handle_movement_input()
	_handle_targeting();
	move_and_slide();

func _die():
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
	Camera.shake(20.0)
	$AnimationPlayer.play("die");
	_alive = false;


func _on_button_pressed() -> void:
	_die_feedback()
	#temporary end

func _handle_targeting():
	var targeting = $Targeting
	var mouse_position = get_local_mouse_position() 
	
	var angle = (mouse_position - targeting.position).angle()
	targeting.rotation = angle - PI/ 2;
	if (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) 
		and targeting.is_colliding() 
		and targeting.get_collider()):
		var collider_parent = targeting.get_collider().get_parent().get_parent();
		if (collider_parent is HarvestableBase 
			and collider_parent.player_in_range):
			currently_mining = collider_parent;
			
