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
		init_aspects()
		init_links()


	func init_aspects() -> void:
		num.aspect = {}
		num.indicator = {}
		num.indicator.threat = 0
		
		for aspect in Global.arr.beast.aspect:
			num.aspect[aspect] = {}
			num.indicator[aspect] = 0
		
			if Global.dict.aspect.has(aspect):
				for subaspect in Global.dict.aspect[aspect]:
					num.aspect[aspect][subaspect] = {}
					num.aspect[aspect][subaspect].base = 0
					num.aspect[aspect][subaspect].current = 0
			else:
				num.aspect[aspect][aspect] = {}
				num.aspect[aspect][aspect].base = 0
				num.aspect[aspect][aspect].current = 0
		
		get_skeleton()


	func get_skeleton() -> void:
		var description = Global.dict.skeleton.title[word.subclass]
		
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
		
		print(word.subclass, num.indicator)


	func update_aspects() -> void:
		for aspect in num.aspect:
			for subaspect in num.aspect[aspect]:
				num.aspect[aspect][subaspect].current = num.aspect[aspect][subaspect].base


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
		#print(obj.chain, word, num)
		roll_bonuses()


	func roll_bonuses() -> void:
		var values = {}
		var description = Global.dict.link.title[word.type]
		
		for aspect in Global.dict.aspect:
			var subaspect = Global.dict.aspect[aspect].pick_random()
			num.bonus[subaspect] = description[aspect]
			obj.chain.num.aspect[aspect][subaspect].base += num.bonus[subaspect]


#Резонатор resonator
class Resonator:
	var obj = {}


	func _init(input_: Dictionary) -> void:
		obj.design = input_.design
		obj.capsule = input_.capsule
		obj.core = input_.core
