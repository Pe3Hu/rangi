extends Polygon2D


var parent = null


func set_parent(parent_) -> void:
	parent = parent_
	set_vertexs()
	update_label()


func set_vertexs() -> void:
	var vertexs = []
	
	for pilier in parent.dict.pilier:
		var vertex = pilier.scene.myself.position
		parent.vec.center += vertex
		vertexs.append(vertex)
	
	parent.vec.center /= vertexs.size()
	parent.vec.center -= Global.vec.size.node.spielkarte * 0.33
	parent.vec.center.x -= 8 
	set_polygon(vertexs)


func paint_black() -> void:
	set_color(Color.GRAY)
	update_color_based_on_cluster_breath()


func update_color_based_on_cluster_ring() -> void:
	if parent.obj.cluster.num.ring != null:
		var max_h = 360.0
		var h = float(parent.obj.cluster.num.ring) / Global.num.size.cluster.ring
		var s = 0.25 
		var v = 1
		var color_ = Color.from_hsv(h, s, v)
		set_color(color_)
	else:
		paint_black()


func update_color_based_on_cluster_breath() -> void:
	var max_h = 360.0
	var h = 0
	var s = 0.0
	var v = float(parent.obj.cluster.num.breath) / Global.num.size.cluster.breath
	var color_ = Color.from_hsv(h, s, v)
	set_color(color_)


func update_color_based_on_cluster() -> void:
	var max_h = 360.0
	var size = Global.num.size.continent
	var index = size.cluster * parent.obj.cluster.vec.grid.y + parent.obj.cluster.vec.grid.x
	var h = float(index) / (size.cluster * size.cluster)#* Global.num.size.terres.n)
	var s = 0.25 
	var v = 1
	var color_ = Color.from_hsv(h, s, v)
	set_color(color_)


func recolor_based_on_compartment(compartment_: Classes_8.Compartment) -> void:
	var color_ = compartment_.color.bg
	
	if compartment_.word.type.current == "gateway":
		color_ = compartment_.obj.schematic.obj.tool.obj.design.obj.branch.obj.badge.color.bg
	
	set_color(color_)


func update_color_based_on_terrain() -> void:
	var max_h = 360.0
	var s = 0.25
	var v = 1
	var h = 0
	
	match parent.word.terrain:
		"jungle":
			h = 210/max_h#120/max_h
		"mountain":
			h = 0/max_h#60/max_h
		null:
			return
	
	print(parent,parent.word.terrain)
	var color_ = Color.from_hsv(h, s, v)
	set_color(color_)


func update_label() -> void:
	var index = Global.num.size.continent.col * parent.vec.grid.y + parent.vec.grid.x
	$Label.position = parent.vec.center
	$Label.text = str(index)
