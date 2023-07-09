extends Node


#Заповедник sanctuary
class Sanctuary:
	var arr = {}
	var num = {}
	var obj = {}
	var vec = {}
	var dict = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		num.ring = 0
		obj.planet = input_.planet
		init_scene()
		init_zoo()
		init_greenhouse()
		init_occasions()
		init_center()
		set_following_forest_rings()
		split_glades()
		init_habitats()
		init_biomes()
		init_breeds()
		init_spots()
		paint_someone()
		#set_locations()
		place_beast_in_locations()
		#init_clashes()
		#activate_beasts()


	func init_scene() -> void:
		scene.myself = Global.scene.sanctuary.instantiate()
		scene.myself.set_parent(self)
		obj.planet.scene.myself.get_node("HBox").add_child(scene.myself)
		obj.planet.scene.myself.get_node("HBox").move_child(scene.myself, 0)


	func init_zoo() -> void:
		var input = {}
		input.sanctuary = self
		obj.zoo = Classes_12.Zoo.new(input)


	func init_greenhouse() -> void:
		var input = {}
		input.sanctuary = self
		obj.greenhouse = Classes_15.Greenhouse.new(input)


	func init_occasions() -> void:
		dict.occasion = {}
		
		for occasion in Global.arr.occasion:
			dict.occasion[occasion] = []


	func init_center() -> void:
		arr.glade = []
		dict.sequoia = {}
		dict.forest = {}
		dict.sequoia[num.ring] = []
		dict.forest[num.ring] = []
		var angle = {}
		angle.step = PI * 2 / Global.num.size.forest.n
		vec.center = Vector2()
		
		for _i in Global.num.size.forest.n:
			angle.current = angle.step * (_i - 1)
			var input = {}
			input.sanctuary = self
			input.position = Vector2().from_angle(angle.current) * Global.num.size.forest.r
			vec.center += input.position
			input.ring = num.ring
			input.order = float(_i)
			var sequoia = Classes_10.Sequoia.new(input)
			dict.sequoia[num.ring].append(sequoia)
		
		vec.center /= dict.sequoia[num.ring].size()
		var input = {}
		input.sanctuary = self
		input.sequoias = dict.sequoia[num.ring]
		input.ring = num.ring
		input.shape = "octagon"
		input.origin = true
		var forest = Classes_10.Forest.new(input)
		dict.forest[num.ring].append(forest)


	func set_following_forest_rings() -> void:
		while num.ring < Global.num.size.sanctuary.ring:
			set_next_ring()
		
		init_forest_neighbors()


	func set_next_ring() -> void:
		var glades = []
		
		for glade in arr.glade:
			if glade.num.ring == float(num.ring):
				glades.append(glade)
		
		num.ring += 1
		dict.sequoia[num.ring] = []
		dict.forest[num.ring] = []
		
		for glade in glades:
			set_square_based_on_glade(glade)
		
		if num.ring == 1:
			for sequoia in dict.sequoia[num.ring - 1]:
				set_triangle_based_on_sequoia(sequoia)
		else:
			for glade in arr.glade:
				set_trapeze_based_on_glade(glade)


	func set_square_based_on_glade(glade_: Glade) -> void:
		var triangle = glade_.arr.shape.has("triangle")
		var trapeze = glade_.arr.shape.has("trapeze")
		
		if glade_.flag.parity and (triangle or trapeze or glade_.num.ring == 0):
			var sequoias = {}
			sequoias.old = glade_.arr.sequoia
			sequoias.new = []
			
			for _i in sequoias.old.size():
				var datas = []
				var _j  = (_i + 1) % sequoias.old.size()
				var vector = sequoias.old[_i].vec.position - sequoias.old[_j].vec.position
				var a = vector.length()
				var angle = vector.angle()
				
				for _l in range(-1,2,2):
					var data = {}
					data.angle = PI / 2 * _l + angle
					data.vertex = Vector2.from_angle(data.angle) * a + sequoias.old[_j].vec.position
					data.d = vec.center.distance_to(data.vertex)
					datas.append(data)
				
				var d = max(datas.front().d, datas.back().d)
				
				for data in datas:
					if data.d == d:
						var input = {}
						input.sanctuary = self
						input.position = data.vertex
						input.ring = num.ring
						input.order = float(sequoias.old[_j].num.order)
						var sequoia = Classes_10.Sequoia.new(input)
						dict.sequoia[num.ring].append(sequoia)
						sequoias.new.append(sequoia)
			
			sequoias.new.append_array(sequoias.old)
			var input = {}
			input.sanctuary = self
			input.sequoias = sequoias.new
			input.ring = num.ring
			input.shape = "square"
			input.origin = true
			var forest = Classes_10.Forest.new(input)
			dict.forest[num.ring].append(forest)


	func set_trapeze_based_on_glade(glade_: Glade) -> void:
		var triangle = glade_.arr.shape.has("triangle")
		var trapeze = glade_.arr.shape.has("trapeze")
		
		if !triangle and !trapeze and glade_.num.ring == num.ring - 1:
			var input = {}
			input.sequoias = []
			input.sequoias.append_array(glade_.arr.sequoia)
			
			for sequoia in glade_.arr.sequoia:
				for neighbor in sequoia.dict.neighbor:
					if neighbor.num.ring == num.ring:
						input.sequoias.append(neighbor)
			
			if input.sequoias.size() == 4:
				var sequoia = input.sequoias.pop_at(2)
				input.sequoias.push_back(sequoia)
				input.sanctuary = self
				input.ring = num.ring
				input.shape = "trapeze"
				input.origin = true
				var forest = Classes_10.Forest.new(input)
				dict.forest[num.ring].append(forest)


	func set_triangle_based_on_sequoia(sequoia_: Sequoia) -> void:
		var input = {}
		input.sequoias = [sequoia_]
		
		for sequoia in sequoia_.dict.neighbor:
			if sequoia.num.ring == num.ring:
				input.sequoias.append(sequoia)
		
		input.sanctuary = self
		input.ring = num.ring
		input.shape = "triangle"
		input.origin = true
		var forest = Classes_10.Forest.new(input)
		dict.forest[num.ring].append(forest)


	func init_forest_neighbors() -> void:
		for glade in arr.glade:
			glade.make_forests_neighbors()


	func split_glades() -> void:
		for glade in arr.glade:
			if glade.flag.parity and glade.flag.origin:
				glade.split()
		
		var shapes = ["trapeze", "square"]
		
		for ring in dict.forest:
			for forest in dict.forest[ring]:
				if shapes.has(forest.word.shape):
					forest.split()
		
		erase_origin_forests()
		erase_origin_glades()
		init_forest_neighbors()


	func erase_origin_forests() -> void:
		var shapes = ["trapeze", "square"]
		
		for ring in dict.forest:
			for _i in range(dict.forest[ring].size()-1, -1, -1):
				var forest = dict.forest[ring][_i]
				
				if forest.flag.origin and shapes.has(forest.word.shape):
					forest.knock_out()


	func erase_origin_glades() -> void:
		var shapes = ["trapeze", "square"]
		
		for _i in range(arr.glade.size()-1, -1, -1):
			var glade = arr.glade[_i]
			
			#if glade.arr.forest.size() > 2:
			for _j in range(glade.arr.forest.size()-1, -1, -1):
				var forest = glade.arr.forest[_j]
				
				if forest.flag.origin and shapes.has(forest.word.shape):
					glade.arr.forest.erase(forest)
			
			if glade.arr.forest.size() == 0:
				glade.knock_out()


	func init_habitats() -> void:
		dict.habitat = {}
		var sizes = [1, 3]
		var index = 0
		
		var input = {}
		input.sanctuary = self
		input.ring = 0
		var habitat = Classes_11.Habitat.new(input)
		habitat.add_forest(dict.forest[input.ring].front())
		dict.habitat[input.ring] = [habitat]
		index = (index + 1) % 2
		
		for ring in range(1, num.ring + 1, 1):
			var options = {}
			options.total = [dict.forest[ring].front()]
			options.current = []
			input.ring = ring
			dict.habitat[ring] = []
			
			while options.total.size() > 0:
				var forest = options.total.pick_random()
				
				if forest.obj.habitat == null:
					habitat = Classes_11.Habitat.new(input)
					dict.habitat[ring].append(habitat)
					habitat.add_forest(forest)
					options.total.erase(forest)
					options.current.append_array(get_unhabitated_neighbors(forest))
					
					while habitat.arr.forest.size() < sizes[index] and options.current.size() > 0:
						var neighbor = options.current.pick_random()
						habitat.add_forest(neighbor)
						options.current.erase(neighbor)
						options.current.append_array(get_unhabitated_neighbors(neighbor))
					
					index = (index + 1) % 2
					options.total.append_array(options.current)
					options.current = []
					#print(["H", habitat.num.ring, habitat.arr.forest.size()])#, habitat.arr.forest])
				else:
					options.total.erase(forest)
		
		init_habitat_neighbors()
		calculate_area_of_forests()


	func get_unhabitated_neighbors(forest_: Forest) -> Array:
		var neighbors = []
		
		for neighbor in forest_.dict.neighbor:
			if forest_.num.ring == neighbor.num.ring and neighbor.obj.habitat == null:
				neighbors.append(neighbor)
		
		return neighbors


	func init_habitat_neighbors() -> void:
		for ring in dict.habitat:
			for habitat in dict.habitat[ring]:
				for original_forest in habitat.arr.forest:
					for neighbor_forest in original_forest.dict.neighbor:
						if original_forest.obj.habitat != neighbor_forest.obj.habitat:
							var glade = original_forest.dict.neighbor[neighbor_forest]
						
							if !habitat.dict.neighbor.has(neighbor_forest.obj.habitat):
								habitat.dict.neighbor[neighbor_forest.obj.habitat] = glade
						
							if !neighbor_forest.obj.habitat.dict.neighbor.has(habitat):
								neighbor_forest.obj.habitat.dict.neighbor[habitat] = glade


	func calculate_area_of_forests() -> void:
		for ring in dict.habitat:
			for habitat in dict.habitat[ring]:
				for forest in habitat.arr.forest:
					forest.calculate_area()
				
				habitat.init_locations()


	func init_biomes() -> void:
		var biomes = {}
		biomes.habitat = []
		biomes.forest = {}
		biomes.neighbor = {}
		
		for ring in dict.habitat:
			if ring != 0:
				for habitat in dict.habitat[ring]:
					biomes.habitat.append(habitat)
		
		for biome in Global.arr.biome:
			biomes.forest[biome] = []
			biomes.neighbor[biome] = []
		
		var triangles = []
		
		for forest in dict.forest[1]:
			if forest.word.shape == "triangle":
				triangles.append(forest)
		
		for _i in range(1, triangles.size(), 2):
			var forest = triangles[_i]
			var index = ((_i - 1) / 2 + 1) % Global.arr.biome.size()
			var biome = Global.arr.biome[index]
			forest.obj.habitat.set_biome(biome)
			biomes.forest[biome].append_array(forest.obj.habitat.arr.forest)
			biomes.habitat.erase(forest.obj.habitat)
			
			for neighbor in forest.obj.habitat.dict.neighbor:
				if biomes.habitat.has(neighbor):
					biomes.neighbor[biome].append(neighbor)
		
		
		while biomes.habitat.size() > 0:
			var biome = get_smallest_biome(biomes)
			find_an_adjacent_habitat_for_biome(biomes, biome)


	func get_smallest_biome(biomes_: Dictionary) -> String:
		var biome = {}
		biome.title = ""
		biome.forests = Global.num.index.forest
		
		for biome_ in biomes_.forest:
			if biome.forests > biomes_.forest[biome_].size():
				biome.title = biome_
				biome.forests = biomes_.forest[biome_].size()
		
		return biome.title


	func find_an_adjacent_habitat_for_biome(biomes_: Dictionary, biome_: String) -> void:
		if biomes_.neighbor[biome_].size() > 0:
			var habitat = biomes_.neighbor[biome_].pick_random()
			
			for biome in biomes_.neighbor:
				biomes_.neighbor[biome].erase(habitat)
			
			for neighbor in habitat.dict.neighbor:
				if biomes_.habitat.has(neighbor):
					biomes_.neighbor[biome_].append(neighbor)
			
			habitat.set_biome(biome_)
			biomes_.forest[biome_].append_array(habitat.arr.forest)
			biomes_.habitat.erase(habitat)
		else:
			biomes_.forest.erase(biome_)
			biomes_.neighbor.erase(biome_)


	func init_breeds() -> void:
		var locations = []
		
		for ring in dict.habitat:
			for habitat in dict.habitat[ring]:
				for type in habitat.arr.location:
					for location in habitat.arr.location[type]:
						if location.word.biome != null:
							locations.append(location)
		
		while locations.size() > 0:
			var location = locations.pick_random()
			locations.erase(location)
			var breeds = {}
			
			for breed in Global.dict.biome.breed[location.word.biome]:
				breeds[breed] = Global.dict.breed.weight[breed]
			
			for type in location.obj.habitat.arr.location:
				for neighbor in location.obj.habitat.arr.location[type]:
					if neighbor.word.breed != null:
						breeds[neighbor.word.breed] += 1
			
			var breed = Global.get_random_key(breeds)
			location.set_breed(breed)


	func init_spots() -> void:
		for ring in dict.habitat:
			for habitat in dict.habitat[ring]:
				for type in habitat.arr.location:
					for location in habitat.arr.location[type]:
						location.init_spots()
				
				habitat.host_forge()
				
				for type in habitat.arr.location:
					for location in habitat.arr.location[type]:
						location.fill_spots()


	func set_locations() -> void:
		var habitat = dict.habitat[0].front()
		#habitat.select_to_show()


	func place_beast_in_locations() -> void:
		var locations = []
		
		for ring in dict.habitat:
			for habitat in dict.habitat[ring]:
				for type in habitat.arr.location:
					for location in habitat.arr.location[type]:
						locations.append(location)
		
		for beast in obj.zoo.arr.beast:
			var location = locations.pick_random()
			locations.erase(location)
			beast.step_into_location(location)


	func place_beast_in_harvest_locations() -> void:
		var locations = []
		
		for ring in dict.habitat:
			for habitat in dict.habitat[ring]:
				for type in habitat.arr.location:
					for location in habitat.arr.location[type]:
						locations.append(location)
		
		for beast in obj.zoo.arr.beast:
			var location = locations.pick_random()
			locations.erase(location)
			beast.step_into_location(location)


	func place_beasts_in_clashe_locations() -> void:
		var locations = []
		
		for ring in dict.habitat:
			for habitat in dict.habitat[ring]:
				for type in habitat.arr.location:
					for location in habitat.arr.location[type]:
						locations.append(location)
		
		var _i = 0
		var _j = 0
		
		while _i < obj.zoo.arr.beast.size():
			var beast = obj.zoo.arr.beast[_i]
			var location = locations[_j]
			beast.step_into_location(location)
			_i += 1
			
			if _i < obj.zoo.arr.beast.size():
				beast = obj.zoo.arr.beast[_i]
				beast.step_into_location(location)
				_i += 1
			
			_j += 1


	func init_harvests() -> void:
		var title = "harvest"
		
		for ring in dict.habitat:
			for habitat in dict.habitat[ring]:
				for type in habitat.arr.location:
					for location in habitat.arr.location[type]:
						if location.arr.beast.size() > 1:
							var input = {}
							input.location = location
							input.type = title
							var occasion = Classes_11.Occasion.new(input)
							dict.occasion[input.type].append(occasion)
		
		for occasion in dict.occasion[title]:
			occasion.prepare()
		
		for occasion in dict.occasion[title]:
			occasion.start()


	func init_clashes() -> void:
		var title = "clash"
		
		for ring in dict.habitat:
			for habitat in dict.habitat[ring]:
				for type in habitat.arr.location:
					for location in habitat.arr.location[type]:
						if location.arr.beast.size() > 1:
							var flag = false
							for beast in location.arr.beast:
								if beast.num.index == 0:
									flag = true
							
							if flag:
								var input = {}
								input.location = location
								input.type = title
								var occasion = Classes_11.Occasion.new(input)
								dict.occasion[input.type].append(occasion)
								
								for beast in location.arr.beast:
									occasion.add_beast(beast)
		
		for occasion in dict.occasion[title]:
			occasion.prepare()
		
		for occasion in dict.occasion[title]:
			occasion.start()


	func activate_beasts() -> void:
		for beast in obj.zoo.arr.beast:
			beast.get_new_task()
			beast.scene.myself.perform_task()



	func paint_someone() -> void:
		num.paint = {}
		num.paint.forest = {}
		num.paint.forest.ring = 0
		num.paint.forest.index = 0
		num.paint.habitat = {}
		num.paint.habitat.ring = 2
		num.paint.habitat.index = 0
		
		
		for ring in dict.habitat:
			for habitat_ in dict.habitat[ring]:
				for forest in habitat_.arr.forest:
					forest.scene.myself.update_color_based_on_biome()
		pass


	func paint_next_forest() -> void:
		var forest = dict.forest[num.paint.forest.ring][num.paint.forest.index]
		forest.scene.myself.update_color_based_on_forest_shape()
		
		for neighbor in forest.dict.neighbor:
			forest.dict.neighbor[neighbor].scene.myself.visible = false
			neighbor.scene.myself.update_color_based_on_forest_shape()
		
		num.paint.forest.index += 1
		
		if dict.forest[num.paint.forest.ring].size() == num.paint.forest.index:
			num.paint.forest.index = 0
			num.paint.forest.ring += 1
			
			if !dict.forest.has(num.paint.forest.ring):
				num.paint.forest.ring = 0
		
		forest = dict.forest[num.paint.forest.ring][num.paint.forest.index]
		forest.scene.myself.paint_white()
		
		for neighbor in forest.dict.neighbor:
			forest.dict.neighbor[neighbor].scene.myself.visible = true
			forest.dict.neighbor[neighbor].scene.myself.paint_black()
			neighbor.scene.myself.paint_black()


	func paint_next_habitat() -> void:
		var habitat = dict.habitat[num.paint.habitat.ring][num.paint.habitat.index]
		habitat.hide()
		
		for neighbor in habitat.dict.neighbor:
			for forest in neighbor.arr.forest:
				forest.scene.myself.update_color_based_on_habitat_index()
		
		num.paint.habitat.index += 1
		
		if dict.habitat[num.paint.habitat.ring].size() == num.paint.habitat.index:
			num.paint.habitat.index = 0
			num.paint.habitat.ring += 1
			
			if !dict.habitat.has(num.paint.habitat.ring):
				num.paint.habitat.ring = 0
		
		habitat = dict.habitat[num.paint.habitat.ring][num.paint.habitat.index]
		#print([num.paint.habitat, habitat.arr.forest.size(),  habitat.arr.forest])
		habitat.select_to_show()
		
		for neighbor in habitat.dict.neighbor:
			for forest in neighbor.arr.forest:
				forest.scene.myself.paint_black()


