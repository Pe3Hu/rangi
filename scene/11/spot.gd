extends MarginContainer


var arr = {}
var num = {}
var obj = {}
var vec = {}
var dict = {}
var flag = {}
var word = {}


func update_rec_size() -> void:
	custom_minimum_size = Vector2(Global.vec.size.node.spot)


func update_color_based_on_content() -> void:
	var max_h = 360.0
	var s = 0.75
	var v = 1
	var h = 0
	
	if arr.subject.size() == 0:
		match word.content:
			null:
				s = 0.1
				v = 0.75
			"first aid kit":
				h = 0.0 /max_h
			"extractor":
				h = 60.0 /max_h
			"bush":
				h = 80.0 /max_h
			"wood":
				h = 120.0 /max_h
			"spring":
				h = 200.0 /max_h
			"natural gas source":
				h = 270.0 /max_h
			"mineral deposit":
				h = 320.0 /max_h
			"forge":
				s = 0.0
				v = 1.0
	else:
		s = 0.1
		v = 0.1

	var color_ = Color.from_hsv(h, s, v)
	$BG.set_color(color_)


func set_content(content_: String) -> void:
	word.content = content_
	
	if word.status == "blank":
		word.status = "booty"
		obj.location.arr.spot.blank.erase(self)
		obj.location.arr.spot.booty.append(self)
	
	match word.content:
		"extractor":
			reduce_adjacent_plant_accumulation()


func reduce_adjacent_plant_accumulation() -> void:
	var n = obj.location.num.narrowness
	var grid = {}
	grid.start = vec.grid - Vector2.ONE * n
	var m = n * 2 + 1
	
	for _i in m:
		for _j in m:
			grid.current = Vector2(_j, _i) + grid.start
			
			if Global.boundary_of_array_check(obj.location.arr.spot.all, grid.current):
				var neighbor = obj.location.arr.spot.all[grid.current.y][grid.current.x]
				
				if neighbor.obj.plant != null:
					var value = 1
					neighbor.obj.plant.reduce_accumulation(value)


func update_footprints() -> void:
	var time = Time.get_unix_time_from_system()
	
	for _i in range(dict.footprint.keys().size()-1,-1,-1):
		var footprint = dict.footprint.keys()[_i]
		
		if time - dict.footprint[footprint] > Global.num.time.footprint.spot:
			dict.footprint.erase(footprint)


func clean() -> void:
	obj.plant = null
	word.content = null
	update_color_based_on_content()
