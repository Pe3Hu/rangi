extends Node


#Ареал habitat
class Habitat:
	var arr = {}
	var num = {}
	var obj = {}
	var dict = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		num.ring = input_.ring
		num.index = Global.num.index.habitat
		Global.num.index.habitat += 1
		arr.forest = []
		obj.sanctuary = input_.sanctuary
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


	func select_to_show() -> void:
		scene.myself.visible = true
		
		for forest in arr.forest:
			forest.scene.myself.paint_white()


	func hide() -> void:
		scene.myself.visible = false
		
		for forest in arr.forest:
			forest.scene.myself.update_color_based_on_habitat_index()


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
			var spot = spots.pick_random()
			spot.set_content("forge")


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
		arr.beast = []
		num.area = input_.area
		num.order = input_.order
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


	func get_assessment_based_on_goal(goal_: String) -> int:
		var assessment = 1
		return assessment


	func set_breed(breed_: String) -> void:
		word.breed = breed_
		obj.greenhouse.arr.breed[breed_].append(self)
		scene.myself.update_color_based_on_breed()


	func init_spots() -> void:
		arr.spot = {}
		arr.spot.all = []
		arr.spot.blank = []
		arr.spot.booty = []
		
		if word.biome != null:
			num.narrowness = Global.dict.biome.narrowness[word.biome].pick_random()
			for _i in Global.num.size.location.spot:
				arr.spot.all.append([])
				
				for _j in Global.num.size.location.spot:
					var input = {}
					input.status = "blank"
					
					if _i % num.narrowness == 0 and _j % num.narrowness == 0:
						input.status = "booty"
					
					input.grid = Vector2(_j, _i)
					input.location = self
					var spot = Classes_11.Spot.new(input)
					arr.spot.all[_i].append(spot)
					arr.spot[input.status].append(spot)
		
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
						spot.dict.neighbor[direction] = neighbor
		
		print(arr.spot.all[1][1].dict.neighbor.size())


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
				var wood = Classes_15.Wood.new(input)
				arr.wood.append(wood)
				obj.greenhouse.arr.wood.append(wood)
				area += input.area
				spots.erase(input.spot)


	func fill_spots() -> void:
		#var spots = []
		for spot in arr.spot.booty:
			if spot.word.content == null:
				#spots.append(spot)
				var content = Global.get_random_key(Global.dict.content.weight)
				spot.set_content(content)


	func set_circumstance() -> void:
		word.circumstance.title = Global.get_random_key(Global.dict.circumstance.climate[word.climate])
		word.circumstance.size = Global.get_random_key(Global.dict.circumstance.size)


	func get_circumstance_influence() -> Variant:
		var result = null
		
		if word.circumstance.title != "typical":
			result = {}
			result.influence = Global.dict.circumstance.title[word.circumstance.title].influence
			result.accumulation = Global.dict.circumstance.title[word.circumstance.title][word.circumstance.size]
		
		return result


#Место spot
class Spot:
	var obj = {}
	var vec = {}
	var dict = {}
	var word = {}


	func _init(input_: Dictionary) -> void:
		obj.location = input_.location
		vec.grid = input_.grid
		dict.neighbor = {}
		word.status = input_.status
		word.content = null


	func set_content(content_: String) -> void:
		word.content = content_
		
		if word.status == "blank":
			word.status = "booty"
			obj.location.arr.spot.blank.erase(self)
			obj.location.arr.spot.booty.append(self)


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


