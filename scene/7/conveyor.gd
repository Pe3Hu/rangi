extends MarginContainer


var parent = null


func set_parent(parent_) -> void:
	parent = parent_


func add_tool(tool_: Classes_3.Tool) -> void:
	tool_.obj.design.scene.myself.get_node("Tool").remove_child(tool_.scene.myself)
	get_node("Schematic").add_child(tool_.scene.myself)


func remove_tool(tool_: Classes_3.Tool) -> void:
	get_node("Schematic").remove_child(tool_.scene.myself) 

