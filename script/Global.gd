extends Node


var rng = RandomNumberGenerator.new()
var arr = {}
var num = {}
var obj = {}
var vec = {}
var dict = {}
var flag = {}
var node = {}
var scene = {}


func _ready() -> void:
	init_arr()
	init_num()
	init_vec()
	init_dict()
	init_node()
	init_scene()


func init_arr() -> void:
	arr.sequence = {}
	arr.color = ["Red","Green","Blue","Yellow"]
	arr.windrose = ["NE","E","SE","S","SW","W","NW","N"]
	arr.windrose_shifted = ["NW","N","NE","W","E","SW","S","SE"]
	arr.polyhedron = [3,4,5,6]
	arr.drone = ["arm","brain"]
	arr.sequence["A000045"] = [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55]


func init_num() -> void:
	num.index = {}
	num.index.branch = 0
	num.index.schematic = 0
	
	num.factory = {}
	num.factory.count = {}
	num.factory.count.n = 3
	num.factory.count.total = pow(num.factory.count.n, 2)
	
	num.bureau = {}
	num.bureau.bid = {}
	num.bureau.bid.showcase = 5
	num.bureau.bid.stock = 10
	
	num.conveyor = {}
	num.conveyor.turn = 4
	num.conveyor.surcharge = 1.5
	
	num.separation = {}
	num.separation.croupier = 5
	num.separation.spielkarte = 5
	
	num.spielkarte = {}
	
	num.size = {}
	num.size.spielkarte = {}
	num.size.spielkarte.a = 12
	num.size.spielkarte.d = num.size.spielkarte.a * 2
	num.size.spielkarte.r = num.size.spielkarte.a * sqrt(2)
	num.size.spielkarte.font = 28
	
	num.size.sector = {}
	num.size.sector.a = 8
	num.size.sector.d = num.size.sector.a * 2
	num.size.sector.r = num.size.sector.a * sqrt(2)
	
	num.size.cluster = {}
	num.size.cluster.n = 3
	num.size.cluster.ring = 5
	num.size.cluster.breath = 4
	
	num.size.continent = {}
	num.size.continent.cluster = num.size.cluster.ring * 2 - 1
	num.size.continent.col = num.size.continent.cluster * num.size.cluster.n
	num.size.continent.row = num.size.continent.col


func init_dict() -> void:
	dict.neighbor = {}
	dict.neighbor.linear3 = [
		Vector3( 0, 0, -1),
		Vector3( 1, 0,  0),
		Vector3( 0, 0,  1),
		Vector3(-1, 0,  0)
	]
	dict.neighbor.linear2 = [
		Vector2( 1, 0),
		Vector2( 0, 1),
		Vector2(-1, 0),
		Vector2( 0,-1)
	]
	dict.neighbor.diagonal = [
		Vector2( 1,-1),
		Vector2( 1, 1),
		Vector2(-1, 1),
		Vector2(-1,-1)
	]
	dict.neighbor.zero = [
		Vector2( 0, 0),
		Vector2( 1, 0),
		Vector2( 1, 1),
		Vector2( 0, 1)
	]
	dict.neighbor.hex = [
		[
			Vector2( 1,-1), 
			Vector2( 1, 0), 
			Vector2( 0, 1), 
			Vector2(-1, 0), 
			Vector2(-1,-1),
			Vector2( 0,-1)
		],
		[
			Vector2( 1, 0),
			Vector2( 1, 1),
			Vector2( 0, 1),
			Vector2(-1, 1),
			Vector2(-1, 0),
			Vector2( 0,-1)
		]
	]
	
	dict.indicator = {}
	dict.indicator["energy"] = ["power generator"]
	dict.indicator["knowledge"] = ["research station"]
	dict.indicator["shield"] = ["protective field generator"]
	dict.indicator["component"] = ["construction berth"]
	
	dict.roman = {}
	dict.roman.number = {}
	dict.roman.number[1] = "I"
	dict.roman.number[2] = "II"
	dict.roman.number[3] = "III"
	dict.roman.number[4] = "IV"
	dict.roman.number[5] = "V"
	
	dict.priority = {}
	dict.priority.min = 1
	dict.priority.avg = 5
	dict.priority.title = ["finish construction", "pursuit of incentive", "take on hardest"]
	dict.priority.total = dict.priority.avg * dict.priority.title.size()
	
	init_corner()
	init_windrose()
	init_compartment()
	init_drone()
	init_schematic()


