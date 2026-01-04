extends Node

@export var starting_pos: Vector2i = Vector2i(4, 4)

signal player_spawned(pos: Vector2i)
signal player_moved(dir: Vector2i)

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("up"):
		player_moved.emit(Vector2i.UP)
	elif event.is_action_pressed("down"):
		player_moved.emit(Vector2i.DOWN)
	elif event.is_action_pressed("left"):
		player_moved.emit(Vector2i.LEFT)
	elif event.is_action_pressed("right"):
		player_moved.emit(Vector2i.RIGHT)
		
func spawn_player():
	player_spawned.emit(starting_pos)
