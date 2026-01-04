extends Node2D

@export var cell_size = Vector2i(64, 64)

var astar_grid = AStarGrid2D.new()
var grid_size

var walls: Array[Vector2i] = []

func _ready() -> void:
	initialize_grid()

func _draw() -> void:
	draw_grid()
	for wall in walls:
		draw_rect(Rect2(wall * cell_size, cell_size), Color.ORANGE_RED)

func initialize_grid():
	grid_size = Vector2i(get_viewport_rect().size) / cell_size
	astar_grid.size = grid_size
	astar_grid.cell_size = cell_size
	astar_grid.offset = cell_size / 2
	astar_grid.update()
	
func draw_grid():
	for x in grid_size.x + 1:
		draw_line(Vector2(x * cell_size.x, 0),
			Vector2(x * cell_size.x, grid_size.y * cell_size.y),
			Color.DARK_GRAY, 2.0)
	for y in grid_size.y + 1:
		draw_line(Vector2(0, y * cell_size.y),
			Vector2(grid_size.x * cell_size.x, y * cell_size.y),
			Color.DARK_GRAY, 2.0)

func display_dungeon(dungeon: Array):
	for row in dungeon:
		print(row)
		
	walls.clear()
	
	for y in range(dungeon.size()):
		var row = dungeon[y]
		for x in range(row.size()):
			if row[x] == "W":
				walls.append(Vector2i(x, y))
		
	queue_redraw()
