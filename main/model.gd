extends Node

signal dungeon_updated(dung: Array)

@export var dimensons: Vector2i = Vector2i(6, 6)

var dungeon: Array = []

var player: Model
var enemies: Array = []

var player_vec: Vector2i = Vector2.ZERO

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
	if not player.can_act:
		print("player cant act")
		return
		
	var want_to_move = player_vec + dir

	var attack = validate_attack_to(want_to_move, player)
	if attack:
		player.can_act = false
		var target: Model
		for enemy: Model in enemies:
			if enemy.dungeon_vec == want_to_move:
				target = enemy
		
		if target:
			player.attack(target)
			dungeon_updated.emit(dungeon)
		return
			
	var move = validate_move_to(want_to_move)
	if move:
		player.can_act = false
		var target: Model
		for enemy: Model in enemies:
			if enemy.dungeon_vec == want_to_move:
				target = enemy
		if target:
			player.attack(target)
		move_obj(player_vec, want_to_move, "@", player)
		player_vec = want_to_move
		

func place_obj(pos: Vector2i, char_repr: String):
	dungeon[pos.x][pos.y] = char_repr
	dungeon_updated.emit(dungeon)
	
func move_obj(from: Vector2i, to: Vector2i, char_repr: String, model: Model):
	dungeon[from.x][from.y] = "."
	dungeon[to.x][to.y] = char_repr
	
	model.dungeon_vec = to
	
	dungeon_updated.emit(dungeon)

# Can make this in to normal collision checks
func validate_move_to(pos: Vector2i) -> bool:
	match dungeon[pos.x][pos.y].to_upper():
		"@": return false
		"W": return false
		"E": return false
	return true

func validate_attack_to(pos: Vector2i, attacker: Model) -> bool:
	match dungeon[pos.x][pos.y].to_upper():
		"W": return false
		"@": 
			if attacker.char_repr == "E":
				return true
			return false
		"E": 
			if attacker.char_repr == "@":
				return true
			return false
	return false

func on_player_turn_taken(model: Model):
	if model.char_repr == "@":
		take_enemy_turns()

func take_enemy_turns():
	for enemy: Model in enemies:
		enemy.take_turn()
	player.can_act = true
	
func remove_obj(model: Model):
	var pos = model.dungeon_vec
	if enemies.has(model):
		enemies.erase(model)
	dungeon[pos.x][pos.y] = "."
	dungeon_updated.emit(dungeon)
