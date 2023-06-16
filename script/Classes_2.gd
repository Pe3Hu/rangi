extends Node


#Завод factory
class Factory:
	var arr = {}
	var obj = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		obj.corporation = input_.corporation
		obj.director = obj.corporation.obj.director
		obj.director.obj.factory = self
		init_scene()
		init_stamps()
		fill_stamps()


	func init_scene() -> void:
		scene.myself = Global.scene.factory.instantiate()
		scene.myself.set_parent(self)
		obj.corporation.obj.director.scene.myself.get_node("VBox").add_child(scene.myself)
		obj.corporation.obj.director.scene.myself.get_node("VBox").move_child(scene.myself, 0)


	func init_stamps() -> void:
		arr.stamp = []
		obj.stamp = {}
		var n = 3
		
		for _i in n:
			arr.stamp.append([])
			
			for _j in n:
				var input = {}
				input.grid = Vector2(_j, _i)
				input.factory = self
				var stamp = Classes_2.Stamp.new(input)
				arr.stamp[_i].append(stamp)
		
		set_stamp_as_selected(arr.stamp.front().front())


	func fill_stamps() -> void:
		obj.corporation.obj.director.obj.album.fill_thought()


	func get_frist_free_stamp() -> Variant:
		for stamps in arr.stamp:
			for stamp in stamps:
				if stamp.obj.design == null:
					return stamp.vec.grid
		
		return null


	func set_stamp_as_selected(stamp_: Stamp) -> void:
		obj.stamp.selected = stamp_
		obj.stamp.selected.word.status = "selected"
		
		for stamps in arr.stamp:
			for stamp in stamps:
				if stamp != obj.stamp.selected:
					if obj.stamp.selected.vec.grid.x == stamp.vec.grid.x or obj.stamp.selected.vec.grid.y == stamp.vec.grid.y:
						stamp.word.status = "line"
					else:
						stamp.word.status = "default"
				
				stamp.scene.myself.recolor()


	func shift_selected_stamp(shift_: Vector2) -> void:
		var grid = obj.stamp.selected.vec.grid + shift_
		
		if Global.boundary_of_array_check(arr.stamp, grid):
			set_stamp_as_selected(arr.stamp[grid.y][grid.x])


	func press_stamps() -> void:
		var pressed = ["selected", "line"]
		
		for stamps in arr.stamp:
			for stamp in stamps:
				if pressed.has(stamp.word.status):
					stamp.press()
		
		obj.director.obj.album.apply_dream()
		obj.director.obj.storage.scene.myself.update_labels()


#Оттиск stamp
class Stamp:
	var obj = {}
	var vec = {}
	var word = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		obj.factory = input_.factory
		obj.design = null
		word.status = "default"
		vec.grid = input_.grid
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.stamp.instantiate()
		scene.myself.set_parent(self)
		obj.factory.scene.myself.get_node("Stamp").add_child(scene.myself)


	func press() -> void:
		obj.design.obj.spielkarte.push_into_next_section()
