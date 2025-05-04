class_name Player
extends CharacterBody2D

var currently_mining: HarvestableBase = null;

var _mine_cooldown: float = 0;
var _lifetime:= 0.0;
var upgrade_stats: PlayerUpgradeStats


func _ready() -> void:
	upgrade_stats = get_tree().get_first_node_in_group("upgrade_stats");


func _physics_process(delta: float) -> void:
	_mine_cooldown -= delta;
	_lifetime+= delta;
	if _lifetime >= upgrade_stats.max_life_time:
		_die();
	_try_mine();
	_handle_movement_input()
	_handle_targeting();
	move_and_slide();

func _die():
		var forge = get_tree().get_first_node_in_group("forge");
		var forge_storage = forge.get_node("Storage");
		for i in ItemTypes.types.size():
			forge_storage.contents[i] += $Storage.contents[i];
		forge.visible = true;
		forge.update_and_generate_storage_display();
		Camera.location = Camera.CameraLocation.FORGE;
		get_tree().get_first_node_in_group("current_mines").queue_free()


func _handle_movement_input():
	var direction: Vector2 = Input.get_vector("player_move_left","player_move_right","player_move_up","player_move_down");
	velocity.x = move_toward(velocity.x, upgrade_stats.movement_speed* direction.x, upgrade_stats.movement_speed/10);
	velocity.y = move_toward(velocity.y, upgrade_stats.movement_speed* direction.y, upgrade_stats.movement_speed/10);
	


func _try_mine() -> void:
	if _mine_cooldown > 0:
		return;
	if currently_mining == null:
		return;
	if not currently_mining.player_in_range:
		currently_mining = null;
		return;
	currently_mining.health -= upgrade_stats.mining_damage;
	currently_mining.mine_visual_feedback();
	mine_visual_feedback()
	_mine_cooldown = upgrade_stats.mining_cooldown_duration;
	if(currently_mining.health <= 0):
		currently_mining.get_destroyed();


func mine_visual_feedback():
		#temporary
	var tween =  get_tree().create_tween();
	var start_scale = Vector2.ONE;
	var middle_scale = Vector2.ONE * 0.7;
	(tween.tween_property($Visuals, "scale", middle_scale,0.1)
		.from(start_scale).set_trans(Tween.TRANS_BACK));
	(tween.tween_property($Visuals, "scale", start_scale,0.3)
		.from(middle_scale).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT));


func _on_button_pressed() -> void:
	_die();

	#temporary end

func _handle_targeting():
	var targeting = $Targeting
	var mouse_position = get_local_mouse_position()
	var angle = mouse_position.angle()
	targeting.rotation = angle - PI/ 2;
	if (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) 
		and targeting.is_colliding() 
		and targeting.get_collider()):
		var collider_parent = targeting.get_collider().get_parent();
		if (collider_parent is HarvestableBase 
			and collider_parent.player_in_range):
			currently_mining = collider_parent;
