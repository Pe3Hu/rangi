extends MarginContainer


var parent = null


func set_parent(parent_) -> void:
	parent = parent_
	update_rec_size()
	$Spot.columns = Global.num.size.location.spot


func update_rec_size() -> void:
	custom_minimum_size = Vector2(Global.vec.size.node.spot) * Global.num.size.location.spot
