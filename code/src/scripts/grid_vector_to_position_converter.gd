extends Node
class_name GridVectorConverter

var grid_vector: Vector2i = Vector2i.ZERO

func grid_vector_to_real_coordinates(gv: Vector2i) -> Vector2:
	var vector_x = Vector2(gv.x, gv.x)* GlobalConstants.TILE_SIZE ;
	var vector_y = Vector2(-gv.y, gv.y)* GlobalConstants.TILE_SIZE ;
	return vector_x  + vector_y 


func set_grid_vector(vector: Vector2i):
	grid_vector = vector;
	get_parent().global_position =(grid_vector_to_real_coordinates(vector) 
					+ Vector2(GlobalConstants.TILE_SIZE.x ,0.001));
