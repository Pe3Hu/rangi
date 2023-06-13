extends Node


#Планета planet  
class Planet:
	var arr = {}
	var obj = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		obj.cosmos = input_.cosmos
		arr.corporation = []
		init_scene()
		init_bureau()


	func init_scene() -> void:
		scene.myself = Global.scene.planet.instantiate()
		scene.myself.set_parent(self)
		obj.cosmos.scene.myself.get_node("Planet").add_child(scene.myself)


	func init_bureau() -> void:
		var input = {}
		input.planet = self
		obj.bureau = Classes_3.Bureau.new(input)


	func add_corporation(corporation_: Classes_1.Corporation) -> void:
		arr.corporation.append(corporation_)
		corporation_.obj.planet = self
		scene.myself.get_node("VBox/Director").add_child(corporation_.obj.director.scene.myself)


#Космос cosmos
class Cosmos:
	var arr = {}
	var obj = {}
	var scene = {}


	func _init() -> void:
		init_scene()
		init_planet()
		init_corporations()


	func init_scene() -> void:
		scene.myself = Global.scene.cosmos.instantiate()
		Global.node.game.get_node("Layer0").add_child(scene.myself)


	func init_planet() -> void:
		var input = {}
		input.cosmos = self
		obj.planet = Classes_0.Planet.new(input)


	func init_corporations() -> void:
		arr.corporation = []
		var n = 2
		
		for _i in n:
			var input = {}
			input.cosmos = self
			var corporation = Classes_1.Corporation.new(input)
			arr.corporation.append(corporation)
			obj.planet.add_corporation(corporation)