#Лес forest
class Forest:
	var arr = {}
	var num = {}
	var obj = {}
	var dict = {}
	var flag = {}
	var word = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		arr.sequoia = []
		arr.sequoia.append_array(input_.sequoias)
		num.ring = input_.ring
		num.index = null
		obj.sanctuary = input_.sanctuary
		obj.habitat = null
		dict.neighbor = {}
		flag.origin = input_.origin
		word.shape = input_.shape
		word.biome = null
		
		if !flag.origin:
			num.index = Global.num.index.forest
			Global.num.index.forest += 1
		
		init_scene()
		init_glades()


	func init_scene() -> void:
		scene.myself = Global.scene.forest.instantiate()
		scene.myself.set_parent(self)
		obj.sanctuary.scene.myself.get_node("HBox/Map/Forest").add_child(scene.myself)


	func init_glades() -> void:
		arr.glade = []
		
		for _i in arr.sequoia.size():
			var _j = (_i + 1) % arr.sequoia.size()
			
			if !arr.sequoia[_i].dict.neighbor.has(arr.sequoia[_j]):
				var input = {}
				input.sequoias = []
				input.sequoias.append(arr.sequoia[_i])
				input.sequoias.append(arr.sequoia[_j])
				input.sanctuary = obj.sanctuary
				input.origin = true
				var glade = Classes_10.Glade.new(input)
				obj.sanctuary.arr.glade.append(glade)
				arr.glade.append(glade)
			else:
				var glade = arr.sequoia[_i].dict.neighbor[arr.sequoia[_j]]
				arr.glade.append(glade)
		
		for glade in arr.glade:
			glade.add_forest(self)


	func split() -> void:
		var old_glades = []
		var input = {}
		input.sequoias = []
		
		for glade in arr.glade:
			if glade.flag.origin:
				if glade.obj.split != null:
					input.sequoias.append(glade.obj.split)
				else:
					old_glades.append(glade)
		
		if input.sequoias.size() == 2:
			input.sanctuary = obj.sanctuary
			input.origin = false
			var new_glade = Classes_10.Glade.new(input)
			obj.sanctuary.arr.glade.append(new_glade)
			
			for _i in old_glades.size():
				var old_glade = old_glades[_i]
				input = {}
				input.sequoias = []
				input.sequoias.append_array(new_glade.arr.sequoia)
				input.sequoias.append_array(old_glade.arr.sequoia)
				var _j = null
				
				match _i:
					0:
						_j = 2
					1:
						_j = 0
				
				var parity = int(num.ring) % 2 == 0
				var sequoia = null
				
				if (old_glade.arr.sequoia.front().num.order == 0.0 
				or old_glade.arr.sequoia.back().num.order == 0.0):
					if int(num.ring) % 2 == 1: 
						match _i:
							0:
								_j = 0
							1:
								_j = 2
					
					sequoia = input.sequoias.pop_at(_j)
					input.sequoias.push_back(sequoia)
					
					if (new_glade.arr.sequoia.front().num.order == 0.5
					or new_glade.arr.sequoia.back().num.order == 0.5):
						sequoia = input.sequoias.pop_at(1)
						input.sequoias.push_back(sequoia)
						
						if !parity:
							sequoia = input.sequoias.pop_at(2)
							input.sequoias.push_back(sequoia)
					
					if (new_glade.arr.sequoia.front().num.order == 7.5
					or new_glade.arr.sequoia.back().num.order == 7.5):
						sequoia = input.sequoias.pop_at(1)
						input.sequoias.push_back(sequoia)
						
						if parity:
							sequoia = input.sequoias.pop_at(2)
							input.sequoias.push_back(sequoia)
				else:
					sequoia = input.sequoias.pop_at(_j)
					input.sequoias.push_back(sequoia)
			
				input.sanctuary = obj.sanctuary
				input.ring = num.ring
				input.shape = word.shape
				input.origin = false
				var forest = Classes_10.Forest.new(input)
				obj.sanctuary.dict.forest[num.ring].append(forest)
				
				var glades = []
				
				for glade in forest.arr.glade:
					if !glade.flag.origin:
						glades.append(glade)
				#print(glades.size())


	func knock_out() -> void:
		for forest in dict.neighbor:
			forest.dict.neighbor.erase(self)
		
		for glade in arr.glade:
			glade.arr.forest.erase(self)
		
		obj.sanctuary.scene.myself.get_node("HBox/Map/Forest").remove_child(scene.myself)
		obj.sanctuary.dict.forest[num.ring].erase(self)


	func calculate_area() -> void:
		num.area = {}
		num.area.total = 0
		num.area.suburb = 0
		num.area.center = []
		
		var first = arr.sequoia.front().vec.position
		
		for _i in range(1, arr.sequoia.size() - 1, 1):
			var vertices = [first]
			
			for _j in 2:
				var index = _i + _j
				var vertex = arr.sequoia[index].vec.position
				vertices.append(vertex)
			
			num.area.total += int(round(Global.get_area_of_triangle_based_on_vertices(vertices)))
			var r = Global.get_radius_of_inscribed_circle_based_on_vertices(vertices)
			var circle_area = int(round(PI * pow(r, 2)))
			num.area.center.append(circle_area)
			num.area.suburb -= circle_area
		
		num.area.suburb += num.area.total


