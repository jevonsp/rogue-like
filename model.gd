extends Node

signal dungeon_updated(dung: Array)
signal dungeon_ready

@export var dimensons: Vector2i = Vector2i(5, 5)

var dungeon: Array = []
var player_vec: Vector2i = Vector2.ZERO
var player_is_moving: bool = false

func _ready() -> void:
	make_dungeon()

func make_dungeon():
	print("making dungeon")
	for i in dimensons.x:
		var row := []
		for y in dimensons.x:
			row.append(".")
		dungeon.append(row)
	dungeon_ready.emit()

func move_player(dir: Vector2i):
	dungeon[player_vec.x][player_vec.y] = "."
	var want_to_move = player_vec + Vector2i(dir.y, dir.x)
	print("want_to_move: %s, %s" % [want_to_move.y + 1,want_to_move.x + 1])
	if want_to_move.x < 0 or want_to_move.y < 0:
		print("player cannot move there!")
		dungeon[player_vec.x][player_vec.y] = "@"
		dungeon_updated.emit(dungeon)
		return
	if want_to_move.y >= dimensons.y or want_to_move.x >= dimensons.x:
		print("player cannot move there!")
		dungeon[player_vec.x][player_vec.y] = "@"
		dungeon_updated.emit(dungeon)
		return
	player_vec = want_to_move
	update_player(player_vec)
	
func update_player(pos: Vector2i):
	if player_is_moving:
		return
	player_is_moving = true
	player_vec = pos
	print("player at: %s, %s" % [player_vec.y + 1,player_vec.x + 1])
	dungeon[pos.x][pos.y] = "@"
	dungeon_updated.emit(dungeon)
	player_is_moving = false