func init_windrose() -> void:
	dict.windrose = {}
	dict.windrose.direction = {}
	dict.windrose.direction["NE"] = Vector2(1, -1)
	dict.windrose.direction["E"] = Vector2(1, 0)
	dict.windrose.direction["SE"] = Vector2(1, 1)
	dict.windrose.direction["S"] = Vector2(0, 1)
	dict.windrose.direction["SW"] = Vector2(-1, 1)
	dict.windrose.direction["W"] = Vector2(-1, 0)
	dict.windrose.direction["NW"] = Vector2(-1, -1)
	dict.windrose.direction["N"] = Vector2(0, -1)
	
	dict.windrose.reverse = {}
	dict.windrose.reverse["NE"] = "SW"
	dict.windrose.reverse["E"] = "W"
	dict.windrose.reverse["SE"] = "NW"
	dict.windrose.reverse["S"] = "N"
	dict.windrose.reverse["SW"] = "NE"
	dict.windrose.reverse["W"] = "E"
	dict.windrose.reverse["NW"] = "SE"
	dict.windrose.reverse["N"] = "S"
	
	dict.windrose.previous = {}
	dict.windrose.previous["NE"] = "NW"
	dict.windrose.previous["E"] = "N"
	dict.windrose.previous["SE"] = "NE"
	dict.windrose.previous["S"] = "E"
	dict.windrose.previous["SW"] = "SE"
	dict.windrose.previous["W"] = "S"
	dict.windrose.previous["NW"] = "SW"
	dict.windrose.previous["N"] = "W"
	
	dict.windrose.next = {}
	dict.windrose.next["NE"] = "SE"
	dict.windrose.next["E"] = "S"
	dict.windrose.next["SE"] = "SW"
	dict.windrose.next["S"] = "W"
	dict.windrose.next["SW"] = "NW"
	dict.windrose.next["W"] = "N"
	dict.windrose.next["NW"] = "NE"
	dict.windrose.next["N"] = "E"
	
	dict.side = {}
	dict.side.windrose = {}
	dict.side.windrose["right"] = ["NE", "E", "SE"]
	dict.side.windrose["bot"] = ["SE", "S", "SW"]
	dict.side.windrose["left"] = ["SW", "W", "NW"]
	dict.side.windrose["top"] = ["NW", "N", "NE"]
	
	dict.side.direction = {}
	dict.side.direction["right"] = Vector2(1, 0)
	dict.side.direction["bot"] = Vector2(0, 1)
	dict.side.direction["left"] = Vector2(-1, 0)
	dict.side.direction["top"] = Vector2(0, -1)


func get_windrose(diretion_: Vector2) -> Variant:
	for windrose_ in dict.windrose.direction:
		if dict.windrose.direction[windrose_] == diretion_:
			return windrose_
	
	return null


func init_corner() -> void:
	dict.order = {}
	dict.order.pair = {}
	dict.order.pair["even"] = "odd"
	dict.order.pair["odd"] = "even"
	var corners = [3,4,6]
	dict.corner = {}
	dict.corner.vector = {}
	
	for corners_ in corners:
		dict.corner.vector[corners_] = {}
		dict.corner.vector[corners_].even = {}
		
		for order_ in dict.order.pair.keys():
			dict.corner.vector[corners_][order_] = {}
		
			for _i in corners_:
				var angle = 2*PI*_i/corners_-PI/2
				
				if order_ == "odd":
					angle += PI/corners_
				
				var vertex = Vector2(1,0).rotated(angle)
				dict.corner.vector[corners_][order_][_i] = vertex


func init_compartment() -> void:
	num.compartment = {}
	num.compartment.consumption = {}
	num.compartment.consumption["power generator"] = 0
	num.compartment.consumption["adaptive compartment"] = 0
	num.compartment.consumption["protective field generator"] = 1
	num.compartment.consumption["research station"] = 1
	num.compartment.consumption["construction berth"] = 1
	
	num.compartment.price = {}
	num.compartment.price["core"] = 100
	num.compartment.price["gateway"] = 7
	num.compartment.price["wall"] = 3
	num.compartment.price["adaptive compartment"] = 30
	num.compartment.price["power generator"] = 10
	num.compartment.price["protective field generator"] = 14
	num.compartment.price["research station"] = 12
	num.compartment.price["construction berth"] = 16
	
	dict.compartment = {}
	dict.compartment.total = ["core", "gateway", "wall", "adaptive compartment", "power generator", "protective field generator", "research station"]
	dict.compartment.passive = ["wall"]
	dict.compartment.active = []
	
	for compartment in num.compartment.consumption:
		#if compartment != "adaptive compartment":
		dict.compartment.active.append(compartment)


