extends Control


@onready var animation_player: AnimationPlayer = $Wrapper/AnimationPlayer
@onready var parent: BaseButton = get_parent();
@onready var wrapper: Control = $Wrapper

func _ready() -> void:
	
	wrapper.size = parent.size
	wrapper.pivot_offset = wrapper.size/2
	$Wrapper/Explosion.position = wrapper.size/2;
	custom_minimum_size = wrapper.size
	
	parent.pressed.connect(func():animation_player.play("click"))
	parent.mouse_entered.connect(func():animation_player.play("hover"))
	
	call_deferred("_handle_parenting")
	
	$Wrapper/Placeholder.queue_free();


func _handle_parenting():
	reparent(parent.get_parent());
	parent.reparent(wrapper)
