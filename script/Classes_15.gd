extends Node


#Теплица greenhouse
class Greenhouse:
	var arr = {}
	var obj = {}


	func _init(input_: Dictionary) -> void:
		obj.sanctuary = input_.sanctuary
		arr.breed = {}
		arr.wood = []
		
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


#Дерево wood
class Wood:
	var num = {}
	var obj = {}
	var word = {}


	func _init(input_: Dictionary) -> void:
		obj.greenhouse = input_.greenhouse
		obj.location = input_.location
		obj.spot = input_.spot
		word.title = input_.title
		word.rarity = "common"
		#word.stage = Global.arr.plant.stage.front()
		obj.spot.set_content("wood")
		obj.spot.obj.plant = self
		init_dices()
		init_nums()


	func init_dices() -> void:
		obj.dice = {}
		
		var input = {}
		input.parent = self
		input.kind = "wood"
		input.type = "ascension"
		input.title = null
		obj.dice[input.type] = Classes_14.Dice.new(input)
		
		input = {}
		input.parent = self
		input.kind = "wood"
		input.type = "growth"
		input.title = null
		obj.dice[input.type] = Classes_14.Dice.new(input)


	func init_nums() -> void:
		init_impacts()
		num.resin = {}
		num.resin.current = 0
		num.resin.limit = Global.dict.rarity.title[word.rarity]["wood ascension"]
		
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
		
		growth()


	func init_impacts() -> void:
		num.impact = {}
		num.impact.accumulation = 1.0
		num.impact.ascension = 1.0
		var description = Global.dict.wood.title[word.title]
		
		for impact in Global.arr.impact:
			for action in num.impact:
				match action:
					"accumulation":
						if description[impact].climate == obj.location.word.climate:
							num.impact[action] = Global.dict.impact[action][impact]
					"ascension":
						if description[impact].circumstance.has(obj.location.word.circumstance.title):
							num.impact[action] = Global.dict.impact[action][impact]


	func growth() -> void:
		obj.dice.growth.roll()
		var count = obj.dice.growth.obj.edge.get_value()
		
		for _i in count:
			var key = Global.arr.growth.pick_random()
			num[key].count += 1
			num.accumulation += num[key].accumulation


	func accumulation_per_day() -> void:
		Global.rng.randomize()
		var accumulation = Global.rng.randi_range(0, num.accumulation)
		num.resin.current += accumulation
		
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
		word.rarity = Global.get_wood_ascend(word.rarity)
		num.resin.limit = Global.dict.rarity.title[word.rarity]["wood ascension"]
		
		if !Global.dict.wood.day.has(word.rarity):
			Global.dict.wood.day[word.rarity] = Global.num.index.day
			#print([word.rarity, Global.num.index.day])


	func reduce_accumulation(value_: int) -> void:
		num.accumulation -= value_
		
		if num.accumulation < 0:
			num.accumulation = 0
