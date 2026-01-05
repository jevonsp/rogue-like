extends Node
class_name Model

signal model_moved(model)
signal model_removed(model)

var model: Node
var char_repr: String = ""
var data: ItemResource

var dungeon_vec: Vector2i = Vector2i.ZERO:
	set(value):
		dungeon_vec = value
		model_moved.emit(self)
		
