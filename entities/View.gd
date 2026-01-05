extends Node2D
class_name View

var cell_size: Vector2i

func convert_v2i(pos: Vector2i) -> Vector2:
	return Vector2(pos.x * cell_size.x - (cell_size.x / 2.0), pos.y * cell_size.y - (cell_size.x / 2.0))

func bind(model: Model):
	model.model_moved.connect(on_model_moved)
	model.model_attacked.connect(on_model_attacked)
	model.model_died.connect(on_model_died)
	match model.char_repr:
		"@":
			modulate = Color.GREEN
		"E":
			modulate = Color.RED

func display(pos: Vector2i):
	position = convert_v2i(pos)

func on_model_moved(model: Model):
	var pos = model.dungeon_vec
	position = convert_v2i(pos)
	
func on_model_attacked(_model: Model):
	pass
	
func on_model_died(_model: Model):
	queue_free()
