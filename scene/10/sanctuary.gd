extends MarginContainer


var parent = null


func set_parent(parent_) -> void:
	parent = parent_
	update_rec_size()


func update_rec_size() -> void:
	var map = get_node("HBox/Map")
	map.custom_minimum_size = Vector2(Global.vec.size.node.sanctuary)
	parent.vec.offset = map.custom_minimum_size * 0.5
