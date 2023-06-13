extends MarginContainer


var parent = null


func set_parent(parent_) -> void:
	parent = parent_
	update_rec_size()


func update_rec_size() -> void:
	custom_minimum_size = Vector2(Global.vec.size.node.spielkarte)


func update_labels() -> void:
	for label in get_node("Label").get_children():
		var spec = label.name.to_lower()
		label.text = spec[0].to_upper() + ":" + str(parent.num.count[spec])
