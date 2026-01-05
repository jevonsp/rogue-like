extends Node

var astar_grid = AStarGrid2D.new()
var model

var dimensions: Vector2i = Vector2i(6, 6)

func initialize_astar():
	astar_grid.size = Vector2i(dimensions.x, dimensions.y)
	print("size: %s" % [astar_grid.size])
	astar_grid.cell_size = Vector2i(1, 1)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()
	
	for point in model.walls:
		astar_grid.set_point_solid(point, true)
				
func get_grid_path(from: Vector2i, to: Vector2i) -> PackedVector2Array:
	return astar_grid.get_point_path(from, to)
