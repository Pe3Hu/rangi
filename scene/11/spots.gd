extends GridContainer


var parent = null
var arr = {}


func set_parent(parent_) -> void:
	parent = parent_
	update_rec_size()
	columns = Global.num.size.location.spot
	init_arr()


func update_rec_size() -> void:
	custom_minimum_size = Vector2(Global.vec.size.node.spot) * Global.num.size.location.spot


func init_arr() -> void:
	var n = parent.num.narrowness
	arr = {}
	arr.all = []
	arr.blank = []
	arr.booty = []
	arr.frontier = []
	var _i = 0
	
	for index in parent.scene.spots.get_children().size():
		var spot = parent.scene.spots.get_children()[index]
		
		var data = Global.arr.spot[index]
		data.scene = {}
		data.scene.spots = self
		spot.set_data(data)
		
		if spot.vec.grid.y == _i:
			_i += 1
			arr.all.append([])
		
		arr.all[spot.vec.grid.y].append(spot)
		
		if spot.flag.frontier:
			arr.frontier.append(spot)
	
		if int(spot.vec.grid.x) % parent.num.narrowness == 0 and int(spot.vec.grid.y) % parent.num.narrowness == 0:
			arr.booty.append(spot)
			spot.word.status = "booty"
		else:
			arr.blank.append(spot)
	
	for index in parent.scene.spots.get_children().size():
		var spot = parent.scene.spots.get_children()[index] 
		spot.update_neighbors()


func init_woods() -> void:
	if parent.word.biome != null:
		var spots = []
		spots.append_array(arr.booty)
		var area = 0
		var limit = Global.num.size.wood.area
		arr.wood = []
		var titles = []
		
		if parent.word.breed != "exotic":
			for title in Global.dict.wood.breed[parent.word.breed]:
				titles.append(title)
		else:
			for title in Global.dict.wood.biome[parent.word.biome]:
				titles.append(title)
		
		while area < parent.num.area and spots.size() > 0:
			var input = {}
			input.location = parent
			input.greenhouse = parent.obj.greenhouse
			input.title = titles.pick_random()
			input.spot = spots.pick_random()
			Global.rng.randomize()
			input.area = Global.rng.randi_range(limit.min, limit.max)
			input.content = "wood"
			var wood = Classes_16.Plant.new(input)
			arr.wood.append(wood)
			parent.obj.greenhouse.arr.plant.wood.append(wood)
			area += input.area
			spots.erase(input.spot)
			
			for neighbor in input.spot.dict.neighbor:
				spots.erase(neighbor)


func fill_spots() -> void:
	if parent.num.narrowness != 1:
		for spot in arr.booty:
			if spot.word.content == null:
				var content = Global.get_random_key(Global.dict.content.weight)
				spot.set_content(content)
	
		init_bushes("blank")
	else:
		init_bushes("booty")
	
	for spots in arr.all:
		for spot in spots:
			spot.update_color_based_on_content()


func init_bushes(layer_: String) -> void:
	if arr[layer_].size() > 0:
		var spots = []
		spots.append_array(arr[layer_])
		arr.bush = []
		
		if layer_ == "booty":
			parent.num.humidity = 0
			
			for spot in arr[layer_]:
				if spot.word.content != null:
					spots.erase(spot)
		
		while spots.size() > 0:
			if layer_ == "blank" and parent.num.humidity <= 0:
				return
			
			var spot = spots.pick_random()
			var bush = sow_bush(spot)
			
			if layer_ == "blank":
				parent.num.humidity -= bush.num.moisture
			else:
				parent.num.humidity += bush.num.moisture
			
			spots.erase(spot)


func sow_bush(spot_: MarginContainer) -> Classes_16.Plant:
	var limit = Global.num.size.bush.moisture
	var input = {}
	input.location = parent
	input.greenhouse = parent.obj.greenhouse
	input.spot = spot_
	
	var preference = "isolationist"
	
	for neighbor in input.spot.dict.neighbor:
		if neighbor.word.content == "wood":
			preference = "symbiote"
			break

	var titles = []
	titles.append_array(Global.dict.bush.preference["standard"])
	titles.append_array(Global.dict.bush.preference[preference])
	input.title = titles.pick_random()
	var max = min(limit.max, parent.num.humidity)
	Global.rng.randomize()
	input.moisture = Global.rng.randi_range(limit.min, max)
	input.content = "bush"
	var bush = Classes_16.Plant.new(input)
	arr.bush.append(bush)
	parent.obj.greenhouse.arr.plant.bush.append(bush)
	spot_.update_color_based_on_content()
	return bush

