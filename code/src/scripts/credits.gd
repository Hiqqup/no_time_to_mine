extends CanvasLayer
class_name CreditScene
signal quit
@onready var button: Button = $VBoxContainer/Control/Button
@onready var control: Control = $VBoxContainer/Control

func _ready() -> void:
	button.pivot_offset = button.size/2;
	control.custom_minimum_size = button.size * button.scale + Vector2(0 , 50);
	button.pressed.connect(quit.emit)
