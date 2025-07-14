extends Control
class_name ButtonAnimationWrapper


enum animations{
	level_unlocked ,
	click,
	hover,
	denied,
}
@onready var _animation_player: AnimationPlayer = $Wrapper/AnimationPlayer
@onready var _parent: BaseButton = get_parent();
@onready var _wrapper: Control = $Wrapper

func _ready() -> void:
	
	_wrapper.size = _parent.size
	_wrapper.pivot_offset = _wrapper.size/2
	$Wrapper/Explosion.position = _wrapper.size/2;
	custom_minimum_size = _wrapper.size
	
	_parent.pressed.connect(func():_animation_player.play("click"))
	_parent.mouse_entered.connect(func():_animation_player.play("hover"))
	
	call_deferred("_handle_parenting")
	
	$Wrapper/Placeholder.queue_free();

func play_animation(animation : animations):
	_animation_player.play(animations.keys()[animation])

func _not_playing_level_unlocked():
	return not (_animation_player.is_playing() and _animation_player.current_animation == "level_unlocked")

func _handle_parenting():
	reparent(_parent.get_parent());
	_parent.reparent(_wrapper)
