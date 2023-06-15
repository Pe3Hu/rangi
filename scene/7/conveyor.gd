extends MarginContainer


var parent = null


func set_parent(parent_) -> void:
	parent = parent_
	update_size()


func update_size() -> void:
	custom_minimum_size = Vector2(Global.vec.size.node.spielkarte)


func add_tool(tool_: Classes_3.Tool) -> void:
	tool_.obj.design.scene.myself.get_node("Tool").remove_child(tool_.scene.myself)
	get_node("Schematic").add_child(tool_.scene.myself)
