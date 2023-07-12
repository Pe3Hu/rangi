extends Node


#Стая flock
class Flock:
	var arr = {}
	var num = {}
	var obj = {}
	var vec = {}
	var scene = {}
	var word = {}


	func _init(input_: Dictionary) -> void:
		obj.zoo = input_.zoo
		int_objs()
		vec.offset = Vector2()
		word.subclass = input_.subclass
		init_scene()
		init_nums()
		init_preys()


	func int_objs() -> void:
		obj.location = null
		obj.spot = null
		obj.migrate = {}
		obj.migrate.spot = null
		obj.migrate.location = null
		obj.moving = null
		obj.grazing = null


	func init_scene() -> void:
		scene.myself = Global.scene.flock.instantiate()
		scene.myself.set_parent(self)


	func init_nums() -> void:
		var limit = Global.num.size.flock.purposefulness
		Global.rng.randomize()
		num.purposefulness = Global.rng.randi_range(limit.min, limit.max)


	func init_preys() -> void:
		arr.prey = []
		var description = Global.dict.prey.title[word.subclass]
		
		for _i in description.group.min:
			var input = {}
			input.subclass = word.subclass
			var prey = Classes_15.Prey.new(input)
			add_prey(prey)
		
		set_leader()
		update_speed()


	func add_prey(prey_: Prey) -> void:
		arr.prey.append(prey_)
		prey_.obj.flock = self


	func set_leader() -> void:
		var prey = arr.prey.pick_random()
		prey.lead()


	func update_speed() -> void:
		num.speed = int(obj.leader.num.speed)
		
		for prey in arr.prey:
			num.speed = min(num.speed, prey.num.speed)


	func step_into_location(location_: Classes_11.Location) -> void:
		if location_ != null and obj.location != location_:
			leave_location()
			obj.location = location_
			location_.scene.myself.add_subject(self)
			location_.dict.footprint[self] = Time.get_unix_time_from_system()
			var spot = obj.location.arr.spot.frontier.pick_random()
			step_on_spot(spot)
			location_.obj.habitat.show()
			location_.show_spots()


	func step_on_spot(spot_: Classes_11.Spot) -> void:
		if obj.spot != null:
			obj.spot.arr.subject.erase(self)
			obj.spot.scene.myself.update_color_based_on_content()
		
		obj.spot = spot_
		obj.spot.arr.subject.append(self)
		obj.spot.scene.myself.update_color_based_on_content()
		obj.spot.dict.footprint[self] = Time.get_unix_time_from_system()


	func leave_location() -> void:
		if obj.location != null:
			obj.location.scene.myself.remove_subject(self)
			obj.location = null
			obj.spot.arr.subject.erase(self)
			obj.spot.scene.myself.update_color_based_on_content()
			obj.spot = null


	func grazing() -> void:
		if obj.grazing == obj.spot:
			if obj.spot.obj.plant == null:
				scene.myself.start_grazing()
			else:
				scene.myself.start_chewing_bush()
		else:
			if obj.spot.word.content == "bush":
				if recognize_bush():
					scene.myself.start_chewing_bush()
			else:
				scene.myself.start_grazing()


	func set_grazing_spot() -> void:
		obj.grazing = null
		obj.moving = null
		var spots = []
		var nourishment = Global.dict.prey.title[word.subclass].nourishment
		
		for neighbor in obj.spot.dict.neighbor:
			if !neighbor.dict.footprint.has(self):
				match nourishment:
					"herbivore":
						if obj.spot.word.content == "bush":
							if recognize_bush():
								spots.append(neighbor)
					"herbivore":
						spots.append(neighbor)
		
		if spots.size() > 0:
			obj.grazing = spots.pick_random()
			obj.moving = obj.grazing
			return
		
		print("___")
		for neighbor in obj.spot.dict.neighbor:
			if !neighbor.dict.footprint.has(self):
				spots.append(neighbor)
			else:
				print(neighbor)
		
		if spots.size() > 0:
			obj.moving = spots.pick_random()
		else:
			obj.moving = obj.spot.dict.neighbor.keys().pick_random()


	func recognize_bush() -> bool:
		var result = {}
		result["on attack"] = obj.leader.roll_aspect_value("sensory", 1)
		result["on defense"] = obj.spot.obj.plant.roll_stealth_value()
	
		if result["on attack"] > result["on defense"]:
			return true
		
		return false


	func set_spot_to_migrate() -> void:
		if obj.spot.num.remoteness == 0:
			set_location_to_migrate()
		else:
			var remoteness = Global.num.size.location.spot
			obj.migrate.spot = null
			
			for neighbor in obj.spot.dict.neighbor:
				if neighbor.num.remoteness < remoteness:
					remoteness = neighbor.num.remoteness
					obj.migrate.spot = neighbor


	func set_location_to_migrate() -> void:
		var locations = []
		
		for neighbor in obj.spot.obj.location.dict.neighbor:
			if !neighbor.dict.footprint.has(self):
				locations.append(neighbor)
		
		obj.migrate.location = locations.pick_random()
		
		if obj.migrate.location == null:
			obj.spot.obj.location.dict.neighbor.pick_random()


#Добыча prey
class Prey:
	var num = {}
	var obj = {}
	var word = {}


	func _init(input_: Dictionary) -> void:
		obj.flock = null
		word.subclass = input_.subclass
		init_nums()
		init_dices()


	func init_nums() -> void:
		num.aspect = {}
		var description = Global.dict.prey.title[word.subclass]
		
		for aspect in description.aspect:
			num.aspect[aspect] = description.aspect[aspect]
		
		var bonus = {}
		bonus.size = ["small", "small", "big", "big"]
		bonus.sign = [-1, -1, 1, 1]
		bonus.aspect = []
		bonus.aspect.append_array(num.aspect.keys())
		bonus.aspect.shuffle()
		
		for _i in bonus.size.size():
			var value = Global.dict.prey.bonus[bonus.size[_i]] * bonus.sign[_i]
			num.aspect[bonus.aspect[_i]] += value
		
		num.speed = floor(sqrt(num.aspect["mobility"])) * 100
		num.dust = {}
		num.dust.total = 100
		num.dust.current = 0


	func init_dices() -> void:
		obj.dice = {}
		obj.dice.aspect = {}
		
		for aspect in num.aspect:
			var input = {}
			input.parent = self
			input.kind = "flock"
			input.type = "aspect"
			input.title = aspect
			obj.dice.aspect[aspect] = Classes_14.Dice.new(input)


	func lead() -> void:
		obj.flock.obj.leader = self
		
		for aspect in num.aspect:
			num.aspect[aspect] = floor(num.aspect[aspect] * Global.num.size.flock.leader)


	func roll_aspect_value(aspect_: String, attempts_: int) -> int:
		var value = {}
		var values = []
		var min = num.aspect[aspect_]
		var max = 0
		value.max = num.aspect[aspect_]
		
		if attempts_ == 0:
			attempts_ = -1
		
		for _i in abs(attempts_):
			Global.rng.randomize()
			value.current = Global.rng.randi_range(0, value.max)
			values.append(value.current)
			
			if min > value.current:
				min = value.current
			
			if max < value.current:
				max = value.current
		
		if attempts_ > 0:
			return max
		
		if attempts_ < 0:
			return min
		
		return max


	func chew(throughput_: int) -> void:
		num.dust.current += throughput_
