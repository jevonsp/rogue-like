extends Node
class_name Model

signal model_moved(model)
signal model_attacked(model)
signal model_died(model)

var model: Node

var char_repr: String = ""
var can_act: bool = false
var dungeon_vec: Vector2i = Vector2i.ZERO:
	set(value):
		dungeon_vec = value
		model_moved.emit(self)

var attack_damage: float = 1.0
var max_hitpoints: float = 5.0
var current_hitpoints: float

var stickiness: float = 0.8
var sight_range: int = 5

func _ready() -> void:
	current_hitpoints = max_hitpoints

func take_turn():
	var path = Pathfinder.get_grid_path(dungeon_vec, model.player_vec)
	
	if len(path) > sight_range:
		while true:
			var dir = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT].pick_random()
			var move = dungeon_vec + dir
			if model.validate_move_to(move):
				model.move_obj(dungeon_vec, move, "E", self)
				break
		return
	
	if path.size() > 1:
		var next_step = Vector2i(path[1])
		var rand = randf()
		var stick = (rand > (1.0 - stickiness))
		if stick:
			if model.validate_move_to(next_step):
				if next_step == model.player_vec:
					attack(model.player)
				model.move_obj(dungeon_vec, next_step, "E", self)
			elif model.validate_attack_to(next_step, self):
				var target = model.player
				if target:
					attack(target)
		else:
			while true:
				var dir = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT].pick_random()
				var move = dungeon_vec + dir
				if model.validate_move_to(move):
					model.move_obj(dungeon_vec, move, "E", self)
					break
			return
	
func attack(defender: Model):
	defender.current_hitpoints -= attack_damage
	model_attacked.emit(self)
	if defender.current_hitpoints <= 0:
		defender.die()
	
func die():
	match char_repr:
		"@":
			print("player would die here")
		"E":
			model_died.emit(self)
			queue_free()
