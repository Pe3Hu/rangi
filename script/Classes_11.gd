extends Node


#Ареал habitat
class Habitat:
	var arr = {}
	var num = {}
	var obj = {}
	var dict = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		arr.forest = []
		num.ring = input_.ring
		num.index = Global.num.index.habitat
		Global.num.index.habitat += 1
		obj.sanctuary = input_.sanctuary
		obj.forge = null
		dict.neighbor = {}
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.habitat.instantiate()
		scene.myself.set_parent(self)
		obj.sanctuary.scene.myself.get_node("HBox/Habitat").add_child(scene.myself)


	func add_forest(forest_: Classes_10.Forest) -> void:
		if !arr.forest.has(forest_):
			arr.forest.append(forest_)
			forest_.obj.habitat = self


	func init_locations() -> void:
		arr.location = {}
		num.area = 0
		
		var datas = {}
		datas["suburb"] = [0]
		datas["center"] = []
		
		for forest in arr.forest:
			datas["suburb"][0] += forest.num.area.suburb
			
			for center in forest.num.area.center:
				datas["center"].append(center)
		
		for type in datas:
			for _i in datas[type].size():
				var input = {}
				input.type = type
				input.area = datas[type][_i]
				input.order = _i
				num.area += input.area
				input.habitat = self
				
				if !arr.location.has(type):
					arr.location[type] = []
				
				var location = Classes_11.Location.new(input)
				arr.location[type].append(location)
		
		
		for type in arr.location:
			for location in arr.location[type]:
				location.init_scene()


	func show() -> void:
		scene.myself.visible = true
		
		for forest in arr.forest:
			forest.scene.myself.paint_white()


	func hide() -> void:
		scene.myself.visible = false
		
		for forest in arr.forest:
			forest.scene.myself.update_color_based_on_biome()


	func set_biome(biome_: String) -> void:
		var climate = Global.dict.biome.climate[biome_].pick_random()
		
		for forest in arr.forest:
			forest.word.biome = biome_
			#forest.word.climate = climate
			
		for type in arr.location:
			for location in arr.location[type]:
				location.word.biome = biome_
				location.word.climate = climate
				location.set_circumstance()


	func host_forge() -> void:
		var spots = []
		
		for type in arr.location:
			for location in arr.location[type]:
				spots.append_array(location.arr.spot.booty)
		
		if spots.size() > 0:
			var spot = null
			
			while spot == null:
				spot = spots.pick_random()
				if spot.word.content != null:
					spot = null
			
			spot.set_content("forge")
			obj.forge = spot


