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


func add_subject(subject_: Variant) -> void:
	parent.arr.subject.append(subject_)
	get_node("Subject").add_child(subject_.scene.myself)
	#var func_name = "recalc_"
	#Callable(parent, func_name).call()
	recalc_offsets()
	#color = Color.GOLD
	
	#print(self, "A", parent.arr.subject.size())


func remove_subject(subject_: Variant) -> void:
	parent.arr.subject.erase(subject_)
	get_node("Subject").remove_child(subject_.scene.myself)
	recalc_offsets()
	subject_.vec.offset = Vector2()
	
	#print(self, "R", parent.arr.subject.size())


func recalc_offsets() -> void:
	var corners = parent.arr.subject.size()
	var r = Global.num.size.location.offset[parent.word.type]
	
	for _i in corners:
		var subject = parent.arr.subject[_i]
		var angle = -2 * PI * _i / corners
		subject.vec.offset = Vector2(0, -1).rotated(angle) * r
		var vector = Vector2()
		
		if parent.word.type == "center":
			vector += parent.vec.offset
		
		if corners > 1:
			vector += subject.vec.offset
		
		subject.scene.myself.position = vector


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
