extends Node2D
class_name View

var cell_size: Vector2i

func convert_v2i(pos: Vector2i) -> Vector2:
	return Vector2(pos.x * cell_size.x - (cell_size.x / 2.0), pos.y * cell_size.y - (cell_size.x / 2.0))

func bind(model: Model):
	model.model_moved.connect(on_model_moved)
	if model is Character:
		model.model_removed.connect(on_model_removed)
		model.model_attacked.connect(on_model_attacked)
	if model is Item:
		model.item_picked_up.connect(on_model_removed)
	match model.char_repr:
		"@":
			modulate = Color.GREEN
		"I":
			modulate = Color.YELLOW
		"E":
			modulate = Color.RED

func display(pos: Vector2i, size: Vector2 = Vector2(1, 1)):
	position = convert_v2i(pos)
	scale = size

func on_model_moved(model: Model):
	var pos = model.dungeon_vec
	position = convert_v2i(pos)
	
func on_model_attacked(_model: Model):
	pass
	
func on_model_removed(_model: Model):
	queue_free()
