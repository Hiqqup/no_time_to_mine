extends Node2D
class_name CollectorSpawner

@export var _upgrade_stats: PlayerUpgradeStats;
@export var _player: Player;
@export var _collector_scene: PackedScene;


var _untargeted_item: Array[ItemDropBase];
var _unbusy_collector: Array[Collector];

func _set_untargeted_item(drop: ItemDropBase):
		#drop.modulate = Color.BLACK;
		_untargeted_item.push_back(drop);
		_check_for_work();

func _set_unbusy_colletor(collector: Collector):
	_unbusy_collector.push_back(collector);

	_check_for_work()

func _check_for_work():
	if not _unbusy_collector.is_empty() and not _untargeted_item.is_empty():
		var collector: Collector = _unbusy_collector.pop_back();
		var item: ItemDropBase = _untargeted_item.pop_back();
		#item.modulate = Color.RED;
		item.targeted_by = collector;
		collector.targeting = item; 

func _ready():
	
	var pos_offset: float = 4.0;
	for i in _upgrade_stats.collector_amount:
		var collector: Collector = _collector_scene.instantiate();
		collector.position = _player.position;
		collector.spawner = self;
		collector.player = _player;
		_unbusy_collector.push_back(collector);
		collector.position += Vector2(-1,-1) * pos_offset;
		add_child(collector);
		pos_offset+= 4.0;