func init_drone() -> void:
	num.drone = {}
	num.drone.arm = {}
	num.drone.arm.max = 5
	num.drone.arm.downgrade = {}
	num.drone.arm.mastery = {}
	num.drone.arm.mastery[1] = 1
	num.drone.arm.mastery[2] = 3
	num.drone.arm.mastery[3] = 5
	num.drone.arm.mastery[4] = 7
	num.drone.arm.mastery[5] = 8
	
	for mastery in num.drone.arm.mastery:
		var index = 2
		num.drone.arm.downgrade[mastery] = {}
		
		for _i in range(mastery, 0, -1):
			num.drone.arm.downgrade[mastery][_i] = arr.sequence["A000045"][index]
			index += 1
	
	num.drone.brain = {}
	num.drone.brain.max = 5
	num.drone.brain.mastery = {}
	
	for mastery in num.drone.arm.mastery:
		num.drone.brain.mastery[mastery] = mastery


func get_mastery_based_on_association_size(size_: int) -> Variant:
	var keys = []
	keys.append_array(num.drone.arm.mastery.keys())
	keys.sort()
	
	for key in keys:
		if num.drone.arm.mastery[key] >= size_:
			return key
	
	return null


func init_schematic() -> void:
	dict.schematic = {}
	dict.schematic.title = {}
	dict.schematic.rarity = {}
	dict.schematic.association = {}
	dict.schematic.indexs = {}
	dict.schematic.mastery = {}
	dict.schematic.rotate = {}
	dict.schematic.deadlock = []
	
	var size = pow(num.size.cluster.n, 2) - 1
	var index = {}
	index.max = pow(2, size)
	index.current = 0
	var datas = []
	var weight = {}
	weight.windrose = {}
	weight.windrose[1] = 1
	weight.windrose[2] = 2
	weight.max = 0
	
	while index.current < index.max:
		var data = {}
		data.title = str(index.current)
		#data.rarity = 0
		data.indexs = []
		var value = int(index.current)
		
		while value > 0:
			var temp = value % 2
			data.indexs.append(temp)
			value /= 2
		
		while data.indexs.size() < size:
			data.indexs.append(0)
		
		#data.indexs.reverse()
		data.associations = []
		var _i = 0
		
		while _i < data.indexs.size():
			if data.indexs[_i] == 1:
				var association = [arr.windrose[_i]]
				var _j = _i + 1
				
				while _j < data.indexs.size() and data.indexs[_j] == 1:
					association.append(arr.windrose[_j])
					_j += 1
				
				_i = _j
				
				if _j == data.indexs.size():
					_j = 0
					
					if data.indexs[_j] == 1 and !association.has(arr.windrose[_j]):
						data.associations.front().append_array(association)
					else:
						data.associations.append(association)
				else:
					data.associations.append(association)
			
			_i += 1
		
		var flag = true
		
		for _j in data.associations.size():
			var flag_only_diagonal = true
			var rarity = -1
			
			for windrose in data.associations[_j]:
				rarity += weight.windrose[windrose.length()]
				flag_only_diagonal = flag_only_diagonal and windrose.length() == 2
				
				if !flag_only_diagonal:
					break
			
			#data.rarity += rarity
			flag = flag and !flag_only_diagonal
			
			if !flag:
				break
		
		if flag:
			#data.rarity *= data.associations.size()
			#if weight.max < data.rarity:
			#	weight.max = data.rarity
			
			if data.associations.size() == 1:
				dict.schematic.deadlock.append(data.title)
			
			datas.append(data)
		
		index.current += 1
	
	for data in datas:
		#data.rarity = weight.max - data.rarity + 1
		var associations_size = data.associations.size()
		
		if associations_size > 0:
			data.mastery = 0
			
			for association in data.associations:
				var mastery = get_mastery_based_on_association_size(association.size())
				
				if data.mastery < mastery:
					data.mastery = mastery
			
			
			if !dict.schematic.deadlock.has(data.title):
				for mastery in range(data.mastery, num.drone.arm.max, 1):
					if !dict.schematic.mastery.has(mastery):
						dict.schematic.mastery[mastery] = []
					
					dict.schematic.mastery[mastery].append(data.title)
			
			dict.schematic.title[data.title] = data
			dict.schematic.indexs[data.indexs] = data.title
			
			if !dict.schematic.association.has(associations_size):
				dict.schematic.association[associations_size] = {}
			
			#if !dict.schematic.rarity.has(data.rarity):
			#	dict.schematic.rarity[data.rarity] = []
			
			dict.schematic.association[associations_size][data.title] = data.title
			#dict.schematic.rarity[data.rarity].append(data.title)
			#print(data)
	
	for title in dict.schematic.title:
		dict.schematic.rotate[title] = []
		var description = dict.schematic.title[title]
		var indexs = {}
		indexs.current = []
		indexs.next = []
		indexs.current.append_array(description.indexs)
		
		for turn in num.conveyor.turn:
			indexs.next = []
			
			for _i in indexs.current.size():
				indexs.next.append(0)
			
			for _i in indexs.current.size():
				if indexs.current[_i] == 1:
					var windrose = arr.windrose[_i]
					var next_windrose = dict.windrose.previous[windrose]
					var next_index = arr.windrose.find(next_windrose)
					indexs.next[next_index] = 1
			
			var title_rotated = dict.schematic.indexs[indexs.next]
			dict.schematic.rotate[title].append(title_rotated)
			
			indexs.current = []
			indexs.current.append_array(indexs.next)


