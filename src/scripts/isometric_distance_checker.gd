extends Node

func check(a: Vector2, b: Vector2, distance: float)->bool:
	# returns true if the distance of the two points is smaller than distance 
	# on the isometric plane (the y value gets scaled by 0.5)
	var phi = a.angle_to(b) + PI /2;
	var scale = 0.25 * cos(2* phi) + 0.75
	distance *= scale;
	print(rad_to_deg(phi))
	return a.distance_to(b) < distance;
