extends Node


#Теплица greenhouse
class Greenhouse:
	var arr = {}
	var obj = {}


	func _init(input_: Dictionary) -> void:
		obj.sanctuary = input_.sanctuary
		arr.breed = {}
		arr.plant = {}
		arr.plant.wood = []
		arr.plant.bush = []
		arr.thicket = []
		
		for breed in Global.dict.breed.weight:
			arr.breed[breed] = []


	func init_plants() -> void:
		arr.plant = []
		var n = 1
		
		for _i in n:
			var input = {}
			input.greenhouse = self
			input.location = null
			input.kind = ""
			var plant = Classes_15.Plant.new(input)
			arr.plant.append(plant)


#Растение plnat
class Plant:
	var num = {}
	var obj = {}
	var word = {}


	func _init(input_: Dictionary) -> void:
		if input_.content == "bush":
			num.moisture = input_.moisture
			num.area = 0
		
		obj.greenhouse = input_.greenhouse
		obj.location = input_.location
		obj.spot = input_.spot
		obj.spot.set_content(input_.content)
		obj.spot.obj.plant = self
		obj.thicket = null
		
		word.title = input_.title
		word.rarity = "common"
		word.kind = input_.content
		#word.stage = Global.arr.plant.stage.front()
		init_dices()
		init_nums()
		init_thicket()


	func init_dices() -> void:
		obj.dice = {}
		
		var input = {}
		input.parent = self
		input.kind = "plant"
		input.type = "growth"
		input.title = null
		obj.dice[input.type] = Classes_14.Dice.new(input)
		
		input = {}
		input.parent = self
		input.kind = "plant"
		input.type = "ascension"
		input.title = null
		obj.dice[input.type] = Classes_14.Dice.new(input)


	func init_nums() -> void:
		init_impacts()
		num.resin = {}
		num.resin.current = 0
		var resin = word.kind + " resin"
		num.resin.limit = Global.dict.rarity.title[word.rarity][resin]
		
		num.accumulation = 0
		num.root = {}
		num.twig = {}
		
		var circumstance = obj.location.get_circumstance_influence()
		
		for key in Global.dict.wood.accumulation:
			num[key].count = 1
			num[key].accumulation = int(Global.dict.wood.accumulation[key])
			
			if circumstance != null:
				if key == circumstance.influence:
					num[key].accumulation += circumstance.accumulation
			
			num[key].accumulation *= num.impact.accumulation
			num.accumulation += num[key].count * num[key].accumulation
		
		if circumstance != null:
			if circumstance.influence == "accumulation":
				num.accumulation += circumstance.accumulation
		
		if word.kind == "wood":
			growth()


	func init_impacts() -> void:
		num.impact = {}
		num.impact.accumulation = 1.0
		num.impact.ascension = 1.0
		
		if word.kind == "wood":
			var description = Global.dict[word.kind].title[word.title]
			
			for impact in Global.arr.impact:
				for action in num.impact:
					match action:
						"accumulation":
							if description[impact].climate == obj.location.word.climate:
								num.impact[action] = Global.dict.impact[action][impact]
						"ascension":
							if description[impact].circumstance.has(obj.location.word.circumstance.title):
								num.impact[action] = Global.dict.impact[action][impact]


	func init_thicket() -> void:
		if word.kind == "bush":
			var thickets = get_neighbor_thickets()
			
			if thickets.size() == 0:
				var input = {}
				input.greenhouse = obj.greenhouse
				input.location = obj.location
				input.title = word.title
				obj.thicket = Classes_16.Thicket.new(input)
				obj.greenhouse.arr.thicket.append(obj.thicket)
				obj.thicket.add_bush(self)
			if thickets.size() == 1:
				obj.thicket = thickets.front()
				obj.thicket.add_bush(self)
			if thickets.size() > 1:
				obj.thicket = thickets.front()
				
				for thicket in thickets:
					if thicket != obj.thicket:
						obj.thicket.merge_with(thicket)


	func growth() -> void:
		obj.dice.growth.roll()
		var count = obj.dice.growth.obj.edge.get_value()
		
		for _i in count:
			match word.kind:
				"wood":
					var key = Global.arr.growth.pick_random()
					num[key].count += 1
					num.accumulation += num[key].accumulation
				"bush":
					if num.area < obj.spot.num.area:
						var fecundity = Global.dict.bush.title[word.title].fecundity
						var area = min(fecundity, obj.spot.num.area - num.area)
						num.area += area
					else:
						obj.thicket.growth()


	func accumulation_per_day() -> void:
		Global.rng.randomize()
		var accumulation = Global.rng.randi_range(0, num.accumulation)
		
		if word.kind == "bush":
			accumulation -= obj.thicket.arr.bush.size()#floor(sqrt(obj.thicket.arr.bush.size()))
		
		num.resin.current += accumulation
		
		if num.resin.current < 0:
			num.resin.current = 0
		
		if num.resin.current >= num.resin.limit:
			num.resin.current -= num.resin.limit
			
			if word.rarity != Global.dict.wood.rarity.limit:
				try_to_ascend()
			else:
				growth()


	func try_to_ascend() -> void:
		var value = roll_ascend_value() + num.root.count
		#print("try to ascend " + word.rarity, [value, num.resin.limit])
		
		if value > num.resin.limit * num.impact.ascension:
			ascend()
		else:
			growth()


	func roll_ascend_value() -> int:
		obj.dice.ascension.roll()
		var attempts = obj.dice.ascension.obj.edge.get_value()
		var values = []
		var min = num.resin.limit
		var max = 0
		var value = {}
		value.max = num.resin.limit
		
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
		
		if attempts > 0:
			return max
		
		if attempts < 0:
			return min
		
		return max


	func ascend() -> void:
		word.rarity = Global.get_rarity_ascend(word.rarity)
		var resin = word.kind + " resin"
		num.resin.limit = Global.dict.rarity.title[word.rarity][resin]
		
		if !Global.dict.wood.day.has(word.rarity):
			Global.dict.wood.day[word.rarity] = Global.num.index.day
			#print([word.rarity, Global.num.index.day])


	func reduce_accumulation(value_: int) -> void:
		num.accumulation -= value_
		
		if num.accumulation < 0:
			num.accumulation = 0

	func get_neighbor_thickets() -> Array:
		var thickets = []
		
		for neighbor in obj.spot.dict.neighbor:
			var direction = obj.spot.dict.neighbor[neighbor]
			
			if Global.dict.neighbor.linear2.has(direction) and neighbor.obj.plant != null:
				var plant = neighbor.obj.plant
				
				if plant.obj.thicket != null:
					if plant.obj.thicket.word.title == word.title and !thickets.has(plant.obj.thicket):
						thickets.append(plant.obj.thicket)
		
		return thickets


	func roll_stealth_value() -> int:
		var imperceptibility = Global.dict.bush.title[word.title].imperceptibility
		Global.rng.randomize()
		var value = Global.rng.randi_range(0, imperceptibility)
		return value


	func fade() -> void:
		obj.greenhouse.arr.plant[word.kind].erase(self)
		
		if word.kind == "bush":
			obj.thicket.arr.bush.erase(self)
			
			if obj.thicket.arr.bush.size() == 0:
				obj.thicket.fade()
		
		obj.spot.clean()


#Заросли thicket
class Thicket:
	var arr = {}
	var obj = {}
	var word = {}


	func _init(input_: Dictionary) -> void:
		arr.bush = []
		obj.greenhouse = input_.greenhouse
		obj.location = input_.location
		word.title = input_.title


	func add_bush(bush_: Plant) -> void:
		arr.bush.append(bush_)
		bush_.obj.thicket = self


	func merge_with(thicket_: Thicket) -> void:
		while thicket_.arr.bush.size() > 0:
			var bush = thicket_.arr.bush.pop_front()
			add_bush(bush)
		
		obj.greenhouse.arr.thicket.erase(thicket_)


	func growth() -> void:
		var spots = []
		
		for bush in arr.bush:
			for neighbor in bush.obj.spot.dict.neighbor:
				if neighbor.word.content == null:
					spots.append(neighbor)
		
		if spots.size() > 0:
			var spot = spots.pick_random()
			var bush = obj.location.sow_bush(spot)
			obj.location.num.humidity -= bush.num.moisture


	func fade() -> void:
		obj.greenhouse.arr.thicket.erase(self)
