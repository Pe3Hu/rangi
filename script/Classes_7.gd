extends Node


#сооружение edifice 
class Edifice:
	var obj = {}


	func _init(input_: Dictionary):
		obj.cluster = input_.cluster


#Схема сооружения schematic 
class Schematic:
	var obj = {}
	var dict = {}
	var word = {}


	func _init(input_: Dictionary):
		word.title = input_.title
		dict.description = input_.description
		set_contacts()


	func set_contacts() -> void:
		pass


#Отсек compartment  
class Compartment:
	var obj = {}
	var dict = {}
	var word = {}


	func _init(input_: Dictionary):
		word.type = input_.type
		obj.schematic = input_.schematic
		obj.edifice = null
		obj.sector = null
