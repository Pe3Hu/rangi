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
			input.position = Vector2().from_angle(angle.current) * Global.num.size.forest.a
			vec.center += input.position
			input.ring = num.ring
			var sequoia = Classes_10.Sequoia.new(input)
			dict.sequoia[num.ring].append(sequoia)
		
		vec.center /= dict.sequoia[num.ring].size()
		var input = {}
		input.sanctuary = self
		input.sequoias = dict.sequoia[num.ring]
		input.ring = num.ring
		var forest = Classes_10.Forest.new(input)
		dict.forest[num.ring].append(forest)


	func set_following_forest_rings() -> void:
		while num.ring < Global.num.size.sanctuary.ring:
			set_next_ring()


	func set_next_ring() -> void:
		var glades = []
		
		for glade in arr.glade:
			if glade.num.ring == float(num.ring):
				glades.append(glade)
		
		num.ring += 1
		print(glades.size())
		
		for glade in glades:
			set_forest_based_on_glade(glade)


	func set_forest_based_on_glade(glade_: Glade) -> void:
		pass


#Лес forest
class Forest:
	var arr = {}
	var num = {}
	var obj = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		arr.sequoia = []
		arr.sequoia.append_array(input_.sequoias)
		obj.sanctuary = input_.sanctuary
		num.ring = input_.ring
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


#Поляна glade
class Glade:
	var arr = {}
	var num = {}
	var obj = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		arr.sequoia = []
		arr.sequoia.append_array(input_.sequoias)
		obj.sanctuary = input_.sanctuary
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
