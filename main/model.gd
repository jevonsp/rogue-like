extends Node

signal dungeon_updated(dung: Array)

var map: TileMapLayer
var walls: Array[Vector2i]
var floors: Array[Vector2i]

var player: Model
var enemies: Array = []

var player_vec: Vector2i = Vector2.ZERO

func make_dungeon():
	print("making dungeon")
	
	map = $"../Map/Map"
	
	# First, let's see the actual bounds
	var used_rect = map.get_used_rect()
	print("Used rect: position=%s, size=%s" % [used_rect.position, used_rect.size])
	
	# Check every single cell in the used rect
	print("\nFull grid contents:")
	for y in range(used_rect.position.y, used_rect.position.y + used_rect.size.y):
		var row = ""
		for x in range(used_rect.position.x, used_rect.position.x + used_rect.size.x):
			var cell = Vector2i(x, y)
			if map.get_cell_source_id(cell) != -1:  # Has a tile
				var atlas_coords = map.get_cell_atlas_coords(cell)
				if atlas_coords == Vector2i(0, 0):
					row += "#"  # Wall
				elif atlas_coords == Vector2i(1, 0):
					row += "."  # Floor
				else:
					row += "?"  # Unexpected tile
			else:
				row += " "  # Empty
		print(row)
	
	# Now get walls and floors
	var map_walls = map.get_used_cells_by_id(0, Vector2i(0, 0))
	var map_floors = map.get_used_cells_by_id(0, Vector2i(1, 0))
	
	print("\nWalls found: %d" % map_walls.size())
	print("Floors found: %d" % map_floors.size())
	
	walls = map_walls
	walls.sort()
	print("walls: ")
	print(walls)
	floors = map_floors
	floors.sort()
	print("floors: ")
	print(floors)
	
	var bounds = map.get_used_rect()
	Pathfinder.dimensions = Vector2i(bounds.size.x, bounds.size.y)

func move_player(dir: Vector2i):
	if not player.can_act:
		print("player cant act") 
		return
		
	var want_to_move = player_vec + dir
	print(want_to_move)

	var attack = validate_attack_to(want_to_move, player)
	if attack:
		player.can_act = false
		var target: Model
		for enemy: Model in enemies:
			if enemy.dungeon_vec == want_to_move:
				target = enemy
		
		if target:
			player.attack(target)
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
		player_vec = want_to_move
		move_obj(player_vec, want_to_move, "@", player)


func place_obj(pos: Vector2i, char_repr: String):
	pass
	
func move_obj(from: Vector2i, to: Vector2i, char_repr: String, model: Model):
	model.dungeon_vec = to

func validate_move_to(pos: Vector2i) -> bool:
	if pos == player_vec:
		return false
	if pos in walls:
		print("%s has wall" % [pos])
		return false
	for enemy: Model in enemies:
		if enemy.dungeon_vec == pos:
			return false
	return true

func validate_attack_to(pos: Vector2i, attacker: Model) -> bool:
	if attacker == player:
		if pos == player_vec:
			return false
		if pos in walls:
			return false
		for enemy: Model in enemies:
			if enemy.dungeon_vec == pos:
				return true
	else:
		if pos == player_vec:
			return true
		if pos in walls:
			return false
		for enemy: Model in enemies:
			if enemy.dungeon_vec == pos:
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
