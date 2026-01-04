extends Node
class_name Model

signal model_moved(model)
signal model_attacked(model)
signal model_died(model)

var char_repr: String = ""
var can_act: bool = false
var dungeon_vec: Vector2i = Vector2i.ZERO:
	set(value):
		dungeon_vec = value
		print("%s moved to %s" % [char_repr, dungeon_vec])
		model_moved.emit(self)

var attack_damage: float = 1.0
var max_hitpoints: float = 5.0
var current_hitpoints: float

var stickiness: float = 0.8
var sight_range: int = 1

static func array_to_display(pos: Vector2i) -> Vector2i:
	return Vector2i(pos.y + 1, pos.x + 1)

static func display_to_array(pos: Vector2i) -> Vector2i:
	return Vector2i(pos.y - 1, pos.x - 1)

func _ready() -> void:
	print("%s spawned at %s" % [char_repr, dungeon_vec])
	current_hitpoints = max_hitpoints

func take_turn():
	pass
	
func attack(defender: Model):
	defender.current_hitpoints -= attack_damage
	model_attacked.emit(self)
	print("%s attacked %s" % [self, defender])
	print("%s at %s hp" % [defender, defender.current_hitpoints])
	if defender.current_hitpoints <= 0:
		defender.die()
	
func die():
	match char_repr:
		"@": print("player would die here")
		"E":
			print("enemy would die here")
			model_died.emit(dungeon_vec, self)
			queue_free()
