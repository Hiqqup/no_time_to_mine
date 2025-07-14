extends Node


func timeout_callback(wait_time: float, callback :Callable)->void:
	# executes set callback $wait_time seconds from now
	var timer: Timer = Timer.new();
	add_child(timer) 
	timer.wait_time = wait_time
	timer.one_shot = true
	timer.timeout.connect(callback);
	timer.start()
