extends Node2D

@export var cell_size = Vector2i(64, 64)

var grid_size = Vector2i(5, 5)

var walls: Array[Vector2i] = []

@onready var model: Node = $"../Model"

func _ready() -> void:
	pass
