extends Node


#Зоопарк zoo Bestiary
class Zoo:
	var arr = {}
	var obj = {}


	func _init(input_: Dictionary) -> void:
		obj.sanctuary = input_.sanctuary
		init_beasts()


	func init_beasts() -> void:
		arr.beast = []
		var n = 1
		
		for _i in n:
			var input = {}
			input.zoo = self
			var beast = Classes_12.Beast.new(input)
			arr.beast.append(beast)


#Зверь beast
class Beast:
	var num = {}
	var obj = {}
	var dict = {}
	var word = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		num.beast = Global.num.index.beast
		Global.num.index.beast += 1
		obj.zoo = input_.zoo
		obj.location = null
		dict.task = {}
		word.task = {}
		word.task.current = null
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.beast.instantiate()
		scene.myself.set_parent(self)


	func step_into_location(location_: Classes_11.Location) -> void:
		if location_ != null and obj.location != location_:
			leave_current_location()
			obj.location = location_
			location_.obj.habitat.select_to_show()
			location_.scene.myself.add_beast(self)


	func leave_current_location() -> void:
		if obj.location != null:
			obj.location.obj.habitat.hide()
			obj.location.scene.myself.remove_beast(self)
			obj.location = null


	func fill_task(task_: String) -> void:
		dict.task[task_] = {}
		var phases = []
		
		match task_:
			"migration":
				phases.append("reach suburb")
				phases.append("reach next habitat")
		
		for phase in phases:
			dict.task[task_][phase] = false


	func get_follow_phase() -> Variant:
		if word.task.current != null:
			for phase in dict.task[word.task.current]:
				if !dict.task[word.task.current][phase]:
					return phase
		
		return null


	func reach_suburb() -> void:
		if obj.location.word.type != "suburb":
			var suburb = obj.location.obj.habitat.arr.location.suburb.front()
			step_into_location(suburb)
		
		finish_current_phase()


	func reach_next_habitat() -> void:
		var habitat = select_next_habitat()
		var suburb = habitat.arr.location.suburb.front()
		step_into_location(suburb)
		finish_current_phase()


	func select_next_habitat() -> Classes_11.Habitat:
		var habitat = obj.location.obj.habitat.dict.neighbor.keys().pick_random()
		return habitat


	func finish_current_phase() -> void:
		var phase = get_follow_phase()
		dict.task[word.task.current][phase] = true
		scene.myself.perform_task()


	func close_current_task() -> void:
		dict.task.erase(word.task.current)
		word.task.current = null


	func get_new_task() -> void:
		var tasks = ["migration"]
		word.task.current = tasks.pick_random()
		fill_task(word.task.current)
