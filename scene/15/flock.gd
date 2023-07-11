extends Polygon2D


var parent = null
var tween = null


func set_parent(parent_) -> void:
	parent = parent_
	set_vertexs()


func set_vertexs() -> void:
	var corners = 4
	var r = Global.num.size.flock.r
	var vertexs = []
	
	for _i in corners:
		var angle = -2 * PI * _i / corners
		var vertex = Vector2(0, -1).rotated(angle) * r 
		vertexs.append(vertex)
	
	set_polygon(vertexs)

