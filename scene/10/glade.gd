extends Line2D


var parent = null


func set_parent(parent_) -> void:
	parent = parent_
	set_vertexs()


func set_vertexs() -> void:
	for pilier in parent.arr.pilier:
		var point = pilier.scene.myself.position
		add_point(point)


func update_color_by_terrain() -> void:
	var max_h = 360.0
	var s = 0.75
	var v = 1
	var h = 0
	
	match parent.word.terrain:
		"jungle":
			h = 210/max_h#120/max_h
		"mountain":
			h = 0/max_h#60/max_h
		null:
			return
	
	print(parent.word.terrain)
	default_color = Color.from_hsv(h,s,v)
