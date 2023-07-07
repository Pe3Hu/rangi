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
		
		for _i in n:
		#for subclass in Global.dict.chain.subclass:
			var input = {}
			#input.subclass = subclass
			input.subclass = "animal"
			var chain = Classes_13.Chain.new(input)
			chains.append(chain)
		
		for chain in chains:
			var input = {}
			input.zoo = self
			input.chain = chain
			input.mentality = Global.arr.beast.mentality.back()
			input.courage = Global.dict.beast.courage.keys()[2]
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
		num.index = Global.num.index.beast
		Global.num.index.beast += 1
		num.skill = {}
		num.skill.finish = null
		obj.zoo = input_.zoo
		obj.chain = input_.chain
		obj.chain.obj.beast = self
		vec.offset = Vector2()
		dict.task = {}
		flag.cycle = false
		flag.alive = true
		word.mentality = input_.mentality
		word.courage = input_.courage
		init_arr()
		init_obj()
		init_scene()
		init_priority_in_combat()


	func init_arr() -> void:
		arr.task = []
		arr.threat = {}
		arr.threat.recognized = []
		arr.threat.unrecognized = []
		arr.threat.beast = []
		arr.plan = {}
		arr.plan.respite = []
		arr.plan.response = []


	func init_obj() -> void:
		obj.location = null
		obj.occasion = null
		obj.target = {}
		obj.response = null


	func init_scene() -> void:
		scene.myself = Global.scene.beast.instantiate()
		scene.myself.set_parent(self)


	func init_priority_in_combat() -> void:
		dict.priority = {}
		word.tactic = {}
		word.tactic.current = null
		
		word.skill = {}
		word.skill.title = null
		word.skill.stage = null
		
		dict.priority.skill = {}
		
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


#Clash section

	func select_target() -> void:
		match obj.occasion.word.type:
			"clash":
				var options = []
				
				for beast in obj.occasion.arr.beast:
					if beast != self:
						options.append(beast)
				
				obj.target = options.pick_random()
				obj.target.arr.threat.beast.append(self)


	func choose_tactic() -> void:
		if word.tactic.current == null:
			if obj.chain.respite_check():
				word.tactic.current = "respite"
			else:
				identify_threat_to_response()
				
				if obj.response != null:
					word.tactic.current = "response"
				else:
					word.tactic.current = "attack"


	func choose_skill() -> void:
		if word.skill.title == null:
			word.skill.title = Global.get_random_key(dict.priority.skill)


	func activate_skill() -> void:
		var result = {}
		result["on attack"] = obj.chain.roll_exodus_value(self, "on attack")
		result["on defense"] = obj.target.obj.chain.roll_exodus_value(self, "on defense")
		
		if result["on attack"] > result["on defense"]:
			print(["hit", word.skill.title, result, obj.chain.obj.beast.num.index, obj.target.obj.chain.obj.beast.num.index])
		
			obj.target.obj.chain.take_attack(self)
