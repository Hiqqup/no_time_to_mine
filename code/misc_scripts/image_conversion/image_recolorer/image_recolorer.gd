extends Node

signal recolored;

@export var input_image: Texture;
@export var recolor_map: RecolorMap;
@export var recolor_shader: Shader;

var _shader_material;
var _viewport: SubViewport
var _sprite: Sprite2D
var _append: String;

func _ready() -> void:
	$placeholder.queue_free();
	_viewport = $SubViewport;
	$ViewportDiplay.texture = _viewport.get_texture();
	_viewport.transparent_bg = true;
	var _viewport_size = Vector2i(input_image.get_width(), input_image.get_height())
	_viewport.size = (_viewport_size)
	_sprite = $SubViewport/Sprite2D
	_sprite.centered = false;
	_sprite.texture = input_image;
	_shader_material = ShaderMaterial.new()
	_sprite.material = _shader_material;
	var _shader: Shader =recolor_shader;
	_shader_material.shader = _shader
	
	var rn = recolor_map.resource_path;
	rn = rn.left(rn.length()-5);
	var strsp = rn.split("_");
	_append = strsp[strsp.size() - 1]
	

var color_pair_index: int = 0
var done = false;


	
func _on_button_pressed() -> void:
	if done:
		return
	if color_pair_index >= recolor_map.color_replacments.size()/2.0:
		var str1 = input_image.resource_path
		var str2 = str1.substr(0,str1.length()-4) + "_" + _append + ".png"
		var split1 = str2.split("/")
		split1.insert(split1.size() - 1, "recolored");
		var save_path = "/".join(split1)
		_viewport.get_texture().get_image().save_png(save_path)
		done = true;
		$CanvasLayer/Button.visible = false;
		recolored.emit();
		return;
	_shader_material.set_shader_parameter("color_to_replace", recolor_map.color_replacments[2*color_pair_index]);
	_shader_material.set_shader_parameter("replacement_color", recolor_map.color_replacments[2*color_pair_index+1]);
	color_pair_index+=1;
	var image: Image = _viewport.get_texture().get_image()
	_sprite.texture = ImageTexture.create_from_image( image);
