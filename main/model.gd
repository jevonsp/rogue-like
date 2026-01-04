extends Node

signal dungeon_updated(dung: Array)

@export var dimensons: Vector2i = Vector2i(6, 6)

var dungeon: Array = []

var player: Model
var enemies: Dictionary = {}

var player_vec: Vector2i = Vector2.ZERO
var player_is_moving: bool = false

func make_dungeon():
	print("making dungeon")
	dungeon.clear()
	
	for r in range(dimensons.x):
		var row := []
		for c in range(dimensons.y):
			if r == 0 or r == dimensons.x - 1 or c == 0 or c == dimensons.x - 1:
				row.append("W")
			else:
				row.append(".")
		dungeon.append(row)
	dungeon_updated.emit(dungeon)

func move_player(dir: Vector2i):
	var want_to_move = player_vec + dir
	
	var move = validate_move_to(want_to_move)
	
	if move:
		move_obj(player_vec, want_to_move, "@", player)
		player_vec = want_to_move
	else:
		pass

func place_obj(pos: Vector2i, char_repr: String):
	dungeon[pos.x][pos.y] = char_repr
	dungeon_updated.emit(dungeon)
	
func move_obj(from: Vector2i, to: Vector2i, char_repr: String, model: Model):
	dungeon[from.x][from.y] = "."
	dungeon[to.x][to.y] = char_repr
	
	model.dungeon_vec = to
	
	dungeon_updated.emit(dungeon)
	
func validate_move_to(pos: Vector2i) -> bool:
	match dungeon[pos.x][pos.y].to_upper():
		"@": return false
		"W": return false
		"E": return false
	return true
