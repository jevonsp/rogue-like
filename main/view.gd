extends Node2D

@export var cell_size = Vector2i(64, 64)

var grid_size = Vector2i(5, 5)

var walls: Array[Vector2i] = []

@onready var model: Node = $"../Model"

func _ready() -> void:
	pass

func _draw() -> void:
	draw_grid()
	for wall in walls:
		draw_rect(Rect2(wall * cell_size, cell_size), Color.ORANGE_RED)
	
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
	walls.clear()
	
	for y in range(dungeon.size()):
		var row = dungeon[y]
		for x in range(row.size()):
			if row[x] == "W":
				walls.append(Vector2i(x, y))
		
	queue_redraw()