func get_schematic_title_based_on_anonymized_markers(markers_: Dictionary) -> Array:
	var titles = []
	
	for title in dict.schematic.title:
		if compare_title_with_markers(title, markers_):
			titles.append(title)
	
	return titles


func compare_title_with_markers(title_: String, markers_: Dictionary) -> bool:
	var flag = true
	var description = dict.schematic.title[title_]
	
	for _i in description.indexs.size():
		var windrose = arr.windrose[_i]
		
		if markers_[windrose] != "any":
			var description_marker = null
			var index = description.indexs[_i]
			
			match index:
				0:
					description_marker = "passive"
				1:
					description_marker = "active"
			
			flag = flag and description_marker == markers_[windrose]
	
	return flag


func init_node() -> void:
	node.game = get_node("/root/Game")


func init_vec():
	vec.size = {}
	init_window_size()


func init_window_size():
	vec.size.window = {}
	vec.size.window.width = ProjectSettings.get_setting("display/window/size/viewport_width")
	vec.size.window.height = ProjectSettings.get_setting("display/window/size/viewport_height")
	vec.size.window.center = Vector2(vec.size.window.width/2, vec.size.window.height/2)
	
	vec.size.node = {}
	vec.size.node.spielkarte = Vector2.ONE * num.size.spielkarte.r * 2


func init_scene() -> void:
	scene.cosmos = load("res://scene/0/cosmos.tscn")
	scene.planet = load("res://scene/0/planet.tscn")
	scene.continent = load("res://scene/0/continent.tscn")
	scene.director = load("res://scene/1/director.tscn")
	scene.factory = load("res://scene/2/factory.tscn")
	scene.stamp = load("res://scene/2/stamp.tscn")
	scene.bureau = load("res://scene/3/bureau.tscn")
	scene.bid = load("res://scene/3/bid.tscn")
	scene.design = load("res://scene/3/design.tscn")
	scene.tool = load("res://scene/3/tool.tscn")
	scene.icon = load("res://scene/3/icon.tscn")
	scene.storage = load("res://scene/4/storage.tscn")
	scene.badge = load("res://scene/4/badge.tscn")
	scene.sector = load("res://scene/6/sector.tscn")
	scene.frontière = load("res://scene/6/frontière.tscn")
	scene.pilier = load("res://scene/6/pilier.tscn")
	scene.outpost = load("res://scene/7/outpost.tscn")
	scene.conveyor = load("res://scene/7/conveyor.tscn")
	scene.scoreboard = load("res://scene/7/scoreboard.tscn")
	scene.compartment = load("res://scene/7/compartment.tscn")
	


func get_random_element(arr_: Array):
	if arr_.size() == 0:
		print("!bug! empty array in get_random_element func")
		return null
	
	rng.randomize()
	var index_r = rng.randi_range(0, arr_.size()-1)
	return arr_[index_r]


func get_random_key(dict_: Dictionary):
	if dict_.keys().size() == 0:
		print("!bug! empty array in get_random_key func")
		return null
	
	var total = 0
	
	for key in dict_.keys():
		total += dict_[key]
	
	rng.randomize()
	var index_r = rng.randf_range(0, 1)
	var index = 0
	
	for key in dict_.keys():
		var weight = float(dict_[key])
		index += weight/total
		
		if index > index_r:
			return key
	
	print("!bug! index_r error in get_random_key func")
	return null


func save(path_: String, data_: String):
	var path = path_+".json"
	var file = FileAccess.open(path,FileAccess.WRITE)
	file.save(data_)
	file.close()


func load_data(path_: String):
	var file = FileAccess.open(path_,FileAccess.READ)
	var text = file.get_as_text()
	var json_object = JSON.new()
	var parse_err = json_object.parse(text)
	return json_object.get_data()


func boundary_of_array_check(array_: Array, grid_: Vector2) -> bool:
	if grid_.y >= 0 and grid_.y < array_.size():
		if grid_.x >= 0 and grid_.x < array_[grid_.y].size():
			return true
	
	return false
