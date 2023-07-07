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
		word.title = input_.title
		#word.stage = Global.arr.plant.stage.front()
		word.rarity = "common"
		init_dices()
		init_nums()


	func init_nums() -> void:
		num.resin = {}
		num.resin.current = 0
		num.resin.limit = Global.dict.rarity.title[word.rarity]["wood ascension"]
		
		num.accumulation = 0
		num.root = 1
		num.branch = 1
		
		for key in Global.dict.wood.accumulation:
			num.accumulation += num[key] * Global.dict.wood.accumulation[key]
		
		growth()


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
		var value = roll_ascend_value() + num.root
		#print("try to ascend " + word.rarity, [value, num.resin.limit])
		
		if value > num.resin.limit:
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
			print([word.rarity, Global.num.index.day])


	func growth() -> void:
		obj.dice.growth.roll()
		var count = obj.dice.growth.obj.edge.get_value()
		
		for _i in count:
			var key = Global.arr.growth.pick_random()
			num[key] += 1
			num.accumulation += Global.dict.wood.accumulation[key]
