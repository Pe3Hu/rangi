extends GridContainer


var parent = null


func set_parent(parent_) -> void:
	parent = parent_
	update_rec_size()
	fill_based_on_tool()


func update_rec_size() -> void:
	custom_minimum_size = Vector2(Global.vec.size.node.spielkarte)


func clean() -> void:
	while get_child_count() > 0:
		var child = get_children().front()
		remove_child(child)


func fill_based_on_tool() -> void:
	match parent.obj.tool.word.category:
		"schematic":
			parent.obj.tool.scene.myself.get_node("HBox/Label").visible = false
			
			for compartment in parent.obj.tool.obj.schematic.dict.compartment:
				add_child(compartment.scene.myself)
