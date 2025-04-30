extends CharacterBody2D

const _SPEED: float = 200;
const _ACCELERATION: float = _SPEED /10;





func _physics_process(_delta: float) -> void:
	var direction: Vector2 = Input.get_vector("player_move_left","player_move_right","player_move_up","player_move_down");
	
	velocity.x = move_toward(velocity.x, _SPEED* direction.x, _ACCELERATION);
	velocity.y = move_toward(velocity.y, _SPEED* direction.y, _ACCELERATION);
	
	move_and_slide();
