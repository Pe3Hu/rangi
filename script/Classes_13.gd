extends Node


#Цепь chain
class Chain:
	var arr = {}
	var num = {}
	var obj = {}
	var word = {}


	func _init(input_: Dictionary) -> void:
		#obj.design = input_.design
		word.subclass = input_.subclass
		obj.beast = null
		init_dices()
		init_resources()
		init_aspects()
		init_links()


	func init_dices() -> void:
		obj.dice = {}
		var aspects = ["offensive", "resilience"]
		
		for aspect in aspects:
			var input = {}
			input.chain = self
			#input.aspect = aspect
			input.faces = 20
			obj.dice[aspect] = Classes_14.Dice.new(input)


	func init_resources() -> void:
		num.resource = {}
		num.wound = {}
		num.stage = {}
		num.indicator = {}
		num.indicator.threat = 0
		arr.trigger = {}
		
		for condition in Global.arr.condition:
			arr.trigger[condition] = []
		
		var description = Global.dict.skeleton.title[word.subclass].wound
		
		for wound in description:
			num.wound[wound] = {}
			num.wound[wound].max = description[wound]
			num.wound[wound].current = 0
		
		for aspect in Global.dict.beast.resource:
			var resource = Global.dict.beast.resource[aspect]
			num.resource[resource] = {}
			num.resource[resource].max = 100
			
			match resource:
				"overheat":
					num.resource[resource].current = 0
					num.stage[resource] = 0
				"integrity":
					num.resource[resource].max = 0
					
					for wound in num.wound:
						num.resource[resource].max += Global.dict.wound.weight[wound] * num.wound[wound].max
					
					num.resource[resource].max -= Global.dict.wound.weight["lethal"]
					num.resource[resource].current = int(num.resource["integrity"].max)
					num.indicator[resource] = 1.0
				"overload":
					num.resource[resource].current = 0
					num.stage[resource] = 0
				"energy":
					num.resource[resource].current = num.resource[resource].max


	func init_aspects() -> void:
		num.aspect = {}
		
		for aspect in Global.arr.beast.aspect:
			num.aspect[aspect] = {}
			num.indicator[aspect] = 0
		
			if Global.dict.aspect.subaspect.has(aspect):
				for subaspect in Global.dict.aspect.subaspect[aspect]:
					num.aspect[aspect][subaspect] = {}
					num.aspect[aspect][subaspect].base = 0
					num.aspect[aspect][subaspect].current = 0
			else:
				num.aspect[aspect][aspect] = {}
				num.aspect[aspect][aspect].base = 0
				num.aspect[aspect][aspect].current = 0
		
		get_skeleton()


	func get_skeleton() -> void:
		var description = Global.dict.skeleton.title[word.subclass].aspect
		
		for aspect in description:
			var value = {}
			value.total = description[aspect]
			value.min = value.total / (num.aspect[aspect].keys().size() + 1)
			value.free = value.total - value.min * num.aspect[aspect].keys().size()
			
			for subaspect in num.aspect[aspect]:
				num.aspect[aspect][subaspect].base += value.min
			
			while value.free > 0:
				var subaspect = num.aspect[aspect].keys().pick_random()
				num.aspect[aspect][subaspect].base += 1
				value.free -= 1
			
			for subaspect in num.aspect[aspect]:
				num.aspect[aspect][subaspect].current = int(num.aspect[aspect][subaspect].base)


	func init_links() -> void:
		arr.link = []
		var links = Global.dict.chain.subclass[word.subclass]
		
		for type in links:
			for _i in links[type].count:
				var input = {}
				input.chain = self
				input.type = type
				input.size = links[type].size
				var link = Classes_13.Link.new(input)
				arr.link.append(link)
		
		update_indicators()
		update_aspects()
		#print(num.aspect)


	func update_indicators() -> void:
		for aspect in num.aspect:
			num.indicator[aspect] = 0
			
			for subaspect in num.aspect[aspect]:
				num.indicator[aspect] += num.aspect[aspect][subaspect].base
			
			num.indicator[aspect] = floor(num.indicator[aspect] / num.aspect[aspect].keys().size())
		
		for aspect in num.indicator:
			if aspect != "threat":
				var sign = 1
				
				if aspect == "decay":
					sign -= 1
				
				num.indicator["threat"] += num.indicator[aspect] * sign
		
		num.indicator["threat"] = floor(sqrt(num.indicator["threat"]))
		num.indicator["overlimit"] = {}
		num.indicator["overlimit"].max = 0
		
		for resource in Global.dict.trigger.condition:
			var size = Global.dict.trigger.condition[resource].size()
			num.indicator["overlimit"].max += pow(size, 2)
		
		num.indicator["overlimit"].current = 0.0
		num.indicator["overlimit"].value = 0.0
		
		for event in Global.dict.subaspect.event:
			num.indicator[event] = 0
			
			for subaspect in Global.dict.subaspect.event[event]:
				var aspect = Global.dict.subaspect.title[subaspect].aspect
				num.indicator[event] += num.aspect[aspect][subaspect].current
			
			num.indicator[event] = floor(num.indicator[event] / Global.dict.subaspect.event[event].size())


	func update_aspects() -> void:
		for aspect in num.aspect:
			for subaspect in num.aspect[aspect]:
				num.aspect[aspect][subaspect].current = num.aspect[aspect][subaspect].base


	func expend_resources() -> void:
		var description = Global.dict.skill.title[obj.beast.word.skill.current]
		
		for resource in num.resource:
			if description.has(resource):
				var value = description[resource]
				expend_resource(resource, value) 


	func expend_resource(resource_: String, value_: int) -> void:
		var expend = null
		var residue = num.resource[resource_].max - num.resource[resource_].current 
		
		match resource_:
			"overheat":
				expend = min(residue, value_)
				num.resource[resource_].current += expend
			"overload":
				expend = min(residue, value_)
				num.resource[resource_].current += expend
			"energy":
				expend = min(num.resource[resource_].current, value_)
				num.resource[resource_].current -= expend
		
		if num.resource[resource_].current < 0:
			num.resource[resource_].current = 0
		
		update_trigger_based_on_overlimit_stage(resource_)


	func update_trigger_based_on_overlimit_stage(resource_: String) -> void:
		if Global.dict.trigger.condition.has(resource_):
			var stage = get_overlimit_stage(resource_)
			
			if stage != null and num.stage[resource_] != stage:
				var shift = stage - num.stage[resource_]
				
				if shift > 0:
					set_trigger_to_next_overlimit_stage(resource_)
				else:
					set_trigger_to_previous_overlimit_stage(resource_)
				
				update_overlimit_indicator()


	func get_overlimit_stage(resource_: String) -> Variant:
		var percentage = float(num.resource[resource_].current) / num.resource[resource_].max
		var stages = Global.dict.trigger.condition[resource_].size()
		
		for stage in stages:
			var stage_percentage = float(stage) / (stages - 1)
			
			if percentage < stage_percentage:
				stage -= 1
				return stage
			
			if stage == stages - 1:
				return stage
		
		return null


	func set_trigger_to_next_overlimit_stage(resource_: String) -> void:
		var stages = Global.dict.trigger.condition[resource_].size()
		
		if num.stage[resource_] < stages - 1:
			num.indicator["overlimit"].current -= pow(num.stage[resource_], 2)
			num.stage[resource_] += 1
			num.indicator["overlimit"].current += pow(num.stage[resource_], 2)
			
			var conditions = Global.dict.trigger.condition[resource_][num.stage[resource_]]
			var debuffs = Global.dict.trigger.debuff[resource_][num.stage[resource_]]
			
			for condition in conditions:
				for debuff in debuffs:
					arr.trigger[condition].append(debuff)


	func set_trigger_to_previous_overlimit_stage(resource_: String) -> void:
		if num.stage[resource_] > 0:
			var conditions = Global.dict.trigger.condition[resource_][num.stage[resource_]]
			var debuffs = Global.dict.trigger.debuff[resource_][num.stage[resource_]]
			
			for condition in conditions:
				for debuff in debuffs:
					arr.trigger[condition].erase(debuff)
			
			num.indicator["overlimit"].current -= pow(num.stage[resource_], 2)
			num.stage[resource_] -= 1
			num.indicator["overlimit"].current += pow(num.stage[resource_], 2)


	func take_attack(opponent_: Classes_12.Beast) -> void:
		var wound = Global.dict.skill.title[opponent_.word.skill.current].wound
		
		if num.wound.has(wound):
			take_wound(wound)
		else:
			take_debuff(opponent_)
		
		update_integrity_indicator()
		
		if retreat_check():
			obj.beast.retreat()


	func take_wound(wound_: String) -> void:
		num.wound[wound_].current += 1
		num.resource["integrity"].current -= Global.dict.wound.weight[wound_]
		
		if num.wound[wound_].current == num.wound[wound_].max and wound_ == "lethal":
			#print(num.wound)
			obj.beast.die()
		elif num.wound[wound_].current > num.wound[wound_].max:
			num.wound[wound_].current = num.wound[wound_].max
			num.resource["integrity"].current += Global.dict.wound.weight[wound_]
			var aggravation = Global.get_aggravation(wound_)
			take_wound(aggravation)


	func take_debuff(opponent_: Classes_12.Beast) -> void:
		pass


	func update_integrity_indicator() -> void:
		if obj.beast.flag.alive:
			num.indicator["integrity"] = float(num.resource["integrity"].current)/ num.resource["integrity"].max
		else:
			num.indicator["integrity"] = 0


	func update_overlimit_indicator() -> void:
		num.indicator["overlimit"].value = float(num.indicator["overlimit"].current)/ num.indicator["overlimit"].max


	func reduce_overlimit() -> void:
		var resource = obj.beast.word.respite.current
		var value = Global.dict.beast.respite[resource].effect
		expend_resource(resource, -value)


	func retreat_check() -> bool:
		if obj.beast.flag.alive:
			var actions = Global.dict.beast.courage[obj.beast.word.courage]
			var value = {}
			Global.rng.randomize()
			value["continue"] = Global.rng.randf_range(0, num.indicator["integrity"]) * actions["continue"]
			value["retreat"] = Global.rng.randf_range(0, 1.0 - num.indicator["integrity"]) * actions["retreat"]
			
			return value["retreat"] > value["continue"]
		
		return false


	func respite_check() -> bool:
		var actions = Global.dict.beast.mentality[obj.beast.word.mentality]
		var value = {}
		Global.rng.randomize()
		value["respite"] = Global.rng.randf_range(0, num.indicator["overlimit"].value) * actions["respite"]
		value["action"] = Global.rng.randf_range(0, 1.0 - num.indicator["overlimit"].value) * actions["action"]
		
		return value["respite"] > value["action"]


	func identify_threat_to_response() -> Variant:
		var threats = []
		
		for beast in obj.beast.arr.threat.skill:
			var threat = {}
			threat.beast = beast
			threat.wound = Global.dict.skill.title[beast.word.skill.current].wound
			threat_detection_check(beast)
		
		
		return null

	func threat_detection_check(beast_: Classes_12.Beast) -> bool:
		var wound = Global.dict.skill.title[beast_.word.skill.current].wound
		
		
		return false


	func roll_exodus_value_based_on_skill_and_condition(skill_: String, condition_: String) -> int:
		var description = Global.dict.skill.title[skill_]
		var subaspect = Global.get_subaspect_based_on_wound_and_condition(description.wound, condition_)
		var aspect = Global.dict.aspect.condition[condition_]
		var edge = obj.dice[aspect].roll()
		var attempts = Global.dict.gist.attempt[edge.word.gist]
		
		if condition_ == "on attack":
			attempts += Global.dict.modifier.attempt[description.accuracy]
			#print(Global.dict.modifier.attempt[description.accuracy])
		
		#correction for the sum of two hindrances
		if edge.word.gist.contains("hindrance") and description.accuracy.contains("hindrance"):
			attempts += 2
		
		var values = []
		var min = num.aspect[aspect][subaspect].current
		var max = 0
		var value = {}
		value.max = num.aspect[aspect][subaspect].current + num.indicator["inside event"]
		
		if attempts == 0:
			attempts = -1
		
		for _i in abs(attempts):
			Global.rng.randomize()
			value.current = Global.rng.randi_range(0, value.max)
			values.append(value.current)
			
			if min > value.current:
				min = value.current
			
			if max < value.current:
				max = value.current
		
		if description.wound == "lethal":
			print([attempts, values, min, max, value.max])
		
		if attempts > 0:
			return max
		
		if attempts < 0:
			return min
		
		return max


	func roll_intention_value_based_on_skill_andcondition(skill_: String, condition_: String) -> int:
		var description = Global.dict.skill.title[skill_]
		var subaspect = Global.dict.subaspect.intention[condition_]
		var aspect = Global.dict.aspect.condition[condition_]
		var edge = obj.dice[aspect].roll()
		var attempts = Global.dict.gist.attempt[edge.word.gist]
		
		if condition_ == "on attack":
			attempts += Global.dict.modifier.attempt[description.notability]
		
		#correction for the sum of two hindrances
		if edge.word.gist.contains("hindrance") and description.notability.contains("hindrance"):
			attempts += 2
		
		var values = []
		var min = num.aspect[aspect][subaspect].current
		var max = 0
		var value = {}
		value.max = num.aspect[aspect][subaspect].current + num.indicator["inside event"]
		
		if attempts == 0:
			attempts = -1
		
		for _i in abs(attempts):
			Global.rng.randomize()
			value.current = Global.rng.randi_range(0, value.max)
			values.append(value.current)
			
			if min > value.current:
				min = value.current
			
			if max < value.current:
				max = value.current
		
		if description.wound == "lethal":
			print([attempts, values, min, max, value.max])
		
		if attempts > 0:
			return max
		
		if attempts < 0:
			return min
		
		return max

#Звено link
class Link:
	var num = {}
	var obj = {}
	var word = {}


	func _init(input_: Dictionary) -> void:
		num.size = input_.size
		obj.chain = input_.chain
		word.type = input_.type
		num.bonus = {}
		generate_basic_bonuses()


	func generate_basic_bonuses() -> void:
		var values = {}
		var description = Global.dict.link.title[word.type]
		
		for aspect in Global.dict.aspect.subaspect:
			var subaspect = Global.dict.aspect.subaspect[aspect].pick_random()
			num.bonus[subaspect] = description[aspect]
			obj.chain.num.aspect[aspect][subaspect].base += num.bonus[subaspect]


#Резонатор resonator
class Resonator:
	var obj = {}


	func _init(input_: Dictionary) -> void:
		obj.design = input_.design
		obj.capsule = input_.capsule
		obj.core = input_.core
