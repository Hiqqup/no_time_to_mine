class_name Player
extends CharacterBody2D

const _SPEED: float = 150;
const _ACCELERATION: float = _SPEED /10;
const _MAX_LIFETIME:= 10.0#60.0;

var currently_mining: HarvestableBase = null;

var _mine_cooldown: float = 0;
var _lifetime:= 0.0;
var upgrade_stats: PlayerUpgradeStats


func _ready() -> void:
	upgrade_stats = get_tree().get_first_node_in_group("upgrade_stats");


func _physics_process(delta: float) -> void:
	_mine_cooldown -= delta;
	_lifetime+= delta;
	if _lifetime >= _MAX_LIFETIME:
		_die();
	_try_mine();
	_handle_movement_input()
	move_and_slide();

func _die():
		var forge = get_tree().get_first_node_in_group("forge");
		var forge_storage = forge.get_node("Storage");
		for i in ItemTypes.types.size():
			forge_storage.contents[i] += $Storage.contents[i];
		forge.visible = true;
		Camera.location = Camera.CameraLocation.FORGE;
		get_tree().get_first_node_in_group("current_mines").queue_free()


func _handle_movement_input():
	var direction: Vector2 = Input.get_vector("player_move_left","player_move_right","player_move_up","player_move_down");
	velocity.x = move_toward(velocity.x, _SPEED* direction.x, _ACCELERATION);
	velocity.y = move_toward(velocity.y, _SPEED* direction.y, _ACCELERATION);
	


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
