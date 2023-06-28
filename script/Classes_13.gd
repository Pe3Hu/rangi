extends Node


#Цепь chain
class Chain:
	var arr = {}
	var obj = {}
	var word = {}


	func _init(input_: Dictionary) -> void:
		obj.design = input_.design
		word.type = input_.type
		init_links()


	func init_links() -> void:
		arr.link = []
		var links = Global.dict.chain.title[word.type]
		
		for type in links:
			for _i in links[type].count:
				var input = {}
				input.chain = self
				input.type = type
				input.size = links[type].size
				var link = Classes_13.Link.new(input)
				arr.link.append(link)


#Звено link
class Link:
	var num = {}
	var obj = {}
	var word = {}


	func _init(input_: Dictionary) -> void:
		num.size = input_.size
		obj.chain = input_.chain
		word.type = input_.type


#Резонатор resonator
class Resonator:
	var obj = {}


	func _init(input_: Dictionary) -> void:
		obj.design = input_.design
		obj.capsule = input_.capsule
		obj.core = input_.core