#			if obj.target != null:
#				print(self, obj.target.obj.chain.num.wound)
		else:
			print(["miss", word.skill.title, result, obj.chain.obj.beast.num.index, obj.target.obj.chain.obj.beast.num.index])
		
		word.tactic.current = null
		word.skill.title = null
		word.skill.stage = null
		num.skill.finish = null
		
		if obj.target != null:
			obj.target.arr.threat.recognized.erase(self)
			obj.target.arr.threat.unrecognized.erase(self)


	func choose_respite_resource(time_: Variant) -> void:
		var multiplier = {}
		multiplier.aspect = Global.arr.beast.roll["modify time"]
		multiplier.value = obj.chain.obj.dice.aspect[multiplier.aspect].obj.edge.get_value()
		
		if word.respite.current == null:
			var datas = []
			
			for resource in Global.dict.beast.respite:
				var data = {}
				data.weight = null
				data.resource = resource
				
				for type in Global.dict.beast.respite[resource]:
					data.preparation = Global.dict.beast.respite[resource][type].preparation * multiplier.value
					var flag = true
					
					if time_ != null:
						if data.preparation > time_.left:
							flag = false
					
					if flag:
						data.effect = Global.dict.beast.respite[resource][type].effect
						data.type = type
						datas.append(data)
			
			if datas.size() == 1:
				word.respite.resource = datas.front().resource
				word.respite.type = datas.front().type
			
			if datas.size() > 1:
				for data in datas:
					match data.resource:
						"overload":
							data.max = float(obj.chain.num.resource[data.resource].current) / obj.chain.num.resource[data.resource].max
						"overheat":
							data.max = float(obj.chain.num.resource[data.resource].current) / obj.chain.num.resource[data.resource].max
						"integrity":
							data.max = Global.dict.wound.weight[data.type]
							
							if data.type == "debuff":
								data.max = obj.chain.num.debuff + 1
							
							data.max = float(data.max) / Global.dict.wound.weight["max"]
					
					Global.rng.randomize()
					data.weight = Global.rng.randi_range(0, data.max)
				
				datas.sort_custom(func(a, b): return a.weight > b.weight)
				word.respite.resource = datas.front().resource
				word.respite.type = datas.front().type


	func activate_respite() -> void:
		word.tactic.current = null
		word.respite.current = null


	func attempt_to_hide_threat() -> void:
		if !obj.target.arr.threat.recognized.has(self):
			#print("attempt_to_hide_threat", word.skill)
			var result = {}
			result["on attack"] = obj.chain.roll_intention_value(self, "on attack")
			result["on defense"] = obj.target.obj.chain.roll_intention_value(self, "on defense")
			
			if result["on attack"] > result["on defense"]:
				obj.target.arr.threat.unrecognized.append(self)
			else:
				if obj.target.arr.threat.unrecognized.has(self):
					obj.target.arr.threat.unrecognized.erase(self)
				
				obj.target.arr.threat.recognized.append(self)


	func identify_threat_to_response() -> void:
		var threats = []
		var max = Global.dict.wound.weight["max"]
		var courage = Global.dict.beast.courage[word.courage]
		
		for aggressor in arr.threat.recognized:
			var threat = {}
			threat.aggressor = aggressor
			threat.wound = Global.dict.skill.title[aggressor.word.skill.title].wound
			threat.weight = Global.dict.wound.weight[threat.wound]
			Global.rng.randomize()
			threat.react = Global.rng.randi_range(0, (max - threat.weight) * courage["continue"])
			Global.rng.randomize()
			threat.ignore = Global.rng.randi_range(0, threat.weight * courage["retreat"])
			threat.time = null
			
			if threat.react > threat.ignore:
				threat.time = threat.aggressor.num.skill.finish - Global.obj.cosmos.get_time()
				
				if threat.time > Global.dict.beast.response[threat.wound].preparation:
					threats.append(threat)
		
		if threats.size() > 0:
			threats.sort_custom(func(a, b): return a.weight > b.weight)
			var threat = threats.front()
			obj.response = threat.aggressor


	func threat_response() -> void:
		if obj.response != null:
			var time = {}
			time.left = obj.response.num.skill.finish - Global.obj.cosmos.get_time()
			var wound = Global.dict.skill.title[obj.response.word.skill.title].wound
			var description = Global.dict.beast.response[wound]
			time.left -= description.preparation
			time.min = float(time.left - description.activated)
			time.max = float(time.left)
			choose_respite_resource(time.left)


	func retreat() -> void:
		flag.alive = false
		print(obj.chain.obj.beast.num.index, " beast is retreat")
		
		for opponent in arr.threat.beast:
			opponent.obj.target = null


	func die() -> void:
		flag.alive = false
		print(obj.chain.obj.beast.num.index, " beast is dead")
		scene.myself.stop_skill()
		
		for opponent in arr.threat.beast:
			opponent.obj.target = null
			opponent.scene.myself.stop_skill()


#Harvest section

	func find_place_to_harvest() -> void:
		pass

