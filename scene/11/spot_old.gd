extends MarginContainer


var arr = {}
var num = {}
var obj = {}
var vec = {}
var dict = {}
var flag = {}
var word = {}
var scene = {}


func set_data(data_: Dictionary) -> void:
	for key in data_:
		if key == "dict":
			for subkey in data_[key]:
				self[key][subkey] = {}
				
				for neighbor in data_[key][subkey]:
					var value = data_[key][subkey][neighbor]
					var vector = Vector2(int(value[1]), int(value[4]))
					self[key][subkey][int(neighbor)] = vector
		else:
			for subkey in data_[key]:
				var value = data_[key][subkey]
				
				if subkey == "grid":
					value = Vector2(int(value[1]), int(value[4]))
				
				self[key][subkey] = value
	
	word.content = null
	obj.plant = null
	arr.subject = []
	update_rec_size()


func update_rec_size() -> void:
	custom_minimum_size = Vector2(Global.vec.size.node.spot)


func update_neighbors() -> void:
	for type in dict:
		for index in dict[type]:
			if typeof(index) == TYPE_INT:
				var neighbor = scene.spots.get_children()[int(index)]
				dict[type][neighbor] = dict[type][index]
	
	for type in dict:
		for _i in range(dict[type].keys().size()-1,-1,-1):
			var key = dict[type].keys()[_i]

			if typeof(key) == TYPE_INT:
				dict[type].erase(key)
	


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
		scene.spots.arr.blank.erase(self)
		scene.spots.arr.booty.append(self)
	
	match word.content:
		"extractor":
			reduce_adjacent_plant_accumulation()


func reduce_adjacent_plant_accumulation() -> void:
	var n = scene.spots.parent.num.narrowness
	var grid = {}
	grid.start = vec.grid - Vector2.ONE * n
	var m = n * 2 + 1
	
	for _i in m:
		for _j in m:
			grid.current = Vector2(_j, _i) + grid.start
			
			if Global.boundary_of_array_check(scene.spots.arr.all, grid.current):
				var neighbor = scene.spots.arr.all[grid.current.y][grid.current.x]
				
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