#Поляна glade
class Glade:
	var arr = {}
	var num = {}
	var obj = {}
	var flag = {}
	var word = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		arr.sequoia = []
		arr.sequoia.append_array(input_.sequoias)
		obj.sanctuary = input_.sanctuary
		obj.split = null
		arr.shape = []
		arr.forest = []
		flag.origin = input_.origin
		update_sequoia_neighbors()
		set_ring()
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.glade.instantiate()
		scene.myself.set_parent(self)
		obj.sanctuary.scene.myself.get_node("HBox/Map/Glade").add_child(scene.myself)


	func update_sequoia_neighbors() -> void:
		arr.sequoia.front().dict.neighbor[arr.sequoia.back()] = self
		arr.sequoia.back().dict.neighbor[arr.sequoia.front()] = self


	func set_ring() -> void:
		num.ring = float(min(arr.sequoia.front().num.ring, arr.sequoia.back().num.ring))
		
		if arr.sequoia.front().num.ring != arr.sequoia.back().num.ring:
			num.ring += 0.5
		
		flag.parity = int(num.ring * 2) % 2 == 0


	func add_forest(forest_: Forest) -> void:
		if !arr.forest.has(forest_):
			arr.forest.append(forest_)
			
			if !arr.shape.has(forest_.word.shape):
				arr.shape.append(forest_.word.shape)


	func make_forests_neighbors() -> void:
		if arr.forest.size() == 2:
			if !arr.forest.front().dict.neighbor.has(arr.forest.back()):
				arr.forest.front().dict.neighbor[arr.forest.back()] = self
			
			if !arr.forest.back().dict.neighbor.has(arr.forest.front()):
				arr.forest.back().dict.neighbor[arr.forest.front()] = self


	func split() -> void:
		var limit = Global.num.size.glade.split
		Global.rng.randomize()
		var factor = Global.rng.randf_range(limit.min, limit.max)
		var vector = arr.sequoia.front().vec.position - arr.sequoia.back().vec.position
		var l = vector.length() * factor
		var vertex = arr.sequoia.back().vec.position + vector.normalized() * l
		var ordres = [arr.sequoia.front().num.order, arr.sequoia.back().num.order]
		
		if ordres.front() != ordres.back():
			if ordres.has(0.0) and !ordres.has(1.0):
				ordres.erase(0.0)
				ordres.append(float(Global.num.size.forest.n))
		
		var input = {}
		input.sanctuary = obj.sanctuary
		input.position = vertex
		input.ring = arr.sequoia.back().num.ring
		input.order = (ordres.front()+ ordres.back()) * 0.5
		obj.split = Classes_10.Sequoia.new(input)
		obj.sanctuary.dict.sequoia[input.ring].append(obj.split)
		
		arr.sequoia.front().dict.neighbor.erase(arr.sequoia.back())
		arr.sequoia.back().dict.neighbor.erase(arr.sequoia.front())
		
		for sequoia in arr.sequoia:
			input = {}
			input.sequoias = [sequoia, obj.split]
			input.sanctuary = obj.sanctuary
			input.origin = false
			var glade = Classes_10.Glade.new(input)
			obj.sanctuary.arr.glade.append(glade)
			glade.scene.myself.paint_black()
			
			for foreset in arr.forest:
				glade.add_forest(foreset)


	func knock_out() -> void:
		obj.sanctuary.scene.myself.get_node("HBox/Map/Glade").remove_child(scene.myself)
		obj.sanctuary.arr.glade.erase(self)
		
		for forest in arr.forest:
			for neighbor in forest.dict.neighbor:
				if forest.dict.neighbor[neighbor] == self:
					forest.dict.neighbor.erase(neighbor)
					neighbor.dict.neighbor.erase(forest)


#Секвойя sequoia
class Sequoia:
	var num = {}
	var obj = {}
	var vec = {}
	var dict = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		num.order = input_.order
		num.ring = input_.ring
		obj.sanctuary = input_.sanctuary
		vec.position = input_.position
		dict.neighbor = {}
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.sequoia.instantiate()
		scene.myself.set_parent(self)
		obj.sanctuary.scene.myself.get_node("HBox/Map/Sequoia").add_child(scene.myself)
