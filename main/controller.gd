extends Node

@export var starting_pos: Vector2i = Vector2i(5, 5)

signal player_move_attempt(dir: Vector2i)

@onready var model: Node = $"../Model"
@onready var view: Node = $"../View"

var enemy_counter: int = 0

func _ready() -> void:
	setup_game()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("up"):
		player_move_attempt.emit(Vector2i(-1, 0))
	elif event.is_action_pressed("down"):
		player_move_attempt.emit(Vector2i(1, 0))
	elif event.is_action_pressed("left"):
		player_move_attempt.emit(Vector2i(0, -1))
	elif event.is_action_pressed("right"):
		player_move_attempt.emit(Vector2i(0, 1))

func setup_game():
	setup_connections()
	model.make_dungeon()
	spawn_obj(starting_pos, "@")
	model.player_vec = Vector2i(starting_pos.x - 1, starting_pos.y - 1)
	spawn_obj(Vector2i(5,4), "E")

func setup_connections():
	player_move_attempt.connect(model.move_player)
	model.dungeon_updated.connect(view.display_dungeon)

func spawn_obj(display_pos: Vector2i, char_repr: String):
	var array_pos = Model.display_to_array(display_pos)
	print("placing %s at display %s, array %s" % [char_repr, display_pos, array_pos])
	model.place_obj(array_pos, char_repr)
	var new_model = Model.new()
	new_model.char_repr = char_repr
	new_model.dungeon_vec = array_pos
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
			model.enemies[new_model] = array_pos
	model.add_child(new_model)
