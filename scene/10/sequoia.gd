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


func paint_black() -> void:
	color = Color.BLACK


func paint_gold() -> void:
	color = Color.GOLD
