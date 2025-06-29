extends Node2D
@onready var music: AudioStreamPlayer = $Music

func _ready() -> void:
	$ShockwaveEffect.visible = GlobalConstants.COMPILED();
