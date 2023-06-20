extends Node


#Орбита orbit
class Orbit:
	var obj = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		obj.planet = input_.planet
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.orbit.instantiate()
		scene.myself.set_parent(self)
		#obj.planet.scene.myself.get_node("HBox").add_child(scene.myself)
		#obj.planet.scene.myself.get_node("HBox").move_child(scene.myself, 0)


#Спутник satellite
class Satellite:
	var obj = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		obj.orbit = input_.orbit
		obj.branch = input_.branch
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.satellite.instantiate()
		scene.myself.set_parent(self)


#Астероид asteroid
class Asteroid:
	var obj = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		obj.orbit = input_.orbit
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.asteroid.instantiate()
		scene.myself.set_parent(self)

