extends MarginContainer


var parent = null


func set_parent(parent_) -> void:
	parent = parent_


func update_labels() -> void:
	for label in get_node("Label").get_children():
		var indicator = label.name.to_lower()
		var value = parent.num.indicator[indicator]
		
		match indicator:
			"energy":
				value -= parent.num.consumption
		
		label.text = indicator[0].to_upper() + ":" + str(value)
