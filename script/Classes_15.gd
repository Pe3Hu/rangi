extends Node


#Стая flock
class Flock:
	var arr = {}
	var obj = {}
	var vec = {}
	var scene = {}
	var word = {}


	func _init(input_: Dictionary) -> void:
		obj.zoo = input_.zoo
		obj.location = null
		obj.spot = null
		vec.offset = Vector2()
		word.subclass = input_.subclass
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.flock.instantiate()
		scene.myself.set_parent(self)


	func init_preys() -> void:
		arr.prey = []
		var description = Global.dict.prey.title[word.subclass]
		
		for _i in description.group.min:
			var input = {}
			input.subclass = word.subclass
			var prey = Classes_15.Prey.new(input)
			add_prey(prey)


	func add_prey(prey_: Prey) -> void:
		arr.prey.append(prey_)
		prey_.obj.flock = self


	func step_into_location(location_: Classes_11.Location) -> void:
		if location_ != null and obj.location != location_:
			leave_current_location()
			obj.location = location_
			location_.scene.myself.add_subject(self)
			location_.dict.footprint[self] = true


	func leave_current_location() -> void:
		if obj.location != null:
			obj.location.scene.myself.remove_subject(self)
			obj.location = null


#Добыча prey
class Prey:
	var obj = {}
	var word = {}


	func _init(input_: Dictionary) -> void:
		obj.flock = null
		word.subclass = input_.subclass
		init_dices()


	func init_dices() -> void:
		obj.dice = {}

