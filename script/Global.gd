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


func init_num() -> void:
	num.index = {}
	num.index.stadion = 0
	num.index.athleten = 0
	
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


func init_dict() -> void:
	dict.neighbor = {}
	dict.neighbor.linear3 = [
		Vector3( 0, 0, -1),
		Vector3( 1, 0,  0),
		Vector3( 0, 0,  1),
		Vector3(-1, 0,  0)
	]
	dict.neighbor.linear2 = [
		Vector2( 0,-1),
		Vector2( 1, 0),
		Vector2( 0, 1),
		Vector2(-1, 0)
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
	
	init_corner()


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


func init_arr() -> void:
	arr.sequence = {}
	arr.color = ["Red","Green","Blue","Yellow"]
	arr.wind_rose = ["N","NE","E","SE","S","SW","W","NW"]
	arr.polyhedron = [3,4,5,6]
	arr.spec = ["arm","brain","heart"]


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
	scene.director = load("res://scene/1/director.tscn")
	scene.factory = load("res://scene/2/factory.tscn")
	scene.stamp = load("res://scene/2/stamp.tscn")
	scene.bureau = load("res://scene/3/bureau.tscn")
	scene.design = load("res://scene/3/design.tscn")
	scene.tool = load("res://scene/3/tool.tscn")
	scene.storage = load("res://scene/4/storage.tscn")


func _ready() -> void:
	init_arr()
	init_num()
	init_dict()
	init_node()
	init_vec()
	init_scene()


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
