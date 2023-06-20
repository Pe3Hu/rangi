extends Node


#Заповедник sanctuary
class Sanctuary:
	var arr = {}
	var num = {}
	var obj = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		num.ring = 0
		obj.planet = input_.planet
		init_scene()
		init_center()


	func init_scene() -> void:
		scene.myself = Global.scene.sanctuary.instantiate()
		scene.myself.set_parent(self)
		obj.planet.scene.myself.get_node("HBox").add_child(scene.myself)
		obj.planet.scene.myself.get_node("HBox").move_child(scene.myself, 0)


	func init_center() -> void:
		arr.sequoia = [[]]
		var angle = {}
		angle.step = PI * 2 / Global.num.size.forest.n
		
		for _i in Global.num.size.forest.n:
			angle.current = angle.step * _i
			var input = {}
			input.sanctuary = self
			input.position = Vector2().from_angle(angle.current) * Global.num.size.forest.a
			input.ring = num.ring
			var sequoia = Classes_10.Sequoia.new(input)
			arr.sequoia[num.ring].append(sequoia)

#Лес forest
class Forest:
	var obj = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		obj.sanctuary = input_.sanctuary
		#init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.forest.instantiate()
		scene.myself.set_parent(self)


#Поляна glade
class Glade:
	var obj = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		obj.sanctuary = input_.sanctuary
		#init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.glade.instantiate()
		scene.myself.set_parent(self)


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
		obj.sanctuary.scene.myself.get_node("Sequoia").add_child(scene.myself)
		scene.myself.set_parent(self)
