extends Control
class_name TitleScreenOptions
@export var _button_antimation_wrapper_scene: PackedScene
@onready var _buttons_container: VBoxContainer = $PanelContainer/VBoxContainer

var _options_resource: OptionsResource;

@onready var music: CheckBox = $PanelContainer/VBoxContainer/Music
@onready var cheats: CheckBox = $PanelContainer/VBoxContainer/Cheats
@onready var screen_shake: CheckBox = $PanelContainer/VBoxContainer/ScreenShake
@onready var shockwave_effect: CheckBox = $PanelContainer/VBoxContainer/ShockwaveEffect
@onready var mobile_controls: CheckBox = $PanelContainer/VBoxContainer/MobileControls


enum option_type{
music,
cheats,
screen_shake,
shockwave_effect,
mobile_controls,
}

@onready var option_type_map: Dictionary[option_type, CheckBox] ={
	option_type.music : music,
	option_type.cheats : cheats,
	option_type.screen_shake :screen_shake ,
	option_type.shockwave_effect :shockwave_effect ,
	option_type.mobile_controls: mobile_controls,
}

func get_option_dict()-> Dictionary[option_type, bool]:

	
	var ret: Dictionary[option_type, bool];
	for i in option_type.size():
		ret[i] = option_type_map[i].button_pressed;
	return ret;

func _set_default_settings():
	if not GlobalConstants.COMPILED():
		shockwave_effect.button_pressed = false;
		music.button_pressed = false;
		#cheats.button_pressed = true;
	
	mobile_controls.button_pressed = GlobalConstants.MOBILE()
	

func _ready():
	if FileAccess.file_exists(GlobalConstants.OPTIONS_PATH):
		_options_resource = load(GlobalConstants.OPTIONS_PATH);
		for i in _options_resource.options.keys():
			option_type_map[i].button_pressed = _options_resource.options[i]
	else:
		_options_resource = OptionsResource.new();
		_options_resource.take_over_path(GlobalConstants.OPTIONS_PATH);
		_set_default_settings()
		
	for i in _buttons_container.get_children():
		i.size.x = _buttons_container.size.x;
		i.add_child(_button_antimation_wrapper_scene.instantiate())



func _on_close_pressed() -> void:
	_options_resource.options = get_option_dict();
	ResourceSaver.save(_options_resource, _options_resource.resource_path);
	get_parent().get_parent().toggle_settings();
