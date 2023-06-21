extends Line2D


var parent = null


func set_parent(parent_) -> void:
	parent = parent_
	set_vertexs()


func set_vertexs() -> void:
	for sequoia in parent.arr.sequoia:
		var point = sequoia.scene.myself.position
		add_point(point)


func paint_black() -> void:
	default_color = Color.BLACK

