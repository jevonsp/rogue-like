extends Node

var astar_grid = AStarGrid2D.new()
var model

func initialize_astar():
	var used_rect = model.map.get_used_rect()
	astar_grid.size = Vector2i(used_rect.size.x, used_rect.size.y)
	print(astar_grid.size)
	astar_grid.cell_size = Vector2i(1, 1)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()

func get_grid_path(from: Vector2i, to: Vector2i) -> PackedVector2Array:
	return astar_grid.get_point_path(from, to)
