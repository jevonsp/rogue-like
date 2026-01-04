extends Node2D
class_name View

var cell_size

static func v2i_to_display(pos: Vector2i, c_size: Vector2i) -> Vector2:
	return Vector2(c_size.x * (pos.x - 1), c_size.y * (pos.y - 1)) + Vector2(c_size.x / 2.0, c_size.y / 2.0)

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
	position = v2i_to_display(pos, cell_size)

func on_model_moved(model: Model):
	var pos = Model.array_to_display(model.dungeon_vec)
	position = v2i_to_display(pos, cell_size)
	
func on_model_attacked(_model: Model):
	pass
	
func on_model_died(_model: Model):
	queue_free()
