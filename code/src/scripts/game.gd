extends Node2D
@onready var music: AudioStreamPlayer = $Music
@onready var shockwave_effect: ShockwaveEffect = $ShockwaveEffect

func _ready() -> void:

	
	shockwave_effect.visible = Camera.options[TitleScreenOptions.option_type.shockwave_effect];
	AudioServer.set_bus_mute(
		AudioServer.get_bus_index("Music"),
		not Camera.options[TitleScreenOptions.option_type.music]
		);

		
