extends Model
class_name Item

signal item_added_to_inventory(item_resource: ItemResource)
signal item_picked_up(item: Item)

func on_pickup():
	print("pickup")
	item_added_to_inventory.emit(data)
	model_removed.emit(self)
	item_picked_up.emit(self)
