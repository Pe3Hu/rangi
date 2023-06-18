extends MarginContainer


var parent = null


func set_parent(parent_) -> void:
	parent = parent_
	update_rec_size()


func update_rec_size() -> void:
	custom_minimum_size = Vector2(Global.vec.size.node.spielkarte)


func update_labels() -> void:
	for label in get_node("Label").get_children():
		var specialty = label.name.to_lower()
		
		if parent.dict.specialty.has(specialty):
			var symbol = null
			
			match specialty:
				"arm":
					symbol = "-"
				"brain":
					symbol = "#"
			
			var text = symbol
			
			for mastery in parent.dict.specialty[specialty]:
				var counter = parent.dict.specialty[specialty][mastery]
				
				if counter > 0:
					var letter = Global.dict.roman.number[mastery]
					text += letter + str(counter) + symbol
			
			label.text = text
