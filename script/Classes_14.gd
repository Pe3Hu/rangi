extends Node


#Теплица greenhouse
class Greenhouse:
	var arr = {}
	var obj = {}


	func _init(input_: Dictionary) -> void:
		obj.sanctuary = input_.sanctuary
		init_plants()


	func init_plants() -> void:
		arr.plant = []
		var n = 1
		
		for _i in n:
			var input = {}
			input.greenhouse = self
			input.location = null
			input.kind = ""
			var plant = Classes_14.Plant.new(input)
			arr.plant.append(plant)


#Растение plant
class Plant:
	var obj = {}
	var vec = {}
	var word = {}


	func _init(input_: Dictionary) -> void:
		obj.greenhouse = input_.greenhouse
		obj.location = input_.location
		word.kind = input_.kind
		word.stage = {}
		word.stage.current = Global.arr.plant.stage.front()
