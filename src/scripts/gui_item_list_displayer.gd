extends Node

@export var _item_sprite_mapper: ItemTypes;



var _already_displaying: Dictionary[ItemTypes.types, bool];

var _generated_labels: Array[Label]

func _ready() -> void:
	for type in ItemTypes.types.size():
		_already_displaying[type] = false;


func generate_or_update_mod_label(
	vcontainer: VBoxContainer, 
	item_list: Dictionary[ItemTypes.types, int]):
	generate_or_update(vcontainer, item_list)
	for label in _generated_labels:
		if label.text == "1":
			label.text = ""


func generate_or_update(
	vcontainer: VBoxContainer, 
	item_list: Dictionary[ItemTypes.types, int]):
	
	const label_name:="Label"
	var item_sprites = _item_sprite_mapper;
	for type in item_list.keys():
		if item_list[type] > 0:
			if not _already_displaying[type]:
				var hcontainer = HBoxContainer.new();
				_already_displaying[type] = true;
				hcontainer.name = str(type);
				hcontainer.alignment = BoxContainer.ALIGNMENT_CENTER;
				hcontainer.add_child(item_sprites.get_copy_texture_rect(type));
				var label = Label.new();
				_generated_labels.push_back(label);
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
