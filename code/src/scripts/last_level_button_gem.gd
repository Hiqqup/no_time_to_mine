extends TextureButton
class_name LastLevelButtonGem
@onready var _texture_rect: TextureRect = $TextureRect
@onready var _animation_player: AnimationPlayer = $ButtonAnimationWrapperContainer/Wrapper/AnimationPlayer;
@onready var _particles: CPUParticles2D = $ButtonAnimationWrapperContainer/Wrapper/Explosion
@onready var _wrapper : Control = $ButtonAnimationWrapperContainer/Wrapper
@export var _level_types: LevelTypes; 

var _position_mapper: Dictionary[LevelTypes.types, Vector2] = {
	LevelTypes.types.FIRST: Vector2(0,18),
	LevelTypes.types.SECOND: Vector2(40,0),
	LevelTypes.types.THIRD: Vector2(80,18),
	LevelTypes.types.FOURTH: Vector2(80,62),
	LevelTypes.types.FIFTH: Vector2(40,80),
	LevelTypes.types.SIXTH: Vector2(0,62),
}

func _ready() -> void:
	_particles.scale = 0.7 * Vector2.ONE;
	_wrapper.visible = false;
	for signa in [pressed, mouse_entered]: #disconnect signals
		for connection in signa.get_connections():
			signa.disconnect(connection.callable);

	

func setup(level: LevelTypes.types, do_visual_feedback: bool ):
	position = _position_mapper[level] - size/2;
	_texture_rect.texture = _texture_rect.texture.duplicate();
	(_texture_rect.texture as AtlasTexture).atlas = _level_types.tileset_map[level]
	if do_visual_feedback:
		_animation_player.play("level_unlocked_no_sound");
	else:
		_wrapper.visible = true;