#Локация location
class Location:
	var arr = {}
	var num = {}
	var obj = {}
	var vec = {}
	var dict = {}
	var word = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		arr.subject = []
		num.area = input_.area
		num.order = input_.order
		num.humidity = null
		obj.habitat = input_.habitat
		obj.greenhouse = obj.habitat.obj.sanctuary.obj.greenhouse
		dict.footprint = {}
		word.type = input_.type
		word.biome = null
		word.breed = null
		word.climate = null
		word.circumstance = {}


	func init_scene() -> void:
		num.angle = PI * 2 * num.order / obj.habitat.arr.location[word.type].size()
		var gap = Global.num.size.location.gap
		vec.offset = Vector2(0, -1).rotated(num.angle) * gap
		
		scene.myself = Global.scene.location.instantiate()
		scene.myself.set_parent(self)
		obj.habitat.scene.myself.get_node("Location").add_child(scene.myself)
		scene.spots = Global.scene.spots.instantiate()
		scene.spots.set_parent(self)
		obj.habitat.obj.sanctuary.scene.myself.get_node("HBox/Spots").add_child(scene.spots)


	func get_assessment_based_on_goal(goal_: String) -> int:
		var assessment = 1
		return assessment


	func set_breed(breed_: String) -> void:
		word.breed = breed_
		obj.greenhouse.arr.breed[breed_].append(self)
		scene.myself.update_color_based_on_breed()


	func set_circumstance() -> void:
		word.circumstance.title = Global.get_random_key(Global.dict.circumstance.climate[word.climate])
		word.circumstance.size = Global.get_random_key(Global.dict.circumstance.size)
		
		var limit = Global.num.size.location.humidity
		num.humidity = Global.rng.randi_range(limit.min, limit.max)


	func init_spots() -> void:
		arr.spot = {}
		arr.spot.all = []
		arr.spot.blank = []
		arr.spot.booty = []
		arr.spot.frontier = []
		var n = Global.num.size.location.spot
		
		if word.biome != null:
			num.narrowness = Global.dict.biome.narrowness[word.biome].pick_random()
			for _i in n:
				arr.spot.all.append([])
				
				for _j in n:
					var input = {}
					input.status = "blank"
					
					if _i % num.narrowness == 0 and _j % num.narrowness == 0:
						input.status = "booty"
					
					input.grid = Vector2(_j, _i)
					var distances = [_i, _j, n - 1 - _i, n - 1 - _j]
					input.remoteness = n
					
					for distance in distances:
						if input.remoteness > distance:
							input.remoteness = distance
					
					input.location = self
					var spot = Classes_11.Spot.new(input)
					arr.spot.all[_i].append(spot)
					arr.spot[input.status].append(spot)
					
					if _i == 0 or _j == 0 or _i == n - 1 or _j == n - 1:
						arr.spot.frontier.append(spot)
			
			init_spot_neighbors()
			init_woods()


	func init_spot_neighbors() -> void:
		var directions = []
		directions.append_array(Global.dict.neighbor.linear2)
		directions.append_array(Global.dict.neighbor.diagonal)
		
		for spots in arr.spot.all:
			for spot in spots:
				for direction in directions:
					var grid = spot.vec.grid + direction
					
					if Global.boundary_of_array_check(arr.spot.all, grid):
						var neighbor = arr.spot.all[grid.y][grid.x]
						spot.dict.neighbor[neighbor] = direction
						
						if Global.dict.neighbor.linear2.has(direction):
							spot.dict.linear2[neighbor] = direction


	func init_woods() -> void:
		if word.biome != null:
			var spots = []
			spots.append_array(arr.spot.booty)
			var area = 0
			var limit = Global.num.size.wood.area
			arr.wood = []
			var titles = []
			
			if word.breed != "exotic":
				for title in Global.dict.wood.breed[word.breed]:
					titles.append(title)
			else:
				for title in Global.dict.wood.biome[word.biome]:
					titles.append(title)
			
			while area < num.area and spots.size() > 0:
				var input = {}
				input.location = self
				input.greenhouse = obj.greenhouse
				input.title = titles.pick_random()
				input.spot = spots.pick_random()
				Global.rng.randomize()
				input.area = Global.rng.randi_range(limit.min, limit.max)
				input.content = "wood"
				var wood = Classes_16.Plant.new(input)
				arr.wood.append(wood)
				obj.greenhouse.arr.plant.wood.append(wood)
				area += input.area
				spots.erase(input.spot)
				
				for neighbor in input.spot.dict.neighbor:
					spots.erase(neighbor)


	func fill_spots() -> void:
		if num.narrowness != 1:
			for spot in arr.spot.booty:
				if spot.word.content == null:
					var content = Global.get_random_key(Global.dict.content.weight)
					spot.set_content(content)
		
			init_bushes("blank")
		else:
			init_bushes("booty")
		
		for spots in arr.spot.all:
			for spot in spots:
				spot.scene.myself.update_color_based_on_content()


	func init_bushes(layer_: String) -> void:
		if arr.spot[layer_].size() > 0:
			var spots = []
			spots.append_array(arr.spot[layer_])
			arr.bush = []
			
			if layer_ == "booty":
				num.humidity = 0
				
				for spot in arr.spot[layer_]:
					if spot.word.content != null:
						spots.erase(spot)
			
			while spots.size() > 0:
				if layer_ == "blank" and num.humidity <= 0:
					return
				
				var spot = spots.pick_random()
				var bush = sow_bush(spot)
				
				if layer_ == "blank":
					num.humidity -= bush.num.moisture
				else:
					num.humidity += bush.num.moisture
				
				spots.erase(spot)


	func sow_bush(spot_: Spot) -> Classes_16.Plant:
		var limit = Global.num.size.bush.moisture
		var input = {}
		input.location = self
		input.greenhouse = obj.greenhouse
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
		var max = min(limit.max, num.humidity)
		Global.rng.randomize()
		input.moisture = Global.rng.randi_range(limit.min, max)
		input.content = "bush"
		var bush = Classes_16.Plant.new(input)
		arr.bush.append(bush)
		obj.greenhouse.arr.plant.bush.append(bush)
		spot_.scene.myself.update_color_based_on_content()
		return bush


	func get_circumstance_influence() -> Variant:
		var result = null
		
		if word.circumstance.title != "typical":
			result = {}
			result.influence = Global.dict.circumstance.title[word.circumstance.title].influence
			result.accumulation = Global.dict.circumstance.title[word.circumstance.title][word.circumstance.size]
		
		return result


	func show_spots() -> void:
		scene.spots.visible = true


	func hide_spots() -> void:
		scene.spots.visible = false


	func update_footprints() -> void:
		var time = Time.get_unix_time_from_system()
		
		for _i in range(dict.footprint.keys().size()-1,-1,-1):
			var footprint = dict.footprint.keys()[_i]
			
			if time - dict.footprint[footprint] > Global.num.time.footprint.location:
				dict.footprint.erase(footprint)


#Место spot
class Spot:
	var arr = {}
	var num = {}
	var obj = {}
	var vec = {}
	var dict = {}
	var word = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		arr.subject = []
		num.area = floor(input_.location.num.area / pow(Global.num.size.location.spot, 2)) * Global.num.size.spot.compactness
		num.boundary = floor(sqrt(num.area))
		num.remoteness = input_.remoteness
		obj.location = input_.location
		obj.plant = null
		vec.grid = input_.grid
		dict.neighbor = {}
		dict.linear2 = {}
		dict.footprint = {}
		word.status = input_.status
		word.content = null
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.spot.instantiate()
		scene.myself.set_parent(self)
		obj.location.scene.spots.get_node("Spot").add_child(scene.myself)


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
		scene.myself.update_color_based_on_content()


#Событие occasion
class Occasion:
	var arr = {}
	var obj = {}
	var word = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		arr.beast = []
		obj.location = input_.location
		word.type = input_.type
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.occasion.instantiate()
		scene.myself.set_parent(self)


	func add_beast(beast_: Classes_12.Beast) -> void:
		arr.beast.append(beast_)
		beast_.obj.occasion = self


	func prepare() -> void:
		for beast in obj.location.arr.beast:
			match beast.obj.occasion.word.type:
				"clash":
					beast.obj.target = null
					beast.select_target()


	func start() -> void:
		match word.type:
			"clash":
				for beast in obj.location.arr.beast:
					beast.scene.myself.start_action_in_combat_mode()
			"harvest":
				for beast in obj.location.arr.beast:
					beast.scene.myself.start_action_in_harvest_mode()


