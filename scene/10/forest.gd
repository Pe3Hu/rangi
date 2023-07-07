extends Polygon2D


var parent = null


func set_parent(parent_) -> void:
	parent = parent_
	set_vertexs()
	update_color_based_on_forest_shape()
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


func update_color_based_on_forest_shape() -> void:
	var max_h = 360.0
	var s = 0.25
	var v = 1
	var h = 0
	
	match parent.word.shape:
		"octagon":
			h = 90/max_h
		"triangle":
			h = 270/max_h
		"square":
			h = 180/max_h
		"trapeze":
			h = 0/max_h
	
	var color_ = Color.from_hsv(h, s, v)
	set_color(color_)


func update_color_based_on_habitat_index() -> void:
	var max_h = 360.0
	var h = float(parent.obj.habitat.num.index) / Global.num.index.habitat
	var s = 0.6 
	var v = 1
	var color_ = Color.from_hsv(h, s, v)
	set_color(color_)


func update_color_based_on_forest_index() -> void:
	if parent.num.index != null:
		var max_h = 360.0
		var h = float(parent.num.index) / Global.num.index.forest
		var s = 0.6 
		var v = 1
		var color_ = Color.from_hsv(h, s, v)
		set_color(color_)
		#visible = false
	else:
		set_color(Color.BLACK)


func update_color_based_on_biome() -> void:
	if parent.word.biome != null:
		var max_h = 360.0
		var h = null
		var s = 0.6 
		var v = 1
		
		match parent.word.biome:
			"north":
				h = 180.0 / max_h
			"east":
				h = 90.0 / max_h
			"south":
				h = 0.0 / max_h
			"west":
				h = 270.0 / max_h
		
		var color_ = Color.from_hsv(h, s, v)
		set_color(color_)
		#visible = false
	else:
		set_color(Color.BLACK)


func paint_black() -> void:
	color = Color.BLACK


func paint_white() -> void:
	color = Color.WHITE


