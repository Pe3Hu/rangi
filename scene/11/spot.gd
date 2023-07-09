extends MarginContainer


var parent = null


func set_parent(parent_) -> void:
	parent = parent_
	update_rec_size()


func update_rec_size() -> void:
	custom_minimum_size = Vector2(Global.vec.size.node.spot)


func update_color_based_on_content() -> void:
	var max_h = 360.0
	var s = 0.75
	var v = 1
	var h = 0
	
	match parent.word.content:
		null:
			s = 0.1
			v = 0.75
		"wood":
			h = 120.0 /max_h
		"bush":
			h = 180.0 /max_h
		"first aid kit":
			h = 0.0 /max_h
		"extractor":
			h = 60.0 /max_h
		"forge":
			h = 270.0 /max_h
	
	var color_ = Color.from_hsv(h, s, v)
	$BG.set_color(color_)
