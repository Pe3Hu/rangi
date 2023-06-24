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


#Локация location
class Location:
	var arr = {}
	var num = {}
	var obj = {}
	var vec = {}
	var word = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		num.area = input_.area
		num.order = input_.order
		word.type = input_.type
		obj.habitat = input_.habitat
		arr.beast = []


	func init_scene() -> void:
		num.angle = PI * 2 * num.order / obj.habitat.arr.location[word.type].size()
		var gap = Global.num.size.location.gap
		vec.offset = Vector2(0, -1).rotated(num.angle) * gap
		
		scene.myself = Global.scene.location.instantiate()
		scene.myself.set_parent(self)
		obj.habitat.scene.myself.get_node("Location").add_child(scene.myself)


#Локация occasion
class Occasion:
	var arr = {}
	var obj = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		arr.type = input_.type
		obj.location = input_.location

