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

func COMPILED()->bool:
	return not OS.has_feature("editor");

func MOBILE()->bool:
	return true;
	return (OS.has_feature("mobile") or
		OS.has_feature("web_ios") or
		OS.has_feature("web_android"))
	;


const USER_PATH := "user://savegame.tres";
