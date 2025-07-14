extends Node2D
@onready var music: AudioStreamPlayer = $Music
@onready var shockwave_effect: ShockwaveEffect = $ShockwaveEffect

func _ready() -> void:
	#print(AudioServer.get_bus_index("Music"))
	#(AudioServer.get_bus_effect(AudioServer.get_bus_index("Music"), 0) as AudioEffectLowPassFilter).cutoff_hz = GlobalConstants.LOW_PASS_FILTER_HZ
	
	
	shockwave_effect.visible = Camera.options[TitleScreenOptions.option_type.shockwave_effect];
	AudioServer.set_bus_mute(
		AudioServer.get_bus_index("Music"),
		not Camera.options[TitleScreenOptions.option_type.music]
		);

		
