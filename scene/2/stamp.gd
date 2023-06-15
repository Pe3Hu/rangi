extends MarginContainer


var parent = null


func set_parent(parent_) -> void:
	parent = parent_
	update_rec_size()
	recolor()


func update_rec_size() -> void:
	custom_minimum_size = Vector2(Global.vec.size.node.spielkarte)


func recolor() -> void:
	var h = 200.0/360.0
	var s = 0.8
	var v = 0.95
	
	match parent.word.status:
		"default":
			s = 0.3
		"selected":
			s = 0.9
		"line":
			s = 0.6
	
	$BG.color = Color.from_hsv(h, s, v)


func set_design(design_: Classes_3.Design) -> void:
	$BG.visible = true
	parent.obj.design = design_
	design_.obj.owner = parent
	
	for tool in design_.arr.tool:
		design_.scene.myself.get_node("Tool").remove_child(tool.scene.myself)
		$Tool.add_child(tool.scene.myself)
		tool.scene.myself.switch_bg()


func pop_design(design_: Classes_3.Design) -> void:
	$BG.visible = false
	parent.obj.design = null
	design_.obj.owner = null
	
	for tool in design_.arr.tool:
		$Tool.remove_child(tool.scene.myself)
		design_.scene.myself.get_node("Tool").add_child(tool.scene.myself)
		tool.scene.myself.switch_bg()


