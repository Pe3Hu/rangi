extends Polygon2D


var parent = null


func set_parent(parent_) -> void:
	parent = parent_
	position = parent.vec.grid * Global.num.size.sector.d + parent.obj.continent.vec.offset
	set_vertexs()


func set_vertexs() -> void:
	var order = "even"
	var corners = 4
	var r = Global.num.size.sector.r * 0.1
	var vertexs = []
	
	for corner in corners:
		var vertex = Global.dict.corner.vector[corners][order][corner] * r
		vertexs.append(vertex)
	
	set_polygon(vertexs)


func update_color_by_terrain() -> void:
	var max_h = 360.0
	var s = 0.75
	var v = 1
	var h = 0
	
	match parent.word.terrain:
		"jungle":
			h = 120/max_h
		"mountain":
			h = 60/max_h
		null:
			return
	
	var color_ = Color.from_hsv(h,s,v)
	set_color(color_)
