extends Node
class_name GuiItemListDisplayer;

@export var _item_sprite_mapper: ItemTypes;

signal updated;


var _already_displaying: Dictionary[ItemTypes.types, bool];

var _generated_labels: Dictionary[ItemTypes.types,Label]
var _generated_sprites: Dictionary[ItemTypes.types, TextureRect];

var _generated_hbox: Dictionary[ItemTypes.types, HBoxContainer];
var _vcontainer: VBoxContainer
func _ready() -> void:
	for type in ItemTypes.types.size():
		_already_displaying[type] = false;


func generate_or_update_mod_label(
	vcontainer: VBoxContainer, 
	item_list: Dictionary[ItemTypes.types, int]):
	generate_or_update(vcontainer, item_list)
	for key in _generated_labels.keys():
		if _generated_labels[key].text == "1":
			_generated_labels[key].text = ""


func generate_or_update(
	vcontainer: VBoxContainer, 
	item_list: Dictionary[ItemTypes.types, int]):
	
	_vcontainer = vcontainer
	const label_name:="Label"
	var item_sprites = _item_sprite_mapper;
	for type in item_list.keys():
		if item_list[type] > 0:
			if not _already_displaying[type]:
				var hcontainer = HBoxContainer.new();
				_already_displaying[type] = true;
				hcontainer.name = str(type);
				hcontainer.alignment = BoxContainer.ALIGNMENT_CENTER;
				_generated_hbox[type] = hcontainer;
				var texture_rect: TextureRect = item_sprites.get_copy_texture_rect(type);
				_generated_sprites[type] = texture_rect;
				hcontainer.add_child(texture_rect);
				var label = Label.new();
				_generated_labels[type] = label;
				label.name = label_name
				label.text = str(item_list[type]);
				hcontainer.add_child(label)
				vcontainer.add_child(hcontainer)
			else:
				var label = vcontainer.get_node(str(type) + "/"+label_name);
				label.text = str(item_list[type]);
		if item_list[type] == 0 and _already_displaying[type]:
			vcontainer.get_node(str(type)).queue_free();
			_already_displaying[type] = false
			_generated_sprites.erase(type);
	updated.emit();
