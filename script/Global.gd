extends Node


var rng = RandomNumberGenerator.new()
var num = {}
var dict = {}
var arr = {}
var obj = {}
var node = {}
var flag = {}
var vec = {}
var scene = {}


func _ready() -> void:
	init_arr()
	init_num()
	init_dict()
	init_node()
	init_vec()
	init_scene()


func init_arr() -> void:
	arr.sequence = {}
	arr.color = ["Red","Green","Blue","Yellow"]
	arr.windrose = ["NE","E","SE","S","SW","W","NW","N"]
	arr.windrose_shifted = ["NW","N","NE","W","E","SW","S","SE"]
	arr.polyhedron = [3,4,5,6]
	arr.spec = ["arm","brain","heart"]
	

func init_num() -> void:
	num.index = {}
	num.index.schematic = 0
	num.index.sector = 0
	num.index.cluster = 0
	
	num.factory = {}
	num.factory.count = {}
	num.factory.count.n = 3
	num.factory.count.total = pow(num.factory.count.n, 2)
	
	num.bureau = {}
	num.bureau.count = {}
	num.bureau.count.active = 5
	num.bureau.count.total = 10
	
	
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
	
	num.size.continent = {}
	num.size.continent.cluster = 9
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
	
	dict.windrose = {}
	dict.windrose["NE"] = Vector2(1, -1)
	dict.windrose["E"] = Vector2(1, 0)
	dict.windrose["SE"] = Vector2(1, 1)
	dict.windrose["S"] = Vector2(0, 1)
	dict.windrose["SW"] = Vector2(-1, 1)
	dict.windrose["W"] = Vector2(-1, 0)
	dict.windrose["NW"] = Vector2(-1, -1)
	dict.windrose["N"] = Vector2(1, -1)
	
	dict.compartment = {}
	dict.compartment.total = ["core", "gateway", "wall", "adaptive compartment", "power generator", "protective field generator", "research station"]
	dict.compartment.active = ["power generator", "protective field generator", "research station"]
	
	init_corner()
	init_schematic()


func get_windrose(diretion_: Vector2) -> String:
	var windrose = ""
	
	for windrose_ in dict.windrose:
		if dict.windrose[windrose_] == diretion_:
			windrose = windrose_
			break
	
	return windrose


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


func init_schematic() -> void:
	dict.schematic = {}
	dict.schematic.title = {}
	dict.schematic.rarity = {}
	dict.schematic.association = {}
	
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
		data.rarity = 0
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
				var association = [_i]
				var _j = _i + 1
				
				while _j < data.indexs.size() and data.indexs[_j] == 1:
					association.append(_j)
					_j += 1
				
				_i = _j
				
				if _j == data.indexs.size():
					_j = 0
					
					if data.indexs[_j] == 1 and !association.has(_j):
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
			
			for _l in data.associations[_j]:
				var windrose = arr.windrose[_l]
				rarity += weight.windrose[windrose.length()]
				flag_only_diagonal = flag_only_diagonal and windrose.length() == 2
				
				if !flag_only_diagonal:
					break
			
			data.rarity += rarity
			flag = flag and !flag_only_diagonal
			
			if !flag:
				break
		
		if flag:
			data.rarity *= data.associations.size()
			
			if weight.max < data.rarity:
				weight.max = data.rarity
			
			datas.append(data)
		
		index.current += 1
	
	for data in datas:
		data.rarity = weight.max - data.rarity + 1
		var association = data.associations.size()
		
		if association > 0:
			dict.schematic.title[data.title] = data
			
			if !dict.schematic.association.has(association):
				dict.schematic.association[association] = {}
			
			if !dict.schematic.rarity.has(data.rarity):
				dict.schematic.rarity[data.rarity] = []
			
			dict.schematic.association[association][data.title] = data.title
			dict.schematic.rarity[data.rarity].append(data.title)


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
	scene.design = load("res://scene/3/design.tscn")
	scene.tool = load("res://scene/3/tool.tscn")
	scene.icon = load("res://scene/3/icon.tscn")
	scene.storage = load("res://scene/4/storage.tscn")
	scene.sector = load("res://scene/6/sector.tscn")
	scene.frontière = load("res://scene/6/frontière.tscn")
	scene.pilier = load("res://scene/6/pilier.tscn")
	scene.conveyor = load("res://scene/7/conveyor.tscn")
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


func check_array_has_grid(array_: Array, grid_: Vector2) -> bool:
	if grid_.y >= 0 and grid_.y < array_.size():
		if grid_.x >= 0 and grid_.x < array_[grid_.y].size():
			return true
	
	return false
