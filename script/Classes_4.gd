extends Node


#Хранилище storage
class Storage:
	var arr = {}
	var obj = {}
	var num = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		obj.corporation = input_.corporation
		obj.director = obj.corporation.obj.director
		obj.director.obj.storage = self
		init_scene()
		init_nums()


	func init_scene() -> void:
		scene.myself = Global.scene.storage.instantiate()
		scene.myself.set_parent(self)
		obj.director.scene.myself.get_node("VBox").add_child(scene.myself)
		obj.director.scene.myself.get_node("VBox").move_child(scene.myself, 0)


	func init_nums() -> void:
		num.count = {}
		
		for spec in Global.arr.spec:
			num.count[spec] = 0


	func apply_tool(tool_: Classes_3.Tool) -> void:
		num.count[tool_.word.specialty] += tool_.num.value
