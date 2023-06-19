extends MarginContainer


var parent = null


func set_parent(parent_) -> void:
	parent = parent_
	update_size()


func update_size() -> void:
	custom_minimum_size = Vector2(Global.vec.size.node.spielkarte)

