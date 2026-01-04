extends Node

var astar_grid = AStarGrid2D.new()
var model

func initialize_astar():
	var dungeon = model.dungeon
	astar_grid.size = Vector2i(dungeon[0].size(), dungeon.size())
	astar_grid.cell_size = Vector2i(1, 1)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()
	
	for y in range(dungeon.size()):
		for x in range(dungeon[y].size()):
			if dungeon[y][x] == "W":
				astar_grid.set_point_solid(Vector2i(x, y), true)
				
func get_grid_path(from: Vector2i, to: Vector2i) -> PackedVector2Array:
	return astar_grid.get_point_path(from, to)
