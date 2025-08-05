extends Node

const TILE_SIZE = Vector2(16,8);
const VISUALS_NODE_NAME = "Visuals"
const _GLOW_MODULATE_FACTOR = 1.5;
const GLOW_MODULATE = Color(_GLOW_MODULATE_FACTOR,_GLOW_MODULATE_FACTOR,_GLOW_MODULATE_FACTOR)
const FIRST_DROP := ItemTypes.types.RED_CAP_STONE; 
const MIN_ZOOM:= 1.9;
const BOUNCE_DECAY:=0.93;
const BOUNCE_IMPULSE:= 2.4 * 50;
const ORB_BOUNCE_IMPULSE:= 200;
const LOW_PASS_FILTER_HZ = 400;
const MUSIC = true;
const SCALE_BUTTONS_MOBILE: float =1.5;

func COMPILED()->bool:
	return not OS.has_feature("editor");

func MOBILE()->bool:
	if Camera.options.has(TitleScreenOptions.option_type.mobile_controls):
		return  Camera.options[TitleScreenOptions.option_type.mobile_controls];
	#return true;
	return (OS.has_feature("mobile") or
		OS.has_feature("web_ios") or
		OS.has_feature("web_android") or
		OS.has_feature("android") or 
		OS.has_feature("ios") or 
		OS.has_feature("android")  
		)
	;


const USER_PATH := "user://savegame.tres";
const OPTIONS_PATH := "user://options.tres";
