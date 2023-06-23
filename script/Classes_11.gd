extends Node


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
		arr.forest = []
		obj.sanctuary = input_.sanctuary
		dict.neighbor = {}


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
			for area in datas[type]:
				var input = {}
				input.type = type
				input.area = area
				num.area += area
				input.habitat = self
				var location = Classes_11.Location.new(input)
				
				if !arr.location.has(type):
					arr.location[type] = []
				
				arr.location[type].append(location)


#Локация location
class Location:
	var arr = {}
	var num = {}
	var obj = {}
	var word = {}


	func _init(input_: Dictionary) -> void:
		word.type = input_.type
		num.area = input_.area
		obj.habitat = input_.habitat
