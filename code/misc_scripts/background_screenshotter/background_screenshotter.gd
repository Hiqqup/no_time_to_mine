extends Node2D
@onready var viewport_preview: TextureRect = $CanvasLayer/ViewportPreview
@onready var sub_viewport: SubViewport = $SubViewport
@onready var background: ColorRect = $SubViewport/Background
@export var _size: Vector2
@export var _color: LevelTypes.types
func _ready():
	#background.set_deferred("size", _size);
	sub_viewport.set_deferred("size", _size);
	

	background._set_colors(_color);
	
	viewport_preview.texture = sub_viewport.get_texture()

func _on_save_pressed() -> void:
	sub_viewport.get_texture().get_image().save_png("res://misc_scripts/background_screenshotter/shot.png")
