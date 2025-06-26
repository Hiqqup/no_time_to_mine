extends Node

@onready var _item_list: GuiItemListDisplayer = get_parent();
@export var _outline_shader:Shader;
@onready var _tooltip_base: PanelContainer = $Tooltip
var _generated_tooltips: Dictionary[ItemTypes.types, PanelContainer];
var _updated: Dictionary[ItemTypes.types, bool]

func _ready() -> void:
	_item_list.updated.connect(_update);

func _update():
	for key in _item_list._already_displaying.keys():
		if not _item_list._already_displaying[key]:
			_updated.erase(key);
			_generated_tooltips.erase(key);
	_item_list._vcontainer.size.x = 0;
	for key in _generated_tooltips.keys():
		call_deferred("_update_tooltip", _generated_tooltips[key]);
	
	for key in _item_list._generated_sprites.keys():
		if _updated.has(key):
			continue;
		var hcontainer: HBoxContainer = _item_list._generated_hbox[key];
		hcontainer.alignment = BoxContainer.ALIGNMENT_BEGIN;
		var trect:TextureRect = _item_list._generated_sprites[key];
		trect.texture = VisualUtility.add_transparent_border(trect.texture);
		
		
		var tooltip: PanelContainer = _tooltip_base.duplicate();
		var tooltip_label :  Label = Label.new();
		tooltip.add_child(tooltip_label);
		tooltip_label.text = ItemTypes.types.keys()[key];
		trect.add_child(tooltip);
		
		call_deferred("_update_tooltip", tooltip);
		
		_generated_tooltips[key] = tooltip;
		
		var shader_material: ShaderMaterial = ShaderMaterial.new();
		trect.material = shader_material;
		shader_material.shader = _outline_shader
		shader_material.set_shader_parameter("outline_color",Color.WHITE);
		shader_material.set_shader_parameter("show",false);
		
		trect.mouse_entered.connect(func(): 
			shader_material.set_shader_parameter("show",true)
			tooltip.visible = true;
			);
		trect.mouse_exited.connect(func(): 
			shader_material.set_shader_parameter("show",false)
			tooltip.visible = false;
			);
		
		
		_updated[key] = true;
		
		
func _update_tooltip(tooltip: PanelContainer):
	tooltip.position.x = _item_list._vcontainer.size.x + 10;
	tooltip.pivot_offset.y = tooltip.size.y/2;
	tooltip.scale = Vector2.ONE * 0.5;
	#print("updated")
