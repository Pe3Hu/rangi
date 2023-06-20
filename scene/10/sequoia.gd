extends Polygon2D


var parent = null


func set_parent(parent_) -> void:
	parent = parent_
	position = parent.vec.position + parent.obj.sanctuary.vec.offset
	set_vertexs()


func set_vertexs() -> void:
	var order = "even"
	var corners = 4
	var r = Global.num.size.sequoia.r * 0.1
	var vertexs = []
	
	for corner in corners:
		var vertex = Global.dict.corner.vector[corners][order][corner] * r
		vertexs.append(vertex)
	
	set_polygon(vertexs)


func update_color_based_on_terrain() -> void:
	var max_h = 360.0
	var s = 0.75
	var v = 1
	var h = parent.num.ring / (Global.num.sanctuary.ring * max_h)
	
	var color_ = Color.from_hsv(h,s,v)
	set_color(color_)
