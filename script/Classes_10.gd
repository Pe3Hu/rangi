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
		split_glades()
		#init_habitats()
		paint_someone()
		num.paint = {}
		num.paint.ring = 2
		num.paint.index = 0


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
		
#		for ring in dict.forest:
#			for forest in dict.forest[ring]:
#				for _i in range(forest.dict.neighbor.keys().size()-1, -1, -1):
#					var neighbor = forest.dict.neighbor.keys()[_i]
#
#					if neighbor.flag.origin and shapes.has(neighbor.word.shape):
#						forest.dict.neighbor.erase(neighbor)


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
		input.forests = [dict.forest[input.ring].front()]
		var habitat = Classes_10.Habitat.new(input)
		dict.habitat[input.ring] = [habitat]
		index = (index + 1) % 2
		
		for ring in range(1, num.ring + 1, 1):
			var options = [dict.forest[ring].front()]
			input.ring = ring
			dict.habitat[ring] = []
			
			while options.size() > 0:
				var forest = options.pick_random()
				input.forests = [forest]
				options.erase(forest)
				options.append_array(get_unhabitated_neighbors(forest))
			
				forest.scene.myself.paint_black()
				for neighbor in options:
					print(neighbor)
					neighbor.scene.myself.paint_white()

				return 
					
				
				while input.forests.size() < sizes[index]:
					var neighbor = options.pick_random()
					input.forests.append(neighbor)
					options.erase(neighbor)
					options.append_array(get_unhabitated_neighbors(neighbor))
					
				habitat = Classes_10.Habitat.new(input)
				dict.habitat[ring].append(habitat)
				index = (index + 1) % 2


	func get_unhabitated_neighbors(forest_: Forest) -> Array:
		var neighbors = []
		
		for neighbor in forest_.dict.neighbor:
			if forest_.num.ring == neighbor.num.ring and neighbor.obj.habitat == null:
				neighbors.append(neighbor)
		
		return neighbors


	func paint_someone() -> void:
#		for ring in dict.forest:
#			print([ring, dict.forest[ring].size()])
#			for forest in dict.forest[ring]:
#				#print([ring, forest.num.index])
#				forest.scene.myself.update_color_based_on_forest_index()
		
#		var forest = dict.forest[1].back()
#		forest.scene.myself.paint_white()
#		print(forest.arr.sequoia)
#
#
#		for neighbor in forest.dict.neighbor:
#			var sequoias = []
#
#			for sequoia in neighbor.arr.sequoia:
#				if forest.arr.sequoia.has(sequoia):
#					sequoias.append(sequoia)
#
#			print([neighbor.arr.sequoia.size(), sequoias.size(), neighbor.arr.sequoia])
#			print([sequoias])
#			neighbor.scene.myself.paint_black()
		
#		var glade = arr.glade[31]
#		glade.scene.myself.visible = true
#		glade.scene.myself.paint_black()
#
#		for forest in glade.arr.forest:
#			forest.scene.myself.paint_white()
		
		#var forest = dict.forest[1][22]
#		var forest = dict.forest[2][30]
#		forest.scene.myself.paint_white()
#
#		for neighbor in forest.dict.neighbor:
#			if !neighbor.flag.origin:
#				forest.dict.neighbor[neighbor].scene.myself.visible = true
#				forest.dict.neighbor[neighbor].scene.myself.paint_black()

		
#		for ring in dict.habitat:
#			for habitat_ in dict.habitat[ring]:
#				for forest in habitat_.arr.forest:
#					forest.scene.myself.update_color_based_on_habitat_index()
		pass


	func paint_next_forest() -> void:
		dict.forest[num.paint.ring][num.paint.index].scene.myself.update_color_based_on_forest_shape()
		for neighbor in dict.forest[num.paint.ring][num.paint.index].dict.neighbor:
			dict.forest[num.paint.ring][num.paint.index].dict.neighbor[neighbor].scene.myself.visible = false
			neighbor.scene.myself.update_color_based_on_forest_shape()
		
		num.paint.index += 1
		
		if dict.forest[num.paint.ring].size() == num.paint.index:
			num.paint.index = 0
			num.paint.ring += 1
			
			if !dict.forest.has(num.paint.ring):
				num.paint.ring = 0
		
		dict.forest[num.paint.ring][num.paint.index].scene.myself.paint_white()
		print(dict.forest[num.paint.ring][num.paint.index].dict.neighbor.size())
		
		for neighbor in dict.forest[num.paint.ring][num.paint.index].dict.neighbor:
			dict.forest[num.paint.ring][num.paint.index].dict.neighbor[neighbor].scene.myself.visible = true
			dict.forest[num.paint.ring][num.paint.index].dict.neighbor[neighbor].scene.myself.paint_black()
			neighbor.scene.myself.paint_black()
			print(neighbor.flag.origin, neighbor.word.shape)


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
		num.index = null
		arr.sequoia = []
		arr.sequoia.append_array(input_.sequoias)
		obj.sanctuary = input_.sanctuary
		obj.habitat = null
		num.ring = input_.ring
		dict.neighbor = {}
		flag.origin = input_.origin
		word.shape = input_.shape
		
		if !flag.origin:
			num.index = Global.num.index.forest
			Global.num.index.forest += 1
		
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
			
#			if glade.flag.origin:
#				if glade.flag.parity:
#					glade.knock_out()
#					obj.sanctuary.arr.glade.erase(self)
#				else:
#					glade
		
		obj.sanctuary.scene.myself.get_node("Forest").remove_child(scene.myself)
		obj.sanctuary.dict.forest[num.ring].erase(self)


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
		obj.sanctuary.scene.myself.get_node("Glade").add_child(scene.myself)


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
		obj.sanctuary.scene.myself.get_node("Glade").remove_child(scene.myself)
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
		print([num.ring, arr.forest.size()])
		
		for forest in arr.forest:
			forest.obj.habitat = self

