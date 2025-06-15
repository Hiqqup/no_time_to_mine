class_name UpgradeButtonBase
extends SkillTreeButtonBase



@export var upgrade_properties: UpgradeProperties:
	set(val):
		upgrade_properties = val;
		setup();

@onready var _frame_sprite: TextureRect = $WrapperButton/Visuals/Frame;
@onready var _button_sprite: TextureRect = $WrapperButton/Visuals/Button;
@onready var _animation_player: AnimationPlayer = $WrapperButton/ButtonAnimationWrapperContainer/Wrapper/AnimationPlayer;
@onready var _wrapper_button: TextureButton = $WrapperButton
@onready var _explosion: CPUParticles2D = $Explosions/Explosion


var cost: Dictionary[ItemTypes.types, int]:
	set(value):
		cost = value;
		_info_label.generate_cost_display(cost);
var _forge_storage_contents: Dictionary[ItemTypes.types, int];
var _forge: Forge;
var _children_visible: bool = false;

var level : int = 0:
	set(value):
		if value != 0:
			_show_all_children();
			modulate = Color.WHITE;
		level = value;
		_info_label.update_level(level);
		if value == upgrade_properties.max_level:
			_info_label.remove_cost_display();


# children:
var _info_label: UpgradeButtonInfoLabel;

func setup():
	if upgrade_properties == null:
		#print("missing upgrade poperties")
		return;
	level = _forge.upgrades_purchased[upgrade_properties.upgrade_type];
	
	cost = upgrade_properties.cost_func.call(level);

	for i in level:
		upgrade_properties.apply_upgrade.call();
	
	_info_label.setup(level, upgrade_properties);
	
	var parent: UpgradeButtonBase = (get_parent() as UpgradeButtonBase);
	if parent and parent._children_visible:
		visible = true;
	if not_visible_because_max_level():
		visible = false;

	
	
	update_frame_sprite();


func update_frame_sprite():
	_button_sprite.modulate = Color.WHITE;
	if level == upgrade_properties.max_level:
		_frame_sprite.modulate = _info_label._yellow
		_button_sprite.modulate = Color.DARK_GRAY;
		return;
	if _check_affordable():
		_frame_sprite.modulate =  _info_label._green
	else:
		_button_sprite.modulate = Color.DARK_GRAY;
		_frame_sprite.modulate =  _info_label._red

func _ready() -> void:
	super();
	_forge = get_tree().get_first_node_in_group("forge")
	_forge_storage_contents = (_forge.get_node("Storage").contents);

	# get children:
	_info_label = $InfoLabel;
	
	visible = false;
	_info_label.visible = false;
	_wrapper_button.pressed.connect(_on_wrapper_button_pressed);
	

func _on_wrapper_button_pressed() -> void:	
	Camera.shake(6)
	if not _check_affordable() or level == upgrade_properties.max_level:
		_animation_player.play("denied")
		return;
	((get_tree().get_first_node_in_group("shockwave") as ShockwaveEffect)
		.at(Camera.convert_position(global_position)));
	if _explosion.emitting:
		$Explosions.add_child(_explosion.duplicate())
	_explosion.emitting = true;
	_appy_cost()
	_forge.update_and_generate_storage_display();
	_forge.purchase_upgrade(upgrade_properties.upgrade_type);
	level += 1;
	cost = upgrade_properties.cost_func.call(level);
	upgrade_properties.apply_upgrade.call();
	_show_all_children();
	if _animation_player.is_playing():
		_animation_player.stop();
	_animation_player.play("click")
	_forge.update_all_upgrades();

func not_visible_because_max_level():
	return LevelTypes.is_higher( upgrade_properties.level_unlocked, _forge._save_state.max_unlocked_level)
	

static func check_button_list_visibility(button_list: Array, sound_on_first_button: bool = true ):
	var first_child: bool = sound_on_first_button;
	for child in button_list:
		if child is UpgradeButtonBase and child.upgrade_properties and not child.visible:
			TimeoutCallback.timeout_callback(0.2, func():
				if child.not_visible_because_max_level():
					return;
				child.visible = true;
				if first_child:
					child._animation_player.play("level_unlocked")
				else: 
					child._animation_player.play("level_unlocked_no_sound")
			)

func _show_all_children():
	if _children_visible:
		return
	_children_visible = true;
	check_button_list_visibility(get_children());


func _on_wrapper_button_mouse_entered() -> void:
	_info_label.visible = true;
	_animation_player.play("hover");
	


func _on_wrapper_button_mouse_exited() -> void:
	_info_label.visible = false;


func _check_affordable() ->bool:
	for key in cost.keys():
		if (not _forge_storage_contents.has(key) 
			or  cost[key] > _forge_storage_contents[key]):
			return false;
	return true;


func _appy_cost():
	for key in cost.keys():
		_forge_storage_contents[key] -= cost[key]; 
