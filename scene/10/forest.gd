extends Polygon2D


var parent = null


func set_parent(parent_) -> void:
	parent = parent_
	set_vertexs()
	#update_color_based_on_forest_ring()


func set_vertexs() -> void:
	var vertexs = []
	
	for sequoia in parent.arr.sequoia:
		var vertex = sequoia.scene.myself.position
		vertexs.append(vertex)
	
	set_polygon(vertexs)


func update_color_based_on_forest_ring() -> void:
	var max_h = 360.0
	var h = float(parent.num.ring) / Global.num.size.sanctuary.ring
	var s = 0.25 
	var v = 1
	var color_ = Color.from_hsv(h, s, v)
	set_color(color_)

