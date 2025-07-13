extends CanvasLayer
class_name CreditScene
signal quit
@onready var button: Button = $PanelContainer/VBoxContainer/Control/Button
@onready var control: Control = $PanelContainer/VBoxContainer/Control

func _ready() -> void:
	button.pivot_offset = button.size/2;
	control.custom_minimum_size = button.size * button.scale + Vector2(0 , 50);
	button.pressed.connect(quit.emit)
