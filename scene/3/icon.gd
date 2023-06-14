extends GridContainer


var parent = null


func set_parent(parent_) -> void:
	parent = parent_
	update_rec_size()
	fill_based_on_tool()


func update_rec_size() -> void:
	custom_minimum_size = Vector2(Global.vec.size.node.spielkarte)


func fill_based_on_tool() -> void:
	match parent.obj.tool.word.category:
		"schematic":
			parent.obj.tool.scene.myself.get_node("HBox/Label").visible = false
			
			for compartment in parent.obj.tool.obj.schematic.arr.compartment:
				add_child(compartment.scene.myself)
