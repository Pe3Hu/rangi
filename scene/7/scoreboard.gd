extends MarginContainer


var parent = null


func set_parent(parent_) -> void:
	parent = parent_


func update_labels() -> void:
	for label in get_node("Label").get_children():
		var indicator = label.name.to_lower()
		label.text = indicator[0].to_upper() + ":" + str(parent.num.indicator[indicator])
