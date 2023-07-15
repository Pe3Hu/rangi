extends MarginContainer


var subjects = []
var index = null
var remoteness = null
var parent = null
var plant = null
var grid = null
var linear2 = {}
var neighbor = {}
var footprint = {}
var frontier = false
var status = null
var content = null


func _ready() -> void:
	index = get_index()
#	var path = "res://asset/json/spot/" + str(index) + ".json"
#	var data = Global.load_data(path)
#
#	for key in data:
#		set(key, data[key])


func set_data(data_: Dictionary) -> void:
	
	update_rec_size()


func update_rec_size() -> void:
	custom_minimum_size = Vector2(Global.size.node.spot)


func update_neighbors() -> void:
	var types = ["linear2", "neighbor"]
	
	for type in types:
		for index in self[type]:
			if typeof(index) == TYPE_INT:
				var neighbor = parent.get_children()[int(index)]
				self[type][neighbor] = self[type][index]
	
	for type in types:
		for _i in range(self[type].keys().size()-1,-1,-1):
			var key = self[type].keys()[_i]

			if typeof(key) == TYPE_INT:
				self[type].erase(key)


func update_color_based_on_content() -> void:
	var max_h = 360.0
	var s = 0.75
	var v = 1
	var h = 0
	
	if subjects.size() == 0:
		match content:
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
	content = content_
	
	if status == "blank":
		status = "booty"
		parent.arr.blank.erase(self)
		parent.arr.booty.append(self)
	
	match content:
		"extractor":
			reduce_adjacent_plant_accumulation()


func reduce_adjacent_plant_accumulation() -> void:
	var n = parent.parent.num.narrowness
	var vec = {}
	vec.start = grid - Vector2.ONE * n
	var m = n * 2 + 1
	
	for _i in m:
		for _j in m:
			vec.current = Vector2(_j, _i) + vec.start
			
			if Global.boundary_of_array_check(parent.arr.all, vec.current):
				var neighbor = parent.arr.all[vec.current.y][vec.current.x]
				
				if neighbor.plant != null:
					var value = 1
					neighbor.plant.reduce_accumulation(value)


func update_footprints() -> void:
	var time = Time.get_unix_time_from_system()
	
	for _i in range(footprint.keys().size()-1,-1,-1):
		var footprint = footprint.keys()[_i]
		
		if time - footprint[footprint] > Global.num.time.footprint.spot:
			footprint.erase(footprint)


func clean() -> void:
	plant = null
	content = null
	update_color_based_on_content()


func get_save_dict() -> Dictionary:
	var save_dict = {
		#"filename" : "res://scene/11/spot.tscn",#get_scene_file_path(),
		#"parent" : get_parent().get_path(),
		"index": index,
		"remoteness": remoteness,
		"grid": grid,
		"frontier": frontier,
		"linear2": linear2,
		"neighbor": neighbor,
		"status": status,
		}
	return save_dict


func save():
	var path = "res://asset/json/spot/" + str(index)
	var node_data = self.call("get_save_dict")
	var json_string = JSON.stringify(node_data)
	Global.save(path, json_string)
	#var save_spot = FileAccess.open(path, FileAccess.WRITE)
	#save_spot.store_line(json_string)

#
#func load_data():
#	var path = "res://asset/json/spot/" + str(index)
#    var save_game = FileAccess.open("user://savegame.save", FileAccess.READ)
#	var json = JSON.new()
#	var parse_result = json.parse(json_string)
#
#	if not parse_result == OK:
#		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
#		return
#
#	# Get the data from the JSON object
#	var node_data = json.get_data()
#
#	# Firstly, we need to create the object and add it to the tree and set its position.
#	var new_object = load(node_data["filename"]).instantiate()
#	get_node(node_data["parent"]).add_child(new_object)
#	new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])
#
#	# Now we set the remaining variables.
#	for key in node_data.keys():
#		if key == "filename" or key == "parent":
#			continue
#
#	new_object.set(key, node_data[key])
