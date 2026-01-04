extends Node
class_name Model

var char_repr: String = ""
var is_moving: bool = false
var dungeon_vec: Vector2i = Vector2i.ZERO:
	set(value):
		dungeon_vec = value
		print("%s moved to %s" % [char_repr, dungeon_vec])

static func array_to_display(pos: Vector2i) -> Vector2i:
	return Vector2i(pos.y + 1, pos.x + 1)

static func display_to_array(pos: Vector2i) -> Vector2i:
	return Vector2i(pos.y - 1, pos.x - 1)

func _ready() -> void:
	print("%s spawned at %s" % [char_repr, dungeon_vec])
