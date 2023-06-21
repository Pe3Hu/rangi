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
		init_center()
		set_following_forest_rings()


	func init_scene() -> void:
		scene.myself = Global.scene.sanctuary.instantiate()
		scene.myself.set_parent(self)
		obj.planet.scene.myself.get_node("HBox").add_child(scene.myself)
		obj.planet.scene.myself.get_node("HBox").move_child(scene.myself, 0)


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
			angle.current = angle.step * _i
			var input = {}
			input.sanctuary = self
			input.position = Vector2().from_angle(angle.current) * Global.num.size.forest.r
			vec.center += input.position
			input.ring = num.ring
			var sequoia = Classes_10.Sequoia.new(input)
			dict.sequoia[num.ring].append(sequoia)
		
		vec.center /= dict.sequoia[num.ring].size()
		var input = {}
		input.sanctuary = self
		input.sequoias = dict.sequoia[num.ring]
		input.ring = num.ring
		input.shape = "octagon"
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
		var parity = int(glade_.num.ring * 2) % 2 == 0
		var triangle = glade_.arr.shape.has("triangle")
		var trapeze = glade_.arr.shape.has("trapeze")
		
		if parity and (triangle or trapeze or glade_.num.ring == 0):
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
						var sequoia = Classes_10.Sequoia.new(input)
						dict.sequoia[num.ring].append(sequoia)
						sequoias.new.append(sequoia)
			
			sequoias.new.append_array(sequoias.old)
			var input = {}
			input.sanctuary = self
			input.sequoias = sequoias.new
			input.ring = num.ring
			input.shape = "square"
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
						#neighbor.scene.myself.paint_black()
						input.sequoias.append(neighbor)
			
			if input.sequoias.size() == 4:
				var sequoia = input.sequoias.pop_at(2)
				input.sequoias.push_back(sequoia)
				input.sanctuary = self
				input.ring = num.ring
				input.shape = "trapeze"
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
		var forest = Classes_10.Forest.new(input)
		dict.forest[num.ring].append(forest)


	func init_forest_neighbors() -> void:
#		for ring in num.ring:
#			for forest in dict.forest[num.ring]:
#				for glade in forest.arr.glade:
#					if glade.num.ring == ring or glade.num.ring == ring + 0.5:
#						glade.make_forests_neighbors()
		
		for glade in arr.glade:
			glade.make_forests_neighbors()
		
		init_habitats()
		

	func init_habitats() -> void:
		dict.habitat = {}
		
		var input = {}
		input.sanctuary = self
		input.ring = 0
		input.forests = [dict.forest[input.ring].front()]
		var habitat = Classes_10.Habitat.new(input)
		dict.habitat[input.ring] = [habitat]
		
		for ring in range(1, num.ring + 1, 1):
			dict.habitat[ring] = []
			var forest = dict.forest[ring].front()
			var neighbors = []
			neighbors.append_array(get_unhabitated_neighbors(forest))
			
			while neighbors.size() > 0:
				var neighbor = neighbors.pick_random()
				neighbors.erase(neighbor)
				
				input.forests = [forest, neighbor]
				input.ring = ring
				habitat = Classes_10.Habitat.new(input)
				dict.habitat[ring].append(habitat)
				
				if neighbors.size() > 0:
					neighbors.append_array(get_unhabitated_neighbors(neighbor))
					forest = neighbors.pop_front()
					neighbors.append_array(get_unhabitated_neighbors(forest))
		
		for ring in dict.habitat:
			for habitat_ in dict.habitat[ring]:
				for forest in habitat_.arr.forest:
					forest.scene.myself.update_color_based_on_habitat_index()


	func get_unhabitated_neighbors(forest_: Forest) -> Array:
		var neighbors = []
		
		for neighbor in forest_.dict.neighbor:
			if forest_.num.ring == neighbor.num.ring and neighbor.obj.habitat == null:
				neighbors.append(neighbor)
		
		return neighbors

#Лес forest
class Forest:
	var arr = {}
	var num = {}
	var obj = {}
	var dict = {}
	var word = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		arr.sequoia = []
		arr.sequoia.append_array(input_.sequoias)
		obj.sanctuary = input_.sanctuary
		obj.habitat = null
		num.ring = input_.ring
		dict.neighbor = {}
		word.shape = input_.shape
		init_scene()
		init_glades()


	func init_scene() -> void:
		scene.myself = Global.scene.forest.instantiate()
		scene.myself.set_parent(self)
		obj.sanctuary.scene.myself.get_node("Forest").add_child(scene.myself)


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
				var glade = Classes_10.Glade.new(input)
				obj.sanctuary.arr.glade.append(glade)
				arr.glade.append(glade)
			else:
				var glade = arr.sequoia[_i].dict.neighbor[arr.sequoia[_j]]
				arr.glade.append(glade)
		
		for glade in arr.glade:
			glade.add_forest(self)


#Поляна glade
class Glade:
	var arr = {}
	var num = {}
	var obj = {}
	var word = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		arr.sequoia = []
		arr.sequoia.append_array(input_.sequoias)
		obj.sanctuary = input_.sanctuary
		arr.shape = []
		arr.forest = []
		update_sequoia_neighbors()
		set_ring()
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.glade.instantiate()
		scene.myself.set_parent(self)
		obj.sanctuary.scene.myself.get_node("Glade").add_child(scene.myself)


	func update_sequoia_neighbors() -> void:
#		if !obj.sanctuary.dict.glade.has(arr.sequoia.front()):
#			obj.sanctuary.dict.glade[arr.sequoia.front()] = {}
#
#		if !obj.sanctuary.dict.glade.has(arr.sequoia.back()):
#			obj.sanctuary.dict.glade[arr.sequoia.back()] = {}
#
#		obj.sanctuary.dict.glade[arr.sequoia.front()][arr.sequoia.back()] = self
#		obj.sanctuary.dict.glade[arr.sequoia.back()][arr.sequoia.front()] = self
		arr.sequoia.front().dict.neighbor[arr.sequoia.back()] = self
		arr.sequoia.back().dict.neighbor[arr.sequoia.front()] = self


	func set_ring() -> void:
		num.ring = float(min(arr.sequoia.front().num.ring, arr.sequoia.back().num.ring))
		
		if arr.sequoia.front().num.ring != arr.sequoia.back().num.ring:
			num.ring += 0.5


	func add_forest(forest_: Forest) -> void:
		arr.forest.append(forest_)
		arr.shape.append(forest_.word.shape)


	func make_forests_neighbors() -> void:
		arr.forest.front().dict.neighbor[arr.forest.back()] = self
		arr.forest.back().dict.neighbor[arr.forest.front()] = self 


#Секвойя sequoia
class Sequoia:
	var obj = {}
	var num = {}
	var vec = {}
	var dict = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		obj.sanctuary = input_.sanctuary
		num.ring = input_.ring
		vec.position = input_.position
		dict.neighbor = {}
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.sequoia.instantiate()
		scene.myself.set_parent(self)
		obj.sanctuary.scene.myself.get_node("Sequoia").add_child(scene.myself)


#Ареал habitat
class Habitat:
	var arr = {}
	var num = {}
	var obj = {}
	var dict = {}


	func _init(input_: Dictionary) -> void:
		num.ring = input_.ring
		num.index = Global.num.index.habitat
		Global.num.index.habitat += 1
		arr.forest = input_.forests
		obj.sanctuary = input_.sanctuary
		dict.neighbor = {}
		
		for forest in arr.forest:
			forest.obj.habitat = self

