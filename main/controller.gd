extends Node

@export var starting_pos: Vector2i = Vector2i(1, 1)

signal player_move_attempt(dir: Vector2i)

@onready var model: Node = $"../Model"
@onready var view: Node = $"../View"

const VIEW = preload("res://entities/view.tscn")

var enemy_counter: int = 0

func _ready() -> void:
	setup_game()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("up"):
		player_move_attempt.emit(Vector2.UP)
	elif event.is_action_pressed("down"):
		player_move_attempt.emit(Vector2.DOWN)
	elif event.is_action_pressed("left"):
		player_move_attempt.emit(Vector2.LEFT)
	elif event.is_action_pressed("right"):
		player_move_attempt.emit(Vector2.RIGHT)

func setup_game():
	setup_connections()
	model.make_dungeon()
	Pathfinder.model = model
	Pathfinder.initialize_astar()
	spawn_obj(Vector2i(starting_pos.x + 1, starting_pos.y + 1), "@")
	model.player_vec = Vector2i(starting_pos.x + 1, starting_pos.y + 1)
	spawn_obj(Vector2i(5,4), "E")

func setup_connections():
	player_move_attempt.connect(model.move_player)

func spawn_obj(pos: Vector2i, char_repr: String):
	
	var new_model = Model.new()
	new_model.model = model
	new_model.char_repr = char_repr
	new_model.dungeon_vec = pos
	
	var new_view: View = VIEW.instantiate()
	new_view.cell_size = view.cell_size
	new_view.bind(new_model)
	new_view.display(pos)
	
	match char_repr:
		"@":
			new_model.name = "Player"
			new_model.model_moved.connect(model.on_player_turn_taken)
			new_model.model_attacked.connect(model.on_player_turn_taken)
			model.player = new_model
			new_model.can_act = true
		"E":
			enemy_counter += 1
			new_model.name = "Enemy %s" % [enemy_counter]
			new_model.model_died.connect(model.remove_obj)
			model.enemies.append(new_model)
			
	model.add_child(new_model)
	view.add_child((new_view))
