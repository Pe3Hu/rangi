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
		var chains = []
		
		#for _i in n:
		for subclass in Global.dict.chain.subclass:
			var input = {}
			input.subclass = subclass
			#input.subclass = "animal"
			var chain = Classes_13.Chain.new(input)
			chains.append(chain)
		
		for chain in chains:
			var input = {}
			input.zoo = self
			input.chain = chain
			input.mentality = Global.arr.beast.mentality.back()
			var beast = Classes_12.Beast.new(input)
			arr.beast.append(beast)


#Зверь beast
class Beast:
	var arr = {}
	var num = {}
	var obj = {}
	var vec = {}
	var dict = {}
	var flag = {}
	var word = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		arr.task = []
		arr.opponent = []
		num.index = Global.num.index.beast
		Global.num.index.beast += 1
		obj.zoo = input_.zoo
		obj.chain = input_.chain
		obj.chain.obj.beast = self
		obj.location = null
		obj.occasion = null
		obj.target = {}
		vec.offset = Vector2()
		dict.task = {}
		flag.cycle = false
		word.mentality = input_.mentality
		init_scene()
		init_priority_in_combat()


	func init_scene() -> void:
		scene.myself = Global.scene.beast.instantiate()
		scene.myself.set_parent(self)


	func init_priority_in_combat() -> void:
		dict.priority = {}
		dict.priority.tactic = {}
		word.tactic = {}
		word.tactic.current = null
		
		for tactic in Global.arr.beast.tactic:
			dict.priority.tactic[tactic] = 1
		
		match word.mentality:
			"careful":
				dict.priority.tactic["bide"] += 2
			"balanced":
				pass
			"aggressive":
				dict.priority.tactic["attack"] += 2
		
		dict.priority.skill = {}
		word.skill = {}
		word.skill.current = null
		
		for skill in Global.dict.skill.subclass[obj.chain.word.subclass]:
			dict.priority.skill[skill] = 1


	func step_into_location(location_: Classes_11.Location) -> void:
		if location_ != null and obj.location != location_:
			leave_current_location()
			obj.location = location_
			location_.obj.habitat.select_to_show()
			location_.scene.myself.add_beast(self)
			location_.dict.footprint[self] = true


	func leave_current_location() -> void:
		if obj.location != null:
			obj.location.obj.habitat.hide()
			obj.location.scene.myself.remove_beast(self)
			obj.location = null


	func fill_task(task_: String) -> void:
		arr.task.append(task_)
		dict.task[task_] = {}
		var phases = []
		
		match task_:
			"site survey":
				phases.append("walk through habitat")
			"harvest":
				phases.append("reach harvest location")
				phases.append("seek plant prey")
			"migration":
				phases.append("reach suburb")
				phases.append("reach migration habitat")
		
		for phase in phases:
			dict.task[task_][phase] = false


	func get_follow_phase() -> Variant:
		if arr.task.front() != null:
			for phase in dict.task[arr.task.front()]:
				if !dict.task[arr.task.front()][phase]:
					return phase
		
		return null


	func reach_suburb() -> void:
		if obj.location.word.type != "suburb":
			var suburb = obj.location.obj.habitat.arr.location.suburb.front()
			step_into_location(suburb)
		
		finish_current_phase()


	func reach_migration_habitat() -> void:
		var habitat = select_migration_habitat()
		var suburb = habitat.arr.location.suburb.front()
		step_into_location(suburb)
		finish_current_phase()


	func select_migration_habitat() -> Classes_11.Habitat:
		var habitat = obj.location.obj.habitat.dict.neighbor.keys().pick_random()
		return habitat


	func walk_through_habitat() -> void:
		var location = select_unvisited_location()
		
		print(location)
		if location != null:
			step_into_location(location)
			repeat_current_phase()
		else:
			finish_current_phase()


	func select_unvisited_location() -> Variant:
		var habitat = obj.location.obj.habitat
		var unvisited_locations = []
		
		for type in habitat.arr.location:
			for location in habitat.arr.location[type]:
				if !location.dict.footprint.has(self):
					unvisited_locations.append(location)
		
		if unvisited_locations.size() > 0:
			var location = unvisited_locations.pick_random()
			return location
		
		return null


	func reach_harvest_location() -> void:
		var location = select_harvest_location()
		
		if location != null:
			step_into_location(location)
		else:
			var task = "migration"
			fill_task(task)
			change_primary_task(task)
		
		finish_current_phase()


	func select_harvest_location() -> Variant:
		var goal = "plant"
		var assessment = {}
		var habitat = obj.location.obj.habitat
		
		for type in habitat.arr.location:
			for location in habitat.arr.location[type]:
				if location.dict.footprint.has(self):
					assessment[location] = location.get_assessment_based_on_goal(goal)
		
		var location = Global.get_random_key(assessment)
		
		return location


	func seek_plant_prey() -> void:
		pass


	func change_primary_task(task_: String) -> void:
		reset_primary_task()
		arr.task.erase(task_)
		arr.task.push_front(task_)


	func reset_primary_task() -> void:
		for phase in dict.task[arr.task.front()]:
			dict.task[arr.task.front()][phase] = false


	func finish_current_phase() -> void:
		var phase = get_follow_phase()
		dict.task[arr.task.front()][phase] = true
		scene.myself.perform_task()


	func repeat_current_phase() -> void:
		scene.myself.perform_task()


	func close_primary_task() -> void:
		dict.task.erase(arr.task.front())
		arr.task.pop_front()


	func get_new_task() -> void:
		var tasks = ["harvest"]
		var task = tasks.pick_random()
		fill_task(task)


	func prepare_for_occasion() -> void:
		obj.target = null
		
		match obj.occasion.word.type:
			"clash":
				select_target()


	func select_target() -> void:
		match obj.occasion.word.type:
			"clash":
				var options = []
				
				for beast in obj.occasion.arr.beast:
					if beast != self:
						options.append(beast)
				
				obj.target = options.pick_random()
				obj.target.arr.opponent.append(self)


	func choose_tactic() -> void:
		if word.tactic.current == null:
			word.tactic.current = Global.get_random_key(dict.priority.tactic)


	func choose_skill() -> void:
		if word.skill.current == null:
			word.skill.current = Global.get_random_key(dict.priority.skill)


	func activate_skill() -> void:
		var result = {}
		result["on attack"] = obj.chain.roll_value_based_on_skill_and_condition(word.skill.current, "on attack")
		result["on defense"] = obj.target.obj.chain.roll_value_based_on_skill_and_condition(word.skill.current, "on defense")
		
		if result["on attack"] > result["on defense"]:
			obj.target.obj.chain.take_attack(self)
			print(["hit", result])
		
			if obj.target != null:
				print(self, word.skill.current,obj.target.obj.chain.num.wound)
		else:
			print(["miss", result])
		
		word.skill.current = null


	func die() -> void:
		print(self, " dead")
		
		for opponent in arr.opponent:
			opponent.obj.target = null
