extends MarginContainer


var parent = null


func set_parent(parent_) -> void:
	parent = parent_
	update_size()
	update_color_based_on_type()


func update_size() -> void:
	custom_minimum_size = Vector2(Global.vec.size.node.spielkarte) * 1.0 / 3


func update_color_based_on_type() -> void:
	var max_h = 360.0
	var s = 0.75
	var v = 1.0
	var h = 0.0

	match parent.word.type.current:
		"core":
			h = 30/max_h
		"gateway":
			s = 0
			v = 0.6
		"wall":
			s = 0
			v = 0.2
		"adaptive compartment":
			s = 0
			v = 1
		"power generator":
			h = 60/max_h
		"protective field generator":
			h = 270/max_h
		"research station":
			h = 220/max_h
		"construction berth":
			h = 120/max_h
	
	if parent.flag.construction and parent.obj.edifice != null:
		v = 0.5
	
	parent.color.bg = Color.from_hsv(h, s, v)
	$BG.set_color(parent.color.bg)
