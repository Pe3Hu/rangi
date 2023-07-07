extends Polygon2D


var parent = null


func set_parent(parent_) -> void:
	parent = parent_
	set_vertexs()


func set_vertexs() -> void:
	var corners = 32
	var r = Global.num.size.location.r[parent.word.type]
	var vertexs = []
	
	for _i in corners:
		var angle = -2 * PI * _i / corners
		var vertex = Vector2(0, -1).rotated(angle) * r 
		
		if parent.word.type == "center":
			vertex += parent.vec.offset
		
		vertexs.append(vertex)
	
	set_polygon(vertexs)


func add_beast(beast_: Classes_12.Beast) -> void:
	parent.arr.beast.append(beast_)
	get_node("Beast").add_child(beast_.scene.myself)
	recalc_beasts_offset()
	#color = Color.GOLD
	
	#print(self, "A", parent.arr.beast.size())


func remove_beast(beast_: Classes_12.Beast) -> void:
	parent.arr.beast.erase(beast_)
	get_node("Beast").remove_child(beast_.scene.myself)
	recalc_beasts_offset()
	beast_.vec.offset = Vector2()
	
	#print(self, "R", parent.arr.beast.size())


func recalc_beasts_offset() -> void:
	var corners = parent.arr.beast.size()
	var r = Global.num.size.location.offset[parent.word.type]
	
	for _i in corners:
		var beast = parent.arr.beast[_i]
		var angle = -2 * PI * _i / corners
		beast.vec.offset = Vector2(0, -1).rotated(angle) * r
		var vector = Vector2()
		
		if parent.word.type == "center":
			vector += parent.vec.offset
		
		if corners > 1:
			vector += beast.vec.offset
		
		beast.scene.myself.position = vector


func update_color_based_on_breed() -> void:
	if parent.word.breed != null:
		var max_h = 360.0
		var h = null
		var s = 0.6 
		var v = 1
		
		match parent.word.breed:
			"conifer":
				h = 120.0 / max_h
			"leafy":
				h = 30.0 / max_h
			"exotic":
				h = 270.0 / max_h
		
		var color_ = Color.from_hsv(h, s, v)
		set_color(color_)
		#visible = false
	else:
		set_color(Color.BLACK)
