extends Node


#Хранилище storage
class Storage:
	var obj = {}
	var dict = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		obj.corporation = input_.corporation
		obj.director = obj.corporation.obj.director
		obj.director.obj.storage = self
		init_scene()
		init_specialty()


	func init_scene() -> void:
		scene.myself = Global.scene.storage.instantiate()
		scene.myself.set_parent(self)
		obj.director.scene.myself.get_node("VBox").add_child(scene.myself)
		obj.director.scene.myself.get_node("VBox").move_child(scene.myself, 0)


	func init_specialty() -> void:
		dict.specialty = {}
		
		for specialty in Global.num.drone:
			dict.specialty[specialty] = {}
			
			for mastery in Global.num.drone[specialty].mastery:
				dict.specialty[specialty][mastery] = 0


	func apply_tool(tool_: Classes_3.Tool) -> void:
		var specialty = tool_.word.specialty
		var mastery = tool_.num.value
		dict.specialty[specialty][mastery] += 1


#Жетон badge
class Badge:
	var obj = {}
	var color = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		obj.branch = input_.branch
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.badge.instantiate()
		scene.myself.set_parent(self)


	func set_bg_color() -> void:
		var max_h = 360.0
		var h = float(obj.branch.num.index) / Global.num.index.branch
		var s = 0.25
		var v = 1
		color.bg = Color.from_hsv(h, s, v)
		scene.myself.update_color()
